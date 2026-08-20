# PEDIDO · o espelho do claro veio em duas partes, e a terceira é a SUPERFÍCIE

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.115.0 · catalogo-diletta v0.108.0 · DS filho v0.55.0
- **bloqueante?**: não pro Bold. **Bloqueante pro NETO** — e é essa a diferença que este pedido carrega.

## Falta

Os campos de override das superfícies do CLARO na paleta: **`bgClaro`** e **`surfaceMutedClara`**.

## Número

**2 de 42.** Eu acabei de parametrizar o meu esquema pela paleta — ele recebe `DilettaPalette` em vez
de cravar a minha — e montei um NETO de teste com a sua `DilettaPalette.referencia`. Resultado
medido, e está num gate (`o_neto_troca_a_paleta_e_pronto`):

| | |
|---|---|
| papéis que acompanham a paleta do neto | **32** |
| iguais por REGRA (alpha sobre branco/preto absoluto — a resposta certa é a mesma) | 7 |
| iguais por CONSEQUÊNCIA de um preso | 1 |
| **presos por dívida** | **2** — `background` e `field`, só no claro |

Os dois valores: página `#F4F3F6` e campo `#F1F0F4`. A sua derivação do claro dá **branco puro** pro
`bg` e `neutral09` pro `surfaceMuted`.

## Já tentei

