# PEDIDO · A web não tem breakpoint — e o Dart tem quatro, declarados, desde sempre

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.1`, pela tag `web-v0.114.0` deste repo; **medido também na `web-v2.4.0`** (24/09)
- **bloqueante?**: **não** — o webadmin já entrega com uma cópia declarada (abaixo), e o custo de não ter está na seção «Se você disser não»

## Falta

A emissão web de `DilettaBreakpoints`. O Dart declara `sm 640 · md 768 · lg 1024 · xl 1280`
(`packages/diletta_design_system/lib/src/theme/diletta_breakpoints.dart`); `diletta_design_system_web`
não emite nada com esse nome — nem token, nem JSON, nem módulo. A `LINGUAGEM.md §2` promete:
*«Breakpoints e densidade (`comfortable`/`compact`) entram como **tokens**, não como forks»*.

## Número

No webadmin (`core-flow-wa`), antes de haver tabela (24/09/2026):

| medida | valor |
|---|---|
| `@media` com `min-width`/`max-width` em `src/**/*.css` | **10**, em 8 folhas |
| larguras distintas | **5** — 40 · 52 · 60 · 62 · 61.999 rem |
| das cinco, quantas são um limiar do Dart | **1** — 40rem = 640 = `sm`, sem ninguém saber |
| das cinco, quantas não são nada | **3** — 832, 960 e 992 ficam entre `md` e `lg` |
| ocorrências de «breakpoint» em `diletta_design_system_web` | **0**, na `web-v0.207.1` e na `web-v2.4.0` |
| tokens `--diletta-*` de layout nas folhas emitidas | **0** |

O irmão (`ib`) consome a mesma linguagem e escreve os próprios `@media`; não conferi os dele —
não está nesta máquina —, mas sem emissão não há gate que faça os dois concordarem.

## Já tentei

Uma **cópia declarada** dos quatro números em `src/design-system/tokens/breakpoints.ts`, em rem,
com um gate (`breakpoints.test.ts`) que reprova qualquer `@media` de largura fora deles. Funciona:
sete das dez ocorrências já desceram ao limiar vizinho, o gate está verde, e a peça de grade do
console (`WaGrade`) lê a tabela.

O que ela **não** faz: fazer dois filhos concordarem. Cada consumidor web teria a própria cópia,
e uma mudança no Dart não chegaria a nenhuma. Foi exatamente a razão de a promessa da
`LINGUAGEM.md` ser «token, não fork».

Antes disso, tentei os do Material 3 (600/840/1200/1600) — a referência dos agentes de UI/UX da
designer. Recuei no mesmo dia pela regra de precedência da própria casa (*DS do projeto > Material*)
quando li o Dart. Registro porque é a armadilha: **sem emissão web, quem escreve web escolhe uma
tabela externa, e a linguagem passa a ter duas.**

## Conferi no pai

- `diletta_breakpoints.dart` — os quatro `static const double`, e `DilettaBreakpoint of(double width)`.
- `docs/LINGUAGEM.md:128` — a promessa, literal.
- `packages/diletta_design_system_web` — `grep -ri breakpoint` devolve zero, na tag instalada e na
  `web-v2.4.0` clonada em 24/09.
- `avo/spec-publicada.json` — `DilettaBreakpoints` não é peça, então não há `destino` para cobrar;
  é o que faz isto ser lacuna de EMISSÃO, não de spec.

Não estou pedindo forma. Cabe ao pai decidir o que «token de breakpoint» é na web — `var()` não
funciona dentro de `@media`, então provavelmente não é custom property sozinha. O que o consumidor
precisa é de UMA fonte lida por máquina (um módulo, um JSON ao lado de `spec-publicada.json`, ou
os dois) de onde `breakpoints.ts` possa reexportar.

## Derivável?

Não. Não há nada na emissão web de onde os quatro números saiam — nem primitiva, nem papel, nem
medida. O único lugar onde existem é o Dart.

## Se você disser não

A cópia declarada fica, com a condição de morrer escrita no `///`. O webadmin funciona. O que se
perde: o `ib` fará a cópia dele, e a próxima mudança em `diletta_breakpoints.dart` não chega a
nenhum dos dois — e nenhum gate avisa. É a coerência entre irmãos que a `LINGUAGEM.md` prometeu e
que hoje depende de alguém lembrar.

## Não estou pedindo

1. **a grade** — doze colunas, calha, coluna central de conteúdo: é layout de produto, mora no
   filho (`WaGrade`), e o irmão pode desenhar a dele;
2. **densidade** (`comfortable`/`compact`) — é o pedido
   `2026-09-23-metade-da-escala-de-tipo-nao-tem-papel-e-a-web-nao-tem-densidade.md`, em pé;
3. **navegação por breakpoint** (barra ↔ rail) — comportamento de produto;
4. **valores novos** — os quatro do Dart servem; se o pai quiser revê-los, é outro pedido.

## Como o pai vai saber que funcionou

`src/design-system/tokens/breakpoints.ts` deixa de declarar `PISO` e passa a **reexportar** o que a
linguagem emitir; `breakpoints.test.ts` continua verde lendo de lá; e `grep -ri breakpoint
packages/diletta_design_system_web` deixa de devolver zero. Se o `ib` adotar a mesma fonte, os dois
`@media` de 640 dos dois produtos passam a vir do mesmo número — que é o gate que não existe hoje.
