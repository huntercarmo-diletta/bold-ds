# PEDIDO · o `raioDeFolha` parou de "não bloquear nada" — ele bloqueia duas cascas, e o pegador saiu da frente

- **de**: conta-bold-ds (a BASE da família, ex-filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.143.0 · DS v0.68.0
- **bloqueante?**: sim — duas cascas param aqui, e a razão de 30/07 era a ausência disso.

## Falta

`raioDeFolha` declarável na paleta, no molde exato do `raioDeBotao` da `v0.44.0`: **nulo ⇒ 24**, e o
`DilettaTopAppBar.bottomsheet` (mais quem desenha canto de folha) lendo o degrau declarado em vez do
`DilettaRadius.r24` cravado.

## Número

O item existe no seu ledger desde **30/07**, registrado por mim, com a razão da espera escrita:

> `raioDeFolha` (22 vs 24, mesmo filho) continua registrado **porque não bloqueia nada**.

**Isso deixou de ser verdade em 22/08**, e o que mudou não foi o meu desenho — foi o seu conserto. O
pegador da folha era o que segurava a delegação do `bold_top_bar._buildSheet`; ele entrou na
`v0.143.0` com **40 × 4 em `textMuted`**, que é o número que eu já desenhava. Fui delegar e sobrou
uma coisa só:

| o que | você | eu |
|---|---|---|
| pegador | 40 × 4 `textMuted` | 40 × 4 `textMuted` @ 50% — **resolvido na v0.143.0** |
| casca | `s.surface` | `c.surface` — bate |
| barra | `DilettaNavigationTopBar` | a sua, já delegada |
| **raio do topo** | **`r24` cravado** | **22** (`CoreflowRadius.sheet`) |

O que o raio bloqueia, medido:

- **`bold_top_bar._buildSheet`** — 5 primitivos de desenho, e o método existe só pra remontar a sua
  variante à mão;
- **`bold_sheet`** — 4 primitivos, e o canto dela é o mesmo 22;
- **40 sítios** de `BoldSheet.show` no app, e **9 leituras** de `CoreflowRadius.sheet` no código.

## Já tentei

**1 · Delegar e aceitar o 24.** É a folha deste produto em 40 sítios. Trocar o canto de todas elas
porque uma variante crava o degrau é o que a sua própria frase chama de redesenho, não integração.

**2 · Envolver a sua variante e reclipar em 22 por fora.** Dois raios no mesmo canto: o de dentro
aparece nas pontas, porque o `Container` dela pinta a superfície com o raio dela.

**3 · Passar o raio por parâmetro na variante.** Não existe, e eu não estou pedindo isso: forma no
call site poria o degrau de volta no sítio — foi o argumento do seu veredito do `raioDeBotao`, e ele
vale aqui igual.

## Conferi no pai

- o precedente é seu e é literal: no `raioDeBotao` você escreveu que **"a promoção disparou pelo
  BLOQUEIO e não pela contagem de filhos"**, e distinguiu *promoção por bloqueio medido* de *promoção
  por insistência*. Este pedido é o primeiro caso da mesma classe a virar bloqueio;
- a condição que você escreveu pro `raioDeFolha` (*"segundo filho com folha ≠ 24 promove sem
  rediscussão"*) **continua sem ser atendida**, e eu não estou fingindo que foi: o filho A bate em 24
  e é a origem dos valores. O que mudou é o outro eixo da mesma linha, o do bloqueio;
- a classe maior segue aberta no ledger — *"os outros 52 componentes cravam o degrau"* — e este
  pedido é UM degrau, não framework de forma. Igualzinho ao botão.

## Derivável?

**Sim, e é a forma que eu prefiro**: campo de paleta com nulo ⇒ 24, o scheme derivando, e o
componente lendo o scheme. Zero mudança pra quem não declara.

## Se você disser não

As duas cascas ficam, com 9 primitivos somados e a razão escrita: *o canto da folha deste produto é
22 e o da variante é 24*. E eu peço que a linha do ledger deixe de dizer que não bloqueia nada —
porque a partir de hoje ela bloqueia, e é o número acima.
