install_htop() {
  # https://htop.dev/
  print_header "htop" "Monitor de processos interativo"
  print_details "https://htop.dev" \
    "Exibe processos em tempo real com árvore hierárquica" \
    "Ordenação por CPU, memória e PID, busca por nome" \
    "Uso: htop"
  sudo apt install -y htop
  log_success "htop instalado: $(htop --version 2>&1 | head -1)"
}

install_tmux() {
  # https://github.com/tmux/tmux
  print_header "tmux" "Multiplexador de terminal com sessões persistentes"
  print_details "https://github.com/tmux/tmux" \
    "Divide o terminal em múltiplos painéis e janelas" \
    "Sessões que persistem mesmo após desconexão SSH" \
    "Uso: tmux new -s sessao, Ctrl+B % (dividir), Ctrl+B d (detach)"
  sudo apt install -y tmux
  log_success "tmux instalado: $(tmux -V 2>&1)"
}

install_ripgrep() {
  # https://github.com/BurntSushi/ripgrep
  print_header "ripgrep" "Ferramenta de busca turbo em Rust"
  print_details "https://github.com/BurntSushi/ripgrep" \
    "Busca recursiva em arquivos mais rápida que grep -r" \
    "Respeita .gitignore automaticamente, regex PCRE2" \
    "Uso: rg 'funcao' src/"
  sudo apt install -y ripgrep
  log_success "ripgrep instalado: $(rg --version 2>&1 | head -1)"
}

install_fd() {
  # https://github.com/sharkdp/fd
  print_header "fd" "Alternativa moderna ao find"
  print_details "https://github.com/sharkdp/fd" \
    "Localiza arquivos por nome com regex, mais rápido que find" \
    "Respeita .gitignore, cores na saída, busca inteligente" \
    "Uso: fd '.txt$', fd -e md"
  sudo apt install -y fd-find
  log_success "fd instalado: $(fdfind --version 2>&1 | head -1)"
}

install_fzf() {
  # https://github.com/junegunn/fzf
  print_header "fzf" "Buscador fuzzy generalizado para terminal"
  print_details "https://github.com/junegunn/fzf" \
    "Busca interativa em listas, histórico de comandos, arquivos" \
    "Integra com Ctrl+R (histórico), Ctrl+T (arquivos), Alt+C (cd)" \
    "Uso: Ctrl+T no terminal, ou fzf --preview 'cat {}'"
  sudo apt install -y fzf
  log_success "fzf instalado: $(fzf --version 2>&1)"
}

install_bat() {
  # https://github.com/sharkdp/bat
  print_header "bat" "cat com syntax highlight"
  print_details "https://github.com/sharkdp/bat" \
    "Exibe arquivos com syntax highlighting, numeração de linhas" \
    "Integração com git (mostra modificações na lateral)" \
    "Uso: bat arquivo.rs, bat -l python arquivo.txt"
  sudo apt install -y bat
  log_success "bat instalado: $(bat --version 2>&1 | head -1)"
}

install_eza() {
  # https://github.com/eza-community/eza
  print_header "eza" "ls moderno com ícones e git status"
  print_details "https://github.com/eza-community/eza" \
    "Listagem de arquivos com cores, ícones, permissões e git" \
    "Exibe árvore (--tree), extended attributes, links simbólicos" \
    "Uso: eza -la, eza --tree, eza --icons"
  sudo apt install -y eza
  log_success "eza instalado: $(eza --version 2>&1 | head -1)"
}

install_starship() {
  # https://starship.rs/
  print_header "Starship" "Prompt minimalista e personalizável"
  print_details "https://starship.rs" \
    "Prompt para qualquer shell (bash, zsh, fish) com informações úteis" \
    "Mostra branch git, versão node/python/rust, tempo de comando" \
    "Configuração via TOML: ~/.config/starship.toml"
  curl -sS https://starship.rs/install.sh | sh
  log_success "Starship instalado"
}

