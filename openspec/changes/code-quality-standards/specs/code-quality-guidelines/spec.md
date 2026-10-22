# Spec Delta

## Purpose

Define requisitos normativos de boas práticas de engenharia de software (DRY, KISS, SOLID adaptado a Shell, tratamento robusto de diretórios e entradas de usuário) e sua documentação em AGENTS.md.

## ADDED Requirements

### Requirement: Reutilização de rotinas comuns (DRY)

O instalador SHALL reutilizar funções utilitárias consolidadas em `lib/utils.sh` (como `install_deb`) sempre que instalar pacotes locais `.deb`, em vez de reimplementar a sequência `dpkg -i` + `apt install -f`.

#### Scenario: Instalação de pacote deb avulso
- **WHEN** uma função de instalação baixa um pacote `.deb` para instalação
- **THEN** ela invoca `install_deb` passando o caminho do pacote, assegurando correção de dependências

### Requirement: Segurança de navegação de diretórios e leitura de dados

Scripts que alteram o diretório de trabalho SHALL tratar falhas de `pushd` e `popd` com verificação de erro ou execução em subshell, e leituras interativas via `read` SHALL utilizar `-r` para prevenir interpretação incorreta de caracteres de escape.

#### Scenario: Falha de diretório temporário
- **WHEN** uma chamada `pushd` ou `popd` é executada
- **THEN** ela não continua a execução caso a mudança de diretório falhe

#### Scenario: Leitura de dados de configuração
- **WHEN** o instalador solicita dados interativos (como email ou usuário do Git)
- **THEN** o comando `read -r` é utilizado para preservar caracteres literais

### Requirement: Governança de boas práticas no AGENTS.md

O arquivo `AGENTS.md` SHALL conter uma seção dedicada aos princípios de qualidade de código (SOLID, DRY, KISS, Clean Code adaptados para Shell Scripts) orientando o desenvolvimento de novos módulos e manutenções.

#### Scenario: Consulta de padrões em AGENTS.md
- **WHEN** um desenvolvedor ou agente consulta `AGENTS.md`
- **THEN** o documento explicita as regras de modularidade, reuso, tratamento de erros e convenções de estilo do projeto
