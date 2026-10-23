#!/bin/bash
# lib/catalog.sh — catálogo único de módulos e itens instaláveis.
# Cada item segue o formato: "funcao|Nome de exibição|descrição curta EN|descrição curta PT".
# A ordem dos arrays é a ordem de instalação.

if ! declare -F select_has >/dev/null 2>&1; then
  # shellcheck source=lib/selection.sh
  source "$(dirname "${BASH_SOURCE[0]}")/selection.sh"
fi

APP_LANG="${APP_LANG:-en}"

MODULES=(BASE DEV AI TOOLS_TERMINAL TOOLS_DESKTOP TOOLS_UBUNTU MEDIA FONTS CONFIG NPM_GLOBALS)

_ITEMS_BASE=(
  "install_curl|Curl|Command line tool for transferring data with URLs|Cliente HTTP/HTTPS"
  "install_git|Git|Distributed version control system|Sistema de controle de versão distribuído"
  "install_gum|Gum|Tool for glamorous shell scripts and prompts|Ferramenta de UI para shell scripts"
  "install_zsh|Zsh + Oh My Zsh|Extended shell with plugins and themes|Terminal aprimorado com plugins e temas"
)

_ITEMS_DEV=(
  "install_build_essential|build-essential|gcc, g++, make and build toolchain|gcc, g++, make e ferramentas de compilação"
  "install_libssl_dev|libssl-dev|OpenSSL development headers|Headers do OpenSSL para compilação"
  "install_python|Python|Python 3 and pip runtime|Linguagem de programação versátil"
  "install_docker|Docker|Container platform (Engine + Compose)|Plataforma de contêineres"
  "install_nvm|NVM + Node|Node Version Manager with current Node LTS|Gerenciador de versões do Node.js"
  "install_java|Java (JDK)|OpenJDK Java Development Kit|Kit de desenvolvimento Java (OpenJDK)"
  "install_vscode|VSCode|Visual Studio Code editor|Editor de código da Microsoft"
  "install_go|Go|Go programming language|Linguagem compilada do Google"
  "install_postman|Postman|API development platform|Plataforma de API para desenvolvimento"
  "install_virtualbox|VirtualBox|Open-source hypervisor|Hipervisor de virtualização"
  "install_antigravity2|Antigravity 2.0|Agent-first developer platform|Plataforma agente-first do Google"
  "install_antigravity_ide|Antigravity IDE|Agent-first IDE|IDE agente-first do Google"
  "install_terraform|Terraform|Infrastructure as Code by HashiCorp|Infraestrutura como código"
  "install_vagrant|Vagrant|Reproducible development environments|Ambientes de desenvolvimento reproduzíveis"
  "install_github_cli|GitHub CLI|Official GitHub command-line tool|CLI oficial do GitHub"
  "install_aws_cli|AWS CLI|Official Amazon Web Services CLI|CLI oficial da Amazon Web Services"
  "install_ansible|Ansible|IT infrastructure automation|Automação de infraestrutura"
  "install_kubectl|kubectl|Official Kubernetes CLI tool|CLI oficial do Kubernetes"
  "install_helm|Helm|Kubernetes package manager|Gerenciador de pacotes Kubernetes"
  "install_minikube|Minikube|Local single-node Kubernetes cluster|Kubernetes single-node local"
  "install_kiro_cli|Kiro CLI|Official CLI for the Kiro platform|CLI da plataforma Kiro"
  "install_shellcheck|ShellCheck|Static analysis linter for shell scripts|Análise estática para scripts shell"
  "install_bats|BATS|Automated Bash Testing System|Testes automatizados para Bash"
)

_ITEMS_AI=(
  "install_ollama|Ollama|Local LLM runner and management|Modelos de linguagem locais"
  "install_opencode|OpenCode|Terminal AI software engineering assistant|Assistente de engenharia no terminal"
  "install_serena|Serena|Semantic MCP toolkit for code agents|MCP toolkit semântico para agentes"
  "install_antigravity_cli|Antigravity CLI|Google agent-first command line interface|CLI agente-first do Google"
  "install_claude_code|Claude Code|Anthropic terminal coding agent|Assistente de codificação da Anthropic"
  "install_github_copilot_cli|GitHub Copilot CLI|GitHub AI assistant for terminals|Assistente de CLI com IA do GitHub"
)

