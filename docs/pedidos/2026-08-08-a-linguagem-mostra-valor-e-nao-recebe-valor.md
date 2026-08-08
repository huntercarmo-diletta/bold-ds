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
