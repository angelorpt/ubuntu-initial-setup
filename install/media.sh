install_chrome() {
  # https://www.google.com/chrome/
  print_header "Google Chrome" "Navegador web do Google"
  print_details "https://www.google.com/chrome" \
    "Navegador mais usado do mundo, com sincronização de contas Google" \
    "Ferramentas de desenvolvedor, extensões, V8 rápido" \
    "Uso: google-chrome"
  pushd /tmp > /dev/null
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  popd > /dev/null
  log_success "Google Chrome instalado"
}

install_brave() {
  # https://brave.com/linux/
  print_header "Brave" "Navegador focado em privacidade"
  print_details "https://brave.com" \
    "Bloqueador de anúncios e rastreadores nativo" \
    "Tor integrado, IPFS, recompensas BAT, compatível com Chrome" \
    "Uso: brave-browser"
  curl -fsS https://dl.brave.com/install.sh | sh
  log_success "Brave instalado: $(brave-browser --version 2>&1)"
}

_run_media_total=2

run_media() {
  init_module_progress $_run_media_total "Media"
  track "MEDIA" install_chrome "Google Chrome"
  track "MEDIA" install_brave "Brave"
  end_module_progress
}
