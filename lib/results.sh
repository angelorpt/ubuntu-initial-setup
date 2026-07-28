RESULTS_DIR=""
RESULTS_RETRY=false
RESULTS_CONTINUE=false
_FAILED_ITEMS=""
_SKIPPED_ITEMS=""

init_results() {
  local fresh=false
  if [[ "${1:-}" == "--fresh" ]]; then
    fresh=true
    shift
  fi
  RESULTS_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.install-results}"
  mkdir -p "$RESULTS_DIR"
  if $fresh; then
    : > "$RESULTS_DIR/sucesso.txt"
    : > "$RESULTS_DIR/falha.txt"
  else
    touch "$RESULTS_DIR/sucesso.txt" "$RESULTS_DIR/falha.txt"
  fi
  log_info "Resultados salvos em $RESULTS_DIR"
}

init_retry() {
  RESULTS_RETRY=true
  if [ -f "$RESULTS_DIR/falha.txt" ]; then
    _FAILED_ITEMS=$(sed 's/^[^:]*: //' "$RESULTS_DIR/falha.txt")
  fi
}

init_continue() {
  RESULTS_CONTINUE=true
  if [ -f "$RESULTS_DIR/sucesso.txt" ]; then
    _SKIPPED_ITEMS=$(sed 's/^[^:]*: //' "$RESULTS_DIR/sucesso.txt")
  fi
}

track() {
  local category="$1"
  local func="$2"
  local name="$3"
  shift 3

  if $RESULTS_RETRY; then
    if ! echo "$_FAILED_ITEMS" | grep -q -F "$name"; then
      log_info "${name} — já instalado anteriormente (pulado)"
      update_progress "$name"
      return 0
    fi
  fi

  if $RESULTS_CONTINUE; then
    if echo "$_SKIPPED_ITEMS" | grep -q -F "$name"; then
      log_info "${name} — já instalado anteriormente (pulado)"
      update_progress "$name"
      return 0
    fi
  fi

  update_progress "$name"
  "$func" "$@"
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo "$category: $name" >> "$RESULTS_DIR/sucesso.txt"
  else
    echo "$category: $name" >> "$RESULTS_DIR/falha.txt"
  fi
  return $exit_code
}

generate_report() {
  local report="$RESULTS_DIR/relatorio.txt"

  {
    echo "╔══════════════════════════════════════╗"
    echo "║  Relatório de Instalação             ║"
    echo "║  $(date '+%Y-%m-%d %H:%M:%S')                ║"
    echo "╚══════════════════════════════════════╝"
    echo
  } > "$report"

  for cat in BASE DEV AI TOOLS_TERMINAL TOOLS_DESKTOP TOOLS_UBUNTU MEDIA FONTS CONFIG NPM_GLOBALS; do
    local items failed_items
    items=$(grep "^${cat}:" "$RESULTS_DIR/sucesso.txt" 2>/dev/null | sed "s/^${cat}: /  ✓ /")
    failed_items=$(grep "^${cat}:" "$RESULTS_DIR/falha.txt" 2>/dev/null | sed "s/^${cat}: /  ✗ /")

    if [ -n "$items" ] || [ -n "$failed_items" ]; then
      echo "[${cat}]" >> "$report"
      [ -n "$items" ] && echo "$items" >> "$report"
      [ -n "$failed_items" ] && echo "$failed_items" >> "$report"
      echo >> "$report"
    fi
  done

  local total success failed
  total=$(( $(wc -l < "$RESULTS_DIR/sucesso.txt" 2>/dev/null || echo 0) + $(wc -l < "$RESULTS_DIR/falha.txt" 2>/dev/null || echo 0) ))
  success=$(wc -l < "$RESULTS_DIR/sucesso.txt" 2>/dev/null || echo 0)
  failed=$(wc -l < "$RESULTS_DIR/falha.txt" 2>/dev/null || echo 0)

  {
    echo "Resumo:"
    echo "  Total: $total | Sucesso: $success | Falha: $failed"
    echo
    echo "Arquivos gerados em $RESULTS_DIR:"
    echo "  sucesso.txt   — programas instalados com sucesso"
    echo "  falha.txt     — programas que falharam"
    echo "  relatorio.txt — este relatório completo"
    echo
    if [ "$failed" -gt 0 ]; then
      echo "Para tentar novamente apenas as falhas:"
      echo "  ./install.sh --retry"
    fi
  } >> "$report"

  echo
  log_success "Instalação concluída!"
  echo
  cat "$report"
}
