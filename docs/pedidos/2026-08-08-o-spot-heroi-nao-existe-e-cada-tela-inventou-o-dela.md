# Pedido · o spot HERÓI não existe, e as seis telas que precisam dele inventaram seis

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.29.0 · pai v0.54.0
- **data**: 2026-08-08

## O que falta

Um porte HERÓI pro `DilettaSpotIcon` — o círculo grande da marca, com o glifo dentro, que ocupa o
centro de uma tela de estado ("conta aprovada", "estamos analisando", "passkey pronta").

## A medição é a discordância, e ela é de seis linhas

Este app tem seis desses momentos. Nenhum usa uma peça: **os seis desenham um `Container` com
`gradient: BoldGradients.brand` na mão**, e discordam entre si em tudo que não é a cor:

| tela | diâmetro | forma | sombra |
|---|---|---|---|
| conta aprovada | **110** | círculo | glow |
| KYC em análise | **100** | círculo | glow |
| passkey configurada | **96** | raio 28 | glow |
| convite de operador | **84** | raio 24 | glow |
| convite → cadastro | **84** | raio 24 | glow |
| tipo de conta (item selecionado) | **48** | raio de campo | nenhuma |

Quatro diâmetros, três formas, e a última linha nem é o mesmo gesto — é um item de lista marcado.
**Isso não é gosto deste produto: é o que acontece quando não existe a palavra.** Cada tela resolveu
sozinha e nenhuma soube que as outras existiam.

## Por que o seu `DilettaSpotIcon` não cobre

Ele cobre a geometria: `size` é livre, então `DilettaSpotIcon(icon: 'key-light', size: 96)` monta o
círculo grande sem eu pedir nada. **O que não cobre é a TINTA.** As dez variantes (fill/outline × 8
estados) saem do esquema, e a mais próxima — `state: primary` — é `primarySubtle` no fundo com
`onPrimarySubtle` no glifo, que é um TINTE.

Num acessório de 34 dentro de uma linha de lista, o tinte é exatamente certo: ele não pode competir
com o texto ao lado. **Aos 110 no centro de uma tela vazia, o mesmo tinte lê como um círculo
desbotado** — e o momento é o oposto disso: é a marca dizendo "deu certo". É por isso que as seis
telas foram buscar o gradiente da marca em vez de usar a peça que existe.

## Onde eu ACHO que mora

Como estado novo no que já existe, e não como peça nova:

```dart
DilettaSpotIcon(
  icon: DilettaIcons.checkLight,
  state: DilettaSpotState.brand,   // fill da marca, glifo em onPrimary
  size: 96,
)
```

Três coisas que eu **não** estou pedindo, com a razão medida:

1. **peça nova.** O `SpotIcon` já tem o tamanho livre e o glifo centrado — o que falta é uma tinta,
   e tinta nova num `switch` que já tem oito casos é a mudança menor;
2. **o glow.** Cinco das seis põem sombra colorida embaixo, mas essa é a minha `BoldElevation.glow`,
   e eu não tenho medição que diga que ela pertence à linguagem. Se o seu spot herói vier sem sombra,
   eu ponho a minha por fora;
3. **o número.** Não peço 96, nem 110. **Eu não tenho o número certo** — tenho quatro números
   diferentes, que é a prova de que ninguém aqui decidiu isso. Se o porte herói vier com um degrau
   declarado, é ele que vale, e as seis telas passam a concordar pela primeira vez.

## Uma coisa que este pedido devolve

O item de tipo de conta (48, raio de campo, sem sombra) **não é este gesto** e eu só percebi ao
tabelar. Ele é um acessório de item selecionado, e vai continuar sendo o que é — a medição separou
cinco casos de um que só parecia igual porque compartilhava a cor.

## Como o pai vai saber que funcionou

`BoldGradients.brand` cai de 6 usos fora do DS pra 1, os cinco heróis passam a ter o mesmo diâmetro,
e a resposta pra "de que tamanho é o círculo da marca?" deixa de depender de qual tela você abriu.
