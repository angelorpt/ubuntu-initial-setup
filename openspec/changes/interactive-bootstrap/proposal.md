# Proposal

## Why

Atualmente, ao executar a instalação rápida via `curl .../bootstrap.sh | bash`, o script detecta que `stdin` é um pipe (`[ ! -t 0 ]`) e automaticamente dispara `bash install.sh --all --yes`. Isso instala todos os 91 pacotes sem que o usuário visualize o menu ou escolha quais categorias e programas deseja.

O objetivo do instalador é oferecer controle modular e seleção granular. O bootstrap deve garantir que o usuário sempre veja o menu interativo por padrão (reatachando o TTY), ou prepare o ambiente e execute o menu interativo com instruções claras de uso, evitando instalações integrais não solicitadas.

## What Changes

- Modificar `bootstrap.sh` para reconectar `stdin` ao `/dev/tty` quando executado via pipe em terminal interativo (`[ -t 1 ]` e `/dev/tty` disponível).
- Executar `bash install.sh` em modo interativo por padrão após a preparação de dependências e clone do repositório.
- Introduzir opção/flag ou variável de ambiente (ex: `BOOTSTRAP_HEADLESS=true` ou passagem de argumentos para `install.sh`) para permitir automação não interativa intencional.
- Quando não houver TTY interativo disponível e nenhum flag headless for passado, emitir mensagem informativa e instruções para executar `cd ~/ubuntu-initial-setup && ./install.sh`, sem executar instalação em massa às cegas.
- Atualizar `README.md` e `AGENTS.md` para documentar o comportamento interativo do bootstrap e o comando manual para abrir o menu.

## Capabilities

### New Capabilities
- `bootstrap-installer`: Controla o ciclo de inicialização do bootstrap (instalação de dependências básicas, clonagem e inicialização interativa do menu via TTY com fallback seguro).

### Modified Capabilities
<!-- Nenhuma existente alterada -->

## Impact

- `bootstrap.sh`: reconexão de stdin com `/dev/tty`, execução interativa padrão de `install.sh`, suporte a repasse de flags para `install.sh`.
- Documentação: `README.md` e `AGENTS.md` atualizados para refletir que o comando one-liner agora abre o menu interativo em vez de instalar tudo silenciosamente.
