install_typescript() {
  # https://www.typescriptlang.org/
  print_header "TypeScript" "Compilador TypeScript — https://www.typescriptlang.org"
  log_info "↪ https://www.typescriptlang.org/"
  npm i -g typescript
  log_success "TypeScript instalado: $(tsc --version)"
}

install_prettier() {
  # https://prettier.io/
  print_header "Prettier" "Formatador de código opinativo — https://prettier.io"
  log_info "↪ https://prettier.io/"
  npm i -g prettier
  log_success "Prettier instalado: $(prettier --version)"
}

install_eslint() {
  # https://eslint.org/
  print_header "ESLint" "Linter de JavaScript/TypeScript — https://eslint.org"
  log_info "↪ https://eslint.org/"
  npm i -g eslint
  log_success "ESLint instalado: $(eslint --version)"
}

install_pnpm() {
  # https://pnpm.io/
  print_header "pnpm" "Gerenciador de pacotes rápido e eficiente — https://pnpm.io"
  log_info "↪ https://pnpm.io/"
  npm i -g pnpm
  log_success "pnpm instalado: $(pnpm --version)"
}

install_yarn() {
  # https://yarnpkg.com/
  print_header "Yarn" "Gerenciador de pacotes alternativo — https://yarnpkg.com"
  log_info "↪ https://yarnpkg.com/"
  npm i -g yarn
  log_success "Yarn instalado: $(yarn --version)"
}

install_tsx() {
  # https://github.com/privatenumber/tsx
  print_header "tsx" "Executar TypeScript diretamente sem compilar — https://github.com/privatenumber/tsx"
  log_info "↪ https://github.com/privatenumber/tsx"
  npm i -g tsx
  log_success "tsx instalado"
}

install_nodemon() {
  # https://nodemon.io/
  print_header "Nodemon" "Auto-restart em alterações de código — https://nodemon.io"
  log_info "↪ https://nodemon.io/"
  npm i -g nodemon
  log_success "Nodemon instalado: $(nodemon --version)"
}

install_concurrently() {
  # https://github.com/open-cli-tools/concurrently
  print_header "Concurrently" "Rodar múltiplos comandos em paralelo — https://github.com/open-cli-tools/concurrently"
  log_info "↪ https://github.com/open-cli-tools/concurrently"
  npm i -g concurrently
  log_success "Concurrently instalado: $(concurrently --version)"
}

install_serve() {
  # https://github.com/vercel/serve
  print_header "Serve" "Servidor estático moderno pela Vercel — https://github.com/vercel/serve"
  log_info "↪ https://github.com/vercel/serve"
  npm i -g serve
  log_success "Serve instalado: $(serve --version 2>&1 | head -1)"
}

install_nestjs() {
  # https://docs.nestjs.com/first-steps
  print_header "Nest.js" "Framework Node.js progressivo — https://nestjs.com"
  log_info "↪ https://docs.nestjs.com/first-steps"
  npm i -g @nestjs/cli
  log_success "Nest.js CLI instalado: $(nest --version)"
}

install_vuejs() {
  # https://cli.vuejs.org/guide/installation.html
  print_header "Vue.js" "Framework JS progressivo — https://vuejs.org"
  log_info "↪ https://cli.vuejs.org/guide/installation.html"
  npm i -g @vue/cli
  log_success "Vue.js CLI instalado: $(vue --version)"
}

install_prisma() {
  # https://www.prisma.io/
  print_header "Prisma" "ORM moderno para Node.js e TypeScript — https://www.prisma.io"
  log_info "↪ https://www.prisma.io/"
  npm i -g prisma
  log_success "Prisma instalado: $(prisma --version 2>&1 | head -1)"
}

install_json_server() {
  # https://github.com/typicode/json-server
  print_header "json-server" "API REST fake com zero configuração — https://github.com/typicode/json-server"
  log_info "↪ https://github.com/typicode/json-server"
  npm i -g json-server
  log_success "json-server instalado: $(json-server --version 2>&1 | head -1)"
}

install_create_next_app() {
  # https://nextjs.org/docs/api-reference/create-next-app
  print_header "create-next-app" "Scaffolding de projetos Next.js — https://nextjs.org"
  log_info "↪ https://nextjs.org/docs/api-reference/create-next-app"
  npm i -g create-next-app
  log_success "create-next-app instalado"
}

install_npm_check_updates() {
  # https://github.com/raineorshine/npm-check-updates
  print_header "npm-check-updates" "Atualizar versões de dependências no package.json — https://github.com/raineorshine/npm-check-updates"
  log_info "↪ https://github.com/raineorshine/npm-check-updates"
  npm i -g npm-check-updates
  log_success "npm-check-updates instalado: $(ncu --version)"
}

install_live_server() {
  # https://github.com/tapio/live-server
  print_header "live-server" "Servidor com live reload para páginas estáticas — https://github.com/tapio/live-server"
  log_info "↪ https://github.com/tapio/live-server"
  npm i -g live-server
  log_success "live-server instalado"
}

install_9router() {
  # https://github.com/decolua/9router
  print_header "9Router" "Roteador CLI — https://github.com/decolua/9router"
  log_info "↪ https://github.com/decolua/9router"
  npm i -g 9router
  log_success "9Router instalado"
}

install_openspec() {
  # https://github.com/Fission-AI/OpenSpec
  print_header "OpenSpec" "Gerenciador de mudanças para projetos de IA — https://github.com/Fission-AI/OpenSpec"
  log_info "↪ https://github.com/Fission-AI/OpenSpec"
  npm i -g @fission-ai/openspec@latest
  log_success "OpenSpec instalado"
}

run_npm_globals() {
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
}
