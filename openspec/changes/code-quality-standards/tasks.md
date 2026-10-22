# Tasks

## 1. Eliminação de Duplicações e Robustez de Código

- [x] 1.1 Em `install/tools_desktop.sh`, `install/dev.sh`, `install/media.sh` e `install/fonts.sh`, proteger chamadas `pushd` / `popd` com `|| return 1`; verificar com `bash -n`
- [x] 1.2 Em `install/tools_desktop.sh` e `install/dev.sh`, substituir instalações manuais de `.deb` por chamadas a `install_deb`; verificar com `bash -n`
- [x] 1.3 Em `install/config.sh`, adicionar a flag `-r` aos comandos `read -p`; verificar com `bash -n install/config.sh`

## 2. Documentação de Boas Práticas em AGENTS.md

- [x] 2.1 Atualizar `AGENTS.md` incluindo seção de Princípios de Engenharia e Boas Práticas (SOLID, DRY, KISS, Clean Code, ShellCheck e convenções de estilo); verificar formatação e links
- [x] 2.2 Executar `bash tests/run.sh` e garantir que ShellCheck e todos os BATS passem com sucesso

## Workflow follow-up

- Arquivar a mudança com `/opsx-archive` após revisão e testes.
