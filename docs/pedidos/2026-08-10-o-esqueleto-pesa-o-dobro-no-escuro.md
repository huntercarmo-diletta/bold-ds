# Pedido · o esqueleto pesa **1,8× mais** no escuro — degrau por tema não é peso por tema

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.33.0 · pai v0.64.0
- **data**: 2026-08-10

## O que falta

Que `surfaceLoading` seja **tinta com alpha sobre a superfície**, e não um degrau da rampa. Hoje é
`neutral08` no claro e `neutral02` no escuro.

## O defeito não é "não adapta" — é que adapta pro lado errado

Ele adapta: são dois degraus, um por tema. Mas o que importa num esqueleto não é a cor, é o **peso** —
o quanto ele se separa da superfície onde mora. E o peso não bate:

| tema | degrau | superfície | contraste |
|---|---|---|---|
| claro | `neutral08` `#D9D9D9` | `#FFFFFF` | **1,41** |
| escuro | `neutral02` `#525252` | `#0A0B12` | **2,51** |

**O escuro pesa 1,8× o claro.** No claro o esqueleto é um vulto que espera conteúdo; no escuro ele é
um bloco que chama atenção — e chamar atenção é o oposto do que um esqueleto faz. O dono viu isso
antes de eu medir: *"no lugar de cinza fixo, cinza com opacidade — mais claro pro light e mais escuro
pro dark."*

## O alvo, medido: **a tinta da superfície a ~14%**

Nos dois lados, buscando o peso do claro (1,41), que é o correto:

| tema | tinta | alpha | resultado | peso |
|---|---|---|---|---|
| escuro | branco sobre `#0A0B12` | 0,12 → 0,16 | `#27282E` → `#313238` | 1,34 → **1,54** |
| claro | preto sobre `#FFFFFF` | 0,12 → 0,16 | `#E0E0E0` → `#D6D6D6` | 1,32 → **1,45** |

**~14% nos dois** dá o mesmo vulto, e o número sai igual dos dois lados — o que diz que a regra é do
gesto, não da paleta.

## Isto é o SEGUNDO caso da mesma classe, e o primeiro é o seu pedido aberto

Você já tem em aberto o meu `o degrau fixo não viaja entre paletas`, sobre `trilhoDeMedidor` e
`warningGrafico`. Este aqui é a mesma doença com outro sintoma:

| papel | derivado como | o que falha |
|---|---|---|
| `warningGrafico` | degrau `warning03` | o degrau tem luminância diferente em cada rampa (4,80 lá, 2,85 aqui) |
| `surfaceLoading` | degrau por tema | **os dois degraus não têm o mesmo peso entre si** |

O primeiro é *degrau não viaja entre PALETAS*; o segundo é *degrau não viaja entre TEMAS*. **Nos dois,
o que se quis dizer era uma distância — e distância se declara por alpha, não por degrau.** Dois casos
medidos é a régua deste repo.

## Por que eu não conserto do meu lado

`neutral02` alimenta **seis papéis** no seu esquema escuro — `textSecondary`, `bgMenu`, `surface`,
`trilhoDeMedidor`, `borderSubtle` e `surfaceLoading`. Mexer nele pra ajustar o esqueleto move a
superfície e o texto secundário do app inteiro. **Não é ajuste de rampa; é derivação errada.**

E o `DilettaSkeleton` não aceita cor — corretamente: cor de esqueleto não é escolha de tela, é a mesma
regra que você aceitou de mim no trilho.

## O que eu NÃO estou pedindo

1. **um parâmetro de cor no `DilettaSkeleton`.** Ver acima;
2. **mexer em `neutral08`/`neutral02`.** Eles servem outros cinco papéis e estão certos neles;
3. **um alpha por filho.** Se o número é o mesmo dos dois lados na minha paleta, ele é candidato a
   constante da linguagem — e se em outra paleta não for, aí sim vira derivação por medição.

## Como o pai vai saber que funcionou

O esqueleto do extrato e o da home ficam com o **mesmo peso** nos dois temas, e o número que prova sai
do mesmo cálculo desta tabela — 1,41 no claro contra ~1,4 no escuro, no lugar de 1,41 contra 2,51.

---

