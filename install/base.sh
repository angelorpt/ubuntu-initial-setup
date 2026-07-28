install_curl() {
  # https://curl.se/
  print_header "Curl" "Ferramenta de transferência de dados via URL"
  print_details "https://curl.se" \
    "Suporta HTTP, HTTPS, FTP, SFTP e dezenas de protocolos" \
    "Usado por praticamente todo software que baixa conteúdo da web" \
    "Uso: curl https://exemplo.com/arquivo.txt -o arquivo.txt"
  sudo apt install curl -y
  log_success "Curl instalado"
}

install_git() {
  # https://git-scm.com/
  print_header "Git" "Sistema de controle de versão distribuído"
  print_details "https://git-scm.com" \
    "Gerencia versões de código com branches, merges e tags" \
    "Base do GitHub, GitLab e qualquer fluxo de desenvolvimento moderno" \
    "Uso: git clone, git add, git commit, git push"
  sudo apt install git-all -y
  log_success "Git instalado"
}

install_gum() {
  # https://github.com/charmbracelet/gum
  print_header "Gum" "Ferramenta de UI para shell scripts"
  print_details "https://github.com/charmbracelet/gum" \
    "Cria interfaces estilizadas no terminal (input, spinner, tabela)" \
    "Substitui diálogos whiptail com design moderno e cores" \
    "Uso: gum input --placeholder 'Digite seu nome'"
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt update && sudo apt install -y gum
  log_success "Gum instalado"
}

install_zsh() {
  # https://ohmyz.sh/
  print_header "Zsh + Oh My Zsh" "Terminal aprimorado com plugins e temas"
  print_details "https://ohmyz.sh" \
    "Zsh: shell interativo com autocomplete inteligente e correção ortográfica" \
    "Oh My Zsh: framework com centenas de plugins e temas prontos" \
    "Uso: chsh -s \$(which zsh) para definir como shell padrão"
  sudo apt install zsh -y
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  log_success "Zsh + Oh My Zsh instalado"
}

_run_base_total=4

run_base() {
  init_module_progress $_run_base_total "Base"
  track "BASE" install_curl "Curl"
  track "BASE" install_git "Git"
  track "BASE" install_gum "Gum"
  track "BASE" install_zsh "Zsh + Oh My Zsh"
  end_module_progress
}