install_zoxide() {
  # https://github.com/ajeetdsouza/zoxide
  print_header "zoxide" "cd inteligente que aprende seus diretórios"
  print_details "https://github.com/ajeetdsouza/zoxide" \
    "Navega pelos diretórios mais usados com busca fuzzy" \
    "Aprende seus padrões com o tempo — nunca mais digite caminhos" \
    "Uso: z proj (vai para /home/user/Projects), z .. (sobe)"
  sudo apt install -y zoxide
  log_success "zoxide instalado: $(zoxide --version 2>&1)"
}

install_nano() {
  # https://www.nano-editor.org/
  print_header "Nano" "Editor de texto simples para terminal"
  print_details "https://www.nano-editor.org" \
    "Editor minimalista e intuitivo, ideal para iniciantes" \
    "Atalhos na tela, syntax highlighting, busca e substituição" \
    "Uso: nano arquivo.txt (Ctrl+O salva, Ctrl+X sai)"
  sudo apt install -y nano
  log_success "Nano instalado: $(nano --version 2>&1 | head -1)"
}

install_vim() {
  # https://www.vim.org/
  print_header "Vim" "Editor de texto clássico e poderoso"
  print_details "https://www.vim.org" \
    "Editor modal com 40+ anos de história e ecossistema vasto" \
    "Modos: normal, insert, visual, command — plugins, macros, regex" \
    "Uso: vim arquivo.txt (i insere, ESC sai, :wq salva e sai)"
  sudo apt install -y vim
  log_success "Vim instalado: $(vim --version 2>&1 | head -1)"
}

install_neovim() {
  # https://neovim.io/
  print_header "Neovim" "Fork moderno do Vim com suporte a Lua"
  print_details "https://neovim.io" \
    "Vim moderno com API assíncrona, Lua como linguagem de config" \
    "Suporte a LSP, Treesitter, Telescope, LazyVim/NvChad" \
    "Uso: nvim arquivo.lua"
  sudo apt install -y neovim
  log_success "Neovim instalado: $(nvim --version 2>&1 | head -1)"
}

install_anyquery() {
  # https://anyquery.dev/docs/#installation
  print_header "Anyquery" "Ferramenta de consulta SQL para qualquer fonte de dados"
  print_details "https://anyquery.dev" \
    "Consulta CSV, JSON, SQLite, Airtable, Google Sheets com SQL" \
    "Exporta resultados para JSON, CSV, tabela formatada" \
    "Uso: anyquery -q 'SELECT * FROM arquivo.csv'"
  curl -fsSL https://anyquery.dev/install.sh | sh
  log_success "Anyquery instalado"
}

install_superfile() {
  # https://superfile.dev/getting-started/installation/
  print_header "Superfile" "Gerenciador de arquivos no terminal"
  print_details "https://superfile.dev" \
    "Navegador de arquivos TUI moderno com preview de arquivos" \
    "Suporte a atalhos, seleção múltipla, operações em lote" \
    "Uso: superfile (ou sf)"
  bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
  log_success "Superfile instalado"
}

_run_tools_terminal_total=14

run_tools_terminal() {
  init_module_progress $_run_tools_terminal_total "Tools Terminal"
  track "TOOLS_TERMINAL" install_htop "htop"
  track "TOOLS_TERMINAL" install_tmux "tmux"
  track "TOOLS_TERMINAL" install_ripgrep "ripgrep"
  track "TOOLS_TERMINAL" install_fd "fd"
  track "TOOLS_TERMINAL" install_fzf "fzf"
  track "TOOLS_TERMINAL" install_bat "bat"
  track "TOOLS_TERMINAL" install_eza "eza"
  track "TOOLS_TERMINAL" install_starship "Starship"
  track "TOOLS_TERMINAL" install_zoxide "zoxide"
  track "TOOLS_TERMINAL" install_nano "Nano"
  track "TOOLS_TERMINAL" install_vim "Vim"
  track "TOOLS_TERMINAL" install_neovim "Neovim"
  track "TOOLS_TERMINAL" install_anyquery "Anyquery"
  track "TOOLS_TERMINAL" install_superfile "Superfile"
  end_module_progress
}
