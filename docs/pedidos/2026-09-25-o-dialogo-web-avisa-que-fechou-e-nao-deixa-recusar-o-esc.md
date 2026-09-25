# PEDIDO · O `<diletta-dialog>` avisa que FECHOU e não deixa o consumidor recusar o `Esc` — e a adoção tirou do console o veto que ele tinha

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0`** (o arquivo é o mesmo)
- **bloqueante?**: **não** — o console contorna reabrindo; o contorno e o preço estão abaixo
- **irmão**: [o diálogo e a folha existem no Dart e não atravessam](2026-09-21-o-dialogo-e-a-folha-existem-no-dart-e-nao-atravessam.md) — o veredito dele criou esta peça

## Falta

Um jeito de o consumidor dizer «agora não fecha» antes de o `Esc` fechar o diálogo.

## Número

- `diletta-dialog.js` (`web-v2.6.0`), `:135-138`: a peça ouve o `close` do `<dialog>` nativo e emite
  `fechou` **depois** de fechado. `:139-147`: o clique no scrim tem trava (`fecha-no-scrim="nao"`).
  **Zero ocorrências de `cancel`** no arquivo, no pino e na ponta.
- O `cancel` do `<dialog>` é o evento cancelável que o navegador dispara antes de fechar por `Esc`, e
  ele nasce no `<dialog>` que mora **dentro do shadow** da peça. Pela especificação do HTML ele não
  borbulha nem atravessa a fronteira do shadow; quem está do lado de fora não o ouve. *Não provei
  isto no navegador nesta rodada* — é leitura da especificação e do arquivo, e está dito.
- No console (`core-flow-wa`, `8f7d6d2`), **8 diálogos** sobre a peça: `WaConfirmDialog` em 4 sítios
  (`AcoesDaMesa.tsx`, `DetalheDoGestor.tsx`, `EditorDePerfil.tsx`) e `WaDialogo` em 4.

## Já tentei

1. **Antes da adoção, o console tinha o veto.** O `///` do `WaConfirmDialog.tsx:38-40` registra o que
   saiu na troca: *«um `useEffect` que chamava `showModal()` com feature-detect, um `onKeyDown` para o
   `Esc` e um `onCancel` com `preventDefault`»*. O `onCancel` com `preventDefault` era o veto, e ele
   funcionava porque o `<dialog>` era nosso.
2. **Depois da adoção, reabrir.** `WaConfirmDialog.tsx:112-124`: quando `fechou` chega com a ação em
   voo, o embrulho põe `aberto` de volta — *«Em voo, a ação não se cancela: o diálogo volta a abrir»*.
   O diálogo fecha e abre de novo. Não medi no navegador o que isso faz com o foco preso e com o
   leitor de tela (a peça chama `showModal()` de novo pelo `sincroniza()`), e é essa a parte que me
   preocupa: numa confirmação destrutiva em voo, a pessoa aperta `Esc` e a interrupção recomeça.
3. **`fecha-no-scrim="nao"`** cobre o clique fora e deixa o `Esc` aberto. É a metade do veto.

É a classe que você mesmo nomeou no veredito do escape, de 22/09: *«a adoção de uma peça minha pode
REMOVER uma garantia do consumidor sem que nada acuse»*. Aqui a garantia era o veto do `Esc`.

## Conferi no pai

- `diletta_dialog.dart:88-100` (`v2.6.0`): `DilettaDialog.show(…, barrierDismissible = true)` — o
  par do `fecha-no-scrim`. O `Esc`/voltar, no Dart, o consumidor recusa pondo um `PopScope` **dentro do
  conteúdo**, que é árvore dele. **Na web o conteúdo também é dele (o slot `conteudo`), e mesmo assim
  não alcança o `<dialog>`**, porque o `<dialog>` é do shadow. É paridade de capacidade, não de peça.
- `DilettaExitConfirmSheet` (`v2.6.0`, `destino: codigo`): *«a camada que pergunta antes de perder o
  que já foi preenchido»*. A linguagem já escreveu que a guarda de saída é vocabulário dela; o que
  peço é a condição mínima para um consumidor web montar essa pergunta sobre o diálogo.
- O slot `conteudo` existe (`:127`) desde a `web-v0.114.0`, e o console o usa. O crítico de fluxo do
  bloco 6 pediu «um `WaConfirmDialog` que aceite conteúdo» — isso é nosso: a peça aceita, o nosso
  embrulho é que não expõe. Não entra aqui.

## Derivável?

Não. A decisão de fechar é tomada dentro do shadow, e o que sai para fora é o fato consumado.

## Se você disser não

O reabrir fica, com o custo não medido acima. E duas guardas que o console já decidiu que precisa
ficam sem onde morar: a janela da **senha provisória** (`AvisoDeSenhaRedefinida.tsx:60-72` — fechar sem
copiar obriga outra redefinição, e hoje o `Esc` fecha: *«esses são escolha»*), e o **rascunho de Marca**
(R4 e R7 da change `ia-da-administracao`, listados como feature seguinte).

## Não estou pedindo

1. **a forma** — um atributo irmão do `fecha-no-scrim`, um evento cancelável antes do `close`, ou
   repassar o `cancel` para fora: qualquer um serve, e escolher é seu;
2. **a folha de confirmação de saída na web** — nenhum consumidor web tem a guarda de rascunho
   ainda; quando tiver, o pedido vem com número;
3. **`erro` e `enviando` na casca** — o veredito de 21/09 já disse que são nossos;
4. **mudar o clique no scrim** — ele está certo.

## Como o pai vai saber que funcionou

No gate da peça, com `showModal` presente: o consumidor declara que não fecha, o `Esc` chega, o
`<dialog>` continua `open` e **nenhum `fechou` é emitido**. Do lado de cá: o `WaConfirmDialog` apaga o
ramo que reabre (`:116-119`) e passa a recusar o `Esc` em voo, e a janela da senha provisória ganha a
guarda que o produto quiser dar a ela.

## Como cheguei aqui

O crítico de fluxo do bloco 6 (`ia-da-administracao`, 25/09) listou «diálogo com guarda ao fechar»
entre as peças que faltam, apontando `AvisoDeSenhaRedefinida.tsx` e `DetalheDoGestor.tsx:324-327`. A
medição acima é desta rodada; o comentário do `WaConfirmDialog` sobre o que saiu na adoção foi o que
transformou o achado de «falta» em «foi tirado».