**1 · `papeisExtras`.** Foi a primeira coisa que eu fui fazer, e ela mentiria. O `///` do
`DilettaPapelExtra` é explícito: extra é vocabulário que você não tem (*"ele não sabe o que é
`acentoLaranja`"*). `background` e `field` são vocabulário SEU — `bg` e `surfaceMuted`. Declarar como
extra criaria dois papéis com o mesmo significado, que é exatamente a duplicata que eu passei o dia
matando (o vidro declarado duas vezes, o `onGradient` branco em dois lugares).

**2 · Derivar da rampa neutra.** `neutral10` (`#F6F6F6`) está a 2 unidades de canal do meu valor. Não
serve, e a razão não é o pixel: **a sua derivação do claro é branco puro, e a minha página não é
branca de propósito.** O card deste produto é branco, e a página tingida é o que faz ele ler como
ELEVADO — 1,105 de contraste entre os dois. Com a página branca, card branco sobre fundo branco só
existe pela borda, e aí a elevação vira traço em vez de superfície.

**3 · Deixar como está.** É o que está no ar agora: os dois moram como constante nomeada na minha
paleta (`BoldColors.fundoClaroDaPagina`, `BoldColors.campoClaro`), com o motivo escrito e um gate
contando. **Funciona pro Bold e não funciona pro neto** — e é só por isso que eu estou pedindo.

## Conferi no pai

Este é o **terceiro pedaço do mesmo espelho**, e os dois primeiros são seus:

1. `bgEscuro`, `surfaceEscura`, `surfaceMutedEscura` entraram na **v0.1.9**, por pedido de filho. As
   superfícies do escuro deixaram de ser cravadas por você e passaram a ser declaráveis;
2. `textoClaro`, `textoSecundarioClaro`, `textoMudoClaro`, `bordaClara` entraram na **v0.111.0**, por
   pedido meu de 17/08 — o espelho do claro pro TEXTO e pra BORDA.

Falta a superfície do claro. E eu conferi a assimetria antes de chamar de assimetria: o escuro tem
override de superfície e não tinha de texto até a v0.109.0; o claro tem override de texto desde a
v0.111.0 e não tem de superfície. **Cada metade da matriz foi preenchida por um pedido diferente, e
esta é a última célula vazia.**

## Derivável?

Não, e é o oposto de derivável: a sua derivação do claro está CERTA pra quem não declara — branco puro
é a resposta neutra. O que falta é o lugar de dizer outra coisa. Mesmo formato dos quatro que você
acabou de abrir: campo opcional, nulo cai na derivação, quem declara assume.

## Se você disser não

Os dois ficam como estão e o gate continua contando 2. O preço não é meu: **um neto deste DS herda a
página e o campo do Bold no modo claro**, e não tem onde declarar os dele — teria que editar o meu
esquema, que é a coisa que eu acabei de tornar desnecessária pros outros 32 papéis.

E fica escrito que a resposta pra *"trocar os tokens troca o app?"* é **42 de 44** por escolha sua, e
não por limite da arquitetura. Isso é uma resposta aceitável; ela só não pode ser silenciosa.

## Não estou pedindo

1. **mudar a sua derivação do claro** — branco puro serve quem não declara, e é o default certo;
2. **campo por papel** — dois bastam, e são exatamente os dois que eu tenho. Se um terceiro aparecer,
   ele vira pedido com o número dele;
3. **que você adivinhe o meu valor** — eu declaro. O que eu preciso é do campo.

## Como o pai vai saber que funcionou

O meu gate. `o_neto_troca_a_paleta_e_pronto` tem uma lista fechada chamada `naoViajam`, hoje com dois
nomes. Com os campos, ela fica **vazia** e a contagem vai de 32 pra 34 de 34. É a asserção que
responde a pergunta do dono do produto sem prosa: **um neto troca a paleta e recebe o esquema dele.**

---

## Veredito · ENTRA — `bgClaro` e `surfaceMutedClara`, e a matriz fecha na célula que faltava
**pai**: ds-diletta **v0.119.0** · **data**: 2026-08-20

### O que decidiu

**Quem mediu a falta não é quem sofria dela.** Você não pediu isto quando os dois valores te doíam — você
pediu quando montou um NETO com a minha paleta e o gate contou:

> **32 papéis viajam · 2 presos por dívida** — `bg` e `field`, só no claro.

Esse é o argumento inteiro, e ele é de arquitetura e não de cor. O que você tem hoje (`BoldColors.
fundoClaroDaPagina` como constante nomeada, com motivo escrito e gate contando) **funciona pro seu
produto** — e é exatamente por isso que o pedido é bom: você não veio pedir conforto, veio pedir a porta
que falta pro terceiro nível existir. Critério que pesou: **escalabilidade** — a pergunta *"aguenta o
próximo"* aqui é literal.

E a sua seção «Conferi no pai» decidiu que era assimetria e não capricho, com a matriz na mão:

| | superfície | texto e borda |
|---|---|---|
| escuro | v0.1.9 | v0.109.0 |
| claro | **esta** | v0.111.0 |

Três células preenchidas por três pedidos diferentes, de dois filhos, em sete meses. **Cada uma pareceu
caso isolado no dia; juntas são uma matriz** — e é a leitura que eu não tinha feito.

O seu «Já tentei» eliminou as duas saídas antes de eu abrir a boca, e a primeira é a que eu ia sugerir:

> *"`papeisExtras` mentiria. `background` e `field` são vocabulário SEU — `bg` e `surfaceMuted`.
> Declarar como extra criaria dois papéis com o mesmo significado, que é exatamente a duplicata que eu
> passei o dia matando."*

Está certo, e é a fronteira do eixo de extras dita melhor do que o `///` dele diz.

### O que eu achei indo implementar

**1 · `bgClaro` move mais do que `bg` — ele move o CHÃO de uma derivação.** O trilho do medidor filtra
candidatos por contraste ≥1,1 **contra a página**, e no claro a página era `p.white` cravado. Com a sua
página tingida, medir contra o branco seria medir o fundo errado — a mesma classe do defeito que a v0.66.0
pagou (*"a derivação otimizou a restrição que ela sabia percorrer"*). No escuro isso já estava certo,
porque lá `pagina` é declarável desde a v0.1.9. **A célula vazia da matriz estava escondendo uma segunda
assimetria dentro de uma derivação**, e ela sai no mesmo commit.

**2 · `bgMenu` NÃO acompanha, e isso é decisão que eu declaro em vez de deixar você descobrir.** No escuro
ele segue a SUPERFÍCIE (`surfaceEscura`), não a página — menu é superfície flutuante; página é o que fica
atrás dela. Então no claro ele continua branco. Se o menu do seu produto for a página tingida, isso é um
número que eu não tenho: **traga o sítio e ele vira pedido** com o mesmo formato desta porta.

**3 · `surface` também não se move, e é o seu próprio argumento que manda não mover.** *"O card deste
produto é branco, e a página tingida é o que faz ele ler como ELEVADO — 1,105 de contraste entre os dois."*
Se `bgClaro` movesse a superfície junto, eu apagaria a distância que você declarou. Ficou no gate: com a
página tingida, `surface` continua branco e a distância entre os dois é medida.

**4 · A proporção da origem dos papéis andou 39/21 → 37/23** no claro, e a direção é a certa: dois papéis
saíram de *degrau cravado* pra *`??` com o degrau como default*. Alias virando derivado por porta nova é o
oposto de alias virando derivado por conta minha — o filho ganha o lugar de dizer, e quem não diz não
muda de pixel.

### O que eu recusei, e a condição de reabrir

- **`surfaceClara`** (a terceira superfície). Você já não pediu, e eu não abro por simetria: seu card é
  branco, e porta que ninguém usa é campo que envelhece. Reabre com o primeiro produto cuja SUPERFÍCIE
  não é branca no claro — e aí eu suspeito que seja pedido de neto também;
- **derivar da rampa** (`neutral10` a 2 unidades do seu valor). Recusado com a sua razão, que é melhor que
  a minha: a derivação do claro é branco PURO de propósito, e 2 unidades de canal não são o assunto;
- **mudar a derivação do claro.** Continua branco puro pra quem não declara.

### O que você faz

`ref: v0.119.0`

1. na sua paleta: `bgClaro: BoldColors.fundoClaroDaPagina` e
   `surfaceMutedClara: BoldColors.campoClaro`. As duas constantes nomeadas do seu esquema morrem com a
   declaração — é o que faz a porta valer;
2. **a lista `naoViajam` do seu gate fica vazia**, e a contagem vai a 34 de 34. Me diga o número final:
   ele é a resposta escrita pra pergunta do dono do produto (*"trocar os tokens troca o app?"*), e eu vou
   citá-lo quando o terceiro filho perguntar a mesma coisa;
3. confira o **trilho do medidor** no seu claro depois de subir. Ele passa a se separar da sua página em
   vez do branco, e é o único papel cuja cor pode mudar sem você ter pedido — se ele piorar em algum tom,
   é defeito meu e eu quero o número.


## Resposta do filho · adotado na v0.57.0, e a dívida do neto foi de 2 pra ZERO
**data**: 2026-08-20

Declarei os dois na paleta e o esquema deixou de ler constante — `background` e `field` no claro
passaram a derivar. O gate que produziu o pedido mudou de número duas vezes na mesma edição:

| | antes | agora |
|---|---|---|
| papéis que acompanham a paleta do neto | 32 | **35** |
| presos por dívida | 2 | **0** |
| iguais por consequência | 1 | **0** |

**O terceiro veio de graça e eu não tinha previsto**: o `overlay` era o único "por consequência" — ele
é o fundo com alpha, e estava preso porque o fundo estava. Soltou o fundo, soltou o scrim. Consequência
funciona nos dois sentidos, e é por isso que ela era uma lista e não uma exceção.

A sua frase sobre quem mediu a falta é a que eu levo: eu convivi com os dois valores por semanas sem
pedir nada, e só vi quando montei o neto. **A medição não achou uma dor minha, achou uma porta que
faltava** — e é o mesmo beneficiário do outro pedido de hoje.
