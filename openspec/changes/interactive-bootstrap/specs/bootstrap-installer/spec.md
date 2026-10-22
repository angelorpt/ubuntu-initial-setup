# Spec Delta

## Purpose

Define o ciclo de execução do bootstrap, garantindo inicialização interativa do menu via TTY, fallback seguro em ambientes não interativos e suporte a automação explícita.

## ADDED Requirements

### Requirement: Execução interativa padrão do menu via pipe

O script de bootstrap SHALL reconectar o fluxo de entrada padrão ao terminal (`/dev/tty`) quando executado em terminal interativo e SHALL iniciar o instalador em modo interativo por padrão.

#### Scenario: Pipe em terminal interativo
- **WHEN** o usuário executa o bootstrap via pipe (`curl ... | bash`) em um terminal interativo com `/dev/tty` disponível
- **THEN** o script reconecta o `stdin` ao `/dev/tty` e executa `install.sh` abrindo o menu interativo de seleção de categorias e itens

### Requirement: Fallback seguro sem TTY interativo

Quando executado sem um terminal interativo acessível e sem flags explícitas de automação, o bootstrap SHALL instalar as dependências básicas, clonar/atualizar o repositório e exibir instruções para execução manual sem iniciar a instalação em lote.

#### Scenario: Execução sem terminal interativo e sem argumentos
- **WHEN** o bootstrap é executado sem `/dev/tty` ou sem terminal interativo e nenhum argumento de instalação for fornecido
- **THEN** o script prepara o repositório, não executa `install.sh --all --yes` e exibe mensagem explicando como rodar `./install.sh` manualmente

### Requirement: Suporte a argumentos e automação não interativa

O script de bootstrap SHALL repassar quaisquer argumentos recebidos na linha de comando diretamente para `install.sh`, permitindo execuções automatizadas intencionais.

#### Scenario: Repasse de argumentos para instalação headless
- **WHEN** o usuário executa o bootstrap passando argumentos como `--all --yes`
- **THEN** o bootstrap repassa esses argumentos para `install.sh`, permitindo instalação silenciosa quando solicitado explicitamente
