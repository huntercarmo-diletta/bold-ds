# Pedido · o card de CONTEÚDO não sabe ser vidro, e neste produto ele é vidro em 96 sítios

- **filho**: conta-bold-ds v0.7.2
- **pai**: ds-diletta v0.26.0 (`DilettaAppList`, `DilettaGlassSurface`, `DilettaScheme`)
- **é bloqueante?**: **não** pro app, que segue com o card dele. É bloqueante pro **catálogo**: o board
  mostra card sólido onde o aparelho mostra vidro, e board que mostra outro material está mentindo sobre o
  produto

## O que falta

`DilettaAppList` na variante `carded` desenha o card assim:

```dart
Container(
  decoration: BoxDecoration(
    color: s.surface,                                  // ← sólido, cravado
    border: Border.all(color: s.divider, width: 1),
    borderRadius: DilettaRadius.all24,
  ),
  ...
)
```

Não há como pedir que essa superfície seja **vidro**. E vidro não é enfeite neste produto: o fundo da home
é o mood de IMAGEM (a cidade), e card sólido em cima da arte apaga a arte. A regra está escrita no DS do
app desde antes de eu existir — *"fills deixam a foto de fundo passar"*.

## A medição

**No app** (`app-newbold`, hoje):

| peça | material | sítios |
|---|---|---|
| `BoldAppListGroup` (o card de lista) | **vidro** | **96** |
| `glass: true` escrito em tela | vidro | 20 |
| componentes do DS do app que são card de vidro | vidro | **6** (lista, app list, cartão de atalho, aviso, comprovante, estado vazio) |

**No seu lado:**

| medida | número |
|---|---|
| arquivos de `lib/src/widgets` que cravam `color: s.surface` | **25** |
| arquivos que usam `DilettaGlassSurface` | **4** |
| e os 4 são todos CHROME | barra de topo, barra de baixo, folha de senha, e o próprio primitivo |

Ou seja: **a construção do vidro já é sua, e o vocabulário só a oferece pra chrome.** Card de conteúdo —
lista, aviso, comprovante, estado vazio, cartão de atalho — é sólido por construção.

## Onde isso aparece, e por que eu não descobri lendo

Descobri porque o dono do produto olhou a aba Telas e disse: *"o fundo nos cards (lista) também é glassy e
eles estão solid"*. As duas telas de comprovante e a home do board usam `lista` com `idioma: 'carded'`, que
é o seu `DilettaAppList` carded — e elas assentam sobre o `fundoDoFrame` deste produto, que é a cidade.

O defeito é o mesmo que o `fundoDoFrame` consertou no ano passado, um nível abaixo: **o catálogo mostrava um
material que o aparelho não mostra assim.** Lá era o fundo da tela; aqui é o fundo do card.

## Por que eu não resolvo sozinho

Três caminhos, e os três dão errado deste lado:

1. **declarar um card meu no filho** — é cópia de componente do pai, que é a coisa que esta família não
   faz. E cópia de container arrasta os 96 sítios do app pro nome novo por nada;
2. **envolver o seu card num `DilettaGlassSurface` dentro do bloco do catálogo** — o board passaria a
   desenhar vidro que o `DilettaAppList` não desenha. Trocaria uma mentira por outra, e a segunda é pior
   porque é minha;
3. **pintar por cima com cor translúcida** — vidro não é cor com alpha: é `BackdropFilter`. Sobre cor lisa
   não desfoca nada, e é exatamente o achado que fez o `fundoDoFrame` nascer.

## O que eu peço — LEITURA antes de código, e três respostas que eu aceito

**1 · O material do card vira DECLARAÇÃO do filho, no scheme.** É a forma que eu preferiria, e não é
desenho novo: é o mesmo padrão do `tinteDeVidro`, do `blurDeVidro` e do `tracoDeVidro` que já existem —
*"a receita é do filho, a construção é do pai"*. Uma declaração (`superficieDeCard: vidro | solida`), zero
mudança em 96 sítios, e o `DilettaAppList` continua sendo o único que sabe montar a lista.

**2 · Ou um parâmetro por componente** (`DilettaAppList.carded(material:)`). Mais explícito, e mais caro: o
knob se repete em cada componente de card e em cada ponto de uso, e é a classe de campo que o seu ledger
já chamou de "forma cravada" no pedido dos 53 raios.

**3 · Ou fica sólido, e eu quero isso escrito.** Se a resposta for que card de conteúdo é sólido na
linguagem e vidro é privilégio de chrome, então **eu paro de pedir e o board passa a mostrar sólido com uma
nota dizendo que o aparelho mostra vidro** — divergência declarada é melhor que divergência silenciosa. Mas
aí eu preciso da frase, porque hoje a ausência não distingue "é sólido por decisão" de "ninguém precisou
ainda".

## O que eu já fiz do meu lado

- o `saldo` deste produto (o card da home) **já é vidro** e é componente do filho: ele usa o seu
  `DilettaGlassSurface` direto, e é a prova de que o primitivo serve pra card de conteúdo sem mudança
  nenhuma na construção;
- a divergência está **escrita no registro de decisões** das telas
  (`packages/catalog/lib/telas_do_bold.dart`), com o número dos dois lados — não nos `notes` da spec, que
  hoje são arquivo gerado e eu não edito à mão.

**Um número que talvez interesse além de mim.** Dos 6 cards de vidro do app, **4 têm equivalente seu que
crava um papel sólido**: `DilettaAppList` carded (`surface`), `DilettaQuickAccessCard` (`surface`),
`DilettaEmptyState` (`surface`) e `DilettaReceipt` (`bg`). O quinto, `DilettaNoticeBanner`, monta em
`DilettaBox(color:)` — então a COR dele é declarável por chamada e o material ainda não é, que é a mesma
falta com uma porta a mais. Se a resposta for a 1, os quatro ganham de graça sem tocar em nenhum construtor
— e é esse "de graça" que me faz apostar no scheme em vez do parâmetro.
