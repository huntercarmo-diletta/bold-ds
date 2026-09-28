# PEDIDO · As abas e os links da linguagem não sabem navegar num app de página única

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `origin/main` (`6a2b756`)** — as linhas do `diletta-tabs.js` citadas são as mesmas
- **bloqueante?**: **não** — o console tem uma ponte (`LinkDeRota`) para os links e `NavLink` à mão para as abas
- **irmãos**: [as abas não têm nome, e o painel perde o dele](2026-09-17-as-abas-nao-tem-nome-e-o-painel-perde-o-dele.md) (nome do `tablist`, outro assunto) · [o link de texto monta a âncora com só `href`](2026-09-22-o-link-de-texto-monta-a-ancora-com-so-href.md) (os atributos da âncora, **ENTRA COMO LISTA**)
- **não é peça nova**: o `busca()` não se aplica

## Falta

Duas coisas, e as duas são a mesma pergunta — *como a peça da linguagem leva a outro endereço dentro
de um app que tem roteador*:

1. **`<diletta-tabs>` em modo navegação**: cada aba com um endereço, desenhada como `<a href>` com
   `aria-current="page"`, e não como `<button role="tab">` que emite um índice;
2. **as peças que rendem `<a>` avisarem a navegação** — o `text-link` e o `breadcrumb` (e, pela mesma
   razão, o `rail-item`) —, com um evento **cancelável** no clique simples, para o roteador de quem
   consome navegar sem recarregar a página.

## Número

**As abas.** A spec põe a peça na família *«Navegação — leva de um lugar a outro»*
(`specs/design-system-tabs/spec.md:14`) e escreve o caso *«a barra que é navegação»*
(`:71-84`). O elemento não leva a lugar nenhum: rende `<button class="aba" role="tab">`
(`diletta-tabs.js:120`) e emite `mudou` com `{ indice }` (`:65`). Não há endereço, então não há
nova aba, nem voltar do navegador, nem `aria-current`.

No console (`c928892`) são **seis faixas de navegação** que por isso não usam a peça:

- a navegação principal, 6 itens (`app/navegacao.ts:149-154`), em `NavLink` (`LayoutAutenticado.tsx:90`);
- as abas de área, em `NavLink` (`app/router.tsx:207`), em **cinco áreas**: `:248` Acessos, `:280`
  Relatórios, `:309` Conversas, `:530` Cadastros, `:542` Marca.

As seis já foram **desenhadas na anatomia do `diletta-tab-item`** nesta passada (`labelLg`, 48px,
recuo 12, sublinha da marca — `LayoutAutenticado.module.css`, `AreaComAbas.module.css`). É a peça
copiada à mão porque não dá para usá-la. O próprio código diz o porquê (`router.tsx:256-268`): um
`WaTabs` *«teria que receber `<a href>` cru (perdendo o roteamento do cliente) ou devolver nomes de
classe para o chamador montar os links — as duas piores que uma folha compartilhada»*.

**Os links.** O `<a href>` do shadow não conhece o roteador: sem interceptar, o clique recarrega o
app inteiro. O console escreveu `shared/ui/LinkDeRota.tsx` (28/09) — o `WaLinkDeTexto` com o
endereço de verdade, e no clique simples (`ehCliqueSimples`: botão 0, sem Ctrl/Cmd/Shift/Alt) o
`preventDefault` no hospedeiro + o roteador. **14 chamadas em 6 arquivos**, e o mesmo critério de
clique reescrito em mais quatro lugares (`TelaDaMesa.tsx:427` e três gráficos). Funciona porque o
clique nasce no `<a>` do shadow, sobe composto, e o `preventDefault` do hospedeiro ainda vale — a
auditoria de 28/09 mediu isso numa página viva (rota `/acessos`, sem recarregar); no console, `LinkDeRota.test.tsx:43-52` cobre o clique simples e o
Ctrl, em jsdom.

**E o `breadcrumb` é pior**: ele monta um `<diletta-text-link>` por nível dentro do próprio shadow
(`diletta-breadcrumb.js:54`). Não há hospedeiro por nível onde pendurar o clique; quem consome teria
que ler o `composedPath()` para descobrir qual nível foi clicado. O console ainda não o usa (a troca
do «← Voltar» pela trilha é decisão aberta da designer), e é por isso que o custo não está contado.

## Já tentei

1. **`<diletta-tabs>` + `mudou` + `navigate(rotas[indice])`.** Navega, mas a aba continua sendo
   `<button>`: não abre em nova aba, não tem endereço para copiar, e o leitor de tela anuncia uma
   aba de painel onde há uma troca de página.
2. **A ponte `LinkDeRota`**, que é o que está em produção. Ela depende de um detalhe de propagação
   que ninguém prometeu — o dia em que a peça tratar o clique por dentro, as 14 chamadas passam a
   recarregar a página, e nenhum teste da linguagem vê.

## Conferi no pai

- `diletta-rail-item.js:92-93` já rende `<a href>` com `aria-current="page"` — **a forma da navegação
  já existe na casa**, numa peça de trilho.
- O precedente do evento cancelável é seu, de 25/09: o `cancel` do diálogo virou `fechando`,
  cancelável — *«booleano não diz "depende"»*. Navegar é o mesmo caso: a peça não sabe se o destino
  é interno.

## Derivável?

Os links, sim — é a ponte. As abas, não: o `<button>` é do shadow.

## Se você disser não

As seis faixas continuam em `NavLink` com o desenho da peça copiado, e a ponte fica como contrato
não escrito entre o console e a propagação do clique.

## Não estou pedindo

1. **que a peça importe um roteador** — a linguagem é de apresentação; o evento é o que basta;
2. **que a peça decida se o destino é interno** — quem consome sabe; a peça só avisa e deixa cancelar;
3. **mudar as abas de painel** — o `role="tab"` continua certo para trocar conteúdo na mesma página.
   É um modo a mais, não uma troca.

## Como o pai vai saber que funcionou

`<diletta-tabs>` com endereços rende `<a href aria-current="page">`, e Ctrl+clique abre nova aba. Um
clique simples num `text-link`, `breadcrumb` ou `rail-item` emite um evento cancelável com o endereço;
cancelado, a página não recarrega. Do lado de cá: as seis faixas viram a peça, e o `LinkDeRota` passa
a ouvir o evento em vez de interceptar o clique.

## Como cheguei aqui

Pela passada «o DS em tudo» do webadmin (tarefa 1.12 de `arquitetura-de-informacao-do-console`,
`c928892`, 28/09): a passada escreveu o `LinkDeRota` e trocou os links à mão de Cadastros,
Conversas, casca e erro por ele (três estavam no azul padrão do navegador). A auditoria de casca e a de
Cadastros levantaram as abas e o `breadcrumb`.
