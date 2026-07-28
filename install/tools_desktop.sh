install_flameshot() {
  # https://flameshot.org/
  print_header "Flameshot" "Ferramenta de captura de tela com anotações"
  log_info "↪ https://flameshot.org/"
  sudo apt install flameshot -y
  log_success "Flameshot instalado"
}

install_espanso() {
  # https://espanso.org/docs/install/linux/
  print_header "Espanso" "Expansor de texto para produtividade"
  log_info "↪ https://espanso.org/docs/install/linux/"
  sudo apt-get update
  sudo apt-get install -y xclip
  sudo snap install espanso --classic
  log_success "Espanso instalado"
}

install_hyperkeys() {
  # https://github.com/xurei/hyperkeys/releases
  print_header "HyperKeys" "Atalhos de teclado personalizados — https://hyperkeys.xureilab.com/download"
  log_info "↪ https://github.com/xurei/hyperkeys/releases"
  sudo apt install libfuse2 -y
  local url tag
  tag=$(curl -s https://api.github.com/repos/xurei/hyperkeys/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  if [ -z "$tag" ]; then
    log_error "Não foi possível obter a versão mais recente do HyperKeys"
    return 1
  fi
  url="https://github.com/xurei/hyperkeys/releases/download/${tag}/HyperKeys-${tag#v}.AppImage"
  cd /tmp
  wget -q -O HyperKeys.AppImage "$url"
  chmod 755 HyperKeys.AppImage
  mkdir -p "$HOME/Progs"
  cp HyperKeys.AppImage "$HOME/Progs"
  log_success "HyperKeys ${tag#v} instalado em ~/Progs"
}

install_imwheel() {
  # https://imwheel.sourceforge.net/
  print_header "IMWheel" "Ajuste de velocidade do scroll do mouse"
  log_info "↪ https://imwheel.sourceforge.net/"
  sudo apt-get install -y imwheel libxcb-cursor0
  cat > "$HOME/.imwheelrc" << EOF
.*
None,      Up,   Button4, 3
None,      Down, Button5, 3
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
EOF
  imwheel
  log_success "IMWheel configurado"
}

install_gparted() {
  # https://gparted.org/
  print_header "GParted" "Gerenciador de partições de disco"
  log_info "↪ https://gparted.org/"
  sudo apt-get install -y gparted
  log_success "GParted instalado"
}

install_waveterm() {
  # https://www.waveterm.dev/download
  print_header "Wave Terminal" "Terminal moderno com widgets integrados — https://www.waveterm.dev"
  log_info "↪ https://www.waveterm.dev/download"
  local url
  url=$(curl -s https://www.waveterm.dev/download | grep -o 'https://dl.waveterm.dev/releases-w2/waveterm-linux-amd64-[0-9.]\+\.deb' | head -1)
  if [ -z "$url" ]; then
    log_error "Não foi possível obter URL do Wave Terminal"
    return 1
  fi
  cd /tmp
  wget -q -O waveterm.deb "$url"
  sudo apt install -y ./waveterm.deb
  log_success "Wave Terminal instalado"
}

install_warpreminal() {
  # https://www.warp.dev/download
  print_header "Warp Terminal" "Terminal moderno com IA integrada — https://www.warp.dev"
  log_info "↪ https://www.warp.dev/download"
  cd /tmp
  wget -q -O warp.deb "https://app.warp.dev/get_warp?package=deb"
  sudo apt install -y ./warp.deb
  log_success "Warp Terminal instalado"
}

install_drawio() {
  # https://github.com/jgraph/drawio-desktop/releases
  print_header "Draw.io" "Editor de diagramas e fluxogramas — https://www.drawio.com"
  log_info "↪ https://github.com/jgraph/drawio-desktop/releases"
  local tag url
  tag=$(curl -s https://api.github.com/repos/jgraph/drawio-desktop/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  [ -z "$tag" ] && log_error "Não foi possível obter versão do Draw.io" && return 1
  url="https://github.com/jgraph/drawio-desktop/releases/download/${tag}/drawio-amd64-${tag#v}.deb"
  cd /tmp
  wget -q -O drawio.deb "$url"
  sudo dpkg -i drawio.deb 2>/dev/null || true
  sudo apt install -f -y
  log_success "Draw.io ${tag#v} instalado"
}

install_dbeaver() {
  # https://snapcraft.io/dbeaver-ce
  print_header "DBeaver" "Gerenciador de bancos de dados universal — https://dbeaver.io"
  log_info "↪ https://snapcraft.io/dbeaver-ce"
  sudo snap install dbeaver-ce --classic
  log_success "DBeaver instalado"
}

install_stacer() {
  # https://github.com/oguzhaninan/Stacer
  print_header "Stacer" "Otimizador e monitor do sistema — https://github.com/oguzhaninan/Stacer"
  log_info "↪ https://github.com/oguzhaninan/Stacer"
  sudo apt install -y stacer
  log_success "Stacer instalado"
}

install_bleachbit() {
  # https://www.bleachbit.org/
  print_header "BleachBit" "Limpeza de cache e lixo do sistema — https://www.bleachbit.org"
  log_info "↪ https://www.bleachbit.org/"
  sudo apt install -y bleachbit
  log_success "BleachBit instalado"
}

install_timeshift() {
  # https://github.com/linuxmint/timeshift
  print_header "Timeshift" "Backup incremental do sistema com snapshots — https://github.com/linuxmint/timeshift"
  log_info "↪ https://github.com/linuxmint/timeshift"
  sudo apt install -y timeshift
  log_success "Timeshift instalado"
}

_run_tools_desktop_total=12

run_tools_desktop() {
  init_module_progress $_run_tools_desktop_total "Tools Desktop"
  track "TOOLS_DESKTOP" install_flameshot "Flameshot"
  track "TOOLS_DESKTOP" install_espanso "Espanso"
  track "TOOLS_DESKTOP" install_hyperkeys "HyperKeys"
  track "TOOLS_DESKTOP" install_imwheel "IMWheel"
  track "TOOLS_DESKTOP" install_gparted "GParted"
  track "TOOLS_DESKTOP" install_waveterm "Wave Terminal"
  track "TOOLS_DESKTOP" install_warpreminal "Warp Terminal"
  track "TOOLS_DESKTOP" install_drawio "Draw.io"
  track "TOOLS_DESKTOP" install_dbeaver "DBeaver"
  track "TOOLS_DESKTOP" install_stacer "Stacer"
  track "TOOLS_DESKTOP" install_bleachbit "BleachBit"
  track "TOOLS_DESKTOP" install_timeshift "Timeshift"
  end_module_progress
}
