#!/bin/bash
# ============================================================
# _template.sh — GUIA PRÁTICO PARA CRIAR NOVAS INSTALAÇÕES
# ============================================================
# Este arquivo NÃO é um módulo e não é carregado pelo install.sh.
# Use como referência para adicionar programas ou criar módulos.
# ============================================================

# ============================================================
# PARTE A — ADICIONAR UM PROGRAMA A UM MÓDULO EXISTENTE
# ============================================================
# Exemplo: adicionar "MeuApp" ao módulo AI (install/ai.sh)
#
# ─── Passo 1: Crie a função de instalação ───

install_meu_app() {
  # https://meuapp.com                          ← URL oficial (obrigatório)
  print_header "MeuApp" "Descrição curta"       ← nome + descrição
  print_details "https://meuapp.com" \           ← site oficial
    "Feature principal — descrição" \            ← bullet 1
    "Outra feature legal — descrição" \          ← bullet 2
    "Uso: meuapp --help"                         ← como usar
  # Comandos de instalação (exemplos):
  # curl -fsSL https://meuapp.com/install.sh | bash
  # sudo apt install -y meuapp
  # ensure_snap && sudo snap install meuapp --classic
  log_success "MeuApp instalado"                 ← confirmação visual
}
#
# ─── Passo 2: Incremente o total ───
# Subtraia 1 e some de volta (evita conflito de merge):
#   _run_ai_total=6  →  _run_ai_total=7
#
# ─── Passo 3: Adicione o track na run_ai() ───
#   track "AI" install_meu_app "MeuApp"
# A ordem dos tracks determina a ordem de instalação.
# ============================================================


# ============================================================
# PARTE B — CRIAR UM MÓDULO NOVO (ex: "JOGOS")
# ============================================================
# Envolve 4 arquivos: install/jogos.sh + 3 alterações no install.sh
#
# ─── B.1: Crie install/jogos.sh ───

install_steam() {
  # https://store.steampowered.com
  print_header "Steam" "Plataforma de jogos digitais"
  print_details "https://store.steampowered.com" \
    "Milhares de jogos com suporte nativo ou via Proton" \
    "Comunidade, achievements, cloud save e multiplayer" \
    "Uso: steam"
  ensure_snap
  sudo snap install steam --classic
  log_success "Steam instalado"
}

install_lutris() {
  # https://lutris.net
  print_header "Lutris" "Gerenciador de jogos para Linux"
  print_details "https://lutris.net" \
    "Gerencia jogos nativos, Wine, Proton e emuladores" \
    "Instalação com um clique a partir da biblioteca online" \
    "Uso: lutris"
  sudo add-apt-repository -y ppa:lutris-team/lutris
  sudo apt update && sudo apt install -y lutris
  log_success "Lutris instalado"
}

_run_jogos_total=2                              ← total de funções no módulo

run_jogos() {
  init_module_progress $_run_jogos_total "Jogos"
  track "JOGOS" install_steam "Steam"
  track "JOGOS" install_lutris "Lutris"
  end_module_progress
}
#
# ─── B.2: Adicione a entrada no whiptail (install.sh) ───
# Localize o array MODULES dentro do bloco `if [ "$MODE" != "retry" ]`
# e adicione uma linha:
#   "JOGOS" "Jogos (Steam, Lutris)" ON
#
# ─── B.3: Adicione nos 3 loops de case (install.sh) ───
# Você precisa adicionar em 3 lugares diferentes (todos no install.sh):
#
# 1º loop (source):
#   JOGOS)           source install/jogos.sh           ;;
#
# 2º loop (total):
#   JOGOS)           TOTAL=$((TOTAL + _run_jogos_total))           ;;
#
# 3º loop (execução):
#   JOGOS)           run_jogos           ;;
#
# ─── B.4: Adicione nas strings CHOICES (se quiser --all/--update) ───
# Nas linhas CHOICES="BASE DEV AI ..." dos blocos --all e --update,
# adicione "JOGOS" à lista:
#   CHOICES="BASE DEV AI JOGOS TOOLS_TERMINAL TOOLS_DESKTOP ..."
# ============================================================


# ============================================================
# CHECKLIST RÁPIDO
# ============================================================
# Para adicionar 1 programa a módulo existente:
#   [ ] Criar função install_*()
#   [ ] Incrementar _run_MODULO_total
#   [ ] Adicionar track na run_*()
#
# Para criar módulo novo:
#   [ ] Criar install/novo_modulo.sh com _run_*_total + run_*()
#   [ ] Adicionar entrada no array MODULES (whiptail)
#   [ ] Adicionar case no 1º loop (source) do install.sh
#   [ ] Adicionar case no 2º loop (total) do install.sh
#   [ ] Adicionar case no 3º loop (execução) do install.sh
#   [ ] Adicionar nas strings CHOICES (--all / --update)

# ============================================================
# FUNÇÕES DISPONÍVEIS (definidas em lib/)
# ============================================================
# print_header "Nome" "Descrição"     → cabeçalho estilizado
# print_details "url" "linha1" ...    → detalhes em bullets
# log_info      "mensagem"            → log informativo (azul)
# log_success   "mensagem"            → log de sucesso (verde)
# log_warn      "mensagem"            → log de aviso (amarelo)
# log_error     "mensagem"            → log de erro (vermelho)
#
# Utilitários (lib/utils.sh):
# ensure_snap                          → instala snap se ausente
# ensure_flatpak                       → instala flatpak se ausente
# die_on_error "msg"                   → aborta se último comando falhou
# download_to_temp "url"              → baixa para /tmp
# install_deb "url"                   → baixa e instala .deb
