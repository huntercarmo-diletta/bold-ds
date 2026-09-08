# RELEASE · três pixels mudam no Flutter, e a linguagem ganhou uma segunda instância

**de**: ds-diletta v0.175.0 · **para**: conta-bold-ds · **data**: 2026-09-08

## O que mudou

Nesta tag são 37 commits, e eles se separam em duas metades que não se misturam.

**A metade que te toca tem TRÊS linhas.** Cinco widgets passaram a pintar por papel e
por absoluto declarado em vez de degrau cru. Onde medi um a um, a esmagadora maioria
bate no hex — 13 de 14 na etiqueta de status, 8 de 9 no botão de ícone — e ali só o
vocabulário mudou. Em três slots a cor muda de verdade:

| peça | slot | antes | agora |
|---|---|---|---|
| `DilettaIconButton` | base do erro | `error03` `#8a1a14` — glifo a 9,38:1 | papel `error` (`#b3251d`) — glifo a **6,56:1** |
| `DilettaStatusTag` | borda do `secure` | `secure03` `#6e5708` — 6,40:1 | papel `secure` (`#9c7b0c`) — **3,69:1** |
| `DilettaSpotIcon` | anel do `loading` | `neutral07` sobre `primary07` — **1,33:1** | a mesma tinta do glifo, calculada por contraste |

Os hexes acima são da paleta de REFERÊNCIA. **No seu tema o número é outro**, porque o
papel é derivado da sua rampa — e é justamente isso que a troca conserta: degrau cru
congela o hex de uma paleta que não é a sua.

A terceira linha é conserto e não vocabulário: 1,33:1 num elemento gráfico está muito
abaixo do mínimo de 3.0 desta casa, e **nenhum gate pegava, porque contraste de borda
decorativa não estava sendo medido**. Trocar pelo papel `border` teria piorado, para
1,05:1; o conserto foi alinhar ao irmão — os outros três estados do outline já pintam
a mesma tinta na borda e no glifo.

**Nove absolutos ganharam NOME, e nenhum ganhou valor novo:** `whiteAlpha06` · `10` ·
`14` · `16` · `22` · `25` · `28` · `30` · `40`. Eram calculados em tempo de execução
com `withValues(alpha:)`. Cor calculada não é `const` e não tem token para amarrar — e
as duas coisas pelo mesmo motivo. Se você escreve branco com alfa à mão sobre cor de
marca, agora tem nome pra ler.

**A metade de cima é o DS na web**, e ela não te cobra nada: pacote novo
`diletta_design_system_web` com custom elements, os 59 papéis × 2 modos saindo como
171 declarações `--cps-*` em CSS, 13 specs de `destino: web`, e dois lados novos no
quadrado (`codigoWeb` e `catalogoWeb`). Se um produto web da família quiser pintar com
os nossos papéis, agora dá — sem trocar um componente. A decisão está na `ADR-007`.

## O que você faz

Adota quando quiser, e antes de adotar olhe os três slots da tabela em tela real, com
a SUA rampa. Se algum dos três não te serve, o número que eu medi está em cada linha —
discorda com medição e eu volto atrás.

**Você está na `v0.163.0`, e esta é a `v0.175.0`: são doze.** O CHANGELOG entre as
duas é a lista de leitura, e nenhuma delas é major.

## Como isso chega

    troque o `ref:` pra v0.175.0

em `packages/coreflow_design_system/pubspec.yaml`.

## Prazo

Nenhum. É minor: nada foi removido nem trocou de assinatura.
