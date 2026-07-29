install_ollama() {
  # https://ollama.com/
  print_header "Ollama" "Plataforma local para execução de modelos de linguagem"
  print_details "https://ollama.com" \
    "Roda LLMs (Llama, Mistral, Gemma, Phi) localmente sem nuvem" \
    "API REST compatível com OpenAI, pull de modelos do hub" \
    "Uso: ollama pull llama3, ollama run llama3"
  curl -fsSL https://ollama.com/install.sh | sh
  log_success "Ollama instalado"
}

install_opencode() {
  # https://opencode.ai/
  print_header "OpenCode" "Assistente de engenharia de software no terminal"
  print_details "https://opencode.ai" \
    "Agente de codificação que entende seu repositório inteiro" \
    "Edita arquivos, executa comandos, gerencia git e deploys" \
    "Uso: opencode -p 'refatore esta função'"
  curl -fsSL https://opencode.ai/install | bash
  log_success "OpenCode instalado"
}

install_serena() {
  # https://github.com/oraios/serena
  print_header "Serena" "MCP toolkit semântico para agentes de código"
  print_details "https://github.com/oraios/serena" \
    "Toolkit semântico que permite agentes entenderem seu repositório" \
    "Suporte a MCP (Model Context Protocol), init interativo" \
    "Uso: serena init (primeira execução)"
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

install_antigravity_cli() {
  # https://antigravity.google/download#antigravity-cli
  print_header "Antigravity CLI" "CLI para desenvolvimento agente-first do Google"
  print_details "https://antigravity.google" \
    "Interface de linha de comando para o ecossistema Antigravity" \
    "Gerencia projetos, agentes e deploys diretamente do terminal" \
    "Uso: antigravity init, antigravity deploy"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
  log_success "Antigravity CLI instalado"
}

install_claude_code() {
  # https://code.claude.com/docs/en/quickstart
  print_header "Claude Code" "Assistente de codificação IA da Anthropic"
  print_details "https://code.claude.com" \
    "Agente de codificação que entende contexto completo do projeto" \
    "Edita arquivos, executa comandos, gerencia git" \
    "Uso: claude code -p 'adicione testes'"
  curl -fsSL https://claude.ai/install.sh | bash
  log_success "Claude Code instalado"
}

install_github_copilot_cli() {
  # https://github.com/features/copilot/cli?locale=pt-br
  print_header "GitHub Copilot CLI" "Assistente de linha de comando com IA do GitHub"
  print_details "https://github.com/features/copilot/cli" \
    "Autocomplete e sugestões de comandos no terminal" \
    "Explica comandos, sugere opções baseado no contexto" \
    "Uso: copilot what-the-shell, copilot explain, copilot suggest"
  curl -fsSL https://gh.io/copilot-install | bash
  log_success "GitHub Copilot CLI instalado"
}

_run_ai_total=6

run_ai() {
  init_module_progress $_run_ai_total "AI"
  track "AI" install_ollama "Ollama"
  track "AI" install_opencode "OpenCode"
  track "AI" install_serena "Serena"
  track "AI" install_antigravity_cli "Antigravity CLI"
  track "AI" install_claude_code "Claude Code"
  track "AI" install_github_copilot_cli "GitHub Copilot CLI"
  end_module_progress
}
