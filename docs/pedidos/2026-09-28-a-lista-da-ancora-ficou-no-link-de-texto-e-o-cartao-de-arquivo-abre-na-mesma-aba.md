# PEDIDO · A lista da âncora ficou no link de texto — e o cartão de arquivo abre o documento na mesma aba

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0` e na `origin/main` (`6a2b756`)** — os seis arquivos citados são byte a byte os mesmos
- **bloqueante?**: **não** — o console põe um segundo link, «nova aba», nas ações do cartão
- **irmão**: [o link de texto monta a âncora com só `href`](2026-09-22-o-link-de-texto-monta-a-ancora-com-so-href.md) — é dele o veredito (**ENTRA COMO LISTA**, `web-v2.5.0`); este arquivo não o reabre, pergunta o alcance
- **não é peça nova**: a regra do `busca()` não se aplica

## Falta

`ATRIBUTOS_DA_ANCORA` (`target`, `rel`, `download`, `hreflang`, `referrerpolicy`) e o par
`noopener noreferrer` do `_blank` no `<a class="nome">` do `<diletta-file-card>`.

## Número

**Executado** em jsdom, com a tag instalada: cada peça que rende `<a>` recebe `href="/doc"
target="_blank" download` no hospedeiro, e eu leio o `<a>` de dentro do shadow.

```
diletta-text-link     target=_blank  rel=noopener noreferrer  download ✓
diletta-file-card     target=null    rel=null                 download ✗
diletta-button        target=null    rel=null                 download ✗
diletta-icon-button   target=null    rel=null                 download ✗
diletta-rail-item     target=null    rel=null                 download ✗
diletta-web-top-bar   target=null    rel=null                 download ✗
```

**Uma de seis.** A lista mora em `diletta-text-link.js:22`, é `const` local e não é exportada
(`:102` exporta só a classe); a função que a aplica, `atributosDaAncora`, também (`:26-41`). As
outras cinco montam a âncora só com `href` (`diletta-file-card.js:113`, `diletta-button.js:201`,
`diletta-icon-button.js:124`, `diletta-rail-item.js:92`, `diletta-web-top-bar.js:58`).

O pedido de 22/09 já contava cinco peças com `<a>` (o `web-top-bar` é a sexta) e escreveu, no gate
que propunha: *«toda peça da família que renda `<a>` repassa o mesmo conjunto»*. O veredito entrou
como lista e falou só do link de texto — **não recusou as outras nem as incluiu**. É esse silêncio
que eu pergunto.

## Onde dói, e é o cartão de arquivo

No console o nome do cartão é o link para o **conteúdo do documento** de um cadastro
(`TelaCliente.tsx:538-560`, `44da813`). O gestor abre o documento no meio de uma pendência; na mesma
aba, ele perde a tela e refaz o caminho. `download` teria o mesmo uso (o anexo baixado com o nome
certo) e também não chega.

## Já tentei

Um `<WaLinkDeTexto href target="_blank">nova aba</WaLinkDeTexto>` no slot `acoes` do cartão
(`TelaCliente.tsx:557-559`), sem `rel` de propósito porque o link de texto já o completa. Funciona e
põe **dois links para o mesmo destino** no mesmo cartão — o nome e o «nova aba» —, com
comportamentos diferentes, e nada na tela diz qual é qual.

Não dá para ajustar de fora: o `<a>` é do shadow, e `::part` estiliza, não põe atributo.

## Conferi no pai

- O veredito de 24/09 no nosso arquivo irmão e a linha 37 do `docs/PEDIDOS.md` da `origin/main`
  do `ds-diletta`: *«lista declarada, não campo por pedido, porque o terceiro caso chega sem aviso»*.
- `diletta-file-card.js:28-29`: `observedAttributes` sem nenhum dos cinco.

## Derivável?

Sim. A lista e a função existem; falta sair do link de texto para a `base.js` (como `mudouAtributo`
e `pinta`) e ser chamada onde há `<a>`. **Quantas das seis recebem é a pergunta** — o que eu meço é
o cartão de arquivo; nas outras quatro eu não tenho sítio contado.

## Se você disser não

O cartão continua com dois links. E a regra *«a nova aba sem `rel` é buraco, e quem fecha é a peça»*
vale numa peça de seis: o `_blank` nu volta a ser possível em qualquer outra que alguém embrulhe com
`target` por fora.

## Não estou pedindo

1. **que a peça decida o destino** — a heurística de URL continua errada, pelo mesmo motivo do irmão;
2. **as outras quatro por mim** — sem sítio contado, não peço; pergunto se a regra é da família;
3. **mudar o `|| '#'` padrão** do `rail-item` e do `file-card` — outro assunto.

## Como o pai vai saber que funcionou

O gate que o pedido de 22/09 descreveu: toda peça que rende `<a>`, com `target="_blank"` no
hospedeiro, tem `target` e `rel="noopener noreferrer"` no `<a>` de dentro. Hoje ele daria **1 de 6**.
Do lado de cá: o «nova aba» sai das ações do cartão, e o cartão ganha `target="_blank"`.

## Como cheguei aqui

Adotando o cartão de arquivo na ficha do cadastro do console (`feat/a-adocao-do-ds-pelo-webadmin`,
`44da813`, 28/09). O chat viu o documento abrir na mesma aba e anotou o remendo; a varredura das seis
é deste pedido.
