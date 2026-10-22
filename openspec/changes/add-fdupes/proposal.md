## Why

O setup atual não inclui uma ferramenta para localizar e remover arquivos duplicados no terminal. `fdupes` é a solução clássica e leve disponível nos repositórios oficiais do Ubuntu via apt.

## What Changes

- Adicionar função `install_fdupes()` em `install/tools_terminal.sh` com `sudo apt install -y fdupes`
- Bump de `_run_tools_terminal_total` de 14 para 15
- Registrar `track "TOOLS_TERMINAL" install_fdupes "fdupes"` em `run_tools_terminal()`
- Atualizar README.md: tabela do módulo Tools Terminal (linha 141), tabela de programas com descrição/site oficial, e comentário da árvore de estrutura

## Capabilities

### New Capabilities

- `fdupes-tool`: instalação e integração do `fdupes` (localizador de arquivos duplicados) no módulo Tools Terminal

### Modified Capabilities

## Impact

- `install/tools_terminal.sh`: nova função, total e chamada `track`
- `README.md`: linhas 141, tabela Tools Terminal (~linha 202) e árvore de estrutura (~linha 388)
- Dependência de sistema: pacote `fdupes` (repositório oficial do Ubuntu, sem repositórios externos)
