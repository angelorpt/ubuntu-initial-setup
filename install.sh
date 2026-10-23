#!/bin/bash
set -uo pipefail

cd "$(dirname "$0")" || exit 1

source lib/colors.sh
source lib/log.sh
source lib/utils.sh
source lib/selection.sh
source lib/catalog.sh
source lib/results.sh
source lib/progress.sh

RESULTS_PATH="$(pwd)/results"

show_help() {
  cat << EOF
Usage / Uso: ./install.sh [OPTION]

Options / Opções:
  --lang=LANG           Set UI language: "en" (default) or "pt"
  --all                 Select all modules and items (requests confirmation)
  --headless, --wsl     Activate Headless / WSL profile (CLI / terminal only)
  --desktop             Activate Standard Desktop profile (default in desktop)
  --profile=TYPE        Set environment profile: "desktop" or "headless" (wsl)
  --update              Select all modules/items and clean history
  --retry               Preselect only previously failed items
  --continue            Continue install skipping already successful items
  --yes, -y             Bypass final confirmation (mandatory in automation)
  --help, -h            Show this help

Interactive whiptail menu without options: language → environment → mode → categories → items.

Examples:
  ./install.sh                 # interactive menu
  ./install.sh --lang=en       # interactive menu in English
  ./install.sh --lang=pt       # interactive menu in Portuguese
  ./install.sh --headless      # CLI/WSL profile
  ./install.sh --all --yes     # unattended full install
  ./install.sh --retry         # retry failures
EOF
}

is_wsl() {
  if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ] || [ -d /run/WSL ] || grep -qi microsoft /proc/version 2>/dev/null; then
    return 0
  fi
  return 1
}

SELECTION_ENABLED=true
MODE=""
PROFILE=""
ASSUME_YES=false
CLI_LANG=""

for arg in "$@"; do
  case "$arg" in
    --all)             MODE="all"      ;;
    --update)          MODE="update"   ;;
    --retry)           MODE="retry"    ;;
    --continue)        MODE="continue" ;;
    --headless|--wsl)  PROFILE="headless" ;;
    --desktop)         PROFILE="desktop"  ;;
    --profile=headless|--profile=wsl) PROFILE="headless" ;;
    --profile=desktop) PROFILE="desktop"  ;;
    --lang=en|--en)    CLI_LANG="en"   ;;
    --lang=pt|--lang=pt-br|--lang=pt_BR|--pt) CLI_LANG="pt" ;;
    --yes|-y)          ASSUME_YES=true ;;
    --help|-h)         show_help; exit 0 ;;
    *)
      log_error "Opção desconhecida / Unknown option: $arg"
      echo
      show_help
      exit 1
      ;;
  esac
done

if [ -n "$CLI_LANG" ]; then
  APP_LANG="$CLI_LANG"
fi

if ! $ASSUME_YES && { [ ! -t 0 ] || [ ! -t 1 ]; }; then
  log_error "Non-interactive terminal detected / Terminal não interativo detectado."
  log_info "Use --all --yes to install without prompts."
  exit 1
fi

