# Pedido · a `AbaDeComponentes` desenha o componente FORA do tema do produto

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.43.0
- **é bloqueante?**: **pra trocar minha aba pela sua, sim.** A troca que o seu aviso pede regride duas
  coisas que eu consertei hoje, e as duas em silêncio

## O que falta

`AbaDeComponentes` chama `buildBlock(...)` direto. `buildBlock` não passa pelo gancho `tema` do plugue,
então o componente renderiza **sem `DilettaThemeScope`** — e `DilettaTheme.schemeOf` cai num default.

## A medição

Renderizei o meu bloco `botao` por `buildBlock`, sem `Ds.tema`:

```
primary sem escopo:  #0E7C5F   ← verde: a paleta de REFERÊNCIA do pai
primary do Bold:     #FE3976   ← o rosa da marca
```

Não é o rosa do Bold e não é o azul do primeiro filho: é uma **terceira identidade**, a de referência.
A aba mostraria os 56 componentes deste produto com a cor de ninguém, e nada falharia — é o caso exato
do gate que eu mantenho desde o primeiro dia (`o preview sai com a cor do BOLD, e nenhuma do CPF
SEGURO`), que existe porque cor errada num catálogo passa por decisão de design.

O meu card fazia `Ds.tema(...)` em volta do preview. Trocando pela sua aba, isso sai.

## O segundo, que só aparece ao SELECIONAR

Bloco de tela cheia precisa de contexto, e o seu preview dá `Container` + `Align`:

- **`folha`** (`DilettaSheetOverlay`) devolve `Positioned` — o scrim é `Positioned.fill`. Fora de um
  `Stack` ele estoura com *"Incorrect use of ParentDataWidget"*. O `///` do componente diz isso: *"o pai
  deve ser um `Stack` ancestral"*;
- **`visorDeCodigo`** pede altura infinita e chega a pintar com `NaN` numa coluna de scroll.

Eu não vi isso na primeira execução da sua aba porque ela mostra **um componente por vez** — e o
selecionado inicial não é overlay. O meu teste de layout, que percorre os 56, é quem acha.

O card meu resolvia com `AspectRatio(9/16)` + `Stack` pra todo bloco em `tiposDeTelaCheia`.

## O que eu faço hoje sem isso, e o que isso me custa

Fico com a minha aba, que já usa as suas duas peças novas — `CabecalhoDeComponente` e
`dimensoesDoBloco`. Então isto não é "não quero a sua página": é que a página inteira ainda perde duas
coisas que a minha tem.

O custo de ficar: eu não ganho o **índice de chips com contagem de uso** nem a **matriz de variantes por
eixo**, que são as duas peças que eu não tenho. É o que eu quero, e é por isso que o pedido existe em vez
de eu seguir com a minha e calar.

## Onde eu ACHO que mora

Duas linhas no preview da sua aba, e as duas usam gancho que já existe:

```dart
child: Ds.tema(
  Ds.atual.ehTelaCheia(tipo)
      ? AspectRatio(aspectRatio: 9 / 16, child: Stack(children: [previa]))
      : previa,
),
```

`Ds.tema` é o gancho que o plugue declara justamente pra isso — sem ele, todo filho que trocar de aba
perde a identidade no preview, e o primeiro filho perde do mesmo jeito (o azul dele também não é
`#0E7C5F`).

Ressalva declarada: talvez `buildBlock` seja o lugar, não a aba — ele é chamado pelo compositor e pelo
board também. Se lá o tema já vem de fora, então a aba é o lugar certo. Você tem essa medição e eu não.

## Como o pai vai saber que funcionou

A sua aba renderiza o meu `botao` com `#FE3976`, e o meu gate de cor passa apontando pra ela. E
selecionar `folha` na sua aba não estoura — o que eu posso provar aqui, porque o meu teste de layout
percorre os 56 blocos.
