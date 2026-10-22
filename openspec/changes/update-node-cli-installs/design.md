## Context

Ver `proposal.md` — Why. O módulo `install/npm-globals.sh` segue o padrão do repositório: cada programa é uma função `install_*` com `# <url>` no topo, `print_header`, `print_details`, comando de instalação e `log_success`; o total fica em `_run_npm_globals_total` e cada item é registrado por `track` em `run_npm_globals()`.

Restrições relevantes do ambiente:

- `install.sh` roda com `set -uo pipefail` (sem `-e`): uma falha isolada não aborta o módulo, então cada função precisa checar seu próprio resultado.
- Node é instalado via NVM (módulo DEV), portanto o prefixo global do npm é `~/.nvm/versions/node/<versão>/bin` — gravável pelo usuário, o que permite `corepack enable` sem `sudo`.
- O setup termina com zsh (módulo BASE), mas o instalador pode rodar sob bash; o script oficial do pnpm escolhe o rc com base em `$SHELL`, o que pode deixar `PNPM_HOME` fora do `~/.zshrc`.
- `track` decide sucesso/falha pelo código de retorno da função, e `$(pnpm --version)` dentro de `log_success` falharia silenciosamente se o binário não estivesse no PATH.
- Auditoria de 2026-10-22: das 18 ferramentas do módulo, 7 não têm mais instalação global na documentação oficial (ESLint, Prettier, tsx, Vue.js, Prisma, json-server, create-next-app). Duas instalam artefatos instáveis ao usar `latest`: Prisma (`8.0.0-rc.25`, estável `7.10.1`) e json-server (`1.0.0-beta.15`, estável `0.17.4`).
- Todo `npm i -g` pertence a uma versão específica do Node (confirmado na doc do OpenSpec); trocar de versão com `nvm use` remove os binários do PATH.

## Goals / Non-Goals

**Goals:**

- Instalar cada ferramenta com o método recomendado pela documentação oficial vigente.
- Reduzir o módulo às 12 ferramentas com instalação global oficial, garantindo binários resolvíveis no PATH ao final da execução e em shells novos.
- Manter o padrão de módulo (contagem, `track`, progresso, relatório) intacto.
- Deixar explícita a precedência do Yarn e o vínculo npm↔versão do Node para o usuário, sem surpresas.

**Non-Goals:**

- Não criar módulo novo: os 12 itens continuam em NPM Globals; ferramentas por projeto passam a ser instaladas pelo usuário (`npm i -D` / `npx`).
- Não alterar a instalação de Node/NVM nem substituir o npm.
- Não instalar versões pinadas por projeto (`yarn set version`) — isso é fluxo do usuário, apenas documentado.
- Não incluir bun ou deno: ficam para um change separado (`add-js-runtimes`).
- Não atualizar `bash-codes/AGENTS.md` (repo pai, raiz diferente desta change).

## Decisions

### pnpm via script standalone

```bash
npm uninstall -g pnpm 2>/dev/null || true
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
export PATH="$PNPM_HOME:$PATH"
command -v pnpm >/dev/null || { log_error "pnpm não encontrado após a instalação"; return 1; }
```

- **Por que standalone**: é o método que a doc do pnpm marca para POSIX, instala binário nativo (pnpm 12 não depende de Node para rodar), suporta `pnpm self-update` e não fica preso ao prefixo do Node/NVM. Alternativa `npm i -g pnpm` foi descartada: é o método legado, atualizável só via npm e atrelado à versão do Node.
- **`npm uninstall -g pnpm`**: evita dois binários `pnpm` no PATH (`~/.nvm/.../bin/pnpm` e `~/.local/share/pnpm/pnpm`), cuja precedência dependeria da ordem de inicialização do rc. O `|| true` é aceitável porque "não havia pnpm global" não é erro de instalação.
- **Persistência no rc**: o script oficial grava `PNPM_HOME` no rc detectado por `$SHELL`. Para cobrir bash→zsh, após o install verificar cada arquivo (`~/.bashrc`, `~/.zshrc`) individualmente com `grep -q PNPM_HOME` e anexar bloco idempotente (`PNPM_HOME` + `PATH`) somente nos que existirem e não tiverem a variável. A sessão corrente recebe o `export` explicitamente para o `log_success` poder reportar a versão.
- **Versão**: sem `PNPM_VERSION`, seguindo o padrão do repo de não fixar versões (usa `latest` do canal).

### Yarn Classic via npm

```bash
npm install --global yarn@1
npm install --global yarn@1
log_success "Yarn Classic instalado: $(yarn --version)"   # se o shim do Corepack já vencer, o log informa a versão em uso
```

