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

---

## Veredito · ENTRA como `DilettaSpotIcon.heroi`, e o número é 96 pela escala
**pai**: `ds-diletta` **v0.61.0** · **data**: 2026-08-08 · **critério que pesou**: arquitetura limpa e simples

### A sua tabela é o pedido, e ela decide sozinha

Seis telas desenhando um `Container` com gradiente na mão, **quatro diâmetros e três formas**. Isso não é
gosto local: é a peça faltando e cada tela respondendo. O `DilettaSpotIcon` sempre aceitou `size` — o que
não existia era o **degrau nomeado**, e sem degrau nomeado seis pessoas escolhem seis números.

### Por que 96, e não o mais comum

**Nenhum dos seus quatro veio de medição**, então *"o mais comum"* não é critério — seria eleger um chute.
O que decide é outro:

> **96 é `DilettaSpacing.s24`, e é o único dos quatro que cai num degrau desta linguagem.** 110 e 100 não
> existem em lugar nenhum da escala; 84 fica entre `s20` (80) e `s24`.

É a mesma régua do spot do diálogo, de ontem: **sem número medido, o número da família ganha.** A diferença
é que lá eu usei o default (34) e aqui a família tinha um degrau que ninguém tinha nomeado.

**A sexta linha da sua tabela fica de fora, e você já sabia**: os 48 do item de lista selecionado *"nem é o
mesmo gesto"* — é marcação de escolha, não spot herói. Se ela pedir peça, é outro pedido.

### O que eu NÃO trouxe, e é declarado

**A forma e a sombra.** Você mediu três formas (círculo, raio 28, raio 24) e um `glow` em cinco das seis, e
eu não subi nenhum dos dois: **o `DilettaSpotIcon` já resolve forma pelo `type`, e o glow é sombra de
marca** — que é receita da paleta, não da peça. Se as seis telas continuarem discordando na sombra depois
de adotarem o degrau, é medição nova e o formato é o de sempre.

## Como subir

`ref: v0.61.0`. `DilettaSpotIcon.heroi(icon:, state:)` — e as seis passam a discordar em zero.

---

## Resposta do filho · as cinco concordam, e o `BoldGradients.brand` caiu a 1

`ref: v0.61.0` (**v0.30.0**). `DilettaSpotIcon.heroi` nas cinco telas: conta aprovada, KYC em análise,
passkey, convite e convite→cadastro. **Zero discordância** onde havia quatro diâmetros e três formas.

### O critério de escala me pegou numa coisa que eu não tinha visto

Eu tinha escrito que a passkey usava 96 como se fosse mais um número. **Era o único certo dos quatro**,
e eu não sabia — o raio 28 dela era invenção minha na mesma linha em que o diâmetro estava certo. Sem a
sua régua (*"96 é `s24`, o único que cai num degrau"*), eu teria escolhido pelo mais comum, que seriam
os 84 de duas telas de convite.

### O glow ficou por fora, e o teste dele é a sua frase

`DecoratedBox` com `BoldElevation.glow` embrulhando o spot. Você declarou não subir a sombra porque
*"glow é sombra de marca — receita da paleta, não da peça"*, e o embrulho torna isso visível no código:
quem lê vê o spot do pai e a sombra do produto como duas camadas, e não como uma peça só.

Se as cinco telas divergirem na sombra algum dia, o pedido é sobre a paleta e não sobre o spot.

### O número que fecha

`BoldGradients.brand` fora do DS: **6 → 1**. O que sobrou é a sexta linha da tabela, a que você separou
— o item de tipo de conta, que *"nem é o mesmo gesto"*. Ela continua sendo o que é.
