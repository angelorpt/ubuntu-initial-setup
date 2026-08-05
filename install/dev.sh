install_python() {
  # https://www.python.org/
  print_header "Python" "Linguagem de programação — versão do repositório Ubuntu"
  print_details "https://www.python.org" \
    "Linguagem versátil usada em scripts, web, IA e automação" \
    "Inclui Python3, pip (gerenciador de pacotes) e venv (ambientes virtuais)" \
    "Uso: python3 script.py, pip install pacote"
  sudo apt install -y python3 python3-pip python3-venv
  log_success "Python instalado: $(python3 --version 2>&1)"
}

install_docker() {
  # https://docs.docker.com/engine/install/ubuntu/
  print_header "Docker" "Plataforma de contêineres para desenvolvimento e deployment"
  print_details "https://docs.docker.com/engine/install/ubuntu" \
    "Contêineres leves e portáteis para rodar aplicações isoladas" \
    "Inclui Docker Engine, containerd e Docker Compose plugin" \
    "Uso: docker run nginx, docker compose up"
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
  print_header "NVM + Node" "Gerenciador de versões do Node.js"
  print_details "https://github.com/nvm-sh/nvm" \
    "NVM: instala e alterna entre múltiplas versões do Node.js" \
    "Node LTS: runtime JavaScript do lado do servidor" \
    "Uso: nvm use 20, nvm install --lts, node app.js"
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
  print_details "https://openjdk.org" \
    "JDK padrão do Ubuntu (OpenJDK) para desenvolvimento Java" \
    "Inclui compilador javac, runtime java e ferramentas" \
    "Uso: javac Arquivo.java, java Arquivo"
  sudo apt install default-jdk -y
  log_success "Java instalado: $(java -version 2>&1 | head -1)"
}

install_vscode() {
  # https://code.visualstudio.com/
  print_header "VSCode" "Editor de código da Microsoft"
  print_details "https://code.visualstudio.com" \
    "Editor multiplataforma com suporte a centenas de extensões" \
    "Terminal integrado, debugger, Git integrado, Intellisense" \
    "Uso: code . para abrir diretório atual"
  ensure_snap
  sudo snap install code --classic
  log_success "VSCode instalado"
}

install_go() {
  # https://snapcraft.io/go
  print_header "Go" "Linguagem de programação compilada"
  print_details "https://snapcraft.io/go" \
    "Linguagem do Google focada em concorrência e performance" \
    "Compilação rápida, tipagem estática, goroutines" \
    "Uso: go run main.go, go build"
  ensure_snap
  sudo snap install go --classic
  log_success "Go instalado"
}

install_postman() {
  # https://snapcraft.io/postman
  print_header "Postman" "Plataforma de API para desenvolvimento"
  print_details "https://snapcraft.io/postman" \
    "Testar, documentar e depurar APIs REST, GraphQL e SOAP" \
    "Collections, environments, testes automatizados (Newman)" \
    "Uso: criar requisições com headers, auth e body"
  ensure_snap
  sudo snap install postman
  log_success "Postman instalado"
}

