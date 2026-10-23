# Proposal

## Why

Currently, program descriptions and categories in the interactive Whiptail menu are hardcoded in Portuguese, while the primary project documentation and global developers expect English by default. Introducing an internationalization (i18n) layer with an interactive language selector (English default, Portuguese optional) and CLI flag allows users to read program details and category prompts in their preferred language.

## What Changes

- Add a language selection step to `install.sh` (`en` default, `pt-BR` optional) and a CLI flag `--lang=en|pt`.
- Support bilingual descriptions for categories and programs in `lib/catalog.sh` (`APP_DESC_EN` and `APP_DESC_PT`).
- Update `catalog_module_desc` and `catalog_items` (or descriptive getters) to return descriptions in the active language.
- Update Whiptail UI titles, checklist instructions, and batch menus to reflect the selected language.

## Capabilities

### New Capabilities
- `i18n-catalog-descriptions`: Multi-language catalog metadata and descriptive resolution for modules and installable items.

### Modified Capabilities
- `menu-selection-flow`: Menu prompts, instructions, and checklist descriptions adapt to the user's chosen language (English default, Portuguese selectable).

## Impact

- `lib/catalog.sh`: Storage and getter resolution for bilingual item descriptions and module labels/descriptions.
- `install.sh`: Language prompt on initial execution, `--lang` CLI flag, and localized UI strings.
- Tests in `tests/lib/`: Tests covering catalog description retrieval in `en` and `pt`.
