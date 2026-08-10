# Pedido · o trilho da barra é CLARO nos dois temas — e no escuro isso deixa o aviso em 1,04

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.32.0 · pai v0.63.0
- **data**: 2026-08-10

## O que falta

Que o trilho da `DilettaProgressBar` seja **papel** e não degrau fixo. Hoje ele é
`s.palette.neutral07` nos dois temas; deveria ser um papel de superfície que vira com o modo, como
`surfaceMuted` já faz.

## Este pedido é a sua deixa, e eu medi o que faltava

No veredito do `tone`, ontem, você fechou com o número e a instrução: *"nenhum alcança o 3:1 de
elemento gráfico, e o default já era assim antes do `tone` — a causa é o trilho. Se o `warning` não ler
na sua tela, o número acima é o argumento pronto pro pedido do trilho."*

Medi. **Na minha paleta é pior do que na sua**, e a diferença não é pequena:

| tom | claro (04) | escuro (05) | | sua referência, claro | sua referência, escuro |
|---|---|---|---|---|---|
| `normal` | 2,03 | 1,60 | | 2,68 | 1,66 |
| `warning` | **1,22** | **1,04** | | 1,82 | 1,17 |
| `error` | 2,15 | 1,90 | | 3,40 | 2,21 |

**`warning` no escuro dá 1,04.** O piso de objeto gráfico é 3:1 (WCAG 1.4.11); 1,04 não é "abaixo do
piso", é **a mesma luminância** — a barra existe e não se vê. E o modo escuro é o default deste app.

## A causa medida: o trilho é CLARO, e num tema escuro isso inverte o problema

`BoldColors.neutral07` é `#C6C6C6` — cinza claro. Ele funciona como trilho no tema claro (é mais escuro
que o fundo) e **falha no escuro por dois motivos ao mesmo tempo**: fica claro sobre superfície escura
(chama mais atenção que o preenchimento) e encosta na luminância das tintas semânticas, que também
clareiam no escuro.

O teste é a inversão. Trocando só o trilho, com a mesma tinta:

| trilho | `warning04` | `warning05` |
|---|---|---|
| `#C6C6C6` (hoje) | 1,22 | 1,04 |
| `#E5E5E5` (mais claro) | 1,65 | 1,42 |
| `#333333` | **6,08** | **7,08** |
| `#1A1A1A` | **8,37** | **9,76** |

**Não é a tinta que precisa mudar: é o lado do trilho.** Clarear não resolve (1,65); escurecer resolve
com folga de 2× o piso. E isso é exatamente o que um papel de superfície faz sozinho — vira com o modo.

## Onde eu ACHO que mora

No papel, não no degrau:

```dart
// hoje
color: isBanner ? whiteAlpha24 : s.palette.neutral07,
// pedido
color: isBanner ? whiteAlpha24 : s.surfaceMuted,   // ou o papel que você julgar
```

Três coisas que eu **não** estou pedindo, com a razão:

1. **trocar a tinta dos tons.** Os três degraus estão certos onde estão: eles são as cores semânticas
   desta marca e aparecem em toast, tag e spot. O defeito não é neles;
2. **um trilho por tom.** Seria três decisões onde falta uma;
3. **um parâmetro `trackColor`.** Trilho por consumidor é como um degrau vira seis: quem passa cor
   escolhe contraste, e contraste não é escolha de tela.

## O que eu já sei que isto NÃO resolve

**Cor sozinha continua não sendo informação** (WCAG 1.4.1), e você já me cobrou isso: os dois medidores
deste app passaram a dizer `perto do teto` e `teto consumido` por escrito, na v0.32.0. O trilho conserta
a **percepção da barra**; o texto é que carrega o aviso. Os dois são necessários, e o texto já entrou.

## Como o pai vai saber que funcionou

`warning` contra o trilho passa de **1,04 para ≥3:1 no escuro** na minha paleta, e o número sai do
mesmo cálculo que está aqui. E a mudança move **toda barra que já existe** — é por isso que ela é sua e
não minha: eu tenho 2 sítios, você tem o `.banner`, o `.activity` e o `.value` em dois filhos.
