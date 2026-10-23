#!/bin/bash
# lib/catalog.sh — catálogo único de módulos e itens instaláveis.
# Cada item segue o formato: "funcao|Nome de exibição|descrição curta".
# A ordem dos arrays é a ordem de instalação.

if ! declare -F select_has >/dev/null 2>&1; then
  # shellcheck source=lib/selection.sh
  source "$(dirname "${BASH_SOURCE[0]}")/selection.sh"
fi

MODULES=(BASE DEV AI TOOLS_TERMINAL TOOLS_DESKTOP TOOLS_UBUNTU MEDIA FONTS CONFIG NPM_GLOBALS)

_ITEMS_BASE=(
  "install_curl|Curl|Cliente HTTP/HTTPS"
  "install_git|Git|Sistema de controle de versão distribuído"
  "install_gum|Gum|Ferramenta de UI para shell scripts"
  "install_zsh|Zsh + Oh My Zsh|Terminal aprimorado com plugins e temas"
)

_ITEMS_DEV=(
  "install_build_essential|build-essential|gcc, g++, make e ferramentas de compilação"
  "install_libssl_dev|libssl-dev|Headers do OpenSSL para compilação"
  "install_python|Python|Linguagem de programação versátil"
  "install_docker|Docker|Plataforma de contêineres"
  "install_nvm|NVM + Node|Gerenciador de versões do Node.js"
  "install_java|Java (JDK)|Kit de desenvolvimento Java (OpenJDK)"
  "install_vscode|VSCode|Editor de código da Microsoft"
  "install_go|Go|Linguagem compilada do Google"
  "install_postman|Postman|Plataforma de API para desenvolvimento"
  "install_virtualbox|VirtualBox|Hipervisor de virtualização"
  "install_antigravity2|Antigravity 2.0|Plataforma agente-first do Google"
  "install_antigravity_ide|Antigravity IDE|IDE agente-first do Google"
  "install_terraform|Terraform|Infraestrutura como código"
  "install_vagrant|Vagrant|Ambientes de desenvolvimento reproduzíveis"
  "install_github_cli|GitHub CLI|CLI oficial do GitHub"
  "install_aws_cli|AWS CLI|CLI oficial da Amazon Web Services"
  "install_ansible|Ansible|Automação de infraestrutura"
  "install_kubectl|kubectl|CLI oficial do Kubernetes"
  "install_helm|Helm|Gerenciador de pacotes Kubernetes"
  "install_minikube|Minikube|Kubernetes single-node local"
  "install_kiro_cli|Kiro CLI|CLI da plataforma Kiro"
  "install_shellcheck|ShellCheck|Análise estática para scripts shell"
  "install_bats|BATS|Testes automatizados para Bash"
)

_ITEMS_AI=(
  "install_ollama|Ollama|Modelos de linguagem locais"
  "install_opencode|OpenCode|Assistente de engenharia no terminal"
  "install_serena|Serena|MCP toolkit semântico para agentes"
  "install_antigravity_cli|Antigravity CLI|CLI agente-first do Google"
  "install_claude_code|Claude Code|Assistente de codificação da Anthropic"
  "install_github_copilot_cli|GitHub Copilot CLI|Assistente de CLI com IA do GitHub"
)

_ITEMS_TOOLS_TERMINAL=(
  "install_htop|htop|Monitor de processos interativo"
  "install_tmux|tmux|Multiplexador de terminal"
  "install_ripgrep|ripgrep|Busca turbo em Rust"
  "install_fd|fd|Alternativa moderna ao find"
  "install_fzf|fzf|Buscador fuzzy para terminal"
  "install_bat|bat|cat com syntax highlight"
  "install_eza|eza|ls moderno com ícones"
  "install_starship|Starship|Prompt minimalista e personalizável"
  "install_zoxide|zoxide|cd inteligente"
  "install_nano|Nano|Editor de texto simples"
  "install_vim|Vim|Editor de texto clássico"
  "install_neovim|Neovim|Fork moderno do Vim com Lua"
  "install_anyquery|Anyquery|Consulta SQL para qualquer fonte de dados"
  "install_superfile|Superfile|Gerenciador de arquivos no terminal"
  "install_fdupes|fdupes|Localizador de arquivos duplicados"
)

