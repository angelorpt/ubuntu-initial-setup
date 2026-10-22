## Why

A instalação do Antigravity 2.0 e do Antigravity IDE pode falhar ou deixar links simbólicos incorretos ou quebrados caso a instalação anterior não seja limpa adequadamente. Além disso, a falta de tratamento de erros robusto (como blocos try-catch ou verificações de status de saída) faz com que falhas no download ou na extração dos pacotes interrompam ou quebrem o fluxo de setup.

## What Changes

- **Limpeza robusta antes da instalação**: Remover instalações anteriores e links simbólicos antigos em `/usr/local/bin` e `/opt`.
- **Tratamento de erros aprimorado**: Adicionar verificações de erros nas operações críticas (download, descompactação, movimentação de arquivos e criação de links simbólicos) e interromper a execução do script com uma mensagem clara caso alguma etapa falhe.
- **Instalação correta e symlinks funcionais**:
  - Extrair o Antigravity 2.0 e mover a pasta descompactada para `/opt/antigravity` de forma segura.
  - Extrair o Antigravity IDE, mover a pasta descompactada para `/opt/antigravity-ide`, e linkar `/opt/antigravity-ide/bin/antigravity-ide` (ou `/opt/antigravity/bin/antigravity-ide` caso seja um executável compartilhado) adequadamente para `/usr/local/bin/antigravity-ide`.

## Capabilities

### New Capabilities
- `dev-tools-install`: Ajustar os procedimentos de instalação das ferramentas de desenvolvimento (Antigravity e Antigravity IDE) para suportar limpeza prévia, tratamento de erros e links simbólicos corretos.

### Modified Capabilities
<!-- None -->

## Impact

Afeta as funções `install_antigravity2` e `install_antigravity_ide` dentro do módulo de instalação de desenvolvimento `install/dev.sh`.
