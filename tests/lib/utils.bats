setup() {
  load "../helpers"
  source_lib "utils.sh"
  source_lib "log.sh"
}

@test "die_on_error does not exit on success" {
  run bash -c '
    source lib/utils.sh
    true
    die_on_error "ok" 2
    echo "sobreviveu"
  '
  [ "$status" -eq 0 ]
  [[ "$output" == *"sobreviveu"* ]]
}

@test "ensure_whiptail detects existing whiptail" {
  if command -v whiptail &>/dev/null; then
    run ensure_whiptail
    [ "$status" -eq 0 ]
  else
    skip "whiptail não instalado"
  fi
}

@test "ensure_snap detects existing snap" {
  if command -v snap &>/dev/null; then
    run ensure_snap
    [ "$status" -eq 0 ]
  else
    skip "snap não instalado"
  fi
}

@test "ensure_flatpak detects existing flatpak" {
  if command -v flatpak &>/dev/null; then
    run ensure_flatpak
    [ "$status" -eq 0 ]
  else
    skip "flatpak não instalado"
  fi
}

