_PROGRESS_TOTAL=0
_PROGRESS_CURRENT=0
_MODULE_TOTAL=0
_MODULE_CURRENT=0
_MODULE_NAME=""

init_progress() {
  _PROGRESS_TOTAL=$1
  _PROGRESS_CURRENT=0
  echo -ne "\n\n\n"
}

init_module_progress() {
  _MODULE_TOTAL=$1
  _MODULE_NAME=$2
  _MODULE_CURRENT=0
  _draw_progress "Preparando..."
}

end_module_progress() {
  _draw_progress "✓ Concluído"
  sleep 0.2
}

end_progress() {
  echo
}

update_progress() {
  : $(( _PROGRESS_CURRENT += 1 ))
  : $(( _MODULE_CURRENT += 1 ))
  _draw_progress "$1"
}

_draw_progress() {
  local app_name="$1"
  local global_pct=0 module_pct=0

  [ "$_PROGRESS_TOTAL" -gt 0 ] && global_pct=$(( _PROGRESS_CURRENT * 100 / _PROGRESS_TOTAL ))
  [ "$_MODULE_TOTAL" -gt 0 ] && module_pct=$(( _MODULE_CURRENT * 100 / _MODULE_TOTAL ))

  echo -ne "\033[3A\033[J"

  _bar "$module_pct" "$_MODULE_NAME" "$_MODULE_CURRENT" "$_MODULE_TOTAL" "$GREEN"
  echo
  echo -e "  ${CYAN}→${NC} ${BOLD}${app_name}${NC}"
  _bar "$global_pct" "Total" "$_PROGRESS_CURRENT" "$_PROGRESS_TOTAL" "$BLUE"
  echo
}

_bar() {
  local pct=$1 label=$2 current=$3 total=$4 color=$5
  local width=36
  local fill=$(( pct * width / 100 ))
  [ "$fill" -gt "$width" ] && fill=$width

  printf "  ${BOLD}%-13s${NC} " "$label"
  printf "$color"
  for ((i=0; i<fill; i++)); do printf '█'; done
  printf "${NC}${YELLOW}"
  for ((i=fill; i<width; i++)); do printf '░'; done
  printf "${NC} "
  printf "${BOLD}%3d%%${NC} (${BOLD}%d${NC}/${BOLD}%d${NC})" "$pct" "$current" "$total"
}
