#!/bin/bash
set -uo pipefail

cd "$(dirname "$0")"

source lib/colors.sh
source lib/log.sh
source lib/utils.sh
source lib/results.sh
source lib/progress.sh

show_help() {
  cat << EOF
Uso: ./install.sh [OPÇÃO]

Opções:
  --all        Instala todos os módulos (não interativo, limpa histórico)
  --update     Atualiza todos os programas instalados (limpa histórico)
  --retry      Tenta novamente apenas os programas que falharam
  --continue   Continua instalação pulando programas já instalados com sucesso
  --help       Mostra esta ajuda

Sem opções: abre o menu interativo whiptail.

Relatórios salvos em .install-results/
  sucesso.txt   — programas instalados com sucesso
  falha.txt     — programas que falharam
  relatorio.txt — relatório completo formatado

Exemplos:
  ./install.sh              # menu interativo
  ./install.sh --all        # instala tudo (do zero)
  ./install.sh --continue   # continua de onde parou
  ./install.sh --retry      # retenta falhas
EOF
}

MODE="install"

case "${1:-}" in
  --all)
    CHOICES="BASE DEV AI TOOLS_TERMINAL TOOLS_DESKTOP TOOLS_UBUNTU MEDIA FONTS CONFIG NPM_GLOBALS"
    init_results --fresh
    log_info "Modo automático: instalando todos os módulos..."
    ;;
  --update)
    CHOICES="BASE DEV AI TOOLS_TERMINAL TOOLS_DESKTOP TOOLS_UBUNTU MEDIA FONTS CONFIG NPM_GLOBALS"
    init_results --fresh
    log_info "Modo update: reinstalando todos os programas..."
    ;;
  --retry)
    init_results
    init_retry
    local retry_falha="$RESULTS_DIR/falha.txt"
    if [ ! -s "$retry_falha" ]; then
      log_info "Nenhuma falha anterior encontrada em $retry_falha"
      exit 0
    fi
    CHOICES=$(sed 's/:.*//' "$retry_falha" | sort -u | tr '\n' ' ')
    log_info "Modo retry: tentando novamente apenas os programas que falharam..."
    ;;
  --continue)
    init_results
    init_continue
    log_info "Modo continue: pulando programas já instalados com sucesso..."
    ;;
  --help|-h)
    show_help
    exit 0
    ;;
  *)
    ensure_whiptail
    MODE=$(whiptail --title "ubuntu-initial-setup" \
      --menu "Escolha o modo de instalação:" \
      15 60 3 \
      "new"       "Nova instalação (limpa histórico)" \
      "continue"  "Continuar de onde parou" \
      "retry"     "Retentar apenas falhas" \
      3>&1 1>&2 2>&3)
    [ -z "$MODE" ] && log_info "Cancelado." && exit 0

    case $MODE in
      new)
        init_results --fresh
        ;;
      continue)
        init_results
        init_continue
        ;;
      retry)
        init_results
        init_retry
        local retry_falha="$RESULTS_DIR/falha.txt"
        if [ ! -s "$retry_falha" ]; then
          log_info "Nenhuma falha anterior encontrada."
          exit 0
        fi
        CHOICES=$(sed 's/:.*//' "$retry_falha" | sort -u | tr '\n' ' ')
        ;;
    esac

    if [ "$MODE" != "retry" ]; then
      MODULES=(
        "BASE"           "Utilitários essenciais (curl, git, zsh)" ON
        "DEV"            "Ferramentas de desenvolvimento" ON
        "AI"             "Inteligência Artificial (ollama, opencode)" ON
        "TOOLS_TERMINAL" "Ferramentas de terminal (htop, tmux, fzf, vim)" ON
        "TOOLS_DESKTOP"  "Aplicativos gráficos (Flameshot, DBeaver, Stacer)" ON
        "TOOLS_UBUNTU"   "Manutenção do sistema (Nala, UFW, fastfetch)" ON
        "MEDIA"          "Navegadores (Chrome, Brave)" ON
        "FONTS"          "Fontes para programação (Fira Code)" ON
        "CONFIG"         "Configuração Git, SSH e terminal" ON
        "NPM_GLOBALS"    "Pacotes npm globais (Nest.js, Vue, OpenSpec)" ON
      )
      CHOICES=$(whiptail --title "ubuntu-initial-setup" \
        --checklist "Selecione os módulos para instalar (espaço para marcar/desmarcar):" \
        24 76 10 \
        "${MODULES[@]}" \
        3>&1 1>&2 2>&3)
      CHOICES=$(echo "$CHOICES" | tr -d '"')
      [ -z "$CHOICES" ] && log_info "Nenhum módulo selecionado. Saindo." && exit 0
    fi
    ;;
esac

log_info "Iniciando instalação dos módulos selecionados..."

for choice in $CHOICES; do
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

TOTAL=0
for choice in $CHOICES; do
  case $choice in
    BASE)            TOTAL=$((TOTAL + _run_base_total))            ;;
    DEV)             TOTAL=$((TOTAL + _run_dev_total))             ;;
    AI)              TOTAL=$((TOTAL + _run_ai_total))              ;;
    TOOLS_TERMINAL)  TOTAL=$((TOTAL + _run_tools_terminal_total))  ;;
    TOOLS_DESKTOP)   TOTAL=$((TOTAL + _run_tools_desktop_total))   ;;
    TOOLS_UBUNTU)    TOTAL=$((TOTAL + _run_tools_ubuntu_total))    ;;
    MEDIA)           TOTAL=$((TOTAL + _run_media_total))           ;;
    FONTS)           TOTAL=$((TOTAL + _run_fonts_total))           ;;
    CONFIG)          TOTAL=$((TOTAL + _run_config_total))          ;;
    NPM_GLOBALS)     TOTAL=$((TOTAL + _run_npm_globals_total))     ;;
  esac
done

init_progress $TOTAL

for choice in $CHOICES; do
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
