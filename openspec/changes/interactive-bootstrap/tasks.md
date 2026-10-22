# Tasks

## 1. Implementação do Bootstrap Interativo

- [x] 1.1 Atualizar `bootstrap.sh` para reconectar `stdin` a `/dev/tty` quando executado via pipe em terminal interativo (`[ -t 1 ] && [ -r /dev/tty ]`); verificar com `bash -n bootstrap.sh`
- [x] 1.2 Adicionar repasse de argumentos `$@` para `install.sh` e implementar o fallback seguro sem TTY quando nenhum argumento for passado; verificar executando `bootstrap.sh < /dev/null` em mock e garantindo que nada é instalado
- [x] 1.3 Adicionar mensagens informativas pós-clone com o comando manual para abrir o menu (`cd ~/ubuntu-initial-setup && ./install.sh`) e instruções para instalação automatizada; verificar saída no terminal

## 2. Documentação e Validação

- [x] 2.1 Atualizar `README.md` refletindo que o one-liner agora abre o menu interativo por padrão e documentando os dois passos (bootstrap + reabrir menu); verificar com visualização do diff
- [x] 2.2 Atualizar `AGENTS.md` para descrever o novo comportamento de `bootstrap.sh`; verificar consistência
- [x] 2.3 Executar `bash tests/run.sh` e garantir ShellCheck e todos os BATS verdes

## Workflow follow-up

- Arquivar a mudança com `/opsx-archive` após aprovação e implementação.
