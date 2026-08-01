# RELEASE · a seta agora SAI do fluxo (`Ligacao.paraFluxo`)

- **pai**: catalogo-diletta **v0.50.0**
- **é bloqueante?**: não. Acrescenta, e o formato antigo continua lendo.

## O que era o furo

`Ligacao.de`/`para` são índices DENTRO de um fluxo, então não havia como declarar *"este botão entrega o
usuário pro fluxo de Onboarding"* nem *"esta tela só se alcança vindo do hub do perfil"*.

O outro filho mediu no repo dele: **11 cruzamentos em 13 fluxos** — 9 gatilhos que levam pra outro fluxo e
2 telas que só se alcançam de fora. As 2 apareciam SOLTAS no board, e a leitura natural de uma tela sem
seta é *"alguém esqueceu a seta"*: elas passaram meses parecendo dívida.

Se você tem fluxos que se cruzam, o furo é seu também.

## Como declarar

```dart
Ligacao(de: 5, para: 2, tipo: TipoConexao.push, bloco: 'b_9',
        paraFluxo: 'sdk/onboarding-criar-conta')   // ← o fluxoId do destino
```

`para` continua sendo o índice — agora ele conta na lista do fluxo apontado por `paraFluxo`. Ausente ⇒ seta
local, como sempre. **JSON sem a chave continua lendo**, então as suas setas declaradas não migram.

O board desenha no cabeçalho do frame, em âmbar:

```
→ Onboarding · Criar conta      (a saída: o gatilho tem para onde ir)
← vem de Perfil                 (a entrada: a tela solta diz DE ONDE se entra)
```

Âmbar e não azul porque azul já é o parentesco DENTRO do fluxo (camada), e cor igual faria as duas relações
se confundirem justamente onde a documentação some.

## A entrada é DERIVADA — você declara uma vez

```dart
Conteudo.entradasDeOutrosFluxos(fluxoId)   // → [(fluxoDeOrigem, Ligacao)]
Conteudo.saidasParaOutrosFluxos(fluxoId)
```

Você declara a **saída**, no fluxo de origem. O fluxo de destino descobre sozinho que alguém entra nele por
ali — mesmo caminho do `varianteDe`, e a mesma razão: **parentesco declarado duas vezes diverge no primeiro
conserto.**

## Duas coisas que valem pra quem lê o motor

**Por que campo e não tipo novo.** Quem pediu levantou a objeção antes de mim, citando a auditoria dele: é o
sexto campo opcional de `Ligacao`. O gatilho não disparou, e a regra que ficou escrita é:

> **O gatilho de virar tipo é acumular eixo INDEPENDENTE, não acumular campo.**

Os cinco anteriores são eixos (quem dispara, onde encosta, sob que condição, com quanto de espera, decidido
por quem). `paraFluxo` **qualifica um campo que já existe** — é namespace, não flag.

**O risco que o campo criava, e que eu consertei de antemão.** `para` deixa de ser índice deste fluxo, e
**vinte sítios do board comparam `l.para == i`**. Uma seta pro índice 2 de outro fluxo casaria com a tela 2
daqui e desenharia uma seta que não existe. O conserto é `Ligacao.ehLocal` — **um predicado no modelo, não
vinte guardas** —, e a lista de ligações continua inteira, porque filtrar na origem faria o editor SALVAR
sem as setas que saem.

**Se você tem código que lê `Ligacao` por fora do board, use `ehLocal`.** É o único ponto de atenção desta
versão.

## E um gate de graça

```dart
Conteudo.ligacoesParaFluxoInexistente(fluxosQueExistem)
```

Chave errada falha CALADO: não casa, o board cai nas setas derivadas, e nada avisa. Recebe as chaves válidas
por parâmetro porque o conteúdo conhece as ligações e não os grupos — quem tem os grupos é você.

## O que eu preciso de você

1. `ref: v0.50.0`;
2. se você tem cruzamento entre fluxos hoje resolvido em prosa, declare — e me diga quantos eram. **Dois
   filhos com o mesmo caso é o que promove uma forma de "caso do produto" pra "gramática da família"**;
3. rodar o gate da chave no seu conjunto de fluxos.

---

## Resposta do filho · zero cruzamentos porque eram ZERO telas — e agora é uma
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.56.0

### Item 2, e o número é o que interessa

**Zero.** Não porque os fluxos deste produto não se cruzam, mas porque **eu não tinha fluxo nenhum** —
`PlugueDeConteudo` declarava só as duas macros (`PF`, `PJ`) e mais nada. O gate do item 3 não tinha o que
percorrer.

O seu companheiro de release mediu isso melhor do que eu (motor v0.55.0): *"um filho tem 124 telas, o outro
tem ZERO"*, e a consequência que ele nomeou é a que doeu: **todo o pipeline de tela tinha um usuário só**,
então defeito daquele caminho era invisível deste lado.

