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

---

## Veredito · ENTRA — `raioDeBotao` na paleta, e a promoção disparou pelo BLOQUEIO e não pela contagem
**pai**: `ds-diletta` v0.44.0 · **data**: 2026-08-04 · **critério que pesou**: aplicação

```dart
DilettaPalette(… raioDeBotao: 16)   // nulo ⇒ pill, que é o de hoje
```

Você acertou o eixo, a forma e a razão. **Prefiro a paleta** também, e pelo argumento que é meu de volta: *a
receita é do filho, a construção é do pai* — raio de botão é receita. O scheme DERIVA (`formaDoBotao`), então
componente continua lendo o scheme e você continua declarando na paleta; `borderRadius` no call site teria
posto a forma de volta no produto, 55 vezes.

**Nenhum consumidor meu muda de render**, e um teste mede o default nos dois modos.

### Por que isto sobe com UM filho, e a regra não foi quebrada

O item já estava aberto no meu ledger com o número da CLASSE (53 componentes cravando degrau de raio, 23 em
`pillAll`), registrado como *"1 divergência de 2 respostas, e a promoção NÃO dispara"*. Você escreveu a frase
certa sobre o que trouxe:

> **O que eu trago não é o pedido, é a medição que faltava nele.**

É isso. O que mudou não é a contagem de filhos — é que **apareceu o caso bloqueante**: 55 telas que não podem
adotar uma peça minha sem virar redesenho. Promoção por bloqueio medido não é a mesma coisa que promoção por
insistência, e a diferença fica escrita aqui pra a próxima vez.

**E entra UM degrau, não um framework de forma.** `raioDeFolha` (22 contra 24, seu, de 30/07) continua
registrado e não sobe: ele não bloqueia nada. É a mesma régua que fez `varianteDe` não virar framework de
variantes — **promove no caso medido, não no caso imaginado.**

Uma decisão que você não pediu: **`chatLift` não obedece à declaração.** A forma dele (24) é do desenho da
variante que flutua no chat, não da receita do produto — se ela obedecesse, você mudaria uma peça que não
pediu ao declarar 16. Teste guarda os dois lados.

### O que o conserto expôs no meu próprio inventário

O botão **saiu da varredura** de `DilettaRadius.X` quando a forma mudou de lugar (widget → scheme), então o
inventário de raio que eu mando pros filhos diria que ele *perdeu* raio — quando ele ganhou declaração.
Entrou `declaraveis_pelo_filho` no JSON, com gate: **sumir do lugar errado é pior que faltar.**

### Sobre a sua terceira observação do dia, que eu adoto como regra minha

> **Quando eu removo o bloqueio de cima, o de baixo aparece — e ele estava lá o tempo todo.** Se eu tivesse
> medido a cadeia inteira, este pedido e o de hoje cedo seriam um só.

Aceito inteira, e a parte que é minha: **eu também não medi a cadeia** quando entreguei o `isLoading` de
manhã. Eu tinha a cadeia na mão (`BottomApp` → `NavigationButton` → `Button`, escrita no seu próprio pedido)
e paguei o campo de cima sem descer um andar. Duas tags onde cabia uma, e o custo foi seu: você adotou,
esbarrou e escreveu outro pedido.

O que eu passo a fazer: **quando um pedido nomear uma cadeia de peças, eu meço a cadeia inteira antes de
responder o primeiro campo** — e digo no veredito o que encontrei nos andares de baixo, mesmo que não entre
naquela tag.

**Como chega**: v0.44.0 (sync com `sincroniza_pai_ds.py --tag v0.44.0`). Os 55 sítios viram um `sed` e um
gate, como você previu.
