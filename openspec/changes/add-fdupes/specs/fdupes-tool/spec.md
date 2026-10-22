## Purpose

Garante que o módulo Tools Terminal instale o `fdupes`, ferramenta de linha de comando para localizar e remover arquivos duplicados, a partir do repositório oficial do Ubuntu.

## ADDED Requirements

### Requirement: fdupes disponível após a instalação
O módulo Tools Terminal SHALL instalar o pacote `fdupes` via `sudo apt install -y fdupes`, tornando o comando `fdupes` disponível no terminal.

#### Scenario: Instalação do fdupes
- **WHEN** o módulo Tools Terminal é executado
- **THEN** o pacote `fdupes` é instalado via apt e o comando `fdupes --version` retorna sua versão

#### Scenario: Localização de arquivos duplicados
- **WHEN** o usuário executa `fdupes -r DIRETORIO`
- **THEN** o fdupes lista os arquivos duplicados encontrados no diretório informado

### Requirement: Total do módulo reflete a nova ferramenta
O contador `_run_tools_terminal_total` SHALL ser incrementado quando `install_fdupes` for adicionado ao módulo, mantendo o progresso do módulo coerente com o número de itens rastreados.

#### Scenario: Progresso exato do módulo
- **WHEN** o módulo Tools Terminal executa com 15 itens rastreados
- **THEN** a barra de progresso alcança 100% apenas após todos os itens, incluindo fdupes, terminarem
