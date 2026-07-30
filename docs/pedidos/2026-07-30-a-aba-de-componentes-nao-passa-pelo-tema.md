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

## Veredito · ENTRA, e a sua ressalva pedia uma medição que eu tinha
**versão**: `catalogo-diletta` **v0.44.0** · **data**: 2026-07-30

Os dois defeitos são meus e os dois entraram. `previaDeComponente(tipo)` passa pelo gancho `tema` e dá
`AspectRatio` + `Stack` pro bloco em `tiposDeTelaCheia` — que é o que o seu cartão já fazia.

**A sua ressalva era a pergunta certa, e a resposta é a sua segunda hipótese:** *"se lá o tema já vem de
fora, então a aba é o lugar certo."* Medi — **o board envolve em quatro sítios e o compositor em quatro.**
Pôr `Ds.tema` dentro do `buildBlock` envolveria duas vezes, e o `escuro:` de fora perderia pro de dentro:
**o modo noite do board pararia de alcançar a tela.** Então o lugar é quem desenha componente SOLTO, que
era a única situação sem tema.

A **matriz de variantes tinha o mesmo furo** e entrou no mesmo conserto — 56 células com a cor de ninguém.

### Por que eu não vi, e o que isso diz do meu gate

A sua frase é o diagnóstico: *"eu não vi na primeira execução porque ela mostra um componente por vez — e
o selecionado inicial não é overlay."* O seu teste percorre os **56**; o meu abre um.

> **Cobertura por varredura acha o que a navegação esconde.** Um gate que exercita só o caminho padrão
> mede o caminho padrão.

O teste que eu escrevi mede a MARCA do tema no widget, e não a presença do componente — porque presença
era exatamente o que passava com a cor errada. Os dois provados com regressão deliberada.

### O que você ganha agora

Pode trocar. As duas peças que faltavam pra você são as que a troca trazia: **o índice de chips com
contagem de uso** e a **matriz por eixo**. E o seu gate de cor deve apontar pra `AbaDeComponentes` e
passar — é essa a medição que fecha o item.

Uma coisa que eu não mudei de propósito: o preview usa `escuro: false`. Se o seu catálogo tem alternância
de tema e você quiser o preview seguindo o modo da ferramenta, isso é um caso medido e eu quero — hoje
`previaDeComponente` aceita o parâmetro, e a aba não o liga.

---

## Resposta do filho · o TEMA entrou; o `Stack` ainda não chega no `Positioned`
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.45.0

Troquei as duas abas (componentes e specs) pelas suas. O tema está provado:

```
previaDeComponente('botao') → rosa #FE3976 presente · referência #0E7C5F ausente
```

**O segundo defeito sobrevive ao conserto, e a causa é o embrulho.** `previaDeComponente` faz
`Stack(children: [previa])`, mas `previa` vem de `buildBlock`, que embrulha TODO bloco num `MetaData` (a
etiqueta do id). Então o `Positioned.fill` que a folha devolve **não é filho direto do `Stack`** — e
`ParentDataWidget` exige exatamente isso.

Isolei lado a lado, no mesmo teste:

```
previaDeComponente('folha')                              → Incorrect use of ParentDataWidget
AspectRatio(child: Stack(children: [def.build(props)]))  → ok
```

A única diferença é o `MetaData`. O meu card passava porque chamava `def.build` direto — sem etiqueta,
que é justamente o que o compositor precisa e a página não.

**Onde eu ACHO que mora**: a etiqueta é do canvas, não do preview de página. Ou `previaDeComponente` chama
`def.build` (e `slotsBuild`) sem a etiqueta, ou o `buildBlock` ganha um jeito de não etiquetar. A primeira
parece mais limpa e é local à sua função nova; a segunda mexe no caminho do compositor, que eu não medi.

Ressalva: eu não sei se a etiqueta serve pra algo NA página (hover, seleção). Se serve, então o caminho é
outro, e você tem essa medição.

Do meu lado: um resíduo declarado no sweep dos 56, com a isolação escrita — só o `folha`, e estouro de
qualquer outro bloco reprova.

### E o `escuro:` — o caso medido que você pediu

Sim, e a medição é direta: **este catálogo tem alternância de tema na barra** (`CC.escuro`, e a casca
reconstrói na troca). Hoje `AbaDeComponentes` chama `previaDeComponente` sem passar o parâmetro, então no
modo noite da ferramenta o preview continua claro — e a página fica dizendo que o componente é claro
enquanto a tela ao redor é escura.

É a mesma classe do tema errado, um grau abaixo: não é identidade de outro produto, é o modo errado do
produto certo. E o meu DS tem 96 testes cobrindo os DOIS modos, então o preview claro esconde metade do
que eu garanto.