_ITEMS_TOOLS_TERMINAL=(
  "install_htop|htop|Interactive process viewer|Monitor de processos interativo"
  "install_tmux|tmux|Terminal multiplexer with persistent sessions|Multiplexador de terminal"
  "install_ripgrep|ripgrep|Blazing-fast regex recursive search|Busca turbo em Rust"
  "install_fd|fd|Simple, fast alternative to find|Alternativa moderna ao find"
  "install_fzf|fzf|Command-line fuzzy finder|Buscador fuzzy para terminal"
  "install_bat|bat|Cat clone with syntax highlighting|cat com syntax highlight"
  "install_eza|eza|Modern ls replacement with icons|ls moderno com ícones"
  "install_starship|Starship|Minimal, fast, and customizable prompt|Prompt minimalista e personalizável"
  "install_zoxide|zoxide|Smarter cd command learning habits|cd inteligente"
  "install_nano|Nano|Simple terminal text editor|Editor de texto simples"
  "install_vim|Vim|Classic powerful text editor|Editor de texto clássico"
  "install_neovim|Neovim|Vim-fork with Lua support|Fork moderno do Vim com Lua"
  "install_anyquery|Anyquery|Query data sources using SQL|Consulta SQL para qualquer fonte de dados"
  "install_superfile|Superfile|Modern terminal file manager|Gerenciador de arquivos no terminal"
  "install_fdupes|fdupes|Duplicate file finder and manager|Localizador de arquivos duplicados"
)

_ITEMS_TOOLS_DESKTOP=(
  "install_flameshot|Flameshot|Powerful screenshot tool with annotations|Captura de tela com anotações"
  "install_espanso|Espanso|Cross-platform text expander|Expansor de texto"
  "install_hyperkeys|HyperKeys|Global custom keyboard shortcut manager|Atalhos de teclado personalizados"
  "install_imwheel|IMWheel|Mouse wheel scroll speed modifier|Ajuste de velocidade do scroll"
  "install_gparted|GParted|Disk partition management tool|Gerenciador de partições"
  "install_waveterm|Wave Terminal|Terminal with inline UI rendering|Terminal com widgets integrados"
  "install_warpreminal|Warp Terminal|Modern terminal with AI integration|Terminal com IA integrada"
  "install_drawio|Draw.io|Diagramming and flowchart editor|Editor de diagramas e fluxogramas"
  "install_dbeaver|DBeaver|Universal database manager|Gerenciador de bancos de dados"
  "install_stacer|Stacer|Linux system optimizer and monitor|Otimizador e monitor do sistema"
  "install_bleachbit|BleachBit|Disk space cleaner and privacy manager|Limpeza de cache e lixo do sistema"
  "install_timeshift|Timeshift|Incremental system restore snapshots|Backup incremental com snapshots"
  "install_moji|Moji|Modern and lightweight emoji picker|Seletor de emojis moderno e leve"
)

_ITEMS_TOOLS_UBUNTU=(
  "install_nala|Nala|Clean, parallel frontend for apt|Frontend moderno para o apt"
  "install_neofetch|Neofetch|Stylish CLI system information|Informações do sistema estilosas"
  "install_ncdu|ncdu|NCurses disk usage analyzer|Análise de uso de disco em TUI"
  "install_duf|duf|Better disk usage utility with tables|df moderno com gráficos e cores"
  "install_deborphan|deborphan|Finds orphaned packages and unused libs|Localiza pacotes órfãos"
  "install_lm_sensors|lm-sensors|Hardware temperature and fan sensors|Monitoramento de temperatura"
  "install_ufw|UFW|Uncomplicated Firewall manager|Firewall simples para Ubuntu"
  "install_unattended_upgrades|Unattended Upgrades|Automatic security updates setup|Atualizações automáticas de segurança"
)

_ITEMS_MEDIA=(
  "install_chrome|Google Chrome|Modern web browser by Google|Navegador web do Google"
  "install_brave|Brave|Privacy-focused secure web browser|Navegador focado em privacidade"
)

_ITEMS_FONTS=(
  "install_firacode|Fira Code|Monospace font with programming ligatures|Monoespaçada com ligaduras"
  "install_jetbrains_mono|JetBrains Mono|Developer typeface by JetBrains|Fonte para programação da JetBrains"
  "install_cascadia_code|Cascadia Code|Monospaced font by Microsoft|Monoespaçada da Microsoft com ligaduras"
  "install_ibm_plex|IBM Plex|Superfamily typeface by IBM|Família de fontes da IBM"
  "install_victor_mono|Victor Mono|Monospaced font with cursive italics|Itálico cursivo e ligaduras"
  "install_monaspace|Monaspace|GitHub typography system for coding|Família de fontes do GitHub"
)