install_virtualbox() {
  # https://www.virtualbox.org/wiki/Linux_Downloads
  print_header "VirtualBox" "Hipervisor de código aberto para virtualização"
  print_details "https://www.virtualbox.org" \
    "Roda máquinas virtuais com Linux, Windows, macOS como convidados" \
    "Suporte a snapshots, pastas compartilhadas, USB pass-through" \
    "Uso: VBoxManage startvm 'Minha VM', interface gráfica VirtualBox"

  local codename version page deb_name
  codename=$(lsb_release -sc 2>/dev/null)
  [ -z "$codename" ] && log_error "Não foi possível detectar versão do Ubuntu" && return 1

  version=$(curl -s https://download.virtualbox.org/virtualbox/ | grep -oP 'href="\K[0-9]+\.[0-9]+\.[0-9]+(?=/")' | sort -V | tail -1)
  [ -z "$version" ] && log_error "Não foi possível obter versão do VirtualBox" && return 1

  page=$(curl -s "https://download.virtualbox.org/virtualbox/${version}/")
  deb_name=$(echo "$page" | grep -oP "virtualbox-${version%.*}_[^\"]*~Ubuntu~${codename}[^\"]*_amd64\.deb" | head -1)
  [ -z "$deb_name" ] && log_error "VirtualBox não disponível para Ubuntu ${codename}" && return 1

  pushd /tmp > /dev/null
  wget -q "https://download.virtualbox.org/virtualbox/${version}/${deb_name}" -O virtualbox.deb
  sudo dpkg -i virtualbox.deb 2>/dev/null || true
  sudo apt install -f -y
  popd > /dev/null
  log_success "VirtualBox ${version} instalado"
}

install_antigravity2() {
  # https://storage.googleapis.com/antigravity-public/antigravity-hub/2.4.2-6711062033203200/linux-x64/Antigravity.tar.gz
  print_header "Antigravity 2.0" "Plataforma de desenvolvimento agente-first do Google"
  print_details "https://antigravity.google/download" \
    "Antigravity Hub: interface visual central para seu workspace agente-first" \
    "Integração com ferramentas do Google (Gemini, Cloud, IDEs)" \
    "Uso: Antigravity para gerenciar agentes e fluxos de trabalho"

  log_info "Limpando instalações anteriores de Antigravity..."
  sudo rm -f /usr/local/bin/antigravity || true
  sudo rm -rf /opt/antigravity || true

  pushd /tmp > /dev/null || return 1
  local url
  url=$(curl -s https://antigravity.google/download | grep -oP 'https://storage\.googleapis\.com/antigravity-public/antigravity-hub/[^"]*/linux-x64/Antigravity\.tar\.gz' | head -1)
  if [ -z "$url" ]; then
    log_error "Não foi possível obter URL do Antigravity 2.0"
    popd > /dev/null
    return 1
  fi

  log_info "Baixando Antigravity 2.0..."
  if ! wget -q -O antigravity.tar.gz "$url"; then
    log_error "Falha ao baixar o Antigravity 2.0"
    popd > /dev/null
    return 1
  fi

  log_info "Extraindo Antigravity 2.0..."
  local extract_dir
  extract_dir="antigravity_extract_$$"
  mkdir -p "$extract_dir"
  if ! tar -xzf antigravity.tar.gz -C "$extract_dir"; then
    log_error "Falha ao extrair o Antigravity 2.0"
    rm -rf "$extract_dir" antigravity.tar.gz
    popd > /dev/null
    return 1
  fi

  local extracted_folder
  extracted_folder=$(find "$extract_dir" -mindepth 1 -maxdepth 1 -type d | head -1)
  if [ -z "$extracted_folder" ]; then
    log_error "Pasta extraída do Antigravity 2.0 não encontrada"
    rm -rf "$extract_dir" antigravity.tar.gz
    popd > /dev/null
    return 1
  fi

  log_info "Instalando Antigravity 2.0 em /opt/antigravity..."
  if ! sudo mv "$extracted_folder" /opt/antigravity; then
    log_error "Falha ao mover Antigravity 2.0 para /opt/antigravity"
    rm -rf "$extract_dir" antigravity.tar.gz
    popd > /dev/null
    return 1
  fi

  rm -rf "$extract_dir" antigravity.tar.gz
  popd > /dev/null || return 1

  log_info "Criando link simbólico para Antigravity..."
  if ! sudo ln -sf /opt/antigravity/antigravity /usr/local/bin/antigravity; then
    log_error "Falha ao criar link simbólico /usr/local/bin/antigravity"
    return 1
  fi

  log_success "Antigravity 2.0 instalado"
}

install_antigravity_ide() {
  # https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/2.1.1-6123990880747520/linux-x64/Antigravity%20IDE.tar.gz
  print_header "Antigravity IDE" "IDE para desenvolvimento agente-first"
  print_details "https://antigravity.google/download" \
    "Ambiente de desenvolvimento integrado com suporte nativo a agentes" \
    "Baseado no VS Code com extensões exclusivas Antigravity" \
    "Uso: Antigravity IDE para codificar com assistência de IA integrada"

  log_info "Limpando instalações anteriores do Antigravity IDE..."
  sudo rm -f /usr/local/bin/antigravity-ide || true
  sudo rm -rf /opt/antigravity-ide || true

  pushd /tmp > /dev/null || return 1
  local url
  url=$(curl -s https://antigravity.google/download | grep -oP 'https://edgedl\.me\.gvt1\.com/edgedl/release2/[^"]*/linux-x64/Antigravity%20IDE\.tar\.gz' | head -1)
  if [ -z "$url" ]; then
    log_error "Não foi possível obter URL do Antigravity IDE"
    popd > /dev/null
    return 1
  fi

  log_info "Baixando Antigravity IDE..."
  if ! wget -q -O antigravity-ide.tar.gz "$url"; then
    log_error "Falha ao baixar o Antigravity IDE"
    popd > /dev/null
    return 1
  fi

  log_info "Extraindo Antigravity IDE..."
  local extract_dir
  extract_dir="antigravity_ide_extract_$$"
  mkdir -p "$extract_dir"
  if ! tar -xzf antigravity-ide.tar.gz -C "$extract_dir"; then
    log_error "Falha ao extrair o Antigravity IDE"
    rm -rf "$extract_dir" antigravity-ide.tar.gz
    popd > /dev/null
    return 1
  fi

  local extracted_folder
  extracted_folder=$(find "$extract_dir" -mindepth 1 -maxdepth 1 -type d | head -1)
  if [ -z "$extracted_folder" ]; then
    log_error "Pasta extraída do Antigravity IDE não encontrada"
    rm -rf "$extract_dir" antigravity-ide.tar.gz
    popd > /dev/null
    return 1
  fi

  log_info "Instalando Antigravity IDE em /opt/antigravity-ide..."
  if ! sudo mv "$extracted_folder" /opt/antigravity-ide; then
    log_error "Falha ao mover Antigravity IDE para /opt/antigravity-ide"
    rm -rf "$extract_dir" antigravity-ide.tar.gz
    popd > /dev/null
    return 1
  fi

  rm -rf "$extract_dir" antigravity-ide.tar.gz
  popd > /dev/null || return 1

  log_info "Criando link simbólico para Antigravity IDE..."
  local ide_bin=""
  if [ -f "/opt/antigravity-ide/bin/antigravity-ide" ]; then
    ide_bin="/opt/antigravity-ide/bin/antigravity-ide"
  elif [ -f "/opt/antigravity-ide/antigravity-ide" ]; then
    ide_bin="/opt/antigravity-ide/antigravity-ide"
  else
    ide_bin=$(find /opt/antigravity-ide -type f -name "antigravity-ide" | head -1)
  fi

  if [ -z "$ide_bin" ]; then
    log_error "Executável antigravity-ide não encontrado em /opt/antigravity-ide"
    return 1
  fi

  if ! sudo ln -sf "$ide_bin" /usr/local/bin/antigravity-ide; then
    log_error "Falha ao criar link simbólico /usr/local/bin/antigravity-ide"
    return 1
  fi

  log_success "Antigravity IDE instalado"
}

install_terraform() {
  # https://developer.hashicorp.com/terraform/install#linux
  print_header "Terraform" "Infraestrutura como código pela HashiCorp"
  print_details "https://developer.hashicorp.com/terraform/install#linux" \
    "Define e provisiona infraestrutura (AWS, GCP, Azure, Docker) via código" \
    "Planos de execução, grafos de dependência, gerenciamento de estado" \
    "Uso: terraform init, terraform plan, terraform apply"
  sudo mkdir -p /etc/apt/keyrings
  wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
  sudo apt update && sudo apt install -y terraform
  log_success "Terraform instalado: $(terraform --version 2>&1 | head -1)"
}

install_vagrant() {
  # https://developer.hashicorp.com/vagrant/install#linux
  print_header "Vagrant" "Ambientes de desenvolvimento reproduzíveis"
  print_details "https://developer.hashicorp.com/vagrant/install" \
    "Cria e gerencia ambientes de desenvolvimento reproduzíveis" \
    "Compatível com VirtualBox, KVM, Docker como providers" \
    "Uso: vagrant init, vagrant up, vagrant ssh"
  sudo mkdir -p /etc/apt/keyrings
  wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
  sudo apt update && sudo apt install -y vagrant
  log_success "Vagrant instalado: $(vagrant --version 2>&1 | head -1)"
}

install_github_cli() {
  # https://cli.github.com/
  print_header "GitHub CLI" "CLI oficial do GitHub"
  print_details "https://cli.github.com" \
    "Gerencia repositórios, issues, PRs, Actions e releases pelo terminal" \
    "Autenticação via gh auth login, fluxo completo de PRs" \
    "Uso: gh repo create, gh pr checkout 123, gh issue list"
  (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
  log_success "GitHub CLI instalado: $(gh --version 2>&1 | head -1)"
}

install_aws_cli() {
  # https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  print_header "AWS CLI" "CLI oficial da Amazon Web Services"
  print_details "https://aws.amazon.com/cli" \
    "Gerencia serviços AWS (EC2, S3, Lambda, IAM) via terminal" \
    "Autenticação via aws configure, scripts de automação" \
    "Uso: aws s3 ls, aws ec2 describe-instances"
  ensure_snap
  sudo snap install aws-cli --classic
  log_success "AWS CLI instalado: $(aws --version 2>&1)"
}

install_ansible() {
  # https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html
  print_header "Ansible" "Automação de infraestrutura"
  print_details "https://www.ansible.com" \
    "Automação de configuração, deploy e orquestração sem agente" \
    "Playbooks em YAML, inventário de servidores, módulos reutilizáveis" \
    "Uso: ansible-playbook playbook.yml -i inventory.ini"
  sudo apt update
  sudo apt install -y software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install -y ansible
  log_success "Ansible instalado: $(ansible --version 2>&1 | head -1)"
}

install_build_essential() {
  # https://packages.ubuntu.com/build-essential
  print_header "build-essential" "Meta-pacote com gcc, g++, make e ferramentas de compilação"
  print_details "https://packages.ubuntu.com/build-essential" \
    "Pacote essencial para compilar qualquer software C/C++" \
    "Inclui GCC, G++, Make, Diffutils, libc-dev" \
    "Pré-requisito para pacotes via pip, npm nativos e kernels"
  sudo apt install -y build-essential
  log_success "build-essential instalado: $(gcc --version 2>&1 | head -1)"
}

install_libssl_dev() {
  # https://packages.ubuntu.com/libssl-dev
  print_header "libssl-dev" "Headers do OpenSSL para compilação de pacotes"
  print_details "https://packages.ubuntu.com/libssl-dev" \
    "Headers e bibliotecas de desenvolvimento do OpenSSL" \
    "Necessário para compilar softwares que usam HTTPS/TLS" \
    "Pré-requisito comum: Python nativo, Node.js, Rust, curl customizado"
  sudo apt install -y libssl-dev
  log_success "libssl-dev instalado"
}

install_kubectl() {
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
  print_header "kubectl" "CLI oficial do Kubernetes"
  print_details "https://kubernetes.io" \
    "Gerencia clusters Kubernetes: pods, services, deployments" \
    "Comandos para aplicar manifestos, debugar pods, escalar cargas" \
    "Uso: kubectl get pods, kubectl apply -f deployment.yaml"
  pushd /tmp > /dev/null
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
  popd > /dev/null
  log_success "kubectl instalado: $(kubectl version --client 2>&1 | head -1)"
}

install_helm() {
  # https://helm.sh/docs/intro/install/
  print_header "Helm" "Gerenciador de pacotes Kubernetes"
  print_details "https://helm.sh" \
    "Empacota, versiona e deploya aplicações Kubernetes como Charts" \
    "Repositórios públicos (Artifact Hub), templates Go, rollbacks" \
    "Uso: helm install nome chart, helm upgrade repo/chart"
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  log_success "Helm instalado: $(helm version 2>&1 | head -1)"
}

install_minikube() {
  # https://minikube.sigs.k8s.io/docs/start/
  print_header "Minikube" "Kubernetes single-node local para estudos"
  print_details "https://minikube.sigs.k8s.io" \
    "Roda cluster Kubernetes completo em VM ou Docker local" \
    "Ideal para desenvolvimento, aprendizado e testes offline" \
    "Uso: minikube start, minikube dashboard, minikube stop"
  pushd /tmp > /dev/null
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  popd > /dev/null
  log_success "Minikube instalado: $(minikube version 2>&1 | head -1)"
}

install_kiro_cli() {
  # https://kiro.dev/cli/
  print_header "Kiro CLI" "CLI da plataforma Kiro"
  print_details "https://kiro.dev/cli" \
    "Interface de linha de comando para a plataforma de deploy Kiro" \
    "Deploy rápido de aplicações com um único comando" \
    "Uso: kiro deploy, kiro logs, kiro status"
  curl -fsSL https://cli.kiro.dev/install | bash
  log_success "Kiro CLI instalado"
}

install_shellcheck() {
  # https://www.shellcheck.net/
  print_header "ShellCheck" "Análise estática para scripts shell"
  print_details "https://www.shellcheck.net" \
    "Detecta erros de sintaxe, escaping e variáveis não utilizadas" \
    "Integra com editores (VSCode, Vim, Emacs) via LSP" \
    "Uso: shellcheck meu_script.sh"
  sudo apt install -y shellcheck
  log_success "ShellCheck instalado: $(shellcheck --version 2>&1 | head -1)"
}

install_bats() {
  # https://bats-core.readthedocs.io/
  print_header "BATS" "Testes automatizados para Bash"
  print_details "https://github.com/bats-core/bats-core" \
    "Framework de testes estilo TDD/BDD para scripts shell" \
    "Suporte a asserções (assert_equal, assert_output, assert_failure)" \
    "Uso: bats tests/"
  sudo apt install -y bats
  log_success "BATS instalado: $(bats --version 2>&1)"
}

_run_dev_total=23

run_dev() {
  init_module_progress $_run_dev_total "Dev"
  track "DEV" install_build_essential "build-essential"
  track "DEV" install_libssl_dev "libssl-dev"
  track "DEV" install_python "Python"
  track "DEV" install_docker "Docker"
  track "DEV" install_nvm "NVM + Node"
  track "DEV" install_java "Java (JDK)"
  track "DEV" install_vscode "VSCode"
  track "DEV" install_go "Go"
  track "DEV" install_postman "Postman"
  track "DEV" install_virtualbox "VirtualBox"
  track "DEV" install_antigravity2 "Antigravity 2.0"
  track "DEV" install_antigravity_ide "Antigravity IDE"
  track "DEV" install_terraform "Terraform"
  track "DEV" install_vagrant "Vagrant"
  track "DEV" install_github_cli "GitHub CLI"
  track "DEV" install_aws_cli "AWS CLI"
  track "DEV" install_ansible "Ansible"
  track "DEV" install_kubectl "kubectl"
  track "DEV" install_helm "Helm"
  track "DEV" install_minikube "Minikube"
  track "DEV" install_kiro_cli "Kiro CLI"
  track "DEV" install_shellcheck "ShellCheck"
  track "DEV" install_bats "BATS"
  end_module_progress
}
