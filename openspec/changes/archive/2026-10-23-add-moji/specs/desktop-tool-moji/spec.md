# Spec Delta

## Purpose

Enables automated installation of the latest Moji emoji picker `.deb` package on Ubuntu desktop workstations.

## ADDED Requirements

### Requirement: Instalação automatizada do Moji via pacote .deb mais recente
O módulo TOOLS_DESKTOP SHALL permitir a instalação do Moji consultando a API do GitHub para obter a URL do pacote `.deb` da versão mais recente (com fallback seguro caso a API atinja rate-limit) e instalando-o via `install_deb`.

#### Scenario: Instalação bem-sucedida do Moji
- **WHEN** o usuário seleciona Moji no menu de instalação
- **THEN** o instalador baixa o `.deb` da versão mais recente em diretório temporário, executa a instalação e registra o sucesso

#### Scenario: Detecção de instalação prévia
- **WHEN** o Moji já estiver instalado no sistema (`command -v moji`)
- **THEN** o instalador informa que já está presente e não refaz o download desnecessariamente
