/// OS FUNDAMENTOS DO CONTA BOLD — a prosa que ensina, e não o inventário.
///
/// A fronteira é do pai, e ele a escreveu melhor do que eu tinha conseguido: **Foundations são as
/// DECISÕES, que se leem uma vez e ensinam; Styles é o INVENTÁRIO, que se consulta.** A aba de Styles se
/// deriva sozinha dos tokens; esta não se deriva de token nenhum — é texto, e por isso mora aqui.
///
/// A prosa da LINGUAGEM viaja no pacote do pai (`kDilettaLinguagem`), então o catálogo plunga a dele sem
/// copiar uma linha. O que está neste arquivo é só o que é decisão DESTE produto.
library;

/// `título → markdown`. É o formato que `PlugueDoDs.fundamentos` recebe.
const Map<String, String> kBoldFundamentos = {
  'A paleta do Bold': _paleta,
  'Os dois gradientes': _gradientes,
  'O vidro': _vidro,
  'A tipografia substituída': _tipografia,
};

const _paleta = r'''
## A paleta é a única coisa que este filho declara

Os ~51 papéis do scheme são DERIVADOS dela pelo pai. Este produto não escolhe papel, não monta tema
Material e não copia widget — e é isso que faz o modo escuro sair de graça: mesma paleta, rampa
invertida pelo pai.

O rosa `primary04` (`#FE3976`) é a marca. O **vinho** (`#90093A`) é o polo profundo dela, e existe como
token próprio (`BoldVinho`) porque ele não é um degrau do rosa: é outra decisão, usada no fundo e no
tinte do vidro.

## O que a conformidade do pai já cobrou desta paleta

Quatro violações no primeiro dia, e todas eram valor meu, não regra dele:

| token | era | virou | por quê |
|---|---|---|---|
| `success03` | `#1E8F4E` | `#157A45` | a rampa estava INVERTIDA no degrau 03 |
| `primary03` | `#CC1E58` | `#9E1241` | contraste com `onPrimary` abaixo de AA |
| `warning02` | `#8F5A06` | `#85520A` | mesma classe |

A quarta (`onPrimarySubtle` no claro) não tinha conserto do meu lado, e o pai a resolveu na v0.1.6 —
com o meu teste anti-fantasma me obrigando a apagar a baseline no mesmo dia.

**Rampa não é gosto: é a estrutura que faz o papel derivado ter contraste.**
''';

const _gradientes = r'''
## Dois, e o resto é modulado neles

Decisão do dono do produto, e ela cortou oito: o DS antigo tinha dez gradientes e **sete tinham ZERO
uso**. Portar código morto parece progresso.

| gradiente | o que é |
|---|---|
| `primary` | o LOCKUP: rosa → coral → amarelo (`primary04` · `lockupCoral` · `lockupAmarelo`) |
| `accent` | só laranja (`warning03` → `warning02`) |

## A pergunta era a TINTA, e não o gradiente

Por dois meses o `primary` foi um gradiente de duas paradas dentro das rampas, e a razão estava
medida: o amarelo do símbolo dava **1,21:1** contra branco, e rótulo em cima dele desaparecia.

A medição estava certa e continua. O que estava errado era a pergunta. Medindo as DUAS tintas nas
DUAS opções, o lockup ganha:

| tinta | `primary` de três paradas | pior caso |
|---|---|---|
| branco | 3,46 · 2,56 · 1,21 | **1,21** — invisível no amarelo |
| vinho-tinta (`onGradient` hoje) | 5,69 · 7,71 · 16,33 | **5,69** — passa AA de TEXTO |
| o de duas paradas com branco | 3,46 · 3,37 | 3,37 — passa AA-grande, não passa texto |

Então o desenho da marca voltou **e a regra de uso ficou mais larga**: sobre o `primary` cabe rótulo
em qualquer tamanho, não só título e selo. O `accent` é outro caso — as duas paradas dele são âmbar
escuro, a tinta ali é o branco, e a regra antiga vale: glifo e texto grande.

O coral e o amarelo não são degraus de rampa, e por isso moram na PALETA (`BoldColors.lockupCoral`,
`lockupAmarelo`) e não no arquivo de gradiente: cor de marca fora da paleta é cor que um rebrand não
alcança. Esse era o segundo argumento de 30/07, e ele sobreviveu à reabertura.
''';

const _vidro = r'''
## A receita é do FILHO; construir vidro é do pai

O pai sabe COMO se faz vidro — clip, `BackdropFilter`, e a regra de não pôr sombra atrás. Com que
material se faz é decisão do produto, e este declara três valores na paleta:

| token | valor | por quê |
|---|---|---|
| `blurDeVidro` | **15** | o do pai é 10; o material do Bold é mais leitoso |
| `tracoDeVidroClaro` | 1px | sem ele a borda branca desaparecia sobre fundo claro |
| `tracoDeVidroEscuro` | 1px | idem, do outro lado |

O traço nasceu de um defeito medido: a borda a 1.06:1 é invisível, e o gate `traco-de-vidro-visivel`
que veio com o gancho acusa exatamente isso.

## O que eu não consigo provar em teste, e digo

O BLUR não dá pra provar num teste de widget: `toImage` devolveu imagem vazia numa cena e cheia
noutra, e a minha própria asserção de CONTROLE (o salto sem vidro) leu 0/0 e denunciou o teste. O que o
teste prova hoje é que o `blurDeVidro: 15` da paleta CHEGA no `BackdropFilter` do pai — a fiação, não o
pixel.
''';

const _tipografia = r'''
## A escala é linguagem; o filho escolhe a SUBSTITUIÇÃO

O produto antigo tinha 19 presets; o pai tem 23. **Sete são idênticos** em tamanho e peso. Nos outros
doze a regra foi **papel primeiro, métrica depois**: quando o pai tinha a métrica exata no papel errado
(`titleSm` 14/500 contra `labelLg` 14/600), escolhi o PAPEL — porque nome de papel é o que o próximo
dev lê.

## O caso que virou pedido, e fechou com o nome mudando

O preset `mono` do Bold não era monoespaçado: era a fonte da marca com tracking apertado, então não
alinhava coluna. O que eu precisava era **dígito tabular**, e a substituição certa era `numericSm`.

O pai promoveu o NOME, não o estilo: `DilettaType.mono` virou **`DilettaType.clock`**, porque chamar de
`mono` o que não alinha coluna é a mentira mais barata que um vocabulário conta. Família monoespaçada
pra código não é token do pai — é `fontFamily` no tema do app.

A fonte de verdade desta substituição é `test/o_mapa_da_tipografia_test.dart`: ele fixa os 19 degraus
escolhidos e **falha se o pai mover tamanho ou peso** de algum deles.
''';
