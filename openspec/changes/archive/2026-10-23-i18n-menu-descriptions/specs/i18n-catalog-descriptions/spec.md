# Spec Delta

## Purpose

Enables multi-language catalog descriptions for installable programs and categories, supporting English as the default and Portuguese as an option.

## ADDED Requirements

### Requirement: Suporte bilíngue para descrições de programas e categorias
O catálogo do instalador SHALL suportar a recuperação de descrições de programas e módulos em múltiplos idiomas (`en` e `pt-BR`), utilizando o inglês como padrão caso nenhum idioma seja especificado.

#### Scenario: Recuperação em inglês por padrão
- **WHEN** a função de catálogo requisitar a descrição de um item sem especificação de idioma ou com `APP_LANG="en"`
- **THEN** o catálogo retorna a descrição em inglês

#### Scenario: Recuperação em português
- **WHEN** o usuário seleciona o idioma português (`APP_LANG="pt"` ou `pt-BR`)
- **THEN** o catálogo retorna a descrição traduzida em português
