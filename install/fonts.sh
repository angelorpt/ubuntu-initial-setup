install_firacode() {
  print_header "Fira Code" "Fonte monoespaçada com ligaduras para programação"

  local fonts_dir="${HOME}/.local/share/fonts"
  mkdir -p "$fonts_dir"

  cd /tmp
  local version="5.2"
  local zip="Fira_Code_v${version}.zip"
  curl -fsSL --location --show-error \
    "https://github.com/tonsky/FiraCode/releases/download/${version}/${zip}" \
    --output "$zip"
  unzip -o -q -d "$fonts_dir" "$zip"
  rm "$zip"
  fc-cache -f

  log_success "Fira Code instalado em $fonts_dir"
}

run_fonts() {
  install_firacode
}
