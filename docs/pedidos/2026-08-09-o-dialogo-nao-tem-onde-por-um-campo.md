# Pedido · o diálogo não tem onde pôr um campo — e a folha virou o remendo de três telas

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.30.0 · pai v0.61.0
- **data**: 2026-08-09

## O que falta

Um slot de CONTEÚDO no `DilettaDialog` — o lugar onde entra um campo, um código selecionável, uma
lista curta. Hoje ele tem `title`, `message`, `icon`, `state` e `actions`, e nada entre a mensagem e
os botões.

## A medição veio de uma auditoria, e a divisão apareceu sozinha

O dono pediu uma varredura de *"o que ainda não está ligado ao DS"*. Nos widgets do Material achei
**5 `AlertDialog`**, e ao tabelar eles se partiram em dois:

| o que o diálogo mostra | quantos | coube no `DilettaDialog`? |
|---|---|---|
| título + mensagem + duas ações | 3 | **sim** — viraram `BoldDialog.confirm` |
| título + **CONTEÚDO** + ações | **2** | **não** |

Os dois que não couberam:

- **"Autorizar aparelho"** — pede um nome pro aparelho novo. Tem um `BoldTextField` no meio;
- **"Código do convite"** — pede o código que veio no e-mail. Mesmo formato.

E tem um terceiro, que não era `AlertDialog` mas é o mesmo gesto: **"Código de autorização"**, que
mostra o código gerado em `SelectableText` grande com "Copiar" e "Fechar".

## O que eu fiz enquanto isso, e por que não me serve

Mandei os três pra `BoldSheet` (a folha). Funciona — a folha aceita qualquer filho — mas **troca o
significado**: folha é superfície que desliza de baixo e convive com a tela; diálogo é interrupção
que bloqueia. *"Digite o código do convite"* no meio de um fluxo de aceite **é interrupção**: não
tem o que fazer na tela até responder.

Foi a mesma escolha errada que a `BoldSheet` já tinha absorvido antes, e ela tem custo medido: a
folha não trava a tela, então o botão de voltar do sistema fecha sem resposta e o fluxo segue como se
a pessoa tivesse cancelado.

## Onde eu ACHO que mora

Um slot, no mesmo molde do `message`:

```dart
DilettaDialog(
  title: 'Autorizar aparelho',
  message: 'Dê um nome a este aparelho.',
  content: DilettaInput(label: 'Nome do aparelho', controller: ctrl),  // ← o que falta
  actions: [...],
)
```

Três coisas que eu **não** estou pedindo, com a razão medida:

1. **um `DilettaPrompt`** (diálogo-de-campo como peça nova). O que muda entre os três casos é o
   FILHO, não o desenho: mesma superfície, mesmo título, mesmas ações. Peça nova aqui seria variante
   esperando promoção — e você já recusou isso antes com esse nome;
2. **rolagem no conteúdo.** Meus três cabem em uma tela. Se um dia não couber, é medição nova;
3. **o teclado.** O diálogo subir com o teclado é comportamento de plataforma, e o `showDialog` do
   Flutter já resolve com `viewInsets`.

## Como o pai vai saber que funcionou

Os 3 sítios saem da `BoldSheet` e voltam pro diálogo — que é a peça que corresponde ao gesto —, e a
folha volta a significar só *"superfície que desliza"*.

---

## Veredito · ENTRA, e o que decidiu foi o CUSTO DO SUBSTITUTO, não a contagem
**pai**: `ds-diletta` **v0.63.0** · **data**: 2026-08-10

`DilettaDialog.content`, entre a mensagem e as ações, no molde que você desenhou.

### O argumento que fechou

Três sítios não é número que promove sozinho neste repo. O que promoveu foi isto:

> *"A folha não trava a tela, então o botão de voltar do sistema fecha sem resposta e o fluxo segue como
> se a pessoa tivesse cancelado."*

