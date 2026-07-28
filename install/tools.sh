install_flameshot() {
  print_header "Flameshot" "Ferramenta de captura de tela com anotações"
  sudo apt install flameshot -y
  log_success "Flameshot instalado"
}

install_espanso() {
  print_header "Espanso" "Expansor de texto para produtividade"
  sudo apt-get update
  sudo apt-get install -y xclip
  sudo snap install espanso --classic
  log_success "Espanso instalado"
}

install_hyperkeys() {
  # https://hyperkeys.xureilab.com/download
  print_header "HyperKeys" "Atalhos de teclado personalizados — https://hyperkeys.xureilab.com/download"
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
  print_header "IMWheel" "Ajuste de velocidade do scroll do mouse"
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
  print_header "GParted" "Gerenciador de partições de disco"
  sudo apt-get install -y gparted
  log_success "GParted instalado"
}

install_waveterm() {
  # https://www.waveterm.dev/download
  print_header "Wave Terminal" "Terminal moderno com widgets integrados — https://www.waveterm.dev"
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
  cd /tmp
  wget -q -O warp.deb "https://app.warp.dev/get_warp?package=deb"
  sudo apt install -y ./warp.deb
  log_success "Warp Terminal instalado"
}

install_superfile() {
  # https://superfile.dev/getting-started/installation/
  print_header "Superfile" "Gerenciador de arquivos no terminal — https://superfile.dev"
  bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
  log_success "Superfile instalado"
}

run_tools() {
  install_flameshot
  install_espanso
  install_hyperkeys
  install_imwheel
  install_gparted
  install_waveterm
  install_warpreminal
  install_superfile
}
