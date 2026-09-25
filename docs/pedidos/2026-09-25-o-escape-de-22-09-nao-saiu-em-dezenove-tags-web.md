# PEDIDO · O escape que ENTROU em 22/09 — o único que você chamou de segurança — não saiu em dezenove tags web, e a cobrança de ontem não o contou

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido na `web-v2.6.0`**
- **bloqueante?**: **não para entregar tela** — o console escapa por fora, em seis embrulhos. É cobrança de ENTREGA (critério 5), como a de 24/09
- **irmão**: [o rótulo entra CRU no `innerHTML`](2026-09-21-o-rotulo-do-botao-entra-cru-no-html.md) — é dele o veredito; este arquivo não o reabre

## Falta

A entrega do veredito ENTRA de 22/09 sobre valor cru no `innerHTML`.

## Número

- **Dezenove tags web** cortadas depois do veredito, de 22/09 a 24/09: `web-v0.207.1` · `web-v0.208.0`
  · `web-v0.208.1` · `web-v0.209.0` · `web-v1.0.0` · `web-v1.0.1` · `web-v1.0.2` · `web-v1.1.0` ·
  `web-v2.0.0` · `web-v2.0.1` · `web-v2.1.0` · `web-v2.2.0` · `web-v2.2.1` · `web-v2.3.0` · `web-v2.4.0`
  · `web-v2.4.1` · `web-v2.4.2` · `web-v2.5.0` · `web-v2.6.0`.
- `src/base.js` (`web-v2.6.0`): **nenhuma função de escape**. A única ocorrência de «escap» é um
  comentário sobre `CSS.escape` (`:191`). O veredito prometia *«a separação "o que veio de fora" × "o
  que a peça escreveu", numa função da `base.js`»*.
- Valor de atributo interpolado cru, na mesma tag (leitura da fonte, não execução):
  `diletta-button.js:120-121` (`rotulo`), `diletta-dialog.js:125-126` (`titulo`, `mensagem`),
  `diletta-segmented-control.js:63` (cada segmento), `diletta-breadcrumb.js:53-54` (`rotulo` do nível).
- O **seu** ledger (`docs/PEDIDOS.md` do `ds-diletta`, `origin/main`, a linha de 22/09 deste assunto)
  ainda diz, na coluna de entrega: *«entrega prevista na v0.208.0, tag ainda NÃO cortada»*. A
  `v0.208.0` foi cortada em 22/09; depois dela vieram mais dezoito.
- A resposta à cobrança de 24/09 (*o loop de adoção do filho B parou*) contou **dois** `ENTRA` de
  22/09 sem tag — o porte do campo e o campo de data. **Este é o terceiro**, e é o único dos três que
  você classificou como segurança.

## Já tentei

O escape por fora, que o veredito aprovou como remendo temporário (*«o seu remendo morre no dia da
tag»*): no console (`core-flow-wa`, `8f7d6d2`), `escapaHtml` em **seis embrulhos** — `WaBotao`,
`WaCampoSelect`, `WaEtiquetaDeEstado`, `WaFilterBar`, `WaConfirmDialog`, `WaDialogo`. O
`WaConfirmDialog.tsx:133-141` diz por quê: dois usos de produção passam dado de servidor ao título
(`Excluir o perfil "${perfil.nome}"?`, `Revogar acesso de ${gestor.nome}?`), e o elemento os interpola
crus.

O remendo funciona onde existe embrulho. A **nota do filho de 22/09** mediu, executando, **21 de 29
peças** que vazam por 34 atributos; o console embrulha seis. O que não tem embrulho — e o que o `ib` e
o próximo consumidor escreverem direto na peça — não tem escape nenhum.

## Conferi no pai

- O veredito (22/09), transcrito no nosso arquivo irmão: ENTRA, *«Valor cru em `innerHTML` não é
  estilo: é execução»*, e os seis critérios.
- O `CHANGELOG` da `v2.6.0` diz, sobre a regra que você escreveu ontem: *«Prometer NÚMERO DE VERSÃO
  para obra futura é promessa sobre uma coisa que o próximo pedido move»*. A coluna de entrega deste
  pedido é uma promessa de número (`v0.208.0`) que nenhuma tag cumpriu — o mesmo caso, ainda escrito
  do jeito antigo.
- Não provei de novo no navegador. A prova de 21/09 foi executada pela tag `web-v0.207.0`; nesta rodada
  eu li a fonte da `web-v2.6.0` e as interpolações estão no mesmo lugar.

## Derivável?

Não se aplica: é entrega de um veredito já dado.

## Se você disser não

Não há «não» a dizer — o veredito é seu. Se a entrega não puder sair agora, o que peço é a condição
escrita no lugar do número de versão, como a `v2.6.0` fez com o `formAssociated`, para que a coluna do
ledger deixe de afirmar uma tag que já passou.

## Não estou pedindo

1. **prioridade sobre o que está na fila** — só que o assunto volte a estar nela, com a data certa;
2. **escape cego** — o desenho do veredito (escapar por destino, o que veio de fora) continua sendo o
   certo, e a nota de 22/09 mostra que o destino importa (atributo × conteúdo);
3. **reabrir o veredito** — ele está certo; falta a tag.

## Como o pai vai saber que funcionou

O gate que o veredito descreveu — o nosso, que pergunta ao elemento **instalado** se ele ainda é
cru — passa a pedir a remoção dos seis `escapaHtml` do console, e o escape duplo (*`&lt;` literal*)
é o sinal de que a peça passou a escapar sozinha. Do seu lado, um caso por peça com `<img src=x
onerror=…>` em cada atributo que ela lê, contado por execução e não por padrão de texto, como a
nota de 22/09 fez.

## Como cheguei aqui

Medindo o pedido do diálogo desta mesma rodada, li o `<h2 …>${titulo}</h2>` da `web-v2.6.0` e fui
conferir por que o console ainda escapa por fora. O ledger do pai tinha a resposta: a entrega nunca
saiu, e a linha ainda diz que a tag não foi cortada.
