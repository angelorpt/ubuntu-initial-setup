# Design

## Context

O projeto possui boa modularização com o catálogo centralizado em `lib/catalog.sh` e seleção granular em `lib/selection.sh`. No entanto, em alguns scripts de instalação ainda há duplicação e fragilidades:
- Funções que executam manualmente `sudo dpkg -i ... || true` seguido de `sudo apt install -f -y -q`, exatamente o que `install_deb` faz.
- Chamadas `pushd /tmp > /dev/null` sem verificar se a operação foi bem-sucedida (`pushd ... || return 1`), o que pode causar execuções no diretório errado.
- `read -p` sem `-r` em `install/config.sh`.
- Ausência de diretrizes explícitas sobre SOLID, DRY, KISS e Clean Code em `AGENTS.md`.

## Goals / Non-Goals

**Goals:**
- Eliminar duplicações de lógica de instalação de `.deb` delegando para `install_deb`.
- Tornar navegações temporárias de diretórios seguras contra falhas.
- Adicionar flag `-r` em leituras de prompt interativo.
- Adicionar seção detalhada de boas práticas (SOLID, DRY, KISS, Clean Code em Bash) no `AGENTS.md`.

**Non-Goals:**
- Não reescrever toda a base de scripts nem mudar nomes de funções públicas ou comandos instalados.

## Decisions

### 1. Centralização da instalação de .deb em `install_deb`

Em `install/tools_desktop.sh` (ex: `install_waveterm`, `install_drawio`) e `install/dev.sh` (ex: `install_virtualbox`):
Substituir blocos `sudo dpkg -i <deb> && sudo apt install -f ...` por `install_deb <deb>`.

### 2. Tratamento seguro de pushd / popd

Todas as chamadas `pushd` em scripts de instalação devem ser protegidas:
```bash
pushd /tmp > /dev/null || return 1
...
popd > /dev/null || return 1
```

### 3. Diretrizes de Qualidade em `AGENTS.md`

Adicionar ao `AGENTS.md` regras cobrindo:
- **SOLID em Bash**: Responsabilidade única (uma função por ferramenta), abstrações reutilizáveis (`lib/`), composição de módulos.
- **DRY**: Utilização de helpers de `lib/utils.sh` e do catálogo declarativo.
- **KISS**: Manter scripts lineares, sem complexidade desnecessária.
- **Clean Code & ShellCheck**: Boas práticas de quoting, `read -r`, verificação de retorno e convenções estéticas de saída.
