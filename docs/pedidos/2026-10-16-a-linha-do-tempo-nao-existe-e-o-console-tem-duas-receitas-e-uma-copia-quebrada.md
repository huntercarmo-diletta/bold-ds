# PEDIDO · A linha do tempo não existe — e o console tem duas receitas, e a terceira cópia saiu sem estilo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não

## Falta

A lista de acontecimentos em ordem, com o instante à esquerda e, à direita, o que aconteceu e os detalhes.

## Número

| sítio | receita |
|---|---|
| `src/features/conversas/ui/DetalheDaQueda.tsx:204` (folha `.module.css:118-150`) | coluna de hora de 3.5rem; fio de 2px à esquerda em `border`; o marco atual com fio `errorOnSurface` e fundo `surfaceMuted` |
| `src/features/pix/ui/comum.tsx:69` (`LinhaDoTempoMed`, folha `comum.module.css:63-110`), chamada em `TelaContestacoes.tsx:294` e `TelaRetencoes.tsx:260` | coluna de hora `minmax(7.5rem, auto)`; hairline embaixo de cada marco; os detalhes quebram em linha |
| `src/features/tarifacao/ui/TelaTarifasDoCliente.tsx:343` (`Tentativas`) | **a marcação da do Pix, lendo as classes de `tarifacao/ui/comum.module.css`, que não declara nenhuma delas** (`linhaDoTempo`, `marco`, `hora`, `corpoDoMarco`, `oQue`, `detalhes`). A lista sai sem a grade, e a hora não fica à esquerda |
| total | **4 sítios, 2 receitas e 1 cópia quebrada sem ninguém notar** |
| `DilettaManifesto.busca` sobre as specs da `v3.19.0` | `busca('linha do tempo')`, `('timeline')`, `('cronologia')` → `[]` · `busca('evento')` → `[data-row]` · `busca('histórico')` → `[search-input]` |

## Já tentei

As três primeiras são leitura da peça, não montagem; a quarta é o que existe.

- **`<diletta-data-row>` e `<diletta-data-list>`**: tabela de colunas, com cabeçalho e ordem. Um marco tem um número variável de detalhes que quebram em linha (valor, prazo, papel, camada, análise), e numa tabela isso vira uma célula de parágrafo com tudo dentro.
- **`day-group`** (sem elemento web): agrupa as linhas de um extrato por dia, com um cabeçalho de data. Aqui o instante é de cada marco, ao minuto.
- **`web-stepper-node`**: é progresso (concluído, bloqueado, pendente), não o registro do que já aconteceu.
- **Copiar a receita**: foi o que fez a terceira cópia, quebrada.

## Conferi no pai

Os 49 arquivos de `src/` da `web-v3.19.0` e as specs: nenhuma peça de marcos com instante.

## Derivável?

Não. A anatomia é nova: hora numa coluna, corpo na outra, e um marco que pode ser o destacado.

## Se você disser não

As duas receitas viram uma peça compartilhada do console, e a quebrada é consertada lá. Sem contrato, a próxima tela copia de novo.

## Não estou pedindo

1. **ícone por tipo de evento**: nenhum dos quatro sítios tem;
2. **agrupar por dia**: nenhum agrupa;
3. **o vocabulário dos eventos**: vem do servidor, e a tela o mostra como chega.

## Como o pai vai saber que funcionou

Uma peça em que cada marco tem um instante (`<time datetime>`) e um corpo que recebe conteúdo, com a hora alinhada numa coluna e um marco que pode ser o atual. Do lado de cá, os quatro sítios passam a chamar a peça.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 2. A cópia quebrada foi achada medindo, e vai como achado de código para a fila do console. Não é defeito seu.

## VEREDITO · NASCE NO FILHO — a linha do tempo é peça do console, e sobe pela regra 3

**pai**: ds-diletta **v3.22.0** · **data**: 2026-10-16

### O que decidiu
O número: 4 sítios, todos neste filho. O Cockpit do flash não tem `Timeline` (0 arquivos, 16/10), e o censo do filho A não lista linha do tempo.

### O caminho de composição
Uma peça do console: `<ol>` com um `<li>` por marco, `<time datetime>` na primeira coluna e o corpo na segunda, numa grade de duas colunas para a hora alinhar. O marco atual leva `aria-current="step"`. Use `labelSm` na hora e os papéis que a receita do Pix já usa. As duas receitas viram essa, e a cópia quebrada de `tarifacao` sai junto.

### O que eu achei indo implementar
nada; não implementei.

### O que eu recusei, e a condição de reabrir
A peça na linguagem. **Reabre quando um segundo filho medir uma linha do tempo**, com o número de sítios dele.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | = | as duas receitas viram uma, do seu lado |
| escalabilidade | = | nada muda para os outros filhos |
| aplicação | = | os 4 sítios se resolvem do seu lado |
| aderência ao mercado | = | é o `Timeline` do antd e do Primer; ninguém da família pediu ainda |
| robustez | = | nada muda |
| arquitetura limpa e simples | ↑ | nenhuma peça nova sem segundo uso |
| conciso | ⊘ | sem mudança de código |

### O que você faz
A peça compartilhada do console, e um adendo aqui quando o segundo filho aparecer.
