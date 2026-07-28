install_chrome() {
  print_header "Google Chrome" "Navegador web do Google"
  cd /tmp
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  log_success "Google Chrome instalado"
}

install_ferdium() {
  print_header "Ferdium" "Agregador de mensagens e serviços em um só lugar"
  cd /tmp
  wget -q https://github.com/ferdium/ferdium-app/releases/download/v6.7.6/Ferdium-linux-6.7.6-amd64.deb
  sudo dpkg -i Ferdium-linux-6.7.6-amd64.deb 2>/dev/null || true
  sudo apt install -f -y
  log_success "Ferdium instalado"
}

install_mailspring() {
  print_header "Mailspring" "Cliente de e-mail moderno e rápido"
  sudo snap install mailspring
  log_success "Mailspring instalado"
}

install_telegram() {
  print_header "Telegram" "Aplicativo de mensagens instantâneas"
  sudo snap install telegram-desktop
  log_success "Telegram instalado"
}

install_obsidian() {
  print_header "Obsidian" "Base de conhecimento pessoal com markdown"
  sudo snap install obsidian --classic
  log_success "Obsidian instalado"
}

install_inkscape() {
  # https://wiki.inkscape.org/wiki/Installing_Inkscape#Ubuntu_or_Debian
  print_header "Inkscape" "Editor de gráficos vetoriais — https://wiki.inkscape.org/wiki/Installing_Inkscape#Ubuntu_or_Debian"
  sudo apt-get update
  sudo apt-get install inkscape -y
  log_success "Inkscape instalado"
}

install_calibre() {
  print_header "Calibre" "Gerenciador de e-books e conversor de formatos"
  sudo -v && wget -q -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
  log_success "Calibre instalado"
}

run_media() {
  install_chrome
  install_ferdium
  install_mailspring
  install_telegram
  install_obsidian
  install_inkscape
  install_calibre
}
