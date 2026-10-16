# PEDIDO · A gaveta lateral não existe na linguagem — e os dois filhos escrevem a sua

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o consumidor medido, o console `core-flow-wa`, prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não. O console tem a sua, e ela funciona; o preço está em «Se você disser não»

## Falta

Uma superfície que abre um registro pela direita, na altura da janela, sem tirar a lista da tela e sem prender o foco.

## Número

| medida | valor |
|---|---|
| a do console: `WaDetailPanel` (`src/design-system/organisms/WaDetailPanel.tsx`, 217 linhas, mais 95 de `.module.css`) | **30 chamadas em 18 arquivos** (sem teste nem story) |
| a anatomia que ela fixou | largura `clamp(35rem, 45vw, 52rem)` e tela cheia no estreito (`WaDetailPanel.module.css:24-26`); título, etiqueta de estado e ações principais no cabeçalho, ao lado do ✕ (props `etiqueta` e `acoes`, decisão da designer de 29/09); excluir no fim, separado por fio (`acaoDeExcluir`); fecha no ✕, no Esc (menos a partir de campo em edição ou de diálogo aberto dentro dela, `escDeveFicar`, `:61-66`) e no clique fora (`pointerdown`, `:155`), que se desliga enquanto há edição não salva (`fecharNoCliqueFora`); ao fechar, devolve o foco a quem abriu; é `region` nomeada pelo título, **não** `dialog` (`:51-63`) |
| o seu censo do filho A (`docs/O-QUE-A-WEB-USA.md:360`, na `v3.19.0`) | **«gaveta lateral · — · não existe · 325 linhas»**, no backoffice dele |
| `DilettaManifesto.busca` sobre as specs da `v3.19.0` | `busca('gaveta')` → `[]` · `busca('drawer')` → `[]` · `busca('painel')` → `[segmented-control, status-banner-error-panel]` · `busca('lateral')` → `[rail-item]` · `busca('detalhe')` → `[amount-display, detail-row, status-banner-button]`. Nenhuma é gaveta |

## Já tentei

- **O `<diletta-dialog>`**, que aceita conteúdo pelo slot `conteudo`: é o diálogo central, prende o foco e para a tela; a spec dele diz *«a pergunta que interrompe»*. A gaveta faz o contrário: quem investiga compara duas linhas com ela aberta, e prender o foco tira metade desse trabalho (o `///` de `WaDetailPanel.tsx:51-63` escreve isso).
- **A folha (`SheetOverlay`)**, por leitura da spec: sem elemento web, sobe de baixo, com scrim. É continuação de fluxo no celular, não painel de leitura ao lado de uma tabela.
- **Ter a nossa**: é o que existe. E uma segunda cópia já nasceu ao lado dela (a `.doca` de `TelaAoVivo.module.css` e `TelaHistorico.module.css`, registrada na rodada de 25/09 deste repo).

## Conferi no pai

- **Em 25/09 esta casa não pediu a gaveta**, com esta razão: *«sem segundo consumidor, pedir peça seria pedir por um produto só»* (`docs/FILA-DOS-CHATS.md`, rodada de 25/09 · tarde, item 5). **O seu próprio censo derruba a razão**: a segunda medição (14/09) conta 325 linhas de gaveta lateral no backoffice do filho A, na mesma tabela da tabela, da paginação e do trilho. Esses três têm instância web; a gaveta não tem em lado nenhum.
- Os 49 arquivos de `src/` da `web-v3.19.0`: nenhuma gaveta.

## Derivável?

Não. É superfície nova: posição, largura, regra de foco e regra de fechar. O conteúdo de dentro é composição (detalhe, tabela, botão), e não peço conteúdo.

## Se você disser não

O `WaDetailPanel` segue como o contrato de fato da web do Bold, o filho A segue com o dele, e a regra do foco (não prender, devolver ao fechar) fica escrita duas vezes, por dois times, sem spec.

## Não estou pedindo

1. **a largura do console** (35–52rem): é medida de um console denso, e a sua pode ser outra;
2. **pilha de gavetas com «volta»**: não achei um sítio no código, só a ideia, e por isso fica de fora;
3. **o lado Dart**: a ordem dos dois lados é sua;
4. **o conteúdo** (ficha, linha do tempo, degrau aberto): são pedidos separados, de hoje.

## Como o pai vai saber que funcionou

Uma peça em que abrir não move o foco e o Tab sai dela; o Esc fecha, menos a partir de campo em edição ou de diálogo aberto dentro dela; fechar devolve o foco a quem abriu; o clique fora fecha e pode ser desligado; e ela é região nomeada pelo título, não `dialog`. Do lado de cá, o `WaDetailPanel` vira embrulho dela nas 30 chamadas.

## Como cheguei aqui

Lote do webadmin de 07–16/10 (sessão principal do `core-flow-wa`), item 5. Medido no código do console, na ponta da release, e no seu repo, pela tag.

## VEREDITO · ENTRA — `<diletta-side-sheet>`, região que não prende o foco

**pai**: ds-diletta **v3.24.0** · **data**: 2026-10-16

### O que decidiu
A sua frase: «o seu próprio censo derruba a razão». Dois filhos medidos, nenhuma instância em lado nenhum. Entrou o contrato que você escreveu: `role="region"` nomeada pelo título, abrir não move o foco, Esc fecha (menos a partir de campo em edição ou de diálogo aberto dentro), o clique fora fecha e `fecha-fora="nao"` desliga, e fechar devolve o foco. Slots `estado`, `acoes`, o corpo e `rodape` (o fio só aparece com conteúdo). Eventos `fechando`, cancelável, e `fechou`, como no `<diletta-dialog>`: a tela é dona do `aberto`.

### O que eu achei indo implementar
1. A devolução do foco ganhou uma borda: ela só volta a quem abriu se o foco estava dentro da gaveta ou em lugar nenhum. Senão, clicar em outra linha da lista perderia o foco dessa linha. Está escrito na spec.
2. A linguagem não tem token de camada, então a gaveta não tem `z-index`. Ajuste por `::part(gaveta)`.
3. O `spec-publicada.json` estava atrás das specs; regerado.

### O que eu recusei, e a condição de reabrir
A largura do console. A da linguagem é 640, o `sm`, e a janela inteira abaixo do `md`. Se 640 não servir à densidade do console, `::part(gaveta)` ajusta; reabre se o segundo filho também ajustar.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | duas gavetas viram uma |
| escalabilidade | ↑ | dois filhos medidos |
| aplicação | ↑ | as 30 chamadas do console; adota o filho B |
| aderência ao mercado | ↑ | é o *side sheet* do M3 |
| robustez | ↑ | 8 testes do contrato de foco |
| arquitetura limpa e simples | = | a convenção de eventos do diálogo |
| conciso | = | uma spec |

### O que você faz
Suba a `web-v3.24.0` e faça o `WaDetailPanel` embrulhar a `<diletta-side-sheet>`: `fecharNoCliqueFora` vira `fecha-fora="nao"`, e `acaoDeExcluir` vai no slot `rodape`.