_ITEMS_TOOLS_DESKTOP=(
  "install_flameshot|Flameshot|Captura de tela com anotações"
  "install_espanso|Espanso|Expansor de texto"
  "install_hyperkeys|HyperKeys|Atalhos de teclado personalizados"
  "install_imwheel|IMWheel|Ajuste de velocidade do scroll"
  "install_gparted|GParted|Gerenciador de partições"
  "install_waveterm|Wave Terminal|Terminal com widgets integrados"
  "install_warpreminal|Warp Terminal|Terminal com IA integrada"
  "install_drawio|Draw.io|Editor de diagramas e fluxogramas"
  "install_dbeaver|DBeaver|Gerenciador de bancos de dados"
  "install_stacer|Stacer|Otimizador e monitor do sistema"
  "install_bleachbit|BleachBit|Limpeza de cache e lixo do sistema"
  "install_timeshift|Timeshift|Backup incremental com snapshots"
)

_ITEMS_TOOLS_UBUNTU=(
  "install_nala|Nala|Frontend moderno para o apt"
  "install_neofetch|Neofetch|Informações do sistema estilosas"
  "install_ncdu|ncdu|Análise de uso de disco em TUI"
  "install_duf|duf|df moderno com gráficos e cores"
  "install_deborphan|deborphan|Localiza pacotes órfãos"
  "install_lm_sensors|lm-sensors|Monitoramento de temperatura"
  "install_ufw|UFW|Firewall simples para Ubuntu"
  "install_unattended_upgrades|Unattended Upgrades|Atualizações automáticas de segurança"
)

_ITEMS_MEDIA=(
  "install_chrome|Google Chrome|Navegador web do Google"
  "install_brave|Brave|Navegador focado em privacidade"
)

_ITEMS_FONTS=(
  "install_firacode|Fira Code|Monoespaçada com ligaduras"
  "install_jetbrains_mono|JetBrains Mono|Fonte para programação da JetBrains"
  "install_cascadia_code|Cascadia Code|Monoespaçada da Microsoft com ligaduras"
  "install_ibm_plex|IBM Plex|Família de fontes da IBM"
  "install_victor_mono|Victor Mono|Itálico cursivo e ligaduras"
  "install_monaspace|Monaspace|Família de fontes do GitHub"
)

_ITEMS_CONFIG=(
  "prompt_git_credentials|Git Config|Identificação para commits Git"
  "setup_ssh|SSH Key|Chave SSH para serviços remotos"
  "install_gogh|Gogh Terminal|Temas para o terminal GNOME"
)

_ITEMS_NPM_GLOBALS=(
  "install_typescript|TypeScript|Compilador TypeScript"
  "install_pnpm|pnpm|Gerenciador de pacotes rápido e eficiente"
  "install_yarn_classic|Yarn Classic|Gerenciador de pacotes 1.22.x"
  "install_yarn_berry|Yarn Berry|Yarn moderno (4.x) via Corepack"
  "install_nodemon|Nodemon|Auto-restart em alterações de código"
  "install_concurrently|Concurrently|Rodar múltiplos comandos em paralelo"
  "install_serve|Serve|Servidor estático moderno da Vercel"
  "install_nestjs|Nest.js|Framework Node.js progressivo"
  "install_npm_check_updates|npm-check-updates|Atualizar dependências do package.json"
  "install_live_server|live-server|Servidor com live reload"
  "install_9router|9Router|Roteador CLI"
  "install_openspec|OpenSpec|Gerenciador de mudanças para projetos de IA"
)

declare -gA MODULE_LABELS=(
  [BASE]="Base"
  [DEV]="Dev"
  [AI]="AI"
  [TOOLS_TERMINAL]="Tools Terminal"
  [TOOLS_DESKTOP]="Tools Desktop"
  [TOOLS_UBUNTU]="Tools Ubuntu"
  [MEDIA]="Media"
  [FONTS]="Fonts"
  [CONFIG]="Config"
  [NPM_GLOBALS]="NPM Globals"
)

