install_9router() {
  # https://github.com/decolua/9router
  print_header "9Router" "Roteador CLI — https://github.com/decolua/9router"
  log_info "↪ https://github.com/decolua/9router"
  npm install -g 9router
  log_success "9Router instalado"
}

install_nestjs() {
  # https://docs.nestjs.com/first-steps
  print_header "Nest.js" "Framework Node.js progressivo — https://nestjs.com"
  log_info "↪ https://docs.nestjs.com/first-steps"
  npm i -g @nestjs/cli
  log_success "Nest.js CLI instalado"
}

install_vuejs() {
  # https://cli.vuejs.org/guide/installation.html
  print_header "Vue.js" "Framework JS progressivo — https://vuejs.org"
  log_info "↪ https://cli.vuejs.org/guide/installation.html"
  npm install -g @vue/cli
  log_success "Vue.js CLI instalado"
}

install_openspec() {
  # https://github.com/Fission-AI/OpenSpec
  print_header "OpenSpec" "Gerenciador de mudanças para projetos de IA — https://github.com/Fission-AI/OpenSpec"
  log_info "↪ https://github.com/Fission-AI/OpenSpec"
  npm install -g @fission-ai/openspec@latest
  log_success "OpenSpec instalado"
}

run_npm_globals() {
  track "NPM_GLOBALS" install_9router "9Router"
  track "NPM_GLOBALS" install_nestjs "Nest.js"
  track "NPM_GLOBALS" install_vuejs "Vue.js"
  track "NPM_GLOBALS" install_openspec "OpenSpec"
}
