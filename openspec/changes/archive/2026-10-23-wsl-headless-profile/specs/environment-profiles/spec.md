# Spec Delta

## Purpose

Enables detecting and selecting the target runtime environment (Desktop vs. Headless/WSL) and filtering installable modules and packages accordingly.

## ADDED Requirements

### Requirement: Detecção e seleção de ambiente de execução
O instalador SHALL detectar se o ambiente atual é WSL e permitir que o usuário escolha explicitamente entre os perfis Standard Ubuntu (Desktop) e Headless / WSL antes da seleção de módulos.

#### Scenario: Detecção automática de WSL com confirmação via menu
- **WHEN** o usuário inicia a execução interativa em ambiente WSL
- **THEN** o menu sugere o perfil Headless/WSL como padrão inicial, mas mantém a opção de alterar para Standard Ubuntu

#### Scenario: Execução em ambiente Ubuntu Desktop comum
- **WHEN** o usuário inicia a execução em máquina Desktop sem WSL
- **THEN** o menu sugere o perfil Standard Ubuntu como padrão inicial

### Requirement: Filtragem de categorias e pacotes no perfil Headless/WSL
Quando o perfil Headless / WSL estiver ativo, o instalador SHALL ocultar categorias exclusivamente gráficas e remover ferramentas de GUI de categorias mistas.

#### Scenario: Ocultação de categorias Desktop
- **WHEN** o perfil Headless/WSL está ativo
- **THEN** os módulos TOOLS_DESKTOP, MEDIA e FONTS não são exibidos no menu nem instalados

#### Scenario: Filtragem de ferramentas visuais em categorias de desenvolvimento
- **WHEN** o perfil Headless/WSL está ativo e a categoria DEV é selecionada
- **THEN** ferramentas de interface gráfica como VSCode, Postman, VirtualBox e Antigravity IDE são omitidas da lista de itens
