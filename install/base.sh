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

install_gum() {
  # https://github.com/charmbracelet/gum
  print_header "Gum" "Ferramenta de UI para shell scripts — https://github.com/charmbracelet/gum"
  log_info "↪ https://github.com/charmbracelet/gum"
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt update && sudo apt install -y gum
  log_success "Gum instalado"
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

_run_base_total=4

run_base() {
  init_module_progress $_run_base_total "Base"
  track "BASE" install_curl "Curl"
  track "BASE" install_git "Git"
  track "BASE" install_gum "Gum"
  track "BASE" install_zsh "Zsh + Oh My Zsh"
  end_module_progress
}
