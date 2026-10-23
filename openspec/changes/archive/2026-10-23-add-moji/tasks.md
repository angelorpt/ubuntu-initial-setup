# Tasks

## 1. Catalog Registration

- [x] 1.1 Register `install_moji` in `_ITEMS_TOOLS_DESKTOP` in `lib/catalog.sh` with English and Portuguese descriptions
- [x] 1.2 Verify catalog tests (`bats tests/lib/catalog.bats`) pass with updated item count

## 2. Implementation

- [x] 2.1 Implement `install_moji` in `install/tools_desktop.sh` adhering to style conventions, header, details, and `install_deb`
- [x] 2.2 Verify shell syntax with `bash -n install/tools_desktop.sh` and ShellCheck

## 3. Verification & Documentation

- [x] 3.1 Run `bash tests/run.sh` to ensure all tests pass
- [x] 3.2 Update `README.md` and `README.pt-BR.md` with Moji entry and updated item counts
