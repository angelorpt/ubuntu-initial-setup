prompt_git_credentials() {
  print_header "Git Config" "Identificação para commits Git"

  local EMAIL_GIT="user@example.com"
  local USER_GIT="User"

  if [ -t 0 ]; then
    read -p "  Email para Git (${EMAIL_GIT}): " input_email
    read -p "  Nome de usuário Git (${USER_GIT}): " input_user
    EMAIL_GIT="${input_email:-$EMAIL_GIT}"
    USER_GIT="${input_user:-$USER_GIT}"
  fi

  git config --global user.email "$EMAIL_GIT"
  git config --global user.name "$USER_GIT"
  log_success "Git configurado: $USER_GIT <$EMAIL_GIT>"
}

install_gogh() {
  # https://github.com/Gogh-Co/Gogh
  print_header "Gogh Terminal" "Temas para o terminal GNOME"
  log_info "↪ https://github.com/Gogh-Co/Gogh"
  sudo apt install -y dconf-cli uuid-runtime
  export TERMINAL=gnome-terminal
  bash -c "$(wget -qO- https://git.io/vQgMr)" 2>/dev/null || true
  log_success "Gogh instalado"
}

setup_ssh() {
  print_header "SSH Key" "Chave SSH para autenticação em serviços remotos"

  local ssh_dir="$HOME/.ssh"
  mkdir -p "$ssh_dir"

  if [ ! -f "$ssh_dir/id_rsa" ]; then
    ssh-keygen -t rsa -b 4096 -C "$EMAIL_GIT" -N "" -f "$ssh_dir/id_rsa"
    log_success "Chave SSH gerada em $ssh_dir/id_rsa.pub"
    echo
    echo -e "${YELLOW}  Adicione esta chave ao GitHub/GitLab:${NC}"
    cat "$ssh_dir/id_rsa.pub"
  else
    log_info "Chave SSH já existe em $ssh_dir/id_rsa"
  fi
}

run_config() {
  prompt_git_credentials
  setup_ssh
  install_gogh
}
