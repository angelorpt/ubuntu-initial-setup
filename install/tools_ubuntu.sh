install_nala() {
  # https://gitlab.com/volian/nala
  print_header "Nala" "Frontend moderno para o apt"
  print_details "https://gitlab.com/volian/nala" \
    "apt com progresso visual, espelhos mais rápidos, histórico de logs" \
    "Download paralelo, busca destacada, rollback de instalações" \
    "Uso: sudo nala install pacote, sudo nala upgrade"
  sudo apt install -y nala
  log_success "Nala instalado: $(nala --version 2>&1 | head -1)"
}

install_neofetch() {
  # https://github.com/dylanaraps/neofetch
  print_header "Neofetch" "Informações do sistema estilosas"
  print_details "https://github.com/dylanaraps/neofetch" \
    "Exibe info do sistema com ASCII art da distro: kernel, CPU, GPU, memória" \
    "Altamente customizável com flags, imagens e formatos de saída" \
    "Uso: neofetch"
  sudo apt install -y neofetch
  log_success "Neofetch instalado"
}

install_ncdu() {
  # https://dev.yorhel.nl/ncdu
  print_header "ncdu" "Análise de uso de disco em TUI"
  print_details "https://dev.yorhel.nl/ncdu" \
    "Navega interativamente pelos diretórios vendo o espaço usado" \
    "Ordena por tamanho, deleta arquivos da interface, exporta relatório" \
    "Uso: ncdu /home, ncdu ~"
  sudo apt install -y ncdu
  log_success "ncdu instalado: $(ncdu --version 2>&1)"
}

install_duf() {
  # https://github.com/muesli/duf
  print_header "duf" "df moderno com gráficos e cores"
  print_details "https://github.com/muesli/duf" \
    "Exibe espaço em disco com barras visuais, cores e montagem" \
    "Agrupa por dispositivo, sistema de arquivos, uso" \
    "Uso: duf, duf /home"
  sudo apt install -y duf
  log_success "duf instalado: $(duf --version 2>&1)"
}

install_deborphan() {
  # https://packages.debian.org/deborphan
  print_header "deborphan" "Localiza pacotes órfãos no sistema"
  print_details "https://packages.debian.org/deborphan" \
    "Encontra bibliotecas e pacotes que não são mais dependências" \
    "Ajuda a liberar espaço removendo pacotes obsoletos" \
    "Uso: deborphan | xargs sudo apt remove -y"
  sudo apt install -y deborphan
  log_success "deborphan instalado"
}

install_lm_sensors() {
  # https://github.com/lm-sensors/lm-sensors
  print_header "lm-sensors" "Monitoramento de temperatura da CPU/GPU"
  print_details "https://github.com/lm-sensors/lm-sensors" \
    "Detecta e exibe sensores de temperatura, voltagem e ventoinha" \
    "Configuração automática com sensors-detect" \
    "Uso: sensors (exibe temperaturas em tempo real)"
  sudo apt install -y lm-sensors
  sudo sensors-detect --auto 2>/dev/null || true
  log_success "lm-sensors instalado"
}

install_ufw() {
  # https://help.ubuntu.com/community/UFW
  print_header "UFW" "Firewall simples para Ubuntu"
  print_details "https://help.ubuntu.com/community/UFW" \
    "Firewall gerenciável com regras simples (allow/deny)" \
    "Proteção padrão contra portas abertas, logs de conexões" \
    "Uso: sudo ufw enable, sudo ufw allow 22/tcp"
  sudo apt install -y ufw
  sudo ufw --force enable 2>/dev/null || true
  log_success "UFW instalado e habilitado"
}

install_unattended_upgrades() {
  # https://wiki.debian.org/UnattendedUpgrades
  print_header "Unattended Upgrades" "Atualizações automáticas de segurança"
  print_details "https://wiki.debian.org/UnattendedUpgrades" \
    "Baixa e instala atualizações críticas de segurança automaticamente" \
    "Configurável para incluir todos os pacotes do repositório" \
    "Uso: configuração automática, logs em /var/log/unattended-upgrades/"
  sudo apt install -y unattended-upgrades
  sudo dpkg-reconfigure -f noninteractive unattended-upgrades 2>/dev/null || true
  log_success "Unattended Upgrades configurado"
}

_run_tools_ubuntu_total=8

run_tools_ubuntu() {
  init_module_progress $_run_tools_ubuntu_total "Tools Ubuntu"
  track "TOOLS_UBUNTU" install_nala "Nala"
  track "TOOLS_UBUNTU" install_neofetch "Neofetch"
  track "TOOLS_UBUNTU" install_ncdu "ncdu"
  track "TOOLS_UBUNTU" install_duf "duf"
  track "TOOLS_UBUNTU" install_deborphan "deborphan"
  track "TOOLS_UBUNTU" install_lm_sensors "lm-sensors"
  track "TOOLS_UBUNTU" install_ufw "UFW"
  track "TOOLS_UBUNTU" install_unattended_upgrades "Unattended Upgrades"
  end_module_progress
}
