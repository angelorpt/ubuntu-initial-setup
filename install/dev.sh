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
  print_header "NVM + Node" "Gerenciador de versões do Node.js"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 18
  nvm install 20
  nvm alias default 20
  log_success "NVM + Node 18/20 instalado"
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

run_dev() {
  install_docker
  install_nvm
  install_java
  install_vscode
}
