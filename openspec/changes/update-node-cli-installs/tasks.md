## 1. pnpm standalone

- [x] 1.1 Substituir o corpo de `install_pnpm()`: `npm uninstall -g pnpm 2>/dev/null || true`, `curl -fsSL https://get.pnpm.io/install.sh | sh -`, `export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"`, `export PATH="$PNPM_HOME:$PATH"` e guarda `command -v pnpm >/dev/null || { log_error ...; return 1; }` — verificar com `shellcheck install/npm-globals.sh` e `grep -q 'get.pnpm.io/install.sh' install/npm-globals.sh`
- [x] 1.2 Atualizar `print_header`/`print_details` do pnpm (método standalone, `PNPM_HOME`, `pnpm self-update`) e o site para `https://pnpm.io/installation` — verificar que o bloco não menciona mais instalação via npm
- [x] 1.3 Adicionar persistência idempotente de `PNPM_HOME` no rc: se `grep -q PNPM_HOME` falhar em `~/.bashrc` e `~/.zshrc`, anexar bloco `PNPM_HOME`/`PATH` aos arquivos existentes — verificar com `bash -n install/npm-globals.sh`

## 2. Yarn Classic

- [x] 2.1 Renomear `install_yarn()` para `install_yarn_classic()` e trocar o comando por `npm install --global yarn@1`; ajustar `print_header`/`print_details` para 1.22.x (sem prometer Berry) e site `https://classic.yarnpkg.com` — verificar com `grep -n 'npm install --global yarn@1' install/npm-globals.sh` e `shellcheck install/npm-globals.sh`
- [x] 2.2 Atualizar a linha do Yarn na tabela NPM Globals do `README.md` para `Yarn Classic` com `https://classic.yarnpkg.com` — verificar que a tabela tem as duas linhas de Yarn ao final do grupo 3

## 3. Yarn Berry (Corepack)

- [x] 3.1 Criar `install_yarn_berry()` após `install_yarn_classic()` com `# https://yarnpkg.com/getting-started/install`, fallback `command -v corepack >/dev/null || npm install -g corepack`, `corepack enable` e `corepack prepare yarn@stable --activate` — verificar com `shellcheck install/npm-globals.sh`
- [x] 3.2 Descrever no `print_details` o fluxo por projeto (`yarn init -2`, `yarn set version stable`) e a precedência sobre o Classic (`packageManager`); adicionar a linha `Yarn Berry` (`https://yarnpkg.com`) na tabela NPM Globals do `README.md` — verificar que as três menções aparecem no bloco e que a tabela não tem mais linha genérica `| Yarn |`

## 4. OpenSpec

- [x] 4.1 Adicionar pré-check de Node ≥ 20.19.0 em `install_openspec()` e abortar o item com `log_error` + `return 1` quando não atender — verificar com `bash -n install/npm-globals.sh` e teste manual do comando `node -e` nas versões LTS instaladas
- [x] 4.2 Trocar o `log_success` por verificação `command -v openspec` + `$(openspec --version)`, e atualizar `# <url>` e `print_details` para `https://openspec.dev/docs/installation` com comandos reais (`openspec init`, `openspec update`, `openspec archive`) e o aviso do vínculo npm↔versão do Node — verificar com `grep -n 'openspec.dev/docs/installation' install/npm-globals.sh` e `shellcheck`
- [x] 4.3 Atualizar a linha do OpenSpec na tabela NPM Globals do `README.md` para `https://openspec.dev/docs/installation` — verificar com `grep -n 'openspec.dev/docs/installation' README.md`

## 5. Remoção das ferramentas sem instalação global oficial

- [x] 5.1 Remover as funções `install_eslint`, `install_prettier`, `install_tsx`, `install_vuejs`, `install_prisma`, `install_json_server` e `install_create_next_app` — verificar que `grep -c '^install_' install/npm-globals.sh` cai para 12
- [x] 5.2 Remover os `track "NPM_GLOBALS"` correspondentes em `run_npm_globals()` — verificar que não resta referência a `install_eslint|install_prettier|install_tsx|install_vuejs|install_prisma|install_json_server|install_create_next_app`
- [x] 5.3 Remover do `README.md` as linhas de ESLint, Prettier, tsx, Vue.js, Prisma, json-server e create-next-app na tabela NPM Globals e atualizar o comentário do `npm-globals.sh` na árvore de estrutura (~linha 396) — verificar que nenhum desses nomes aparece no README. Também atualizar o rótulo do módulo no menu do `install.sh`, que citava Vue

## 6. Integração no módulo

- [x] 6.1 Atualizar `_run_npm_globals_total` de 18 para 12 — verificar `grep -n '_run_npm_globals_total=' install/npm-globals.sh`
- [x] 6.2 Substituir `track ... install_yarn "Yarn"` por `install_yarn_classic "Yarn Classic"` + `install_yarn_berry "Yarn Berry"`, nesta ordem e após o pnpm — verificar que `grep -c 'track "NPM_GLOBALS"' install/npm-globals.sh` retorna 12 e que a ordem é pnpm → Classic → Berry
- [x] 6.3 Atualizar a linha do módulo `npm-globals` no `README.md` (tabela de módulos): contagem `18` → `12` e lista final dos 12 itens — verificar que a contagem bate com `grep -c 'track "NPM_GLOBALS"'`

## 7. Verificação final

- [x] 7.1 Rodar `shellcheck install/npm-globals.sh` (arquivo alterado) e confirmar zero achados; rodar `bash tests/lint.sh` e confirmar que a mudança não adiciona achados novos (baseline 73 → 72; os 72 restantes são pré-existentes em arquivos não tocados)
- [x] 7.2 Rodar `bash tests/run.sh` e confirmar BATS passando (17/17) — o aviso de ShellCheck do runner é o mesmo débito pré-existente do item 7.1
- [x] 7.3 Smoke test manual sem sudo: executar o módulo NPM Globals via `./install.sh` e confirmar `pnpm --version`, `yarn --version` (4.x após o item Berry), `corepack --version` e `openspec --version` respondendo; abrir um novo shell zsh e confirmar que `pnpm` continua no `PATH` — executado apenas os 4 itens alterados (pnpm 12.15.0, Yarn Classic 1.22.22, Yarn Berry 4.18.1, OpenSpec 1.14.3), sem reinstalar os 8 itens inalterados; `pnpm` resolvido em `zsh -ic` e `bash -ic`
