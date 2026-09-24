# PEDIDO · A região `content` da web não tem largura — e o pai tem um teto de 600 para o app

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.1`, pela tag `web-v0.114.0` deste repo; **medido também na `web-v2.4.0`** (24/09)
- **bloqueante?**: **não** — o webadmin já vive com um token de produto (abaixo); o custo está em «Se você disser não»
- **irmão**: `2026-09-24-a-web-nao-tem-breakpoint-e-o-dart-tem.md` (os limiares) e `2026-09-24-a-web-de-backoffice-nao-tem-grade.md` (as colunas dentro da largura)

## Falta

A largura da região `content` da web de backoffice — o teto em que o conteúdo para de esticar e
centraliza, com a fuga nomeada para quem precisa da largura cheia. A `LINGUAGEM.md §2` declara as
regiões (`top` · `side` · `content`) e não diz quanto `content` mede em tela larga.

## Número

| medida | valor |
|---|---|
| telas web no Figma da linguagem (`O-QUE-A-WEB-USA.md`) | **86**, todas a 1440 |
| largura de conteúdo nelas — a linha de tabela e o cabeçalho | **917** |
| tokens de largura de conteúdo na emissão web | **0** (`web-v0.207.1` e `web-v2.4.0`) |
| o que o webadmin escreveu para suprir | `--wa-largura-da-coluna: 58rem` (928) — token de produto, 24/09 |
| o que a casca do webadmin já tinha | teto de 90rem (1440) para as tabelas |
| o que o pai declara para o app | `CoreflowLargura.teto = 600` (`coreflow_largura.dart`) |

Dois consumidores web (webadmin e `ib`), duas cascas, zero número em comum. Não conferi o `ib`;
o repositório não está nesta máquina.

## Já tentei

Um token do produto, `--wa-largura-da-coluna: 58rem`, catalogado com a razão e lido por duas
folhas (a grade do console e o Painel). Funciona — o Painel passou a morar nos 928px do meio da
tela a 1440, com ar dos dois lados, e a designer aprovou no print.

O que ele **não** faz: fazer o irmão concordar. É o mesmo defeito do pedido dos breakpoints, na
outra dimensão: sem emissão, cada consumidor escolhe um número e a linguagem passa a ter dois.

## Conferi no pai

- `packages/coreflow/lib/src/coreflow_largura.dart` — o princípio JÁ existe, e está bem escrito:
  *«numa tela larga o conteúdo deste produto não estica: ele para em 600 e centraliza»*, com
  `CoreflowLarguraDeConteudo` (o teto), `CoreflowSemTeto` (a fuga, por nome) e
  `coreflowSobraLateral` (quanto sobrou). **É exatamente a regra que a web precisa.** O 600 resolve
  o app no tablet; na web de backoffice ele não segura uma tabela nem os 917 do Figma. Então não é
  «não existe» — é «existe para o app, com o número do app, e a web não recebe nem o princípio».
- `docs/LINGUAGEM.md:125-126` — a tabela de regiões por plataforma. `content` está lá; a largura
  dele em tela larga, não.
- `packages/coreflow/lib/src/coreflow_espaco.dart:25` — `gutter = DilettaSpacing.s6`. A calha da
  grade do webadmin é a mesma, por coincidência que virou decisão.

Não estou pedindo o número. Se o pai quiser 917, 928 ou outro, é dele; o que o consumidor precisa
é de UMA fonte emitida na web (token CSS serve aqui — largura não é `@media`) de onde o token do
produto vire apelido.

## Derivável?

Não. A emissão web não tem nenhum valor de largura de onde 917 ou 928 saiam. O único precedente
é o `teto = 600` do pai, que é do app.

## Se você disser não

O token de produto fica, com a divergência do pai (600 → 58rem) escrita na razão. O webadmin
funciona. O que se perde: o `ib` fará o dele, e o Figma da linguagem — que mede 917 para os dois —
deixa de ser a fonte de ninguém.

## Não estou pedindo

1. **o número** — é decisão do pai, e o Figma já o mede;
2. **a grade** dentro da largura — é o pedido irmão `a-web-de-backoffice-nao-tem-grade`;
3. **os breakpoints** — pedido irmão, já no ledger deste filho;
4. **mudar o 600 do app** — está certo para o que resolve.

## Como o pai vai saber que funcionou

`--wa-largura-da-coluna` deixa de ter valor próprio e passa a `var(--diletta-<o nome que o pai der>)`;
`nomes.test.ts` continua verde; e um `grep` de largura de conteúdo em `diletta_design_system_web`
deixa de devolver zero. Se o `ib` adotar a mesma fonte, os dois consoles passam a medir o mesmo
`content`.
