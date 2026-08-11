# Pedido · a família de chips não tem o SELECIONÁVEL, e o `filled` não é ele

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.36.0 · pai v0.66.1
- **data**: 2026-08-11

## O que falta

Uma variante `selecionavel` na família de chips: numa fila onde **exatamente um** está escolhido, o
escolhido INVERTE.

## Por que o `filled` do `DilettaInputChip` não serve

| estado | `DilettaInputChip` | o que este produto faz |
|---|---|---|
| não escolhido | `surface` + borda | transparente + borda neutra + tinta forte |
| escolhido | `primarySubtle` + label `primary` | **`primary` cheio + `onPrimary`** |

Os dois são chips e os papéis são opostos. O teu marca *este filtro está aplicado* numa fila de
filtros aplicados — vários podem estar, e nenhum precisa gritar. O meu marca *A escolha* numa fila
de opções mutuamente exclusivas, e a leitura tem que ser instantânea.

**O `filled` fica no mesmo tom nos dois estados**; o selecionável troca fundo e tinta de lugar. Numa
fila de três, a diferença entre "tom mais claro" e "inversão" é a diferença entre procurar e ver.

## Uma coisa que eu acrescentei e que acho que é da regra, não minha

O peso do rótulo vai de **400 a 600** junto com a cor. Não é enfeite: `bodySm` em `primary` sobre
`bg` e `bodySm` em `onPrimary` sobre `primary` são dois pares que passam AA, e mesmo assim **cor
sozinha não é informação** (1.4.1). O peso é o segundo canal.

Se isso entrar como regra da variante, ele deixa de depender de cada filho lembrar.

## O alvo de toque, que é o outro motivo de a peça existir

A pílula tem ~26 de altura e o alvo tem **44** (WCAG 2.5.5), com o respiro **fora** do desenho. É
fácil de errar na direção contrária — pôr o respiro dentro engorda a pílula e não muda o alvo —, e é
o tipo de coisa que uma variante da linguagem resolve uma vez.

## O que eu NÃO estou pedindo

1. **trocar o `filled`.** Ele está certo no papel dele, e os dois papéis convivem na mesma tela;
2. **cor configurável.** Escolhido é `primary`, e isso não é decisão de tela;
3. **seleção múltipla.** Fila com vários marcados é o `filled`, que já existe.

## Como o pai vai saber que funcionou

O `BoldChipDeFiltro` deste filho vira casca de uma linha, e os seis sítios do app passam a falar a
variante da linguagem.
