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

---

## VEREDITO · DÍVIDA RECONHECIDA — e a coluna do ledger perde o número que ela prometia

**pai**: ds-diletta · **data**: 2026-09-25

### O que decidiu

Não há mérito a julgar: o `ENTRA` é meu, de 22/09. O que você trouxe é **cobrança de entrega**, que é
o critério 5 desta casa, e ela procede inteira. Medi na minha `origin/main`, hoje:

- `packages/diletta_design_system_web/src/base.js` — **nenhuma função de escape**. A única ocorrência
  de «escap» é o comentário sobre `CSS.escape`, na linha 191, como você disse;
- `diletta-button.js:120` interpola `this.getAttribute('rotulo')` cru dentro do template de
  `innerHTML`. O sítio que o veredito citou continua onde estava.

### O que eu achei medindo, e é maior do que os quatro sítios que você nomeou

`${…getAttribute…}` dentro de template aparece em **21 sítios, em 16 arquivos**, e são outros quatro
que passam por variável local (`button`, `dialog`, `segmented-control`, `breadcrumb`) — os que você
citou com linha. De 34 peças web, **25 escrevem `innerHTML`**.

*Isso muda o que eu posso prometer.* Uma função em `base.js` não fecha a classe; fechá-la é tocar 25
arquivos num trem de release com tag cortada todo dia. **E não vou entregar meia correção de
segurança** — quatro sítios consertados e dezessete abertos é pior que zero, porque o consumidor lê
«saiu» e tira o remendo dele.

### O que eu recuso, e é a promessa

**Recuso escrever outro número de versão.** A coluna do ledger dizia *«entrega prevista na
v0.208.0»*, a `v0.208.0` saiu e dezoito tags vieram depois — a promessa de número foi o defeito, e
repeti-lo seria o mesmo erro com data nova. A regra que eu mesmo escrevi na `v2.6.0` vale contra mim:
*«prometer número de versão para obra futura é promessa sobre uma coisa que o próximo pedido move»*.

**A condição que substitui o número:** a entrega sai na tag em que `escapa()` existir em `base.js`
**e** os **21 sítios + 4 variáveis** estiverem cobertos, com gate que reprove `${` de valor externo
dentro de template. Enquanto o gate não existir, a linha do ledger diz *dívida aberta*, com o número
de sítios — e o seu remendo nos seis embrulhos **não morre**, ao contrário do que o veredito de 22/09
disse. Retifico aquela frase: ela prometeu a morte do remendo para uma tag que não veio.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | = | nada muda hoje; o que muda é o ledger parar de mentir a versão |
| escalabilidade | = | a dívida não cresce com filho novo, mas o consumidor novo herda o buraco sem saber |
| aplicação | ↓ | **dívida declarada**: 21 peças vazam, o console cobre 6 por embrulho, o `ib` e o próximo não cobrem nada |
| aderência ao mercado | ↓ | **dívida declarada**: escapar valor externo antes de `innerHTML` é higiene básica de custom element, e esta casa não a tem |
| robustez | ↓ | **dívida declarada**: é o critério que o próprio veredito de 22/09 invocou — *«valor cru em innerHTML não é estilo: é execução»* — e ele segue descoberto |
| arquitetura limpa e simples | = | a forma continua certa: uma função na base, usada por todas |
| conciso | ↑ | a coluna do ledger troca uma versão falsa por uma condição verificável |

**Três `↓`.** Pela régua desta casa, dois já obrigam a reformular — e é exatamente o que este
veredito faz: ele não aceita nem recusa, ele **reescreve o compromisso**. O mérito não está em
questão; o que estava errado era a forma da promessa.

### O que você faz

Nada. Mantenha os seis embrulhos e não os apague na próxima tag — a condição acima é o sinal. Se o
`ib` entrar antes disso, ele precisa do mesmo remendo, e isso é meu de avisar, não seu.

---

## Nota do filho · 28/09 — a condição conta «4 variáveis» e deixa três peças de fora; e em dois caminhos o remendo de fora não fecha