declare -gA MODULE_DESCRIPTIONS=(
  [BASE]="Utilitários essenciais (curl, git, zsh)"
  [DEV]="Ferramentas de desenvolvimento"
  [AI]="Inteligência Artificial (ollama, opencode)"
  [TOOLS_TERMINAL]="Ferramentas de terminal (htop, tmux, fzf, vim)"
  [TOOLS_DESKTOP]="Aplicativos gráficos (Flameshot, DBeaver, Stacer)"
  [TOOLS_UBUNTU]="Manutenção do sistema (Nala, UFW, neofetch)"
  [MEDIA]="Navegadores (Chrome, Brave)"
  [FONTS]="Fontes para programação (Fira Code)"
  [CONFIG]="Configuração Git, SSH e terminal"
  [NPM_GLOBALS]="Pacotes npm globais (TypeScript, pnpm, Yarn, OpenSpec)"
)

catalog_items() {
  local module="${1:?módulo obrigatório}"
  local var="_ITEMS_${module}"
  declare -p "$var" >/dev/null 2>&1 || return 0
  local ref="${var}[@]"
  local item
  for item in "${!ref}"; do
    printf '%s\n' "$item"
  done
}

catalog_module_total() {
  local module="${1:?módulo obrigatório}"
  local count
  count=$(catalog_items "$module" | wc -l)
  printf '%s\n' "$((count))"
}

catalog_module_label() {
  local module="$1"
  printf '%s\n' "${MODULE_LABELS[$module]:-$module}"
}

catalog_module_desc() {
  local module="$1"
  printf '%s\n' "${MODULE_DESCRIPTIONS[$module]:-}"
}

catalog_tag() {
  printf '%s:%s\n' "$1" "$2"
}

catalog_item_name() {
  local module="$1"
  local func="$2"
  local item_func name _desc
  while IFS='|' read -r item_func name _desc; do
    if [ "$item_func" = "$func" ]; then
      printf '%s\n' "$name"
      return 0
    fi
  done < <(catalog_items "$module")
  return 1
}

catalog_selected_total() {
  local -a modules=("$@")
  local module total=0
  if [ ${#modules[@]} -eq 0 ]; then
    modules=("${MODULES[@]}")
  fi
  for module in "${modules[@]}"; do
    total=$((total + $(catalog_module_selected_total "$module")))
  done
  printf '%s\n' "$total"
}

catalog_module_selected_total() {
  local module="${1:?módulo obrigatório}"
  local func name _desc total=0
  while IFS='|' read -r func name _desc; do
    [ -n "$func" ] || continue
    if ! $SELECTION_ENABLED || select_has "$(catalog_tag "$module" "$func")"; then
      total=$((total + 1))
    fi
  done < <(catalog_items "$module")
  printf '%s\n' "$total"
}

catalog_run_module() {
  local module="${1:?módulo obrigatório}"
  local func name _desc total
  total=$(catalog_module_selected_total "$module")
  [ "$total" -eq 0 ] && return 0
  init_module_progress "$total" "$(catalog_module_label "$module")"
  while IFS='|' read -r func name _desc; do
    [ -n "$func" ] || continue
    if ! $SELECTION_ENABLED || select_has "$(catalog_tag "$module" "$func")"; then
      track "$module" "$func" "$name"
    fi
  done < <(catalog_items "$module")
  end_module_progress
}

catalog_module_is_gui() {
  local module="${1:?módulo obrigatório}"
  case "$module" in
    TOOLS_DESKTOP|MEDIA|FONTS) return 0 ;;
    *) return 1 ;;
  esac
}

catalog_item_is_gui() {
  local module="${1:?módulo obrigatório}"
  local func="${2:?função obrigatória}"
  if catalog_module_is_gui "$module"; then
    return 0
  fi
  case "$func" in
    install_vscode|install_postman|install_virtualbox|install_antigravity_ide)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}
