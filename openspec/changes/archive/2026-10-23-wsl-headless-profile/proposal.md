# Proposal

## Why

Users who run Ubuntu in headless environments (such as Windows WSL or server/VPS instances) need an automated setup script without visual/GUI packages like VSCode, Postman, VirtualBox, and desktop managers that either fail or introduce unnecessary bloat. Furthermore, the installation checklist currently preselects all items, forcing users into unwanted installs unless manually toggled off. Introducing an environment profile selector and a default-unselected granular selection model ensures clean, intentional, and headless-friendly installations.

## What Changes

- Add target environment selection to `install.sh`: **Standard Ubuntu (Desktop)** and **Headless / WSL (Terminal & CLI only)**.
- Implement auto-detection for WSL (`/proc/sys/fs/binfmt_misc/WSL*` or Microsoft kernel strings) while always presenting the interactive menu for user confirmation.
- Filter out desktop-only modules (`TOOLS_DESKTOP`, `MEDIA`, `FONTS`) and GUI items in CLI categories (e.g. `install_vscode`, `install_postman`, `install_virtualbox`, `install_antigravity_ide`) when Headless/WSL profile is active.
- Change interactive menu defaults to **unselected (`OFF`)** for categories and items.
- Provide batch actions for category drilldown: allow users to select all items in a category, deselect all, or customize individual items via a granular checklist.

## Capabilities

### New Capabilities
- `environment-profiles`: Detection and filtering of installable categories and items based on target environment (Desktop vs. Headless/WSL).
- `menu-selection-flow`: Unselected-by-default checklist menus with category-level batch selection and drilldown customization.

### Modified Capabilities
<!-- None -->

## Impact

- `install.sh`: Introduces environment selection step, updates whiptail checklist default states to `OFF`, and adds category batch action flow.
- `lib/catalog.sh`: Metadata or helper functions to differentiate CLI/headless items from GUI/desktop-only items.
- Tests in `tests/lib/`: New tests verifying catalog headless filtering and selection behavior.
