#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/user/ubuntu-initial-setup.git"
INSTALL_DIR="$HOME/ubuntu-initial-setup"

# Detecta se está rodando via pipe
PIPE_MODE=false
[ ! -t 0 ] && PIPE_MODE=true

# 1. Instalar dependências mínimas
echo ">>> Instalando dependências..."
sudo apt update -qq
sudo apt install -y git curl wget whiptail

# 2. Clonar o repositório
if [ -d "$INSTALL_DIR" ]; then
  echo ">>> Atualizando repositório existente em $INSTALL_DIR..."
  cd "$INSTALL_DIR" && git pull
else
  echo ">>> Clonando repositório para $INSTALL_DIR..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# 3. Executar instalador
if $PIPE_MODE; then
  echo ">>> Modo automático: instalando todos os módulos..."
  bash install.sh --all
else
  bash install.sh
fi

echo
echo "✓ Setup concluído!"
