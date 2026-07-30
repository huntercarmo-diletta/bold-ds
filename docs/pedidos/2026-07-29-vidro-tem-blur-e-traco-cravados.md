# Pedido · o vidro tem blur e traço decididos pelo pai

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.3.0
- **é bloqueante?**: não (entrego com o contorno abaixo, e o custo dele é ter dois vidros na
  mesma tela)

## O que falta

O `DilettaGlassSurface` decide o blur no componente e não tem traço; o vidro deste produto
tem outro blur e tem traço de 1px.

## A medição

**18 leituras do vidro em 7 componentes** do DS deste filho, mais 3 nas telas:
`card`, `glass_surface`, `promo_card`, `input_chip`, `bottom_app`, `tab_bar`, `app_bar`.

A spec do vidro daqui, comparada com a do pai:

| | pai | este filho |
|---|---|---|
| tinte | `glassTint`, já vem da paleta desde a v0.1.9 | vinho `#16060A` @ 50% escuro · branco @ 50% claro |
| blur | **10, constante dentro do componente** | **15** |
| traço | **não existe** | **1px** — rosa `#FF9898` @ 30% escuro · `primary08` claro |
| sombra | não usa | proibida, e a razão está escrita: sombra atrás de vidro é reamostrada pelo `BackdropFilter` e vira halo sujo |

O traço não é enfeite, e a razão medida está no código deste filho: **"a borda branca sumia
sobre fundo claro"**. Vidro branco @ 50% sobre fundo claro é superfície sem limite visível.

E isso já é regra do pai: a conformidade do catálogo tem `borda-invisivel`, com o motivo
escrito — "card, painel e campo ficam sem limite visível", limiar 1.06:1. O vidro claro do pai
é branco @ 80% sem traço nenhum, e passa hoje porque a conformidade olha os papéis do chrome,
não a superfície glassy.

## O que eu faço hoje sem isso, e o que isso me custa

Contorno possível: um decorador aqui que embrulha o `DilettaGlassSurface` e desenha só o traço
por cima.

O custo não é o arquivo, é a consequência: vidro é característica de CONTAINER — está escrito
na doc do componente do pai — e vários containers do pai são glass por dentro (`TopAppBar`,
`BottomApp`, `Toast`, `Sheet`). Com um vidro do filho por cima, este produto fica com **dois
vidros na mesma tela**: o meu nos cards, o do pai nas barras. Isso não aparece como bug,
aparece como "o app está meio inconsistente", que é a forma de defeito que ninguém abre ticket
pra consertar.

O que eu não vou fazer é reimplementar o `BackdropFilter`: o clip e o `saveLayer` do
componente do pai têm duas armadilhas documentadas lá, e as duas custaram tempo de alguém.

## Onde eu ACHO que mora

Token, com a forma do próprio pai. O `tinteDeVidroClaro/Escuro` entrou na v0.1.9 como campo
opcional da paleta com fallback neutro; blur e traço parecem ser a outra metade da mesma peça,
e ficaram de fora porque ninguém tinha medido um segundo vidro.

Se for por aí, o default que preserva o primeiro filho é blur 10 e traço nenhum — o que faz
disso um `minor`.

## Como o pai vai saber que funcionou

Dois gates, e o segundo é o que interessa:

1. o primeiro filho renderiza idêntico com os defaults (golden não muda um pixel);
2. **um teste de vidro na conformidade**: superfície glassy sobre o fundo do tema precisa ter
   limite visível — traço ou contraste de tinte — no mesmo limiar de 1.06:1 que a regra
   `borda-invisivel` já usa. Sem esse gate, o vidro claro continua sendo o único lugar do
   sistema onde a regra de borda não é cobrada.
