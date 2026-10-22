# Design

## Context

Ver `proposal.md` para a motivação. Hoje a estrutura é: `install.sh` faz três laços sobre `CHOICES` (source, soma de totais, execução), cada `install/<modulo>.sh` declara `_run_*_total` e uma `run_*()` com chamadas `track` fixas, e `lib/results.sh` concentra `track`, retry/continue e relatório. `lib/progress.sh` desenha três linhas fixas. Não existe nenhuma camada de metadados: a lista de programas só existe como sequência de `track` dentro de `run_*()`.

Restrições relevantes:

- Bash puro, sem dependências além de whiptail (já exigido) e gum (opcional).
- `install.sh` roda com `set -uo pipefail` (sem `-e`), então retornos de menu cancelado precisam ser tratados explicitamente.
- `bootstrap.sh` usa `curl | bash` e não tem terminal interativo garantido.
- Cada `run_*()` define a ordem de instalação; em alguns módulos a ordem importa (ex.: `build-essential` antes de compilar; Node antes dos pacotes npm globais; módulos BASE antes de CONFIG).

## Goals / Non-Goals

**Goals:**

- Fonte única de verdade para módulos, itens, rótulos e descrições.
- Seleção em dois níveis (categoria → itens) com todos os itens marcados por padrão.
- Resumo + confirmação obrigatória antes de qualquer comando de instalação.
- `--all --yes` como caminho 100% não interativo para bootstrap/automação.
- Compatibilidade com retry/continue e com o formato atual de `results/*.txt`.
- Cobertura BATS do catálogo e da filtragem por seleção.

**Non-Goals:**

- Não reescrever as funções `install_*` nem mudar comandos de instalação.
- Não introduzir detecção de "já instalado" por binário (o histórico continua sendo a fonte).
- Não trocar whiptail por outra TUI nem adicionar dependências.
- Não alterar o layout de `results/`.

## Decisions

### 1. Catálogo declarativo em `lib/catalog.sh`

Formato escolhido: arrays Bash por módulo, com itens no formato `funcao|Nome de exibição|descrição curta`, mais um array `MODULES` com a ordem canônica.

```bash
MODULES=(BASE DEV AI TOOLS_TERMINAL TOOLS_DESKTOP TOOLS_UBUNTU MEDIA FONTS CONFIG NPM_GLOBALS)
_ITEMS_BASE=(
  "install_curl|Curl|Cliente HTTP/HTTPS"
  "install_git|Git|Controle de versão"
  ...
)
```

API pública do catálogo:

| Função | Papel |
|---|---|
| `catalog_items <MODULO>` | Emite `funcao\|nome\|descricao` por linha |
| `catalog_module_label <MODULO>` | Rótulo curto para o menu |
| `catalog_module_desc <MODULO>` | Descrição da categoria |
| `catalog_module_total <MODULO>` | Nº de itens do módulo |
| `catalog_tag <MODULO> <funcao>` | Tag estável `MODULO:funcao` |
| `catalog_item_name <MODULO> <funcao>` | Nome de exibição |
| `catalog_selected_total` | Soma apenas dos itens selecionados |

**Por que não extrair os itens via `grep 'track '` de `install/*.sh`:** parsing de código frágil (comentários, continuações de linha, ordem de sourcing). **Por que não um arquivo TSV/JSON externo:** exigiria parser extra em Bash e um segundo artefato para manter sincronizado; arrays são nativos e testáveis.

Cada `install/<modulo>.sh` mantém `_run_*_total` como variável derivada no momento do carregamento do catálogo (`_run_dev_total=$(catalog_module_total DEV)`), preservando os laços atuais de `install.sh` e a API de `lib/progress.sh`.

### 2. `run_*()` genérico orientado pelo catálogo

`run_dev()` e equivalentes passam a delegar para um executor comum:

```bash
run_dev() { catalog_run_module DEV; }

catalog_run_module() {
  local module="$1" func name desc
  init_module_progress "$(catalog_module_total "$module")" "$(catalog_module_label "$module")"
  while IFS='|' read -r func name desc; do
    track "$module" "$func" "$name"
  done < <(catalog_items "$module")
  end_module_progress
}
```

Assim a ordem do array é a ordem de instalação, e adicionar um programa deixa de exigir três edições (função, `track`, total). A assinatura `run_<modulo>()` é preservada para não mexer nos três laços de `install.sh`.

### 3. Seleção como filtro dentro de `track`

Nova `lib/selection.sh`:

- `SELECTION_ENABLED=false` por padrão (chamadas diretas de `track` em testes continuam instalando).
- `select_add <tag>`, `select_clear`, `select_has <tag>`, `select_count`, `select_summary`.
- Armazenamento em array associativo `SELECTED_TAGS[tag]=1` (Bash 4+, disponível no Ubuntu alvo).

`track` ganha, no topo, o filtro:

```bash
if $SELECTION_ENABLED && ! select_has "$category:$func"; then
  update_progress "$name"
  return 0
fi
```

Filtrar dentro de `track` (em vez de reescrever os laços) mantém retry/continue, logging e relatório intactos e concentra a regra em um único ponto. Efeito colateral desejado: itens não selecionados não entram em `success.txt`/`failure.txt`.

**Alternativa descartada:** gerar dinamicamente uma lista de funções por módulo e chamá-las direto — quebraria a contagem do progresso e a lógica de retry já embutida em `track`.

### 4. Fluxo de menu em `install.sh`

```
flags (--all/--update/--retry/--continue/--yes/--help)
  └─ modo (new/continue/retry)            [interativo, exceto --all/--update/--retry/--continue]
      └─ checklist de categorias          [todas ON]
          └─ para cada categoria: checklist de itens [todos ON]
              └─ resumo + --yesno         [obrigatório, salvo --yes]
                  └─ init_results → init_progress (total selecionado) → execução → relatório
```

Detalhes:

- `whiptail --checklist --separate-output` em ambos os níveis; `--separate-output` evita o parsing de aspas do formato padrão.
- Itens usam a função como tag e o nome como rótulo; a lista pode rolar, então altura = `min(nº_itens + 8, 30)` e largura 78.
- Categoria sem itens marcados é descartada antes do resumo.
- Resumo lista `MODULO (n itens): Item1, Item2, ...` e o total geral.
- `--yes` só dispensa o `--yesno`; nunca dispensa a seleção.
- Retry: pré-seleciona apenas categorias/itens presentes em `failure.txt` (via `sed 's/^[^:]*: //'`), mas ainda mostra os checklists e o resumo.
- Continue: todos os itens ON; `track` continua pulando sucessos do histórico.

### 5. Comportamento sem TTY

Antes de qualquer menu: se `--yes` está ausente e `[ ! -t 0 ] || [ ! -t 1 ]`, encerrar com código 1 e mensagem indicando usar `--all --yes`. Isso preserva automação explícita e evita instalar às cegas dentro de `curl | bash`. `bootstrap.sh` passa a usar `--all --yes`.

### 6. Testes

- `tests/lib/catalog.bats`: todo módulo de `MODULES` tem array de itens; tags únicas; toda função referenciada existe após sourcing do módulo; `catalog_module_total` bate com o número de linhas.
- `tests/lib/selection.bats`: `select_add`/`select_has`/`select_clear`/`select_count`; `track` com `SELECTION_ENABLED=true` não executa item fora da seleção e não grava em `failure.txt`; executa item selecionado.
- `tests/lib/results.bats`: resetar `SELECTION_ENABLED=false` no setup para manter os testes atuais válidos.
- `tests/lint.sh`: ShellCheck já cobre os novos arquivos.

## Risks / Trade-offs

- **Menu longo no módulo DEV (23 itens) em terminais pequenos** → altura calculada com limite e rolagem nativa do whiptail; teste manual em 24 linhas.
- **Duplicação temporária entre catálogo e `run_*()` durante a migração** → migrar um módulo por commit e adicionar teste que compara catálogo × funções existentes.
- **`--all` deixa de ser silencioso (breaking)** → `--yes` documentado no `--help`, README, `bootstrap.sh` e AGENTS.md.
- **Retorno de `whiptail` cancelado (255) sob `set -uo pipefail`** → tratar explicitamente: cancelar em qualquer etapa encerra com código 0 sem instalar.
- **Associative arrays exigem Bash 4+** → Ubuntu 18.04+ já traz Bash 4.4; `install.sh` usa `#!/bin/bash` (não `sh`).

## Migration Plan

1. Adicionar `lib/catalog.sh` e `lib/selection.sh` sem alterar comportamento (seleção desativada).
2. Migrar os 10 módulos para o catálogo, um por vez, mantendo ordem e totais idênticos; rodar `bash tests/run.sh` a cada migração.
3. Ativar o novo fluxo de menu e a confirmação em `install.sh`.
4. Atualizar `bootstrap.sh` para `--all --yes`, depois README/AGENTS/`_template.sh`.
5. Rollback: reverter o commit de `install.sh`; catálogo e seleção são aditivos e inertes com `SELECTION_ENABLED=false`.

## Open Questions

Nenhuma pendente.