FROM_MENU=false
if [ -z "$MODE" ]; then
  ensure_whiptail
  FROM_MENU=true

  if [ -z "$CLI_LANG" ]; then
    chosen_lang=$(whiptail --title "ubuntu-initial-setup — Language / Idioma" \
      --radiolist "Choose language / Escolha o idioma:" \
      15 65 2 \
      "en" "English (Default)" "ON" \
      "pt" "Português (Brasil)" "OFF" \
      3>&1 1>&2 2>&3) || true
    if [ -z "$chosen_lang" ]; then
      log_info "Cancelled / Cancelado."
      exit 0
    fi
    APP_LANG="$chosen_lang"
  fi

  is_pt=false
  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    is_pt=true
  fi

  if [ -z "$PROFILE" ]; then
    default_profile="desktop"
    if is_wsl; then
      default_profile="headless"
    fi
    desktop_state="OFF"
    headless_state="OFF"
    if [ "$default_profile" = "desktop" ]; then
      desktop_state="ON"
    else
      headless_state="ON"
    fi

    env_title="ubuntu-initial-setup — Target Environment"
    env_prompt="Select target environment:"
    env_desktop="Standard Ubuntu (Desktop + GUI + CLI)"
    env_headless="Headless / WSL (Terminal & CLI only)"
    if $is_pt; then
      env_title="ubuntu-initial-setup — Ambiente"
      env_prompt="Escolha o ambiente de instalação:"
      env_desktop="Standard Ubuntu (Desktop + GUI + CLI)"
      env_headless="Headless / WSL (Terminal & CLI apenas)"
    fi

    PROFILE=$(whiptail --title "$env_title" \
      --radiolist "$env_prompt" \
      15 70 2 \
      "desktop"  "$env_desktop" "$desktop_state" \
      "headless" "$env_headless" "$headless_state" \
      3>&1 1>&2 2>&3) || true
    if [ -z "$PROFILE" ]; then
      log_info "$($is_pt && echo "Cancelado." || echo "Cancelled.")"
      exit 0
    fi
  fi

  mode_title="ubuntu-initial-setup — Mode"
  mode_prompt="Choose installation mode:"
  mode_new="Fresh install (clear history)"
  mode_continue="Continue from last run"
  mode_retry="Retry failed items only"
  if $is_pt; then
    mode_title="ubuntu-initial-setup — Modo"
    mode_prompt="Escolha o modo de instalação:"
    mode_new="Nova instalação (limpa histórico)"
    mode_continue="Continuar de onde parou"
    mode_retry="Retentar apenas falhas"
  fi

  MODE=$(whiptail --title "$mode_title" \
    --menu "$mode_prompt" \
    15 60 3 \
    "new"       "$mode_new" \
    "continue"  "$mode_continue" \
    "retry"     "$mode_retry" \
    3>&1 1>&2 2>&3) || true
  if [ -z "$MODE" ]; then
    log_info "$($is_pt && echo "Cancelado." || echo "Cancelled.")"
    exit 0
  fi
fi

if [ -z "$PROFILE" ]; then
  if is_wsl; then
    PROFILE="headless"
  else
    PROFILE="desktop"
  fi
fi

if [ "$MODE" = "retry" ] && [ ! -s "$RESULTS_PATH/failure.txt" ]; then
  log_info "Nenhuma falha anterior encontrada em $RESULTS_PATH/failure.txt"
  exit 0
fi

declare -a SELECTED_MODULES=()
select_clear

_preselect_all() {
  local module func name _desc
  SELECTED_MODULES=()
  for module in "${MODULES[@]}"; do
    if [ "$PROFILE" = "headless" ] && catalog_module_is_gui "$module"; then
      continue
    fi
    SELECTED_MODULES+=("$module")
    while IFS='|' read -r func name _desc; do
      [ -n "$func" ] || continue
      if [ "$PROFILE" = "headless" ] && catalog_item_is_gui "$module" "$func"; then
        continue
      fi
      select_add "$(catalog_tag "$module" "$func")"
    done < <(catalog_items "$module")
  done
}

_preselect_retry() {
  local module func name _desc matched
  SELECTED_MODULES=()
  for module in "${MODULES[@]}"; do
    if [ "$PROFILE" = "headless" ] && catalog_module_is_gui "$module"; then
      continue
    fi
    grep -q "^${module}:" "$RESULTS_PATH/failure.txt" || continue
    matched=false
    while IFS='|' read -r func name _desc; do
      [ -n "$func" ] || continue
      if [ "$PROFILE" = "headless" ] && catalog_item_is_gui "$module" "$func"; then
        continue
      fi
      if grep -qxF "$module: $name" "$RESULTS_PATH/failure.txt"; then
        select_add "$(catalog_tag "$module" "$func")"
        matched=true
      fi
    done < <(catalog_items "$module")
    $matched && SELECTED_MODULES+=("$module")
  done
}

_dialog_width() {
  local cols
  cols=$(tput cols 2>/dev/null || echo 80)
  if [ "$cols" -gt 104 ]; then
    printf '%s\n' "98"
  elif [ "$cols" -gt 88 ]; then
    printf '%s\n' "$(( cols - 6 ))"
  else
    printf '%s\n' "$cols"
  fi
}

