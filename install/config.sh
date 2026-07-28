prompt_git_credentials() {
  print_header "Git Config" "Identificação para commits Git"

  local config_file="$(dirname "$0")/../config/settings.conf"
  [ -f "$config_file" ] && source "$config_file"

  if [ -t 0 ]; then
    read -p "  Email para Git (${emailgit:-user@example.com}): " input_email
    read -p "  Nome de usuário Git (${usergit:-User}): " input_user
    emailgit="${input_email:-$emailgit}"
    usergit="${input_user:-$usergit}"
  fi

  git config --global user.email "$emailgit"
  git config --global user.name "$usergit"
  log_success "Git configurado: $usergit <$emailgit>"
}

install_gogh() {
  print_header "Gogh Terminal" "Temas para o terminal GNOME"
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
    ssh-keygen -t rsa -b 4096 -C "$emailgit" -N "" -f "$ssh_dir/id_rsa"
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
