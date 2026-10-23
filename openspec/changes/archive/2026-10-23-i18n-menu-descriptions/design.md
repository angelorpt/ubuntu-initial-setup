# Design

## Context

`lib/catalog.sh` contains the centralized definitions of modules and installable items in format `function|Name|Description`. Currently, all descriptions and Whiptail menu prompts are in Portuguese. Global developers expect English as the standard default, with Portuguese available on demand.

## Goals / Non-Goals

**Goals:**
- Provide an initial Whiptail prompt to pick UI language: **English (Default)** or **Português (Brasil)**.
- Support CLI override flag `--lang=en` or `--lang=pt`.
- Support descriptions in both English and Portuguese without breaking existing test harnesses or parsing contracts.
- Ensure all category descriptions, program short summaries, and UI action prompts switch smoothly based on selected language.

**Non-Goals:**
- Full runtime localization of third-party command output (e.g. `apt`, `git`, external install scripts).
- Translating comments inside `.sh` script files.

## Decisions

### 1. Catalog Format Compatibility
- **Decision:** Store items as `function|Name|Description_EN|Description_PT` in `lib/catalog.sh`, and provide a resolver helper `catalog_item_desc "$module" "$func" [lang]` that defaults to English.
- If a 4th field is absent, fallback gracefully to the 3rd field.
- **Rationale:** Preserves backward compatibility where callers split by `|`. Callers requesting descriptions use the helper or parse based on `APP_LANG`.

### 2. UI String Dictionary
- Implement a small associative array or helper function `t <key>` (translate) in `lib/catalog.sh` or a dedicated `lib/i18n.sh`:
  - `select_env`: "Select Target Environment" / "Escolha o ambiente de instalação"
  - `select_mode`: "Choose Installation Mode" / "Escolha o modo de instalação"
  - `select_cats`: "Select Categories (Space to mark/unmark)" / "Selecione as categorias (espaço marca/desmarca)"
  - `cat_action`: "How would you like to select items in this category?" / "Como deseja selecionar os itens desta categoria?"
  - `all`: "Mark all items" / "Marcar todos os itens"
  - `custom`: "Pick items individually" / "Escolher programas item a item"
  - `skip`: "Skip category" / "Desconsiderar categoria"

## Risks / Trade-offs

- **[Risk] Adding a 4th field to `_ITEMS_*` could affect custom parser loops** → **Mitigation:** Update `catalog_items` or normalize fields so existing 3-column readers (`IFS='|' read -r func name desc`) continue working without error.
