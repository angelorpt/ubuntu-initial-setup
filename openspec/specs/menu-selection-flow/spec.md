# menu-selection-flow Specification

## Purpose
Provides a clean and intentional menu selection experience where checklists start unselected by default and support category-level batch selection.

## Requirements

### Requirement: Inicialização de listas de seleção desmarcadas por padrão
Os menus interativos de checklist para categorias e programas individuais SHALL iniciar com todos os itens desmarcados (estado OFF) por padrão em novas instalações, com títulos, descrições e orientações traduzidas de acordo com o idioma ativo (inglês padrão ou português).

#### Scenario: Abertura do menu de categorias
- **WHEN** o usuário acessa o menu de categorias em uma nova instalação
- **THEN** nenhuma categoria vem marcada previamente e o texto exibe as mensagens no idioma ativo

#### Scenario: Abertura do menu de programas individuais
- **WHEN** o usuário entra na seleção detalhada de itens de uma categoria
- **THEN** todos os programas da categoria iniciam no estado desmarcado (OFF) e as descrições dos programas refletem o idioma escolhido

### Requirement: Ações de seleção em lote por categoria
Ao selecionar uma categoria, o instalador SHALL permitir escolher entre selecionar todos os itens da categoria imediatamente ou abrir o checklist para escolha item a item, apresentando o menu no idioma ativo.

#### Scenario: Seleção em lote de todos os itens da categoria
- **WHEN** o usuário opta por selecionar todos os programas de uma categoria selecionada
- **THEN** todos os itens aplicáveis da categoria são marcados sem necessidade de marcar um a um

#### Scenario: Seleção granular item a item
- **WHEN** o usuário opta por personalizar os itens de uma categoria
- **THEN** o checklist da categoria é apresentado permitindo marcar programas específicos
