install_firacode() {
  # https://github.com/tonsky/FiraCode/wiki/Linux-instructions#manual-installation
  print_header "Fira Code" "Fonte monoespaçada com ligaduras para programação — https://github.com/tonsky/FiraCode"

  local fonts_dir="${HOME}/.local/share/fonts"
  mkdir -p "$fonts_dir"

  cd /tmp
  local tag version zip
  tag=$(curl -s https://api.github.com/repos/tonsky/FiraCode/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  version="${tag#v}"
  zip="Fira_Code_v${version}.zip"
  curl -fsSL --location --show-error \
    "https://github.com/tonsky/FiraCode/releases/download/${version}/${zip}" \
    --output "$zip"
  unzip -o -q -d "$fonts_dir" "$zip"
  rm "$zip"
  fc-cache -f

  log_success "Fira Code ${version} instalado em $fonts_dir"
}

run_fonts() {
  install_firacode
}
