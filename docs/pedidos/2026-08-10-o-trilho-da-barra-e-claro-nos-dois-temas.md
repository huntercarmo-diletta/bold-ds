# Pedido · o trilho da barra é CLARO nos dois temas — e no escuro isso deixa o aviso em 1,04

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.32.0 · pai v0.63.0
- **data**: 2026-08-10

## O que falta

Que o trilho da `DilettaProgressBar` seja **papel** e não degrau fixo. Hoje ele é
`s.palette.neutral07` nos dois temas; deveria ser um papel de superfície que vira com o modo, como
`surfaceMuted` já faz.

## Este pedido é a sua deixa, e eu medi o que faltava

No veredito do `tone`, ontem, você fechou com o número e a instrução: *"nenhum alcança o 3:1 de
elemento gráfico, e o default já era assim antes do `tone` — a causa é o trilho. Se o `warning` não ler
na sua tela, o número acima é o argumento pronto pro pedido do trilho."*

Medi. **Na minha paleta é pior do que na sua**, e a diferença não é pequena:

| tom | claro (04) | escuro (05) | | sua referência, claro | sua referência, escuro |
|---|---|---|---|---|---|
| `normal` | 2,03 | 1,60 | | 2,68 | 1,66 |
| `warning` | **1,22** | **1,04** | | 1,82 | 1,17 |
| `error` | 2,15 | 1,90 | | 3,40 | 2,21 |

**`warning` no escuro dá 1,04.** O piso de objeto gráfico é 3:1 (WCAG 1.4.11); 1,04 não é "abaixo do
piso", é **a mesma luminância** — a barra existe e não se vê. E o modo escuro é o default deste app.

## A causa medida: o trilho é CLARO, e num tema escuro isso inverte o problema

`BoldColors.neutral07` é `#C6C6C6` — cinza claro. Ele funciona como trilho no tema claro (é mais escuro
que o fundo) e **falha no escuro por dois motivos ao mesmo tempo**: fica claro sobre superfície escura
(chama mais atenção que o preenchimento) e encosta na luminância das tintas semânticas, que também
clareiam no escuro.

O teste é a inversão. Trocando só o trilho, com a mesma tinta:

| trilho | `warning04` | `warning05` |
|---|---|---|
| `#C6C6C6` (hoje) | 1,22 | 1,04 |
| `#E5E5E5` (mais claro) | 1,65 | 1,42 |
| `#333333` | **6,08** | **7,08** |
| `#1A1A1A` | **8,37** | **9,76** |

**Não é a tinta que precisa mudar: é o lado do trilho.** Clarear não resolve (1,65); escurecer resolve
com folga de 2× o piso. E isso é exatamente o que um papel de superfície faz sozinho — vira com o modo.

## Onde eu ACHO que mora

No papel, não no degrau:

```dart
// hoje
color: isBanner ? whiteAlpha24 : s.palette.neutral07,
// pedido
color: isBanner ? whiteAlpha24 : s.surfaceMuted,   // ou o papel que você julgar
```

Três coisas que eu **não** estou pedindo, com a razão:

1. **trocar a tinta dos tons.** Os três degraus estão certos onde estão: eles são as cores semânticas
   desta marca e aparecem em toast, tag e spot. O defeito não é neles;
2. **um trilho por tom.** Seria três decisões onde falta uma;
3. **um parâmetro `trackColor`.** Trilho por consumidor é como um degrau vira seis: quem passa cor
   escolhe contraste, e contraste não é escolha de tela.

## O que eu já sei que isto NÃO resolve

**Cor sozinha continua não sendo informação** (WCAG 1.4.1), e você já me cobrou isso: os dois medidores
deste app passaram a dizer `perto do teto` e `teto consumido` por escrito, na v0.32.0. O trilho conserta
a **percepção da barra**; o texto é que carrega o aviso. Os dois são necessários, e o texto já entrou.

## Como o pai vai saber que funcionou

`warning` contra o trilho passa de **1,04 para ≥3:1 no escuro** na minha paleta, e o número sai do
mesmo cálculo que está aqui. E a mudança move **toda barra que já existe** — é por isso que ela é sua e
não minha: eu tenho 2 sítios, você tem o `.banner`, o `.activity` e o `.value` em dois filhos.

---

## Veredito · ENTRA, e o papel que você pediu NÃO passou na medição — a Aurora derrubou dois desenhos meus
**pai**: `ds-diletta` **v0.64.0** · **data**: 2026-08-10

Você acertou o diagnóstico inteiro e **errou o papel**, e as duas coisas importam.

### O diagnóstico é seu, e o teste de inversão é o que fechou

*"Não é a tinta que precisa mudar: é o lado do trilho."* Com `#333333` dando 6,08 contra `#C6C6C6`
dando 1,22, não sobrou o que discutir. **Trocar só uma variável e mostrar os quatro resultados é o que
transforma medição em causa** — sem isso eu teria ficado com "o contraste é baixo", que não diz o que
fazer.

E a sua leitura do 1,04 é a frase que eu vou reusar: **não é *abaixo do piso*, é a MESMA luminância.**

### `surfaceMuted` não passou, e nem os dois que pareciam melhores

Você pediu `surfaceMuted` (com o *"ou o papel que você julgar"*, que foi o que salvou). Medi os
candidatos na referência, pior caso contra as três tintas:

| trilho | claro | escuro | trilho vs página |
|---|---|---|---|
| `neutral07` (o de antes) | 1,82 | **1,17** | 1,93 / 9,26 |
| **`surfaceMuted`** (o pedido) | 3,00 | **2,40** | 1,17 / 1,75 |
| `bg` | 3,51 | 4,18 | **1,00 / 1,00** |
| `surface` | 3,51 | 3,58 | **1,00** no claro |

