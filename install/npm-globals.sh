install_typescript() {
  # https://www.typescriptlang.org/
  print_header "TypeScript" "Compilador TypeScript"
  print_details "https://www.typescriptlang.org" \
    "Superset do JavaScript com tipagem estática opcional" \
    "Compila para JS limpo, interfaces, generics, enums" \
    "Uso: tsc arquivo.ts, tsc --init"
  npm i -g typescript
  log_success "TypeScript instalado: $(tsc --version)"
}

install_prettier() {
  # https://prettier.io/
  print_header "Prettier" "Formatador de código opinativo"
  print_details "https://prettier.io" \
    "Formata código JS/TS/CSS/JSON/MD/YAML consistentemente" \
    "Sem opções de estilo — formato único pré-definido" \
    "Uso: prettier --write src/"
  npm i -g prettier
  log_success "Prettier instalado: $(prettier --version)"
}

install_eslint() {
  # https://eslint.org/
  print_header "ESLint" "Linter de JavaScript/TypeScript"
  print_details "https://eslint.org" \
    "Encontra e corrige problemas em JS/TS com regras customizáveis" \
    "Integra com Prettier, suporte a plugins (React, Vue)" \
    "Uso: eslint src/ --fix"
  npm i -g eslint
  log_success "ESLint instalado: $(eslint --version)"
}

install_pnpm() {
  # https://pnpm.io/
  print_header "pnpm" "Gerenciador de pacotes rápido e eficiente"
  print_details "https://pnpm.io" \
    "3x mais rápido que npm, economia de disco com hard links" \
    "Workspaces nativos, lockfile rigoroso, suporte a monorepo" \
    "Uso: pnpm add react, pnpm install"
  npm i -g pnpm
  log_success "pnpm instalado: $(pnpm --version)"
}

install_yarn() {
  # https://yarnpkg.com/
  print_header "Yarn" "Gerenciador de pacotes alternativo"
  print_details "https://yarnpkg.com" \
    "Alternativa ao npm com cache offline e instalação paralela" \
    "Yarn Berry (v4): PnP, workspaces, plugins" \
    "Uso: yarn add react, yarn install"
  npm i -g yarn
  log_success "Yarn instalado: $(yarn --version)"
}

install_tsx() {
  # https://github.com/privatenumber/tsx
  print_header "tsx" "Executar TypeScript diretamente sem compilar"
  print_details "https://github.com/privatenumber/tsx" \
    "Node.js enhanced que roda .ts e .tsx sem ts-node ou build" \
    "Baseado no esbuild (rápido), watch mode nativo" \
    "Uso: tsx script.ts"
  npm i -g tsx
  log_success "tsx instalado"
}

install_nodemon() {
  # https://nodemon.io/
  print_header "Nodemon" "Auto-restart em alterações de código"
  print_details "https://nodemon.io" \
    "Reinicia automaticamente o servidor Node ao salvar mudanças" \
    "Ignora node_modules, watch de extensões customizáveis" \
    "Uso: nodemon server.js, nodemon --ext ts src/"
  npm i -g nodemon
  log_success "Nodemon instalado: $(nodemon --version)"
}

install_concurrently() {
  # https://github.com/open-cli-tools/concurrently
  print_header "Concurrently" "Rodar múltiplos comandos em paralelo"
  print_details "https://github.com/open-cli-tools/concurrently" \
    "Executa scripts npm em paralelo com prefixo colorido" \
    "Útil para frontend + backend simultaneamente" \
    "Uso: concurrently 'npm run dev' 'npm run api'"
  npm i -g concurrently
  log_success "Concurrently instalado: $(concurrently --version)"
}

install_serve() {
  # https://github.com/vercel/serve
  print_header "Serve" "Servidor estático moderno pela Vercel"
  print_details "https://github.com/vercel/serve" \
    "Servidor HTTP zero-config para SPAs e páginas estáticas" \
    "Suporte a SPA (fallback para index.html), HTTPS, CORS" \
    "Uso: serve -s dist (SPA), serve . (lista diretório)"
  npm i -g serve
  log_success "Serve instalado: $(serve --version 2>&1 | head -1)"
}

install_nestjs() {
  # https://docs.nestjs.com/first-steps
  print_header "Nest.js" "Framework Node.js progressivo"
  print_details "https://nestjs.com" \
    "Framework backend com arquitetura modular, decorators e DI" \
    "Suporte nativo a GraphQL, WebSockets, microserviços" \
    "Uso: nest new projeto, nest generate resource"
  npm i -g @nestjs/cli
  log_success "Nest.js CLI instalado: $(nest --version)"
}

install_vuejs() {
  # https://cli.vuejs.org/guide/installation.html
  print_header "Vue.js" "Framework JS progressivo"
  print_details "https://vuejs.org" \
    "Framework reativo e progressivo para SPAs e interfaces" \
    "Vue CLI para scaffolding, Vue 3 com Composition API" \
    "Uso: vue create projeto, vue ui"
  npm i -g @vue/cli
  log_success "Vue.js CLI instalado: $(vue --version)"
}

