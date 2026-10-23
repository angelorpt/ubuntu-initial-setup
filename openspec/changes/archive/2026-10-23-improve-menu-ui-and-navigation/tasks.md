# Tasks

## 1. Responsive Dialog Width

- [x] 1.1 Implement `_dialog_width()` in `install.sh` and apply it to category, item, and confirmation menus
- [x] 1.2 Verify visually or via dry-run that dialog boxes don't overflow on various terminal sizes

## 2. Item Checklist Navigation & "Select All" Option

- [x] 2.1 Add `__ALL__` pseudo-option at the top of `_select_items` checklist
- [x] 2.2 In `_select_via_menu`, handle `__ALL__` selection by selecting all eligible items in the category
- [x] 2.3 Make `<Cancel>` in `_select_items` return back to the category batch menu (`all / custom / skip`) instead of aborting the installer

## 3. Verification & Documentation

- [x] 3.1 Run `bash tests/run.sh` to ensure ShellCheck clean and all BATS tests pass
- [x] 3.2 Update `AGENTS.md` and `README.md` if UX flows are altered
