install_chrome() {
  # https://www.google.com/chrome/
  print_header "Google Chrome" "Navegador web do Google"
  log_info "↪ https://www.google.com/chrome/"
  cd /tmp
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  log_success "Google Chrome instalado"
}

_run_media_total=1

run_media() {
  init_module_progress $_run_media_total "Media"
  track "MEDIA" install_chrome "Google Chrome"
  end_module_progress
}
