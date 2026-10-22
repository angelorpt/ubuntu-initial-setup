## Context

See proposal.md for the motivation. The Dev module lives in `install/dev.sh`: each item is a `install_*()` function, registered by bumping `_run_dev_total` and adding a `track "DEV" install_* "Display"` call inside `run_dev()`. Terraform (`install_terraform`) already configures the official HashiCorp apt keyring (`/etc/apt/keyrings/hashicorp-archive-keyring.gpg`) and the `hashicorp.list` sources entry. README.md documents the Dev module in two places: the one-line summary table (line ~139) and the Dev package table (~160-186).

## Goals / Non-Goals

**Goals:**
- Add an `install_vagrant()` function following the same `print_header` / `print_details` / commands / `log_success` pattern used by every other module item.
- Register Vagrant in the Dev module (total bump from 22 to 23 + `track` call).
- Reuse the HashiCorp keyring/list configuration, but set it up inside the function independently (not relying on Terraform's side effects).
- Update the README Dev summary and package table.

**Non-Goals:**
- Not installing virtualbox provider config or any Vagrant plugins.
- Not changing the Terraform install or the shared HashiCorp repo logic.

## Decisions

**Install via HashiCorp apt repo (same as Terraform), not `apt install virtualbox` deb or a direct download.**
Rationale: matches official docs (https://developer.hashicorp.com/vagrant/install#linux), gives automatic updates, and reuses the repo that the Dev module already trusts. Alternative considered: installing a `.deb` directly from releases.hashicorp.com - rejected for version pinning and the duplicate work vs the established repo pattern.

**[Mirror Terraform's exact repo/key commands]**
The function repeats the keyring + sources setup (copying the Terraform body) and then runs `sudo apt update && sudo apt install -y vagrant`. This keeps Vagrant independent of install order; the cost of duplicating ~3 lines is acceptable for robustness. Alternative considered: refactor the shared HashiCorp setup into a helper in `lib/utils.sh` - deferred to a separate refactor to keep this change focused.

**Version logged on success** using `vagrant --version`, matching the Terraform item's behavior.

## Risks / Trade-offs

- Duplicated HashiCorp repo setup across Terraform/Vagrant could drift → accepted for now; a `ensure_hashicorp_repo()` helper in `lib/utils.sh` is a clean follow-up.
- Both items run `apt update`; harmless but slightly slower → negligible for a setup script.
- README Dev count (22) must be bumped where shown or the summary becomes inconsistent → update both the summary line and the table row.