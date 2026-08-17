# Pedido · a sua única row de TRÊS linhas estoura por 16px, e a alternativa trunca

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.46.0 · pai v0.108.0
- **data**: 2026-08-17

## O que falta

Uma row de lista que aceite **três linhas empilhadas** sem estourar. Duas saídas servem, e a
segunda é a barata:

1. `DilettaMiddleAccessory.titleBodyLabel` declarar `DilettaMiddleSize.md` em vez de `sm`; ou
2. a altura da row deixar de ser fixa quando o acessório do meio tem três linhas.

## Já tentei — e o defeito é reproduzível em quatro linhas

Cabeçalho de identidade do operador: avatar, nome, CPF, e-mail, tag de status. É `DilettaAppListRow`
inteiro, com acessório dos três lados. Os dois caminhos de três linhas reprovaram:

**`titleBodyLabel` estoura.** É o único acessório do meio que empilha três (`title` + `body` +
`label`), e ele declara `_sizeHint() => DilettaMiddleSize.sm`. A row fixa a altura pelo hint —
`double get _height => DilettaMiddleSize.md == _sizeHint() ? 72 : 36`. Três linhas não cabem em 36:

```
A RenderFlex overflowed by 16 pixels on the bottom.
  creator: Column ← SizedBox ← Expanded ← _MiddleTitleBodyLabel ← Row ← ...
```

Medido nos dois temas, num frame de 393. **Com o `label` nulo passa limpo** — ou seja, o estouro é
exatamente a linha que dá nome ao acessório.

**`titleSubtitleSubtitle` trunca.** Ele não empilha: junta `subtitle` e `accessorySubtitle` na mesma
linha com bullet (`bulletParts.join(' • ')`, `maxLines: 1`). Com dado real — CPF `390.***.***-05` e
`maria.silva.santos@empresa.com.br` — o e-mail some no reticências antes do arroba. O bullet serve
dois dados CURTOS; não serve um par documento + contato.

## Conferi no pai

- `_height` é `72` pra `md` e `36` pra `sm`, e o hint é do acessório, não do consumidor;
- `titleBodyLabel` não expõe `size` — `titleSubtitleSubtitle` e `titleSubtitle` expõem. Então nem
  como escotilha eu consigo pedir `md` pra ele;
- o `///` do próprio arquivo já avisa da classe do problema, uma linha acima:
  *"a row fixa altura (`SizedBox(height: 72)`), então texto de 10 linhas dentro dela estoura em vez
  de crescer"*. O caso escrito é o texto longo; este é o mesmo defeito com **o número de linhas
  declarado pelo próprio acessório**, o que é mais difícil de defender: ele não depende do conteúdo
  que o consumidor passa;
- as 9 variantes do meio estão documentadas no `enum`, e a de três linhas é a única sem `size`.

## Derivável?

Não. A altura é decidida dentro da row, o hint é do acessório e nenhum dos dois é parâmetro. Do lado
do filho eu só tenho duas saídas, e as duas são piores: envelopar a row com `IntrinsicHeight` (que
não desfaz um `SizedBox` de dentro) ou voltar a montar a linha à mão — que é exatamente o que este
cabeçalho faz hoje, e é a razão de eu estar escrevendo.

## Se você disser não

O `_IdentityCard` deste app continua composto à mão, com a razão escrita no `///` da classe. Custo
medido: **2 telas de identidade, 2 grafias de tipo pro mesmo papel** (`titleMd` w600 numa, `title`
noutra) — a divergência que a peça existe pra fechar.

## Não estou pedindo

1. **altura elástica em toda row.** O `SizedBox` protege a lista de item que cresce com o conteúdo,
   e isso está certo. O que peço é que a altura acompanhe o número de linhas que o ACESSÓRIO
   declara, que é conhecido em tempo de construção;
2. **mudar o bullet do `titleSubtitleSubtitle`.** Ele serve dois dados curtos e tem uso; só não
   serve este;
3. **acessório novo.** Não tenho caso pra uma quarta linha, e três já existem em duas formas.

## Como o pai vai saber que funcionou

O `_IdentityCard` sai do `operador_detalhe_screen.dart` e vira `DilettaAppListRow` com
`titleBodyLabel`. O gate é o próprio teste: a row com as três linhas renderiza sem
`RenderFlex overflowed` num frame de 393.
