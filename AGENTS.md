# AGENTS.md — ubuntu-initial-setup

Shell scripts to automate Ubuntu setup. Modular, interactive menu (whiptail) or headless (`--all`).

## Entrypoints

- `./install.sh` — interactive menu (no args), `--all`, `--retry`, `--continue`, `--update`
- `bootstrap.sh` — curl-pipe-bash entry: clones repo, runs `install.sh --all` if piped

## Commands

```bash
./install.sh              # whiptail menu
./install.sh --all        # headless full install
./install.sh --retry      # retry only previously failed items
./install.sh --continue   # skip already successful items
bash tests/run.sh         # ShellCheck + BATS
bash tests/lint.sh        # ShellCheck only
bats tests/lib/            # BATS only
```

## Architecture

- `install.sh` uses `set -uo pipefail` (intentionally no `set -e` — a module failure should not abort others)
- Each module in `install/*.sh` defines install functions (`install_*`), a total var (`_run_MODULE_total=N`), and a `run_MODULE()` function
- `track "CATEGORY" install_func "Display Name"` handles skip logic, progress bars, and result logging
- Results go to `results/{success,failure,report}.txt` (gitignored)
- `lib/{colors,log,utils,progress,results}.sh` — source dependencies

## Adding a program

1. Create `install_myapp()` in the right `install/*.sh`: `# <url>` → `print_header` → `print_details` → commands → `log_success`
2. Bump `_run_MODULE_total`
3. Add `track "MODULE" install_myapp "MyApp"` inside `run_MODULE()`

## Adding a new module

1. Create `install/new_module.sh` with `_run_*_total` + `run_*()`
2. In `install.sh`: add to `MODULES` array, 3 `case` blocks (source, total, execution), and `CHOICES` strings for `--all`/`--update`

## Helpers (lib/utils.sh)

- `ensure_snap`, `ensure_flatpak`, `install_deb`, `download_to_temp`

## Style conventions

- Every `install_*` function starts with a `# <url>` comment line
- Use `print_header "Name" "Description"` then `print_details "url" "bullet1" "bullet2" "usage"` before install commands
- End with `log_success "Name installed"`
