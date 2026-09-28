# PEDIDO · O trilho do segmented não diz o que acontece com sete opções

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `origin/main` (`6a2b756`)**
- **bloqueante?**: **não** — e **condicional**: só vale se a designer escolher o segmented para os atalhos dos relatórios (a alternativa é o campo de seleção, e a decisão está aberta com ela)
- **irmão**: [o segmented pinta 32 e não tem o alvo de 44](2026-09-25-o-segmented-control-pinta-32-e-nao-tem-o-alvo-de-44-que-as-irmas-tem.md) (**ENTRA**, `c26c3c5`, sem tag). Este não o reabre
- **não é peça nova**: o `busca()` não se aplica

## Falta

Uma regra na spec do `segmented-control` para **quantas opções cabem no trilho**, e o que a peça faz
quando não cabem: quebrar, rolar, ou dizer «acima de N, use o campo de seleção».

## Número

O trilho não quebra e não rola: `display: inline-flex; ... gap: 2px; padding: 2px` com `height`
fixo (`diletta-segmented-control.js:75-76` no pino; `:80-81` na `origin/main`), sem `flex-wrap` nem
`overflow`. A spec nasceu de **9 instâncias, todas `247×32`**, de quatro opções
(`specs/design-system-segmented-control/spec.md:3-5`), e não fala de quantidade.

O caso: o «Ordenar por» de Clientes tem **7 opções** (`TelaUsuarios.tsx:73-80`: movimentação,
transações, saldo, uso do aplicativo, entradas no aplicativo, erros, conversas — três delas com o
sufixo «· sem dados»). A auditoria de 28/09 estimou **~960px** de trilho para **~786px** de coluna:
transborda. (A estimativa é dela, pela soma dos rótulos em `labelSm`; eu não medi em pixel.)

Os outros grupos do console (Agrupar, Ver, Mostrar como, período) têm de 2 a 4 opções e cabem.

## Já tentei

Nada na peça: os atalhos do console ainda são botões próprios (`AtalhosExclusivos.tsx`), à espera
do alvo de 44 e da decisão de desenho. O comentário do componente já registra o transbordo
(`AtalhosExclusivos.tsx:11-15`).

## Conferi no pai

- A spec e o elemento, acima. Nenhum requisito ou cenário com quantidade de segmentos.
- O `<diletta-tabs>` resolveu o mesmo problema com um eixo (`larguraIgual`, e o corte com
  reticências — `specs/design-system-tabs/spec.md:71-84`). O segmented não tem o equivalente.

## Derivável?

Não: o trilho é do shadow.

## Se você disser não

Se a designer escolher o segmented, o «Ordenar» de Clientes vai para o campo de seleção e os outros
ficam no segmented — duas formas para o mesmo tipo de escolha na mesma área, decididas pela contagem
de opções e não pelo desenho.

## Não estou pedindo

1. **que o trilho cresça ou mude de desenho** — o 32 e a pílula continuam;
2. **o estado «sem dados»** de um segmento — é outro assunto, e não medi quantos consumidores teria;
3. **que a peça escolha sozinha virar campo de seleção** — basta a regra escrita.

## Como o pai vai saber que funcionou

A spec diz quantas opções o trilho hospeda e o que acontece acima disso; se for comportamento (quebra
ou rolagem), um cenário com sete rótulos numa coluna de 786 não transborda.

## Como cheguei aqui

Pela passada «o DS em tudo» do webadmin (tarefa 1.12 de `arquitetura-de-informacao-do-console`,
`c928892`, 28/09), auditoria de Painel e Relatórios, que tentou trocar os atalhos pelo segmented.

---

## VEREDITO · ENTRA — a regra: de dois a cinco, e acima disso é campo de seleção

**pai**: ds-diletta **v2.8.0** · **data**: 2026-09-28

### O que decidiu

A sua terceira linha do «não estou pedindo»: *«que a peça escolha sozinha virar campo de seleção —
basta a regra escrita»*. A regra é o que falta, e o comportamento não. O trilho não quebra e não
rola por desenho: a pílula existe para as opções serem comparadas à vista.

### O que eu fiz

Requisito novo na spec do `segmented-control`: **o trilho hospeda de 2 a 5 segmentos; acima de cinco
a escolha é `design-system-dropdown`**. O teto é o do segmented button do Material 3, que declara
de 2 a 5. O cenário de sete opções está escrito.

### O que eu achei indo implementar

nada

### O que eu recusei, e a condição de reabrir

**Quebrar ou rolar o trilho.** Reabre com um caso medido em que seis ou mais opções precisem estar à
vista ao mesmo tempo, e em que o campo de seleção esconda a comparação.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | = | uma frase na spec, nenhum código |
| escalabilidade | ↑ | todo consumidor decide pela mesma contagem |
| aplicação | ↑ | o «Ordenar» de sete vai para o seletor sem ninguém medir pixel |
| aderência ao mercado | ↑ | é o teto do Material 3 |
| robustez | = | não há comportamento novo para quebrar |
| arquitetura limpa e simples | ↑ | nenhum modo de quebra ou rolagem na peça |
| conciso | = | um requisito e um cenário |

### O que você faz

Se a designer escolher o segmented para os atalhos, o «Ordenar por» de sete opções é
`<diletta-dropdown>`. É o que a regra diz, e não uma exceção de tela.
