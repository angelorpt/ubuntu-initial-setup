# Proposal

## Why

A análise do código revelou oportunidades pontuais de melhoria em DRY, KISS, robustez e conformidade com boas práticas Shell/SOLID:
1. **DRY**: Duplicação em `install/tools_desktop.sh` e `install/dev.sh` executando `pushd /tmp`, `wget`, `dpkg -i`, `apt install -f` e `popd` manualmente, em vez de reutilizar `install_deb` de `lib/utils.sh`.
2. **Robustez / Boas Práticas Bash**: Chamadas de `pushd` / `popd` sem tratamento de erro (`|| return 1`), `read` sem `-r` em `install/config.sh`, e ausência de documentação formal de padrões de engenharia (SOLID, DRY, KISS, Clean Code em shell) no `AGENTS.md`.
3. **Padrões e Governança**: Necessidade de formalizar as convenções e diretrizes de qualidade em `AGENTS.md` para novos módulos e manutenções futuras.

## What Changes

- Reutilizar `install_deb` e helpers de download onde havia `dpkg -i` manual duplicado.
- Adicionar tratamento seguro `|| return 1` ou isolamento em subshell/funções auxiliares para `pushd`/`popd`.
- Usar `read -r` em `install/config.sh` evitando mangling de barras.
- Documentar explicitamente em `AGENTS.md` os princípios aplicados (SOLID, DRY, KISS, Clean Code em Bash) e as convenções que devem ser seguidas por agentes e desenvolvedores.

## Capabilities

### New Capabilities
- `code-quality-guidelines`: Define e documenta os padrões de engenharia (SOLID, DRY, KISS, Clean Code) aplicados ao projeto em shell scripts.

### Modified Capabilities
<!-- Nenhuma especificação existente quebrada -->

## Impact

- `AGENTS.md`: nova seção com princípios de design e boas práticas obrigatórias.
- `install/*.sh`: substituição de lógicas duplicadas por chamadas padronizadas a `install_deb` e proteção em operações com diretórios.
