# PEDIDO · O interruptor não tem rótulo nem descrição — e o checkbox tem

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0`, pela tag `web-v0.125.0` deste repo
- **bloqueante?**: **sim, para a troca** — 3 dos 5 interruptores do IB têm descrição, e ela deixaria de ser lida com o controle
- **irmão**: `2026-09-29-o-checkbox-e-so-codigo-e-o-console-desenha-o-seu-sobre-o-input-nativo.md` (o `<diletta-checkbox>` nasceu com rótulo e descrição dentro do shadow) e `2026-10-16-o-interruptor-desligado-nao-se-ve.md` (o outro buraco do mesmo controle)

## Falta

Que o `<diletta-toggle-switch>` aceite `rotulo` visível e `descricao`, como o `<diletta-checkbox>` aceita:
o texto ao lado do controle, a descrição ligada a ele por `aria-describedby` dentro do shadow, e o clique
no texto alternando. Hoje o elemento é só o trilho, e `rotulo` vira `aria-label`.

## Número

Os cinco interruptores do IB, medidos em 16/10:

| onde | rótulo | descrição |
|---|---|---|
| Entrar | «Computador compartilhado» | «Não guarda o CPF e apaga tudo ao sair.» |
| Pix Automático, nova cobrança | «Valor fixo» | o que o pagador vê, muda com o estado |
| Pix Automático, nova cobrança | «Gerar QR Code» | como o cliente autoriza, muda com o estado |
| Matriz de permissões | uma por permissão | uma por permissão |
| Editor de alçada | «Exige todos os titulares» | — |

Três dos cinco têm descrição. Duas delas mudam com o estado e dizem o que o estado significa: são a
parte do controle que explica a escolha.

## Já tentei

- **Montar a linha por fora**, com o texto do IB ao lado do elemento: funciona para o olho e não para
  quem ouve. A descrição não se liga ao controle, porque referência por `id` não atravessa o shadow, e o
  clique no texto não alterna. É o argumento que o pai usou nas abas em 15/10 para recusar o
  `aria-controls`.
- **Juntar a descrição ao nome** (`rotulo="Computador compartilhado. Não guarda o CPF…"`): o leitor
  lê uma frase longa como nome do controle, e a descrição que muda com o estado muda o nome junto.

## Conferi no pai

- O `<diletta-checkbox>` tem `rotulo` e `descricao`, com paridade declarada (`descricao = description`),
  e a descrição mora no shadow. É a mesma anatomia: um controle binário com texto ao lado.
- O `DilettaToggleSwitch` do Dart também não tem rótulo, só `semanticLabel`. Não medi se a linha montada
  por fora perde a descrição no Dart; na web ela perde, pelo shadow.

## Derivável?

Não: a ligação entre controle e descrição só existe dentro do mesmo shadow.

## Se você disser não

O `BoldToggle` fica local, e o interruptor da linguagem só serve onde não há descrição.

## Não estou pedindo

Mudar o desenho do trilho, o tamanho ou o alvo. O Dart fica a seu critério.

## Como o pai vai saber que funcionou

`<diletta-toggle-switch rotulo="Computador compartilhado" descricao="Não guarda o CPF…">` → o `switch`
de dentro tem o nome do rótulo e a descrição por `aria-describedby`; clicar no texto alterna e avisa
`mudou` uma vez; sem `descricao`, nada de descrição vazia.
