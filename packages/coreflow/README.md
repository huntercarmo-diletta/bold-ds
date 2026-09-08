# coreflow — o pai

A linguagem de produto **sem produto**: os componentes `Coreflow*`, os contratos e a forma dos
esquemas. Cor, fonte, logo, arte e nome de produto são do filho — o primeiro é o Bold, em
`packages/coreflow_design_system`, que continua com o nome, o `path:` e os símbolos que o app importa.

Por que existe, o que fica onde e em que ordem se move:
[`docs/2026-09-04-adr-o-coreflow-e-o-pai.md`](../../docs/2026-09-04-adr-o-coreflow-e-o-pai.md).

## Estado — fase 2 feita (08/09)

Re-exporta `diletta_design_system` (`v0.175.0`) e tem a linguagem inteira: **61** arquivos —
componentes, `CoreflowProduto`, `CoreflowScheme`, `CoreflowTemaMaterial`, `CoreflowTipografia`,
`CoreflowGradients`, `CoreflowVinho`, `CoreflowVocabulario`. Veredito do dono do DS em
`docs/pedidos/2026-09-04-o-coreflow-e-o-pai-e-o-bold-e-o-primeiro-filho.md`: o degrau do meio **não
declara valor de produto** — nem cor crua, nem degrau de escala, nem valor de gradiente, nem caminho de
asset, nem família tipográfica. Os arquivos seguem chamando `bold_*.dart`: dívida de NOME, medida e fora
do escopo do ADR.

O filho (`packages/coreflow_design_system`) depende daqui por `path:` e re-exporta este barrel.

## Os testes

Teste de componente mora com o componente: os 12 arquivos que exercitam peças daqui vieram do filho
com a peça, e trocaram o tema do Bold pelo **neto** (`test/o_neto.dart`: a paleta de referência do
avô, marca `nenhuma`). O neto já pagou: `CoreflowBackground` estourava em qualquer produto que não
declarasse `bgEscuro`, porque o primeiro produto declara.

## O gate

```bash
flutter analyze && flutter test
```

`o_coreflow_nao_cita_bold`: as duas colunas da régua de
`packages/coreflow_design_system/tool/levanta_a_separacao.sh` — NOME (símbolos do produto) e VALOR (hex
cru, `TextStyle(` cru, `assets/`) — têm que dar **zero** em `lib/`. Comentário e doc **não** são isentos
— o pai não conta a história do filho nem em prosa. Os testes de componente moram aqui, com o **neto**
(`test/o_neto.dart`: a paleta de referência do avô, marca nenhuma) como fixture.
