install_docker() {
  # https://docs.docker.com/engine/install/ubuntu/
  print_header "Docker" "Plataforma de contêineres para desenvolvimento e deployment"
  log_info "↪ https://docs.docker.com/engine/install/ubuntu/"
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
  # https://github.com/nvm-sh/nvm#installing-and-updating
  print_header "NVM + Node" "Gerenciador de versões do Node.js — https://github.com/nvm-sh/nvm"
  log_info "↪ https://github.com/nvm-sh/nvm#installing-and-updating"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
  log_success "NVM + Node LTS instalado"
}

install_java() {
  # https://openjdk.org/
  print_header "Java (JDK)" "Kit de desenvolvimento Java padrão"
  log_info "↪ https://openjdk.org/"
  sudo apt install default-jdk -y
  log_success "Java instalado: $(java -version 2>&1 | head -1)"
}

install_vscode() {
  # https://code.visualstudio.com/
  print_header "VSCode" "Editor de código da Microsoft"
  log_info "↪ https://code.visualstudio.com/"
  sudo snap install code --classic
  log_success "VSCode instalado"
}

install_go() {
  # https://snapcraft.io/go
  print_header "Go" "Linguagem de programação compilada — https://snapcraft.io/go"
  log_info "↪ https://snapcraft.io/go"
  sudo snap install go --classic
  log_success "Go instalado"
}

install_postman() {
  # https://snapcraft.io/postman
  print_header "Postman" "Plataforma de API para desenvolvimento — https://snapcraft.io/postman"
  log_info "↪ https://snapcraft.io/postman"
  sudo snap install postman
  log_success "Postman instalado"
}

install_antigravity2() {
  # https://storage.googleapis.com/antigravity-public/antigravity-hub/2.4.2-6711062033203200/linux-x64/Antigravity.tar.gz
  print_header "Antigravity 2.0" "Plataforma de desenvolvimento agente-first do Google — https://antigravity.google"
  log_info "↪ https://antigravity.google/download"
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
  # https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/2.1.1-6123990880747520/linux-x64/Antigravity%20IDE.tar.gz
  print_header "Antigravity IDE" "IDE para desenvolvimento agente-first — https://antigravity.google"
  log_info "↪ https://antigravity.google/download"
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
  install_go
  install_postman
  install_antigravity2
  install_antigravity_ide
}
