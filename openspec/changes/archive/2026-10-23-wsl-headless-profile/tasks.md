# Tasks

## 1. Catalog Environment Metadata & Filtering

- [x] 1.1 Implement GUI classifier helpers in `lib/catalog.sh` (`catalog_module_is_gui` and `catalog_item_is_gui`) and verify with a quick bash evaluation
- [x] 1.2 Add BATS unit tests in `tests/lib/catalog.bats` covering GUI filtering for modules and individual items

## 2. Environment Detection & CLI Support

- [x] 2.1 Implement WSL detection helper `is_wsl` and environment profile parsing (`--profile`, `--headless`) in `install.sh`
- [x] 2.2 Add interactive whiptail environment selector prompt to `install.sh` that preselects the detected environment

## 3. Interactive Menu Defaults & Category Batch Flow

- [x] 3.1 Update `install.sh` category checklist so items default to unselected (`OFF`)
- [x] 3.2 Implement category batch prompt (`all`, `custom`, `skip`) in `install.sh` so users can choose all items at once or customize individual items (defaulting to `OFF`)
- [x] 3.3 Ensure desktop modules and GUI items are filtered out when the headless profile is active

## 4. Verification & Documentation

- [x] 4.1 Run test suite (`bash tests/run.sh`) to confirm ShellCheck compliance and that all BATS unit tests pass
- [x] 4.2 Update `README.md` and `AGENTS.md` documenting the WSL/Headless profile option and new selection UX
