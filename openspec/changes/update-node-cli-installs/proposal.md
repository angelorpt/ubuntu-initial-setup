## Why

Os métodos atuais de instalação de CLIs Node no módulo NPM Globals estão desatualizados em relação à documentação oficial: o pnpm usa `npm i -g pnpm` (método legado, sem `self-update` e preso ao prefixo do Node); o Yarn usa `npm i -g yarn`, que traz apenas o Classic 1.22.x enquanto o `print_details` promete Berry v4; e sete itens (ESLint, Prettier, tsx, Vue.js, Prisma, json-server, create-next-app) são instalados globalmente mesmo que suas documentações oficiais hoje prescrevam instalação local, `npx` ou por projeto. Dois deles instalam artefatos instáveis: a dist-tag `latest` do Prisma aponta para `8.0.0-rc.25` (release candidate, estável em 7.10.1) e a do json-server para `1.0.0-beta.15` (estável em 0.17.4).

O item OpenSpec tem problema semelhante: instala sem checar o pré-requisito oficial (Node ≥ 20.19.0) nem o resultado, reporta sucesso mesmo quando o binário não entra no PATH, descreve comandos que não existem na CLI (`openspec propose`, `openspec apply`) e não avisa que a instalação global via npm pertence a uma única versão do Node — trocar de versão com `nvm use` faz o `openspec` desaparecer, como já aconteceu nesta máquina (1.11.0 em v24.18.0, ausente em v24.22.1).

## What Changes

- **pnpm**: trocar `npm i -g pnpm` pelo script standalone oficial `curl -fsSL https://get.pnpm.io/install.sh | sh -`, com `PNPM_HOME` (`~/.local/share/pnpm`) persistido no rc do shell e disponível na sessão corrente
- **Yarn Classic**: renomear `install_yarn` para `install_yarn_classic` e usar o comando recomendado pela doc oficial `npm install --global yarn@1` (1.22.x)
- **Yarn Berry (moderno)**: novo `install_yarn_berry` via Corepack (`npm install -g corepack` como fallback, `corepack enable` e `corepack prepare yarn@stable --activate`), com `yarn init -2` / `yarn set version stable` documentados como fluxo por projeto
- **OpenSpec**: manter `npm install -g @fission-ai/openspec@latest` (único método global oficial no Linux), com pré-check de Node ≥ 20.19.0, verificação de `openspec --version`, URL `https://openspec.dev/docs/installation`, texto de uso corrigido (`openspec init`, `openspec update`, `openspec archive`) e aviso de que a instalação vale para a versão de Node ativa
- **Remover 7 itens sem instalação global na doc oficial**: ESLint (global existe mas é "not recommended"), Prettier (só local), tsx (só local), Vue.js (`npm create vue@latest`), Prisma (`npm create prisma@latest` / `npx`), json-server (local + `npx`) e create-next-app (`npm create next-app`) — funções, `track` e linhas do README removidos
- **BREAKING (interno)**: `_run_npm_globals_total` passa de 18 para 12; o módulo passa a listar apenas ferramentas com instalação global oficial
- Remover instalações legadas via npm antes de aplicar os novos métodos (`npm uninstall -g pnpm` / shim antigo), evitando binários conflitantes no PATH
- Atualizar `README.md` (tabela do módulo, tabela de programas e árvore de estrutura) e o `print_details` do Yarn, que hoje descreve Berry sem instalá-lo

## Capabilities

### New Capabilities

- `node-package-managers`: métodos de instalação, verificação e persistência no PATH do pnpm (standalone), Yarn Classic (npm), Yarn Berry (Corepack) e da CLI OpenSpec, incluindo a política de que o módulo NPM Globals só contém ferramentas com instalação global oficial, a precedência entre os shims de Yarn e o total do módulo

### Modified Capabilities

## Impact

- `install/npm-globals.sh`: `install_pnpm` (método), `install_yarn` → `install_yarn_classic` + `install_yarn_berry`, `install_openspec` (pré-check + verificação), remoção de `install_eslint`, `install_prettier`, `install_tsx`, `install_vuejs`, `install_prisma`, `install_json_server`, `install_create_next_app`, `_run_npm_globals_total` 18 → 12 e os `track` correspondentes
- `README.md`: linha 147 (contagem/lista do módulo `npm-globals`), tabela NPM Globals (linhas ~282-296, com remoções e sites atualizados) e árvore de estrutura (~linha 396)
- `install.sh`: rótulo do módulo no menu do whiptail, que citava Vue e passa a listar TypeScript, pnpm, Yarn e OpenSpec
- Dependências: `curl` (já instalado no módulo BASE), Node LTS via NVM (módulo DEV), `corepack` (bundled no Node ≥ 16.10, com fallback via npm) e Node ≥ 20.19.0 para o OpenSpec
- Shell: `PNPM_HOME` e `PATH` passam a ser escritos em `~/.zshrc` (zsh é o shell final do setup) e/ou `~/.bashrc`
- Impacto em runtime: após `corepack enable`, o `yarn` global passa a ser o Berry 4.x, sombreando o Classic 1.22.x instalado por npm (documentado no design; Classic continua acessível via `packageManager` pinado por projeto); ferramentas removidas passam a ser instaladas por projeto (`npm i -D` / `npx`)
- Fora de escopo deste change (repo pai): atualizar a linha `NPM_GLOBALS` (18) em `bash-codes/AGENTS.md`
