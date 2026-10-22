## Purpose

Define como o instalador provisiona as CLIs Node globais do módulo NPM Globals — pnpm (script standalone), Yarn Classic 1.22.x (npm), Yarn Berry 4.x (Corepack) e OpenSpec (npm) — garantindo binários corretos no PATH, convivência previsível entre as versões do Yarn, aderência à documentação oficial de cada ferramenta e rastreamento individual no módulo.

## ADDED Requirements

### Requirement: pnpm instalado pelo script standalone oficial

O instalador SHALL instalar o pnpm usando o script standalone oficial (`curl -fsSL https://get.pnpm.io/install.sh | sh -`) em vez de `npm i -g pnpm`, e SHALL expor o binário na sessão corrente antes de reportar a versão.

#### Scenario: Instalação do pnpm em máquina sem pnpm

- **WHEN** a instalação do pnpm é executada
- **THEN** o script oficial é baixado e executado, o binário é instalado em `~/.local/share/pnpm` e `pnpm --version` responde com a versão instalada

#### Scenario: pnpm disponível em novos shells

- **WHEN** o usuário abre um novo shell após a instalação
- **THEN** `PNPM_HOME` (`~/.local/share/pnpm`) está no rc do shell e `pnpm` é resolvido no `PATH`, permitindo `pnpm add` e `pnpm self-update`

#### Scenario: Instalação anterior via npm é removida

- **WHEN** existir um pnpm previamente instalado via npm no prefixo global do Node
- **THEN** o instalador remove essa instalação antes de aplicar o método standalone, de modo que `which pnpm` aponte apenas para a instalação standalone

### Requirement: Yarn Classic instalado e reportado separadamente

O instalador SHALL oferecer o Yarn Classic como item próprio, instalado com o comando recomendado pela documentação oficial (`npm install --global yarn@1`), e SHALL reportar sua versão (1.22.x) ao final.

#### Scenario: Instalação do Yarn Classic

- **WHEN** o item Yarn Classic é executado
- **THEN** a versão 1.22.x é instalada globalmente via npm e `yarn --version` retorna uma versão `1.22.x` enquanto o Corepack não estiver ativo

#### Scenario: Yarn Classic reexecutado

- **WHEN** o item é executado em uma máquina que já possui Yarn Classic
- **THEN** a instalação é idempotente, sem erro e mantendo a versão 1.22.x

### Requirement: Yarn Berry instalado via Corepack

O instalador SHALL oferecer o Yarn moderno (Berry 4.x) como item próprio, baseado em Corepack (`corepack enable` e `corepack prepare yarn@stable --activate`), garantindo Corepack disponível mesmo quando não vier embutido no Node.

#### Scenario: Instalação do Yarn Berry

- **WHEN** o item Yarn Berry é executado
- **THEN** o Corepack é habilitado, o canal `stable` do Yarn é ativado e `yarn --version` retorna uma versão 4.x em um diretório sem `packageManager` definido

#### Scenario: Projeto com versão pinada

- **WHEN** o usuário executa `yarn --version` dentro de um projeto cujo `package.json` declara `packageManager`
- **THEN** o Corepack usa a versão declarada pelo projeto, independentemente da versão global ativada

#### Scenario: Corepack ausente na distribuição do Node

- **WHEN** o binário `corepack` não estiver disponível após a instalação do Node
- **THEN** o instalador instala o Corepack via npm antes de habilitá-lo

### Requirement: Convivência entre Yarn Classic e Yarn Berry

O instalador SHALL documentar e preservar a precedência entre os shims de Yarn, de forma que o `yarn` global resolva para Berry 4.x após a instalação do item Berry, sem remover a possibilidade de usar o Classic em projetos que o pinem.

#### Scenario: Ambos os itens instalados

- **WHEN** Yarn Classic e Yarn Berry são instalados na mesma execução, nesta ordem
- **THEN** `yarn --version` fora de um projeto retorna 4.x, e um projeto com `"packageManager": "yarn@1.22.x"` continua executando o Classic

#### Scenario: Descrição coerente com o que é instalado

- **WHEN** o usuário lê o cabeçalho de cada item no menu
- **THEN** o item Classic se descreve como 1.22.x e o item Berry se descreve como Corepack/Yarn 4, sem prometer uma versão que não será instalada

### Requirement: OpenSpec CLI instalado com pré-requisito e versão verificados

O instalador SHALL instalar a CLI OpenSpec com `npm install -g @fission-ai/openspec@latest` apenas quando o Node ativo for 20.19.0 ou superior, SHALL verificar o binário antes de reportar sucesso e SHALL documentar que a instalação pertence à versão de Node ativa.

#### Scenario: Node atende ao pré-requisito

- **WHEN** o item OpenSpec é executado com Node ≥ 20.19.0
- **THEN** o pacote é instalado globalmente, `command -v openspec` é verificado e `openspec --version` retorna a versão instalada

#### Scenario: Node abaixo do pré-requisito

- **WHEN** o Node ativo é anterior a 20.19.0
- **THEN** o instalador aborta o item com mensagem explicativa antes de executar o npm, sem instalar nada

#### Scenario: Binário fora do PATH após a instalação

- **WHEN** o npm termina mas `openspec` não é resolvido no PATH
- **THEN** o item é registrado como falha no relatório, em vez de reportar sucesso

#### Scenario: Troca de versão do Node

- **WHEN** o usuário troca de versão do Node com `nvm use`
- **THEN** a descrição do item e o README informam que o OpenSpec precisa ser reinstalado sob a nova versão, já que a instalação global pertence a uma única versão

### Requirement: Módulo contém apenas ferramentas com instalação global oficial

O módulo NPM Globals SHALL oferecer apenas ferramentas cuja documentação oficial prescreve instalação global, removendo as que são instaladas por projeto, por `npx` ou cuja instalação global é explicitamente desaconselhada.

#### Scenario: Ferramentas removidas do módulo

- **WHEN** o módulo NPM Globals é executado
- **THEN** ESLint, Prettier, tsx, Vue.js, Prisma, json-server e create-next-app não aparecem no menu nem no relatório, e suas funções não existem em `install/npm-globals.sh`

#### Scenario: Ferramentas mantidas no módulo

- **WHEN** o módulo NPM Globals é executado
- **THEN** TypeScript, pnpm, Yarn Classic, Yarn Berry, Nodemon, Concurrently, Serve, Nest.js, npm-check-updates, live-server, 9Router e OpenSpec são instalados e rastreados individualmente

#### Scenario: Documentação espelha o módulo

- **WHEN** o usuário lê o `README.md`
- **THEN** a tabela do módulo, a tabela de programas e a árvore de estrutura listam exatamente os mesmos 12 itens, sem referência às ferramentas removidas

### Requirement: Total do módulo reflete o conjunto final

O contador `_run_npm_globals_total` SHALL corresponder ao número de itens registrados em `run_npm_globals()`, e cada item SHALL ser registrado individualmente.

#### Scenario: Progresso exato do módulo

- **WHEN** o módulo NPM Globals executa com 12 itens rastreados
- **THEN** a barra de progresso alcança 100% somente após todos os itens terminarem

#### Scenario: Falha individual não interrompe o módulo

- **WHEN** a instalação de um dos itens falha
- **THEN** os demais itens continuam sendo executados e a falha é registrada individualmente no relatório do módulo
