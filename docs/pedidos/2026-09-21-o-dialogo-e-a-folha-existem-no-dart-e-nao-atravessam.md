# PEDIDO · O diálogo e a folha existem no Dart e não atravessam para a web

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — o consumidor tem a peça dele, construída sobre o `<dialog>`
  nativo, e ela funciona. É paridade que falta, não função.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), terminando a adoção do
> DS: ele foi listar o que ainda é peça local e por quê. Irmão do pedido de hoje sobre o
> campo de seleção — mesma forma, peça que não existe do lado web.

## O caso

Confirmar uma ação destrutiva é o momento mais sensível de um console administrativo, e a
superfície que o faz não tem instância web na família.

**E não é que a família não tenha resolvido isso.** O `///` do
`coreflow_folha.dart` declara os DOIS, em uma frase:

> *«BottomSheet (organismo). O CONTAINER de sheet que faltava: o
> `[CoreflowBarraDeTopo.sheet]` só dava o cabeçalho e **o `Dialog` do app é modal central**.»*

Então existem a folha ancorada no rodapé (com grip, scrim, cantos superiores) e o diálogo
modal central. Nos **25 elementos web**, nenhum dos dois. Procuramos por `dialog`, `modal`,
`sheet`, `popover` e `overlay`.

O token da forma dela, esse atravessou: `--diletta-formaDeFolha: 22px` está publicado, e
não há peça que o leia. Token sem consumidor é o sintoma que esta casa já nomeou.

## Onde isso dói, medido

No webadmin: **14 usos** em 3 telas, e todos são ação que não volta atrás — revogar acesso
de gestor, recusar KYC, desligar botão publicado.

## O que a nossa peça faz, para o pedido não pedir menos

`WaConfirmDialog` é construído sobre o `<dialog>` NATIVO, e a escolha está no `///` dela:
`showModal()` prende o foco e dá `Esc` de graça no navegador — comportamento que uma
div-com-overlay reimplementa mal e quase sempre incompleto.

Além do que a folha do Dart já tem, ela carrega três coisas que nasceram do domínio:

| o que | por quê |
|---|---|
| `perigo` | o botão de confirmar muda de tinta quando a ação é destrutiva |
| `exigirMotivo` | campo de texto obrigatório cujo conteúdo vai para a TRILHA DE AUDITORIA. A obrigatoriedade mora no componente, e não em cada tela que abre um diálogo perigoso |
| `erro` + `enviando` | o erro do servidor aparece DENTRO do diálogo, e ele nunca fecha por causa do erro |

Os dois primeiros provavelmente são do filho, não da linguagem — `exigirMotivo` é regra de
console de banco. O que pedimos é a CASCA: o modal central com foco preso, scrim, `Esc`, e
os slots de título, corpo e ações.

## O pedido

Um `<diletta-dialog>` (modal central) e, se couber na mesma rodada, um `<diletta-sheet>` —
a instância web do `coreflow_folha`, que já existe no Dart e já tem o token de forma
publicado.

**Sobre a base**: se a instância web for construída sobre o `<dialog>` nativo, ela ganha
foco preso e `Esc` do navegador, sem reimplementar. Medimos isso aqui, e é a razão de a
nossa peça ser assim.

**Uma ressalva que vale mais que o pedido**, e que vem da nossa experiência com o
`<diletta-status-tag>`: peça com foco preso dentro de shadow root precisa que o
`attributeChangedCallback` não reescreva o shadow a cada atributo — senão o elemento que
tinha o foco deixa de existir no meio da interação. É o mesmo defeito do pedido
`2026-09-20-cada-atributo-redesenha-o-shadow-inteiro`, e num diálogo ele não é lentidão:
é a pessoa perdendo o foco dentro de uma confirmação de ação destrutiva.

## A forma que estes três casos compartilham

É o terceiro em quatro dias — o `DilettaStepper` que o IB reportou em 17/09, o campo de
seleção de hoje, e este. Nenhum é «recurso que ficou para trás dentro de uma peça»: são
**peças que nunca saíram**. E os três só apareceram quando um filho tentou trocar tudo e
listou o que sobrou.

O inventário é barato: os 25 elementos contra as peças locais de cada filho, com a razão
escrita de cada sobra. Se a casa quiser, mandamos o do webadmin como molde.
