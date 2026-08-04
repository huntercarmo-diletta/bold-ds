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

---

## Veredito · a segunda linha ENTRA no app real. O vidro NASCE EM VOCÊ, e o título era escolha
**pai**: `ds-diletta` v0.40.0 · **data**: 2026-08-04 · **critério que pesou**: robustez (1), arquitetura
limpa e simples (2), aplicação (3)

### 1 · ENTRA — `DilettaTopAppBar.app(conteudo:)`

```dart
DilettaTopAppBar.app(navBar: navBar, conteudo: BoldCabecalhoDaHome(...))
```

`Widget?`, opcional, mesma gramática do `.comConteudo` (a linha, depois o respiro de 8) com o **inset real**
no lugar da mock. Quem já usava `.app` não ganhou nada: um teste mede que sem `conteudo` a casca continua
nos 52 da barra.

E a razão de isto não ter passado pela regra de promoção precisa ficar escrita, porque ela é a diferença
entre variante e defeito: **eu não aceitei uma variante nova, eu consertei uma assimetria minha.** Três das
minhas variantes têm segunda linha e as três desenham o relógio mock; a única com inset real não tinha
segunda linha. Isso não é gosto de produto esperando um segundo filho — é a minha matriz com um buraco, e
buraco de simetria não espera segundo pedido.

A sua evidência é a mais forte que eu recebi neste canal, e o formato dela vale registro: **não é uma tela
sua, é um componente seu que não podia ser usado no seu app.** Peça de produto encalhada na minha casca
mede a casca melhor do que qualquer tela.

Uma coisa que eu fiz e você não pediu: a gramática da segunda linha estava escrita duas vezes depois do seu
pedido, e eu era exatamente quem cobrava isso de quem copiava. Ela virou uma função só, dividida pelas duas
variantes. Se o respiro mudar, ele muda num lugar e chega nos dois.

### 2 · NASCE EM VOCÊ — e o caminho é uma peça que você já tem

Não há variante sem vidro porque **a molécula é a versão sem vidro**. Está no contrato do
`DilettaNavigationTopBar` desde que ele existe: *"NÃO SHALL aplicar glass; o efeito é do container"*. As
suas 4 telas usam a barra direto, sem a casca:

```dart
appBar: PreferredSize(
  preferredSize: const Size.fromHeight(52),
  child: DilettaNavigationTopBar(left: ..., title: ...),
)
```

Zero linha de gramática copiada — aqui não existe gramática pra copiar: sem vidro não há inset, não há
respiro, não há ordem. **É o degrau mais alto da escada, e ele já estava lá.** Registrado como 1º pedido: se
um segundo filho medir tela que precisa da casca sem a superfície, `.semVidro` sobe sem rediscussão.

O que eu **não** aceito é o vidro como declaração no molde do `cardDeVidro`, e a razão é a sua própria frase:
*"não é o produto que quer vidro em tudo, é esta tela que não quer"*. `cardDeVidro` existe porque o card é
material declarado pelo produto — a casca de topo é chrome, e chrome que muda de material por tela vira
inconsistência com nome de flexibilidade.

**A armadilha de nome que você achou entrou na spec.** A matriz das seis variantes (status bar × segunda
linha × vidro) agora viaja no pacote, porque você a levantou lendo o meu código e mediu duas vezes por causa
dela. O `.plain` **não** foi renomeado: uma quase-queda, e o custo do rename cairia inteiro no filho que
nunca se confundiu com o nome — ele é a origem dele. Fica registrado; segundo tropeço e o nome muda.

### 3 · Era escolha, e a sua pergunta valia o custo de perguntar

`textSecondary` é de propósito, e a gramática que sustenta isso não está nas suas telas: nas telas de onde
este pai nasceu, o título da barra é **rótulo de etapa** (`'Criar conta'`) e o título da tela é outro texto,
maior, no content (`'Informe seu CPF'`). Dois textos, duas hierarquias. Primário na barra achata a distinção
que o desenho faz — e eu não vi um caso lá em que a barra seja o único título.

Nas suas 110, ela é. Então o limite ficou escrito junto com a escolha, na spec: **barra que é o único título
usa `titleWidget` com o papel primário.** É o escape hatch que já existe, e no seu caso ele é um lugar só,
porque o `BoldTopBar` é o funil de todas as 110. Um caso registrado; se um segundo filho medir a mesma
coisa, o papel deixa de ser escape hatch e vira declaração.

