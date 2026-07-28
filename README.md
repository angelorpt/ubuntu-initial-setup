# ubuntu-initial-setup

Configuração inicial do Ubuntu — instala tudo que você precisa com um comando.

## Como usar

```bash
# Via curl (recomendado)
curl -fsSL https://raw.githubusercontent.com/user/ubuntu-initial-setup/main/bootstrap.sh | bash

# Ou localmente
git clone https://github.com/user/ubuntu-initial-setup.git
cd ubuntu-initial-setup
./install.sh
```

## O que instala

| Módulo | Programas |
|--------|-----------|
| `base` | curl, git, zsh + oh-my-zsh |
| `dev` | Docker, NVM + Node 18/20, Java, VSCode |
| `ai` | Ollama, OpenCode, Serena |
| `tools` | Flameshot, Espanso, HyperKeys, IMWheel, GParted |
| `media` | Google Chrome, Ferdium, Mailspring, Telegram, Obsidian, Calibre |
| `fonts` | Fira Code |
| `config` | Git config, SSH key, Gogh terminal |

O menu whiptail permite desmarcar módulos que você não quer.

## Estrutura

```
ubuntu-initial-setup/
├── bootstrap.sh          # curl | bash
├── install.sh            # menu interativo
├── install/              # módulos por categoria
├── lib/                  # cores, log, utils
└── config/settings.conf  # versões e defaults
```
