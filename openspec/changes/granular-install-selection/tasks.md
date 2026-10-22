# Tasks

## 1. Catálogo e seleção

- [x] 1.1 Criar `lib/catalog.sh` com `MODULES`, arrays `_ITEMS_<MODULO>` e a API `catalog_items`, `catalog_module_label`, `catalog_module_desc`, `catalog_module_total`, `catalog_tag`, `catalog_item_name`, `catalog_selected_total`; verificar com `bash -n lib/catalog.sh` e `source lib/catalog.sh && catalog_module_total BASE` retornando 4
- [x] 1.2 Criar `lib/selection.sh` com `SELECTION_ENABLED`, `select_add`, `select_clear`, `select_has`, `select_count`, `select_summary`; verificar com testes BATS em `tests/lib/selection.bats`
- [x] 1.3 Adicionar `tests/lib/catalog.bats` validando módulos sem itens, tags únicas por módulo e contagem de `catalog_module_total`; verificar com `bats tests/lib/catalog.bats`
- [x] 1.4 Filtrar seleção no início de `track()` em `lib/results.sh` (item não selecionado atualiza progresso, retorna 0 e não grava em sucesso/falha); verificar com teste BATS que `failure.txt` fica vazio ao pular item não selecionado
- [x] 1.5 Ajustar `tests/lib/results.bats` para desativar `SELECTION_ENABLED` no setup; verificar com `bats tests/lib/results.bats`

## 2. Migração dos módulos pequenos

- [x] 2.1 Migrar `install/base.sh` para `_ITEMS_BASE` + `run_base() { catalog_run_module BASE; }`; verificar `source install/base.sh && _run_base_total == 4`
- [x] 2.2 Migrar `install/ai.sh` (6 itens) e `install/media.sh` (2 itens); verificar totais iguais aos atuais
- [x] 2.3 Migrar `install/fonts.sh` (6 itens) e `install/config.sh` (3 itens); verificar totais iguais aos atuais
- [x] 2.4 Migrar `install/npm-globals.sh` (12 itens) mantendo a ordem atual; verificar `_run_npm_globals_total == 12`
- [x] 2.5 Implementar `catalog_run_module` em `lib/catalog.sh` preservando `init_module_progress`/`end_module_progress`; verificar com teste BATS que a função chama `track` na ordem do catálogo

## 3. Migração dos módulos grandes

- [x] 3.1 Migrar `install/dev.sh` (23 itens) preservando a ordem de dependências (build-essential → libssl-dev → Python → …); verificar `_run_dev_total == 23`
- [x] 3.2 Migrar `install/tools_terminal.sh` (15 itens) e `install/tools_ubuntu.sh` (8 itens); verificar totais 15 e 8
- [x] 3.3 Migrar `install/tools_desktop.sh` (12 itens); verificar `_run_tools_desktop_total == 12`
- [x] 3.4 Remover contadores manuais remanescentes e derivar `_run_*_total` do catálogo; verificar que nenhum `track` fixo sobrou com `grep -n '^  track ' install/*.sh` sem resultados

## 4. Fluxo de menu e confirmação

- [x] 4.1 Implementar em `install.sh` o checklist de categorias seguido do checklist de itens por categoria com `--separate-output`, itens ON por padrão e altura limitada; verificar abrindo o menu e navegando pelas 10 categorias
- [x] 4.2 Descartar categorias sem itens marcados e montar o resumo com contagem por categoria e total geral; verificar selecionando uma categoria sem itens e conferindo que o resumo não a lista
- [x] 4.3 Exigir confirmação via `whiptail --yesno` antes de `init_results`; verificar que recusar encerra sem criar entradas em `results/success.txt`
- [x] 4.4 Calcular `init_progress` a partir de `catalog_selected_total` e pular módulos vazios nos três laços de `install.sh`; verificar progresso total igual ao número de itens do resumo
- [x] 4.5 Ajustar modos `--retry` e `--continue` para pré-selecionar itens do histórico e ainda passar pelo resumo; verificar com `results/failure.txt` contendo uma única entrada
- [x] 4.6 Implementar `--yes` (dispensa só a confirmação) e o erro sem TTY sem `--yes`; verificar com `./install.sh --all < /dev/null` saindo com código 1 e mensagem explicativa
- [x] 4.7 Atualizar `show_help` com `--yes` e o novo comportamento de `--all`; verificar que `./install.sh --help` lista o flag

## 5. Documentação e bootstrap

- [x] 5.1 Atualizar `bootstrap.sh` para `./install.sh --all --yes`; verificar com `bash -n bootstrap.sh` e execução do comando em ambiente de teste
- [x] 5.2 Atualizar `README.md` (flags, fluxo em etapas, seleção por item, breaking change de `--all`); verificar que o README não afirma mais que o menu inicia a instalação automaticamente
- [x] 5.3 Atualizar `AGENTS.md` (catálogo como fonte de verdade, `run_*()` delegando para `catalog_run_module`, remoção do bump manual de `_run_*_total`); verificar consistência com o código final
- [x] 5.4 Atualizar `install/_template.sh` com o padrão de catálogo e seleção; verificar `bash -n install/_template.sh`

## 6. Verificação integrada

- [x] 6.1 Rodar `bash tests/run.sh` e garantir ShellCheck + todos os BATS verdes
- [x] 6.2 Rodar `./install.sh` em terminal interativo de teste, desmarcar uma categoria e um item, cancelar na confirmação e garantir que nada foi instalado nem gravado em `results/`
- [x] 6.3 Rodar `./install.sh --all --yes` em ambiente descartável e comparar o relatório com o comportamento anterior (todos os itens, mesmas categorias)

## Workflow follow-up

- Arquivar a mudança com `/opsx-archive` após a implementação e revisão.
