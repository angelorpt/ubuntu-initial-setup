# Design

## Context

`install.sh` uses whiptail menus to coordinate category and program selection driven by `lib/catalog.sh`. Currently, categories and items default to `"ON"`, and all modules run uniformly regardless of whether the system is a full desktop or a headless terminal/WSL instance. See `proposal.md` for problem background.

## Goals / Non-Goals

**Goals:**
- Provide a clear, non-intrusive environment prompt (`Desktop` vs. `Headless / WSL`) early in the interactive flow.
- Filter catalog items dynamically based on the active profile so visual-only apps are completely hidden in headless environments.
- Default checklists to unchecked (`OFF`) to give users deliberate control.
- Offer category batch choices (`Select all`, `Pick individual items`, `Skip`) before opening detailed checklists.
- Support CLI flags for the environment profile (e.g. `--profile=headless|desktop` or `--headless`).

**Non-Goals:**
- Creating a separate entrypoint script: `install.sh` remains the single orchestrator.
- Supporting Windows-native (.exe) software installations: only Linux packages running inside Ubuntu/WSL are managed.

## Decisions

### 1. Environment Metadata in Catalog vs. Helper Predicates
- **Decision:** Implement a helper function `catalog_item_is_gui "$module" "$func"` and `catalog_module_is_gui "$module"` in `lib/catalog.sh`.
- **Rationale:** Keeps the format of `_ITEMS_<MODULE>` clean and backwards-compatible with existing BATS tests, while centralizing GUI classification in the catalog.
- **Alternatives considered:**
  - Adding a 4th pipe-separated field in `_ITEMS_*`: Breaks existing tests and scripts reading `IFS='|' read -r func name desc`.
  - Hardcoding GUI exclusions in `install.sh`: Violates single source of truth in `catalog.sh`.

### 2. WSL Environment Detection
- **Decision:** Check for WSL indicators (`/proc/sys/fs/binfmt_misc/WSLInterop` or `grep -qi microsoft /proc/version`) to determine the default suggested profile, but always show the selection menu.
- **Rationale:** Respects user agency: a user running WSL with WSLg may still want GUI apps if they choose `Desktop`, while a cloud server user can choose `Headless`.

### 3. Whiptail UX for Category Batch Actions
- **Decision:** When a category is selected, prompt via a simple radiolist/menu:
  - `all` — Mark all eligible items in category
  - `custom` — Open checklist (starting with items `OFF`)
  - `skip` — Deselect category
- **Rationale:** Whiptail cannot add custom toggle buttons inside a single checklist screen. A 2-step prompt is standard, intuitive, and visually uncluttered.

## Risks / Trade-offs

- **[Risk] User wants to install a desktop tool inside WSLg** → **Mitigation:** The environment menu allows choosing `Desktop` even when running on WSL.
- **[Risk] Extra prompt steps increase interaction time** → **Mitigation:** Batch selection (`Select All`) makes category selection faster than manually unchecking dozens of default-ON items.
