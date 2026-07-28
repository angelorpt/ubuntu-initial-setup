#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

source lib/colors.sh
source lib/log.sh
source lib/utils.sh

ensure_whiptail

MODULES=(
  "BASE"      "Utilitários essenciais (curl, git, zsh)" ON
  "DEV"       "Ferramentas de desenvolvimento" ON
  "AI"        "Inteligência Artificial (ollama, opencode)" ON
  "TOOLS"     "Utilitários de desktop (flameshot, espanso)" ON
  "MEDIA"     "Aplicativos de mídia (Chrome, Telegram)" ON
  "FONTS"     "Fontes para programação (Fira Code)" ON
  "CONFIG"    "Configuração Git, SSH e terminal" ON
)

if [ "${1:-}" = "--all" ]; then
  CHOICES="BASE DEV AI TOOLS MEDIA FONTS CONFIG"
else
  CHOICES=$(whiptail --title "ubuntu-initial-setup" \
    --checklist "Selecione os módulos para instalar (espaço para marcar/desmarcar):" \
    20 72 7 \
    "${MODULES[@]}" \
    3>&1 1>&2 2>&3)
  [ -z "$CHOICES" ] && log_info "Nenhum módulo selecionado. Saindo." && exit 0
fi

log_info "Iniciando instalação dos módulos selecionados..."

for choice in $CHOICES; do
  case $choice in
    BASE)   source install/base.sh   && run_base ;;
    DEV)    source install/dev.sh    && run_dev ;;
    AI)     source install/ai.sh     && run_ai ;;
    TOOLS)  source install/tools.sh  && run_tools ;;
    MEDIA)  source install/media.sh  && run_media ;;
    FONTS)  source install/fonts.sh  && run_fonts ;;
    CONFIG) source install/config.sh && run_config ;;
  esac
done

echo
log_success "Instalação concluída!"
