# PEDIDO · O checkbox e o interruptor web não têm o piso de 44 — e o Dart do interruptor tem

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.13.0` · `web-v3.13.0`, pela tag `web-v0.123.0` deste repo (medido em 14/10, no navegador, com os elementos registrados numa página nua)
- **bloqueante?**: **não** — o IB mantém o `<input type="checkbox">` nativo e o `BoldToggle` local até o veredito; o custo está em «Se você disser não»
- **irmão**: `2026-10-15-as-tres-pecas-de-escolha-novas-derrubam-o-foco.md` (o mesmo lote, a outra classe de defeito)

## Falta

O alvo de toque de 44 nas duas peças de escolha que nasceram na `v3.13.0` para a web: `<diletta-checkbox>` e `<diletta-toggle-switch>`. A casa tem o número escrito no `DilettaAlvoDeToque` — *«o piso é 44 ([DilettaAlvo.piso]) — o número do iOS HIG e o critério AAA da WCAG 2.5.5»* — e o aplicou na web ao segmentado (`web-v2.7.0`, host com `min-height: 44`), à paginação (22/09) e ao link de texto (`v3.10.0`). As duas peças novas saíram sem ele.

## Número

| medida | valor |
|---|---|
| `<diletta-checkbox size="md">`: host e `[role=checkbox]` | **20 × 20** |
| `<diletta-toggle-switch size="md">`: host e `[role=switch]` | **44 × 24** (24 de altura) |
| `<diletta-segmented-control>`: host | **44** (trilho de 32 por dentro) — o precedente da própria web |
| `DilettaToggleSwitch` no Dart (`diletta_toggle_switch.dart:141-145`) | *«O PISO DO ALVO. A trilha pintada é 36×20 (sm) ou 44×24 … a área tocável passa a 44»* — `DilettaAlvoDeToque(child: core)` |
| `DilettaCheckbox` no Dart (`diletta_checkbox.dart`) | `Semantics(checked:)` + `GestureDetector`, **sem** `DilettaAlvoDeToque`; a spec declara `sm` 16 e `md` 20 |
| sítios do IB que trocariam | checkbox: 4 (a tabela nova, as notificações, dois formulários); interruptor: 9 em 4 arquivos |

Então o interruptor é paridade quebrada (o Dart tem o piso, a web não), e o checkbox é o piso faltando nos dois lados.

## Já tentei

No IB, a célula da tabela dá o alvo por fora: `44px` de coluna com o checkbox nativo de 18 centrado, e o rótulo da linha no `aria-label`. Funciona para a tabela e para nada mais — num formulário o checkbox fica com os 20 que o elemento desenha, e o interruptor com 24. O alvo é da peça, não de quem a põe na tela; é a mesma frase da `v3.10.0` para o link.

## Conferi no pai

- `DilettaAlvoDeToque` existe desde o pedido do filho A (*«a adoção do DS num filho perdeu em oito sítios»*) e é usado no interruptor Dart, no botão de ícone e no link.
- Na web, o segmentado ganhou o host de 44 na `web-v2.7.0` por pedido deste filho (*«pinta 32 e não tem o alvo de 44 que as irmãs têm»*), e o veredito foi a condição que o avô mediu em 01/10. É o molde: o desenho não muda, o host cresce.

## Derivável?

Sim, por fora, com `min-height`/`padding` no consumidor — e é derivado por cada consumidor com um número diferente, que é o que a regra de 03/09 existe para impedir.

## Se você disser não

O IB continua com o checkbox nativo na tabela e o `BoldToggle` local, e a `v3.13.0` não troca nada aqui. O Cockpit, que pediu as peças, fica com alvos de 20 e 24 nos sete e três sítios dele.

## Não estou pedindo

Mudar o desenho: a caixa de 20 e a trilha de 44×24 ficam. Pedindo o host que cresce por fora, como o segmentado, e o `DilettaAlvoDeToque` no checkbox Dart, como no interruptor.

## Como o pai vai saber que funcionou

`getBoundingClientRect().height` de `[role=checkbox]` e de `[role=switch]` ≥ 44 na web, com a caixa e a trilha nos tamanhos de hoje; no Dart, o gate `o_alvo_de_toque_tem_piso_test.dart` cobre o checkbox.

## VEREDITO · ENTRA, defeito meu — o alvo cresce, o desenho não
**pai**: ds-diletta **v3.16.0** · **data**: 2026-10-15

### O que decidiu
O molde é o que você citou, o segmentado da web-v2.7.0. Na web, o elemento com `role="checkbox"` ou `role="switch"` ganha `min-height` e `min-width` de 44, com o desenho centrado. A caixa de 20 e a trilha de 44×24 ficam como estão. No Dart, o `DilettaCheckbox` ganha o `DilettaAlvoDeToque`. Com rótulo, a linha alinha no início. O gate `o_alvo_de_toque_tem_piso_test.dart` cobre os dois casos.

### O que eu achei indo implementar
A lista de rádio também está abaixo do piso: 32 de linha, igual no Dart e na web.

### O que eu recusei, e a condição de reabrir
- **o piso na rádio**: fica fora deste veredito, porque não há quebra de paridade e ninguém pediu. Reabre com um pedido.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o alvo sai da célula da tela e entra na peça |
| escalabilidade | ↑ | todo filho recebe o piso sem saber |
| aplicação | ↑ | 4 checkboxes e 9 interruptores do IB, e os do Cockpit |
| aderência ao mercado | ↑ | 44 da HIG e WCAG 2.5.5 |
| robustez | ↑ | gate Dart e gate web, com o desenho medido junto |
| arquitetura limpa e simples | = | o mesmo `ALVO` do segmentado |
| conciso | = | uma linha de comentário por peça |

### O que você faz
`ref: v3.16.0`. No IB, apague a coluna de 44 que dava o alvo por fora na tabela. O `.trilho` do interruptor continua sendo o desenho, e o papel `switch` agora mora no `.alvo`.
