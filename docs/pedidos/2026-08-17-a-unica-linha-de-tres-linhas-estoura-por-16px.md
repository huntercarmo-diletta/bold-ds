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

---

## Veredito · DEFEITO MEU, e nem a saída 1 nem a saída 2 — a altura sai das LINHAS DECLARADAS

**pai**: `ds-diletta` **v0.110.0** · **data**: 2026-08-17

```dart
DilettaMiddleSize _sizeHint() => label == null ? DilettaMiddleSize.sm : DilettaMiddleSize.md;
```

Uma linha. E as duas saídas que você ofereceu estavam as duas erradas por meio grau cada.

### A aritmética fecha, e é o que faz isto ser defeito e não pedido

`subheading` 20 + `caption` 16 + `labelSm` 16 = **52** contra os 36 declarados. **16px**, o seu número,
sem depender de conteúdo nenhum. O acessório **declarava `sm` e pintava o título em `md`** — a linha 745
passa `DilettaMiddleSize.md` pro estilo do título e a 737 devolvia `sm` pra altura. Duas afirmações
sobre a mesma variante, discordando dentro da mesma classe.

Você tem razão no que escreveu como o ponto mais difícil de defender: o `///` da classe-mãe já avisava
da classe do defeito, e o caso escrito lá era **conteúdo** longo. Aqui o número de linhas é declarado
pelo próprio acessório, então não havia nem o consolo de *"o chamador pediu isso"*.

### Por que não a sua saída 1 (`md` fixo)

Porque **com o `label` nulo a conta dá 36 exatos** (20 + 16), e você mediu isso — *"com o `label` nulo
passa limpo"*. `md` fixo levaria toda linha de duas linhas de 36 pra 72: mexer na altura de quem já
funcionava, do jeito que a v0.48.0 já cobrou aqui uma vez (2px moveram tela de um filho que não pediu).

### Por que não a sua saída 2 (altura elástica)

Porque o mecanismo já existe e **não é o certo pra este caso**: `_cresce` faz a altura virar PISO e
acrescenta respiro `s3`, e ele nasceu pra quando o CHAMADOR abre `maxLines` — conteúdo que não se sabe.
Aqui o número de linhas é conhecido na construção, então piso elástico entregaria uma altura que varia
sem ninguém precisar disso, e com um respiro que as outras linhas de 72 não têm.

**A sua própria exclusão nº1 dizia o certo** — *"o que peço é que a altura acompanhe o número de linhas
que o ACESSÓRIO declara, que é conhecido em tempo de construção"* —, e ela contradiz a sua saída 2. Eu
implementei a exclusão, não a saída.

### O que eu achei e você não podia ver

**O defeito estava na vitrine do PRIMEIRO filho.** O catálogo dele pinta
`titleBodyLabel(title:, body:, label:)` — os três campos — na tabela que documenta o acessório, rotulada
`titleBodyLabel() · sm`. Ou seja: a variante estourava na página que existe pra ensinar a usá-la, e
ninguém viu, porque estouro de layout na web em release não pinta a tarja.

Isso responde a régua do segundo filho sem eu ter que perguntar: **dois sítios independentes, e um deles
é documentação.**

### O `titleSubtitleSubtitle` fica como está, e a sua razão entrou no teste

Sua exclusão nº2 mantida: o bullet serve dois dados curtos. Medi o seu caso e ele confirma — o par
documento + contato divide UMA linha com `maxLines: 1`. **O defeito ali é de informação, não de
layout**, e por isso a peça não muda: quem escolhe entre empilhar e juntar é quem sabe o que os dois
dados são.

### O que você faz

`ref: v0.110.0`, e o `_IdentityCard` sai do `operador_detalhe_screen.dart`. O gate que você propôs é o
que subiu: a row com as três linhas num frame de 393, sem exceção, mais o par de duas linhas cravado em
**36** — porque a metade do conserto que ninguém pediria de volta é a que não se move.
