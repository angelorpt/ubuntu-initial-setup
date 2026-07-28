#!/bin/bash
set -e

echo "==> Verificando dependências..."
command -v bats >/dev/null 2>&1 || { echo "Erro: bats não instalado. Instale com: sudo apt install bats"; exit 1; }
command -v shellcheck >/dev/null 2>&1 || { echo "Erro: shellcheck não instalado. Instale com: sudo apt install shellcheck"; exit 1; }

echo "==> ShellCheck..."
bash tests/lint.sh && echo "  OK" || echo "  Falhou"

echo
echo "==> BATS (libs)..."
bats tests/lib/
