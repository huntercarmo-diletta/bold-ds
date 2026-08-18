# Pedido · o `primary` como TINTA não tem piso, e com a minha rampa ele dá 3,46

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.50.0 · pai v0.111.0
- **data**: 2026-08-18

## O que falta

O mesmo conserto que você fez ontem no `textPlaceholder`, uma família ao lado: **piso dentro da
derivação** para os papéis de marca quando eles são usados como TINTA.

Concretamente, no claro: `primary` e `error` deveriam cair pro degrau vizinho da própria família
quando o par com a superfície não alcança o piso — do jeito que o `warningGrafico` já faz
(`_primeiroQueAlcanca(3.0, …)`).

## O número, e ele é o pedido inteiro

Contraste sobre a superfície, no CLARO, com as duas paletas:

| papel | referência | **Bold** |
|---|---|---|
| `primary` | 5,16 | **3,46** |
| `error` | 6,56 | **3,68** |
| `primaryOnSurface` | 8,54 | 8,03 |
| `errorSolid` | 8,30 | 8,98 |

**A sua paleta passa 4,5 nos dois. A minha reprova nos dois.** E a razão é a mesma de sempre: a
derivação escolhe o degrau pelo NÚMERO dele na rampa, e o quanto aquele degrau contrasta depende de
qual rampa é.

É a terceira vez que a lição volta — foram as suas palavras ontem —, e agora ela chegou na família
que a marca usa mais.

## Já tentei

**O eixo de ajuste de papel** que você abriu na `v0.77.0`. Ele resolve, e é por isso que eu comecei
por ele: `primaryOnSurface` é da mesma família, o motivo é `contraste`, o par novo lê melhor (8,03
contra 3,46) — passa nas quatro travas.

**Mas ele é por COMPONENTE**, e o problema não é de um componente. Eu contei no seu pacote: **25
sítios pintam `color: s.primary`**, e pelo menos oito deles são tinta de verdade — texto de valor no
`checkout_sheet`, sufixo no `feature_detail_card`, glifo do usuário na `navigation_top_bar`, dois
ícones no `payment_sheet`, o `chat_completion_card`, o `progress_ring`. Declarar um ajuste por
componente é declarar oito, e o nono nasce sem ajuste.

**E `primaryOnSurface` tem UM consumidor** no pacote inteiro. O papel certo existe e quase ninguém
lê — o que quer dizer que o defeito não é de quem escreve tela, é de qual papel a peça pega.

## Derivável?

É, e é por isso que eu acho que é seu e não meu: **a conta que decide já está escrita no seu
código**, no `warningGrafico`. Ele pega o primeiro degrau da família que alcança 3,0 contra o
trilho. É a mesma forma, aplicada a `primary`/`error` contra a superfície.

Do meu lado eu só tenho duas saídas, e as duas são piores: declarar oito ajustes (e o nono nasce
sem), ou clarear a minha marca até o 04 passar — o que muda a cor da marca pra consertar contraste,
que é o oposto do que a linguagem deve fazer.

## Se você disser não

O app deste filho continua declarando `primary: primary03` e `danger: error03` no scheme dele — que
é o que ele já faz hoje, com o número escrito no `///`. **Os seus componentes, esses, continuam
pintando 3,46**, e o que acontece é o que já acontece: o produto não usa o componente do pai naquele
lugar. Foi assim que a casca de baixo ficou 55 telas fora, e você mesmo chamou isso de o que a
adoção paga quando o papel não serve.

## Não estou pedindo

1. **mudar a rampa da referência.** O primeiro filho passa nos dois; o conserto não pode custar
   nada a ele;
2. **novo papel.** `primaryOnSurface` e `errorSolid` já existem e já são o destino certo;
3. **piso 4,5.** Marca não é texto de corpo — 3,0 já resolveria os dois casos, e é o piso que você
   usa no `warningGrafico`.

## Li o seu ledger antes de insistir, e ele tem a metade que faltava do meu argumento

Eu já tinha levantado o **mesmo 3,46** em 31/07, e você fechou na `v0.22.0`. O seu veredito de lá é
a frase que este pedido devia ter aberto citando:

> *"`dilettaTintaSobre` deriva na ordem declarada → branco → cinza de texto → preto. **Tinta é
> consequência de legibilidade; preenchimento é decisão de marca.**"*

**Então isto não é o mesmo pedido de novo — é a outra metade do mesmo princípio.** Você aplicou o
piso à tinta que vai SOBRE o `primary` (e é por isso que o `onPrimary` do meu claro é preto). O que
não tem piso é o `primary` sendo usado **como tinta**, sobre a superfície.

Pela sua própria régua, esse caso é tinta, e tinta é consequência de legibilidade. É a única linha de
argumento que eu precisava, e ela é sua.

O que continua sendo minha contribuição de hoje é só a medição do tamanho: **25 sítios** do seu
pacote pintam `color: s.primary`, oito deles em texto ou glifo, e `primaryOnSurface` — o papel que
existe exatamente pra esse caso — tem **um** consumidor.

E registro a lição de meia hora atrás, na nota do `raioDeFolha`: eu citei o seu ledger sem checar a
coluna de quem levantou, e a nota morreu por isso. Desta vez eu fui ler antes.

## Como o pai vai saber que funcionou

O `primary` do meu claro passa de 3,46 pra ≥3,0 sem eu declarar ajuste nenhum, e os 25 sítios do seu
pacote param de depender de qual rampa o filho plugou. Do meu lado, o `BoldScheme.light()` perde
mais dois dos cinco campos que ainda declara.
