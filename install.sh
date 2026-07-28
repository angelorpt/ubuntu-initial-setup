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
  --all       Instala todos os módulos (não interativo)
  --update    Atualiza todos os programas instalados
  --retry     Tenta novamente apenas os programas que falharam
  --help      Mostra esta ajuda

Sem opções: abre o menu interativo whiptail para selecionar módulos.

Relatórios salvos em .install-results/
  sucesso.txt   — programas instalados com sucesso
  falha.txt     — programas que falharam
  relatorio.txt — relatório completo formatado

Exemplos:
  ./install.sh              # menu interativo
  ./install.sh --all        # instala tudo
  ./install.sh --retry      # retenta falhas
EOF
}

MODE="install"

case "${1:-}" in
  --all)
    CHOICES="BASE DEV AI TOOLS MEDIA FONTS CONFIG NPM_GLOBALS"
    init_results
    log_info "Modo automático: instalando todos os módulos..."
    ;;
  --update)
    CHOICES="BASE DEV AI TOOLS MEDIA FONTS CONFIG NPM_GLOBALS"
    init_results
    log_info "Modo update: reinstalando todos os programas..."
    ;;
  --retry)
    init_results
    if [ ! -s "$RESULTS_DIR/falha.txt" ]; then
      log_info "Nenhuma falha anterior encontrada em $RESULTS_DIR/falha.txt"
      exit 0
    fi
    CHOICES=$(sed 's/:.*//' "$RESULTS_DIR/falha.txt" | sort -u | tr '\n' ' ')
    init_retry
    log_info "Modo retry: tentando novamente apenas os programas que falharam..."
    ;;
  --help|-h)
    show_help
    exit 0
    ;;
  *)
    ensure_whiptail
    MODULES=(
      "BASE"      "Utilitários essenciais (curl, git, zsh)" ON
      "DEV"       "Ferramentas de desenvolvimento" ON
      "AI"        "Inteligência Artificial (ollama, opencode)" ON
      "TOOLS"     "Utilitários de desktop (flameshot, espanso)" ON
      "MEDIA"      "Aplicativos de mídia (Chrome)" ON
      "FONTS"      "Fontes para programação (Fira Code)" ON
      "CONFIG"     "Configuração Git, SSH e terminal" ON
      "NPM_GLOBALS" "Pacotes npm globais (Nest.js, Vue, OpenSpec)" ON
    )
    CHOICES=$(whiptail --title "ubuntu-initial-setup" \
      --checklist "Selecione os módulos para instalar (espaço para marcar/desmarcar):" \
      22 72 8 \
      "${MODULES[@]}" \
      3>&1 1>&2 2>&3)
    [ -z "$CHOICES" ] && log_info "Nenhum módulo selecionado. Saindo." && exit 0
    init_results
    ;;
esac

log_info "Iniciando instalação dos módulos selecionados..."

for choice in $CHOICES; do
  case $choice in
    BASE)   source install/base.sh   ;;
    DEV)    source install/dev.sh    ;;
    AI)     source install/ai.sh     ;;
    TOOLS)  source install/tools.sh  ;;
    MEDIA)  source install/media.sh  ;;
    FONTS)  source install/fonts.sh  ;;
    CONFIG) source install/config.sh ;;
    NPM_GLOBALS) source install/npm-globals.sh ;;
  esac
done

TOTAL=0
for choice in $CHOICES; do
  case $choice in
    BASE)   TOTAL=$((TOTAL + _run_base_total))   ;;
    DEV)    TOTAL=$((TOTAL + _run_dev_total))    ;;
    AI)     TOTAL=$((TOTAL + _run_ai_total))     ;;
    TOOLS)  TOTAL=$((TOTAL + _run_tools_total))  ;;
    MEDIA)  TOTAL=$((TOTAL + _run_media_total))  ;;
    FONTS)  TOTAL=$((TOTAL + _run_fonts_total))  ;;
    CONFIG) TOTAL=$((TOTAL + _run_config_total)) ;;
    NPM_GLOBALS) TOTAL=$((TOTAL + _run_npm_globals_total)) ;;
  esac
done

init_progress $TOTAL

for choice in $CHOICES; do
  case $choice in
    BASE)   run_base   ;;
    DEV)    run_dev    ;;
    AI)     run_ai     ;;
    TOOLS)  run_tools  ;;
    MEDIA)  run_media  ;;
    FONTS)  run_fonts  ;;
    CONFIG) run_config ;;
    NPM_GLOBALS) run_npm_globals ;;
  esac
done

end_progress
generate_report
