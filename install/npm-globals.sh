# shellcheck shell=bash

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

install_pnpm() {
  # https://pnpm.io/installation
  print_header "pnpm" "Gerenciador de pacotes rápido e eficiente"
  print_details "https://pnpm.io/installation" \
    "3x mais rápido que npm, economia de disco com hard links" \
    "Workspaces nativos, lockfile rigoroso, suporte a monorepo" \
    "Instalação standalone: binário em ~/.local/share/pnpm, independente da versão do Node" \
    "Uso: pnpm add react, pnpm install, pnpm self-update"
  npm uninstall -g pnpm >/dev/null 2>&1 || true
  curl -fsSL https://get.pnpm.io/install.sh | sh -
  export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
  export PATH="$PNPM_HOME:$PATH"
  command -v pnpm >/dev/null || { log_error "pnpm não encontrado no PATH após a instalação"; return 1; }
  local rc
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    grep -q 'PNPM_HOME' "$rc" && continue
    cat >> "$rc" <<'EOF'

# pnpm
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
export PATH="$PNPM_HOME:$PATH"
EOF
  done
  log_success "pnpm instalado: $(pnpm --version)"
}

install_yarn_classic() {
  # https://classic.yarnpkg.com
  print_header "Yarn Classic" "Gerenciador de pacotes (linha 1.22.x)"
  print_details "https://classic.yarnpkg.com" \
    "Versão clássica mantida em 1.22.x, instalada globalmente via npm" \
    "Alternativa ao npm com cache offline e instalação paralela" \
    "Para o Yarn moderno (4.x), use o item Yarn Berry" \
    "Uso: yarn add react, yarn install"
  npm install --global yarn@1
  local yarn_version
  yarn_version=$(yarn --version 2>/dev/null || true)
  if [[ "$yarn_version" == 1.* ]]; then
    log_success "Yarn Classic instalado: $yarn_version"
  else
    log_success "Yarn Classic instalado via npm (shim do Corepack ativo: yarn --version = ${yarn_version:-indisponível})"
  fi
}

install_yarn_berry() {
  # https://yarnpkg.com/getting-started/install
  print_header "Yarn Berry" "Yarn moderno (4.x) via Corepack"
  print_details "https://yarnpkg.com/getting-started/install" \
    "Yarn 4.x gerenciado pelo Corepack (distribuído com o Node)" \
    "Ativa o canal stable globalmente; projetos podem pinar a versão" \
    "Fluxo por projeto: yarn init -2 ou yarn set version stable (grava packageManager)" \
    "O Corepack respeita o packageManager do projeto, inclusive yarn@1.22.x"
  command -v corepack >/dev/null || npm install -g corepack
  corepack enable || { log_error "Falha ao habilitar o Corepack"; return 1; }
  corepack prepare yarn@stable --activate || { log_error "Falha ao ativar o Yarn stable"; return 1; }
  local yarn_version
  yarn_version=$(yarn --version 2>/dev/null || true)
  case "$yarn_version" in
    1.*|"")
      log_error "Yarn Berry não ativado (yarn --version: ${yarn_version:-indisponível})"
      return 1
      ;;
    *)
      log_success "Yarn Berry instalado: $yarn_version"
      ;;
  esac
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
  # https://openspec.dev/docs/installation
  print_header "OpenSpec" "Gerenciador de mudanças para projetos de IA"
  print_details "https://openspec.dev/docs/installation" \
    "Planeja, implementa e arquiva mudanças em projetos" \
    "Gera specs técnicas, rastreia tasks, sincroniza com código" \
    "Uso: openspec init, openspec update, openspec archive" \
    "Requisito: Node >= 20.19.0 (instalação global via npm pertence à versão ativa do Node)" \
    "Ao trocar de versão com nvm use, reinstale: npm i -g @fission-ai/openspec@latest"
  if ! node -e 'const [maj, min] = process.versions.node.split(".").map(Number); process.exit(maj > 20 || (maj === 20 && min >= 19) ? 0 : 1)'; then
    log_error "OpenSpec exige Node >= 20.19.0 (versão ativa: $(node --version))"
    return 1
  fi
  npm install -g @fission-ai/openspec@latest
  command -v openspec >/dev/null || { log_error "openspec não encontrado no PATH após a instalação"; return 1; }
  log_success "OpenSpec instalado: $(openspec --version)"
}

_run_npm_globals_total=$(catalog_module_total NPM_GLOBALS)

run_npm_globals() {
  catalog_run_module NPM_GLOBALS
}
