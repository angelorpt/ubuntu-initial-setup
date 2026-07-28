install_chrome() {
  # https://www.google.com/chrome/
  print_header "Google Chrome" "Navegador web do Google"
  log_info "↪ https://www.google.com/chrome/"
  cd /tmp
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  log_success "Google Chrome instalado"
}

install_brave() {
  # https://brave.com/linux/
  print_header "Brave" "Navegador focado em privacidade — https://brave.com"
  log_info "↪ https://brave.com/linux/"
  curl -fsS https://dl.brave.com/install.sh | sh
  log_success "Brave instalado: $(brave-browser --version 2>&1)"
}

install_blisk() {
  # https://blisk.io/
  print_header "Blisk" "Navegador para desenvolvimento web — https://blisk.io"
  log_info "↪ https://blisk.io/download/installer/?os=linux-deb"
  cd /tmp
  wget -q -O blisk.deb "https://blisk.io/download/installer/?os=linux-deb"
  sudo dpkg -i blisk.deb 2>/dev/null || true
  sudo apt install -f -y
  log_success "Blisk instalado"
}

_run_media_total=3

run_media() {
  init_module_progress $_run_media_total "Media"
  track "MEDIA" install_chrome "Google Chrome"
  track "MEDIA" install_brave "Brave"
  track "MEDIA" install_blisk "Blisk"
  end_module_progress
}
