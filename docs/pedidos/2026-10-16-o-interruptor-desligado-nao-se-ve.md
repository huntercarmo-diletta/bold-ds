# PEDIDO · O interruptor desligado não se vê — no claro, nenhum pixel do controle chega a 3:1

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0`, pela tag `web-v0.125.0` deste repo
- **bloqueante?**: **sim, para a troca** — o `BoldToggle` do IB fica local até o desligado se ver
- **irmão**: `2026-09-29-a-caixa-vazia-do-checkbox-e-do-radio-nao-passa-3-para-1.md` (ENTRA na `v3.2.0`, que criou o `contornoDeControle`). Lá o trilho do interruptor foi recusado com a condição de reabrir: *«com a medida do controle inteiro, polegar e sombras juntos»*. Este pedido traz essa medida.

## Falta

Que o `<diletta-toggle-switch>` desligado se distinga do que está atrás dele com 3:1 (WCAG 1.4.11). Hoje a
tabela de pintura dá `surfaceMuted` ao trilho no estado `off`, e esse papel é quase o fundo.

## Número

**O controle inteiro, medido por pixel.** Em 16/10, no Chrome 155, com a `web-v0.125.0`: um
`<diletta-toggle-switch>` desligado sobre `bg` e outro sobre `surface`, capturados a 4×, e o pixel do
controle mais distante do que está atrás. Trilho, polegar e sombra entram juntos.

| marca e modo | sobre `bg` | sobre `surface` | o pixel que ganhou |
|---|--:|--:|---|
| Bold, claro | **1,28:1** | **1,42:1** | a sombra do polegar |
| Bold, escuro | 19,64:1 | 18,15:1 | o polegar branco |
| Norte Benk, claro | **1,46:1** | **1,46:1** | a sombra do polegar |
| Norte Benk, escuro | 17,87:1 | 15,31:1 | o polegar branco |

No claro, nenhum pixel do controle chega a 3:1: o polegar é branco sobre um trilho quase branco, e a
sombra é o que mais aparece. No escuro, o polegar aparece, mas sozinho ele não diz o estado: o estado é a
posição dele no trilho, e o trilho some.

**O trilho, por papel**, contra o fundo, o cartão e o polegar:

| marca e modo | `surfaceMuted` contra `bg` | contra `surface` | contra o polegar | `contornoDeControle` contra `bg` | contra `surface` | contra o polegar |
|---|--:|--:|--:|--:|--:|--:|
| Bold, claro | 1,03 | 1,13 | 1,13 | 3,57 | 3,95 | 3,95 |
| Bold, escuro | 1,21 | 1,11 | 16,29 | 4,14 | 3,83 | 4,74 |
| Norte Benk, claro | 1,17 | 1,17 | 1,17 | 4,00 | 4,00 | 4,00 |
| Norte Benk, escuro | 1,75 | 1,50 | 10,23 | 4,47 | 3,83 | 4,00 |

## Já tentei

- **Pôr o interruptor só sobre cartão**: o cartão é mais claro que o fundo no Bold, e o desligado continua
  abaixo de 3:1 nos dois.
- **Pintar o trilho por fora**: o trilho mora no shadow, e o `part="trilho"` deixaria cada filho com a sua
  cor para o mesmo controle.
- **No IB, enquanto isso**: a nossa peça local passou a ler `contornoDeControle` no trilho desligado, com
  uma régua no gate de contraste que cobra 3:1 contra fundo, cartão e polegar nas duas marcas e nos dois
  modos. É o remendo que este pedido quer apagar.

## Conferi no pai

- O `contornoDeControle` existe desde a `v3.2.0`, derivado com piso de 3:1 contra `surface` nos dois
  modos, para os traços vazios do checkbox, do rádio e do código. O trilho desligado é a mesma classe: o
  contorno de um controle vazio.
- O veredito de 29/09 recusou o trilho por falta da medida do controle inteiro. A primeira tabela acima é
  essa medida.

## Derivável?

Não: o trilho mora no shadow.

## Se você disser não

O `BoldToggle` fica local, com o remendo, e o interruptor da linguagem não entra em tela do IB.

## Não estou pedindo

Mudar o ligado, o desabilitado ou a geometria. Só o papel do trilho no estado `off`.

## Como o pai vai saber que funcionou

`<diletta-toggle-switch>` desligado sobre `bg` e sobre `surface`, nas marcas do catálogo e nos dois modos:
o trilho passa 3:1 contra os dois fundos e contra o polegar. O gate que mede o contorno do checkbox ganha
o trilho.
