setup() {
  load "../helpers"
  source_lib "selection.sh"
  source_lib "catalog.sh"
  ROOT="$(cd "$(dirname "$BATS_TEST_DIRNAME")/.." && pwd)"
  TEST_DIR=$(mktemp -d)
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "catalog has modules" {
  [ "${#MODULES[@]}" -gt 0 ]
}

@test "every module has items" {
  for module in "${MODULES[@]}"; do
    [ -n "$(catalog_items "$module")" ] || fail "módulo $module sem itens"
  done
}

@test "item tags are unique per module" {
  for module in "${MODULES[@]}"; do
    duplicates=$(catalog_items "$module" | cut -d'|' -f1 | sort | uniq -d)
    [ -z "$duplicates" ] || fail "tags duplicadas em $module: $duplicates"
  done
}

@test "catalog_module_total matches item count" {
  for module in "${MODULES[@]}"; do
    expected=$(catalog_items "$module" | wc -l)
    [ "$(catalog_module_total "$module")" -eq "$expected" ] || fail "total divergente em $module"
  done
}

@test "known module totals" {
  [ "$(catalog_module_total BASE)" -eq 4 ]
  [ "$(catalog_module_total DEV)" -eq 23 ]
  [ "$(catalog_module_total NPM_GLOBALS)" -eq 12 ]
}

@test "catalog_tag and catalog_item_name resolve items" {
  [ "$(catalog_tag BASE install_git)" = "BASE:install_git" ]
  [ "$(catalog_item_name BASE install_git)" = "Git" ]
}

@test "all catalog functions are defined by their modules" {
  for module in "${MODULES[@]}"; do
    case "$module" in
      NPM_GLOBALS) module_file="install/npm-globals.sh" ;;
      *) module_file="install/$(printf '%s' "$module" | tr '[:upper:]' '[:lower:]').sh" ;;
    esac
    source "$ROOT/$module_file"
    while IFS='|' read -r func _name _desc; do
      declare -F "$func" >/dev/null || fail "função $func ($module) não definida"
    done < <(catalog_items "$module")
  done
}

@test "catalog_run_module tracks items in catalog order" {
  init_module_progress() { :; }
  end_module_progress() { :; }
  track() { printf '%s\n' "$2" >> "$TEST_DIR/order"; }

  catalog_run_module BASE

  expected=$(catalog_items BASE | cut -d'|' -f1)
  [ "$(cat "$TEST_DIR/order")" = "$expected" ]
}

@test "catalog_selected_total respects selection" {
  [ "$(catalog_selected_total BASE)" -eq 4 ]

  SELECTION_ENABLED=true
  select_clear
  select_add "$(catalog_tag BASE install_git)"
  [ "$(catalog_selected_total BASE)" -eq 1 ]
}

@test "catalog_run_module skips unselected items" {
  SELECTION_ENABLED=true
  select_clear
  select_add "$(catalog_tag BASE install_git)"

  init_module_progress() { printf '%s\n' "$1" > "$TEST_DIR/total"; }
  end_module_progress() { :; }
  track() { printf '%s\n' "$2" >> "$TEST_DIR/order"; }

  catalog_run_module BASE

  [ "$(cat "$TEST_DIR/total")" -eq 1 ]
  [ "$(cat "$TEST_DIR/order")" = "install_git" ]
}

@test "catalog_module_is_gui identifies GUI modules" {
  run catalog_module_is_gui TOOLS_DESKTOP
  [ "$status" -eq 0 ]

  run catalog_module_is_gui MEDIA
  [ "$status" -eq 0 ]

  run catalog_module_is_gui FONTS
  [ "$status" -eq 0 ]

  run catalog_module_is_gui BASE
  [ "$status" -eq 1 ]

  run catalog_module_is_gui DEV
  [ "$status" -eq 1 ]
}

@test "catalog_item_is_gui identifies individual GUI items" {
  run catalog_item_is_gui DEV install_vscode
  [ "$status" -eq 0 ]

  run catalog_item_is_gui DEV install_postman
  [ "$status" -eq 0 ]

  run catalog_item_is_gui DEV install_virtualbox
  [ "$status" -eq 0 ]

  run catalog_item_is_gui DEV install_antigravity_ide
  [ "$status" -eq 0 ]

  run catalog_item_is_gui DEV install_docker
  [ "$status" -eq 1 ]

  run catalog_item_is_gui TOOLS_DESKTOP install_flameshot
  [ "$status" -eq 0 ]
}