install_prisma() {
  # https://www.prisma.io/
  print_header "Prisma" "ORM moderno para Node.js e TypeScript"
  print_details "https://www.prisma.io" \
    "ORM type-safe: schema declarativo, migrations, queries" \
    "Prisma Studio: GUI visual para o banco, suporte a MySQL/PG/SQLite" \
    "Uso: prisma init, prisma db push, npx prisma studio"
  npm i -g prisma
  log_success "Prisma instalado: $(prisma --version 2>&1 | head -1)"
}

install_json_server() {
  # https://github.com/typicode/json-server
  print_header "json-server" "API REST fake com zero configuração"
  print_details "https://github.com/typicode/json-server" \
    "Cria API REST completa a partir de um arquivo JSON" \
    "Suporte a paginação, filtros, ordenação, POST/PUT/DELETE" \
    "Uso: json-server --watch db.json"
  npm i -g json-server
  log_success "json-server instalado: $(json-server --version 2>&1 | head -1)"
}

install_create_next_app() {
  # https://nextjs.org/docs/api-reference/create-next-app
  print_header "create-next-app" "Scaffolding de projetos Next.js"
  print_details "https://nextjs.org" \
    "Inicia projetos Next.js com configuração zero" \
    "Suporte a TypeScript, App Router, Tailwind CSS" \
    "Uso: npx create-next-app@latest meu-app"
  npm i -g create-next-app
  log_success "create-next-app instalado"
}

install_npm_check_updates() {
  # https://github.com/raineorshine/npm-check-updates
  print_header "npm-check-updates" "Atualizar versões de dependências no package.json"
  print_details "https://github.com/raineorshine/npm-check-updates" \
    "Verifica versões mais recentes de dependências npm" \
    "Atualiza package.json automaticamente (ncu -u)" \
    "Uso: ncu (verificar), ncu -u (atualizar)"
  npm i -g npm-check-updates
  log_success "npm-check-updates instalado: $(ncu --version)"
}

install_live_server() {
  # https://github.com/tapio/live-server
  print_header "live-server" "Servidor com live reload para páginas estáticas"
  print_details "https://github.com/tapio/live-server" \
    "Servidor HTTP com recarregamento automático ao salvar" \
    "Ideal para desenvolvimento de HTML/CSS/JS simples" \
    "Uso: live-server . (abre no navegador com watch)"
  npm i -g live-server
  log_success "live-server instalado"
}

install_9router() {
  # https://github.com/decolua/9router
  print_header "9Router" "Roteador CLI"
  print_details "https://github.com/decolua/9router" \
    "Roteador leve e rápido para linha de comando" \
    "Organiza comandos em rotas estilo framework web" \
    "Uso: 9router exec caminho"
  npm i -g 9router
  log_success "9Router instalado"
}

install_openspec() {
  # https://github.com/Fission-AI/OpenSpec
  print_header "OpenSpec" "Gerenciador de mudanças para projetos de IA"
  print_details "https://github.com/Fission-AI/OpenSpec" \
    "Planeja, implementa e arquiva mudanças em projetos" \
    "Gera specs técnicas, rastreia tasks, sincroniza com código" \
    "Uso: openspec propose, openspec apply, openspec archive"
  npm i -g @fission-ai/openspec@latest
  log_success "OpenSpec instalado"
}

_run_npm_globals_total=18

run_npm_globals() {
  init_module_progress $_run_npm_globals_total "NPM Globals"
  track "NPM_GLOBALS" install_typescript "TypeScript"
  track "NPM_GLOBALS" install_prettier "Prettier"
  track "NPM_GLOBALS" install_eslint "ESLint"
  track "NPM_GLOBALS" install_pnpm "pnpm"
  track "NPM_GLOBALS" install_yarn "Yarn"
  track "NPM_GLOBALS" install_tsx "tsx"
  track "NPM_GLOBALS" install_nodemon "Nodemon"
  track "NPM_GLOBALS" install_concurrently "Concurrently"
  track "NPM_GLOBALS" install_serve "Serve"
  track "NPM_GLOBALS" install_nestjs "Nest.js"
  track "NPM_GLOBALS" install_vuejs "Vue.js"
  track "NPM_GLOBALS" install_prisma "Prisma"
  track "NPM_GLOBALS" install_json_server "json-server"
  track "NPM_GLOBALS" install_create_next_app "create-next-app"
  track "NPM_GLOBALS" install_npm_check_updates "npm-check-updates"
  track "NPM_GLOBALS" install_live_server "live-server"
  track "NPM_GLOBALS" install_9router "9Router"
  track "NPM_GLOBALS" install_openspec "OpenSpec"
  end_module_progress
}