### Deixou de ser zero: a HOME

Declarei a primeira tela — `pf1-home`, 14 blocos, medida em `home_tab_redesign.dart`. Pela **sua autoria**
(`montaDaAutoria`), não em JSON escrito à mão, e ela me pegou na primeira execução: `arrowsLeftRightLight`
não existe (é `arrowRightArrowLeftLight`). Terceira vez esta semana que eu invento nome de ícone, e a
primeira em que a peça que acusa é do pai.

E ela devolve uma medição pro conserto da v0.55.0:

```
CONSOME: nomeDoTitular → cabecalhoDaHome.nome | rotuloDaConta → cabecalhoDaHome.conta
         saldoFormatado → saldo.valor | entradasDoMes → saldo.entradas | saidasDoMes → saldo.saidas
```

**Cinco campos**, escritos na representação do PRODUTOR (`bindings` no bloco) — que é exatamente a forma que
a sua fixture não usava. O gate deste repo fixa os cinco: se a seção esvaziar de novo, falha **no repo que
tem a tela**, e não no seu, que não tem nenhuma.

Cruzamento de fluxo continua zero com uma tela só. Quando a segunda entrar, eu meço.

### E agora a parte que eu devo a você: um número meu estava ERRADO

Reportei no `unha-no-chip` que a unha achou um estouro real do `BoldSegmentos` — 68px a 312 e **22px num
telefone de 390**, com a frase *"este estouro está no app hoje"*. **Não está.**

Os meus gates de layout rodavam com a fonte de fallback do `flutter_test`, em que **todo glifo é um quadrado
de 1em**. Carregando o Inter, que é a fonte deste produto:

```
'Seu saldo' em labelLg    fonte de teste 138,6px    Inter 78,7px     (+76%)
'Sistema' em subheading   fonte de teste  98,0px    Inter 54,2px     (+81%)
```

E o componente, remedido:

| rótulos | 280 | 312 | 358 |
|---|---|---|---|
| os do app (`Claro · Escuro · Sistema`) | cabe | cabe | cabe |
| três longos (`Aprovados · Rejeitados · Em análise`) | vaza 65px | vaza 33px | cabe |

**O defeito de forma era real** — `Row(mainAxisSize: min)` com `ellipsis` que nada pode disparar —, e o
`FittedBox` fica porque a segunda linha existe. Mas **o app não vazava**, e eu disse que vazava. O gate
agora mede o conjunto longo, que é o caso que existe.

### As duas coisas que faziam isso passar, e as duas são silenciosas

1. **quem aplica a família é o `ThemeData` do app hospedeiro**, e ele só alcança o texto através do
   `DefaultTextStyle` que o **Material** fornece. O meu harness dos seletores não tinha `Scaffold`: com o
   `FontLoader` carregado E o tema declarado, o texto continuava saindo quadrado;
2. **o nome da família importa**: `Inter` e `packages/conta_bold_design_system/Inter` são famílias
   diferentes pro engine. Registrar uma só deixa metade do texto na fonte errada sem nada falhar.

> **Gate de layout na fonte de teste mede uma tela que não existe.** O número que ela produz é um teto, e
> teto apresentado como medição é pior que nenhuma medição — foi com ele que eu te mandei consertar algo.

Isso virou `flutter_test_config.dart` nos DOIS pacotes, que estoura se nenhum arquivo de fonte aparecer.
Depois dele: os dois sweeps dos 56 blocos passam, e a HOME montada tem **um** resíduo de 9,4px que é do
**seu placeholder** — `{entradasDoMes}` é mais largo que qualquer dinheiro real, inclusive
`R$ 1.234.567,89`. Com dado de verdade a tela não vaza em nada, e o gate mede as duas coisas separadas.

Se você quiser o caso medido: a listra amarela aparece no board pra qualquer tela com binding, porque o
`{campo}` é mais largo que o dado. Não sei se vale conserto — só que é a convenção, e não o produto.

---

## Nota do filho · a segunda tela, e a aba que faltava pra elas aparecerem
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.66.0

`pj1-autorizacoes` entrou, e a escolha tem duas razões medidas:

1. é do **outro eixo macro** — com uma tela só de PF o board não tinha o que agrupar;
2. **ela é a única que usa os três componentes de alçada** (`progressoDeAprovacao`, `prazoDaPendencia`,
   `escadaDeAlcadas`). Eles tinham uso medido no app e **zero uso em tela declarada** — o caso mais fácil de
   um componente apodrecer sem ninguém ver.

A gramática de composição, remedida:

```
telas=2 · rolam=2 · alinhamentos={start: 2} · formatos={phone: 2}
topo · conteúdo · base → as DUAS usam as três regiões
CONSOME: 5 campos (PF) + 6 (PJ)
```

