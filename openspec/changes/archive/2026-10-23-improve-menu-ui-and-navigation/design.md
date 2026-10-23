# Design

## Context

`install.sh` uses hardcoded dimensions (typically `height=count+8`, `width=78`) across checklist calls. Modern terminal windows typically have 100+ columns, and program descriptions (name + site/features) easily exceed 70 characters, causing unsightly wrap or overflow in Whiptail. Also, selecting `custom` in a category enters a one-way street: pressing `<Cancel>` aborts the whole script.

## Goals / Non-Goals

**Goals:**
- Compute responsive width dynamically: `columns=$(tput cols 2>/dev/null || echo 80)` clamped between `88` and `110` (or `columns - 4` if smaller), ensuring descriptions fit cleanly without overflow.
- In `_select_via_menu`, treat cancelling or selecting `<Back>` from `_select_items` as a return to the category action menu (`all / custom / skip`), avoiding script termination.
- Add an `__ALL__` action item at the top of the item checklist: `[ ] (ALL) — Select all items in this category` / `(TODOS) — Selecionar todos os itens desta categoria`. If checked, all items in that category are selected immediately.

**Non-Goals:**
- Completely rewriting Whiptail in another framework (Whiptail is lightweight and guaranteed across Ubuntu).

## Decisions

1. **Top pseudo-item `__ALL__`**:
   Inside the checklist:
   `"__ALL__" "[★ SELECT ALL / MARCAR TODOS]" "OFF"`
   If the user selects `__ALL__`, `install.sh` expands this to all eligible items in that category.
2. **Non-fatal Cancel on item checklist**:
   If the user hits `<Cancel>` in the item checklist, instead of `return 1` (which aborts the installer), return code `2` (meaning "back"). The category action loop catches this and re-displays the `all / custom / skip` menu for that category.
3. **Responsive Width**:
   Define helper `_dialog_width()` returning `min(100, max(88, cols - 4))`.

## Risks / Trade-offs

- **[Risk] Terminal size is very small (e.g. 80x24)** → **Mitigation:** Fallback logic respects small terminals so dialogs don't exceed actual columns.
