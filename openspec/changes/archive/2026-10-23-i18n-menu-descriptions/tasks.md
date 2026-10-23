# Tasks

## 1. Catalog i18n Metadata & Resolvers

- [x] 1.1 Add English and Portuguese descriptions to all catalog items and module descriptions in `lib/catalog.sh`
- [x] 1.2 Implement `catalog_item_desc "$module" "$func"` and update `catalog_module_desc "$module"` to resolve based on `APP_LANG` (defaulting to `en`)
- [x] 1.3 Add BATS unit tests in `tests/lib/catalog.bats` validating `en` and `pt` description resolution

## 2. Interactive Language Prompt & UI Localization

- [x] 2.1 Implement language selection prompt (English vs. Português) in `install.sh` and support `--lang=en|pt` CLI flags
- [x] 2.2 Localize Whiptail menu titles, buttons, prompts, and category batch menus in `install.sh` based on `APP_LANG`

## 3. Verification & Documentation

- [x] 3.1 Run `bash tests/run.sh` to ensure ShellCheck clean and all BATS tests pass
- [x] 3.2 Update `README.md`, `README.pt-BR.md`, and `AGENTS.md` documenting language support and flags
