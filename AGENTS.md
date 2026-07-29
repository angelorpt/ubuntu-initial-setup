# AGENTS.md — ubuntu-initial-setup

Shell scripts to automate Ubuntu setup. Modular, interactive menu (whiptail) or headless (`--all`).

## Entrypoints

- `install.sh` — main entry. Must be run from repo root (uses `cd "$(dirname "$0")"` internally)
- `bootstrap.sh` — curl-pipe-bash entry: clones repo, runs `install.sh --all` if piped

## Commands

```bash
./install.sh                  # whiptail menu (new/continue/retry)
./install.sh --all            # headless full install (fresh)
./install.sh --update         # reinstall everything (fresh)
./install.sh --retry          # retry only previously failed items
./install.sh --continue       # skip already successful items
bash tests/run.sh             # ShellCheck + BATS
bash tests/lint.sh            # ShellCheck only
bats tests/lib/               # BATS only
```

## Architecture

- `install.sh`: `set -uo pipefail` (no `set -e` — module failure should not abort others)
- `bootstrap.sh`: `set -euo pipefail` (has `-e`)
- Each module in `install/*.sh` defines install functions, `_run_*_total=N`, and `run_*()`
- `track "CATEGORY" install_func "Display Name"` handles skip/retry/continue logic, progress bars, and result logging
- `init_module_progress $total "Name"` / `end_module_progress` wrap the `track` calls inside `run_*()`
- `results/{success,failure,report}.txt` are auto-generated per run (gitignored)
- `install/_template.sh` has full reference for adding programs and modules (not loaded at runtime)

## Adding a program

1. `install_myapp()` in right `install/*.sh`: `# <url>` → `print_header` → `print_details` (variadic bullets) → commands → `log_success`
2. Bump `_run_MODULE_total`
3. Add `track "MODULE" install_myapp "MyApp"` inside `run_*()` (order determines install order)

## Adding a new module

1. Create `install/new_module.sh` with `_run_*_total` + `run_*()`
2. In `install.sh`: add to `MODULES` array, 3 `case` blocks (source, total, execution), and `CHOICES` strings for `--all`/`--update`

## Helpers (lib/utils.sh)

- `ensure_snap`, `ensure_flatpak`, `install_deb`, `download_to_temp`, `die_on_error`, `ensure_whiptail`

## Style conventions

- Every `install_*` function starts with `# <url>` comment
- `print_header "Name" "Desc"` before install commands, then `print_details "url" "bullet1" "bullet2" ...`
- End with `log_success "Name installed"`