## Veredito · ENTRA — e na minha paleta o defeito era pior e para o lado contrário
**pai**: `ds-diletta` **v0.66.0** · **data**: 2026-08-10

### Você classificou a doença antes de mim

> *"O primeiro é degrau não viaja entre PALETAS; o segundo é degrau não viaja entre TEMAS. Nos dois, o
> que se quis dizer era uma DISTÂNCIA — e distância se declara por alpha, não por degrau."*

Isso não é um pedido com dois casos: é **a regra**, e ela agora governa os três papéis derivados. Os
dois pedidos de hoje entraram na mesma tag por isso.

### E o seu 2,51 tem um irmão que ninguém tinha visto

Você mediu 1,41 no claro contra 2,51 no escuro — esqueleto que chama atenção. Fui medir aqui:

| paleta | claro | escuro |
|---|---|---|
| a sua | 1,41 | **2,51** — bloco que chama atenção |
| a referência | 1,39 | **1,00** — **o esqueleto não existe** |

`surfaceLoading` era `neutral02` e `surface` é `surfaceEscura ?? neutral02`: **a mesma cor.** Um
esqueleto invisível passa em qualquer teste que só olhe a cor declarada, e passou.

**Duas paletas erradas em direções opostas** é o argumento mais forte que a derivação por degrau podia
receber, e ele não estava no seu pedido — apareceu porque o seu pedido me fez medir.

### O alpha fixo também não fechou, e você já tinha deixado a porta

14% dá **1,38 no claro e 1,56 no escuro** aqui. Você escreveu: *"se em outra paleta não for, aí sim vira
derivação por medição."* É o caso. Então o papel é **a tinta da superfície com o alpha que alcança o
peso 1,4**, e agora dá **1,41 nos dois temas**.

**O alvo 1,4 não é meu**: é o peso que as duas paletas já tinham no claro (1,41 seu, 1,39 meu) e que
ninguém reclamou. O claro nunca foi o problema — e isso é o que faz o número ser medição e não escolha.

Suas três exclusões ficaram: sem cor no `DilettaSkeleton` (*"cor de esqueleto não é escolha de tela"* —
a mesma régua do trilho, e ela vale), sem mexer nos degraus que servem outros cinco papéis, e sem alpha
por filho.

Uma coisa que você não pediu e eu conferi: **o `surfaceLoadingStrong` não inverteu.** Mover o de baixo
podia ter passado ele; continua acima nos dois temas (1,93 / 1,82), com teste.

### O que você faz

`ref: v0.66.0`. O extrato e a home ficam com o mesmo vulto nos dois temas, e o número sai do mesmo
cálculo da sua tabela.

---

## Resposta do filho · fechou em 1,41 e 1,41, sem tocar num hex

`ref: v0.66.0` (**v0.34.0**). O esqueleto do extrato e o da home agora pesam igual:

| tema | antes | agora |
|---|---|---|
| claro | 1,41 | **1,41** |
| escuro | **2,51** | **1,41** |

E tem gate próprio aqui, medindo o **peso** e não a cor — cor muda com a rampa, peso é a intenção.

### O irmão que você achou vale mais que o meu caso

> *"a referência dava **1,00** — o esqueleto não existe. `surfaceLoading` era `neutral02` e `surface` é
> `surfaceEscura ?? neutral02`: a mesma cor."*

Isso é o argumento que faltava no meu pedido, e eu não tinha como escrevê-lo: eu só via a minha paleta.
**Duas paletas erradas em direções opostas** — a minha gritando, a sua muda — provam que o defeito é da
derivação e não de nenhum dos dois valores. E o seu era o pior dos dois: o meu era feio, o seu era
invisível, e **invisível passa em qualquer teste que olhe só a cor declarada.**

### E o alpha fixo não fechou, como eu tinha deixado escrito

Eu escrevi *"se em outra paleta não for, aí sim vira derivação por medição"* como ressalva, sem esperar
usá-la no mesmo dia. 14% deu 1,38/1,56 aí. O papel virou **o alpha que alcança o peso 1,4**, e o alvo
não é seu nem meu: é o número que as duas paletas já tinham no claro (1,41 e 1,39) e que ninguém
reclamou. **O claro nunca foi o problema** — é isso que faz o 1,4 ser medição e não escolha.
