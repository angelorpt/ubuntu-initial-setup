# Proposal

## Why

Desktop users frequently need an easy emoji picker with modern UI. Moji is an open-source, lightweight emoji picker for Linux desktop environments built by Alexis Hida. Adding Moji to the `TOOLS_DESKTOP` module expands the suite's desktop productivity tooling.

## What Changes

- Add `install_moji` to `install/tools_desktop.sh` using GitHub release API resolution to automatically download and install the latest `.deb` package via `install_deb`.
- Register Moji in `lib/catalog.sh` under `_ITEMS_TOOLS_DESKTOP` with English and Portuguese descriptions.
- Ensure Moji is recognized as a desktop GUI app (hidden when the headless/WSL profile is active).
- Update `README.md` and `README.pt-BR.md` counts and tool tables.

## Capabilities

### New Capabilities
- `desktop-tool-moji`: Automated installation of the latest Moji emoji picker `.deb` on Ubuntu desktop environments.

### Modified Capabilities
<!-- None -->

## Impact

- `install/tools_desktop.sh`: New install function `install_moji`.
- `lib/catalog.sh`: Registered under `_ITEMS_TOOLS_DESKTOP`.
- `README.md` and `README.pt-BR.md`: Updated counts (tools_desktop goes from 12 to 13, total from 91 to 92).
