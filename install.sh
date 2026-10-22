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
Uso: ./install.sh [OPÇÃO]

Opções:
  --all        Seleciona todos os módulos e itens (pede confirmação)
  --update     Seleciona todos os módulos e itens e limpa histórico
  --retry      Pré-seleciona apenas os programas que falharam
  --continue   Continua instalação pulando programas já instalados com sucesso
  --yes, -y    Dispensa a confirmação final (obrigatório em automação)
  --help       Mostra esta ajuda

Sem opções: abre o menu interativo whiptail (modo → categorias → itens).

A instalação só começa após o resumo da seleção ser confirmado. Para execução
não interativa use --all --yes; sem terminal e sem --yes o script encerra com erro.

Relatórios salvos em results/
  success.txt   — programs installed successfully
  failure.txt   — programs that failed
  report.txt    — full formatted report

Exemplos:
  ./install.sh                 # menu interativo
  ./install.sh --all           # seleciona tudo e pede confirmação
  ./install.sh --all --yes     # instala tudo sem perguntar
  ./install.sh --continue      # continua de onde parou
  ./install.sh --retry         # retenta falhas
EOF
}

SELECTION_ENABLED=true
MODE=""
ASSUME_YES=false

for arg in "$@"; do
  case "$arg" in
    --all)      MODE="all"      ;;
    --update)   MODE="update"   ;;
    --retry)    MODE="retry"    ;;
    --continue) MODE="continue" ;;
    --yes|-y)   ASSUME_YES=true ;;
    --help|-h)  show_help; exit 0 ;;
    *)
      log_error "Opção desconhecida: $arg"
      echo
      show_help
      exit 1
      ;;
  esac
done

if ! $ASSUME_YES && { [ ! -t 0 ] || [ ! -t 1 ]; }; then
  log_error "Terminal não interativo detectado."
  log_info "Use --all --yes para instalar sem nenhuma pergunta."
  exit 1
fi

FROM_MENU=false
if [ -z "$MODE" ]; then
  ensure_whiptail
  FROM_MENU=true
  MODE=$(whiptail --title "ubuntu-initial-setup" \
    --menu "Escolha o modo de instalação:" \
    15 60 3 \
    "new"       "Nova instalação (limpa histórico)" \
    "continue"  "Continuar de onde parou" \
    "retry"     "Retentar apenas falhas" \
    3>&1 1>&2 2>&3) || true
  if [ -z "$MODE" ]; then
    log_info "Cancelado."
    exit 0
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
    SELECTED_MODULES+=("$module")
    while IFS='|' read -r func name _desc; do
      [ -n "$func" ] && select_add "$(catalog_tag "$module" "$func")"
    done < <(catalog_items "$module")
  done
}

_preselect_retry() {
  local module func name _desc matched
  SELECTED_MODULES=()
  for module in "${MODULES[@]}"; do
    grep -q "^${module}:" "$RESULTS_PATH/failure.txt" || continue
    matched=false
    while IFS='|' read -r func name _desc; do
      [ -n "$func" ] || continue
      if grep -qxF "$module: $name" "$RESULTS_PATH/failure.txt"; then
        select_add "$(catalog_tag "$module" "$func")"
        matched=true
      fi
    done < <(catalog_items "$module")
    $matched && SELECTED_MODULES+=("$module")
  done
}

_select_categories() {
  local module output height
  local -a entries=()
  for module in "${MODULES[@]}"; do
    if [ "$MODE" = "retry" ] && ! grep -q "^${module}:" "$RESULTS_PATH/failure.txt"; then
      continue
    fi
    entries+=("$module" "$(catalog_module_label "$module") — $(catalog_module_desc "$module")" "ON")
  done

  height=$(( ${#MODULES[@]} + 8 ))
  [ "$height" -gt 30 ] && height=30

  output=$(whiptail --title "ubuntu-initial-setup" \
    --separate-output \
    --checklist "Selecione as categorias (espaço marca/desmarca):" \
    "$height" 78 10 \
    "${entries[@]}" \
    3>&1 1>&2 2>&3) || return 1
  printf '%s\n' "$output"
}

_select_items() {
  local module="$1"
  local func name desc state output
  local -a entries=()
  while IFS='|' read -r func name desc; do
    [ -n "$func" ] || continue
    state="ON"
    if [ "$MODE" = "retry" ] && ! grep -qxF "$module: $name" "$RESULTS_PATH/failure.txt"; then
      state="OFF"
    fi
    entries+=("$func" "$name — $desc" "$state")
  done < <(catalog_items "$module")

  local count=$(( ${#entries[@]} / 3 ))
  local height=$(( count + 8 ))
  [ "$height" -gt 30 ] && height=30
  local list_height=$count
  [ "$list_height" -gt 20 ] && list_height=20

  output=$(whiptail --title "$(catalog_module_label "$module")" \
    --separate-output \
    --checklist "Selecione os itens (espaço marca/desmarca):" \
    "$height" 78 "$list_height" \
    "${entries[@]}" \
    3>&1 1>&2 2>&3) || return 1
  printf '%s\n' "$output"
}

_select_via_menu() {
  local module category_output item_output func
  SELECTED_MODULES=()
  category_output=$(_select_categories) || return 1
  for module in $category_output; do
    item_output=$(_select_items "$module") || return 1
    [ -z "$item_output" ] && continue
    for func in $item_output; do
      select_add "$(catalog_tag "$module" "$func")"
    done
    SELECTED_MODULES+=("$module")
  done
}

if $FROM_MENU; then
  _select_via_menu || { log_info "Cancelado."; exit 0; }
else
  case "$MODE" in
    all|update|continue) _preselect_all ;;
    retry)               _preselect_retry ;;
  esac
fi

TOTAL=$(catalog_selected_total "${SELECTED_MODULES[@]}")

if [ "$TOTAL" -eq 0 ]; then
  log_info "Nenhum item selecionado. Nada a instalar."
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
log_info "Resumo da seleção:"
while IFS= read -r line; do
  [ -n "$line" ] && echo -e "  ${BOLD}•${NC} $line"
done <<< "$SUMMARY"
log_info "Total: $TOTAL item(ns) em ${#SELECTED_MODULES[@]} categoria(s)"
echo

if ! $ASSUME_YES; then
  summary_height=$(( $(printf '%s' "$SUMMARY" | grep -c .) + 10 ))
  [ "$summary_height" -gt 30 ] && summary_height=30
  if ! whiptail --title "Confirmar instalação" \
    --yesno "${SUMMARY}
Total: $TOTAL item(ns) em ${#SELECTED_MODULES[@]} categoria(s)

Iniciar a instalação?" \
    "$summary_height" 78 3>&1 1>&2 2>&3; then
    log_info "Instalação cancelada. Nada foi instalado."
    exit 0
  fi
else
  log_info "Confirmação dispensada (--yes)."
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