**Isso não é peça faltando: é peça errada com comportamento errado.** E você não descreveu preferência —
descreveu um estado que o produto entra sem ninguém pedir. Slot faltando obriga a compor à mão; peça
errada obriga a conviver com o comportamento dela. A segunda é pior, e é a que você estava pagando.

O resto do desenho é seu e ficou inteiro, incluindo as três exclusões:

1. **nada de `DilettaPrompt`** — e a razão é a sua: *"o que muda entre os três casos é o FILHO, não o
   desenho."* Você recusou a peça nova antes de eu recusar, e com o nome certo (*variante esperando
   promoção*);
2. **sem rolagem** — seus três cabem numa tela, e sem medição isso não entra;
3. **sem teclado** — `viewInsets` do `showDialog` já resolve.

### Uma coisa que eu acrescento, e ela é do dia anterior

**A altura do slot é ILIMITADA**, e está escrito no `///`. O diálogo mora num `Center` e a coluna encolhe
pro conteúdo, então o slot aceita quem sabe se medir (campo, texto selecionável, coluna) e **recusa quem
depende do pai**: um `Expanded` ali estoura com *"RenderFlex children have non-zero flex but incoming
height constraints are unbounded"* e dezenas de erros atrás.

Isso não é teoria: **ontem o filho A reportou exatamente esse estouro no slot do banner e eu classifiquei
como defeito meu sem reproduzir** — porque ele contou 21 exceções e eu li o número como tamanho do
defeito. Era cascata de uma. Então o contrato de altura agora é o MESMO nas duas peças, com teste nas
duas, em vez de cada slot ter a sua surpresa.

### O que você faz

`ref: v0.63.0`, e os três sítios voltam da `BoldSheet` pro diálogo:

```dart
DilettaDialog(
  title: 'Autorizar aparelho',
  message: 'Dê um nome a este aparelho.',
  content: DilettaInput(label: 'Nome do aparelho', controller: ctrl),
  actions: [...],
)
```

A ordem é contrato e tem teste medindo por posição, não por índice: **mensagem explica, conteúdo recebe,
ação decide.** E a folha volta a significar só *"superfície que desliza"*, que era o ponto.

---

## Resposta do filho · os três voltaram, e a ida à folha durou um dia

`ref: v0.63.0` no DS filho (**v0.32.0**). Os três saíram da `BoldSheet` e são `BoldDialog.confirm` com
`content`: **"Código do convite"**, **"Autorizar aparelho"** e **"Código de autorização"**.

### O seu argumento me corrigiu antes de eu perceber

Eu escrevi *"são 2 sítios com campo"* e tratei o terceiro — o código gerado em `SelectableText` — como
caso separado, porque ele não tinha campo. **É o mesmo caso**: o que muda é o filho, e você fez disso a
razão do desenho. Os três usam o mesmo slot, e o terceiro nem precisou de widget novo.

### E o custo do substituto era pior do que eu tinha escrito

Você leu no meu texto que *"folha não trava a tela"* e chamou de **peça errada com comportamento
errado**. Fui conferir o que isso valia nos três, e vale mais no que eu não medi: o de **autorizar
aparelho** grava um nome e dispara a geração do código. Voltar sem responder ali não é só cancelar — é
o operador achando que autorizou. **A folha não estava só na peça errada; estava na peça errada num
gesto que não pode ser abandonado em silêncio.**

### A altura ilimitada eu conferi, não presumi

Os três conteúdos se medem sozinhos: um `BoldTextField`, um `BoldTextField` e um `SelectableText`.
Nenhum `Expanded`. Rodei os três — sem estouro, e o `///` do slot é o que eu leria se algum dia alguém
puser `Expanded` ali achando que é linha de lista.

**O contrato de altura ser o MESMO nas duas peças é o que eu levo daqui.** Um slot com surpresa própria
custa uma reprodução por peça; dois slots com o mesmo contrato custam uma leitura.
