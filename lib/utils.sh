die_on_error() {
  local rc=$?
  local msg="$1"
  local code="${2:-1}"
  if [ $rc -ne 0 ]; then
    log_error "$msg"
    exit "$code"
  fi
}

download_to_temp() {
  local url="$1"
  local dest
  dest=$(mktemp -d)
  cd "$dest" || return 1
  wget -q "$url" 2>/dev/null || curl -sLO "$url" 2>/dev/null
  echo "$dest"
}

install_deb() {
  local deb_path="$1"
  sudo dpkg -i "$deb_path" 2>/dev/null || true
  sudo apt install -f -y -q
}

ensure_whiptail() {
  if ! command -v whiptail &>/dev/null; then
    echo "Instalando whiptail..."
    sudo apt install -y whiptail
  fi
}

ensure_snap() {
  if ! command -v snap &>/dev/null; then
    log_info "Instalando snap..."
    sudo apt install -y snapd
  fi
}

ensure_flatpak() {
  if ! command -v flatpak &>/dev/null; then
    log_info "Instalando flatpak..."
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
}
