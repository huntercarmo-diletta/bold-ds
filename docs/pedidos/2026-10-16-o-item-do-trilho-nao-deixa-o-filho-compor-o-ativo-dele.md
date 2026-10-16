# PEDIDO · O item do trilho não deixa o filho compor o ativo dele — a casca do glifo e o rótulo ficam fora de alcance

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não
- **irmão**: `2026-09-29-o-chip-nao-tem-aparencia-neutra-para-sugestao-e-nao-ouve-o-teclado.md`, cujo veredito deu o caminho que este pedido quer seguir

## Falta

O filho não alcança a casca do glifo nem o rótulo do `<diletta-rail-item>`. Por isso não consegue compor a variante de ativo que a regra 3 manda nascer nele.

## Número

| medida | valor |
|---|---|
| consumidor | o trilho do console (`src/app/LayoutAutenticado.tsx:196-223`, folha `.module.css:336-394`): um destino por área, conforme a permissão de quem entra; 8 no protótipo de 08/10 |
| `<diletta-rail-item>` no console | **0**. O trilho é `NavLink` à mão, e o motivo está escrito no código (`LayoutAutenticado.tsx:196-204`): *«ficou estranho na casca e não publica a casca do glifo como `part`: não dá para trocar o medalhão pela pílula de fora»* |
| o desenho escolhido | o navigation rail do Material 3 (decisão da designer, 28/09): 80 de largura, indicador em pílula de 56×32 atrás de um glifo de 24, ativo em `primarySubtle` com o glifo cheio, rótulo `labelMd` |
| a peça (`diletta-rail-item.js`, `web-v3.19.0`) | `part` só no `<a class="item">` (`:95`). A casca (`:78-86`: medalhão de 38, raio 12, `primary` cheio no ativo) e o rótulo (`:91`) não têm `part` |

## Conferi no pai

- **O caminho já é seu**: no chip, a aparência neutra *«nasce no filho»*, e o caminho que você escreveu foi *«pinte a pílula neutra por `::part(pilula)`»* (veredito de 29/09). Aqui é a mesma coisa, e falta o `part`.
- **O rótulo ativo da peça é `primary` (`:74`), e na tinta do Bold isso passa**: 8,03:1 no claro (o esquema do produto redeclara `primary` como `#9e1241`, `bold-tokens.css:222`) e 6,66:1 no escuro, contra `surface` (calculado dos valores, não medido em tela). **Não é defeito seu.** O console pinta o rótulo e o glifo em `textPrimary` por causa da pílula dele: o glifo `primary` sobre `primarySubtle` dá 2,94:1 no escuro, abaixo dos 3:1 de objeto gráfico (`LayoutAutenticado.module.css:373-376`). A divergência é nossa, e fica registrada.

## Já tentei

- **A peça como está**: o medalhão de 38 cheio de cor da marca *«ficou estranho na casca»* (o comentário do console), e a designer escolheu o rail do Material 3.
- **Esconder a casca e desenhar a pílula ao lado**: o glifo mora dentro da casca, então ele some junto.
- **A cópia à mão**: é o que existe.

## Derivável?

Não. O desenho mora no shadow DOM, e sem `part` nenhum seletor de fora chega até ele.

## Se você disser não

O trilho do console continua sem a peça, e a navegação cancelável que entrou para ela em 28/09 também não chega ao trilho.

## Não estou pedindo

1. **a pílula na linguagem**: variante nasce no filho;
2. **mudar o medalhão**: ele é a forma da linguagem;
3. **trocar o glifo cheio pelo leve**: é troca de ícone, feita por quem chama.

## Como o pai vai saber que funcionou

`::part()` alcança a casca e o rótulo. Do lado de cá, os `NavLink` do trilho viram `<diletta-rail-item>`, com a pílula composta por fora.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 12. O console anotou este pedido no código e não o escreveu.

## VEREDITO · ENTRA — `::part(casca)` e `::part(rotulo)`

**pai**: ds-diletta **v3.22.0** · **data**: 2026-10-16

### O que decidiu
A sua frase: «o caminho já é seu». É o caminho do chip: a pílula do M3 nasce no filho, por `::part`. O `<diletta-rail-item>` publica `part="casca"` e `part="rotulo"`. O recolhido segue sem rótulo, então ali só a casca existe.

### O que eu achei indo implementar
nada.

### O que eu recusei, e a condição de reabrir
nada recusado.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o trilho à mão do console sai |
| escalabilidade | = | dois `part`; o próximo filho herda só isso |
| aplicação | ↑ | o trilho do console; adota o filho B |
| aderência ao mercado | ↑ | `::part` é o caminho do Shoelace para estilo de fora |
| robustez | = | sem mudança de comportamento |
| arquitetura limpa e simples | = | dois atributos |
| conciso | = | uma linha de comentário |

### O que você faz
Suba a `web-v3.22.0` e componha a pílula por `::part(casca)`; a navegação cancelável de 28/09 vem junto.
