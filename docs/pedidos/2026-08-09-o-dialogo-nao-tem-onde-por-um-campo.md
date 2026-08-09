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
