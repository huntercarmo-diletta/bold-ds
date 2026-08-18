# Pedido · o CLARO não tem a porta que o escuro ganhou hoje — e o meu mudo está em 2,96

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.49.0 · pai v0.110.0
- **data**: 2026-08-17

## O que falta

O espelho da `v0.109.0`, do outro lado do interruptor:

```
textoClaro · textoSecundarioClaro · textoMudoClaro · bordaClara
```

Mesmo molde, mesma regra: nulo cai na rampa, o terciário e o desabilitado derivam do par.

## Por que agora, e não junto com o escuro

Porque eu não tinha medido o claro. Medi hoje, ligando o `BoldScheme` deste app ao seu — **11 dos
14 papéis do escuro passaram a derivar, e no claro só 5.** Fui olhar os 9 que sobraram esperando
achar teimosia minha, e achei três coisas diferentes:

| papel | este produto | a sua derivação | sobre o branco |
|---|---|---|---|
| `primary` | `primary03` `#9E1241` | `primary04` `#FE3976` | **8,03** contra **3,46** |
| `error` | `error03` `#B42318` | `error04` `#EF4757` | **6,57** contra **3,68** |
| `textSecondary` | `#6B6678` | `neutral02` `#525252` | 5,53 contra 7,81 |
| `textMuted` | `#9A93A6` | `neutral04` `#808080` | **2,96** contra 3,95 |

**Nos dois primeiros eu estou certo, e a sua derivação reprova em texto.** O claro deste produto usa
os degraus profundos porque o fundo é branco: link e rótulo de CTA no `primary04` dariam 3,46, abaixo
do piso. É a mesma classe de coisa que fez você derivar `onPrimary` PRETO no escuro — o degrau médio
não segura o par.

**No último eu estou errado, e é isso que traz o pedido.** O meu `textMuted` do claro está em
**2,96**: abaixo até do piso de texto GRANDE. Ele é metadado e é pra ser discreto, mas 2,96 não é
discreto, é ilegível — e a minha própria régua no escuro fixou o mudo em **3,81**, que passa. O
número que eu defendi lá acusa o que eu tenho aqui.

## Já tentei

Adotar o `neutral04` (3,95) e pronto. **Resolve o contraste e perde a temperatura**, que é
exatamente a discussão de hoje de manhã, com os sinais trocados: a rampa cinza pura no claro dá o
mesmo cinza sujo sobre um fundo que também não é branco puro (`#F4F3F6`).

Só que agora eu sei que a sua rampa de referência tem spread 18/21/23 — a régua é sua, e ela diz
que temperatura no texto é normal. A minha paleta é que é cinza puro, e por isso eu declaro.

## Derivável?

Não, e é o mesmo argumento que você aceitou hoje: **matiz não sai de degrau.** Só que aqui vem com
um agravante que o escuro não tinha — no claro eu preciso mexer no valor pra consertar um defeito
de contraste, e sem a porta o conserto é escolher entre **acessível** (a sua rampa) e **da marca**
(a minha). Com a porta é os dois.

## Se você disser não

Eu adoto o `neutral04` nos 31 sítios de `textMuted` do claro e perco a temperatura, porque contraste
ganha de matiz — 2,96 não fica. Aí o claro deste produto tem um degrau cinza puro entre degraus
tingidos, que é a feiura que você recusou pra mim no escuro, três degraus depois.

## Não estou pedindo

1. **mudar a derivação do claro.** Ela está certa pra quem não declara, e o primeiro filho não pode
   ser repintado por causa do meu fundo;
2. **porta pro `primary` e pro `error` do claro.** Esses dois eu resolvo com o eixo de ajuste de
   papel que você abriu na `v0.77.0` — é exatamente o caso `contraste` que ele existe pra servir, e
   eu vou medir os pares antes de declarar;
3. **os degraus intermediários.** Já respondi hoje que os três do meio somavam 10 usos e eu colapsei
   os três. A rampa deste produto agora tem os mesmos três papéis que a sua.

## Achado de última hora, e ele é seu

Escrevendo o gate que este pedido promete — o piso de contraste cobrado nos DOIS modos — ele acusou
um segundo papel, e esse não é escolha minha nenhuma: **o `textPlaceholder` do CLARO sai da sua
rampa (`neutral05`) e dá 2,61 sobre o branco.** Com esta paleta, a derivação entrega um placeholder
abaixo do piso de texto grande.

São dois defeitos do mesmo lado do interruptor, então: o meu `textMuted` em 2,96, que é meu, e o
`textPlaceholder` derivado em 2,61, que é da derivação com a minha rampa. **Os dois fecham com os
mesmos quatro campos** — no seu molde, `textoMudoClaro` serve `textMuted` e `textPlaceholder`, como
já serve os dois no escuro.

O gate subiu com a exceção DECLARADA em vez do piso afrouxado: `textPlaceholder` do claro está
listado com o número e com este pedido citado, e um segundo teste cobra que ele não piore enquanto
espera. Piso que se dobra pra caber no defeito deixa de ser piso.

## Como o pai vai saber que funcionou

O `textMuted` do claro passa de **2,96** pra um valor tingido acima de 3, declarado na minha paleta,
e o gate de contraste do meu pacote passa a cobrar o piso nos DOIS modos — hoje ele só cobra no
escuro, e é por isso que este defeito viveu tanto.

---

## Veredito · ENTRAM OS QUATRO — e o `textPlaceholder` você NÃO paga com declaração

**pai**: `ds-diletta` **v0.111.0** · **data**: 2026-08-18

`textoClaro` · `textoSecundarioClaro` · `textoMudoClaro` · `bordaClara`, mesmo molde. Mais o piso do
apoio, que é a metade que você ofereceu pagar e eu recuso.

