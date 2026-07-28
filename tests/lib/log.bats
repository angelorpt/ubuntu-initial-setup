setup() {
  load "../helpers"
  source_lib "log.sh"
}

@test "log_info output" {
  run log_info "teste"
  [ "$status" -eq 0 ]
  [[ "$output" == *"teste"* ]]
}

@test "log_success output" {
  run log_success "ok"
  [ "$status" -eq 0 ]
  [[ "$output" == *"ok"* ]]
}

@test "log_warn output" {
  run log_warn "aviso"
  [ "$status" -eq 0 ]
  [[ "$output" == *"aviso"* ]]
}

@test "log_error output" {
  run log_error "erro"
  [ "$status" -eq 0 ]
  [[ "$output" == *"erro"* ]]
}

@test "print_header output" {
  run print_header "App" "Descrição"
  [ "$status" -eq 0 ]
  [[ "$output" == *"App"* ]]
  [[ "$output" == *"Descrição"* ]]
}

@test "print_details with url and bullets" {
  run print_details "https://site.com" "Detalhe 1" "Detalhe 2"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Detalhe 1"* ]]
  [[ "$output" == *"Detalhe 2"* ]]
  [[ "$output" == *"https://site.com"* ]]
}

@test "print_details empty url" {
  run print_details "" "Apenas detalhe"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Apenas detalhe"* ]]
  [[ "$output" != *"Site:"* ]]
}
