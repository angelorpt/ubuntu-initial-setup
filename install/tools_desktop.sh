install_flameshot() {
  # https://flameshot.org/
  print_header "Flameshot" "Ferramenta de captura de tela com anotações"
  print_details "https://flameshot.org" \
    "Captura de tela com editor embutido: setas, caixas, blur, texto" \
    "Upload para imgur, clipboard automático, atalhos globais" \
    "Uso: flameshot gui (captura interativa)"
  sudo apt install flameshot -y
  log_success "Flameshot instalado"
}

install_espanso() {
  # https://espanso.org/docs/install/linux/
  print_header "Espanso" "Expansor de texto para produtividade"
  print_details "https://espanso.org" \
    "Substitui atalhos por texto completo: :email → user@gmail.com" \
    "Match triggers, scripts embutidos, pacotes pré-definidos da comunidade" \
    "Uso: digitar :trigger expande automaticamente"
  ensure_snap
  sudo snap install espanso --classic
  log_success "Espanso instalado"
}

install_hyperkeys() {
  # https://github.com/xurei/hyperkeys/releases
  print_header "HyperKeys" "Atalhos de teclado personalizados"
  print_details "https://hyperkeys.xureilab.com" \
    "Cria atalhos customizados para abrir apps, scripts e URLs" \
    "Interface visual para configurar combinações de teclas" \
    "Uso: configurar pelo AppImage em ~/Progs"
  sudo apt install libfuse2 -y
  local tag url
  tag=$(curl -s https://api.github.com/repos/xurei/hyperkeys/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  if [ -z "$tag" ]; then
    log_error "Não foi possível obter a versão mais recente do HyperKeys"
    return 1
  fi
  url="https://github.com/xurei/hyperkeys/releases/download/${tag}/HyperKeys-${tag#v}.AppImage"
  pushd /tmp > /dev/null
  wget -q -O HyperKeys.AppImage "$url"
  chmod 755 HyperKeys.AppImage
  mkdir -p "$HOME/Progs"
  cp HyperKeys.AppImage "$HOME/Progs"
  popd > /dev/null
  log_success "HyperKeys ${tag#v} instalado em ~/Progs"
}

install_imwheel() {
  # https://imwheel.sourceforge.net/
  print_header "IMWheel" "Ajuste de velocidade do scroll do mouse"
  print_details "https://imwheel.sourceforge.net" \
    "Acelera o scroll do mouse em aplicações (navegador, terminal)" \
    "Configura por ~/.imwheelrc com sensibilidade personalizada" \
    "Uso: imwheel (iniciar), imwheel -k (matar)"
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
  print_details "https://gparted.org" \
    "Redimensiona, move, cria e deleta partições (ext4, ntfs, fat)" \
    "Interface gráfica com preview das operações antes de aplicar" \
    "Uso: sudo gparted"
  sudo apt-get install -y gparted
  log_success "GParted instalado"
}

install_waveterm() {
  # https://www.waveterm.dev/download
  print_header "Wave Terminal" "Terminal moderno com widgets integrados"
  print_details "https://www.waveterm.dev" \
    "Terminal com blocos de saída, preview de imagens/links/HTML" \
    "Suporte a sessões, abas, busca visual e histórico rico" \
    "Uso: wave"
  local url
  url=$(curl -s https://www.waveterm.dev/download | grep -o 'https://dl.waveterm.dev/releases-w2/waveterm-linux-amd64-[0-9.]\+\.deb' | head -1)
  if [ -z "$url" ]; then
    log_error "Não foi possível obter URL do Wave Terminal"
    return 1
  fi
  pushd /tmp > /dev/null
  wget -q -O waveterm.deb "$url"
  sudo apt install -y ./waveterm.deb
  popd > /dev/null
  log_success "Wave Terminal instalado"
}

install_warpreminal() {
  # https://www.warp.dev/download
  print_header "Warp Terminal" "Terminal moderno com IA integrada"
  print_details "https://www.warp.dev" \
    "Terminal com IA para explicar erros e sugerir comandos" \
    "Blocos de comando, histórico pesquisável, worktrees" \
    "Uso: warp"

  if command -v warp &>/dev/null; then
    log_info "Warp Terminal já instalado: $(warp --version 2>&1 | head -1)"
    return 0
  fi

  pushd /tmp > /dev/null
  local url="https://app.warp.dev/download/linux/deb"
  log_info "↪ Baixando: $url"
  wget -q -O warp.deb "$url" || { log_error "Falha ao baixar Warp Terminal"; popd > /dev/null; return 1; }
  sudo apt install -y ./warp.deb || { log_error "Falha ao instalar Warp Terminal"; popd > /dev/null; return 1; }
  rm -f warp.deb
  popd > /dev/null
  log_success "Warp Terminal instalado"
}

install_drawio() {
  # https://github.com/jgraph/drawio-desktop/releases
  print_header "Draw.io" "Editor de diagramas e fluxogramas"
  print_details "https://www.drawio.com" \
    "Cria diagramas UML, fluxogramas, mapas mentais, wireframes" \
    "Exporta para PNG, SVG, PDF; integra com Google Drive e Git" \
    "Uso: drawio"
  local tag url
  tag=$(curl -s https://api.github.com/repos/jgraph/drawio-desktop/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  [ -z "$tag" ] && log_error "Não foi possível obter versão do Draw.io" && return 1
  url="https://github.com/jgraph/drawio-desktop/releases/download/${tag}/drawio-amd64-${tag#v}.deb"
  pushd /tmp > /dev/null
  wget -q -O drawio.deb "$url"
  sudo dpkg -i drawio.deb 2>/dev/null || true
  sudo apt install -f -y
  popd > /dev/null
  log_success "Draw.io ${tag#v} instalado"
}

install_dbeaver() {
  # https://snapcraft.io/dbeaver-ce
  print_header "DBeaver" "Gerenciador de bancos de dados universal"
  print_details "https://dbeaver.io" \
    "Conecta em MySQL, PostgreSQL, SQLite, Oracle, SQL Server, etc" \
    "Editor SQL com autocomplete, visualizador de schema, exportação" \
    "Uso: dbeaver-ce (ou DBeaver no menu)"
  ensure_snap
  sudo snap install dbeaver-ce --classic
  log_success "DBeaver instalado"
}

install_stacer() {
  # https://github.com/oguzhaninan/Stacer
  print_header "Stacer" "Otimizador e monitor do sistema"
  print_details "https://github.com/oguzhaninan/Stacer" \
    "Limpa cache, desinstala pacotes, gerencia serviços e apps de inicio" \
    "Monitor de CPU/RAM/disco em tempo real" \
    "Uso: stacer (ou Stacer no menu)"
  sudo apt install -y stacer
  log_success "Stacer instalado"
}

install_bleachbit() {
  # https://www.bleachbit.org/
  print_header "BleachBit" "Limpeza de cache e lixo do sistema"
  print_details "https://www.bleachbit.org" \
    "Limpa cache do navegador, APT, logs, lixeira e temporários" \
    "Modo seco (preview) antes de deletar, regras customizáveis" \
    "Uso: bleachbit --clean system.cache system.tmp"
  sudo apt install -y bleachbit
  log_success "BleachBit instalado"
}

install_timeshift() {
  # https://github.com/linuxmint/timeshift
  print_header "Timeshift" "Backup incremental do sistema com snapshots"
  print_details "https://github.com/linuxmint/timeshift" \
    "Snapshots do sistema (rsync ou btrfs) para recuperação rápida" \
    "Agendamento automático, restauração via boot menu" \
    "Uso: sudo timeshift --create --comments 'antes da atualização'"
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
