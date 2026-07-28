setup() {
  load "../helpers"
  source_lib "progress.sh"
}

@test "init_progress sets total" {
  init_progress 10
  [ "$_PROGRESS_TOTAL" -eq 10 ]
  [ "$_PROGRESS_CURRENT" -eq 0 ]
}

@test "init_module_progress sets module vars" {
  init_module_progress 5 "Test"
  [ "$_MODULE_TOTAL" -eq 5 ]
  [ "$_MODULE_NAME" = "Test" ]
  [ "$_MODULE_CURRENT" -eq 0 ]
}

@test "update_progress increments counters" {
  init_progress 10
  init_module_progress 5 "Test"
  _PROGRESS_CURRENT=0
  _MODULE_CURRENT=0
  update_progress "app"
  [ "$_PROGRESS_CURRENT" -eq 1 ]
  [ "$_MODULE_CURRENT" -eq 1 ]
}
