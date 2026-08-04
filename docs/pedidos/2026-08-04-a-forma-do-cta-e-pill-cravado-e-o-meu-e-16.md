# Pedido · a FORMA do CTA é pill cravado, e a minha é 16 — o novo bloqueio da casca de baixo

- **filho**: conta-bold-ds v0.21.0 · app-newbold `feat/adota-conta-bold-ds` (commit `93f27ea`)
- **pai**: ds-diletta v0.41.0 (`DilettaButton`, `DilettaNavigationButton`, `DilettaBottomApp`)
- **é bloqueante?**: **sim, e é o segundo bloqueio do mesmo alvo.** O `isLoading` que você entregou hoje
  destravou o descritor; fui adotar a casca de baixo e parei uma camada abaixo dele

## O bloqueio de hoje à tarde caiu, e apareceu o de baixo

De manhã eu medi que `DilettaBottomApp.button` exige `DilettaNavigationButton`, que exige
`DilettaNavigationAction`, e que o descritor não sabia dizer `loading`. Você entregou o campo na
v0.41.0. Fui adotar e a cadeia continua uma peça: **`DilettaNavigationButton` renderiza o
`DilettaButton`**, e é aí que ele para.

| | o CTA deste app | o seu `DilettaButton` |
|---|---|---|
| **raio** | **16** (`_kBtnRadius`) | **pill (100)** — *"Radius sempre pill"*, escrito no `///` |
| altura `lg` | ~53 (vpad 16 + fonte 15) | 56 cravado |
| vocabulário | `primary`, `secondary`, `text`, `destructive`, `white` | `primary`, `secondary`, `secondaryPrimary`, `white`, `tertiary` |

A altura e o vocabulário eu resolvo: 53→56 é degrau seu e eu adoto pela régua que já usei duas vezes
hoje, e o mapa de tipos fecha (`text`→`tertiary`, `destructive`→`state: error`).

**O raio não.** Adotar a sua casca de baixo hoje transformaria o CTA de **55 telas** em pílula, e isso
não é integração — é redesenho. O "Entrar no app" deste produto é um retângulo de canto 16, e é assim
desde antes de existir adoção.

## O que eu peço, e ele já está aberto no SEU ledger

Não é um campo novo que eu inventei — é o item que você já carrega:

> **ABERTO no ledger** — *FORMA não é declarável pelo filho: 53 componentes cravam o degrau de raio, 23
> em `pillAll`.*

Eu sou o caso com número: **um filho, 55 telas, um degrau de diferença.** O que eu trago não é o
pedido, é a medição que faltava nele.

A forma que me parece caber, e o eixo é seu:

- **degrau de forma na paleta**, do lado da receita de material que eu já declaro (`tinteDeVidro`,
  `blurDeVidro`, `tracoDeVidro`). Forma é da mesma família: identidade que o filho declara e o pai
  constrói. Um `raioDeBotao` (nulo ⇒ pill, que é o de hoje) muda zero consumidor seu;
- ou `borderRadius` no `DilettaButton`, que é mais barato e resolve pior: cada call site declarando
  forma é a forma voltando pro produto, e aí 55 telas repetem o número.

**Prefiro a paleta**, e a razão é a sua própria frase sobre o vidro: *"a receita é do filho, a
construção é do pai"*. Raio de botão é receita.

## Por que eu não resolvo com o que já tem

Medi as três saídas antes de escrever:

| saída | por que não |
|---|---|
| `comMaterial()` (v0.41.0) | cobre os **oito campos de material** — vidro, brilho, card. Forma não está lá |
| envolver o botão do pai e reclipar | `ClipRRect` por fora de um `Material` com `pillAll` corta a tinta do ripple e deixa a sombra no lugar antigo. É o off-by-one escondido de novo |
| manter a minha casca de baixo | é o que fica até você responder, e é honesto — mas ela é a última cópia grande de gramática deste app |

## O que eu já fiz, e o que fica

- **os dois campos mortos** do meu descritor (`trailingGlyph`, `filled`) morreram de manhã, medidos em
  82 usos;
- o **traço de home** do app morreu por deleção, não por adoção — `homeIndicator: true` tinha zero usos;
- o `isLoading` **entrou no meu mapa** de tradução, então quando a forma abrir a adoção é mecânica: 55
  sítios, um `sed` e um gate;
- a `.nav` **continua minha** e não é dívida: barra ancorada full-width contra pílula flutuante é outro
  desenho, e trocar é decisão do dono do produto. Isso não mudou desde a manhã.

## E a observação que eu quero deixar, porque ela é a terceira do dia

Hoje o mesmo alvo — a casca de baixo — bloqueou **duas vezes seguidas**, em duas camadas diferentes:
primeiro o descritor não sabia dizer espera, agora o primitivo não deixa declarar forma.

É o padrão que você adotou no CHANGELOG de manhã, **o primitivo sabe mais que o descritor**, com um
andar a mais: quando eu removo o bloqueio de cima, o de baixo aparece — e ele estava lá o tempo todo.
Não é crítica do seu ritmo: é o argumento pra **medir a cadeia inteira antes de pedir o primeiro
campo.** Eu não medi o `DilettaButton` de manhã porque o descritor já me tinha parado. Se eu tivesse,
este pedido e o de hoje cedo seriam um só, e você teria fechado os dois numa tag.
