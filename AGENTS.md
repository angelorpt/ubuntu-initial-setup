# AGENTS.md — ubuntu-initial-setup

Shell scripts to automate Ubuntu setup. Modular, interactive menu (whiptail) or headless (`--all --yes`).

## Entrypoints

- `install.sh` — main entry. Must be run from repo root (uses `cd "$(dirname "$0")"` internally)
- `bootstrap.sh` — curl-pipe-bash entry: installs prerequisites, clones repo, and launches interactive `install.sh` menu via `/dev/tty` (supports passing flags like `--all --yes`)

## Commands

```bash
./install.sh                  # whiptail menu (mode → categories → items → confirm)
./install.sh --all            # select everything, show summary, ask confirmation (fresh)
./install.sh --all --yes      # headless full install (fresh)
./install.sh --update         # reinstall everything (fresh, asks confirmation)
./install.sh --retry          # preselect only previously failed items
./install.sh --continue       # skip already successful items
bash tests/run.sh             # ShellCheck + BATS
bash tests/lint.sh            # ShellCheck only
bats tests/lib/               # BATS only
```

## Architecture

- `install.sh`: `set -uo pipefail` (no `set -e` — module failure should not abort others)
- `bootstrap.sh`: `set -euo pipefail` (has `-e`)
- `lib/catalog.sh` is the single source of truth: `MODULES` (order) plus `_ITEMS_<MODULE>` arrays of `function|Display Name|short description`
- Each module in `install/*.sh` defines only the install functions, `_run_*_total=$(catalog_module_total MODULE)`, and `run_*() { catalog_run_module MODULE; }`
- `catalog_run_module` walks the catalog in order, sets module progress and calls `track` only for selected items
- `lib/selection.sh` holds `SELECTION_ENABLED`, `select_add/clear/has/count/summary` (tags are `MODULE:function`)
- `track "CATEGORY" install_func "Display Name"` filters by selection, then handles skip/retry/continue logic, progress bars, and result logging
- `install.sh` computes the total with `catalog_selected_total`, initializes results only after confirmation, and skips empty modules
- `results/{success,failure,report}.txt` are auto-generated per run (gitignored)
- `install/_template.sh` has full reference for adding programs and modules (not loaded at runtime)

## Adding a program

1. `install_myapp()` in the right `install/*.sh`: `# <url>` → `print_header` → `print_details` (variadic bullets) → commands → `log_success`
2. Add `"install_myapp|MyApp|Short description"` to `_ITEMS_<MODULE>` in `lib/catalog.sh` (position defines install order)
3. Nothing else: menu entry, total and `track` call are derived from the catalog

## Adding a new module

1. Add the module name to `MODULES` and an `_ITEMS_<MODULE>` array in `lib/catalog.sh`, plus `MODULE_LABELS`/`MODULE_DESCRIPTIONS` entries
2. Create `install/new_module.sh` with the install functions and `_run_*_total=$(catalog_module_total NEW_MODULE)` + `run_new_module() { catalog_run_module NEW_MODULE; }`
3. In `install.sh`: add the source and `run_*` cases to the two loops

## Helpers (lib/utils.sh)

- `ensure_snap`, `ensure_flatpak`, `install_deb`, `download_to_temp`, `die_on_error`, `ensure_whiptail`

## Style conventions

- Every `install_*` function starts with `# <url>` comment
- `print_header "Name" "Desc"` before install commands, then `print_details "url" "bullet1" "bullet2" ...`
- End with `log_success "Name installed"`
