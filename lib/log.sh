source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

log_info()    { echo -e "${BLUE}  →${NC} $1"; }
log_success() { echo -e "${GREEN}  ✓${NC} $1"; }
log_warn()    { echo -e "${YELLOW}  ⚠${NC} $1"; }
log_error()   { echo -e "${RED}  ✗${NC} $1"; }

print_header() {
  local name="$1"
  local desc="$2"
  echo
  echo
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${CYAN}  ${name}${NC} — ${BLUE}${desc}${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo
}

print_details() {
  local url="$1"
  shift
  local detail
  for detail in "$@"; do
    echo -e "  ${BLUE}•${NC} $detail"
  done
  [ -n "$url" ] && echo -e "  ${BLUE}Site:${NC} $url"
  echo -e "  ${BLUE}╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌${NC}"
}

print_progress() {
  echo -ne "  ${YELLOW}...${NC} $1\r"
}
