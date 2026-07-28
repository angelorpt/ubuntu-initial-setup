# ubuntu-initial-setup

Configuração inicial do Ubuntu — instala tudo que você precisa com um comando.

## Como usar

```bash
# Via curl (recomendado)
curl -fsSL https://raw.githubusercontent.com/angelorpt/ubuntu-initial-setup/main/bootstrap.sh | bash

# Ou localmente
git clone https://github.com/angelorpt/ubuntu-initial-setup.git
cd ubuntu-initial-setup
./install.sh
```

## O que instala

| Módulo | Programas |
|--------|-----------|
| `base` | curl, git, zsh + oh-my-zsh |
| `dev` | Docker, NVM + Node LTS, Java, VSCode, Antigravity 2.0, Antigravity IDE |
| `ai` | Ollama, OpenCode, Serena, Hermes Agent, Antigravity CLI |
| `tools` | Flameshot, Espanso, HyperKeys, IMWheel, GParted, Wave/Warp Terminal, Superfile |
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
└── lib/                  # cores, log, utils
```