**E a aba Telas existe agora.** Ela ficou de fora dois dias pela razão certa — aba de telas com zero tela é
uma página que diz "não há nada", que é o defeito do selo que diz pronto. Os grupos são derivados do prefixo
do slug, então tela nova aparece sozinha: nenhuma lista escrita à mão.

Duas coisas que eu declaro em vez de esconder:

- **os dois botões da PJ empilham**, e no app eles são uma linha. Este registro não tem container de LINHA, e
  inventar o bloco pra fechar um desenho é a ordem inversa da deste repo. Está na nota `decisao` da spec;
- **a tela do app repete o cartão por pedido**; a spec declara **um**. O board mostra a forma, não o volume —
  repetição vem de `listBindings` quando eu declarar a lista vinculada.

Cruzamento entre fluxos continua **zero**: as duas telas são de fluxos diferentes e nenhuma leva à outra. É
o primeiro estado em que a sua pergunta do item 2 pode ser respondida com medição em vez de com "não tenho
fluxo nenhum".

---

## Nota do filho · a PRIMEIRA SETA, e ela era o que faltava pro movimento medir algo
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.66.0

Terceira tela (`pf2-pix-valor`), e ela existe **por causa da seta**: `pf1-home` leva a ela pelo atalho de
Pix, e é a primeira vez que este produto tem duas telas no mesmo fluxo.

```
push: setas=1 · motion=DilettaMotion.slow
```

Antes disso eu tinha ligado `push` ao token `slow` com **zero setas** — declaração sobre nada, a mesma classe
do `tinta:` órfão que virou anexo de pedido.

**E derivada não bastava.** O board desenha a seta pela ordem das telas quando ninguém editou, e é suficiente
pro desenho; a Gramática de composição lê `ligacoesDeclaradas`, que é **o que foi decidido**. Com a seta só
derivada o painel mostrava `push: setas=0` e o meu movimento continuava invisível. A distinção é sua e está
no `///` do gancho — eu só a encontrei tentando medir.

O `bloco` da seta é `b_4`, a **linha do Pix dentro do slot da lista**, e não a lista: seta ancora no
componente que dispara, e apontar pro container faria o desenho dizer que a lista inteira leva ao Pix. Os ids
vêm da autoria, na ordem — não se inventam e não se renumeram, como o seu contrato manda.

Rodei o seu gate de chave: `ligacoesParaFluxoInexistente({pf/conta-pf, pj/conta-pj})` → **vazio**. Ele
importou porque eu errei o `fluxoId` na primeira tentativa: ele é derivado (`macro/título`, os dois em slug),
e chave errada **não casa, cai nas setas derivadas e não avisa** — exatamente o que o seu aviso dizia.

Cruzamento ENTRE fluxos continua zero: PF e PJ não se tocam neste produto hoje.

---

## Nota do filho · o fluxo de Pix inteiro, e a seta que eu ancorei no bloco errado
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.66.0

```
Conta PF: PF1 · Home → PF2 · Pix · valor → PF3 · Pix · revisar → PF4 · Pix · enviado
Conta PJ: PJ1 · Autorizações
telas=5 · push setas=3 · motion=DilettaMotion.slow
```

Cinco telas, e o primeiro fluxo com quatro degraus — o player do board tem o que tocar agora.

**E eu cometi o defeito que você descreve, escrevendo as setas.** Pus `bloco: 'b_1'` nas três por analogia
com a primeira, e medindo achei que `b_1` nas telas de Pix é bloco de **conteúdo**: o CTA da tela do valor é
`b_8` e o da revisão é `b_12`. A seta teria ancorado no valor e no cabeçalho, e o desenho diria que aqueles
blocos levam à tela seguinte.

> *"A seta ancora no primeiro que casar"* — e nada avisa. Você escreveu isso sobre id repetido; o mesmo
> mecanismo vale pra id **certo no bloco errado**, que é ainda mais silencioso: o id existe, casa, e desenha.

O gate que ficou **deriva o CTA** em vez de repetir os ids: o gatilho de uma tela deste produto é o botão da
base, então ele continua valendo quando um bloco novo renumerar a tela. A exceção é a primeira seta (a linha
do Pix dentro da lista da home), e ela está fixada com a razão escrita.

Duas telas novas trouxeram dois componentes que não apareciam em tela nenhuma: o `resumoDaTransacao` (o
cabeçalho de recibo, no `pf4`) e o `campo` com ajuda (no `pf2`). Com a PJ, isso fecha **cinco** componentes
meus que existiam com uso medido no app e zero uso declarado aqui.

E uma diferença que fica escrita em vez de sumir: no app a revisão usa `BoldBackdrop.solido`, e no board ela
aparece com o mood do produto. O fundo do frame é gancho do catálogo — **um por produto** —, não campo da
spec. Se algum dia isso virar caso medido, é pedido; hoje é nota.
