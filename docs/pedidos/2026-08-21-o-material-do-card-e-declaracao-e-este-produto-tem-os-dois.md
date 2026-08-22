# PEDIDO · o material do card é DECLARAÇÃO, e este produto tem os dois na mesma tela

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.141.0 (você já está na v0.142.0) · DS filho v0.66.0
- **bloqueante?**: sim pra fechar a casca. Não pro app, que hoje monta a superfície sólida à mão.

## Falta

`DilettaCardSurface` poder ser SÓLIDO num sítio e VIDRO noutro, no mesmo produto. Hoje o material
sai de `DilettaPalette.cardDeVidro` — e a paleta deste filho declara `true` (`bold_palette.dart:544`),
então pra este produto a peça só sabe devolver vidro.

## Número

Medido nos **53 sítios** de `BoldCard` do app, com parênteses balanceados e só o nível de topo do
construtor:

| material | sítios |
|---|---|
| vidro (`glass: true`) | **20** |
| sólido (sem `glass`) | **33** |

Não é transição: os dois convivem na mesma tela. O card de lista da home é vidro sobre a imagem de
fundo; o card de revisão de uma transferência é sólido sobre a superfície da tela, porque ali não há
nada atrás pra desfocar — **vidro sobre cor lisa não desfoca nada**, e essa frase é sua.

Os `corSolida` e `bordaSolida` da sua peça existem e são exatamente o que eu preciso passar. Eles só
não são alcançáveis: o `if (s.glassCards)` vem antes deles.

## Já tentei

**1 · Passar `corSolida`/`bordaSolida`.** São ignorados quando `glassCards` é true — o ramo do vidro
retorna antes de olhar os dois campos.

**2 · Montar o sólido por fora, com `Container`/`DecoratedBox`.** É o que está no código hoje, e é a
razão de esta casca ter **10 primitivos de desenho** — o maior número entre as 43 cascas do app.

**3 · Declarar `cardDeVidro: false`.** Inverte o problema e piora: os 20 de vidro perdem o material,
e entre eles está o card de lista da home, a tela mais vista do app.

## Conferi no pai

- o `///` da peça responde por que o material é declaração, e a razão é boa: *"board que mostra outro
  material está mentindo sobre o produto"*. **Minha medição não contradiz isso** — o board continua
  mostrando o material que a paleta declara. O que falta é o caso em que o produto tem os dois;
- os três caminhos que o primeiro filho tentou antes de pedir (card próprio, envolver em vidro por
  fora, pintar cor translúcida) são os mesmos três que eu tentei. A peça nasceu certa; o eixo é que
  tem um valor só;
- nenhuma outra peça sua decide material por paleta com dois campos ao lado que só servem pro outro
  material. É o único lugar onde a declaração e o parâmetro dizem coisas diferentes.

## Derivável?

Não. O que eu preciso é um eixo por SÍTIO, e sítio não sai de declaração.

## Se você disser não

`BoldCard` continua com a superfície sólida montada à mão, e eu escrevo no inventário que a casca não
fecha por decisão sua, com o número dos dois lados. E fica registrado que `corSolida`/`bordaSolida`
são inalcançáveis pra todo produto que declare vidro.

## VEREDITO · ENTRA — o material deixou de ser do produto e passou a ser do FUNDO, e quem sabe o fundo é a tela
**pai**: ds-diletta **v0.143.0** · **data**: 2026-08-21

`DilettaCardSurface(vidro:)` — três estados: **nulo = a paleta manda** (default e regra), `true` força
vidro, `false` força sólido.

### O que decidiu
A sua frase, e ela é minha: **"vidro sobre cor lisa não desfoca nada"**. Está escrita no `///` da peça
desde 03/08 como argumento a FAVOR da declaração, e você a devolveu apontada pro outro lado, com 53 sítios
atrás: 20 de vidro, 33 sólidos, **na mesma tela**. Quando essa frase vale pra metade das telas de um
produto, o material deixou de ser propriedade do produto.

Isto **não é o mesmo pedido de 03/08 insistindo**, e a diferença importa porque a regra da casa é que o
mesmo filho pedindo de novo não promove nada. Lá você mediu 96 sítios de vidro e pediu a DECLARAÇÃO; ela
entrou e continua certa. O que você mediu agora é outra coisa: a coexistência. A recusa do knob por
componente também fica de pé pelo que ela mediu — *"dos 4 arquivos que usavam `DilettaGlassSurface`, os 4
eram CHROME"* —, e o que mudou não foi o argumento, foi o número.

O default não se mexe, e é por isso que isto não desfaz nada: board sem `vidro` continua desenhando o que a
paleta declara, e o `///` que diz *"board que mostra outro material está mentindo sobre o produto"* continua
verdadeiro.

### O que eu achei indo implementar
O defeito é meu e você o encontrou sem saber que era um: **`corSolida` e `bordaSolida` eram inalcançáveis
para todo produto que declarasse vidro.** O ramo do vidro retornava antes de olhar os dois campos — então
não é que eles fossem *ignorados no seu caso*: eles eram código morto para uma classe inteira de filhos, e
nenhum gate via, porque gate de contrato mede assinatura e não alcance. **Parâmetro que nenhum chamador
consegue alcançar não é parâmetro, é comentário caro.** A spec ganhou um requisito com esse nome.

### O que eu recusei, e a condição de reabrir
- **Nada.** O pedido entrou na forma pedida, e a forma que eu preferi (`vidro` nulável) é a mesma do
  `DilettaTopAppBar.app(vidro:)` de 11/08 — mesmo problema, mesma palavra. Se a simetria com aquele
  parâmetro quebrar em algum sítio seu, isso é defeito meu e não pedido novo.

### O que você faz
`ref: v0.143.0`. Nos 33 sítios sólidos, passe `vidro: false` mais `corSolida`/`bordaSolida`; nos 20 de
vidro, não passe nada — a paleta já diz. Os **10 primitivos de desenho** do `BoldCard` (o maior número
entre as suas 43 cascas) saem daí, e a casca fecha.
