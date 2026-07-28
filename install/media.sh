install_chrome() {
  # https://www.google.com/chrome/
  print_header "Google Chrome" "Navegador web do Google"
  log_info "↪ https://www.google.com/chrome/"
  cd /tmp
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  log_success "Google Chrome instalado"
}

run_media() {
  track "MEDIA" install_chrome "Google Chrome"
}
