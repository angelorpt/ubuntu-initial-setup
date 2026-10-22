setup() {
  load "../helpers"
  source_lib "selection.sh"
  source_lib "catalog.sh"
  source_lib "log.sh"
  source_lib "results.sh"

  TEST_DIR=$(mktemp -d)
  update_progress() { :; }
  SELECTION_ENABLED=true
  select_clear
  init_results "$TEST_DIR"
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "select_add and select_has" {
  [ "$(select_count)" -eq 0 ]
  select_add "BASE:install_git"
  select_has "BASE:install_git"
  [ "$(select_count)" -eq 1 ]
}

@test "select_clear removes all tags" {
  select_add "BASE:install_git"
  select_add "DEV:install_python"
  [ "$(select_count)" -eq 2 ]
  select_clear
  [ "$(select_count)" -eq 0 ]
  ! select_has "BASE:install_git"
}

@test "select_summary reports count" {
  select_add "BASE:install_git"
  select_add "BASE:install_curl"
  run select_summary
  [ "$output" = "2 item(ns) selecionado(s)" ]
}

@test "track skips unselected items without recording" {
  dummy_fail() { return 1; }

  run track "BASE" dummy_fail "Ignorado"

  [ "$status" -eq 0 ]
  [ ! -s "$TEST_DIR/failure.txt" ]
  [ ! -s "$TEST_DIR/success.txt" ]
}

@test "track runs and records selected items" {
  dummy_fail() { return 1; }
  select_add "BASE:dummy_fail"

  run track "BASE" dummy_fail "Selecionado"

  [ "$status" -eq 1 ]
  grep -q "BASE: Selecionado" "$TEST_DIR/failure.txt"
}
