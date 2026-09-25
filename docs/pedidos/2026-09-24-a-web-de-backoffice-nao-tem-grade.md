# PEDIDO · A web de backoffice não tem grade — e cada consumidor está desenhando a sua

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.1`, pela tag `web-v0.114.0` deste repo; **medido também na `web-v2.4.0`** (24/09)
- **bloqueante?**: **não** — o webadmin já tem uma peça própria (abaixo); o custo está em «Se você disser não»
- **irmão**: `2026-09-24-o-content-da-web-nao-tem-largura-e-o-pai-tem-teto.md` (a largura) e `2026-09-24-a-web-nao-tem-breakpoint-e-o-dart-tem.md` (os limiares)

## Falta

Uma grade de colunas para a região `content` da web — colunas, calha, e como os painéis se
arrumam nelas por classe de largura. A `LINGUAGEM.md §2` cita Carbon, Fluent e Polaris como
modelo para «admin + web»; os três publicam grade. A linguagem publica 29 elementos web e nenhum
é grade.

## Número

| medida | valor |
|---|---|
| elementos web publicados (`avo/src/diletta-*.js`) | **29**; grade: **0** |
| ocorrências de «grid»/«coluna» na emissão web | **0** tokens; a palavra só aparece em `data-list`/`data-row` (a tabela) |
| o que o webadmin construiu em 24/09 | `WaGrade`: 12 colunas, calha `s6`, 5 layouts com nome (`leitura`, `principal-apoio`, `lista-detalhe`, `feed`, `colunas`), colapsando pelos breakpoints do Dart |
| `@media` de largura que o webadmin tinha antes da grade | **10**, em 8 folhas, 5 larguras distintas |
| telas do webadmin com grade própria à mão | **1** (o Painel: duas colunas reordenáveis) |

O `ib` — não conferi, não está nesta máquina — tem as próprias telas de 1440 e, sem grade
emitida, só pode ter feito o mesmo: escrito a dele.

## Já tentei

`WaGrade`, uma peça do produto: `grid` de 12 colunas com calha `--diletta-s6` dentro da largura de
coluna, e quatro layouts canônicos com nome em vez de spans soltos — `leitura` (8/12 centrada,
teto 74ch), `principal-apoio` (8 + 4), `lista-detalhe` (5 + 7), `feed` (3 · 2 · 1 por linha) —
mais `colunas` como fuga declarada. Empilha abaixo do `lg` (1024), vai a uma coluna abaixo do `sm`
(640), não reordena o DOM. Está em uso e testada.

O que ela **não** faz: existir no `ib`. Duas grades para a mesma linguagem é o «fork» que a
`LINGUAGEM.md §2` diz que não quer.

Também tentei aplicar a peça no Painel do console e recuei: ele já tem uma grade semântica própria
(duas colunas reordenáveis pelo gestor), e isso me ensinou que a grade da linguagem precisa
conviver com grade de domínio — a região `content` dá as colunas; o que a tela faz dentro é dela.

## Conferi no pai

- `ls avo/src/diletta-*.js` — 29 peças, nenhuma de layout. `data-list`/`data-row`/`data-cell` são
  a TABELA, não a grade.
- `docs/LINGUAGEM.md:118-129` — a gramática é «um conjunto pequeno de regiões responsivas»;
  colunas dentro de `content` não estão descritas.
- `packages/coreflow/lib/src/coreflow_contratos.dart:823-852` — o pai fala em «grade de 3
  colunas» e «use 2 ou 3 colunas quando os itens devem ter a MESMA largura» — é o menu de
  ladrilhos do app, uma grade de peça, não de página. Não é isto; registro para não parecer que
  não vi.
- `~/.claude/design-refs/material.md §1` — os layouts canônicos que a peça do console copiou
  (feed, list-detail, supporting pane ≈ 2/3 + 1/3), e «painéis por classe: Compact 1 · Medium 1–2 ·
  Expanded 2 · Extra-large até 3».

Não estou pedindo a forma. Pode ser peça, pode ser tokens de coluna/calha + guideline, pode ser os
dois. O que o consumidor precisa é de onde reexportar.

## Derivável?

Não. Sem largura de `content` (pedido irmão) e sem breakpoints (pedido irmão) não há de onde
derivar colunas; com os dois, a grade ainda é uma decisão — quantas colunas, qual calha, quais
layouts têm nome.

## Se você disser não

`WaGrade` fica no webadmin, e o `ib` faz a dele. Duas telas de 1440 da mesma família com colunas
diferentes, e nenhum gate que avise. É o custo mais caro dos três pedidos irmãos, porque é o que o
gestor vê.

## Não estou pedindo

1. **os nomes dos layouts** — `leitura`, `principal-apoio` etc. são do console; se o pai nomear
   diferente, o consumidor traduz;
2. **a largura** e **os breakpoints** — pedidos irmãos;
3. **que o Painel use a grade da linguagem** — ele tem a dele, com razão escrita;
4. **densidade** — pedido em pé.

## Como o pai vai saber que funcionou

`WaGrade` passa a ser embrulho do que a linguagem emitir (ou some, se a emissão for peça), a
folha dele perde as regras de coluna, e `grep -c "grid-template-columns" src/design-system` no
webadmin cai. Se o `ib` adotar a mesma fonte, as telas de 1440 dos dois passam a ter as mesmas
colunas.

---

## Veredito · ENTRA COMO DADO, e não como `<diletta-grade>`
**pai**: ds-diletta **web-v2.6.0** · **data**: 2026-09-24

`src/grade.js`: `GRADE` (12 colunas, calha `s6`, a largura), `LAYOUTS` com os cinco nomes que você
nomeou, e `porLinha()` para o feed.

### Por que dado e não peça — e a sua própria mão escreveu a razão

Você disse que a forma era minha. Escolhi dado, por três coisas:

1. **grade é estrutura de PÁGINA, e página é do consumidor.** Ele monta com React, Astro, Lit ou
   HTML; obrigar tudo isso a passar por um custom element para ganhar `display: grid` é o elemento
   cobrando pedágio numa coisa que o CSS faz sozinho;
2. **Carbon e Polaris publicam grade como token e classe**, não como componente — e a
   `LINGUAGEM.md §2` cita os dois como o modelo desta gramática;
3. **e a terceira é sua**: você aplicou a `WaGrade` no Painel e **recuou**, porque aquela tela já
   tinha grade semântica própria. A frase que você tirou disso é o desenho inteiro — *a região
   `content` dá as colunas; o que a tela faz dentro é dela.* Uma peça de layout teria brigado com
   a grade de domínio; um dado não briga com nada.

### O que a linguagem publica, então, é o que faz dois consumidores concordarem: os números e os NOMES

Os cinco vieram do seu uso, não de um catálogo, e batem com os layouts canônicos do Material.
**Nome de layout é vocabulário**: duas pessoas discutindo *«isto é `lista-detalhe` ou
`principal-apoio`?»* estão discutindo a tela, e é para isso que um DS serve. `spans` soltos não
produzem essa conversa.

A fuga entrou com nome — `colunas` —, pelo mesmo desenho do `CoreflowSemTeto`: **exceção sem nome é
exceção que ninguém audita.**

O gate cobra que todo span caiba nas doze e que **todo limiar de colapso seja um breakpoint da
linguagem**, e não número solto. É a amarração com o seu pedido irmão: sem ela a grade nasceria com
a quinta largura inventada que você acabou de tirar do seu produto.

**Os sete**: manutenção ↑ · escalabilidade ↑ o `ib` para de escrever a dele · **aplicação ↑ decide**
— era «o custo mais caro dos três, porque é o que o gestor vê» · aderência ao mercado ↑ · robustez
↑ o gate amarra a grade aos breakpoints · **arquitetura ↑ decide** — dado não briga com grade de
domínio, peça brigaria · conciso ↑ cinco nomes em vez de spans soltos.
