# Spec Delta

## Purpose

Improves menu layout sizing and category item drilldown navigation so descriptions fit comfortably and users can easily select all or navigate back.

## MODIFIED Requirements

### Requirement: Inicialização de listas de seleção desmarcadas por padrão
Os menus interativos de checklist para categorias e programas individuais SHALL iniciar com todos os itens desmarcados (estado OFF) por padrão em novas instalações, com títulos, descrições e orientações traduzidas de acordo com o idioma ativo (inglês padrão ou português) e largura dimensionada para evitar truncamento de texto.

#### Scenario: Visualização de itens sem truncamento de texto
- **WHEN** o usuário abre a lista de itens de uma categoria com descrições detalhadas
- **THEN** a caixa do menu tem largura responsiva proporcional às colunas do terminal (ex: 88 a 98 colunas) para acomodar o texto

#### Scenario: Abertura do menu de categorias
- **WHEN** o usuário acessa o menu de categorias em uma nova instalação
- **THEN** nenhuma categoria vem marcada previamente e o texto exibe as mensagens no idioma ativo

#### Scenario: Abertura do menu de programas individuais
- **WHEN** o usuário entra na seleção detalhada de itens de uma categoria
- **THEN** todos os programas da categoria iniciam no estado desmarcado (OFF) e as descrições dos programas refletem o idioma escolhido

### Requirement: Ações de seleção em lote por categoria
Ao selecionar uma categoria, o instalador SHALL permitir escolher entre selecionar todos os itens da categoria imediatamente ou abrir o checklist para escolha item a item, apresentando o menu no idioma ativo e permitindo retornar ao menu de lote ou marcar todos os itens a partir da lista.

#### Scenario: Retorno ao menu da categoria a partir do checklist de itens
- **WHEN** o usuário abre a personalização de itens e escolhe voltar ou cancela a tela detalhada
- **THEN** o instalador retorna à escolha de ação da categoria em vez de abortar o processo geral

#### Scenario: Opção de selecionar todos dentro da lista de itens
- **WHEN** o usuário visualiza a lista de itens e marca a opção inicial de selecionar todos
- **THEN** todos os itens da categoria são marcados automaticamente

#### Scenario: Seleção em lote de todos os itens da categoria
- **WHEN** o usuário opta por selecionar todos os programas de uma categoria selecionada
- **THEN** todos os itens aplicáveis da categoria são marcados sem necessidade de marcar um a um

#### Scenario: Seleção granular item a item
- **WHEN** o usuário opta por personalizar os itens de uma categoria
- **THEN** o checklist da categoria é apresentado permitindo marcar programas específicos
