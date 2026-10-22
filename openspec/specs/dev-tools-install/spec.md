# dev-tools-install Specification

## Purpose
Garante a instalação confiável e correta do Antigravity 2.0 e do Antigravity IDE, limpando instalações prévias e tratando erros de rede ou de sistema durante a execução.

## Requirements

### Requirement: Limpeza prévia de instalações antigas
O instalador do Antigravity e do Antigravity IDE SHALL remover links simbólicos e diretórios de instalações anteriores em `/usr/local/bin` e `/opt` antes de prosseguir com uma nova descompactação para evitar conflitos ou links quebrados.

#### Scenario: Remoção de instalações anteriores antes do setup
- **WHEN** o usuário inicia a instalação de Antigravity ou Antigravity IDE
- **THEN** o script remove arquivos e links anteriores de forma segura e silenciosa sem abortar caso eles não existam

### Requirement: Tratamento de falhas na instalação
O instalador do Antigravity e do Antigravity IDE SHALL verificar o status das operações críticas (download do tarball, extração com tar, movimentação de arquivos para `/opt` e criação de links simbólicos) e interromper a execução do instalador caso ocorra alguma falha, exibindo uma mensagem de erro explicativa.

#### Scenario: Falha no download ou extração de pacotes
- **WHEN** o download falhar ou o tarball estiver corrompido durante a extração
- **THEN** o script detecta a falha, interrompe o fluxo de instalação retornando um código de status de erro (não-zero) e exibe uma mensagem informativa

### Requirement: Links simbólicos funcionais
O instalador do Antigravity e do Antigravity IDE SHALL criar links simbólicos válidos em `/usr/local/bin` apontando diretamente para os respectivos arquivos executáveis instalados em `/opt/antigravity` e `/opt/antigravity-ide`.

#### Scenario: Criação de links após instalação bem-sucedida
- **WHEN** a descompactação e movimentação de arquivos forem concluídas com sucesso
- **THEN** o script cria o link simbólico `/usr/local/bin/antigravity` apontando para `/opt/antigravity/antigravity` e `/usr/local/bin/antigravity-ide` apontando para `/opt/antigravity-ide/bin/antigravity-ide` (ou executável equivalente do IDE)
