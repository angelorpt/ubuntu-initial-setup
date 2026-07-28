# ubuntu-initial-setup

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
| `base` | curl, git, zsh + oh-my-zsh |
| `dev` | Docker, NVM + Node LTS, Java (JDK), VSCode, Go, Postman, VirtualBox, Antigravity 2.0, Antigravity IDE |
| `ai` | Ollama, OpenCode, Serena, Hermes Agent, Antigravity CLI |
| `tools` | Flameshot, Espanso, HyperKeys, IMWheel, GParted, Wave Terminal, Warp Terminal, Superfile |
| `media` | Google Chrome, Ferdium, Mailspring, Telegram, Obsidian, VLC, Inkscape, Calibre |
| `fonts` | Fira Code |
| `config` | Git config, SSH key, Gogh terminal themes |

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

## Estrutura

```
ubuntu-initial-setup/
├── bootstrap.sh          # curl | bash — instala dependências e executa install.sh
├── install.sh            # Ponto de entrada com menu interativo e CLI flags
├── install/
│   ├── base.sh           # curl, git, zsh
│   ├── dev.sh            # Docker, NVM, Java, VSCode, Go, Postman, VirtualBox, Antigravity
│   ├── ai.sh             # Ollama, OpenCode, Serena, Hermes, Antigravity CLI
│   ├── tools.sh          # Flameshot, Espanso, HyperKeys, IMWheel, GParted, terminais
│   ├── media.sh          # Chrome, Ferdium, Mailspring, Telegram, Obsidian, VLC, Inkscape, Calibre
│   ├── fonts.sh          # Fira Code
│   └── config.sh         # Git, SSH, Gogh
└── lib/
    ├── colors.sh         # Cores ANSI
    ├── log.sh            # log_info, log_success, log_error, print_header
    ├── utils.sh          # Utilitários (die_on_error, download_to_temp, install_deb)
    └── results.sh        # Tracking de resultados, relatório e retry
```

## Arquitetura

- **Strict mode** (`set -uo pipefail`) em `install.sh` — sem `set -e` para não abortar em caso de erro em um módulo
- **Versões dinâmicas**: resolvidas via GitHub API (`releases/latest`) ou scraping da página oficial — sem versões fixas
- **Cada função de instalação** segue o padrão `# <url>` + `print_header` + `log_info "↪ <url>"` + comandos + `log_success`
- **Tracking independente**: `results.sh` registra em arquivo separadamente da saída do terminal

## Licença

MIT
