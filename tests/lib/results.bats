setup() {
  load "../helpers"
  source_lib "results.sh"
  source_lib "log.sh"

  TEST_DIR=$(mktemp -d)
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "init_results creates results dir" {
  init_results "$TEST_DIR"
  [ -d "$TEST_DIR" ]
  [ -f "$TEST_DIR/success.txt" ]
  [ -f "$TEST_DIR/failure.txt" ]
}

@test "track records success" {
  init_results "$TEST_DIR"

  dummy() { return 0; }
  run track "TEST" dummy "Dummy"
  [ "$status" -eq 0 ]
  grep -q "TEST: Dummy" "$TEST_DIR/success.txt"
}

@test "track records failure" {
  init_results "$TEST_DIR"

  dummy() { return 1; }
  run track "TEST" dummy "Falha"
  [ "$status" -eq 1 ]
  grep -q "TEST: Falha" "$TEST_DIR/failure.txt"
}
