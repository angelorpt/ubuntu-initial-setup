## Context

O módulo `install/tools_terminal.sh` segue um padrão fixo: cada programa tem uma função `install_*` com `# <url>` no topo, `print_header`, `print_details`, o comando de instalação e `log_success`. O total `_run_tools_terminal_total` é incrementado manualmente e cada item é registrado com `track` em `run_tools_terminal()`. O README espelha a lista de programas em três lugares: tabela de contagem, tabela Tools Terminal e árvore de estrutura.

## Goals / Non-Goals

**Goals:**
- Seguir exatamente o padrão existente dos demais programas do módulo
- Adicionar `fdupes` via apt (repositório oficial, sem PPA nem download externo)

**Non-Goals:**
- Não criar módulo novo — `fdupes` pertence ao Tools Terminal
- Não remover outros programas

## Decisions

- **Função `install_fdupes()` no final do arquivo** antes de `_run_tools_terminal_total`, seguindo o padrão dos demais. Site oficial: https://github.com/adrianlopezroche/fdupes (packages.ubuntu.com é a fonte do binário apt).
- **`sudo apt install -y fdupes`** em vez de PPA ou build manual — disponível nos repositórios oficiais do Ubuntu, simples e versionado pelo sistema.
- **Incrementar `_run_tools_terminal_total` para 15** e adicionar `track "TOOLS_TERMINAL" install_fdupes "fdupes"` antes de `end_module_progress`, preservando a ordem de exibição.
- **README**: atualizar as 3 referências (contagem 14→15, linha da tabela Tools Terminal, comentário da árvore). A linha de contagem usa `14` e a tabela de programas precisa da nova linha com descrição e site.

## Risks / Trade-offs

- [Nome `fdupes` pode conflitar com o número da tabela de contagem no README se atualizado de forma isolada] → Atualizar as três referências no mesmo passo (2)
- [`fdupes --version` exige output a ser capturado no `log_success`] → Seguir o padrão dos demais usando `head -1`
