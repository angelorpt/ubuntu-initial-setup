install_ollama() {
  # https://ollama.com/
  print_header "Ollama" "Plataforma local para execução de modelos de linguagem"
  log_info "↪ https://ollama.com/"
  curl -fsSL https://ollama.com/install.sh | sh
  log_success "Ollama instalado"
}

install_opencode() {
  # https://opencode.ai/
  print_header "OpenCode" "Assistente de engenharia de software no terminal"
  log_info "↪ https://opencode.ai/"
  curl -fsSL https://opencode.ai/install.sh | bash
  log_success "OpenCode instalado"
}

install_serena() {
  # https://github.com/oraios/serena
  print_header "Serena" "MCP toolkit semântico para agentes de código — https://github.com/oraios/serena"
  log_info "↪ https://github.com/oraios/serena"
  if ! command -v uv &>/dev/null; then
    log_info "Instalando uv (gerenciador de projetos Python)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.local/bin/env" 2>/dev/null || true
  fi
  log_info "Instalando Serena via uv..."
  uv tool install -p 3.13 serena-agent
  serena init
  log_success "Serena instalado e inicializado"
}

install_hermes() {
  # https://hermes-agent.nousresearch.com/docs/
  print_header "Hermes Agent" "Agente de IA auto-melhorável da Nous Research — https://hermes-agent.nousresearch.com"
  log_info "↪ https://hermes-agent.nousresearch.com/docs/"
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
  log_success "Hermes Agent instalado"
}

install_antigravity_cli() {
  # https://antigravity.google/download#antigravity-cli
  print_header "Antigravity CLI" "CLI para desenvolvimento agente-first do Google — https://antigravity.google"
  log_info "↪ https://antigravity.google/download#antigravity-cli"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
  log_success "Antigravity CLI instalado"
}

_run_ai_total=5

run_ai() {
  init_module_progress $_run_ai_total "AI"
  track "AI" install_ollama "Ollama"
  track "AI" install_opencode "OpenCode"
  track "AI" install_serena "Serena"
  track "AI" install_hermes "Hermes Agent"
  track "AI" install_antigravity_cli "Antigravity CLI"
  end_module_progress
}
