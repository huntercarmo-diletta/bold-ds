# PEDIDO · A aba da web quebra o rótulo em linhas e corta, e a fileira não rola — o Dart segura o rótulo numa linha

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` · `web-v3.24.0`, na `main` deste repo (tags até `web-v0.128.0`); o Internet Banking `core-flow-ib` prende `web-v0.126.0` (avô `web-v3.24.0`). Conferido também na `web-v3.25.0`: o CSS da aba é o mesmo
- **bloqueante?**: não. O IB contornou: onde as abas não cabem, um botão de menu com o estado da vez faz o papel delas (abaixo). O que fica errado é a peça: um segundo controle para a mesma escolha, e as abas sumindo justamente na largura do notebook
- **irmão**: `2026-08-13-as-abas-do-pai-abracam-o-rotulo-e-as-minhas-repartem-a-largura.md` — lá a escolha foi abraçar o rótulo (`larguraIgual` não atravessou para a web). Este pedido é sobre o que acontece quando o que abraça não cabe

## Falta

1. **Paridade com o Dart: o rótulo da aba numa linha só, e a aba sem encolher.** No Dart o rótulo é
   `DilettaText(rotulo, maxLines: 1, softWrap: false)` (`diletta_tabs.dart:238-243`, `v3.25.0`) e a fileira é
   uma `Row` de tamanho mínimo: o rótulo nunca quebra. Na web, `.trilho { display: flex }` e `.aba` sem
   `white-space: nowrap` nem `flex-shrink: 0` (`diletta-tabs.js:169-185`): num hospedeiro estreito o flex
   encolhe os botões até a palavra mais longa, o rótulo quebra em duas ou três linhas e a fita de `48px` o corta.
2. **A fileira que rola**, como o `isScrollable` das abas do Material: `overflow-x: auto` no `.trilho`, com a
   aba selecionada trazida à vista ao selecionar e na primeira pintura. O item 1 sozinho já destrava quem
   consome (dá para pôr o hospedeiro num contêiner que rola, por fora do shadow); o item 2 é a peça fazer isso
   sozinha, sem que cada filho escreva o contêiner.

## Número

**No IB (`core-flow-ib`, T4.1 da Fase 4, «Pagamentos por estado», 28/10):** sete abas que filtram a lista —
«Todos», «Sem a sua assinatura · 3», «Aguardando outros · 1», «Agendados · 4», «Pagos», «Falharam · 1» e
«Cancelados». Os nomes e os números são decisão de produto. Medido no Chrome, com o pacote de e2e:

| tela | largura do hospedeiro | maior `scrollHeight` de uma aba (fita de 48) | o que se vê |
|---|---|---|---|
| 1440 (com o menu lateral) | 1128 | 46 | as sete numa linha, inteiras |
| 1280 (com o menu lateral) | 968 | 46 | cabem, por 27 px |
| 1100 (com o menu lateral) | 788 | 46 | duas linhas, apertadas |
| 1024 (com o menu lateral) | 712 | **60** | três linhas, cortadas |
| 768 | 720 | **60** | três linhas, cortadas |
| 640 | 592 | **60** | três linhas, cortadas |
| 390 | 342 | **60** | três linhas, e a fileira transborda: `scrollWidth` 699 no hospedeiro, a página rola 333 px de lado |

A largura natural das sete, cada uma com `nowrap` e sem encolher: **941 px**. A 390 px, as abas ficam com 72 a
120 px cada e, mesmo encolhidas, somam 699 px — o `min-content` das palavras —, que passam do hospedeiro sem
rolar e empurram a página.

## Já tentei

- **Pôr o hospedeiro num contêiner com `overflow-x: auto`.** A página para de rolar, mas os rótulos continuam
  quebrados e cortados dentro da fita: o flex ainda encolhe as abas, e o `nowrap` mora no shadow, onde o
  filho não alcança.
- **Rótulos mais curtos.** «Sem a sua assinatura» é o nome decidido (a fila não diz se a pessoa pode
  assinar), e os números são o que a pessoa procura.
- **O que está no ar** (`src/features/pagar/ui/PagamentosScreen.tsx` e `pagamentos.module.css`, PR da T4.1):
  uma consulta de contêiner troca as abas, abaixo de `62rem` de área, por um `BoldMenu` em forma de botão
  («Todos ▾») com os sete estados. Funciona, mas é um segundo controle para a mesma escolha, que não diz
  qual está selecionada como a aba diz, e que vale até em notebook de 1280 com o menu lateral aberto.

## Conferi no pai

- `diletta-tabs.js` da `web-v3.24.0` e da `web-v3.25.0`: `.trilho { display: flex; }` e `.aba` com
  `height: 48px; min-height: 44px; padding: 0 12px`, sem `white-space` nem `flex-shrink`.
- A régua de paridade do próprio elemento lista `larguraIgual` («não atravessa hoje») e não diz nada do
  rótulo em uma linha: a diferença não está declarada, e a regra da casa é que diferença sem razão é defeito.
- `diletta_tabs.dart` (`v3.25.0`): `maxLines: 1`, `softWrap: false`, reticências só quando `reparte`. A
  `Row` também não rola: no Dart quem chama envolve num `SingleChildScrollView` — na web, sem o item 1, esse
  envelope não salva o rótulo.
- O elemento não expõe `part` na aba: quem consome não tem como escrever o `nowrap`.

## Derivável?

Não: o rótulo e a fileira moram no shadow, e não há `part` nem variável CSS para o quebra-linha. O filho só
consegue trocar a peça por outra, que é o que o IB fez.

## Se você disser não

O IB segue com o menu dos estados abaixo de `62rem` de área e as abas acima; a T4 continua com sete estados.

## Não estou pedindo

- `larguraIgual` na web, nem reticências no modo que abraça: cortar «Sem a sua assinatura» esconde o estado.
- Outra altura de fita, ou outra tipografia.
- Um modo «menu» dentro da peça: com o item 1, quem consome escolhe rolar por fora; com o item 2, nem isso.

## O que não medi

O leitor de tela com a fileira rolada (o foco que segue a seleção deveria trazer a aba à vista, e é a mesma
regra do item 2); o modo navegação (`destinos`), onde a aba é `<a>` — a mesma regra deveria valer.

## Como o pai vai saber que funcionou

`<diletta-tabs abas="Todos|Sem a sua assinatura · 3|Aguardando outros · 1|Agendados · 4|Pagos|Falharam · 1|Cancelados" selecionada="5" rotulo="Estados">`
num contêiner de 342 px:

- **item 1:** toda `.aba` com `scrollHeight <= clientHeight` (uma linha, inteira na fita de 48), e a soma das
  larguras igual à natural (941 px no Inter do Bold);
- **item 2:** `documentElement.scrollWidth === clientWidth` (a página não rola de lado), o `.trilho` com
  `scrollWidth > clientWidth` e rolável, e «Falharam · 1», a selecionada, inteira à vista na primeira pintura e
  depois de cada seta.

A 1440 px nada muda.