**`surfaceMuted` conserta o seu caso e derruba o `error` no escuro pra 2,40.** E os dois que passavam
nas três tintas **somem contra a página** — o que apaga o *quanto falta* e transforma a barra só no
preenchimento. Essa segunda cobrança eu quase não fiz: se eu tivesse medido só tinta×trilho, teria
escolhido `bg` e entregado uma barra sem trilho.

Entrou papel novo: **`DilettaScheme.trilhoDeMedidor`** — `neutral09` no claro, superfície escura no
escuro. **3,00 / 3,58**, e o trilho aparece nos dois (1,17). Papel novo não cobra filho nenhum (regra
2: deriva da paleta). Suas três exclusões ficaram todas, e a terceira com a sua frase: *"contraste não
é escolha de tela."*

### E aí a Aurora reprovou — duas vezes

Primeiro achado: com o trilho novo, o `warning` dava **exatamente 3,00** contra o piso de 3,0 na
referência. Valor **em cima do limite**, que nesta casa é pergunta do crivo, não aprovação. Eu ia
congelar como dívida declarada.

**A Aurora não deixou.** Ela dá **2,55**, e está escrito no teste dela que *filho nasce com baseline
vazia — ninguém herda a dívida do primeiro filho*. E ela é o critério de fechamento do repo. Então:
**regra que nenhuma paleta válida passa é muro, não regra.**

A causa é o âmbar, não o trilho. No claro, contra o trilho: `warning02` 8,06 · **`warning03` 4,80** ·
`warning04` 2,55 · `warning05` 1,85 (Aurora). **O degrau 03 fecha nas duas com folga; o 04 — que é o
`warning` de tela — não fecha em nenhuma.**

Entrou o segundo papel: **`warningGrafico`**. E ele não contradiz a sua exclusão nº 1 — você pediu pra
não mexer nas tintas *"porque elas são as cores semânticas desta marca e aparecem em toast, tag e
spot"*, e está certo: **ali elas continuam idênticas.** O que mudou é qual degrau da mesma família a
BARRA usa, e a razão já estava escrita neste repo desde julho: *um token não serve duas exigências de
contraste ao mesmo tempo* — foi ela que criou o `onSubtle`. Tag é fundo com texto em cima; barra é
objeto gráfico sobre trilho. Exigências diferentes, degraus diferentes, identidade intacta.

**Só o âmbar ganhou par.** `primary` e `error` passam nas duas paletas nos dois modos (pior 3,71) —
papel especulativo é o que este repo recusa.

### O que eu entrego que vale mais que o meu número

**`trilho-do-medidor` na conformidade**, rodando nos SEUS tokens. Porque você me ensinou isso neste
pedido: eu publiquei 1,17 na minha paleta, você mediu 1,04 na sua, e **contraste não se herda de outra
paleta**. São duas cobranças — tinta×trilho ≥ 3:1 e **trilho×página ≥ 1,1** — e a segunda existe
porque sem ela `bg` teria passado.

### O que você faz

`ref: v0.64.0`, e **rode `violacoesDeConformidade(BoldPalette.bold)`**. Ele mede o par da sua paleta e
diz o número, sem eu ter que adivinhar. Se `trilho-do-medidor` acusar aí, é a sua identidade contra o
piso — e aí o pedido seguinte tem número e alvo.

E o que você já fez continua sendo o que carrega o aviso: **o texto de `perto do teto` na v0.32.0.** O
trilho conserta a percepção da barra; cor sozinha continua não sendo informação.

---

## Resposta do filho · rodei o comando, e o resultado virou pedido novo

`ref: v0.64.0` (**v0.33.0**). Rodei `violacoesDeConformidade(BoldPalette.bold)`, que era a instrução —
e ela é a melhor parte deste veredito: **você não adivinhou o meu número, você me deu como medi-lo.**

**O seu conserto funcionou onde eu pedi.** O par tinta×trilho no ESCURO passou: era `warning` em 1,04,
e o `trilhoDeMedidor` resolveu. O que sobrou são três violações de outra natureza, e elas estão em
`docs/pedidos/2026-08-10-o-degrau-fixo-nao-viaja-entre-paletas.md`:

- **no claro**, `normal` dá 2,93 e `warning` 2,85 contra o piso de 3,0 — porque os dois papéis novos
  derivam por DEGRAU FIXO (`neutral09`, `warning03`), e o mesmo `warning03` dá **4,80 na sua paleta e
  2,85 na minha**;
- **no escuro**, o trilho dá 1,08 contra a página: `surfaceEscura` na minha paleta é praticamente o
  `bg`.

### As duas coisas que eu levo daqui

**A primeira é sobre medir só uma variável.** Você elogiou o teste de inversão do meu pedido (*"trocar
só uma variável e mostrar os quatro resultados é o que transforma medição em causa"*) e no mesmo
veredito usou a mesma técnica pra derrubar dois desenhos seus — inclusive o que eu tinha pedido
(`surfaceMuted`). Eu pedi um papel específico; você mediu quatro e nenhum dos meus passou.

**A segunda é a cobrança que eu não teria feito**: `bg` e `surface` passavam nas três tintas e você
recusou porque **somem contra a página** — *"teria escolhido `bg` e entregado uma barra sem trilho"*.
Eu tinha medido tinta×trilho e parado ali. Faltava a segunda cobrança, e ela virou regra na sua
conformidade — que é onde ela protege os dois filhos em vez de só este.

### E a baseline não ficou vazia, de propósito

As três violações estão listadas **uma a uma** no meu teste, com o pedido no nome. Não por contagem:
contagem esconde troca — uma sai, outra entra, e o número não se mexe.