_select_categories() {
  local module output height width
  local -a entries=()
  for module in "${MODULES[@]}"; do
    if [ "$PROFILE" = "headless" ] && catalog_module_is_gui "$module"; then
      continue
    fi
    if [ "$MODE" = "retry" ] && ! grep -q "^${module}:" "$RESULTS_PATH/failure.txt"; then
      continue
    fi
    entries+=("$module" "$(catalog_module_label "$module") — $(catalog_module_desc "$module")" "OFF")
  done

  height=$(( ${#MODULES[@]} + 8 ))
  [ "$height" -gt 30 ] && height=30
  width=$(_dialog_width)

  local cat_prompt="Select categories (Space to toggle):"
  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    cat_prompt="Selecione as categorias (espaço marca/desmarca):"
  fi

  output=$(whiptail --title "ubuntu-initial-setup" \
    --separate-output \
    --checklist "$cat_prompt" \
    "$height" "$width" 10 \
    "${entries[@]}" \
    3>&1 1>&2 2>&3) || return 1
  printf '%s\n' "$output"
}

_select_items() {
  local module="$1"
  local func name desc state output width
  local -a entries=()

  local all_label="[★ SELECT ALL / MARCAR TODOS]"
  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    all_label="[★ MARCAR TODOS OS ITENS DESTA CATEGORIA]"
  else
    all_label="[★ SELECT ALL ITEMS IN THIS CATEGORY]"
  fi
  entries+=("__ALL__" "$all_label" "OFF")

  while IFS='|' read -r func name desc; do
    [ -n "$func" ] || continue
    if [ "$PROFILE" = "headless" ] && catalog_item_is_gui "$module" "$func"; then
      continue
    fi
    state="OFF"
    entries+=("$func" "$name — $desc" "$state")
  done < <(catalog_items "$module")

  local count=$(( ${#entries[@]} / 3 ))
  if [ "$count" -le 1 ]; then
    return 0
  fi
  local height=$(( count + 8 ))
  [ "$height" -gt 30 ] && height=30
  local list_height=$count
  [ "$list_height" -gt 20 ] && list_height=20
  width=$(_dialog_width)

  local item_prompt="Select items (Space to toggle) or Cancel to go back:"
  local cancel_text="Back"
  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    item_prompt="Selecione os itens (espaço marca/desmarca) ou Cancelar para voltar:"
    cancel_text="Voltar"
  fi

  output=$(whiptail --title "$(catalog_module_label "$module")" \
    --cancel-button "$cancel_text" \
    --separate-output \
    --checklist "$item_prompt" \
    "$height" "$width" "$list_height" \
    "${entries[@]}" \
    3>&1 1>&2 2>&3) || return 2
  printf '%s\n' "$output"
}

_select_via_menu() {
  local module category_output item_output func action ret
  local batch_prompt batch_all batch_custom batch_skip width
  width=$(_dialog_width)

  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    batch_prompt="Como deseja selecionar os itens desta categoria?"
    batch_all="Marcar todos os itens desta categoria"
    batch_custom="Escolher programas item a item"
    batch_skip="Desconsiderar categoria"
  else
    batch_prompt="How would you like to select items in this category?"
    batch_all="Select all items in this category"
    batch_custom="Choose items individually"
    batch_skip="Skip this category"
  fi

  SELECTED_MODULES=()
  category_output=$(_select_categories) || return 1
  for module in $category_output; do
    while true; do
      action=$(whiptail --title "$(catalog_module_label "$module")" \
        --menu "$batch_prompt" \
        15 "$width" 3 \
        "all"    "$batch_all" \
        "custom" "$batch_custom" \
        "skip"   "$batch_skip" \
        3>&1 1>&2 2>&3) || return 1

      case "$action" in
        all)
          while IFS='|' read -r func name desc; do
            [ -n "$func" ] || continue
            if [ "$PROFILE" = "headless" ] && catalog_item_is_gui "$module" "$func"; then
              continue
            fi
            select_add "$(catalog_tag "$module" "$func")"
          done < <(catalog_items "$module")
          SELECTED_MODULES+=("$module")
          break
          ;;
        custom)
          item_output=$(_select_items "$module")
          ret=$?
          if [ "$ret" -eq 2 ]; then
            # User clicked Back / Voltar, loop to show category menu again
            continue
          elif [ "$ret" -ne 0 ]; then
            return 1
          fi

          if [ -n "$item_output" ]; then
            if grep -qxF "__ALL__" <<< "$item_output"; then
              while IFS='|' read -r func name desc; do
                [ -n "$func" ] || continue
                if [ "$PROFILE" = "headless" ] && catalog_item_is_gui "$module" "$func"; then
                  continue
                fi
                select_add "$(catalog_tag "$module" "$func")"
              done < <(catalog_items "$module")
            else
              for func in $item_output; do
                select_add "$(catalog_tag "$module" "$func")"
              done
            fi
            SELECTED_MODULES+=("$module")
          fi
          break
          ;;
        skip)
          break
          ;;
      esac
    done
  done
}

if $FROM_MENU; then
  _select_via_menu || { log_info "$([ "$APP_LANG" = "pt" ] && echo "Cancelado." || echo "Cancelled.")"; exit 0; }
else
  case "$MODE" in
    all|update|continue) _preselect_all ;;
    retry)               _preselect_retry ;;
  esac
fi

TOTAL=$(catalog_selected_total "${SELECTED_MODULES[@]}")

if [ "$TOTAL" -eq 0 ]; then
  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    log_info "Nenhum item selecionado. Nada a instalar."
  else
    log_info "No items selected. Nothing to install."
  fi
  exit 0
fi

SUMMARY=""
for module in "${SELECTED_MODULES[@]}"; do
  names=()
  while IFS='|' read -r func name _desc; do
    select_has "$(catalog_tag "$module" "$func")" && names+=("$name")
  done < <(catalog_items "$module")
  SUMMARY+="${module} (${#names[@]}): ${names[*]}"$'\n'
done

echo
if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
  log_info "Resumo da seleção:"
else
  log_info "Selection summary:"
fi

while IFS= read -r line; do
  [ -n "$line" ] && echo -e "  ${BOLD}•${NC} $line"
done <<< "$SUMMARY"

if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
  log_info "Total: $TOTAL item(ns) em ${#SELECTED_MODULES[@]} categoria(s)"
else
  log_info "Total: $TOTAL item(s) across ${#SELECTED_MODULES[@]} category(ies)"
fi
echo

if ! $ASSUME_YES; then
  summary_height=$(( $(printf '%s' "$SUMMARY" | grep -c .) + 10 ))
  [ "$summary_height" -gt 30 ] && summary_height=30

  confirm_title="Confirm installation"
  confirm_prompt="Total: $TOTAL item(s) across ${#SELECTED_MODULES[@]} category(ies)

Start installation?"
  cancel_msg="Installation cancelled. Nothing was installed."

  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    confirm_title="Confirmar instalação"
    confirm_prompt="Total: $TOTAL item(ns) em ${#SELECTED_MODULES[@]} categoria(s)

Iniciar a instalação?"
    cancel_msg="Instalação cancelada. Nada foi instalado."
  fi

  width=$(_dialog_width)
  if ! whiptail --title "$confirm_title" \
    --yesno "${SUMMARY}
${confirm_prompt}" \
    "$summary_height" "$width" 3>&1 1>&2 2>&3; then
    log_info "$cancel_msg"
    exit 0
  fi
else
  if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
    log_info "Confirmação dispensada (--yes)."
  else
    log_info "Confirmation bypassed (--yes)."
  fi
fi

case "$MODE" in
  new|all|update) init_results --fresh "$RESULTS_PATH" ;;
  *)              init_results "$RESULTS_PATH" ;;
