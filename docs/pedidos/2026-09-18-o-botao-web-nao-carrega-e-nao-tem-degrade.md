# PEDIDO · Dois estados do botão existem no Dart e não atravessam — e um deles é 29 ações assíncronas

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.199.0` · `web-v0.199.0`
- **bloqueante?**: **sim, para a adoção do botão** — 138 usos em 40 arquivos, a peça mais usada do
  produto. O `formAssociated` e o `acao` que você entregou na `v0.199.0` destravaram os 22 envios;
  o que segura agora são estes dois.
- **classe**: a quinta vez. É a mesma de `formAssociated`, do modo escolhível do chip, do badge do
  spot e do `DilettaStepper`: **existe do lado Dart e o lado web não carrega**.

## Falta

O `<diletta-button>` não tem estado de CARREGANDO nem versão DEGRADE, e o `DilettaButton` tem os dois.

## Número

**138 usos em 40 arquivos.** Destes:

| o que usamos | em quantos | o elemento tem? |
|---|---|---|
| `onClick` | 104 | — |
| `variant` | 87 (ghost 72 · primary 52 · destructive 11 · **accent 3**) | os três primeiros sim |
| `type="submit"` | 22 | **sim, desde a v0.199.0** |
| **`loading`** | **29** | **não** |
| `leading` | 22 | sim (`slot name="lead"`) |

### CASO 1 · carregando — 29 botões, em 16 telas

```dart
// DilettaButton
/// Mostra spinner (three-bounce) e bloqueia o toque, mantendo a cor do tipo.
final bool isLoading;
```

No elemento web: `grep -ciE 'loading|spinner|carregando' src/diletta-button.js` devolve **zero**.

**Onde isso vive aqui**: 16 telas, e a concentração conta a história — 6 na de operadores, 3 no
envio de Pix, 3 nas chaves, 2 em beneficiários, 2 no recebimento, 2 nos perfis. **Todos são ação
assíncrona**, que é exatamente o lugar onde a pessoa clica de novo se nada responder. Num banco,
clicar duas vezes em «Transferir» não é detalhe de acabamento.

O app foi além do avô e tem a razão escrita: `onPressedAsync`, com `_running` como *«fonte da trava
e do loading»* e um comentário de reentrada — `if (_running) return null`. Ou seja: **os dois lados
do Dart trataram isto, e cada um à sua maneira**; só a web ficou sem.

**Por que não contorno por fora**: o rótulo é ATRIBUTO e o `<button>` é do shadow. Trocar o rótulo
por um spinner mantendo a largura exigiria desenhar por cima do shadow — a mão que esta casa recusou
três vezes, e que na quarta você mesmo mostrou ser pior do que parecia (o remendo do `submit`
consertaria o clique e deixaria o teclado quebrado).

**O pedido**: um atributo de carregando, com o spinner e a trava de toque que o `///` do Dart já
descreve. Se o `three-bounce` não tiver instância web, a forma é sua — o que eu preciso é do ESTADO.

### CASO 2 · degrade — 3 botões, e talvez seja meu

```dart
/// Versão DEGRADE (brandLift, o azul mais forte) — vale pra todas as hierarquias:
/// primary = fill gradient · secondary(s) = border + label gradient ·
/// tertiary(s) = label gradient. Ignorado em disabled/error.
final bool gradient;
```

No elemento: `grep -c 'gradient' src/diletta-button.js` devolve **zero**. Os oito valores de `type`
não incluem nenhum degrade.

Aqui eu pergunto em vez de pedir, porque **a resposta pode ser que é meu**. O nosso são 3 botões
pintados com `--cps-gradiente-primary`, que é token DESTE produto — e você já respondeu uma vez, em
17/09, que cor de marca sem papel **MORA NO SEU DS**. Se o degrade do botão for a mesma classe, eu
aceito e escrevo a razão no `///` da peça.

O que me faz perguntar mesmo assim é o `///` acima: ele declara o degrade como **eixo que vale para
todas as hierarquias**, com regra por hierarquia e exclusão em `disabled/error`. Isso é gramática de
componente, não tinta de produto — e gramática é sua. Se for eixo, ele atravessa; se for tinta, o
gradiente é meu e o eixo não existe.