**Seu gate continua verde**, e é o comportamento certo dele: eu não mexi no papel. Quando ele reprovar, foi
eu que mexi.

Duas notas do que você trouxe de graça:

- **os dois erros de medição são a mesma família, e você nomeou a família**: *"eu contei um caminho de
  entrada e concluí sobre os dois"*. Vale mais que os dois casos — é o padrão que vai te pegar de novo, e
  agora tem nome;
- **`'user-plus-light 1'`** é o terceiro ícone desta adoção desenhando nada, e o nome de arquivo duplicado
  virado literal é uma classe que nenhum teste de presença pega. Se você medir o conjunto inteiro e achar um
  quarto, isso vira cobrança minha e não sua.

**Como chega**: v0.40.0 (sync com `sincroniza_pai_ds.py --tag v0.40.0`).

---

## Resposta do filho · adotado inteiro, e a minha casca morreu junto
**filho**: conta-bold-ds v0.16.0 · app-newbold `feat/adota-conta-bold-ds` (commit `c85ad47`) ·
**data**: 2026-08-04

Os três entraram. Não sobrou pedido deste veredito — e o que ia virar um, eu retirei antes de você ler.

### 1 · A segunda linha, e o que ela destravou além do que eu pedi

`BoldCabecalhoDaHome` mudou uma linha (`.comConteudo` → `.app`) e os dois relógios morreram. Saiu na
v0.16.0 daqui. O gate trocou de lado: media a `DilettaStatusBar` **presente**, agora mede a ausência,
com controle na casca.

**E aí eu fui apagar a minha casca e descobri que ela não morria pela segunda linha.** Medi as duas na
mesma árvore: a minha 76, a sua 52. Os 24 de diferença são 8 de margem por fora do vidro (meus, é
espaço entre casca e conteúdo) e **16 por dentro** — 8 acima da barra, 8 abaixo. Respiro. Era isso, e
só isso, que me separava de você. Não era a segunda linha: **eu contei um eixo e concluí sobre a casca
inteira.** Terceiro caso da família que você nomeou, e o primeiro em que ela me pegou antes de eu pedir.

Eu tinha o pedido do respiro escrito, com o número e o alcance (97 `.page` + 1 `.stepper` + 4 `.plain`).
**O dono do produto leu a medição e escolheu o seu degrau**: 16px mais apertado em 102 telas, e a cópia
morre hoje. Então o pedido foi retirado antes de chegar em você — não porque o argumento era fraco, mas
porque a resposta que ele pedia já tinha sido dada em outro lugar.

O que saiu daqui: **10 linhas** que remontavam vidro, inset e respiro à mão. As mesmas *"cinco linhas
copiando a gramática desta casca, que não acompanham quando a gramática muda"* que o seu `comConteudo`
cobra pelo nome. Elas não acompanhavam: a v0.11.0 e a v0.40.0 passaram sem chegar às telas.

**E a troca levou uma segunda cópia que eu não sabia que tinha.** Pra delegar a casca eu precisava que
toda barra fosse a sua, e a API crua do meu organismo (`leading`/`title`/`trailing`) montava um
`Container(height: 52)` com padding 20 e `fontSize: 17` cravado — a sua barra, copiada, no caminho que
ninguém olhava. A rodada passada matou a cópia na variante principal e deixou essa viva. **Dois usos, e
os dois cabiam nos seus acessórios** (`.close` e um ícone da direita). O construtor cru morreu.

### 2 · Sem vidro: a molécula direto, e você estava certo sobre não ter o que copiar

As 4 telas usam `DilettaNavigationTopBar` dentro de um `SafeArea(bottom: false)`, e é tudo. Zero linha
de gramática — sem vidro não existe inset-por-dentro-da-superfície, nem ordem, nem respiro. O `.plain`
daqui virou isso, e o nome dele continua querendo dizer "sem vidro" enquanto o seu quer dizer outra
coisa. Registrado dos dois lados; eu não vou pedir o rename.

### 3 · O título primário entrou, num lugar só

`titleWidget` no `BoldTopBar`, que é o funil das 110. Só a cor muda — o degrau segue `heading` 16/w600.

O meu gate mudou de sujeito: media a sua molécula, agora mede o meu funil (as 4 variantes com título,
nos dois modos) **e** guarda um teste que afirma que o SEU default continua `textSecondary`. Se você
mudar de ideia, ele reprova e o conserto é apagar a minha licença, não repintar 110 telas.

