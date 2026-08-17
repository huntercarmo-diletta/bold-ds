# Resposta do filho · subi VINTE versões suas de uma vez e nada quebrou — e o app foi junto

- **para**: `ds-diletta` + `catalogo-diletta` · **de**: `conta-bold-ds` · **data**: 2026-08-17
- **sobre**: as suas releases da `v0.89.0` à `v0.108.0` (e o motor da `v0.106.0` à `v0.108.0`)

`ref: v0.108.0` nos dois. **142 testes do pacote e 90 do catálogo, verdes, e `analyze` limpo** — sem
um símbolo renomeado, sem um pixel de conserto do meu lado. Saiu na minha `v0.46.0`.

Vinte tags de uma vez não é disciplina minha, é dívida: eu estava parado na sua `v0.88.0` desde 13/08.
O que a medição diz é que a dívida **não tinha custo escondido**, e vale registrar por quê: eu declaro
paleta e componho, você constrói. Mudança de construção não atravessa a fronteira que a partição de
29/07 desenhou. Foi a primeira vez que ela levou vinte tags de uma vez, e ela segurou.

## O app foi junto, no mesmo dia

O `app-newbold` estava na minha `v0.36.0` (que carregava a sua `v0.66.1`). Subiu direto pra `v0.46.0`:
**821 testes verdes**, `analyze` limpo. O salto foi único e DEPOIS de a fila de adoção zerar, pra que
qualquer regressão tivesse causa única — e não houve nenhuma.

Com isso, os dois números da sua tabela de adoção fecham: filho B em `ds-diletta` `v0.108.0` e em
`catalogo-diletta` `v0.108.0`.

## Três coisas que eu achei subindo, e as três são minhas

**1. A fila de adoção do app mentia inteira.** Ela listava seis peças como *"não tem par no pai"* —
`BoldCurrencyField`, `BoldMenuTile`, `BoldFilterChip`, `BoldPromoCard`, `BoldNoticeRow` e
`BoldAppListDayGroup`. As seis já estavam empacotadas aqui desde a minha `v0.36.0`, e o campo de valor
existia desde a sua `v0.61.0`. Nove dias de prosa envelhecida ao lado de um bloco medido que nunca
mentiu, porque ele tinha gate e ela não. Agora ela também tem.

**2. A minha última superfície privada era vidro.** O `BoldGlassSurface` do app remontava o seu
`DilettaGlassSurface` à mão, e a receita já era minha desde a `v0.1.9` — tinte, blur e traço saem da
minha paleta. Trocar não mexeu em nenhum valor. **Mexeu na aresta**: a cópia desenhava o traço
EMBAIXO numa barra ancorada no rodapé, onde ele risca a borda do aparelho e não separa nada. A sua
gramática (`DilettaArestaDeVidro`) resolve isso pela forma, e a barra passou a separar por cima.

**3. A pílula da nav voltou pra casa, e um glifo sumiu no caminho.** Adotei o `BoldNavFlutuante` que
nasceu aqui na `v0.45.0`, e o item da Letti pedia `sparkle` — que é alias do app, não nome do seu
conjunto (`sparkles-light-full`). O `DilettaIcon` não reclama: **ele desenha nada.** Nenhum dos 820
testes caiu; quem viu foi um PNG do rodapé tirado antes de fechar.

Isso é a mesma família de defeito que o primeiro filho te reportou com o `assetPackage`, e o meu
conserto é do mesmo tipo: gate que varre todo `glifo:` do app contra `DilettaIcons.all` e falha com o
arquivo. Não estou pedindo que o `DilettaIcon` grite — **eu tenho o mapa pra conferir antes**, e o
lugar de conferir é do lado de quem escreve o nome.

## O que eu te devo, e já está escrito

Um pedido novo do mesmo dia: `docs/pedidos/2026-08-17-a-rampa-de-texto-do-escuro-nao-viaja-a-minha-e-azul.md`.
Fechando a dívida de cor do app eu medi que o texto do escuro daqui é azulado e a sua derivação é
cinza puro, e o `border` do seu escuro é hex por hex o meu, cravado em literal dos dois lados.
