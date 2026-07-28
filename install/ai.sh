install_ollama() {
  print_header "Ollama" "Plataforma local para execução de modelos de linguagem"
  curl -fsSL https://ollama.com/install.sh | sh
  log_success "Ollama instalado"
}

install_opencode() {
  print_header "OpenCode" "Assistente de engenharia de software no terminal"
  curl -fsSL https://opencode.ai/install.sh | bash
  log_success "OpenCode instalado"
}

install_serena() {
  # https://github.com/oraios/serena - uv tool install -p 3.13 serena-agent
  print_header "Serena" "MCP toolkit semântico para agentes de código — https://github.com/oraios/serena"
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
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
  log_success "Hermes Agent instalado"
}

install_antigravity_cli() {
  # https://antigravity.google/download#antigravity-cli
  print_header "Antigravity CLI" "CLI para desenvolvimento agente-first do Google — https://antigravity.google"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
  log_success "Antigravity CLI instalado"
}

run_ai() {
  install_ollama
  install_opencode
  install_serena
  install_hermes
  install_antigravity_cli
}
