# PEDIDO · A web não tem a região `bottom` — e o console fixa a ação de salvar em três cópias da mesma folha

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não

## Falta

A barra de ação que fica no pé da janela enquanto o formulário rola, e pousa no fim do conteúdo quando ele acaba.

## Número

| sítio | o que é |
|---|---|
| `src/features/botoes/ui/TelaBotoes.module.css:285-297` (`.barraDeSalvar`, usada em `TelaBotoes.tsx:272`) | a original, em Ajustes |
| `src/features/pix/ui/TelaAbrirMed.module.css:75-87` (`.barra`, em `TelaAbrirMed.tsx:488`) | cópia, com o comentário *«a de Ajustes (`TelaBotoes.module.css`)»* |
| `src/features/tarifacao/ui/telas.module.css:100-112` (`.barra`, em `TelaTarifaPadrao.tsx:137`) | cópia, com o mesmo comentário |
| a receita, igual nas três | `position: sticky; bottom: s4; z-index: 10`; `surface` com borda `border`, raio `formaDeCartao` e sombra `elevation-overlayLg`; padding `s3 s4`; a linha de dentro em `space-between`, quebrando |
| `DilettaManifesto.busca` sobre as specs da `v3.19.0` | `busca('fixa')` → `[chat-typing-indicator, dev-inspect, sticky-header]` · `busca('rodapé')` → `[bottom-home-indicator, box, cobrand-mark, data-list, navigation-button]` · `busca('barra')` → 10 peças, nenhuma é barra de ação na web |

## Conferi no pai

- **A gramática tem a região**: `surface-grammar` (top · content · bottom), `bottom-app` com `livre(child:, altura:)`, e `navigation-button` (`ambos`: *«a pilha de 1 a 3 CTAs do rodapé de um fluxo»*). **Na web, nada disso**: o `navigation-button` não tem elemento entre os 49 arquivos de `src/` da `web-v3.19.0`, e a região `bottom` não existe. A web tem a barra de topo, a grade e o `content` com largura (24/09), e para aí.
- `sticky-header` é o título que gruda depois da rolagem, não a ação.

## Já tentei

Nenhuma alternativa construída além da cópia, e digo isso como informação: as duas cópias nasceram da original, e o comentário delas aponta para ela. O que a original registra é a razão do desenho (`TelaBotoes.module.css:280-284`): *«sticky no rodapé da janela enquanto a coluna rola, e pousada no fim do conteúdo. Superfície e elevação de folha flutuante — ela passa POR CIMA das seções, e sem a sombra o conteúdo que some por baixo pareceria cortado.»* `position: fixed` e botão solto no fim do formulário **não foram medidos** por mim.

## Derivável?

O desenho, sim: são papéis e tokens seus, e as três cópias provam isso. O que falta é o lugar da casa: a região `bottom` da web, com a regra de pousar no fim do conteúdo e de não cobrir o que está embaixo.

## Se você disser não

A folha vira uma classe compartilhada do console. A quarta tela com formulário longo copia de lá.

## Não estou pedindo

1. **o texto de «mudanças não gravadas» e a guarda do rascunho**: são da tela;
2. **a ordem e o peso dos botões**: o `navigation-button` já decide isso, e eu quero que ele decida aqui também.

## Como o pai vai saber que funcionou

O `navigation-button` (ou a região `bottom` da web) tem elemento: gruda no pé da janela enquanto há conteúdo abaixo, e pousa no fim quando o conteúdo acaba. Do lado de cá, as três folhas saem.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 6. Na rodada de 25/09 esta casa deixou a «barra de mudanças não gravadas» de fora porque a feature não existia. Agora existe, em três telas.
