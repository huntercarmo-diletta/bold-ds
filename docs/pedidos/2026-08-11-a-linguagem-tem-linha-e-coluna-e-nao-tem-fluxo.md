# Pedido · a linguagem tem LINHA e COLUNA e não tem FLUXO — e o menu do Pix é fluxo

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.36.0 · pai v0.66.1
- **data**: 2026-08-11

## O que falta

Um container de **fluxo** no `DilettaFrame`: itens que ocupam a linha e quebram pra próxima quando
não cabem. Hoje o frame tem `.column`, `.row` e `.stack`.

## Onde ele aparece, com número

Três sítios neste produto, e nenhum é o mesmo desenho:

| tela | forma | por que não é `.row` nem `.column` |
|---|---|---|
| Área Pix · menu | 6 ladrilhos de **85 fixos** | 6 × 85 + vãos = 510 num frame de 393 — `.row` estoura |
| extrato · filtros | 3 chips de largura própria | cabem hoje; com "Agendados" e "Pix" não cabem |
| autorizações · filtros | 3 chips | idem |

O caso do Pix é o que fecha o argumento: **os itens têm largura própria E são mais largos que a
linha juntos.** `.row` estoura. Uma coluna de `.row`s com `Expanded` funciona — foi o que eu fiz
primeiro — mas ela ESTICA cada ladrilho pra um terço da tela, e o que o produto desenha é um
quadrado de 85 com espaço sobrando à direita. Não é o mesmo desenho, é outro.

## O que eu fiz enquanto isso, e por que está escrito

O bloco `grade` do meu catálogo tem quatro formas: `fileira` (`DilettaFrame.row`), `2`, `3`
(coluna de `Row`s com `Expanded`) e **`fluida`** — que emite

```dart
ds.DilettaFrame.column(children: [Wrap(spacing: …, runSpacing: …, children: […])])
```

O `Wrap` é do Flutter. É a mesma exceção declarada que o teu divisor vertical já tem (`SizedBox`
pra dar o eixo), e ela está escrita no lugar em que é cometida — não escondida.

Mas ela tem um custo que a do divisor não tem: **o meu gate de vocabulário cobra que todo bloco
emita componente do DS**, e este passa por um detalhe de sintaxe (a expressão começa com `ds.`).
Um gate que passa pelo prefixo e não pela substância é um gate que vai deixar o próximo passar
também.

## Onde eu ACHO que mora

`DilettaFrame.flow(gap:, runGap:, children:)`, com a mesma gramática das outras três. O `runGap`
separado do `gap` porque vão horizontal e vão entre linhas são decisões diferentes — nos meus três
sítios eles calham de ser iguais, e isso não é amostra.

## O que eu NÃO estou pedindo

1. **grade com colunas.** Isso é layout de tela e eu já resolvo com `.column` de `.row`s;
2. **alinhamento configurável.** Os três sítios alinham à esquerda; quando eu tiver um que não
   alinha, ele vem com número;
3. **quebra por breakpoint.** Fluxo quebra por CABER, e caber já é a regra.

## Como o pai vai saber que funcionou

O `Wrap` sai do meu `ds_do_bold.dart` e o bloco `grade` volta a emitir só componente do DS — sem a
exceção escrita e sem o gate passando pelo prefixo.
