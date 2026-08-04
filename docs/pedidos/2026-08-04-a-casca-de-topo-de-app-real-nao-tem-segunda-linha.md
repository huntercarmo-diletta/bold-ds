# Pedido · a casca de topo de APP REAL não tem segunda linha, e um componente MEU está encalhado nela

- **filho**: conta-bold-ds v0.14.0 · app-newbold `feat/adota-conta-bold-ds` (commit `58b0aba`)
- **pai**: ds-diletta v0.38.0 (`DilettaTopAppBar`, `DilettaNavigationTopBar`)
- **é bloqueante?**: **não pra barra** — a barra subiu hoje e o app está verde. **É bloqueante pra
  casca**: sem o item 1 eu não consigo apagar a minha, e sem o item 2 quatro telas não têm onde ir

## Primeiro, o que subiu — e o `.livre` era mesmo o gancho certo

`bold_nav_top_bar.dart` tinha **344 linhas** e era cópia da sua barra: `height: 52`, mesmo padding
horizontal, mesmos 40px de placeholder nos dois lados, e os dois acessórios `sealed` já montavam com os
seus átomos. **Apagado.** A doc do seu `.livre` fala do meu caso pelo nome (*"113 usos, 110 deles rename
direto"*) — era isto, e agora são zero.

O que ficou do meu lado, e por que: o **avatar com saudação** da home tem FOTO de perfil e um mini-avatar
de 16px no canto. O seu `.home` tem `firstName` + `onOpenProfile`. Então ele entra pelo `.livre`, que é
exatamente o que você desenhou.

**E eu quase te pedi uma escotilha à direita, com a medição errada na mão.** Eu tinha contado **1 uso** do
meu `RightAccessory.custom` e concluído que era código morto. Errado nas duas pontas: o meu
`BoldLightScaffold` passa `trailing` pra dentro de `actions`, e eu tinha procurado o nome `actions:`. Com
parênteses balanceados são **11 usos** — e os 11 eram **botão de ícone** (9 o mesmo `xmark` de fechar
cadastro, 2 `IconButton` de Material anterior ao DS). **Todos caberam no `.icons`.** Não havia o que pedir,
e a escotilha morreu.

> Segundo erro de medição meu na mesma semana, e é a mesma família do `grep -A4` que te contei ontem: **eu
> contei um caminho de entrada e concluí sobre os dois.**

## 1 · A segunda linha só existe na casca com a status bar MOCK

Esta é a que me trava, e a evidência mais forte não é uma tela minha — é um componente **meu** que já
mora no meu pacote e não pode ser usado no meu app:

```dart
// packages/conta_bold_design_system/lib/src/bold_cabecalho_da_home.dart
child: DilettaTopAppBar.comConteudo(   // ← desenha DilettaStatusBar() — a MOCK 9:41
```

O `BoldCabecalhoDaHome` é a peça do produto pra home. Ele monta sobre `comConteudo` porque a segunda linha
é o que ele precisa. **No app real isso desenha DOIS RELÓGIOS** — a mock 9:41 do DS por cima da status bar
do sistema. O dono do produto já viu esse defeito nesta semana, num outro sítio, e a frase dele foi *"o top
app no app n tem a status bar"*.

Medido nas suas variantes:

| variante | status bar | segunda linha |
|---|---|---|
| `.defaultVariant` | mock (9:41) | não |
| `.comConteudo` / `.stepper` | **mock (9:41)** | **sim** |
| `.cobrand` | mock (9:41) | sim (a co-marca) |
| `.app` | **inset REAL (SafeArea)** | **não** |
| `.plain` | nenhuma, sem SafeArea | não |
| `.bottomsheet` | nenhuma (é superfície interna) | não |

**A abertura da v0.11.0 chegou até a casca do CATÁLOGO e parou ali.** É a mesma forma do argumento que
você aceitou naquele pedido: *a hierarquia dos acessórios abriu na v0.4.0 e a casca acima dela continuou
fechada, então a abertura chegava até a linha da barra e parava*. Um degrau acima, de novo.

**O que eu peço:** `conteudo` na variante de app real. Ou como parâmetro do `.app`, ou como um
`.appComConteudo` — a forma é sua. O que eu preciso é a mesma casca com o **inset real** em vez da mock.

**Por que não resolvo sozinho:** hoje eu resolvo, e é exatamente o que quero parar de fazer. A minha casca
copia a sua gramática (vidro + inset + respiro), e é o que o `///` do seu `comConteudo` chama de *"cinco
linhas copiando a gramática desta casca, que não acompanham quando a gramática muda"*. Eu tenho essas cinco
linhas. Elas são a razão pela qual esta rodada apagou 344 linhas e não 700.

## 2 · Não há variante SEM VIDRO — e o seu `.plain` quer dizer outra coisa

4 usos: comprovante, perfil, personalização, meus limites. Todas rolam sobre um **backdrop com scrim
preto**, e o vidro em cima empilha duas superfícies translúcidas — o texto perde contraste e a borda do
vidro aparece no meio da arte.

E aqui tem uma armadilha de NOME, que é o que me fez medir duas vezes: o seu `.plain` **tem vidro** (é a
versão "sem status bar e sem SafeArea"). O meu `.plain` quer dizer "sem vidro". Mesmo nome, eixo
diferente — se eu tivesse traduzido pelo nome, quatro telas ganhariam vidro em silêncio.

**O que eu peço:** ou uma variante sem a superfície, ou o vidro como declaração do filho no molde do
`cardDeVidro` que você já abriu — *"material se declara"*. A segunda me parece mais coerente com a receita
que já existe, mas o eixo é seu: aqui não é o produto que quer vidro em tudo, é **esta tela** que não quer.

## 3 · Uma pergunta, não um pedido: o título da barra é `textSecondary` de propósito?

Não estou pedindo mudança. Estou dizendo o que embarquei e por quê, pra você medir se foi escolha sua.

A minha barra copiada desenhava o título com `fontSize: 17` cravado e o papel **primário**. A sua desenha
com `heading` (16/w600) e **`textSecondary`**. Eu adotei o seu, pela régua que você mesmo aplicou no 15 →
16 da inicial do avatar: **o degrau é seu.** Mas o papel não é degrau, e o número é grande:

| modo | primário (`fg`) | o que o título recebe (`textSecondary`) | passo |
|---|---|---|---|
| escuro | `#f6f6f6` | `#c6c6c6` | **48 pontos por canal, ~19% mais escuro** |
| claro | `#3d3939` | `#525252` | 21 pontos, mais claro que o fundo pede |

São **110 telas** minhas, e o app é escuro por padrão. Título de tela é a informação primária da tela —
`textSecondary` é o papel de metadado. Se for escolha sua, ela fica e eu não mexo. Se for descuido, **o
conserto é uma linha aí e não 110 aqui**, e o outro filho ganha junto.

Meu gate (`app-newbold/test/o_titulo_da_barra_tem_o_papel_do_pai_test.dart`) fixa o valor de hoje com
controle nos dois modos: se o papel deixar de diferir do primário, ele reprova e eu vou saber que você
mexeu — em vez de descobrir num print.

## O que eu já fiz do meu lado

- os 11 sítios do slot direito viraram descritores do seu `.icons`; o `xmark` de fechar cadastro é uma
  função (`fecharCadastro(context, ref)`) e o favorito passou a dizer o estado pelo GLIFO
  (`star-solid` / `star-light`) em vez de uma cor crua;
- **o seu gate de ícone pegou 3 sítios meus** que só se tornaram fronteira agora que `DilettaNavRightIcon`
  é tipo seu. Um deles era **`'user-plus-light 1'`** — nome de arquivo duplicado (`… 1.svg`) virado
  literal, que não existe em conjunto nenhum. **Terceiro ícone desta adoção que estava desenhando NADA**,
  e nenhum teste de presença ia achar;
- o `BoldTopBar` continua existindo e não é dívida: ele injeta a faixa *"agindo em nome de"* lida do
  contexto em toda variante, e isso é produto — 110 telas recebem sem saber que existe. O que eu quero
  apagar é a **gramática de casca** que mora dentro dele, não ele.
