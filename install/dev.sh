install_docker() {
  print_header "Docker" "Plataforma de contêineres para desenvolvimento e deployment"
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg" 2>/dev/null || true
  done
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo groupadd docker 2>/dev/null || true
  sudo usermod -aG docker "$USER"
  log_success "Docker instalado"
}

install_nvm() {
  print_header "NVM + Node" "Gerenciador de versões do Node.js — https://github.com/nvm-sh/nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
  log_success "NVM + Node LTS instalado"
}

install_java() {
  print_header "Java (JDK)" "Kit de desenvolvimento Java padrão"
  sudo apt install default-jdk -y
  log_success "Java instalado: $(java -version 2>&1 | head -1)"
}

install_vscode() {
  print_header "VSCode" "Editor de código da Microsoft"
  sudo snap install code --classic
  log_success "VSCode instalado"
}

install_antigravity2() {
  print_header "Antigravity 2.0" "Plataforma de desenvolvimento agente-first do Google — https://antigravity.google"
  cd /tmp
  local url
  url=$(curl -s https://antigravity.google/download | grep -oP 'https://storage\.googleapis\.com/antigravity-public/antigravity-hub/[^"]*/linux-x64/Antigravity\.tar\.gz' | head -1)
  if [ -z "$url" ]; then
    log_error "Não foi possível obter URL do Antigravity 2.0"
    return 1
  fi
  wget -q -O antigravity.tar.gz "$url"
  sudo tar -xzf antigravity.tar.gz -C /opt
  log_success "Antigravity 2.0 instalado"
}

install_antigravity_ide() {
  print_header "Antigravity IDE" "IDE para desenvolvimento agente-first — https://antigravity.google"
  cd /tmp
  local url
  url=$(curl -s https://antigravity.google/download | grep -oP 'https://edgedl\.me\.gvt1\.com/edgedl/release2/[^"]*/linux-x64/Antigravity%20IDE\.tar\.gz' | head -1)
  if [ -z "$url" ]; then
    log_error "Não foi possível obter URL do Antigravity IDE"
    return 1
  fi
  wget -q -O antigravity-ide.tar.gz "$url"
  sudo tar -xzf antigravity-ide.tar.gz -C /opt
  log_success "Antigravity IDE instalado"
}

run_dev() {
  install_docker
  install_nvm
  install_java
  install_vscode
  install_antigravity2
  install_antigravity_ide
}
