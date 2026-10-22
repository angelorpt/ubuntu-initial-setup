#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/angelorpt/ubuntu-initial-setup.git"
INSTALL_DIR="$HOME/ubuntu-initial-setup"

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
# Se executado via pipe (ex: curl ... | bash), reconecta stdin a /dev/tty para permitir o menu interativo
if [ ! -t 0 ] && [ -r /dev/tty ] && [ -t 1 ]; then
  exec < /dev/tty
fi

if [ $# -gt 0 ]; then
  bash install.sh "$@"
elif [ -t 0 ] && [ -t 1 ]; then
  bash install.sh
else
  echo
  echo ">>> Repositório preparado em $INSTALL_DIR"
  echo ">>> Ambiente não interativo detectado (sem TTY)."
  echo ">>> Para abrir o menu interativo de seleção:"
  echo "      cd $INSTALL_DIR && ./install.sh"
  echo ">>> Para instalar tudo automaticamente de forma não interativa:"
  echo "      cd $INSTALL_DIR && ./install.sh --all --yes"
  exit 0
fi

echo
echo "✓ Setup concluído!"
