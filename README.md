# Ubuntu Initial Setup

<p align="center">
  <img src="https://img.shields.io/badge/licen%C3%A7a-MIT-green" alt="Licença MIT">
  <img src="https://img.shields.io/badge/plataforma-Ubuntu-orange" alt="Ubuntu">
  <img src="https://img.shields.io/badge/linguagem-Bash-blue" alt="Bash">
</p>

## Sumário

- [Sobre](#ubuntu-initial-setup)
- [Pré-requisitos](#pré-requisitos)
- [Uso](#uso)
- [Módulos](#módulos)
- [Flags](#flags)
- [Relatórios](#relatórios)
- [Progresso Visual](#progresso-visual)
- [Testes](#testes)
- [Estrutura](#estrutura)
- [Arquitetura](#arquitetura)
- [FAQ / Troubleshooting](#faq--troubleshooting)
- [Licença](#licença)

**Projeto pessoal** de scripts modulares para automatizar a instalação e configuração do Ubuntu — criado por e para desenvolvedores que precisam montar seu ambiente de trabalho rápido, seja do zero ou após um formato.

Ideal para usuários Ubuntu que:
- Formatam o computador com frequência e querem restaurar o setup em minutos
- Preferem escolher o que instalar via menu interativo
- Querem um ponto de partida para customizar seu próprio instalador

Fique à vontade para fazer um **fork**, remover o que não usa, adicionar seus programas favoritos e adaptar ao seu gosto.

## Pré-requisitos

- **Ubuntu** ou distribuição baseada em Debian
- **Conexão com internet**
- **Espaço em disco**: variável conforme os módulos selecionados (~5 GB para instalação completa)
- **Privilégios sudo**: diversos módulos requerem permissão de superusuário

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
| `dev` | Python, Docker, NVM + Node LTS, Java (JDK), VSCode, Go, Postman, VirtualBox, Antigravity 2.0, Antigravity IDE, Terraform, GitHub CLI, AWS CLI, Ansible, build-essential, libssl-dev, kubectl, helm, minikube, Kiro CLI |
| `ai` | Ollama, OpenCode, Serena, Hermes Agent, Antigravity CLI, Claude Code |
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

## Testes

```bash
# ShellCheck + BATS
bash tests/run.sh

# Apenas ShellCheck
bash tests/lint.sh

# Apenas BATS
bats tests/lib/
```

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
├── lib/
│   ├── colors.sh         # Cores ANSI
│   ├── log.sh            # log_info, log_success, log_error, print_header
│   ├── utils.sh          # Utilitários (die_on_error, download_to_temp, install_deb, ensure_snap, ensure_flatpak)
│   ├── progress.sh       # Barras de progresso (módulo + total)
│   └── results.sh        # Tracking de resultados, relatório e retry
└── tests/
    ├── run.sh              # Runner: lint + BATS
    ├── lint.sh             # ShellCheck em todos os .sh
    ├── helpers.bash        # source_lib() para BATS
    └── lib/
        ├── log.bats        # Testes: print_header, print_details, log_*
        ├── progress.bats   # Testes: init_progress, update_progress
        ├── results.bats    # Testes: init_results, track
        └── utils.bats      # Testes: die_on_error, ensure_whiptail, ensure_snap, ensure_flatpak
```

## Arquitetura

- **Strict mode** (`set -uo pipefail`) em `install.sh` — sem `set -e` para não abortar em caso de erro em um módulo
- **Versões dinâmicas**: resolvidas via GitHub API (`releases/latest`) ou scraping da página oficial — sem versões fixas
- **Cada função de instalação** segue o padrão `# <url>` + `print_header` + `log_info "↪ <url>"` + comandos + `log_success`
- **Tracking independente**: `results.sh` registra em arquivo separadamente da saída do terminal
- **Snap/Flatpak**: funções que usam `snap install` ou `flatpak install` chamam `ensure_snap()` / `ensure_flatpak()` antes para garantir que o gerenciador esteja instalado

## FAQ / Troubleshooting

### `curl: command not found`
O bootstrap.sh instala curl automaticamente. Se for executar manualmente, instale antes com `sudo apt install curl -y`.

### Falha na instalação de algum pacote
Pode ser rede instável, repositório temporariamente fora do ar ou pacote já instalado. Execute `./install.sh --retry` para tentar novamente apenas os programas que falharam.

### Algum programa não aparece no menu
Verifique se o módulo correspondente existe em `install/`. O menu whiptail lista automaticamente os módulos encontrados.

### Erro de permissão
Certifique-se de que seu usuário tem permissão sudo. Alguns módulos instalam pacotes via `apt`, `snap` ou scripts que exigem superusuário.

### Quero adicionar meus próprios programas
Faça um fork do projeto, crie um arquivo em `install/` seguindo o padrão dos existentes, adicione o `track` no `run_*()` e incremente o `_run_*_total`. Veja o template em `scripts-utils/template.sh` para referência.

## Licença

[MIT](LICENSE) — use, modifique e compartilhe à vontade.