## Já tentei

**Trocar só os 109 botões sem `loading`.** Recusado: parte a peça em duas pelo mesmo critério que eu
recusei no cartão de arquivo há dois dias — a fronteira não seria de desenho, seria de quem
implementou o quê. E deixaria as 16 telas mais delicadas do produto com a peça antiga.

**Pintar o degrade por fora**, no hospedeiro. Funciona para o `type=primary` e mente nos outros: o
`///` do Dart diz que em `secondary` o degrade vai na BORDA e no RÓTULO, não no fundo. Reproduzir
isso aqui seria manter uma cópia da regra — a coisa que a adoção veio acabar.

**Deixar o `loading` com o `disabled` só.** É o que sobra sem spinner, e não serve: `disabled`
diz «não pode», carregando diz «estou indo». A pessoa lê as duas coisas de formas diferentes, e a
segunda é a única que explica por que o botão parou de responder.

## Conferi no pai

Fui escrever que faltava estado no elemento e parei no seu `///` do `formAssociated`, escrito há um
dia: *«quem pede o tipo pede o comportamento»*. É o mesmo raciocínio aqui — `loading` não é
aparência, é comportamento (trava o toque), e por isso ele não cabe num eixo de tinta.

Li também a sua tabela de eixos. O `Interacao` tem `normal · hover · pressed · disabled`, e é
tentador enfiar `loading` lá. **Não peço isso**: `disabled` e `loading` podem coexistir num mesmo
instante — um botão que carrega ESTÁ desabilitado —, e dois estados no mesmo eixo não coexistem. Se
for eixo, é eixo próprio; se for booleano, melhor ainda.

## Derivável?

**O caso 1, não.** Não sai de nada que eu declare. É estado novo, com comportamento (trava) e forma
(spinner).

**O caso 2, talvez inteiro** — se a resposta for que o degrade é tinta minha, ele sai do meu
`--cps-gradiente-primary` e não preciso de nada seu.

## Se você disser não

Aos dois: o `BoldButton` fica local, e com ele **a peça mais usada do produto** — 138 usos. É a
maior das que ficam, e a que mais me custa, porque ela já está a uma lacuna de distância: você
entregou o `formAssociated` ontem e os 22 envios voltaram a funcionar.

Ao caso 1 só: fico local do mesmo jeito. Não dá para adotar um botão que não sabe dizer «estou
indo» em 16 telas de dinheiro.

Ao caso 2 só: **adoto**, com o degrade desenhado aqui e a razão escrita — e aí o `accent` vira
variante local declarada, não divergência.

## Não estou pedindo

1. **O `three-bounce` do Dart.** A forma do spinner é sua; eu preciso do estado. Se a web resolver
   com outro movimento, melhor — é o que o seu veredito das curvas já decidiu;
2. **`onPressedAsync`.** A trava de reentrada do app é conveniência de Flutter; na web quem segura
   a promessa é o consumidor. Eu só preciso que o botão não aceite clique enquanto carrega;
3. **um eixo `loading` dentro de `Interacao`** — ver acima, eles coexistem;
4. **nada sobre `state=error`.** Ele cobre o meu `destructive`, e cobre bem.

## Como o pai vai saber que funcionou

```
<diletta-button carregando>  →  o botão interno tem `disabled` E `aria-busy="true"`
                             →  o clique NÃO dispara o evento
                             →  a largura não muda entre carregando e parado
```

A terceira linha é a que eu mais quero: o `///` do Dart diz *«mantendo a cor do tipo»*, e o irmão
disso na web é **manter a largura** — botão que encolhe ao carregar move a tela inteira embaixo dele.

E, se o degrade entrar como eixo, o gate que eu escreveria é o do próprio `///`: em `primary` o
degrade está no FUNDO, em `secondary` na BORDA e no RÓTULO, e em `disabled` ele não aparece. Três
asserções, uma por hierarquia — porque é aí que uma cópia divergiria sem ninguém ver.
