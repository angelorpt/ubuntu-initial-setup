# Spec Delta

## Purpose

Define como o instalador apresenta e executa escolhas granulares: catálogo único de módulos e itens, seleção por categoria e por programa individual, e confirmação obrigatória antes de qualquer instalação.

## ADDED Requirements

### Requirement: Catálogo único de módulos e itens

O instalador SHALL manter um catálogo declarativo que registra cada módulo e cada item instalável com identificador estável, função de instalação, nome de exibição e descrição curta, e SHALL derivar dele os menus, a contagem total e a execução.

#### Scenario: Menu reflete o catálogo
- **WHEN** o menu de categorias é aberto
- **THEN** cada categoria exibida corresponde a um módulo do catálogo e cada item exibido dentro dela corresponde a um item registrado

#### Scenario: Item novo aparece sem alterar o menu
- **WHEN** um item é adicionado ao catálogo de um módulo
- **THEN** ele aparece automaticamente na etapa de seleção desse módulo, sem edição adicional no código do menu

### Requirement: Seleção por categoria e por item

O instalador SHALL permitir escolher quais categorias participam da execução e, para cada categoria escolhida, quais itens individuais serão instalados.

#### Scenario: Categoria desmarcada
- **WHEN** o usuário desmarca uma categoria
- **THEN** nenhum item dessa categoria é instalado e sua etapa de seleção de itens não é exibida

#### Scenario: Item individual desmarcado
- **WHEN** o usuário desmarca um item dentro de uma categoria selecionada
- **THEN** os demais itens da categoria são instalados e o item desmarcado é ignorado

#### Scenario: Estado inicial dos itens
- **WHEN** a etapa de seleção de itens de uma categoria é aberta pela primeira vez
- **THEN** todos os itens daquela categoria aparecem marcados por padrão

#### Scenario: Categoria sem itens selecionados
- **WHEN** o usuário confirma uma categoria sem nenhum item marcado
- **THEN** a categoria é descartada da execução sem erro e não contribui para o total

### Requirement: Confirmação obrigatória antes de instalar

O instalador SHALL apresentar um resumo da seleção e SHALL iniciar a instalação somente após confirmação explícita do usuário.

#### Scenario: Confirmação aceita
- **WHEN** o usuário confirma o resumo da seleção
- **THEN** a instalação começa apenas com os itens listados no resumo

#### Scenario: Confirmação recusada
- **WHEN** o usuário recusa ou cancela o resumo
- **THEN** nenhuma instalação é executada e o instalador encerra sem erro

#### Scenario: Nenhum item selecionado
- **WHEN** o usuário chega ao resumo sem nenhum item selecionado
- **THEN** o instalador informa que não há nada a instalar e encerra sem executar comandos

### Requirement: Execução restrita à seleção

O instalador SHALL executar apenas os itens selecionados, e o progresso e o relatório SHALL considerar somente esses itens.

#### Scenario: Progresso e relatório coerentes
- **WHEN** a instalação termina com itens não selecionados
- **THEN** o total do progresso e o relatório final contêm apenas os itens selecionados, sem entradas dos itens ignorados

### Requirement: Modo não interativo explícito

O instalador SHALL selecionar todos os itens ao receber `--all`, mas SHALL ainda exigir confirmação, dispensada apenas pelo flag `--yes`. Sem terminal interativo e sem `--yes`, SHALL encerrar com erro em vez de instalar.

#### Scenario: --all com confirmação
- **WHEN** o instalador é executado com `--all` em terminal interativo
- **THEN** todos os itens são pré-selecionados e a instalação só começa após a confirmação do resumo

#### Scenario: --all com --yes
- **WHEN** o instalador é executado com `--all --yes`
- **THEN** todos os itens são instalados sem nenhuma pergunta

#### Scenario: Sem terminal interativo
- **WHEN** o instalador é executado sem terminal interativo e sem `--yes`
- **THEN** ele encerra com código de erro e mensagem explicativa, sem instalar nada

### Requirement: Retry e continue respeitam a seleção

Os modos de retentativa e continuação SHALL operar apenas sobre os itens selecionados e SHALL manter o comportamento de pular itens conforme o histórico de resultados.

#### Scenario: Retry com seleção parcial
- **WHEN** o usuário escolhe retentar falhas e mantém apenas alguns itens no resumo
- **THEN** apenas os itens selecionados que constam como falha anterior são executados