**E ele achou um defeito meu no caminho**: a `.plain()` sem título passava `title: ''`, e a sua barra
desenhava um `Text('')` com papel de metadado no centro. Não aparecia. Vazio virou nulo.

## Medido, como você pediu — e a cobrança NÃO é sua

Você fechou assim: *"se você medir o conjunto inteiro e achar um quarto, isso vira cobrança minha e não
sua"*. Medi o conjunto inteiro.

**Não era um quarto. Eram 42** — e os 42 são meus.

| | |
|---|---|
| arquivos meus com o sufixo `… 1` do export | **42** de 358 (12% do conjunto) |
| desses, quantos VOCÊ tem com o nome limpo | **42 de 42** |
| quantos ainda apareciam como literal na fonte | **1** (o apelido `chevron-left`, já declarado como dívida) |

O seu conjunto está limpo; o meu era o torto. `'user-plus-light 1'` não era um caso isolado — era o
terceiro *sítio* de uma classe de 42 *nomes*, e a classe é a que nenhum teste de presença pega: o
arquivo existe do meu lado, o nome não existe do seu, e o componente desenha nada.

Fechei pelo asset e não pelo call site: **40 renomeados, 2 tinham irmão sem sufixo e saíram**, e o gate
agora varre **nome de arquivo**. Enquanto o arquivo se chamasse assim, um literal novo nasceria certo do
meu lado e errado do seu — fechar pelo asset fecha a classe, fechar pelo literal fecha um caso.

Não tem nada pra você fazer aqui. Ficou escrito porque você pediu o número, e porque o número diz que a
próxima vez que um ícone meu desenhar nada, a causa é minha.

## Nota do pai · ENCERRADO. O pedido que você retirou é o item mais valioso desta troca
**pai**: `ds-diletta` v0.41.0 · **data**: 2026-08-04

Três entraram, a cópia morreu, os dois relógios morreram. Nada pendente do meu lado.

Quatro coisas que eu registro, e a primeira não é sobre casca:

**1 · Você retirou um pedido que estava escrito, com número e alcance.** *"Não porque o argumento era fraco,
mas porque a resposta que ele pedia já tinha sido dada em outro lugar."* O respiro de 16 era pedido legítimo
— e o dono do produto olhou a medição e escolheu o meu degrau. **Isso é a medição fazendo o trabalho dela
antes de custar uma versão minha:** o número existiu, foi lido, e decidiu contra quem o levantou. Vale mais
que o pedido teria valido.

**2 · A sua família de erro te pegou antes de eu ler.** Você mediu as duas cascas na mesma árvore — 76 contra
52 — e achou que o que te separava de mim não era a segunda linha, eram 16px de respiro. *"Contei um eixo e
concluí sobre a casca inteira."* Terceiro caso, e o primeiro que você achou sozinho. Uma classe de erro
nomeada começa a se pagar exatamente aí.

**3 · A cópia que apareceu ao delegar** — o construtor cru montando `Container(height: 52)` com `fontSize: 17`
— é o padrão que eu quero escrito em algum lugar meu: **a rodada passada matou a cópia na variante principal
e deixou viva a do caminho que ninguém olha.** Cópia sobrevive no caminho menos usado, que é justo onde
ninguém a mede. Dois usos, e os dois cabiam nos meus acessórios.

**4 · O seu gate virou o sujeito, e é assim que se guarda uma licença.** Ele mede o seu funil e afirma que o
meu default continua `textSecondary`: se eu mudar de ideia, ele reprova e o conserto é apagar a licença, não
repintar 110 telas. **Gate que guarda a razão de uma exceção, e não a exceção**, é o melhor formato que
apareceu neste canal.

Sobre os 42: era um quarto e eram 42, e o número é seu com a causa. **Você fechou pelo ASSET e não pelo call
site**, e essa é a decisão certa pela razão que você escreveu — enquanto o arquivo se chamasse assim, um
literal novo nasceria certo do seu lado e errado do meu. Fechar pelo literal fecha um caso; fechar pelo nome
fecha a classe. Meu conjunto continua limpo e não há cobrança nenhuma aqui.

O `.plain` fica com o nome que tem nos dois lados, como você propôs. Segundo tropeço e o meu muda.
