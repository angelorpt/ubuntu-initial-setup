# Ubuntu Initial Setup

Setup automatizado para Ubuntu — instalação e configuração do ambiente de desenvolvimento com um único comando.

## Uso

```bash
# Instalação rápida (recomendado)
curl -fsSL https://raw.githubusercontent.com/angelorpt/ubuntu-initial-setup/main/bootstrap.sh | bash

# Menu interativo
git clone https://github.com/angelorpt/ubuntu-initial-setup.git
cd ubuntu-initial-setup
./install.sh

# Instalar tudo sem perguntar
./install.sh --all

# Tentar novamente apenas os programas que falharam
./install.sh --retry

# Ajuda
./install.sh --help
```

## Módulos

| Módulo | Programas |
|--------|-----------|
| `base` | curl, git, gum, zsh + oh-my-zsh |
| `dev` | Python, Docker, NVM + Node LTS, Java (JDK), VSCode, Go, Postman, VirtualBox, Antigravity 2.0, Antigravity IDE, Terraform, GitHub CLI, AWS CLI, Ansible, build-essential, libssl-dev, kubectl, helm, minikube |
| `ai` | Ollama, OpenCode, Serena, Hermes Agent, Antigravity CLI |
| `tools_terminal` | htop, tmux, ripgrep, fd, fzf, bat, eza, Starship, zoxide, nano, vim, Neovim, Anyquery, Superfile |
| `tools_desktop` | Flameshot, Espanso, HyperKeys, IMWheel, GParted, Wave Terminal, Warp Terminal, Draw.io, DBeaver, Stacer, BleachBit, Timeshift |
| `tools_ubuntu` | Nala, fastfetch, ncdu, duf, deborphan, lm-sensors, UFW, Unattended Upgrades |
| `media` | Google Chrome, Brave, Blisk |
| `fonts` | Fira Code, JetBrains Mono, Cascadia Code, IBM Plex, Victor Mono, Monaspace |
| `config` | Git config, SSH key, Gogh terminal themes |
| `npm-globals` | TypeScript, Prettier, ESLint, pnpm, Yarn, tsx, Nodemon, Concurrently, Serve, Nest.js, Vue.js, Prisma, json-server, create-next-app, npm-check-updates, live-server, 9Router, OpenSpec |

## Flags

| Flag | Comportamento |
|------|---------------|
| *(sem flag)* | Menu interativo whiptail para selecionar módulos |
| `--all` | Instala todos os módulos sem interação |
| `--retry` | Reexecuta apenas os programas que falharam na última execução |
| `--update` | Reinstala todos os programas (efetivamente atualiza para última versão) |
| `--help` | Exibe ajuda |

## Relatórios

Cada execução gera `.install-results/` no diretório clonado:

```
.install-results/
├── sucesso.txt     — programas instalados com sucesso
├── falha.txt       — programas que falharam
└── relatorio.txt   — relatório formatado com resumo por categoria
```

Se houver falhas, `./install.sh --retry` lê `falha.txt` e tenta novamente apenas os programas pendentes — útil para falhas temporárias (rede, repositório instável).

## Progresso Visual

Durante a instalação, duas barras de progresso são exibidas em tempo real:

```
  Dev          ████████████████████░░░░░░  75% (3/4)
  → Docker
  Total        ████████████████░░░░░░░░░░  25% (3/12)
```

- **Linha 1**: progresso do módulo atual com nome, barra, percentual e contagem
- **Linha 2**: nome do programa sendo instalado no momento
- **Linha 3**: progresso global (total de todos os módulos)

O sistema detecta automaticamente o **gum** (instalado via `base.sh`), mas funciona sem ele com cores ANSI puras.

## Estrutura

```
ubuntu-initial-setup/
├── bootstrap.sh          # curl | bash — instala dependências e executa install.sh
├── install.sh            # Ponto de entrada com menu interativo e CLI flags
├── install/
│   ├── base.sh             # curl, git, gum, zsh
│   ├── dev.sh              # Python, Docker, NVM, Java, VSCode, Go, kubectl, helm e mais
│   ├── ai.sh               # Ollama, OpenCode, Serena, Hermes, Antigravity CLI
│   ├── tools_terminal.sh   # htop, tmux, ripgrep, fzf, vim, Neovim, Superfile
│   ├── tools_desktop.sh    # Flameshot, Espanso, Draw.io, DBeaver, Stacer, Timeshift
│   ├── tools_ubuntu.sh     # Nala, fastfetch, ncdu, duf, UFW
│   ├── media.sh            # Chrome, Brave, Blisk
│   ├── fonts.sh            # Fira Code, JetBrains Mono, Cascadia Code, Victor Mono, Monaspace
│   ├── config.sh           # Git, SSH, Gogh
│   └── npm-globals.sh      # TypeScript, Nest.js, Vue.js, Prisma e mais
└── lib/
    ├── colors.sh         # Cores ANSI
    ├── log.sh            # log_info, log_success, log_error, print_header
    ├── utils.sh          # Utilitários (die_on_error, download_to_temp, install_deb)
    ├── progress.sh       # Barras de progresso (módulo + total)
    └── results.sh        # Tracking de resultados, relatório e retry
```

## Arquitetura

- **Strict mode** (`set -uo pipefail`) em `install.sh` — sem `set -e` para não abortar em caso de erro em um módulo
- **Versões dinâmicas**: resolvidas via GitHub API (`releases/latest`) ou scraping da página oficial — sem versões fixas
- **Cada função de instalação** segue o padrão `# <url>` + `print_header` + `log_info "↪ <url>"` + comandos + `log_success`
- **Tracking independente**: `results.sh` registra em arquivo separadamente da saída do terminal

## Licença

MIT
