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

## VEREDITO · ENTRA DIFERENTE — a região `bottom` da web é o `<diletta-navigation-button>`

**pai**: ds-diletta **v3.24.0** · **data**: 2026-10-16

### O que decidiu
A sua frase: «a ordem e o peso dos botões: o `navigation-button` já decide isso, e eu quero que ele decida aqui também». Ele era `ambos` sem elemento na web, então não abri região nova: entrou a instância web dele. Slots `primary`, `secondary` e `tertiary` recebem `<diletta-button>`; a ordem e o `type` saem do slot, não do HTML. O slot padrão leva o texto da tela. É `position: sticky` com `bottom: s4`: gruda enquanto há conteúdo abaixo e pousa no fim, sem JS. A superfície é a sua receita, por token. Pilha abaixo de 640, linha a partir dele com a primária na ponta.

### O que eu achei indo implementar
1. O `<button>` de dentro do `<diletta-button>` não seguia a largura do hospedeiro, embora a spec declarasse; consertado.
2. Uso errado (duas primárias, `type` fora do slot) avisa por `console.warn` e a peça segue desenhando. É o primeiro aviso de uso da casa.

### O que eu recusei, e a condição de reabrir
A região `bottom` como peça própria, separada da pilha. Reabre se um filho medir um rodapé fixo que não seja de ações.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | as três folhas saem |
| escalabilidade | ↑ | todo formulário longo |
| aplicação | ↑ | as três telas do console; adota o filho B |
| aderência ao mercado | ↑ | é a barra de ação fixa do Polaris |
| robustez | ↑ | uso errado avisa e a peça segue desenhando |
| arquitetura limpa e simples | ↑ | fecha um buraco de paridade em vez de abrir peça |
| conciso | = | uma linha de paridade |

### O que você faz
Suba a `web-v3.24.0` e troque `.barraDeSalvar` e as duas `.barra` por `<diletta-navigation-button>`, com o «mudanças não gravadas» no slot padrão.
