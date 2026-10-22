## 1. Implement Vagrant install

- [x] 1.1 Add `install_vagrant()` to `install/dev.sh` mirroring the Terraform function: `# https://developer.hashicorp.com/vagrant/install#linux`
- [x] 1.2 In `install_vagrant()`: `print_header "Vagrant" "..."`, `print_details "..."`, configure the HashiCorp keyring + `hashicorp.list` independently, then `sudo apt update && sudo apt install -y vagrant`, ending with `log_success "Vagrant instalado: $(vagrant --version 2>&1 | head -1)"`

## 2. Register in Dev module

- [x] 2.1 Bump `_run_dev_total` from 22 to 23 in `install/dev.sh`
- [x] 2.2 Add `track "DEV" install_vagrant "Vagrant"` inside `run_dev()` (placed after Terraform for logical grouping)

## 3. Update documentation

- [x] 3.1 Add a Vagrant row to the README Dev package table (`Programa | Descrição | Site`), linking to https://developer.hashicorp.com/vagrant/install
- [x] 3.2 Add Vagrant to the README Dev summary line and bump the shown Dev count from 22 to 23 if it appears there

## 4. Verify

- [x] 4.1 Run `bash tests/lint.sh` (ShellCheck) to confirm `install/dev.sh` passes
- [x] 4.2 Run `bash tests/run.sh` to confirm ShellCheck + BATS pass