## Purpose

Provides a working HashiCorp Vagrant binary on fresh Ubuntu developer machines through the setup utility's Dev module, enabling reproducible development environments via the official apt repository and documenting the install in the README.

## ADDED Requirements

### Requirement: Vagrant installed from official HashiCorp apt repository
The system SHALL install Vagrant using the official HashiCorp apt repository (https://apt.releases.hashicorp.com), configuring the HashiCorp archive keyring and the corresponding apt sources entry independently of any other installed package.

#### Scenario: Vagrant install succeeds on a fresh system
- **WHEN** the Dev module runs the Vagrant install item on a fresh Ubuntu machine
- **THEN** the HashiCorp apt keyring and `hashicorp.list` sources entry are configured without depending on prior installs
- **AND** the `vagrant` package is installed from the HashiCorp apt repository
- **AND** the resulting Vagrant binary reports a version when invoked

#### Scenario: Numeric Dev module total accounts for Vagrant
- **WHEN** the Dev module is registered in the setup tool
- **THEN** the Dev module item total includes the Vagrant install item

### Requirement: Vagrant documented in the README
The system SHALL document Vagrant in the project README so users can discover what it installs and where to learn more.

#### Scenario: README lists Vagrant
- **WHEN** a user reads the README Dev section
- **THEN** the Dev package table includes a Vagrant row with a description and a link to the official HashiCorp Vagrant install documentation
- **AND** any Dev tooling count shown in the README reflects the Vagrant item