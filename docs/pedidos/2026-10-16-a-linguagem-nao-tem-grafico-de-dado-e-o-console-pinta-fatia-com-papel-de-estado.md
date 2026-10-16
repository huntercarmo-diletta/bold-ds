# PEDIDO · A linguagem não tem gráfico de dado — e o console pinta as fatias com papéis de estado

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não

## Falta

| item | o que é | por que agora |
|---|---|---|
| 1 · as cores de série | papéis para categorias de dado, que não sejam os de estado | sem eles, cada gráfico pega emprestado o `success` ou o `warning`, e uma fatia passa a dizer «deu certo» ou «atenção» |
| 2 · a barra de dado horizontal | o valor de cada categoria como barra proporcional, com rótulo e número | 13 chamadas |
| 3 · a pizza ou rosca com legenda | a parte de um todo, com o nome e o número de cada fatia na legenda | 3 chamadas |
| 4 · a série temporal | o valor ao longo do tempo | 8 chamadas |

**O 1 vem antes dos outros três**, porque são eles que pintam com ele.

## Número

| peça do console | chamadas | linhas (tsx + folha) |
|---|---|---|
| `src/design-system/molecules/WaBarrasHorizontais.tsx` | **13 em 12 arquivos** | 195 |
| `src/design-system/molecules/WaPizza.tsx` | **3 em 3** | 239 |
| `src/design-system/molecules/WaSerieTemporal.tsx` | **8 em 5** | 770 |

**As cores das fatias** (`WaPizza.module.css:83-90`), em ordem: `primary`, `secure`, `success`, `textPrimary`, `primaryTrack`, `successBorder`, `warningBorder`, e `textMuted` para o resto. Sete papéis, e cinco deles são de estado ou de borda.

`DilettaManifesto.busca` sobre as specs da `v3.19.0`: `busca('gráfico')`, `('pizza')`, `('rosca')`, `('série')`, `('barra horizontal')`, `('indicador')`, `('métrica')` → todos `[]`.

## Conferi no pai

- `diletta-progress-bar.js` (`web-v3.19.0`): trilho de 5px (`:37`), `TONE = ['normal', 'warning', 'error']` (`:8`). É progresso, quanto falta, e o tom é de estado. Valor de dado não tem estado.
- `progress-ring` (`destino` de código): uma fração só, com rótulo no centro.
- `errorGrafico` e `warningGrafico` existem, com piso de objeto gráfico. São estado sobre trilho, não série.

## Já tentei

- **A barra de progresso como barra de dado**: 5px, trilho com borda e três tons de estado. O console fez a sua (`WaBarrasHorizontais.module.css:47-48`, trilho `border`, raio `formaDeCampo`).
- **Emprestar papéis de estado como série**: é o que a pizza faz hoje, e a folha declara a dívida.

## Derivável?

O item 1, talvez: se a linguagem já deriva os papéis de estado com piso contra a superfície, as cores de série podem sair da mesma conta. Se houver um jeito de compor que eu não vi, diga. Os itens 2, 3 e 4 não se derivam.

## Se você disser não

As três peças do console (1.204 linhas) continuam como o contrato de fato da web do Bold, e a paleta emprestada continua, declarada na folha.

## Não estou pedindo

1. **uma biblioteca de gráficos**: três formas, as que têm chamada;
2. **eixo, escala e interação** (dica ao passar o mouse, zoom, nota de eixo): a série do console tem, e isso fica lá;
3. **mais de sete categorias**: o contrato do servidor para em sete, e o resto vira «outras».

## Como o pai vai saber que funcionou

Os papéis de série existem, com piso de 3:1 contra a superfície nos dois modos (o piso de objeto gráfico), e as três formas pintam a partir deles. Do lado de cá, a pizza troca a paleta emprestada.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 11. Medido no código do console e no seu repo, pela tag.
