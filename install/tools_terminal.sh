install_htop() {
  # https://htop.dev/
  print_header "htop" "Monitor de processos interativo — https://htop.dev"
  log_info "↪ https://htop.dev/"
  sudo apt install -y htop
  log_success "htop instalado: $(htop --version 2>&1 | head -1)"
}

install_tmux() {
  # https://github.com/tmux/tmux
  print_header "tmux" "Multiplexador de terminal com sessões persistentes — https://github.com/tmux/tmux"
  log_info "↪ https://github.com/tmux/tmux"
  sudo apt install -y tmux
  log_success "tmux instalado: $(tmux -V 2>&1)"
}

install_ripgrep() {
  # https://github.com/BurntSushi/ripgrep
  print_header "ripgrep" "Ferramenta de busca turbo em Rust — https://github.com/BurntSushi/ripgrep"
  log_info "↪ https://github.com/BurntSushi/ripgrep"
  sudo apt install -y ripgrep
  log_success "ripgrep instalado: $(rg --version 2>&1 | head -1)"
}

install_fd() {
  # https://github.com/sharkdp/fd
  print_header "fd" "Alternativa moderna ao find — https://github.com/sharkdp/fd"
  log_info "↪ https://github.com/sharkdp/fd"
  sudo apt install -y fd-find
  log_success "fd instalado: $(fdfind --version 2>&1 | head -1)"
}

install_fzf() {
  # https://github.com/junegunn/fzf
  print_header "fzf" "Buscador fuzzy generalizado para terminal — https://github.com/junegunn/fzf"
  log_info "↪ https://github.com/junegunn/fzf"
  sudo apt install -y fzf
  log_success "fzf instalado: $(fzf --version 2>&1)"
}

install_bat() {
  # https://github.com/sharkdp/bat
  print_header "bat" "cat com syntax highlight — https://github.com/sharkdp/bat"
  log_info "↪ https://github.com/sharkdp/bat"
  sudo apt install -y bat
  log_success "bat instalado: $(bat --version 2>&1 | head -1)"
}

install_eza() {
  # https://github.com/eza-community/eza
  print_header "eza" "ls moderno com ícones e git status — https://github.com/eza-community/eza"
  log_info "↪ https://github.com/eza-community/eza"
  sudo apt install -y eza
  log_success "eza instalado: $(eza --version 2>&1 | head -1)"
}

install_starship() {
  # https://starship.rs/
  print_header "Starship" "Prompt minimalista e personalizável — https://starship.rs"
  log_info "↪ https://starship.rs/"
  curl -sS https://starship.rs/install.sh | sh
  log_success "Starship instalado"
}

install_zoxide() {
  # https://github.com/ajeetdsouza/zoxide
  print_header "zoxide" "cd inteligente que aprende seus diretórios — https://github.com/ajeetdsouza/zoxide"
  log_info "↪ https://github.com/ajeetdsouza/zoxide"
  sudo apt install -y zoxide
  log_success "zoxide instalado: $(zoxide --version 2>&1)"
}

install_nano() {
  # https://www.nano-editor.org/
  print_header "Nano" "Editor de texto simples para terminal"
  log_info "↪ https://www.nano-editor.org/"
  sudo apt install -y nano
  log_success "Nano instalado: $(nano --version 2>&1 | head -1)"
}

install_vim() {
  # https://www.vim.org/
  print_header "Vim" "Editor de texto clássico e poderoso"
  log_info "↪ https://www.vim.org/"
  sudo apt install -y vim
  log_success "Vim instalado: $(vim --version 2>&1 | head -1)"
}

install_neovim() {
  # https://neovim.io/
  print_header "Neovim" "Fork moderno do Vim com suporte a Lua — https://neovim.io"
  log_info "↪ https://neovim.io/"
  sudo apt install -y neovim
  log_success "Neovim instalado: $(nvim --version 2>&1 | head -1)"
}

install_anyquery() {
  # https://anyquery.dev/docs/#installation
  print_header "Anyquery" "Ferramenta de consulta SQL para qualquer fonte de dados — https://anyquery.dev"
  log_info "↪ https://anyquery.dev/docs/#installation"
  curl -fsSL https://anyquery.dev/install.sh | sh
  log_success "Anyquery instalado"
}

install_superfile() {
  # https://superfile.dev/getting-started/installation/
  print_header "Superfile" "Gerenciador de arquivos no terminal — https://superfile.dev"
  log_info "↪ https://superfile.dev"
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
