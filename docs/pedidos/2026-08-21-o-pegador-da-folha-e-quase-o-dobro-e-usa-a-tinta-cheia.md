# PEDIDO · o pegador da folha é quase o DOBRO e usa a tinta cheia

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.141.0 (você já está na v0.142.0) · DS filho v0.66.0
- **bloqueante?**: sim pra `bold_top_bar._buildSheet` delegar — a casca monta a sua variante à mão.

## Falta

O **pegador** (grip) do `DilettaTopAppBar.bottomsheet` ser declarável, ou ser medido. Hoje é constante
da peça, e a constante é grande.

## Número

Medido nos dois arquivos:

| | você (`_BottomsheetVariant`) | eu (`bold_top_bar`) |
|---|---|---|
| traço | **75 × 5** | **40 × 4** |
| tinta | `s.fg` — a primária, cheia | `textMuted` a **50%** |
| respiro | `SizedBox(height: 24)`, centrado | margin 10 / 6 (= 20) |
| casca | `s.surface`, raio r24 no topo | `c.surface`, raio de folha no topo |

**A casca é a mesma; o traço é 87% mais largo e sai da tinta de texto primária.** O resto do meu
`_buildSheet` é a sua composição — `DilettaNavigationTopBar` com o acessório de fechar —, então o
pegador é a única coisa que me impede de apagar o método.

## Já tentei

**1 · Delegar e aceitar o seu.** É o caminho que eu quero, e não é meu de aceitar: um traço de 75×5
na tinta cheia é um elemento a mais competindo com o título da folha, e o desenho deste produto pede o
oposto — o pegador é affordance, não conteúdo.

**2 · Envolver a sua variante e repintar o traço por cima.** Dois traços no mesmo lugar, com o de
baixo aparecendo nas pontas.

**3 · Declarar na paleta.** Não existe campo — é por isso que este pedido é um pedido e não uma
declaração minha.

## Conferi no pai

- **um único sítio desenha o grip** no repo inteiro (`_BottomsheetVariant`), então não há segundo
  consumidor pra empatar a decisão;
- nenhuma paleta declara nada sobre ele: não é escolha de produto hoje, é constante da peça — a mesma
  classe do `raioDeBotao` antes de virar campo;
- o `///` da variante descreve o pegador como parte da casca (*"container branco opaco com grip no
  topo"*) e não diz por que 75 × 5. Se houver medição atrás desses dois números, ela decide e eu
  adoto — o pedido passa a ser só a linha na spec.

## Derivável?

**Sim, e é o que eu prefiro**: se o pegador virar papel (tinta + porte) ou campo de paleta, sai da
minha casca sem virar variante nova.

## Se você disser não

Eu delego a folha inteira e fico com o seu pegador, ou mantenho o método com a razão escrita. As duas
são resposta; hoje o que existe é uma cópia sem razão.
