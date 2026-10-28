# PEDIDO · O aviso que fica não atravessa para a web — e o console montou dois à mão

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` · `web-v3.24.0`, na `main` deste repo (tags até `web-v0.128.0`); o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`), e as duas cópias dizem o mesmo no que este pedido mede
- **bloqueante?**: não. O console já desenhou as duas superfícies localmente e segue; o que fica é peça da linguagem montada fora dela, em dois lugares, com dois nomes
- **irmão**: `2026-10-26-a-mensagem-do-aviso-que-fica-some-no-escuro-e-o-aviso-novo-nao-se-anuncia.md` (a MESMA peça, pelo lado Dart: a tinta da mensagem no escuro e o anúncio — o que entrar lá vale para a instância web pedida aqui), `2026-10-16-o-degrau-web-da-esteira-nao-abre-e-nao-diz-qual-e-o-passo-atual.md` (a mesma tela de Limites › Pedidos; reaberto hoje com adendo) e `2026-10-28-o-no-de-passo-nao-tem-o-estado-falhou.md`

## Falta

Que o **`DilettaInlineAlert`** — «o aviso que fica: a mensagem persistente, no fluxo do conteúdo, que a
pessoa relê enquanto decide» (a sua spec) — tenha instância web: `<diletta-inline-alert>`, com o tom
(informação, sucesso, atenção, erro), o glifo derivado do tom, o título, o texto e um slot para a ação —
onde o filho põe o `<diletta-status-banner-button>`, que já atravessou.

## Número

**Na spec publicada do avô (`web-v3.24.0`, `versaoDaLinguagem 3.24.0`, lida em `packages/coreflow_design_system_web/node_modules/diletta-design-system-web/`; 106 peças):**

| peça | destino | o que é |
|---|---|---|
| `design-system-inline-alert` | `codigo` | o aviso que fica; papéis `errorSubtle`/`errorBorder`, `warningSubtle`/`warningBorder`, `successSubtle`/`successBorder`, `surfaceSubtle`/`border`, `fg`, `textTertiary` |
| `design-system-status-banner` | `codigo` | o card hero de estado da CONTA no topo da home — um por tela. Não é isto |
| `design-system-status-banner-button` | `ambos` | o CTA de largura cheia **dentro do aviso**. Este atravessou: `diletta-status-banner-button.js` |

O botão do aviso chegou à web; o aviso, não. Um filho que precise do aviso com ação tem o botão e não
tem onde pô-lo.

**No console (`core-flow-wa`, change `pedidos-de-limite`, 27–28/10), duas superfícies locais fazem as
vezes da mesma peça:**

| superfície local | onde | usos | o que é |
|---|---|---:|---|
| `WaLinhaDeAviso` (`design-system/molecules`) | a fila de pedidos (B24): «Pedido do Pix Automático perto do prazo», com «Abrir pedido» | 1 | o aviso que fica, COM ação — a faixa é local (tokens `infoSubtle`, `r2`), o botão é o `diletta-status-banner-button` |
| `.destaque[data-tom]` (`limites.module.css`) | a gaveta do pedido: a classificação explicada (B2) e «O provedor não aprovou» (B23) | 2 | o aviso que fica, SEM ação — título em negrito e texto, tingido pelo tom (`successSubtle`, `warningSubtle`, `errorSubtle`) |

**No Figma (Web-Admin, página `282:2099`):** a B24 usa a peça remota «Coreflow / Linha de aviso»
(`key 17faa856…`); a B23 usa a peça remota «InlineAlert» (`key 4d7515bc…`). Duas peças da biblioteca
para a mesma família, e nenhuma com instância web.

**No IB:** há um `BoldAlert` local em `design-system/molecules` e um `BoldBanner` (a faixa fixa no topo da
janela: offline, manutenção — essa é o `notice-banner`, outra peça). Não medi o `BoldAlert` a fundo; cito
porque é o terceiro lugar com um aviso que fica escrito à mão.

## Já tentei

- **Usar o `<diletta-status-banner-button>` sozinho**, dentro de uma faixa local: é o que o console faz
  na B24. Funciona, e a faixa é o que a linguagem devia pintar — a tinta do tom, o raio, o respiro.
- **Usar o `<diletta-dialog>` ou o `<diletta-toast>`**: não são «o que fica». O toast some; o diálogo
  prende.

## Conferi no pai

- A spec do `inline-alert` diz por que a peça existe e que o `DilettaStatusBannerErrorPanel` era ela,
  travada num tom e escondida como slot do banner de nível. A web repetiu a história: o botão do banner
  atravessou e o aviso ficou dentro de casa.
- O `diletta-status-banner-button.js` diz «fora do banner o botão é o `<diletta-button>`» — e, na web,
  não há banner para ele morar.

## Derivável?

Não: a faixa é tinta por tom, com glifo derivado e papéis de borda e fundo que só a peça conhece. Um
filho que derive escreve os papéis à mão (é o que o console fez) e os três filhos divergem.

## Se você disser não

O console mantém as duas superfícies locais, e o pedido fica como registro de que são a mesma peça.

## Não estou pedindo

O banner de estado da conta na web (`status-banner`): o console não tem home de conta. O
`notice-banner`. Um toast. Mudar a peça Dart.

## O que não medi

O `BoldAlert` do IB por dentro, e o `catalogo-diletta`. Não medi contraste das tintas no escuro: as
superfícies locais do console usam os papéis `…Subtle` da sua folha, que o seu gate mede.

## Como o pai vai saber que funcionou

`<diletta-inline-alert tom="atencao" titulo="Pedido do Pix Automático perto do prazo">Faltam 4 horas…</diletta-inline-alert>`
desenha a faixa tingida, com o glifo do tom, o título e o texto; com um `<diletta-status-banner-button slot="acao">Abrir pedido</diletta-status-banner-button>`
dentro, o botão aparece no lugar da ação. Sem título, só o texto. `role="status"` (ou o que a sua régua
de anúncio disser), para quem ouve saber que apareceu.

## Como cheguei aqui

A tela de Limites › Pedidos do console (PRs 5 a 8 da change `pedidos-de-limite`, 27–28/10). Ao montar a
B24 procurei a faixa no pacote web e achei só o botão dela; ao montar a classificação explicada e a
recusa do provedor, escrevi o `.destaque` e vi que era a mesma coisa sem ação. A spec do avô fechou o
nome: `inline-alert`, `destino: codigo`.
