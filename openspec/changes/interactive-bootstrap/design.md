# Design

## Context

Ver `proposal.md` para a motivação. Atualmente, `bootstrap.sh` possui:
```bash
PIPE_MODE=false
[ ! -t 0 ] && PIPE_MODE=true
...
if $PIPE_MODE; then
  echo ">>> Modo automático: instalando todos os módulos..."
  bash install.sh --all --yes
else
  bash install.sh
fi
```
Como o comando recomendado no README é `curl ... | bash`, `[ ! -t 0 ]` é sempre verdadeiro, forçando a instalação completa automática e ignorando o menu interativo. Além disso, `whiptail` requer acesso a um TTY interativo (`/dev/tty`) para desenhar a interface de menus e capturar teclas.

## Goals / Non-Goals

**Goals:**
- Permitir que `curl ... | bash` abra diretamente o menu interativo de `install.sh`.
- Reatachar `stdin` ao `/dev/tty` de forma segura quando o terminal de saída for interativo (`[ -t 1 ]`).
- Permitir repasse transparente de argumentos via `bash -s -- <args>` (ex: `curl ... | bash -s -- --all --yes`).
- Fornecer fallback seguro e explicativo quando não houver terminal interativo disponível, sem instalar nada silenciosamente.
- Exibir instruções claras de como reabrir o menu em `~/ubuntu-initial-setup`.

**Non-Goals:**
- Não alterar a lógica interna de `install.sh` ou `lib/`.
- Não criar novo script além dos existentes.

## Decisions

### 1. Reatachamento de `/dev/tty` para a execução interativa

Se `[ ! -t 0 ]` (executado via pipe) e `[ -r /dev/tty ]` com `[ -t 1 ]` (terminal de saída interativo), redirecionar o descritor de entrada para `/dev/tty`:
```bash
if [ ! -t 0 ] && [ -r /dev/tty ] && [ -t 1 ]; then
  exec < /dev/tty
fi
```
Isso permite que tanto comandos internos quanto o `whiptail` dentro de `install.sh` recebam eventos do teclado do usuário normalmente.

*Alternativa descartada:* apenas clonar e instruir o usuário a digitar um segundo comando. Isso adiciona atrito desnecessário para o caso comum onde o usuário espera que o one-liner já abra o instalador.

### 2. Repasse de argumentos (`$@`) para `install.sh`

`bootstrap.sh` repassa seus parâmetros diretamente para `install.sh`:
```bash
bash install.sh "$@"
```
Isso permite automações com `curl ... | bash -s -- --all --yes` ou parâmetros customizados como `--retry`.

### 3. Tratamento sem TTY interativo

Se o usuário executar o bootstrap em um ambiente sem terminal interativo (ex: CI, container sem TTY alocado) e sem argumentos explícitos (`$# -eq 0`):
O script instala as dependências, clona/atualiza o repositório e encerra exibindo instruções:
```
✓ Repositório preparado em ~/ubuntu-initial-setup
Ambiente sem terminal interativo detectado.
Para abrir o menu interativo:
  cd ~/ubuntu-initial-setup && ./install.sh
Para instalar tudo automaticamente:
  cd ~/ubuntu-initial-setup && ./install.sh --all --yes
```
Isso impede que um ambiente headless instale 91 ferramentas sem autorização explícita.

## Risks / Trade-offs

- **Ambientes restritos sem `/dev/tty`** → O fallback seguro detecta a ausência de TTY e orienta o usuário sem falhar com erro opaco.
- **`set -euo pipefail` ativo no `bootstrap.sh`** → O reatachamento e as verificações condicionais usam testes seguros que não provocam encerramento inesperado sob `-e`.
