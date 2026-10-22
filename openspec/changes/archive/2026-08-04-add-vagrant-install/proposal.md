## Why

Vagrant is the standard HashiCorp tool for reproducible development environments, and users setting up a fresh Ubuntu dev machine already expect it alongside Terraform and VirtualBox. Currently it is not installed, and the setup repo already keeps the official HashiCorp apt key, so adding it is low-risk and consistent.

## What Changes

- Add a new `install_vagrant()` function to `install/dev.sh` that installs Vagrant from the official HashiCorp apt repository.
- Register the new install in the `DEV` module: increment `_run_dev_total` and add a `track` entry in `run_dev()`.
- Reuse the existing HashiCorp archive keyring setup (same as Terraform), installed from the official docs: https://developer.hashicorp.com/vagrant/install#linux
- Run ShellCheck (no new warnings) and update the README documentation with the new feature.

## Capabilities

### New Capabilities
- `dev-tools`: The headless/interactive setup utility for the "Dev" module installs a working Vagrant binary from the official HashiCorp apt repository, alongside the other developer tooling.

### Modified Capabilities
<!-- None: no existing specs exist yet. -->

## Impact

- `install/dev.mag`: new `install_vagrant()` function and updated `_total_dev_total` + `run_dev()`.
- Uses the existing HashiCorp `<code>.deb</code>` repo that the Terraform entry already configures (apt repo shared, key already present after `install_terraform`, but the function will ensure it independently).
- Documentation updates (README/module docs).
- Test coverage: `bash tests/run.sh` (ShellCheck + BATS) must remain green.