- **Por que npm**: é o método único recomendado pela doc do Classic (cross-platform) e o `@1` fixa o canal 1.22.x, que é o que "Classic" significa.
- **Alternativa (repo apt da Yarn)**: descartada. O repositório `dl.yarnpkg.com/debian` traz `nodejs` do Ubuntu como dependência, o que conflita com o Node do NVM e pode sobrescrever o binário gerenciado. Além disso exigiria `sudo` e importação de chave GPG, aumentando a superfície de falha sem ganho.
- **Renomear a função** `install_yarn` → `install_yarn_classic` para que o nome do `track` reflita o produto.

### Yarn Berry via Corepack

```bash
command -v corepack >/dev/null || npm install -g corepack
corepack enable
corepack prepare yarn@stable --activate
log_success "Yarn Berry instalado: $(yarn --version)"
```

- **Por que Corepack**: é o caminho oficial da doc do Yarn 2+ (instalar Corepack, depois `yarn init -2`/`yarn set version stable`). `corepack prepare yarn@stable --activate` define uma versão global padrão, tornando `yarn` utilizável fora de projetos — algo que `yarn init -2` (por projeto) não faz.
- **Fallback de Corepack**: Node ≥ 16.10 distribui Corepack, mas builds recentes podem removê-lo; `npm install -g corepack` cobre isso sem depender de versão específica.
- **`corepack enable` sem `sudo`**: funciona porque o bin do NVM é do usuário. Se o Node viesse de apt, seria necessário `sudo` — caso não coberto por este change (o repo usa NVM).
- **Per-project**: documentar em `print_details` que `yarn init -2` / `yarn set version stable` criam o pin no projeto e que o Corepack honra o campo `packageManager`.

### Precedência entre Classic e Berry

`corepack enable` instala o shim `yarn` no mesmo diretório de bin do Node, sobrescrevendo o symlink criado por `npm i -g yarn`. Como o setup não tem `-e`, ambos podem coexistir; a ordem dos `track` define quem vence:

1. `pnpm`
2. `Yarn Classic`
3. `Yarn Berry` (último → `yarn` global resolve para 4.x)

- **Por que essa ordem**: o estado final é o mais moderno por padrão, e o Classic continua acessível em projetos com `"packageManager": "yarn@1.22.x"` (Corepack baixa e usa a versão pinada). O `print_details` de cada item explicita isso para evitar a expectativa de "versão que não foi instalada", problema atual do texto que promete Berry v4.
- **Alternativa (instalar Berry antes do Classic)**: descartada — o npm sobrescreveria o shim do Corepack e o estado final voltaria a ser 1.22.x, anulando o item Berry.

### OpenSpec via npm global com pré-check

```bash
node -e 'const [maj, min] = process.versions.node.split(".").map(Number); process.exit(maj > 20 || (maj === 20 && min >= 19) ? 0 : 1)' \
  || { log_error "OpenSpec exige Node >= 20.19.0"; return 1; }
npm install -g @fission-ai/openspec@latest
command -v openspec >/dev/null || { log_error "openspec não encontrado no PATH"; return 1; }
log_success "OpenSpec instalado: $(openspec --version)"
```

- **Por que npm**: é o método global padrão da doc oficial no Linux. Homebrew foi descartado (módulo não instala brew e o setup é Ubuntu), assim como Deno e Nix (runtime extra) e Bun (não executa a CLI sem Node).
- **Pré-check**: a doc exige Node ≥ 20.19.0; falhar aqui evita erro críptico do npm.
- **Verificação de PATH**: sem ela o item reportava sucesso mesmo quando o binário não estava disponível.
- **Vínculo com a versão do Node**: a doc oficial diz que a instalação global não acompanha a troca de versão; o `print_details` e o README passam a avisar, e o usuário reinstala sob a versão desejada.
- **Texto de uso corrigido**: `openspec propose` e `openspec apply` não existem na CLI; os comandos reais são `openspec init`, `openspec update` e `openspec archive` (os fluxos `/opsx:*` rodam no agente, não na CLI).

### Remoção das ferramentas sem instalação global oficial