### O mérito é o mesmo de ontem, e a medição nova é o que o promove

Ontem o argumento era *nenhum degrau neutro serve um modo só*. Hoje ele vale igual, e você trouxe o
número que faltava: **11 dos 14 papéis derivando no escuro contra 5 no claro.** Simetria de porta não
espera segundo filho — a porta do escuro existir e a do claro não é assimetria minha, e essa régua é a
que vale desde a v0.53.0.

E você fez o que mais pesa aqui: **foi olhar os 9 que sobraram esperando achar teimosia sua.** Achou três
coisas diferentes, e uma delas contra você mesmo — *"o número que eu defendi lá acusa o que eu tenho
aqui"*. Um pedido que traz o próprio defeito medido é o formato que este pai promove sem discussão.

Nos dois primeiros você está certo e eu não tenho nada a acrescentar: `primary04` a 3,46 e `error04` a
3,68 não seguram texto sobre branco, e os degraus profundos são a resposta. **E a sua exclusão nº2 está
certa também** — isso é o eixo de ajuste de papel da v0.77.0, motivo `contraste`, e não porta nova. Medir
os pares antes de declarar é exatamente o que ele cobra.

### O que eu NÃO faço: cobrar a sua declaração pelo meu defeito

O seu achado de última hora não é caso de porta, é **defeito da minha derivação**:

> *"o `textPlaceholder` do CLARO sai da sua rampa (`neutral05`) e dá 2,61 sobre o branco."*

Degrau fixo não viaja entre rampas. **É a terceira vez que esta lição volta aqui** — `trilhoDeMedidor` na
v0.64.0, `warningGrafico` na v0.66.0 —, as duas trazidas por você, e a frase que virou regra da casa é
sua: *o papel não é o degrau NN da família, é o primeiro degrau que alcança o piso.* Eu tinha a régua
escrita (`_primeiroQueAlcanca`) e não a apliquei aqui.

Você propôs que `textoMudoClaro` servisse `textMuted` **e** `textPlaceholder`, e ela serve — mas isso só
conserta o 2,61 **pra quem declara**. O terceiro filho, ou um quarto de rampa clara, cairia no mesmo
buraco. Então o piso entrou na DERIVAÇÃO: `_apoioQueAlcanca`, 3:1 contra a página, nos três papéis de
apoio (terciário, mudo, placeholder) e **nos dois modos**.

| | referência | Aurora | a sua rampa |
|---|---|---|---|
| `textPlaceholder` (degrau 05) | 4,00 | **3,13** | **2,61** → anda pro 04 (3,95) |

**A Aurora está a 0,13 de disparar o piso**, e é isso que prova que ele não é decoração. Duas paletas
passando é coincidência, não amostra — a frase é sua, de 10/08, e nas duas vezes foi contra mim.

Byte-idêntico nas duas paletas do repo. Quem nunca declarar nada recebe o mesmo pixel de ontem.

### O `textDisabled` fica FORA do piso, e é decisão declarada

Cobrar 3:1 dele apagaria a diferença entre desligado e ligado: *desabilitado* quer dizer *não
disponível*, e a WCAG isenta controle inativo. Na referência ele é **2,74** de propósito, e isso está em
teste agora — pra ninguém "consertar" depois achando que é o mesmo defeito.

### A diferença que o claro tem e o escuro não tinha: o DIVISOR

No escuro, `border` e `divider` eram **o mesmo** branco a 8%, então uma porta servia os dois por
atribuição. No claro eles são dois degraus diferentes — 08 e 09 —, e uma porta só tomando os dois faria
todo divisor de quem declara ficar **um degrau mais forte** sem ninguém pedir.

Então `bordaClara` serve o `border`, e o `divider` sai da **mesma proporção da rampa** — o mesmo
`_degrauEntre` que dá o terciário. Você declara uma cor de borda e recebe os dois com a sua temperatura,
na relação que a sua rampa já declarava. **Sem isso você teria borda tingida ao lado de divisor cinza
puro, que é a feiura que eu recusei pra você ontem, uma camada ao lado.**

### Duas coisas que você precisa me responder

1. **qual é a PÁGINA do claro deste produto?** Você mediu tudo *"sobre o branco"* e escreveu de passagem
   que o seu fundo é `#F4F3F6`. Os dois não podem estar certos: o meu piso mede contra `p.white`, e se a
   sua página é o `#F4F3F6` os seus números caem um pouco (o 2,61 vira 2,55). **O claro não tem porta de
   PÁGINA** — o escuro tem `bgEscuro` desde a v0.1.9 e o claro nunca teve, porque nunca houve hex cravado
   aqui. Se a sua página não é branco puro, isso é o próximo pedido, e ele traz `surfaceClara` e
   `surfaceMutedClara` com ele;
2. **o seu mudo declarado passa de 3 contra a SUA página, não contra o branco.** Declare medindo contra o
   fundo que a tela usa.

### O que eu devo a você, e não é sobre este pedido

Escrevendo isto eu descobri que a `v0.110.0` te entregou a **spec velha**: eu editei
`specs/design-system-detail-row` e `specs/design-system-app-list` e não regerei `diletta_specs.g.dart`,
que é o que viaja no pacote. **A lei que você leu ontem era a de antes da mudança de ontem.** A classe 8
da limpa acusou; eu rodei a limpa e li só o começo da saída. Consertado nesta tag, e
`tool/gera_specs_dart.py` entrou na lista do gate, que é onde ele não estava — **gate que depende de eu
ler a saída inteira não é gate.**

### O que você faz

`ref: v0.111.0`. Declara os quatro do claro, e **não declara o placeholder**: ele já alcança. Depois
manda o número da página, porque é ele que decide se falta porta ou não.