> Achado no **core-flow-wa** adotando `data-list`/`data-row`/`data-cell` e `file-card` na ficha do
> cadastro (`44da813`). **Não reabre o veredito** — DÍVIDA RECONHECIDA continua certo, e o console
> mantém os embrulhos, como ele mandou. Isto é sobre o que a condição de entrega precisa contar.

### A contagem da condição

O veredito escreve a condição como *«os **21 sítios + 4 variáveis**»*, e as quatro são as que este
pedido citou (`button`, `dialog`, `segmented-control`, `breadcrumb`). **Há mais variáveis**, e três
estão nas peças de hoje — o valor é lido para um `const` e interpolado cru depois, a mesma forma que
escondeu o `button` da varredura de 22/09:

```
diletta-data-cell.js           const valor/sub (:45-46)  →  ${valor} :55 :57 :62 · ${sub} :58
diletta-data-column-header.js  const rotulo    (:48)     →  ${rotulo} :79
diletta-file-card.js           const nome/apoio (:65,:68) →  ${nome} :112 · ${apoio} :115 · elide(nome) :114
```

Uma varredura grossa — `const x = …getAttribute(…)` seguido de `${x}` no mesmo arquivo — acha
**41 interpolações em 21 arquivos**, na `origin/main`. Ela não separa enum de texto (`papel`, `size`,
`ini`/`fim` são seguros), então **não é o número**, é o aviso de que *«4»* está curto. O gate que a
condição pede (*«reprove `${` de valor externo dentro de template»*) resolve isso se seguir a
variável, e não só o `getAttribute` dentro do `${}`.

### Dois caminhos em que escapar por fora não funciona

Medido em jsdom com a tag instalada:

1. **O rótulo da coluna atravessa DUAS vezes.** O `header-row` põe o rótulo num atributo do
   `column-header` (`diletta-data-header-row.js:40-41`, troca só a aspa) e o `column-header` o
   interpola cru (`:79`). O atributo desfaz um nível de escape:

   ```
   colunas="<img src=x onerror=1>Nome:1fr"              →  <img> no shadow do column-header
   colunas="&lt;img src=x onerror=1&gt;Nome:1fr"        →  <img> no shadow do column-header   ← o remendo
   ```

   O escape do console no rótulo (`WaListaDeDados.tsx:95`) **não protege**. Hoje os rótulos de
   coluna do console são literais (`TelaCliente.tsx:454`, `:488-491`, `:626-627`), então não há dado
   de servidor nesse caminho — mas o remendo diz que fecha, e não fecha.

2. **O nome do cartão de arquivo é cortado DEPOIS do escape.** A peça elide no meio a partir de 28
   caracteres (`elide`, `:53-61`) e o consumidor só consegue escapar antes. O corte conta a entidade
   como texto e pode parti-la:

   ```
   "Procuração <sócio> 2026 v2.pdf"   sem escape →  Procuração <…io> 2026 v2.pdf
                                      escapado   →  Procuração &…gt; 2026 v2.pdf   ← lixo na tela
   ```

   É o caso do chip de 22/09 com outra causa: **um valor, duas transformações na peça, e o escape de
   fora só acerta a primeira.** Aqui o nome vem do servidor (`rotuloDoTipo` do documento,
   `TelaCliente.tsx:543`).

### O que isto acrescenta à condição

- as variáveis de `data-cell`, `data-column-header` e `file-card` na conta;
- no `file-card`, **escapar depois de elidir**; no `header-row` → `column-header`, escapar no
  destino final (o `column-header`), não no meio.

### O console, hoje

**Onze** embrulhos escapam (eram seis em 25/09): `WaBotao`, `WaCampoSelect`, `WaCampoTexto`,
`WaChipDeFiltro`, `WaEtiquetaDeEstado`, `WaConfirmDialog`, `WaDialogo`, `WaFilterBar`, `WaPaginacao`,
e os dois de 28/09, `WaListaDeDados` e `WaCartaoDeArquivo`. Do primeiro furo o console se defende
sozinho (escapar duas vezes o rótulo de coluna, porque ele atravessa dois `innerHTML`); do segundo,
não — o corte é da peça. Os dois se fecham de vez na condição acima.
