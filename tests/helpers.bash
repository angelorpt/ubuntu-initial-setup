source_lib() {
  local lib="$1"
  local root
  root="$(cd "$(dirname "$BATS_TEST_DIRNAME")/.." && pwd)"
  if [ -f "$root/lib/$lib" ]; then
    source "$root/lib/$lib"
  else
    skip "lib/$lib não encontrado"
  fi
}