_ITEMS_CONFIG=(
  "prompt_git_credentials|Git Config|Global git user and email setup|Identificação para commits Git"
  "setup_ssh|SSH Key|SSH key generation for remote git hosts|Chave SSH para serviços remotos"
  "install_gogh|Gogh Terminal|Over 200 terminal color schemes|Temas para o terminal GNOME"
)

_ITEMS_NPM_GLOBALS=(
  "install_typescript|TypeScript|TypeScript compiler and type checker|Compilador TypeScript"
  "install_pnpm|pnpm|Fast, disk space efficient package manager|Gerenciador de pacotes rápido e eficiente"
  "install_yarn_classic|Yarn Classic|Classic package manager (1.22.x)|Gerenciador de pacotes 1.22.x"
  "install_yarn_berry|Yarn Berry|Modern Yarn (4.x) via Corepack|Yarn moderno (4.x) via Corepack"
  "install_nodemon|Nodemon|Auto-restart application on code changes|Auto-restart em alterações de código"
  "install_concurrently|Concurrently|Run multiple commands concurrently|Rodar múltiplos comandos em paralelo"
  "install_serve|Serve|Static file server and single page apps|Servidor estático moderno da Vercel"
  "install_nestjs|Nest.js|Progressive Node.js framework CLI|Framework Node.js progressivo"
  "install_npm_check_updates|npm-check-updates|Upgrade package.json dependencies|Atualizar dependências do package.json"
  "install_live_server|live-server|Development HTTP server with reload|Servidor com live reload"
  "install_9router|9Router|Command-line router utility|Roteador CLI"
  "install_openspec|OpenSpec|Spec-driven change manager for AI|Gerenciador de mudanças para projetos de IA"
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

declare -gA MODULE_DESCRIPTIONS_EN=(
  [BASE]="Essential foundations (curl, git, zsh)"
  [DEV]="Developer compilers, runtimes, containers and cloud tools"
  [AI]="Artificial Intelligence & LLMs (ollama, opencode, copilot)"
  [TOOLS_TERMINAL]="Terminal utilities and multiplexers (htop, tmux, fzf, vim)"
  [TOOLS_DESKTOP]="Desktop GUI applications (Flameshot, DBeaver, Stacer)"
  [TOOLS_UBUNTU]="System maintenance & security (Nala, UFW, neofetch)"
  [MEDIA]="Web browsers (Chrome, Brave)"
  [FONTS]="Developer monospace fonts (Fira Code, JetBrains Mono)"
  [CONFIG]="Git credentials, SSH keys, and terminal themes"
  [NPM_GLOBALS]="Global NPM tools (TypeScript, pnpm, Yarn, OpenSpec)"
)

declare -gA MODULE_DESCRIPTIONS_PT=(
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
  local item func name desc_en desc_pt chosen_desc
  for item in "${!ref}"; do
    IFS='|' read -r func name desc_en desc_pt <<< "$item"
    if [ "$APP_LANG" = "pt" ] || [ "$APP_LANG" = "pt-BR" ] || [ "$APP_LANG" = "pt_BR" ]; then
      chosen_desc="${desc_pt:-$desc_en}"
    else
      chosen_desc="${desc_en:-$desc_pt}"
    fi
    printf '%s|%s|%s\n' "$func" "$name" "$chosen_desc"
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
  local lang="${2:-$APP_LANG}"
  if [ "$lang" = "pt" ] || [ "$lang" = "pt-BR" ] || [ "$lang" = "pt_BR" ]; then
    printf '%s\n' "${MODULE_DESCRIPTIONS_PT[$module]:-${MODULE_DESCRIPTIONS_EN[$module]:-}}"
  else
    printf '%s\n' "${MODULE_DESCRIPTIONS_EN[$module]:-${MODULE_DESCRIPTIONS_PT[$module]:-}}"
  fi
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

catalog_item_desc() {
  local module="$1"
  local func="$2"
  local lang="${3:-$APP_LANG}"
  local item_func name desc_en desc_pt var="_ITEMS_${module}"
  declare -p "$var" >/dev/null 2>&1 || return 1
  local ref="${var}[@]"
  local item
  for item in "${!ref}"; do
    IFS='|' read -r item_func name desc_en desc_pt <<< "$item"
    if [ "$item_func" = "$func" ]; then
      if [ "$lang" = "pt" ] || [ "$lang" = "pt-BR" ] || [ "$lang" = "pt_BR" ]; then
        printf '%s\n' "${desc_pt:-$desc_en}"
      else
        printf '%s\n' "${desc_en:-$desc_pt}"
      fi
      return 0
    fi
  done
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
