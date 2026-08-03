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

---

## Veredito · ENTRA pela sua resposta 1, e a medição que decidiu é a sua
**pai**: `ds-diletta` v0.32.0 · **data**: 2026-08-03 · **critério que pesou**: aplicação

```dart
DilettaPalette(… cardDeVidro: true)   // e os cards do vocabulário trocam de material
```

Você pediu leitura antes de código e ofereceu três saídas. É a **1**, e o argumento que fecha é o seu:

> *"é o mesmo padrão do `tinteDeVidro`, do `blurDeVidro` e do `tracoDeVidro` que já existem — a receita é do
> filho, a construção é do pai."*

E a medição que decide entre a 1 e a 2 também é sua: **dos 4 arquivos que usavam `DilettaGlassSurface`, os 4
eram CHROME.** A construção do vidro já era minha; o vocabulário só a oferecia pra barra. Isso não é falta de
parâmetro, é uma **fronteira desenhada errado** — e knob por componente teria espalhado a mesma falta em
quatro assinaturas, que é a forma cravada que este repo recusou nos 53 raios.

Os três caminhos que você descartou estavam descartados pelo motivo certo, e o terceiro é o que mais importa:
**vidro é `BackdropFilter`, não cor com alpha.** É o mesmo achado que fez o `fundoDoFrame` nascer, e é por
isso que a saída 3 (pintar translúcido) não era uma saída.

### A peça, e a regra que ela carrega

`DilettaCardSurface` monta sólido (cor + borda por papel) ou vidro. No vidro o radius vai **pro primitivo** e
a borda sólida **não entra**: o clip precisa ser pai direto do `BackdropFilter` (senão o blur vaza pra tela
toda) e o traço é o `glassStroke` declarado, por `foregroundDecoration`. As duas regras já estavam escritas no
`///` do primitivo, e são exatamente o que uma segunda montagem à mão perderia — foi o que aconteceu com o
traço de home, no seu outro pedido de hoje.

### Uma correção na sua contagem: são TRÊS, não quatro

`DilettaReceipt` **não tem card**. Ele é uma `Column`, e as duas ocorrências de `s.bg` que você viu são o spot
de status (círculo 34) e a caixa do rodapé — quem o coloca em superfície é quem monta a tela. Convertidos:
`AppList.carded`, `EmptyState` e `QuickAccessCard`.

`DilettaNoticeBanner` ficou fora com razão declarada, e não por esquecimento: **a cor dele é escolhida por
chamada**, e vidro descartaria a escolha em silêncio. Card cuja cor o chamador pinta é outro caso, e ele ainda
não tem medição.

### O seu pedido achou um terceiro defeito meu, pelo gate que ele produziu

O gate novo (`quem monta vidro à mão é só CHROME`) apontou dois arquivos que montam `BackdropFilter` no corpo
— e os dois **cravavam `sigma: 10`**:

> Um produto que declarasse `blurDeVidro: 20` ganhava 20 em todo vidro **menos** na nav e no toast.

Montar à mão é exceção declarada (o toast tinge por ESTADO, a nav empilha o círculo ativo fora do clip);
**ignorar a declaração do filho não é.** Os dois passaram a usar `s.glassBlur`, e a lista de exceção mora no
teste com o motivo de cada uma, em vez de escondida no código.

### O que você faz

1. `cardDeVidro: true` na paleta do Bold — uma linha, e os três cards trocam de material. **Zero mudança nos
   96 sítios**, que era o ponto;
2. confira no board: as duas telas de comprovante e a home passam a mostrar o card sobre a cidade como o
   aparelho mostra;
3. o `saldo` continua como está — ele já usava o primitivo direto, e é a prova que você citou de que a
   construção servia pra conteúdo sem mudança nenhuma.

Chega pela tag **v0.32.0**. E a divergência que você escreveu no registro de decisões pode sair: ela deixou de
existir.
