source "$(dirname "$0")/colors.sh"

log_info()    { echo -e "${BLUE}  →${NC} $1"; }
log_success() { echo -e "${GREEN}  ✓${NC} $1"; }
log_warn()    { echo -e "${YELLOW}  ⚠${NC} $1"; }
log_error()   { echo -e "${RED}  ✗${NC} $1"; }

print_header() {
  local name="$1"
  local desc="$2"
  echo
  echo -e "${BOLD}${CYAN}── ${name}${NC}"
  echo -e "${BLUE}  ${desc}${NC}"
  echo
}

print_progress() {
  echo -ne "  ${YELLOW}...${NC} $1\r"
}
