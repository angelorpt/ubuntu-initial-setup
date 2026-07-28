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
- [Programas](#programas)
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

| Módulo | Programas | Total |
|--------|-----------|-------|
| `base` | curl, git, gum, zsh + oh-my-zsh | 4 |
| `dev` | Python, Docker, NVM + Node LTS, Java (JDK), VSCode, Go, Postman, VirtualBox, Antigravity 2.0, Antigravity IDE, Terraform, GitHub CLI, AWS CLI, Ansible, build-essential, libssl-dev, kubectl, helm, minikube, Kiro CLI, ShellCheck, BATS | 22 |
| `ai` | Ollama, OpenCode, Serena, Hermes Agent, Antigravity CLI, Claude Code | 6 |
| `tools_terminal` | htop, tmux, ripgrep, fd, fzf, bat, eza, Starship, zoxide, nano, vim, Neovim, Anyquery, Superfile | 14 |
| `tools_desktop` | Flameshot, Espanso, HyperKeys, IMWheel, GParted, Wave Terminal, Warp Terminal, Draw.io, DBeaver, Stacer, BleachBit, Timeshift | 12 |
| `tools_ubuntu` | Nala, fastfetch, ncdu, duf, deborphan, lm-sensors, UFW, Unattended Upgrades | 8 |
| `media` | Google Chrome, Brave, Blisk | 3 |
| `fonts` | Fira Code, JetBrains Mono, Cascadia Code, IBM Plex, Victor Mono, Monaspace | 6 |
| `config` | Git config, SSH key, Gogh terminal themes | 3 |
| `npm-globals` | TypeScript, Prettier, ESLint, pnpm, Yarn, tsx, Nodemon, Concurrently, Serve, Nest.js, Vue.js, Prisma, json-server, create-next-app, npm-check-updates, live-server, 9Router, OpenSpec | 18 |

## Programas

### Base

| Programa | Site | Descrição |
|----------|------|-----------|
| Curl | https://curl.se | Ferramenta de transferência de dados via URL |
| Git | https://git-scm.com | Sistema de controle de versão distribuído |
| Gum | https://github.com/charmbracelet/gum | Ferramenta de UI para shell scripts |
| Zsh + Oh My Zsh | https://ohmyz.sh | Terminal aprimorado com plugins e temas |

### Dev

| Programa | Site | Descrição |
|----------|------|-----------|
| build-essential | https://packages.ubuntu.com/build-essential | Meta-pacote com gcc, g++, make e ferramentas de compilação |
| libssl-dev | https://packages.ubuntu.com/libssl-dev | Headers do OpenSSL para compilação de pacotes |
| Python | https://www.python.org | Linguagem de programação versátil |
| Docker | https://docs.docker.com/engine/install/ubuntu | Plataforma de contêineres para desenvolvimento e deployment |
| NVM + Node | https://github.com/nvm-sh/nvm | Gerenciador de versões do Node.js + Node LTS |
| Java (JDK) | https://openjdk.org | Kit de desenvolvimento Java padrão (OpenJDK) |
| VSCode | https://code.visualstudio.com | Editor de código da Microsoft com extensões |
| Go | https://snapcraft.io/go | Linguagem de programação compilada do Google |
| Postman | https://snapcraft.io/postman | Plataforma de API para desenvolvimento |
| VirtualBox | https://www.virtualbox.org | Hipervisor de código aberto para virtualização |
| Antigravity 2.0 | https://antigravity.google | Plataforma de desenvolvimento agente-first do Google |
| Antigravity IDE | https://antigravity.google | IDE para desenvolvimento agente-first |
| Terraform | https://developer.hashicorp.com/terraform/install#linux | Infraestrutura como código pela HashiCorp |
| GitHub CLI | https://cli.github.com | CLI oficial do GitHub |
| AWS CLI | https://aws.amazon.com/cli | CLI oficial da Amazon Web Services |
| Ansible | https://www.ansible.com | Automação de infraestrutura |
| kubectl | https://kubernetes.io | CLI oficial do Kubernetes |
| Helm | https://helm.sh | Gerenciador de pacotes Kubernetes |
| Minikube | https://minikube.sigs.k8s.io | Kubernetes single-node local para estudos |
| Kiro CLI | https://kiro.dev/cli | CLI da plataforma Kiro |
| ShellCheck | https://www.shellcheck.net | Análise estática para scripts shell |
| BATS | https://bats-core.readthedocs.io | Testes automatizados para Bash |

### AI

| Programa | Site | Descrição |
|----------|------|-----------|
| Ollama | https://ollama.com | Plataforma local para execução de modelos de linguagem |
| OpenCode | https://opencode.ai | Assistente de engenharia de software no terminal |
| Serena | https://github.com/oraios/serena | MCP toolkit semântico para agentes de código |
| Antigravity CLI | https://antigravity.google | CLI para desenvolvimento agente-first do Google |
| Claude Code | https://code.claude.com | Assistente de codificação IA da Anthropic |

### Tools Terminal

| Programa | Site | Descrição |
|----------|------|-----------|
| htop | https://htop.dev | Monitor de processos interativo |
| tmux | https://github.com/tmux/tmux | Multiplexador de terminal com sessões persistentes |
| ripgrep | https://github.com/BurntSushi/ripgrep | Ferramenta de busca turbo em Rust |
| fd | https://github.com/sharkdp/fd | Alternativa moderna ao find |
| fzf | https://github.com/junegunn/fzf | Buscador fuzzy generalizado para terminal |
| bat | https://github.com/sharkdp/bat | cat com syntax highlight |
| eza | https://github.com/eza-community/eza | ls moderno com ícones e git status |
| Starship | https://starship.rs | Prompt minimalista e personalizável |
| zoxide | https://github.com/ajeetdsouza/zoxide | cd inteligente que aprende seus diretórios |
| Nano | https://www.nano-editor.org | Editor de texto simples para terminal |
| Vim | https://www.vim.org | Editor de texto clássico e poderoso |
| Neovim | https://neovim.io | Fork moderno do Vim com suporte a Lua |
| Anyquery | https://anyquery.dev | Ferramenta de consulta SQL para qualquer fonte de dados |
| Superfile | https://superfile.dev | Gerenciador de arquivos no terminal |

### Tools Desktop

| Programa | Site | Descrição |
|----------|------|-----------|
| Flameshot | https://flameshot.org | Ferramenta de captura de tela com anotações |
| Espanso | https://espanso.org | Expansor de texto para produtividade |
| HyperKeys | https://hyperkeys.xureilab.com | Atalhos de teclado personalizados |
| IMWheel | https://imwheel.sourceforge.net | Ajuste de velocidade do scroll do mouse |
| GParted | https://gparted.org | Gerenciador de partições de disco |
| Wave Terminal | https://www.waveterm.dev | Terminal moderno com widgets integrados |
| Warp Terminal | https://www.warp.dev | Terminal moderno com IA integrada |
| Draw.io | https://www.drawio.com | Editor de diagramas e fluxogramas |
| DBeaver | https://dbeaver.io | Gerenciador de bancos de dados universal |
| Stacer | https://github.com/oguzhaninan/Stacer | Otimizador e monitor do sistema |
| BleachBit | https://www.bleachbit.org | Limpeza de cache e lixo do sistema |
| Timeshift | https://github.com/linuxmint/timeshift | Backup incremental do sistema com snapshots |

### Tools Ubuntu

| Programa | Site | Descrição |
|----------|------|-----------|
| Nala | https://gitlab.com/volian/nala | Frontend moderno para o apt |
| fastfetch | https://github.com/fastfetch-cli/fastfetch | Informações do sistema rápidas e bonitas |
| ncdu | https://dev.yorhel.nl/ncdu | Análise de uso de disco em TUI |
| duf | https://github.com/muesli/duf | df moderno com gráficos e cores |
| deborphan | https://packages.debian.org/deborphan | Localiza pacotes órfãos no sistema |
| lm-sensors | https://github.com/lm-sensors/lm-sensors | Monitoramento de temperatura da CPU/GPU |
| UFW | https://help.ubuntu.com/community/UFW | Firewall simples para Ubuntu |
| Unattended Upgrades | https://wiki.debian.org/UnattendedUpgrades | Atualizações automáticas de segurança |

### Media

| Programa | Site | Descrição |
|----------|------|-----------|
| Google Chrome | https://www.google.com/chrome | Navegador web do Google |
| Brave | https://brave.com | Navegador focado em privacidade |

### Fonts

| Programa | Site | Descrição |
|----------|------|-----------|
| Fira Code | https://github.com/tonsky/FiraCode | Fonte monoespaçada com ligaduras para programação |
| JetBrains Mono | https://www.jetbrains.com/lp/mono | Fonte para programação desenhada pela JetBrains |
| Cascadia Code | https://github.com/microsoft/cascadia-code | Fonte monoespaçada da Microsoft com ligaduras |
| IBM Plex | https://www.ibm.com/plex | Família de fontes da IBM com design elegante |
| Victor Mono | https://rubjo.github.io/victor-mono | Fonte com itálico cursivo e ligaduras |
| Monaspace | https://monaspace.githubnext.com | Família de fontes do GitHub com 5 variantes |

### Config

| Programa | Site | Descrição |
|----------|------|-----------|
| Git Config | — | Identificação para commits Git |
| SSH Key | — | Chave SSH para autenticação em serviços remotos |
| Gogh Terminal | https://github.com/Gogh-Co/Gogh | Temas para o terminal GNOME |

### NPM Globals

| Programa | Site | Descrição |
|----------|------|-----------|
| TypeScript | https://www.typescriptlang.org | Compilador TypeScript |
| Prettier | https://prettier.io | Formatador de código opinativo |
| ESLint | https://eslint.org | Linter de JavaScript/TypeScript |
| pnpm | https://pnpm.io | Gerenciador de pacotes rápido e eficiente |
| Yarn | https://yarnpkg.com | Gerenciador de pacotes alternativo |
| tsx | https://github.com/privatenumber/tsx | Executar TypeScript diretamente sem compilar |
| Nodemon | https://nodemon.io | Auto-restart em alterações de código |
| Concurrently | https://github.com/open-cli-tools/concurrently | Rodar múltiplos comandos em paralelo |
| Serve | https://github.com/vercel/serve | Servidor estático moderno pela Vercel |
| Nest.js | https://nestjs.com | Framework Node.js progressivo |
| Vue.js | https://vuejs.org | Framework JS progressivo |
| Prisma | https://www.prisma.io | ORM moderno para Node.js e TypeScript |
| json-server | https://github.com/typicode/json-server | API REST fake com zero configuração |
| create-next-app | https://nextjs.org | Scaffolding de projetos Next.js |
| npm-check-updates | https://github.com/raineorshine/npm-check-updates | Atualizar versões de dependências no package.json |
| live-server | https://github.com/tapio/live-server | Servidor com live reload para páginas estáticas |
| 9Router | https://github.com/decolua/9router | Roteador CLI |
| OpenSpec | https://github.com/Fission-AI/OpenSpec | Gerenciador de mudanças para projetos de IA |

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
