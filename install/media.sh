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

install_blisk() {
  # https://blisk.io/
  print_header "Blisk" "Navegador para desenvolvimento web"
  print_details "https://blisk.io" \
    "Navegador feito para desenvolvedores web com emulador mobile" \
    "Ferramentas de screenshot, grab de requisições, auto-refresh" \
    "Uso: blisk (ou Blisk no menu)"

  if command -v blisk &>/dev/null; then
    log_info "Blisk já instalado"
    return 0
  fi

  pushd /tmp > /dev/null
  local url="https://blisk.io/download/installer/?os=linux-deb"
  log_info "↪ Baixando: $url"
  wget -q -O blisk.deb "$url" || { log_error "Falha ao baixar Blisk"; popd > /dev/null; return 1; }
  sudo apt install -y ./blisk.deb || { log_error "Falha ao instalar Blisk"; popd > /dev/null; return 1; }
  rm -f blisk.deb
  popd > /dev/null
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
