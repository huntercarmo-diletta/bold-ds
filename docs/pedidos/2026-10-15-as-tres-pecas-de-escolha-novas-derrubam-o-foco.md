# PEDIDO · As três peças de escolha novas derrubam o foco — o `pinta()` existe e elas não o usam

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.13.0` · `web-v3.13.0`, pela tag `web-v0.123.0` deste repo (medido em 14/10, no Chrome, tecla de verdade)
- **bloqueante?**: **sim, para a troca** — peça de escolha que perde o foco a cada tecla não serve a quem usa teclado; o IB não troca o checkbox nem o interruptor até isto entrar
- **irmão**: `2026-10-15-o-checkbox-e-o-interruptor-web-nao-tem-o-piso-de-44.md`

## Falta

Que `<diletta-checkbox>`, `<diletta-toggle-switch>` e `<diletta-radio-list>` desenhem pelo `pinta(host, html)` da `base.js`, que guarda e devolve o foco — e não por `this.shadowRoot.innerHTML = …` direto. O `pinta()` nasceu do pedido deste filho de 17/09 (*«o render da linguagem derruba o foco»*), e o veredito foi *«o conserto é de UMA função e não de oito peças»*. As três peças de 14/10 nasceram fora dessa função.

## Número

| medida | valor |
|---|---|
| `<diletta-toggle-switch>`: foco no `[role=switch]`, Espaço | liga (`mudou: true`) e o foco cai: `document.activeElement` deixa de ser o host, `shadowRoot.activeElement` = `null` |
| idem, Enter em seguida | **nada**: a tecla não chega a ninguém. Com o foco reposto à mão, Enter desliga — a tecla está implementada (`e.key !== ' ' && e.key !== 'Enter'`); o foco é que sumiu |
| `<diletta-checkbox>`: foco no `[role=checkbox]`, Espaço | marca e o foco cai, igual |
| `<diletta-input-chip>`: foco, Enter | alterna e o foco **fica** dentro (`pinta`) |
| `<diletta-segmented-control>`: foco, → | muda e o foco **fica** no segmento novo (`pinta`) |
| ocorrências de `pinta(` nos arquivos | `diletta-input-chip.js` 1 · `diletta-segmented-control.js` 1 · `diletta-checkbox.js` **0** · `diletta-toggle-switch.js` **0** · `diletta-radio-list.js` **0** |
| ocorrências de `this.shadowRoot.innerHTML =` | `diletta-checkbox.js:62` · `diletta-toggle-switch.js:51` (a lista de rádio, pelo mesmo molde) |

A consequência para quem usa teclado: marcar um checkbox com Espaço joga a pessoa para o `<body>`; o próximo Tab recomeça do início da página. Numa tabela de 20 linhas, é 20 vezes.

## Já tentei

Nada no IB: o conserto é de dentro do shadow, e escrever lá de fora é a mão que esta casa já recusou duas vezes (o remendo do foco da paginação foi declarado dívida por isso, em `BoldPagination.tsx`).

## Conferi no pai

- `base.js:161`, `pinta(host, html, { ancora, herdaTexto })`: guarda `raiz.activeElement`, reescreve e devolve o foco pela âncora. É a função do veredito de 17/09.
- As cinco peças do lote 1 da paridade (`v3.13.0`) vieram *«com a pintura gerada da tabela medida no render do Dart»*; a pintura entrou, o render guardado não.

## Derivável?

Não. O foco mora no shadow da peça.

## Se você disser não

O IB não adota checkbox, interruptor nem lista de rádio da web, e mantém as peças locais com teclado próprio. O Cockpit recebe três peças que não se usam pelo teclado.

## Não estou pedindo

Tecla nova: Espaço e Enter já estão lá. Pedindo só o render pela função que existe — três chamadas trocadas.

## Como o pai vai saber que funcionou

Depois de Espaço no `[role=checkbox]` e no `[role=switch]`, `host.shadowRoot.activeElement` continua sendo o controle; o gate do foco da `base.js` cobre as três.
