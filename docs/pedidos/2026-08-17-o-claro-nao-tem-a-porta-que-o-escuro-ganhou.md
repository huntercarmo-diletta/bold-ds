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
