install_chrome() {
  # https://www.google.com/chrome/
  print_header "Google Chrome" "Navegador web do Google"
  log_info "↪ https://www.google.com/chrome/"
  cd /tmp
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  log_success "Google Chrome instalado"
}

install_ferdium() {
  # https://github.com/ferdium/ferdium-app/releases
  print_header "Ferdium" "Agregador de mensagens e serviços em um só lugar — https://github.com/ferdium/ferdium-app"
  log_info "↪ https://github.com/ferdium/ferdium-app/releases"
  cd /tmp
  local tag url
  tag=$(curl -s https://api.github.com/repos/ferdium/ferdium-app/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  url="https://github.com/ferdium/ferdium-app/releases/download/${tag}/Ferdium-linux-${tag#v}-amd64.deb"
  wget -q -O ferdium.deb "$url"
  sudo dpkg -i ferdium.deb 2>/dev/null || true
  sudo apt install -f -y
  log_success "Ferdium ${tag#v} instalado"
}

install_mailspring() {
  # https://getmailspring.com/
  print_header "Mailspring" "Cliente de e-mail moderno e rápido"
  log_info "↪ https://getmailspring.com/"
  sudo snap install mailspring
  log_success "Mailspring instalado"
}

install_telegram() {
  # https://desktop.telegram.org/
  print_header "Telegram" "Aplicativo de mensagens instantâneas"
  log_info "↪ https://desktop.telegram.org/"
  sudo snap install telegram-desktop
  log_success "Telegram instalado"
}

install_obsidian() {
  # https://obsidian.md/
  print_header "Obsidian" "Base de conhecimento pessoal com markdown"
  log_info "↪ https://obsidian.md/"
  sudo snap install obsidian --classic
  log_success "Obsidian instalado"
}

install_vlc() {
  # https://snapcraft.io/vlc
  print_header "VLC" "Player de mídia versátil e de código aberto — https://snapcraft.io/vlc"
  log_info "↪ https://snapcraft.io/vlc"
  sudo snap install vlc
  log_success "VLC instalado"
}

install_inkscape() {
  # https://wiki.inkscape.org/wiki/Installing_Inkscape#Ubuntu_or_Debian
  print_header "Inkscape" "Editor de gráficos vetoriais — https://wiki.inkscape.org/wiki/Installing_Inkscape#Ubuntu_or_Debian"
  log_info "↪ https://wiki.inkscape.org/wiki/Installing_Inkscape#Ubuntu_or_Debian"
  sudo apt-get update
  sudo apt-get install inkscape -y
  log_success "Inkscape instalado"
}

install_calibre() {
  # https://calibre-ebook.com/
  print_header "Calibre" "Gerenciador de e-books e conversor de formatos"
  log_info "↪ https://calibre-ebook.com/"
  sudo -v && wget -q -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
  log_success "Calibre instalado"
}

run_media() {
  install_chrome
  install_ferdium
  install_mailspring
  install_telegram
  install_obsidian
  install_vlc
  install_inkscape
  install_calibre
}
