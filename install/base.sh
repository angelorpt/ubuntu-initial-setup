install_curl() {
  # https://curl.se/
  print_header "Curl" "Ferramenta de transferência de dados via URL"
  log_info "↪ https://curl.se/"
  log_info "Instalando curl..."
  sudo apt install curl -y
  log_success "Curl instalado"
}

install_git() {
  # https://git-scm.com/
  print_header "Git" "Sistema de controle de versão distribuído"
  log_info "↪ https://git-scm.com/"
  log_info "Instalando git..."
  sudo apt install git-all -y
  log_success "Git instalado"
}

install_zsh() {
  # https://ohmyz.sh/
  print_header "Zsh + Oh My Zsh" "Terminal aprimorado com plugins e temas"
  log_info "↪ https://ohmyz.sh/"
  log_info "Instalando zsh..."
  sudo apt install zsh -y
  log_info "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  log_success "Zsh + Oh My Zsh instalado"
}

run_base() {
  track "BASE" install_curl "Curl"
  track "BASE" install_git "Git"
  track "BASE" install_zsh "Zsh + Oh My Zsh"
}
