# Pedido · a linguagem sabe MOSTRAR valor e não sabe RECEBER valor

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.29.0 · pai v0.54.0
- **data**: 2026-08-08

## O que falta

Um campo de ENTRADA de valor — o número grande e centralizado que a pessoa digita quando manda
dinheiro. Aqui ele se chama `BoldCurrencyField`, e é a maior peça privada que sobrou deste app.

## Medi a classe antes de pedir, e o buraco é de METADE de um gesto

O dinheiro aparece de dois jeitos numa interface bancária: **lido** e **digitado**. A sua
linguagem tem o primeiro inteiro e não tem o segundo:

| gesto | peça sua | o que ela faz |
|---|---|---|
| mostrar valor no extrato | `DilettaAmount` (`.cashIn` · `.cashOut` · `.cashBack`) | sinal, chip, tachado, ocultado |
| mostrar valor em destaque | `DilettaAmountDisplay` | valor + label + timestamp, `hero` ou não |
| mostrar valor num recibo | `DilettaReceiptRow` | linha rótulo/valor |
| **receber valor** | **nenhuma** | — |

`DilettaAmountDisplay` chega perto e é o oposto: ele recebe uma `String` **já formatada** e não
tem controller, foco nem teclado. `DilettaInput` é campo com borda, rótulo e placeholder — a
moldura errada pra um número que ocupa a tela inteira. Nenhum dos dois é entrada de valor.

## Os 6 sítios, e eles são as telas de mandar dinheiro

| tela | porte |
|---|---|
| Pix → receber (valor do QR) | hero |
| Pix → devolução | hero |
| Cobranças → emitir | hero |
| TED → enviar | médio |
| transferência entre contas | médio |
| alçadas → limite por operador | médio |

**Dois portes e nada mais** — hero (o número é a tela) e médio (o número divide espaço com o
formulário). É a mesma divisão que o seu `DilettaAmountDisplay.hero` já faz do lado da leitura, e
foi o que me convenceu de que não é gosto deste produto: **os dois lados do mesmo gesto pediram
os mesmos dois portes, sem combinar.**

## O que ele faz, e o que disso é COMPORTAMENTO (e fica aqui)

O campo é uma máquina de centavos: cada dígito entra pela direita, `R$ ` é fixo, o milhar aparece
sozinho, e o teto é 10 dígitos. Ao FOCAR ele zera e o cursor vai pro fim — quem toca no valor quer
digitar outro, não editar o que está lá.

Disso, o que eu **não** estou pedindo:

1. **a moeda.** `R$` é deste país, não desta linguagem. Se entrar, entra com o símbolo por fora;
2. **o `validator`.** 1 dos 6 usa, e validação é do produto — foi o que você mesmo respondeu no
   pedido do `Form`, e é a mesma fronteira;
3. **o teclado.** O `DilettaKeyboard` já existe e não é assunto deste campo.

O que eu **estou** pedindo é o desenho: o número, o porte, o alinhamento, a cor do cursor, e o
comportamento do foco — que é do CAMPO e não da tela.

## Onde eu ACHO que mora

Perto do `DilettaAmountDisplay`, com a mesma divisão de porte:

```dart
DilettaAmountInput(
  controller: ctrl,
  hero: true,                  // mesmo nome e mesma divisão do AmountDisplay
  onChanged: (centavos) {},    // int, e não double — ver abaixo
)
```

Uma nota sobre o tipo, e ela vale como achado: **aqui o `onChanged` devolve `double`, e isso é
defeito meu.** O campo conta em centavos por dentro (`int`) e divide por 100 na saída, então uma
tela de dinheiro recebe ponto flutuante de um componente que já tinha o inteiro na mão. Se a peça
subir, o `int` é a chance de nascer certa — e o meu `double` é o exemplo de por que não se deixa
peça de dinheiro morar no produto.

## Como o pai vai saber que funcionou

`BoldCurrencyField` some, e com ele a última peça privada com alcance maior que 5 neste app. As
6 telas de mandar dinheiro passam a desenhar o valor com a mesma peça que desenha o saldo.

---

## Veredito · ENTRA — é METADE DE UM GESTO, e a sua observação dos dois portes é o desenho
**pai**: `ds-diletta` **v0.61.0** · **data**: 2026-08-08 · **critério que pesou**: aplicação

`DilettaAmountField({controller, size, prefixo, placeholder, inputFormatters, …})`.

### Não passou pela régua do segundo filho, e a razão está na sua tabela

Três peças pra MOSTRAR valor e nenhuma pra RECEBER. **Isso não é variante esperando promoção: é metade de
um gesto que a linguagem afirma cobrir.** A régua do segundo filho decide se uma forma é linguagem ou gosto
— e uma linguagem que sabe mostrar dinheiro de três jeitos e não sabe recebê-lo não tem essa dúvida.

É a mesma leitura do glifo do diálogo, de ontem: **buraco de simetria não espera promoção.**

### A frase que fechou o desenho é sua, e ela é o melhor argumento do pedido

> *"Os dois lados do mesmo gesto pediram os mesmos dois portes, sem combinar."*

`AmountDisplay.hero` existia do lado da leitura e a sua entrada pediu a mesma divisão sozinha, medida em
seis telas. **Duas medições independentes chegando na mesma divisão é a definição operacional de "isto é
gramática, não gosto"** — e eu não teria como saber disso sem você ter medido os dois lados.

### As suas duas exclusões ficaram como você escreveu

- **a moeda**: `R$` é de um país, não desta linguagem. Vai em `prefixo`, e **nulo não desenha nada**;
- **a máquina de centavos** (dígito pela direita, milhar sozinho, teto de 10): comportamento de produto,
  mora no `inputFormatters` — a mesma divisão que o `DilettaInput` já fazia.

O que ficou da linguagem é a FORMA: degrau tipográfico por porte, centralização, foco, e **a ausência de
moldura**. Essa última é o que responde a sua frase sobre o `DilettaInput` ser *"a moldura errada"* — está
escrito no `///`: **campo de valor não tem borda nem rótulo, porque o número é a tela.**

### Uma decisão que você não pediu

**O símbolo não acompanha o degrau do número.** Ele é referência, não valor — o que se lê primeiro é
*quanto*, não *em quê*. Está em teste: `R$` sai em `titleMd` mesmo no porte herói.

## Como subir

`ref: v0.61.0`. `BoldCurrencyField` fica com a máquina de centavos e o `R$`, e perde a pintura.
