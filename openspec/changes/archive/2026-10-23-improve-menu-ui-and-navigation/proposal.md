# Proposal

## Why

In `install.sh`, long descriptions in Whiptail checklists currently get truncated or overflow outside the window boundaries due to static, narrow dialog dimensions (`width=78`). Furthermore, during category item selection, if a user opens the granular checklist (`custom`) and decides they want to install all items in that category after seeing them, there is currently no way to select all without either checking every item manually or having to exit and re-run. Providing dynamic/wider responsive menu widths and flexible navigation (a "Select All" toggle inside the item checklist or a "Back" button) significantly improves TUI usability and UX.

## What Changes

- Dynamically calculate or expand dialog width in `install.sh` (e.g. `width=88` to `96`, or auto-sized up to terminal columns) to prevent description clipping and overflow.
- In `_select_items`, introduce a top action item or Cancel-to-back navigation flow allowing the user to either:
  1. Select all items directly within the item checklist (`__ALL__` pseudo-option or return to batch menu).
  2. Press "Back" / "Cancel" on the checklist to return cleanly to the category batch action menu instead of aborting the whole installer.

## Capabilities

### Modified Capabilities
- `menu-selection-flow`: Checklist dialog sizing expands to prevent text clipping, and item selection supports returning to category batch options or selecting all items.

## Impact

- `install.sh`: Dialog dimensions updated across Whiptail calls, and `_select_via_menu` / `_select_items` navigation loop refined.