esac

case "$MODE" in
  retry)    init_retry ;;
  continue) init_continue ;;
esac

log_info "Iniciando instalação de $TOTAL item(ns)..."

for choice in "${SELECTED_MODULES[@]}"; do
  case $choice in
    BASE)            source install/base.sh            ;;
    DEV)             source install/dev.sh             ;;
    AI)              source install/ai.sh              ;;
    TOOLS_TERMINAL)  source install/tools_terminal.sh  ;;
    TOOLS_DESKTOP)   source install/tools_desktop.sh   ;;
    TOOLS_UBUNTU)    source install/tools_ubuntu.sh    ;;
    MEDIA)           source install/media.sh           ;;
    FONTS)           source install/fonts.sh           ;;
    CONFIG)          source install/config.sh          ;;
    NPM_GLOBALS)     source install/npm-globals.sh     ;;
  esac
done

init_progress "$TOTAL"

for choice in "${SELECTED_MODULES[@]}"; do
  case $choice in
    BASE)            run_base            ;;
    DEV)             run_dev             ;;
    AI)              run_ai              ;;
    TOOLS_TERMINAL)  run_tools_terminal  ;;
    TOOLS_DESKTOP)   run_tools_desktop   ;;
    TOOLS_UBUNTU)    run_tools_ubuntu    ;;
    MEDIA)           run_media           ;;
    FONTS)           run_fonts           ;;
    CONFIG)          run_config          ;;
    NPM_GLOBALS)     run_npm_globals     ;;
  esac
done

end_progress
generate_report
