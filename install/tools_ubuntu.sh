install_nala() {
  # https://gitlab.com/volian/nala
  print_header "Nala" "Frontend moderno para o apt — https://gitlab.com/volian/nala"
  log_info "↪ https://gitlab.com/volian/nala"
  sudo apt install -y nala
  log_success "Nala instalado: $(nala --version 2>&1 | head -1)"
}

install_fastfetch() {
  # https://github.com/fastfetch-cli/fastfetch
  print_header "fastfetch" "Informações do sistema rápidas e bonitas — https://github.com/fastfetch-cli/fastfetch"
  log_info "↪ https://github.com/fastfetch-cli/fastfetch"
  sudo apt install -y fastfetch
  log_success "fastfetch instalado: $(fastfetch --version 2>&1)"
}

install_ncdu() {
  # https://dev.yorhel.nl/ncdu
  print_header "ncdu" "Análise de uso de disco em TUI — https://dev.yorhel.nl/ncdu"
  log_info "↪ https://dev.yorhel.nl/ncdu"
  sudo apt install -y ncdu
  log_success "ncdu instalado: $(ncdu --version 2>&1)"
}

install_duf() {
  # https://github.com/muesli/duf
  print_header "duf" "df moderno com gráficos e cores — https://github.com/muesli/duf"
  log_info "↪ https://github.com/muesli/duf"
  sudo apt install -y duf
  log_success "duf instalado: $(duf --version 2>&1)"
}

install_deborphan() {
  # https://packages.debian.org/deborphan
  print_header "deborphan" "Localiza pacotes órfãos no sistema"
  log_info "↪ https://packages.debian.org/deborphan"
  sudo apt install -y deborphan
  log_success "deborphan instalado"
}

install_lm_sensors() {
  # https://github.com/lm-sensors/lm-sensors
  print_header "lm-sensors" "Monitoramento de temperatura da CPU/GPU"
  log_info "↪ https://github.com/lm-sensors/lm-sensors"
  sudo apt install -y lm-sensors
  sudo sensors-detect --auto 2>/dev/null || true
  log_success "lm-sensors instalado"
}

install_ufw() {
  # https://help.ubuntu.com/community/UFW
  print_header "UFW" "Firewall simples para Ubuntu — https://help.ubuntu.com/community/UFW"
  log_info "↪ https://help.ubuntu.com/community/UFW"
  sudo apt install -y ufw
  sudo ufw --force enable 2>/dev/null || true
  log_success "UFW instalado e habilitado"
}

install_unattended_upgrades() {
  # https://wiki.debian.org/UnattendedUpgrades
  print_header "Unattended Upgrades" "Atualizações automáticas de segurança"
  log_info "↪ https://wiki.debian.org/UnattendedUpgrades"
  sudo apt install -y unattended-upgrades
  sudo dpkg-reconfigure -f noninteractive unattended-upgrades 2>/dev/null || true
  log_success "Unattended Upgrades configurado"
}

_run_tools_ubuntu_total=8

run_tools_ubuntu() {
  init_module_progress $_run_tools_ubuntu_total "Tools Ubuntu"
  track "TOOLS_UBUNTU" install_nala "Nala"
  track "TOOLS_UBUNTU" install_fastfetch "fastfetch"
  track "TOOLS_UBUNTU" install_ncdu "ncdu"
  track "TOOLS_UBUNTU" install_duf "duf"
  track "TOOLS_UBUNTU" install_deborphan "deborphan"
  track "TOOLS_UBUNTU" install_lm_sensors "lm-sensors"
  track "TOOLS_UBUNTU" install_ufw "UFW"
  track "TOOLS_UBUNTU" install_unattended_upgrades "Unattended Upgrades"
  end_module_progress
}
