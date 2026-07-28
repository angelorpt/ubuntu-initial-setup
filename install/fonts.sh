install_firacode() {
  # https://packages.ubuntu.com/fonts-firacode
  print_header "Fira Code" "Fonte monoespaçada com ligaduras para programação"
  print_details "https://github.com/tonsky/FiraCode" \
    "Ligaduras de programação: -> ⟶ →, != ⟶ ≠, >= ⟶ ≥" \
    "Suporte a Powerline, hinting otimizado para telas" \
    "Uso: configurar no terminal e editor como fonte padrão"
  sudo apt install -y fonts-firacode
  log_success "Fira Code instalado"
}

install_jetbrains_mono() {
  # https://packages.ubuntu.com/fonts-jetbrains-mono
  print_header "JetBrains Mono" "Fonte para programação desenhada pela JetBrains"
  print_details "https://www.jetbrains.com/lp/mono" \
    "Desenhada para legibilidade em longas horas de código" \
    "Letras claramente distinguíveis (I/l/1), peso variável" \
    "Uso: configurar IDE JetBrains, VSCode ou terminal"
  sudo apt install -y fonts-jetbrains-mono
  log_success "JetBrains Mono instalado"
}

install_cascadia_code() {
  # https://packages.ubuntu.com/fonts-cascadia-code
  print_header "Cascadia Code" "Fonte monoespaçada da Microsoft com ligaduras"
  print_details "https://github.com/microsoft/cascadia-code" \
    "Ligaduras estilosas, suporte Powerline, peso variável" \
    "Design moderno da Microsoft para Windows Terminal e VSCode" \
    "Uso: configurar no terminal, VSCode ou qualquer editor"
  sudo apt install -y fonts-cascadia-code
  log_success "Cascadia Code instalado"
}

install_ibm_plex() {
  # https://packages.ubuntu.com/fonts-ibm-plex
  print_header "IBM Plex Mono" "Família de fontes da IBM com design elegante"
  print_details "https://www.ibm.com/plex" \
    "Família completa: Mono, Sans, Serif, Sans Condensed" \
    "Design corporativo da IBM com excelente legibilidade" \
    "Uso: configurar no editor ou terminal como mono ou sans-serif"
  sudo apt install -y fonts-ibm-plex
  log_success "IBM Plex instalado"
}

install_victor_mono() {
  # https://github.com/rubjo/victor-mono
  print_header "Victor Mono" "Fonte com itálico cursivo e ligaduras"
  print_details "https://rubjo.github.io/victor-mono" \
    "Itálico cursivo único que se destaca em comentários e strings" \
    "Ligaduras de código, suporte Powerline, semi-condensada" \
    "Uso: configurar no VSCode para ver itálico cursivo em markdown"
  local fonts_dir="${HOME}/.local/share/fonts"
  mkdir -p "$fonts_dir"
  local tag url
  tag=$(curl -s https://api.github.com/repos/rubjo/victor-mono/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  [ -z "$tag" ] && log_error "Não foi possível obter versão do Victor Mono" && return 1
  url="https://github.com/rubjo/victor-mono/releases/download/${tag}/VictorMonoAll.zip"
  pushd /tmp > /dev/null
  wget -q -O victormono.zip "$url"
  unzip -o -q victormono.zip -d victormono
  cp victormono/*.ttf "$fonts_dir/" 2>/dev/null || true
  rm -rf victormono victormono.zip
  popd > /dev/null
  fc-cache -f
  log_success "Victor Mono ${tag#v} instalado em $fonts_dir"
}

install_monaspace() {
  # https://github.com/githubnext/monaspace
  print_header "Monaspace" "Família de fontes do GitHub com 5 variantes"
  print_details "https://monaspace.githubnext.com" \
    "5 variantes: Neon (padrão), Radon, Krypton, Xenon, Argon" \
    "Texturas adaptáveis que funcionam juntas no mesmo código" \
    "Uso: configurar Neon como principal, variantes para destaques"
  local fonts_dir="${HOME}/.local/share/fonts"
  mkdir -p "$fonts_dir"
  local tag url
  tag=$(curl -s https://api.github.com/repos/githubnext/monaspace/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  [ -z "$tag" ] && log_error "Não foi possível obter versão do Monaspace" && return 1
  url="https://github.com/githubnext/monaspace/releases/download/${tag}/monaspace-${tag#v}.zip"
  pushd /tmp > /dev/null
  wget -q -O monaspace.zip "$url"
  unzip -o -q monaspace.zip -d monaspace
  find monaspace -name '*.ttf' -exec cp {} "$fonts_dir/" \; 2>/dev/null || true
  rm -rf monaspace monaspace.zip
  popd > /dev/null
  fc-cache -f
  log_success "Monaspace ${tag#v} instalado em $fonts_dir"
}

_run_fonts_total=6

run_fonts() {
  init_module_progress $_run_fonts_total "Fonts"
  track "FONTS" install_firacode "Fira Code"
  track "FONTS" install_jetbrains_mono "JetBrains Mono"
  track "FONTS" install_cascadia_code "Cascadia Code"
  track "FONTS" install_ibm_plex "IBM Plex"
  track "FONTS" install_victor_mono "Victor Mono"
  track "FONTS" install_monaspace "Monaspace"
  end_module_progress
}
