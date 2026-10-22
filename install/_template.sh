#!/bin/bash
# ============================================================
# _template.sh — GUIA PRÁTICO PARA CRIAR NOVAS INSTALAÇÕES
# ============================================================
# Este arquivo NÃO é um módulo e não é carregado pelo install.sh.
# Use como referência para adicionar programas ou criar módulos.
#
# O catálogo (lib/catalog.sh) é a fonte de verdade: menu de
# categorias, checklist de itens, total de progresso e ordem de
# execução são todos derivados dele.
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
# ─── Passo 2: Registre o item no catálogo ───
# Em lib/catalog.sh, adicione uma linha no array _ITEMS_AI:
#   "install_meu_app|MeuApp|Descrição curta"
# A posição no array define a ordem de instalação.
#
# Não é preciso mexer em run_ai() nem em _run_ai_total.
# ============================================================


# ============================================================
# PARTE B — CRIAR UM MÓDULO NOVO (ex: "JOGOS")
# ============================================================
# Envolve lib/catalog.sh + install/jogos.sh + 2 casos no install.sh
#
# ─── B.1: Declare o módulo e os itens no catálogo ───

# lib/catalog.sh:
#   MODULES=(... JOGOS)                        ← adicione na ordem canônica
#
#   _ITEMS_JOGOS=(
#     "install_steam|Steam|Plataforma de jogos digitais"
#     "install_lutris|Lutris|Gerenciador de jogos para Linux"
#   )
#
#   MODULE_LABELS[JOGOS]="Jogos"
#   MODULE_DESCRIPTIONS[JOGOS]="Jogos (Steam, Lutris)"
#
# ─── B.2: Crie install/jogos.sh com as funções + run_*() ───

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

_run_jogos_total=$(catalog_module_total JOGOS)   # total derivado do catálogo

run_jogos() {
  catalog_run_module JOGOS
}
#
# ─── B.3: Adicione os casos no install.sh ───
# No laço de source:
#   JOGOS)           source install/jogos.sh           ;;
# No laço de execução:
#   JOGOS)           run_jogos           ;;
#
# O menu de categorias, o checklist de itens e o total do
# progresso passam a incluir o módulo automaticamente.
# ============================================================


# ============================================================
# CHECKLIST RÁPIDO
# ============================================================
# Para adicionar 1 programa a módulo existente:
#   [ ] Criar função install_*()
#   [ ] Adicionar item em _ITEMS_MODULO (lib/catalog.sh)
#
# Para criar módulo novo:
#   [ ] Adicionar módulo em MODULES + _ITEMS_* + labels/descrições (lib/catalog.sh)
#   [ ] Criar install/novo_modulo.sh com funções + _run_*_total + run_*()
#   [ ] Adicionar case no laço de source do install.sh
#   [ ] Adicionar case no laço de execução do install.sh

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
# Catálogo (lib/catalog.sh):
# catalog_run_module MODULO            → executa os itens selecionados do módulo
# catalog_module_total MODULO          → nº total de itens do módulo
# catalog_selected_total [MODULO...]   → nº de itens selecionados
#
# Utilitários (lib/utils.sh):
# ensure_snap                          → instala snap se ausente
# ensure_flatpak                       → instala flatpak se ausente
# die_on_error "msg"                   → aborta se último comando falhou
# download_to_temp "url"              → baixa para /tmp
# install_deb "url"                   → baixa e instala .deb
