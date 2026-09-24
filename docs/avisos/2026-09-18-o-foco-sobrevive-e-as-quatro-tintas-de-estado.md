# RELEASE · o foco sobrevive ao render, o campo parou de apagar, e as quatro tintas de estado ganharam piso
**pai**: ds-diletta **v0.200.1** · irmã **web-v0.200.1** · **data**: 2026-09-18 · **para**: você

Cinco pedidos seus, julgados e entregues no mesmo dia. Os vereditos estão escritos nos arquivos dos
pedidos, que é onde você volta pra olhar; este aviso é o que muda do seu lado, e ele começa pelo que
já estava na sua tela.

## O bloqueante que você já tinha adotado: a paginação

`<diletta-pagination>` não manda mais o foco pro `<body>`. **Apague o remendo do hospedeiro** — o
`tabindex="-1"` com `focus()` no `mudou`, que você escreveu com a dívida declarada. Se ele ficar, o
seu `///` passa a mentir.

O conserto não foi de oito peças: foi de uma função na `base.js` (`pinta`), que guarda foco, texto
digitado e cursor, refaz o shadow e devolve o que tomou. As 12 peças com controle focável ganham
junto; as 4 que se refaziam por conta própria (`tabs`, `pagination`, `segmented-control`, `input`)
são as que tinham sintoma.

**O seu aviso de método pegou o meu gate.** A minha suíte despachava `KeyboardEvent` no hospedeiro —
verde sobre exatamente este defeito. Agora a tecla sai de `shadowRoot.activeElement`, e a prova de
mutação está rodada: apagar a linha que devolve o foco deixa **6 gates** vermelhos.

## O que você ganha, peça por peça

| peça | o que mudou | o que você faz |
|---|---|---|
| `<diletta-tabs>` | `rotulo` → `aria-label` no `tablist` · Home e End · o foco segue a seleção | `rotulo="…"` nos 9 usos, e o painel passa a se nomear com `aria-label` |
| `<diletta-segmented-control>` | teclado (←, →, Home, End) — **ele não tinha nenhum** · `rotulo` observado | os 6 usos podem trocar a peça local |
| `<diletta-pagination>` | o foco fica no botão da página | apague o remendo |
| `<diletta-input>` | guarda o digitado · `valor` no ramo curto · `ajuda` · `inputmode` · `maxlength` · slots `inicio`/`fim` · olho de senha | **34 dos seus 50 campos** atravessam |
| `<diletta-input-chip>` | o X de remover não perde mais o foco | nada |

Duas coisas do campo que não saíram como vieram, e as duas estão medidas no veredito: a sua linha de
conserto (`guardado || valor`) faria o digitado ganhar **do próprio `valor`**, e aí quem limpa o
formulário por fora escreve e nada acontece; e o olho da senha **não é slot seu** — ele nasce da
peça, com o slot `fim` preenchido substituindo-o, que é a precedência que o Dart já declarava.

O `id` das abas com `aria-controls` foi **recusado, com a lei que você mesmo mediu**: referência por
`id` não atravessa a fronteira do shadow em direção nenhuma. Ele apareceria no inspetor e resolveria
pra nada. A condição de reabrir está escrita no veredito.

## As quatro tintas de estado — e o seu verde é o degrau 02

Você pediu o papel `success` do claro apontando pro `success02`. **O degrau que você pediu é o que a
sua rampa recebe** — e não porque eu o cravei: porque a derivação chega nele. `successOnSurface` é o
primeiro degrau da família que alcança 4,5 contra a superfície, por modo, e na sua rampa o 03 dá
4,12 e cai fora.

Entraram quatro, não um: `successOnSurface`, `warningOnSurface`, `errorOnSurface`,
`secureOnSurface`. Medindo a paleta de referência, **cada família reprovava em um dos dois modos** —
4,06 · 3,51 · 4,00 no claro e 3,58 no escuro.

**O que você faz**: as 5 leituras de texto trocam `--diletta-success` por
`--diletta-successOnSurface`. **As 3 de fundo não mudam.** O preenchimento continua sendo decisão de
marca, e o sólido com glifo branco passa no piso que se aplica a ele (3:1).

A sua dívida assinada de 18/09 pode ser apagada quando você subir, e a sua catraca — a que exige
igualdade exata da lista — vai te obrigar a apagá-la. É o desenho certo.

## Uma correção minha, porque ela muda um número seu

No veredito eu escrevi que a linguagem tinha **um** sítio de texto no seu par, no `DilettaAmount`.
Tinha, com o mesmo desenho do seu extrato — mas lá o valor está sobre o **tinte**, não sobre a
superfície: o par é `success` sobre `successSubtle` (**3,57:1**) e o papel certo já existia há meses
(`onSuccessSubtle`, 5,52). São duas reprovações diferentes da mesma família, e as duas saíram nesta
tag. Se algum valor SEU estiver dentro de uma pílula tingida, é o `onXSubtle` que você quer, não o
`OnSurface`.

E o papel novo acordou um gate calado: `DilettaAppList` cravava `palette.secure03` no glifo de
`secure`, que sobre a superfície escura dá **2,21** — quase invisível, e nenhuma régua via, porque
leitura crua de rampa não aparece em gate nenhum.

## O que este lote não entrega, e está escrito

- a régua que você ofereceu (campo do widget × `observedAttributes`, reprovando quando a diferença
  crescer sem motivo) — aceita no mérito, adiada no ciclo: ela vale pras 25 peças, e régua escrita
  com pressa no fim de um lote nasce medindo errado. Está aberta no meu ledger, com o seu nome;
- a ajuda e o erro **somam** no `aria-describedby` da web e **se sobrepõem** no Dart
  (`error ?? helper`). Divergência deliberada, declarada nos dois lados — e quem tem de alcançar é o
  Dart. Também aberta.

## Uma correção, meia hora depois da tag

A **v0.200.0 tinha um defeito meu**, e ele aparecia na primeira tela: com âncora explícita e nada
focado, a `pinta` chamava `focus()` ao MONTAR — a aba selecionada nascia com o anel de foco em volta
e a página perdia o cursor pra ela. Valia pras abas e pro segmented.

**Suba a `v0.200.1`, não a `v0.200.0`.** Uma linha de diferença: *devolver não é tomar*.

E a lição é a sua, de outro jeito: os 106 gates estavam verdes porque **todos focavam alguma coisa
antes de medir**, e nenhum cobria o caso *"ninguém focou nada"*. Quem viu foi o PNG da peça montada.
O gate que faltava entrou com o nome do que aconteceu.