| Removido | Doc oficial hoje | Motivo |
|---|---|---|
| ESLint | `npm init @eslint/config@latest` + `npm i -D eslint` + `npx eslint`; global "not recommended" | instalação por projeto; plugins globais não resolvem |
| Prettier | `npm i -D --save-exact prettier@3` + `npx prettier` | página de instalação só cobre local |
| tsx | `npm i -D tsx` + `npx tsx` | doc só cobre local |
| Vue.js | `npm create vue@latest` | CLI (`@vue/cli`) em manutenção desde 2021; scaffold atual é create-vue |
| Prisma | `npm create prisma@latest` / `npx prisma@latest` | global nunca documentado; `latest` está em RC 8.0.0-rc.25 |
| json-server | `npm install json-server` + `npx json-server` | global não documentado; `latest` está em beta 1.0.0-beta.15 |
| create-next-app | `npm create next-app` | scaffold por projeto |

- **Por que remover em vez de fixar versão**: fixar `prisma@7` ou `json-server@0.17.4` manteria binários globais que a doc oficial não suporta, e o usuário precisa da versão do projeto, não da global.
- **Alternativa considerada (instalar `create-vue`/`create-next-app` globais)**: descartada por contrariar a política escolhida — scaffolders são por projeto.
- **Consequência**: `_run_npm_globals_total` 18 → 12 (`18 + 1` do split do Yarn `- 7` remoções).

### Contagem e README

- `_run_npm_globals_total`: 18 → 12.
- `README.md` linha 147: `18` → `12` e lista final `TypeScript, pnpm, Yarn Classic, Yarn Berry, Nodemon, Concurrently, Serve, Nest.js, npm-check-updates, live-server, 9Router, OpenSpec`.
- `README.md` tabela NPM Globals: remover as linhas de ESLint, Prettier, tsx, Vue.js, Prisma, json-server e create-next-app; dividir o Yarn em Classic (`https://classic.yarnpkg.com`) e Berry (`https://yarnpkg.com`); pnpm → `https://pnpm.io/installation`; OpenSpec → `https://openspec.dev/docs/installation`.
- `README.md` árvore de estrutura (~396): comentário do `npm-globals.sh` passa a citar TypeScript, pnpm, Yarn, Nest.js e mais.

## Risks / Trade-offs

- [Script standalone depende de rede e de `curl`] → `curl` já vem do módulo BASE; falha de rede faz `command -v pnpm` falhar e a função retorna 1, registrando falha individual via `track` sem abortar o módulo.
- [`PNPM_HOME` gravado no rc errado (bash instalado, zsh em uso)] → verificação pós-install e bloco idempotente nos rc existentes.
- [Corepack sobrescreve o `yarn` do Classic instalado por npm] → comportamento esperado e documentado; ordem dos `track` garante Berry como padrão; Classic segue disponível via `packageManager`.
- [`corepack enable` falha se o prefixo do Node exigir `sudo`] → cenário fora do escopo (Node via NVM garante prefixo do usuário); a falha é reportada como falha do item Berry sem afetar os demais.
- [`npm uninstall -g pnpm` pode remover o pnpm que o usuário usava antes de o standalone concluir] → o install roda em seguida na mesma função; se o download falhar, o estado é "sem pnpm" e a falha fica registrada explicitamente no relatório, em vez de silenciosa.
- [Remoção de ESLint, Prettier e tsx pode frustrar quem usava os binários globais] → mudança é intencional e alinhada à doc; README passa a indicar instalação por projeto (`npm i -D` / `npx`).
- [Prisma e json-server deixam de existir no setup] → evita instalar RC/beta sem aviso; o usuário roda `npm create prisma@latest` / `npx json-server` no projeto.
- [Pré-check de Node do OpenSpec usa comparação de versão em `node -e`] → testado com as versões LTS instaladas; falha vira erro explícito do item, sem abortar o módulo.
- [Tempo de instalação maior: script standalone + Corepack download] → aceitável para setup único; itens são independentes e rastreados separadamente.

## Migration Plan

1. Reexecutar o setup (`./install.sh --all` ou `--retry`/`--continue`) para aplicar os novos métodos.
2. pnpm antigo via npm é removido automaticamente; pnpm standalone assume o PATH.
3. Ferramentas removidas (ESLint, Prettier, tsx, Vue.js, Prisma, json-server, create-next-app) passam a ser instaladas por projeto; binários globais antigos não são desinstalados por este change (ficam a cargo do usuário).
4. Usuários que dependem do Yarn 1.22 global devem pinar `packageManager` no projeto ou rodar o item Classic isoladamente (o Berry vencerá no `yarn` global).
5. Rollback: reverter `install/npm-globals.sh` e `README.md` para o commit anterior e reexecutar; não há migração de estado irreversível (apenas binários em `~/.local/share/pnpm` e shims do Corepack).

## Open Questions

Nenhuma pendente.
