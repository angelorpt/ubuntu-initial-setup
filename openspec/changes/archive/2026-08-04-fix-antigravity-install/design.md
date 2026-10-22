## Context

O script `install/dev.sh` atualmente baixa os tarballs do Antigravity 2.0 e Antigravity IDE diretamente para o diretório `/tmp`, extraindo-os para `/opt`. Não há processo de limpeza robusto de instalações antigas ou de links simbólicos quebrados, e erros durante downloads ou extrações de tarball não são capturados adequadamente para interromper o fluxo com segurança.

## Goals / Non-Goals

**Goals:**
- Implementar limpeza prévia de links simbólicos e diretórios existentes em `/usr/local/bin` e `/opt`.
- Adicionar tratamento de erros robusto em cada etapa crítica da instalação (download, extração, symlinks).
- Garantir que links simbólicos apontem para os caminhos corretos e funcionais no sistema operacional.

**Non-Goals:**
- Mudar as URLs de download oficiais que são raspadas dinamicamente via `curl` no site do Antigravity.
- Implementar atualização automática em background dos binários após a instalação.

## Decisions

### 1. Limpeza Prévia Segura
Decidimos remover ativamente `/usr/local/bin/antigravity`, `/usr/local/bin/antigravity-ide`, `/opt/antigravity` e `/opt/antigravity-ide` antes de descompactar os novos arquivos.
*Rationale*: Evita conflitos de permissões ou arquivos remanescentes de versões anteriores misturados com a nova instalação.
*Alternatives Considered*: Tentar sobrescrever diretamente com o comando `tar` ou `mv`. Porém, isso pode falhar ou mesclar diretórios se a estrutura de pastas mudou.

### 2. Tratamento de Erros usando `|| die_on_error` ou similares
O projeto possui helpers definidos em `lib/utils.sh` (como `die_on_error`). Decidimos envelopar as operações ou usar validações explícitas de status de saída (`$?`). Se um comando falhar, utilizaremos logs de erro (`log_error`) e retornaremos um código de erro para evitar que o script continue silenciosamente.
*Rationale*: Segue os padrões do projeto e garante que o usuário saiba exatamente onde e por que a instalação falhou.

### 3. Caminhos Corretos de Links Simbólicos
- Para Antigravity 2.0: Linkar `/opt/antigravity/antigravity` para `/usr/local/bin/antigravity`.
- Para Antigravity IDE: Linkar `/opt/antigravity-ide/bin/antigravity-ide` para `/usr/local/bin/antigravity-ide`.
*Rationale*: Garante que ambos os executáveis estejam acessíveis globalmente via PATH do sistema.

## Risks / Trade-offs

- **[Risk]** O comando `tar -xzf` pode falhar se a URL retornada pelo scraper estiver corrompida ou offline.
  - **Mitigation** Verificamos se o download com `wget` foi bem-sucedido e se o arquivo baixado não está vazio antes de tentar extraí-lo.
