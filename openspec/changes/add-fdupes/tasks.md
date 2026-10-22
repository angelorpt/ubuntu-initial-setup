## 1. Implementação no módulo Tools Terminal

- [x] 1.1 Adicionar `install_fdupes()` em `install/tools_terminal.sh` com `# https://github.com/adrianlopezroche/fdupes`, `print_header`, `print_details` (uso: `fdupes -r DIRETORIO`), `sudo apt install -y fdupes` e `log_success "fdupes instalado: $(fdupes --version 2>&1 | head -1)"`
- [x] 1.2 Incrementar `_run_tools_terminal_total` de 14 para 15
- [x] 1.3 Adicionar `track "TOOLS_TERMINAL" install_fdupes "fdupes"` em `run_tools_terminal()` antes de `end_module_progress`

## 2. Atualização do README

- [x] 2.1 Atualizar a linha de contagem do módulo `tools_terminal` de `14` para `15` e adicionar fdupes à lista de programas da linha
- [x] 2.2 Adicionar linha `| fdupes | Localizador de arquivos duplicados | https://github.com/adrianlopezroche/fdupes |` na tabela Tools Terminal
- [x] 2.3 Atualizar o comentário de `tools_terminal.sh` na árvore de estrutura incluindo fdupes

## 3. Verificação

- [x] 3.1 Rodar `bash tests/lint.sh` para ShellCheck
- [x] 3.2 Rodar `bash tests/run.sh` (ShellCheck + BATS) e conferir que os testes existentes seguem passando
