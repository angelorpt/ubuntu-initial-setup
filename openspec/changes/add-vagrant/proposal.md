## Why

Vagrant is the standard HashiCorp tool for reproducible development environments, and the repo already installs Terraform from the same official HashiCorp apt repository. Adding Vagrant gives users a consistent, documented way to provision and share dev/prod-equivalent environments, reusing the apt repo and key already in place.

## What Changes

- Add a new `install_vagrant()` function to `install/dev.sh` that installs Vagrant from the official HashiCorp apt repository, following the official docs: https://developer.hashicorp.com/vagrant/install#linux
- Reuse the existing HashiCorp archive keyring + `.list` setup (same approach as Terraform), ensuring it is set up independently rather than depending on another install's side effects.
- Register the new item in the Dev module: bump `_run_dev_total`, add `track "DEV" install_vagrant "Vagrant"` in `run_dev()`.
- Update documentation (README.md): add Vagrant to the Dev tools summary, the Dev package table, and the Dev module total count if it appears.

## Capabilities

### New Capabilities
- `dev-tools`: The interactive/headless setup utility installs a working Vagrant binary from the official HashiCorp apt repository as part of the Dev module, alongside the other developer tooling, and documents it in the README.

### Modified Capabilities
<!-- None - no existing specs are modified. -->

## Impact

- `install/dev.sh`: new `install_vagrant()` function, `_run_dev_total` bumped from 22 to 23, `run_dev()` gains a new `track` call.
- `README.md`: Dev summary line and Dev package table gain a Vagrant row; update the Dev tools count (22 -> 23) if shown.
- Reuses the HashiCorp apt keyring `/etc/apt/keyrings/hashicorp-archive-keyring.gpg` and `hashicorp.list` sources entry (same as Terraform). Installs no other providers; VirtualBox (already a Dev module item) is a supported provider.