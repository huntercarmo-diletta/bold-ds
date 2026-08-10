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
