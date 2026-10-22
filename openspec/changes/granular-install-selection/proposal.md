## Why

Hoje o menu só permite escolher categorias inteiras e já dispara a instalação assim que o checklist é confirmado; com `--all`, tudo é instalado sem nenhuma confirmação. O usuário não consegue instalar apenas um programa específico (por exemplo, somente `pnpm` dentro de NPM Globals) nem revisar o que será feito antes de começar.

## What Changes

- Introduzir um catálogo único (`lib/catalog.sh`) que declara, para cada módulo, os itens instaláveis: tag estável, função, nome de exibição e descrição curta.
- Menu em três etapas: modo de execução → categorias → itens de cada categoria selecionada.
- Cada item de cada categoria passa a ter checkbox individual; todos vêm marcados por padrão.
- Nenhuma instalação inicia sem confirmação explícita: após os checklists, exibir resumo (categorias, itens, total) e pedir confirmação.
- `track` passa a respeitar uma lista de seleção (`INSTALL_SELECTION`); itens não selecionados são pulados e não entram no progresso nem no relatório.
- `--all` continua selecionando tudo, mas agora exibe o resumo e pede confirmação; novo flag `--yes` pula a confirmação (uso em automação/bootstrap).
- `bootstrap.sh` passa a chamar `--all --yes` para preservar o one-liner não interativo.
- **BREAKING**: `--all` sem `--yes` deixa de ser totalmente não interativo.
- Atualizar `install/_template.sh`, `README.md` e `AGENTS.md` para o novo padrão de catálogo e seleção.
- Testes BATS para resolução de seleção, contagem e cancelamento.

## Capabilities

### New Capabilities

- `install-selection`: catálogo de módulos/itens e fluxo de seleção granular (categorias + itens) com confirmação obrigatória antes de qualquer instalação.

### Modified Capabilities

<!-- Nenhuma capability existente tem requisitos alterados. -->

## Impact

- `lib/catalog.sh` (novo): registro de módulos e itens.
- `lib/results.sh`: `track` filtra por seleção.
- `lib/progress.sh`: total considera apenas itens selecionados.
- `install.sh`: fluxo de menu em etapas, confirmação, flags `--all` / `--yes`.
- `install/*.sh` (10 módulos): `run_*()` itera o catálogo em vez de `track` fixo; `_run_*_total` derivado do catálogo.
- `bootstrap.sh`, `README.md`, `AGENTS.md`, `install/_template.sh`.
- `tests/`: novos testes em `tests/lib/` e ajuste dos existentes que dependem de `track`.
