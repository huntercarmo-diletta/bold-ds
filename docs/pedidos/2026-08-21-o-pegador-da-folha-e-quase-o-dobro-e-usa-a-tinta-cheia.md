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

## VEREDITO · ENTRA DIFERENTE — não vira campo: os meus dois números estavam errados, e o conserto é meu
**pai**: ds-diletta **v0.143.0** · **data**: 2026-08-21 · **BREAKING**

O pegador do `.bottomsheet()` passa a **40 × 4 em `textMuted`**. Sem campo de paleta, sem parâmetro, sem
variante.

### O que decidiu
A sua pergunta, não o seu pedido: *"se houver medição atrás desses dois números, ela decide e eu adoto."*
**Não havia.** Fui procurar como você pediu e a resposta é vazia dos três lados — nenhuma paleta declara o
traço, nenhum arquivo de Figma dos dois filhos o desenha como componente, e o `///` da variante dizia
*"container branco opaco com grip no topo"* sem um número justificado. `75 × 5` em `s.fg` era constante sem
autor.

Você ofereceu a saída errada com elegância (*"eu delego e fico com o seu"*) e ela é justamente a que eu não
podia aceitar: **adotar um número que ninguém mediu é como ele vira lei.**

A faixa do mercado desempata sem precisar de gosto de ninguém: Material 3 desenha **32 × 4** em
`onSurfaceVariant`; o grabber do iOS, **36 × 5** em cinza. Os dois estão do seu lado, e o seu 40 × 4 está
dentro da faixa. Peguei o seu número — não por ser seu, mas por ser o topo da faixa e o único com medição
escrita. A tinta é `textMuted` cheia, e não `textMuted` a 50% como a sua: o papel já é o mudo, e mudo sobre
mudo é o degrau que some no escuro.

**Por que não vira declaração**, que era a sua preferência: um único sítio desenha o grip no repo inteiro,
e você mesmo mediu isso. Campo de paleta pra valor com um consumidor é a "forma cravada" ao contrário —
cobra 109 peças de declaração pra resolver uma. Se um terceiro produto discordar do 40, aí sim vira campo,
e a condição está escrita abaixo.

É **BREAKING**: muda pixel nas folhas dos dois filhos. O seu ganha o desenho que já tinha; o do irmão muda
sem ter pedido, e ele vai receber o aviso com o número.

### O que eu achei indo implementar
Nada de novo aqui além do que você já tinha achado — e é o caso mais limpo do dia: **o pedido não achou um
buraco na linguagem, achou um número sem dono dentro dela.** Vale registrar a classe, porque ela repete: o
`raioDeBotao` era exatamente isto antes de virar campo, e o que o separou de virar campo naquele caso foi
haver um segundo consumidor discordando. Aqui não há.

O gate que faltava agora existe: `os_cinco_do_filho_b_test.dart` mede o traço RENDERIZADO. Antes disto, os
dois números podiam mudar sem nada reclamar — que é como eles ficaram errados por tanto tempo.

### O que eu recusei, e a condição de reabrir
- **`pegadorDaFolha` como campo de paleta / papel declarável.** Um consumidor não sustenta campo.
  **Reabre no primeiro produto que medir um pegador diferente de 40 × 4 com a tela do lado** — e aí ele
  nasce como campo, não como variante.

### O que você faz
`ref: v0.143.0`. Apague o `_buildSheet` do `bold_top_bar`: o resto dele já era a minha composição
(`DilettaNavigationTopBar` com o acessório de fechar), e o pegador era a única coisa segurando o método.
