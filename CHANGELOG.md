# CHANGELOG · Conta BOLD DS

Quem consome este pacote é o **app do Conta BOLD**, e a entrega é por tag. Sem este arquivo, subir de
versão é aceitar mudança sem saber qual — e a regra é do pai, com o número dele: *"filho que não consegue
ler o que ganha ao subir de versão não sobe"*, escrita depois de um DS da família chegar à tag 44 sem
changelog nenhum.

**Ele começa aqui, e isso é declarado**: `version: 0.1.0` nos dois pacotes desde o primeiro commit, **zero
tags** em 113 commits. Não existe histórico de versão pra recuperar, e inventar entradas retroativas a
partir de assunto de commit seria precisão de mentira. A primeira linha real é a próxima.

Formato: [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) ·
versionamento: [SemVer](https://semver.org/lang/pt-BR/).

O que cada degrau significa **pro app que adota**:

| degrau | o que muda | o que o app faz |
|---|---|---|
| **major** | símbolo removido ou assinatura trocada | lê a nota de migração antes de subir |
| **minor** | componente novo, papel novo, token novo | sobe sem mexer em nada |
| **patch** | conserto que não muda API | sobe sem ler |

## [0.55.1] — 2026-08-19

### Declarado — o degrau de tipo cede o PESO, e só o peso

Uma varredura no app mediu **37 sítios de `FontWeight` cru**, e o que ela achou não foram 37 defeitos:
foram **23 pedidos da mesma coisa** — o mesmo tamanho, com peso maior — porque esta escada não tem 600
abaixo de 24px nem 800 abaixo de 30px.

Dois saíram por redundância (pediam o peso que o degrau já tem) e dois trocaram pelo degrau do PAPEL
certo. **O pixel dizia 11 e o papel disse 2**: nove cairiam no `label`, que é *"12/700 · tracking 1,5 ·
sobrancelha em caixa alta"* — usar sobrancelha de caixa alta em rótulo de frase não é 1px de diferença,
é pegar o degrau de outro papel.

Pros 23 que sobraram, a decisão é a que não mexe em nada e não fecha porta:

| eixo | a tela pode? | por quê |
|---|---|---|
| `fontWeight` | **pode** | peso não muda geometria — a mesma linha em 500 e em 700 ocupa a mesma caixa e quebra no mesmo ponto |
| `fontSize` | não | é o degrau, e sobrescrever declara um degrau invisível pra quem mede a escada |
| `letterSpacing` | não | tracking é do PAPEL |
| `height` | não | é o ritmo vertical, e ele decide onde a linha seguinte cai |

**O que isso NÃO fecha** está escrito no `///`: o eixo de ênfase nomeado, que apareceria no catálogo. A
demanda medida fica registrada — peso 600 ×9, 700 ×9, 800 ×5 — e ela sobe quando o mesmo par (tamanho,
peso) tiver caso repetido o bastante pra ser vocabulário em vez de escolha de tela.

## [0.55.0] — 2026-08-19

### O esquema passa a RECEBER a paleta — e a resposta pra "trocar o token troca o app?" virou 42 de 44

A pergunta é do dono do produto: *"se o Bold tiver um filho, apenas mudando os tokens conseguiremos
mudar toda a aplicação?"*. A resposta medida era **não**, e o defeito não estava onde se esperava.

**Os componentes estavam limpos.** Varredura nos 33 do pacote: **zero hex real** — os dois que a busca
acha são `Color(0x00000000)`, que é ausência de cor, e quatro são hex citados em `///` explicando o que
foi removido. As telas do app têm **um**, e é o fundo da splash, que precisa casar com a splash nativa.

**Quem decidia cor fora do contrato era o tradutor.** O `BoldScheme` cravava `BoldPalette.bold` por
dentro das duas fábricas — então não existia paleta a passar — e escrevia **21 valores como literal**:
8 papéis no escuro e 13 no claro. Um neto herdava as superfícies elevadas, as bordas, o scrim, o fluxo
secundário, o azul de informação, e no claro o rosa do Bold no `primary` e no `danger`.

### As três formas de um papel chegar ao esquema agora

`BoldScheme.de(paleta, brilho:)` é a assinatura nova; `.dark()` e `.light()` viraram atalhos que passam
a paleta deste produto, e **nenhum call site mudou**.

1. **derivado do pai** — o `DilettaScheme` resolve a partir da paleta. É o caminho da maioria;
2. **derivado por REGRA** — o valor é função da paleta, não literal: *"no claro a marca escreve com o
   degrau profundo"* (`primary` → `primary03`, medido 8,03 contra 3,46 do 04), *"a borda suave é a
   tinta de borda a 5%"*, *"o scrim é o fundo a 85%"*, *"o wash é a marca a 20%"*. **A regra viaja; o
   valor não**;
3. **`papeisExtras` da paleta** — os quatro papéis que o pai não tem e não deveria ter:
   `superficieElevada`, `superficiePressionada`, `fluxoSecundario` e `info`. O mecanismo já existia
   (*"capacidade sobe; inventário não"*) e cada um foi com o `significado` obrigatório.

**O `info` merece a linha**: o pai recusou a FAMÍLIA em 02/08 com contra-medição — 9 dos meus 10 sítios
eram ESPERA e viraram `DilettaStatusTone.pending`; o 10º é codificação categórica. Como extra, o azul
que sobrou fica medido e nomeado em vez de escondido dentro de uma fábrica.

### O refactor não moveu um pixel, e isso é medido

Conferi os 44 valores antes e depois, um por um: **todos idênticos**. O que mudou é de onde eles vêm.

### Os DOIS que ainda não viajam, com nome e pedido

`background` e `field` no CLARO. A paleta do pai tem os overrides do ESCURO (`bgEscuro`,
`surfaceEscura`, `surfaceMutedEscura`, da `v0.1.9`) e ganhou o espelho do claro pro TEXTO e pra BORDA
na `v0.111.0` — **falta a superfície do claro, que é a última célula vazia da matriz.** Pedido enviado
em 19/08.

Enquanto ele não vem, os dois são constante nomeada na paleta (`fundoClaroDaPagina`, `campoClaro`),
com o motivo escrito: a derivação do pai dá branco puro, e a página deste produto é tingida de
propósito — é ela que faz o card branco ler como ELEVADO (1,105 de contraste entre os dois). Com a
página branca, a elevação vira traço em vez de superfície.

### Gate novo — `o_neto_troca_a_paleta_e_pronto`

Ele monta um NETO de verdade: a `DilettaPalette.referencia` do pai, mais os quatro extras que um neto
declararia. Não é um verde inventado aqui — é outra marca, mantida por ele.

E a asserção separa três coisas que uma contagem crua confundiria:

| por que saiu igual | papéis | é dívida? |
|---|---|---|
| **regra** que não depende de marca (alpha sobre branco/preto absoluto) | 7 | não — a resposta certa é a mesma |
| **consequência** de um papel preso (o scrim deriva do fundo) | 1 | não, e some quando o fundo sair |
| **dívida** — literal do pacote | **2** | sim, e é o pedido |
| acompanham a paleta do neto | **32** | — |

As três listas são fechadas: dívida nova não entra sem alguém editar o arquivo e decidir que ela entra.

E o segundo gate é a causa raiz virada mecanismo: **o esquema não escreve um `Color(0x…)`**. Enquanto
ele pudesse, qualquer conserto de retema seria desfeito pelo próximo papel que alguém cravasse ali — e
cravar ali é mais fácil que declarar na paleta, que é o que faz a regra precisar de gate e não de
acordo.

## [0.54.1] — 2026-08-19

### Declarado — o gutter do cabeçalho da home é do CHROME, e ele descobriu uma pergunta

Nenhuma linha de código mudou; o que entrou foi uma medição que eu fiz tentando matar um gêmeo, e ela
precisa ficar escrita antes de virar folclore.

Convergindo o `BoldCabecalhoDaHome` com o `BoldTopBar.home` do app, medi os dois lado a lado. O único
desalinhamento no eixo x eram **4px**, e eu ia consertar baixando o gutter desta peça de `s6` (24) pra
`s5` (20), que é o gutter das telas do app. **Fui conferir antes, e a premissa estava errada**: a barra
de topo, a barra de baixo e a status bar do pai usam `s6` as três. 24 não é descuido desta peça, é o
gutter do CHROME da linguagem.

O que sobra é uma pergunta que não é do DS: **as telas deste produto usam 20 de conteúdo contra 24 de
chrome**, então todo cabeçalho fica 4px pra dentro do que vem embaixo dele. Quem move — o conteúdo pra
24, ou o chrome virando declarável — é decisão do dono do produto, e está registrada no `///` da peça.

**É a segunda vez hoje que medir os dois lados mudou a pergunta** (a primeira foi a tinta do
gradiente), e as duas vezes a medição custou minutos e economizou uma mudança errada.

## [0.54.0] — 2026-08-19

### Três decisões do dono do produto, e duas delas REABREM decisões dele mesmo

Nenhuma das três é conserto de defeito: são escolhas, tomadas com o número na frente. As duas
primeiras derrubam razões que estavam escritas e defendidas neste repo — e o que as derrubou foi
medição, não gosto.

**1 · A MARCA DO ESCURO passou a ser a do pai.** Aqui era `primary04` cravado (`#FE3976`, o rosa do
logo) com tinta BRANCA; agora é o `primary05` (`#F66FA0`) que a linguagem clareia de propósito, com a
tinta derivada dele. O que decidiu foi a **divergência**: com `tintasAssumidas` o claro ficou branco
nas duas casas, mas no escuro o teto de 3:1 barra o branco (ele dá 2,73 sobre o 05) — então ou o pai
mudava o escuro dele, ou este produto adotava o 05. O dono adotou.

Preço medido e visível: **o rótulo do CTA no escuro deixa de ser branco** (3,46) e passa a ser a tinta
derivada (**7,70**); o rosa da marca no escuro deixa de ser o do símbolo. Contraste melhor, marca
menos literal. E os papéis que derivam do `DilettaScheme` no escuro foram de **onze pra treze** — o
que sobra sem derivar é UM, o `primaryWash`.

**2 · O GRADIENTE DA MARCA voltou a ser o LOCKUP de três paradas** — rosa → coral → amarelo —, e o que
destravou não foi o gradiente, foi a **tinta**. A razão de 30/07 pra matá-lo estava certa e continua:
branco sobre as três paradas dá 3,46 · 2,56 · **1,21**, e 1,21 é conteúdo invisível. Só que a pergunta
era *"qual gradiente sobrevive ao branco?"* quando ela era *"qual tinta sobrevive ao gradiente da
marca?"*.

| tinta | as três paradas | pior |
|---|---|---|
| branco (a de antes) | 3,46 · 2,56 · 1,21 | **1,21** |
| vinho-tinta (`onGradient` agora) | 5,69 · 7,71 · 16,33 | **5,69** |
| o gradiente de duas paradas com branco | 3,46 · 3,37 | 3,37 |

**O lockup com tinta escura tem pior caso MELHOR que o que estava no lugar dele**, e é o primeiro dos
dois que passa AA de TEXTO — então a regra de uso ficou mais larga, não mais estreita: sobre o
`primary` cabe rótulo em qualquer tamanho, e não só glifo e título grande.

Vinho e não preto puro, com 0,37 de diferença: o preto ganha por uma margem que ninguém vê, e o vinho
já é o escuro DESTA marca. É a mesma escolha que o vidro deste DS já faz.

O segundo argumento de 30/07 **sobreviveu**: o coral e o amarelo não são degraus de rampa, então eles
moram na PALETA (`BoldColors.lockupCoral`, `lockupAmarelo`) e não no arquivo de gradiente — cor de
marca fora da paleta é cor que um rebrand não alcança. O `accent` não mudou: as duas paradas dele são
da mesma rampa de âmbar, a tinta ali é o branco, e o caso dele nunca pediu o matiz do lockup.

**3 · O LADRILHO COMPACTO parou de cravar largura.** Era `85×80` fixo dentro de um FLUXO, com razão
escrita — e essa razão foi o argumento que pôs o `DilettaFrame.flow` na linguagem do pai. O aparelho a
derrubou: **85×3 + 8×2 = 271 numa linha de 350**, então sobravam **79pt vazios à direita** enquanto
três dos seis rótulos do menu Pix quebravam em duas linhas por falta de 4px. Fluxo que sobra espaço e
corta texto ao mesmo tempo não economiza nada.

Agora a peça declara só a ALTURA (80) e aceita a largura de quem posiciona. Numa coluna de 111 o
rótulo recebe **95** onde recebia 69. O `flow` do pai continua certo pros casos dele; o que caiu foi
**este caso como evidência dele**, e isso vira nota pra ele.

### Gates que mudaram de lado, e por quê

Três gates guardavam as decisões antigas. Nenhum foi apagado — cada um passou a guardar a nova, e
todos ficaram com o número de antes escrito ao lado:

- **`o_tema_do_material_mora_aqui`** guardava o `primary04` cravado no escuro; agora guarda a
  derivação, e reprova quem recravar o rosa do logo sem passar pela decisão;
- **`dois_gradientes_e_so`** afirmava *"o branco passa AA-grande em toda parada"*; agora afirma que a
  tinta escolhida passa **AA de texto** no gradiente da marca e que ela ganha do branco — com o 1,21
  escrito, pra ninguém precisar remedir pra saber por que a tinta não é branca;
- **`as_seis_que_atravessaram_a_fronteira`** afirmava *"o compacto trava a largura em 85"*; agora
  afirma que ele declara altura e aceita a largura da coluna, e mede a folga do rótulo (69 → 95).

**E um gate eu tentei escrever e não deu**, o que também é informação: afirmar que *"Agência e conta"
cabe em uma linha* é impossível num widget test — o ambiente renderiza com a fonte de bloco, onde
todo glifo é quadrado e o rótulo ocuparia 165 a 11px. Teste que não vê a fonte não pode dizer se o
texto quebra. O que ficou mede a **largura disponível**, que é o que a decisão de fato mudou.

## [0.53.0] — 2026-08-19

### O pai julgou sete pedidos na v0.115.0, quatro eram meus, e os quatro estão adotados

**1 · A TINTA ASSUMIDA (`DilettaPalette.tintasAssumidas`).** Eu pedi um canal pra o `onPrimary` que eu
declaro sobreviver à derivação; ele deu maior e melhor: exceção **auditável** com `razao` e `medida`
obrigatórias, a medida conferida contra o pior modo, e **teto no piso gráfico** — *"marca decide entre
legível e mais legível; ninguém decide por ilegível"*. Declarado aqui:

```
onPrimary · declarada 3,46 · medidas {claro: 3,46 · escuro: 7,70} · honrada em {claro}
```

No claro a tinta sobre a marca é **branca** nas peças do pai, que é o que o dono do produto pediu ao
ver o chip com rótulo escuro ao lado do CTA branco na mesma tela. **No escuro a divergência ANDOU e
não morreu**: lá o pai clareia a marca pro degrau 05 e o branco daria 2,73, abaixo do teto — está
escrito na resposta do pedido, e é decisão do dono antes de ser pedido novo.

**2 · O VOO DO AVATAR (`DilettaAvatar.heroTag`).** `BoldCabecalhoDaHome.heroTag` repassa a identidade.
A adoção pagou um sítio de desenho de brinde: o ramo da FOTO montava o círculo à mão aqui dentro
(`DecoratedBox` + `DecorationImage`) e virou o avatar do pai — **e isso não era higiene, era o voo**,
porque o `flightShuttleBuilder` que segura o recorte circular mora na peça dele. Um `Hero` sobre o meu
`DecoratedBox` faria a foto virar quadrado no meio do caminho.

**3 · AS ABAS (`DilettaTabs.larguraIgual`).** As `BoldAbas` **deixaram de desenhar**: 122 linhas viraram
89, e o corpo é uma chamada. Custo escrito, porque pixel que muda em silêncio é pior que pixel feio: o
sublinhado ativo era **2** aqui e é **3** no pai. O inativo continua 1, então a redundância que não
depende de matiz aumentou em vez de sumir.

**4 · O PISO DA TINTA DE MARCA (`primaryOnSurface` passou a derivar).** Nada a declarar — e o conserto
dele achou um defeito MEU que nenhuma medição minha tinha achado, porque eu media
`primary × onPrimary` e nunca `primary × surface`:

| modo | antes (degrau 03 fixo) | agora |
|---|---|---|
| claro | 8,03 | 8,03 — o 03 já alcançava |
| escuro | **2,26** | **8,04** |

**2,26 é texto que não se lê**, e ele estava vivo no modo default deste app.

### Gates

- **`o_avatar_da_home_voa`** — sem tag não existe `Hero`; com tag ele mede **48 × 48** e não a casca;
  a foto passa pela peça do pai; e a borda de marca é só do ramo da foto (passar `s.primary` nos dois
  ramos trocaria a borda de todo avatar sem foto — mudança de desenho de carona numa de estrutura);
- **`o_tema_do_material_mora_aqui`** ganhou a asserção da tinta assumida: honrada no claro, derivada no
  escuro, número conferido, zero violações;
- **o gate de AA do catálogo mudou de lado.** Ele afirmava *"nenhum par declarado reprova em AA"* e
  passou a afirmar **"todo par abaixo de AA é exceção DECLARADA"**, com a lista vinda da paleta e a
  auditoria conferindo o número. Par que reprova sem declaração continua defeito; com declaração é
  dívida com dono;
- **o gate das abas mudou de número e não de mérito** — era borda de `AnimatedContainer`, virou altura
  de `Container`, e o que ele sempre protegeu foi a seleção se ler sem cor: agora 1 contra 3.

### O que o app faz ao subir

Nada obrigatório. Pra usar o voo, passar `heroTag` no cabeçalho da home e a mesma tag no Perfil
EMPILHADO — **nunca na aba Perfil**, que convive com a home no `IndexedStack`: duas `Hero` iguais na
mesma rota derrubam o Flutter.

## [0.52.0] — 2026-08-19

### Corrigido — o saldo oculto sumia, e eram DOIS defeitos empilhados no mesmo `SizedBox`

Chegou do dono olhando o app: *"ao esconder o saldo ele desaparece, no lugar de ter algum tipo de
máscara"*. A peça tem máscara (`R$ ••••••`) e ela funciona isolada — o que não funcionava era a
largura reservada pra ela.

**1 · O medidor media numa fonte e a tela pintava em outra.** A largura sai de um `TextPainter`
alimentado com o degrau de tipo cru, e **degrau desta linguagem não fixa família nem escala**: ele
herda do tema, que é como a fonte da marca chega em todo lugar sem ninguém repetir o nome dela. O
`TextPainter` não herda nada — mede exatamente o `TextSpan` que recebe. Agora ele recebe
`DefaultTextStyle.of(context).style.merge(estilo)` e o `textScaler` do `MediaQuery`. O scaler é o
mesmo defeito por outra causa: com a escala do sistema aumentada o texto cresce e a caixa não.

**2 · O "máximo dos dois estados" só olhava um estado por vez.** A peça recebia o texto já resolvido
(`mostrado`) e reservava o máximo entre ele e o valor. No estado VISÍVEL os dois são a mesma string,
então o máximo era a largura do valor: **98 com o saldo à mostra, 128 com ele oculto** — medido. A
intenção estava escrita no `///` do arquivo (*"o card NÃO MEXE ao virar o olho"*) e a implementação
não a cumpria. Agora a peça recebe os dois textos e mede sempre os dois.

O segundo não foi achado lendo: **foi o gate novo que o encontrou**, na asserção que existia pra
provar a outra coisa.

### Gate novo — `a_mascara_do_saldo_cabe`

Mede a caixa reservada contra a largura INTRÍNSECA do texto, com escala do sistema em 1× e 2×. A
escala é o lever honesto num teste de fonte: ela reproduz o mesmo defeito por outra causa — o
medidor ignorando algo que a tela aplica.

### Mudado — uma asserção de `o_saldo_test` virou proxy de nada, e foi trocada

O teste do saldo curto comparava a largura RENDERIZADA dos dois textos e exigia que a máscara fosse
maior. Ele media o defeito por tabela: com a caixa mudando de tamanho por estado, máscara maior
provava que a caixa crescera. Com o defeito 2 consertado a caixa é a mesma nos dois estados, e a
comparação virou **252 contra 252** — passaria a concordar consigo mesma pra sempre. A asserção
agora pergunta direto: a máscara cabe na caixa?

## [0.51.0] — 2026-08-19

### O tema do Material e o vidro passam a morar aqui — e o app parava de decidir DS

Duas peças que estavam do lado errado da fronteira. O critério é o mesmo dos dois lados: **decisão
de linguagem não mora em aplicação**, e as duas eram decisão de linguagem com endereço de app.

**O `ThemeData` (`BoldTemaMaterial.claro` · `.escuro`).** Enquanto ele morava no app, o app decidia
nove superfícies do Material — a escada de tipo, o fundo do scaffold, o divisor, o ícone, o card, a
folha, o campo, o botão de texto e a transição de página. O sintoma que provou isso não foi
arquitetural, foi visível: até ontem quem servia o `MaterialApp` era a camada legada do app, que
pedia **Nunito**, enquanto os 644 sítios que leem um degrau saíam em **Inter**. Duas fontes na mesma
tela, e nenhum teste olhava, porque cada metade estava certa sozinha.

Vieram **nove** das treze peças que o tema legado configurava. As quatro que ficaram — `appBar`,
`bottomNav`, `chip`, `dialog`, `snackBar`, `elevated`, `outlined` — têm **zero consumidores** no app:
ele instancia um `TextButton` e um `Dialog` do Material, e mais nada. Declaração sem consumidor
envelhece igual token sem call site.

**O `BoldScheme`, e ele é a razão de o tema não ter vindo antes.** É a extensão que faz
`BoldColors.of(context)` responder, e é o tema que a registra: com o esquema no app, o tema tinha
que ficar lá junto. Ele nunca foi decisão de aplicação — **11 dos 14 papéis do escuro e 9 dos 14 do
claro derivam do `DilettaScheme`** do pai, e o que sobra são decisões de marca. A classe manteve o
nome; os ~400 sítios do app não souberam da mudança.

**O vidro (`BoldVidro`), e aqui não era mudança de casa: era duplicata.** A receita mora na paleta
desde a `v0.4.0` do pai — *"o pai sabe COMO se constrói vidro; o filho diz de que material ele é"* —
e mesmo assim o app declarava os **mesmos cinco valores** por outro caminho: `#16060A @ 50%`,
`#FFFFFF @ 50%`, `#FF9898 @ 30%`, `primary08` e blur 15. Conferido valor por valor antes de apagar a
segunda fonte, e o gate novo é o que impede as duas de voltarem a existir.

**O vidro de ENTRADA (`BoldVidroDeEntrada`) veio junto, e ele é outro material.** Blur 5 contra 15,
gradiente que some subindo em vez de fill chapado, base própria. Existe porque o card do login fica
sobre uma FOTO de tela cheia, não sobre o backdrop — fill chapado ali achata a imagem. Uso restrito,
e escrito: se aparecer um terceiro caso, a pergunta é se o PRIMEIRO vidro devia ganhar variante.

### Adicionado

- `BoldTemaMaterial.claro` / `.escuro` — o `ThemeData` do produto, nos dois modos;
- `BoldScheme` — os catorze papéis mode-aware, com as duas fábricas;
- `BoldRadius` — vieram junto porque o tema precisa de três deles; dois derivam do pai, e o `sheet`
  de 22 é o único fora da escada dele (pergunta ABERTA no ledger do pai desde 18/08);
- `BoldVidro` e `BoldVidroDeEntrada`;
- `BoldVinho.lavagem` (`#420616`) — o **terceiro** degrau do vinho, e ele entrou com o caso na mão,
  que é a régua que este arquivo declarou quando nasceu com dois. Não é `vinho03`: não é degrau de
  rampa, é a lavagem de um material.

### Gates novos

- **`o_tema_do_material_mora_aqui`** — o tema pede a família da marca em toda a escada, e registra o
  esquema do modo certo. É a metade que faltava do gate da fonte: sem a extensão,
  `BoldColors.of(context)` cai no escuro por fallback dentro de um app claro, sem erro nenhum;
- **`o_vidro_tem_uma_fonte_so`** — os cinco valores PINADOS na medição de 19/08, não copiados da
  paleta. Cópia faria o teste concordar consigo mesmo; a medição é o que diz se a mudança de casa
  mexeu num pixel.

### O que o app faz ao subir

Nada além de afinar as cascas: `BoldTheme.light()`/`dark()` passam a delegar, `bold_glass.dart` e o
`BoldScheme` local viram uma linha cada. Nenhum call site muda de nome.

## [0.50.0] — 2026-08-18

### O CLARO ganha o espelho da porta, e dois defeitos de contraste morrem

O pai fechou o pedido de ontem à noite na `v0.111.0`: `textoClaro` · `textoSecundarioClaro` ·
`textoMudoClaro` · `bordaClara`, mesmo molde do escuro. Este filho declara os quatro.

**Os dois defeitos, e um era meu:**

| | antes | agora |
|---|---|---|
| `textMuted` do claro (meu) | **2,96** | **3,54** |
| `textPlaceholder` do claro (derivação dele) | **2,61** | passa o piso |

O meu estava abaixo do piso de texto GRANDE enquanto eu defendia 3,81 pro mesmo papel no escuro —
**a régua que eu apontei pro pai acusou o que eu tinha em casa.** O dele derivava por degrau fixo e
não segurava numa rampa mais clara; ele pôs o piso dentro da própria derivação, nos dois modos.

O mudo novo (`#8A8398`) mantém a temperatura (spread 21) que a rampa neutra não tem como dar — que
foi o argumento do pedido do escuro, agora do outro lado do interruptor.

### A exceção do gate morreu no dia seguinte

O `o_piso_de_contraste_vale_nos_dois_modos` nasceu ontem com **uma** exceção declarada — o
placeholder do claro, com o número e o pedido citado. Ela some hoje, e some inteira em vez de virar
lista vazia: lista de exceção vazia é convite pra próxima entrar sem discussão.

### A proporção de papéis mudou, e é notícia

O gate do catálogo cravava **16 alias para 5 derivados**; agora é **12 para 9**. Quatro papéis do
claro deixaram de ser alias de degrau e passaram a sair de campo declarado. Eu movo menos papel
trocando a paleta — e é isso que eu queria: o que saiu do alias não foi pra rampa, foi pra uma porta
que eu declaro.

## [0.49.0] — 2026-08-17

### `BoldType` — a escala de tipo da marca atravessa a fronteira, e um degrau nasce da medição

Terceira camada a sair do app, depois da paleta e das peças. Ela veio por último de propósito: é o
token com mais consumidor (**644 sítios**) e o que menos perdoa erro.

**Sete degraus derivam do pai** — `headlineMd` · `headlineSm` · `titleMd` · `bodyLg` · `labelMd` ·
`bodySm` · `labelSm` —, conferidos um a um em px, altura, peso **e tracking** antes de trocar. A
família é a única coisa que este pacote acrescenta, porque os degraus dele não fixam família de
propósito.

**Doze são declarados, e cada um tem razão escrita**: seis têm px que o pai não tem (46, 30, 17, 13,
13, 10), cinco têm o px dele com outro peso, e o `labelLg` bate em tudo menos tracking — 1,4 contra
0,1 do `titleSm`. Catorze com 1,4 é rótulo espaçado, não título pequeno.

**`valorHeroi` (32) nasceu da medição do app**: 17 sítios escreviam `display.copyWith(fontSize: …)`,
onze com **32** e seis com **34**. A divisão não era decisão — 34 nas telas de revisar, 32 nas de
resultado, dois pixels que ninguém escolheu. Um degrau, e ele é o grupo maior; as seis de revisar
encolhem 2px.

**O gate mede a ESCADA, não os valores**: nenhum par de degraus a menos de 1px de distância, e
degraus que compartilham px têm que se separar por peso ou tracking. É o que impede a terceira
grafia de nascer no dia seguinte.

## [0.48.0] — 2026-08-17

### Pai `v0.110.0` — os dois pedidos do dia voltaram, e os dois com defeito MEU junto

**A linha rótulo→valor.** O `DilettaDetailRow` ganhou `enfase` · `porte` · `trailing`, e nenhuma peça
nova nasceu — porque a peça já existia e eu li errado. Eu escrevi que ele *"empilha onde este caso
alinha"*; ele é `Row`, com `Expanded` + `textAlign: end` no valor, e a spec dele abre dizendo
*"horizontal: label à esquerda, valor à direita"*. **O pedido estava certo no número e errado na
saída.**

O que o veredito acrescenta e eu não tinha visto: o pai tinha **duas** receitas da mesma forma no
próprio pacote — a pública (`subheading`/`fg` → `bodyMd`/`textTertiary`) e a privada do
`DilettaReceipt` (`caption`/`textTertiary` → `caption`/`fg`), com a ênfase invertida entre elas.
A minha régua apontada pra ele deu o mesmo veredito que ele me deu: 5 receitas em 16 sítios aqui,
2 em 2 lá, e uma sem porta. O `DilettaReceipt` passou a montar a peça pública.

**A row de três linhas.** Defeito dele, consertado em uma linha —
`_sizeHint() => label == null ? sm : md`. E as duas saídas que eu ofereci estavam as duas erradas:
`md` fixo mexeria na altura de quem já funcionava (com `label` nulo a conta dá 36 exatos), e altura
elástica entregaria piso variável onde o número de linhas é conhecido na construção. **A minha
própria exclusão nº1 dizia o certo, e ela contradizia a minha saída nº2** — ele implementou a
exclusão.

O achado que eu não podia ver: a variante estourava **na vitrine do primeiro filho**, na tabela que
documenta o acessório. Estouro de layout na web em release não pinta a tarja.

### O que isso destrava aqui

Os 16 sítios de linha rótulo→valor do app e o `_IdentityCard`, que voltou a ter caminho.

## [0.47.0] — 2026-08-17

### O texto do escuro passa a ser DECLARADO — quatro campos, sete papéis, dois derivados

O pai fechou o pedido no mesmo dia: `v0.109.0`, quatro campos opcionais na paleta
(`textoEscuro` · `textoSecundarioEscuro` · `textoMudoEscuro` · `bordaEscura`), no molde que a
`v0.1.9` abriu pras superfícies. Este filho declara os quatro:

| campo | valor | contraste sobre `#0A0B12` | spread RGB |
|---|---|---|---|
| `textoEscuro` | `#FFFFFF` | 19,64 | 0 |
| `textoSecundarioEscuro` | `#B7BBC8` | 10,24 | 17 |
| `textoMudoEscuro` | `#686D7E` | **3,81** | 22 |
| `bordaEscura` | branco @ 8% | — | — |

O `mudo` em 3,81 é a razão do pedido inteiro: ele é METADADO e não pode competir com o corpo. A
derivação da rampa neutra o punha em 7,51.

**Dois papéis chegam derivados, e eles carregam a temperatura.** O terciário sai `#8D91A0` (6,27,
spread 19) e o desabilitado `#3F424F` (1,96, spread 16) — ambos entre os vizinhos declarados, pela
fração de luminância que o degrau ocupa na rampa. Isso responde a parte que eu não tinha medido: a
correção do pai foi dizer que *matiz não sai de degrau, mas degrau sai de degrau.*

**E o diagnóstico do meu pedido estava invertido**, o que ele mostrou com a régua dele: a rampa
neutra de referência tem spread 18/21/23 — ela **não** é cinza puro. Cinza puro é a paleta DESTE
produto (spread 0 nos três degraus neutros). A porta continua necessária, mas por outra razão: a
derivação default fica intacta, e o outro filho não é repintado por um defeito que não é dele.

### O que isso destrava no app

Quatro dos hex crus do `bold_colors.dart` podem morrer: `textPrimary`, `textSecondary`, `textMuted`
e `border` passam a vir do `DilettaScheme`. Os outros sete da rampa (o corpo, o corpo suave, o
rótulo, a borda forte e as duas superfícies elevadas) continuam sem papel na linguagem — medidos e
escritos, não esquecidos.

### Gate

`o_texto_do_escuro_test`: os quatro campos chegando nos sete papéis, e os dois derivados provados
por TEMPERATURA (spread > 10) e por posição (luminância entre os vizinhos). Campo opcional que
ninguém liga cai na rampa em silêncio — o gate existe pra que o silêncio faça barulho.

## [0.46.0] — 2026-08-17

### Pai `v0.88.0` → `v0.108.0` e motor `v0.105.0` → `v0.108.0` — 20 versões do pai, zero quebras

Vinte tags do pai entraram de uma vez e o pacote nem piscou: `flutter analyze` limpo e **142/142** no
pacote, **90/90** no catálogo. Não é sorte — é o que a partição fechada em 29/07 comprou: o filho
declara paleta e compõe, o pai constrói, e mudança de construção não atravessa a fronteira.

O motor sobe junto porque a `v0.107.0` dele traz o `FormatoDoAparelho`, que era a única coisa
segurando as telas de loja no formato de iPad — elas rodavam com `dependency_overrides` apontando pro
disco. **O override morreu**, e as duas levas saem por `--dart-define`:

```sh
flutter test test/desenha_as_telas_de_loja.dart                              # 393×852  ⇒ 786×1704
flutter test test/desenha_as_telas_de_loja.dart \
  --dart-define=largura=1032 --dart-define=altura=1376                       # ⇒ 2064×2752 (iPad 13")
```

A tela é **desenhada** no formato, não ampliada até ele: a primeira resposta ao pedido da loja foi
compor a imagem por fora — PNG de telefone centrado numa arte de fundo —, e ela cabe na loja sem
responder à pergunta do dono, que é o que o produto faz na largura do iPad. Quem tinha que mudar era
o frame, e mudou. Uma pasta por aparelho, pra as duas levas não se comerem.

### Pedido novo ao pai — a rampa de TEXTO do escuro não viaja

Medido fechando a dívida de cor do app: a derivação do `DilettaScheme` no escuro dá cinza PURO
(distância entre canais RGB = 0 nos quatro papéis), e o texto deste produto é azulado (6 no corpo, 17
no secundário, 22 no mudo), porque o fundo daqui é um azul-quase-preto. O `mudo` é o caso que decide:
ele fica a **3,81** de propósito, e a derivação do pai o põe a **7,51** — mais forte que o
`textSecondary` de muitos produtos. Mudo que grita deixa de ser mudo.

O pedido é por SLOT, não por cor: quatro campos opcionais na paleta, no mesmo molde das superfícies
do escuro da `v0.1.9`. `docs/pedidos/2026-08-17-a-rampa-de-texto-do-escuro-nao-viaja-a-minha-e-azul.md`.

E um achado que foi junto: o `border` do escuro do pai é `const Color(0x14FFFFFF)` cravado no scheme,
e é **hex por hex** o `border` deste produto, nos 127 sítios em que ele pinta. Dois caminhos
separados chegando no mesmo valor é o sinal de token que já é da linguagem e ainda não tem nome nela.

## [0.45.0] — 2026-08-13

### `BoldNavFlutuante` — a navbar da home era a do PAI, e o print viu antes de qualquer gate

*"A navbar da home tá diferente, parece que você redesenhou do zero"*, e depois o diagnóstico exato:
*"você tá usando a navbar da CPF Seguro, não do Bold — no Bold a navbar não deixa a home indicator
dentro dela."* Estava certo nas duas frases.

O `barraDeBaixo` com `variante: nav` emite `DilettaBottomApp.nav`: **barra ancorada full-width**, itens
em `Expanded`, círculo do ativo estourando a borda de cima, traço de home POR DENTRO. A home deste
produto usa **pílula flutuante** com hug e margem de 16, e o indicador é do aparelho.

E a diferença estava escrita, palavra por palavra, no `///` do `BoldBottomApp` dentro do app desde
antes: *"não é cópia da dele com defeito — é outro desenho, e trocar é decisão de produto."* O desenho
estava declarado, o produto tinha escolhido, e o board mostrava o outro por duas versões. **Nenhum gate
mede qual dos dois desenhos válidos a tela usa** — é a classe de divergência mais cara deste repo,
porque ela passa por decisão de design.

Ela entra como bloco PRÓPRIO (`navFlutuante`) e não como sexta variante: a união é das factories do
pai, e esta peça não é dele. A `nav` ancorada segue no vocabulário. Três testes novos no pacote, e o
primeiro mede exatamente o que o dono viu: `findsNothing` pro `DilettaBottomHomeIndicator`.

Na travessia: vidro montado à mão → `DilettaGlassSurface` · raio 26 → `all24` · rótulo de 10px cravado
→ `labelSm` · vão 3 → `s1` · sombra → `DilettaElevation.medium`, e ela fica FORA do clip do vidro
(atrás do blur ela é reamostrada e vira halo). Quarta peça a pagar o mesmo atalho de tipografia na
travessia — o ladrilho e a amostra de fundo vieram antes.

### A arte do cartão de passkey existia como TOKEN, e o bloco não passava

*"A ilustração precisa estar no banner da passkey."* O `///` do componente dizia que o placeholder de
100×100 ficava porque *"a arte do carrossel é do app, asset de produto, não do DS"* — e isso estava
errado por um detalhe medido: o app carrega `illustrations/key_word_{tema}.svg`, e o pai tem
`DilettaIllustration.keyWord` com base `key_word`. **É a mesma arte, e ela é token da linguagem.**

### E o conserto dela achou um defeito de emissão que nada acusava

Com `ctor`+`args` declarados o motor prefere a TABELA e o `codegen` fica vestigial. A ilustração é
widget ANINHADO (`DilettaIllustrationAccessory`), e a tabela só lê valor literal — então o board
desenhava a arte e o código emitido saía **sem ela, em silêncio**:

```
ds.BoldCartaoPromocional(titulo: '…', subtitulo: '…', aoFechar: aoFechar, aoTocar: aoTocar)
```

Terceiro bloco a sair da tabela pelo mesmo motivo (`linhaDeValor` e `divisor` vieram antes), com entrada
no leitor pra fechar a volta.

### A STATUS BAR nas imagens, e ela é chrome de APARELHO

A home usa `cabecalhoDaHome` (`DilettaTopAppBar.app`), que reserva o **inset real** da `SafeArea` em vez
de desenhar o 9:41 mock — decisão certa do DS, *"não é uma tela minha, é um componente meu que não podia
ser usado no meu app"*. Num render headless o inset é zero, então a home saía colada no topo, sem faixa.

Num aparelho quem pinta ali é o sistema. **Estas imagens são mock de aparelho**, então quem faz o papel
do sistema é a ferramenta: `FakeViewPadding(top: 40)` mais a `DilettaStatusBar` por cima, e só nas telas
cujo topo não traz relógio próprio. Fica no renderizador e NÃO na spec — declarar `barraDeStatus` no
`top` da home seria o catálogo dizendo que a tela desenha o relógio, e o gate proíbe essa coexistência
com razão.

### Os dados viraram FICTÍCIOS, e a aritmética fecha

*"Mocka melhor os dados! Não usa meu nome."* A home e o extrato traziam o nome e o extrato reais de uma
conta — servia pra medir contra o aparelho, não serve pra imagem de loja.

Entradas 6.150,00 − saídas 1.862,10 = saldo 4.287,90, e os saldos por dia do extrato descem na mesma
conta (250,00 → 6.150,00 → 4.287,90). Mock que não fecha a conta é pior que mock: alguém soma na tela.

Os nomes são curtos de propósito — a linha de valor **não elipsa** o título, ela trunca em silêncio, e
"MERCADO SÃO JOÃO LTDA" encostava em "− R$ 1.228,10".

Gate: **90/90** no catálogo · **142/142** no pacote (era 139).

## [0.44.0] — 2026-08-13

### A décima tela, e ela é a que EDITA este DS — `pf8-aparencia`

O pedido era quatro telas em PNG pra virar screenshot de loja: home, Área Pix, extrato e **editar
aparência**. Três já existiam e estavam certas contra o aparelho; a quarta não existia, e o motivo é o
que interessa: **o `BoldBackdrop` tinha sete valores e nenhuma peça que os mostrasse.** O retrato de
cada mood era `_BgOption` + `_Swatch`, classe PRIVADA dentro de `aparencia_screen.dart` — a quarta
classe de dívida deste repo, a mesma que trouxe o `cartaoDaConta` e o `cartaoDePedido`.

### `BoldAmostraDeFundo` — o componente que o próprio DS já citava pelo nome

O `///` do `BoldBackground.fixo` abre com *"o SELETOR — a tela de Aparência desenha as cinco opções com
`estilo:` em cada uma"*, e é o primeiro dos dois casos em que o declarado tem que vencer a escolha da
pessoa. Ou seja: o construtor existia PRA esta peça, e a peça não existia. Dois números do aparelho
viraram degrau na mudança de casa — raio 11 → `r8` (11 não é degrau, e o anel fica em `all16` pra ler
como anel) e rótulo de 10px cravado → `DilettaType.labelSm`, o mesmo `copyWith` que o ladrilho de menu
já pagou.

**Um sítio no app, e a medição por sítio é a pergunta errada aqui**: seletor de token é único por
construção — dois seria o defeito. O que justifica a peça é o SUJEITO, que é um token deste DS.

### `linhaDeEscolha` — fica no catálogo, porque nada novo foi desenhado

Composição dos três acessórios do pai (`spotIcon` + `title` + `iconAccessory`), e a única diferença
contra o `linha` é a direita: **check no lugar da seta.** Seta numa lista de escolha promete outra tela
e o toque decide ali — é a mesma classe do botão cinza desabilitado, que oferece o que não existe. Ela
entra na spec `app-list` do pai pela mesma exceção da `linha` e da `linhaDeValor`.

### E o PNG achou um defeito que os 90 gates não viam: a leva escura saía com TEXTO PRETO

`desenha_as_telas_de_loja.dart` montava a árvore com `ThemeData(fontFamily: …)` — **claro nas duas
voltas do laço.** O `DilettaThemeScope` de dentro pintava fundo, card e acessório certos; o texto solto
pegava a tinta do `DefaultTextStyle`, que vem do Material.

Não é defeito de bloco: o `texto` emite `ds.DilettaText(x, style: ds.DilettaType.bodySm)`, e o token de
tipo **não carrega cor de propósito** — cor é papel, e papel vem do scheme. No app o `MaterialApp`
recebe o tema do produto por modo; aqui a árvore é montada à mão, e é aí que o ambiente se perde.

O estrago era antigo e estava nas imagens que iam pra loja: no `pf7-extrato-escuro`, **"Transações"
invisível**; no `pf8-aparencia-escuro`, as duas linhas de apoio. Uma linha (`brightness:` no
`ThemeData`) conserta as seis telas de uma vez.

### A folha da árvore virou categoria DECLARADA no gate de saída

`toda tela tem gatilho de saída` reprovou a Aparência, e reprovou com razão pela régua antiga. Só que
nela **todo toque aplica e persiste** — tema e fundo — e a única saída é a volta da casca. Declarar a
linha de escolha como gatilho seria desenhar seta pra tela que não existe.

A lista de folhas é nominal (`{kSlugDaAparencia}`) e a asserção **inverte** pra quem está nela: folha
que ganha gatilho reprova também. E a volta da casca segue FORA de `gatilhosDeSaida` — ela existe em
quase toda tela, e aceitá-la faria o gate passar em tudo, inclusive na tela de fluxo que esqueceu o CTA.

Gate: **90/90** no catálogo (era 83) · **139/139** no pacote. Contratos: 21, e a lacuna de cobertura
segue em 1. Superfície de variação de enum: 68 → **74**.

## [0.43.0] — 2026-08-13

### Recebeu — `ds-diletta` v0.88.0 · `DilettaStoreBadge`

Fecha a última dívida do cruzamento dos dois DS. **Zero sítios aqui**, e a medição que o aviso pediu:
0 no app, 0 no pacote, 0 arte de loja nos assets. As três menções a *App Store* e *Google Play* nos
dois repos são prosa em comentário.

O motivo é de produto e não é dívida: **o Conta BOLD não tem superfície de aquisição.** O app é pra
quem já tem conta, e selo de loja mora onde se pede pra instalar. Se aparecer, vai ser no CATÁLOGO
antes do app.

139 testes do pacote e 90 do catálogo verdes — o componente degrada pra nada sem arte declarada, como
o aviso afirma.

### Uma dívida minha que este aviso nomeou

> *"Onde a arte mora: junto do resto da arte de marca do seu repo, **com um README de procedência ao
> lado** — de onde o arquivo veio e sob quais termos."*

Eu tenho arte de marca de terceiro no produto — o `BoldPixMark` é o símbolo oficial do Pix, do BACEN —
e **não tenho procedência escrita em nenhuma**. Ele está no inventário como `deliberado` com a razão
certa, mas de onde o arquivo veio não está em lugar nenhum. A disciplina que o pai pede pra arte que
eu não tenho é a que falta na que eu tenho.

## [0.42.0] — 2026-08-13

### Recebeu — `ds-diletta` v0.87.0: o CRUZAMENTO dos dois DS virou vocabulário

`DilettaTabs` e `DilettaUpload` nasceram da interseção de 216 nomes de componente entre os dois
produtos que a linguagem serve. A régua: **o que está só num produto é inventário dele; o que está
nos dois é o vocabulário da categoria.**

### Conferido — o círculo de erro do `DilettaSpotIcon`

Um sítio: a linha *Encerrar conta digital*. Desenhei e olhei — o contorno vermelho chegou e melhora o
que estava lá. **É a única linha destrutiva do produto**, e ela agora se lê como destrutiva antes do
texto, que é o trabalho do spot. Nada a corrigir.

### Não adotado — `DilettaTabs`, por 113 pixels, e está pedido

Fui adotar como o aviso sugere e não coube: `Pendentes · Histórico · Minhas` em 353 de largura
**estoura por 113px**. A do pai é `MainAxisSize.min` com cada aba do tamanho do rótulo; a minha
reparte em fatias iguais, e a razão está escrita nela desde que nasceu — **fatia desigual faz o alvo
de toque mudar de tamanho a cada troca de tela**, e numa barra de navegação isso é o botão andar de
lugar.

Pedido aberto como variante (`larguraIgual`), no formato novo, com o «Já tentei» medido nos três
conjuntos de rótulo. `BoldAbas` fica sendo a única peça deste produto com par na linguagem que não
adota — declarado no `///` dela, não silencioso.

### A lição do cruzamento, e ela é maior que as duas peças

O `///` da `BoldAbas` dizia, desde o primeiro dia: *"candidata clara a subir quando um segundo filho
medir a mesma falta"*.

**Eu escrevi a condição e não tinha como verificá-la** — eu vejo um produto. Ele cruzou os dois e ela
disparou sozinha. As próximas peças que nascerem aqui vão escrever a promessa como uma **consulta que
alguém consegue rodar**, e não como intenção.

## [0.41.0] — 2026-08-12

### Recebeu — o eixo de AJUSTE DE PAPEL, e ele nasce desligado

`ds-diletta` v0.78.0 + `catalogo-diletta` v0.105.0. Um componente pode pedir outro degrau da MESMA
família, por `marca` ou por `contraste`. **139 testes do pacote e 90 do catálogo verdes sem declarar
nada** — conferido, não acreditado.

### Eu não tenho caso, e a medição é que diz isso

Ia responder *"não tenho parceiro, logo não tenho caso"* e parar. Medi antes, e a medição corrigiu a
resposta: o único par que o eixo melhoraria é `primaryTrack`/`surface` (1,64 claro · 1,34 escuro) —
que é o exemplo do próprio aviso — e **ele é baixo de propósito**, por um pedido meu que o pai
aceitou em 10/08: *"trilho é o que sobra atrás do preenchimento, não elemento que se anuncia"*.

Ajustar ali seria desfazer com um eixo novo o que a linguagem decidiu com medição.

### Corrigido em mim — o terceiro erro da mesma classe em três dias

A minha varredura de margem aplicou piso 4,5 a papéis que não são texto e acusou seis "REPROVA" que
não são violação — a conformidade do pai devolve vazia, e ela é que está certa.

Pior: a **primeira** versão do cálculo deu `fg/bg` = **1,70** no claro, porque eu escrevi uma
aproximação de `pow` à mão em vez de usar `dart:math`.

> **Cálculo que eu escrevo pra medir o rigor do outro precisa do mesmo rigor.** A frase que eu usei
> contra o `razao` sem alpha — *"errado com a mesma confiança"* — voltou contra mim.

### O dado que ficou, e ele não é pedido

Com a fórmula certa, o claro desta paleta é muito mais apertado que o escuro (`primary`/`bg` 3,46
contra 7,20; `error`/`bg` 3,68 contra 6,05). O rosa `#FE3976` tem luminância média: fecha pouco sobre
o quase-branco e sobra sobre o quase-preto. A única inversão é `onPrimarySubtle`/`primarySubtle`, que
no ESCURO está em 4,89 — acima do piso, com a menor folga da tabela.

## [0.40.0] — 2026-08-12

### Recebeu — `ds-diletta` v0.76.0 + `catalogo-diletta` v0.104.0

**A origem de cada papel na página de Styles.** Custou as cinco linhas que o aviso prometeu, e o
número que ela revela é a informação: **16 alias para 5 derivados**, de 21 papéis, com zero sem
origem.

> *"Alias é porta, derivação é parede. Mostrar as duas iguais convida alguém a trocar `white`
> esperando mover a tinta de `onPrimary`."*

Virou gate com o número DECLARADO em vez de `greaterThan` — papel que muda de natureza é notícia nos
dois sentidos.

**`DilettaPalette.nome` obrigatório**, e o `analyze` quebrou, que é o comportamento certo pra campo
que a linguagem PINTA. Declarei `'Conta BOLD'`. A razão dele vale reter: **duas peças da linguagem
pintavam o nome do primeiro filho** — um botão que um parceiro embeda no app dele dizia literalmente
*"Pagar com CPF Seguro"*. A régua é *"string que é lookup é inofensiva; string que é PINTADA é o pior
caso da classe"*, e eu tenho `id: 'contaBold'` desde sempre sem nunca ter pensado nele como risco.

### Corrigido — DOIS defeitos meus que só as checagens novas do motor podiam achar

**1 · o alinhamento não voltava.** O motor emite o `crossAlign` como um widget POR FORA do bloco —
`Align(alignment:)` pros extremos, `Center` pro meio — e o meu leitor lia só o de dentro. Quem
mudasse o alinhamento no compositor veria a escolha sumir na volta, **sem nada falhar**.

Eu não tinha como achar: nenhuma tela minha declara alinhamento, então o defeito só existia no
caminho que ninguém tinha andado. A armadilha veio avisada no `porQue` da violação e ela é real —
**`AlignmentDirectional.centerEnd` contém a palavra `center`**, e testar o meio antes dos extremos
devolve um terceiro valor errado, que é pior que falhar.

**2 · onze aliases fantasmas.** A origem de `bg` aponta pra `white`, e `white` não estava na minha
página. **Link morto numa página de referência é pior que ausência**: quem lê `alias: neutral09`
procura o degrau, não acha, e conclui que a rampa é outra.

A lista era curta porque eu escolhia por *"quais eu uso em componente"*. A origem mudou o critério:
**publicar é obrigação de quem declara alias.**

### Aberto — o primeiro pedido no formato novo

`Object? heroTag` no `DilettaAvatar`, com o «Já tentei» que o pai pediu antes de eu escrever:
envolver o cabeçalho num `Hero` por fora faz voar a CASCA (300+ × 100+) e não o círculo (48 × 48),
porque **`Hero` casa por posição na árvore, não por seletor**. Medido em teste.

O critério de sucesso é o que ele cobrou, e não é "ficarem parecidas": **`BoldTopBar.home` deixa de
existir no app.**

## [0.39.0] — 2026-08-11

### Recebeu — os dois pedidos abertos voltaram, e os dois ENTRAM

**`ds-diletta` v0.67.0 → v0.68.0 · `DilettaTopAppBar.app(vidro: false)`.** O `BoldCabecalhoDaHome`
não cobre mais o terço superior da arte, e a home do catálogo mostra a cidade do topo ao rodapé —
medido: o pixel do topo é `(232,247,252)`, o azul do céu, onde antes era superfície.

O veredito é mais largo que o meu pedido, e a formulação fica: **a superfície da barra existe pra
separar a navegação do conteúdo que ROLA por baixo; quando o topo da tela É a identidade, ela não
tem trabalho — o que ela faz é cobrir.** Ele contou antes de decidir: as SETE variantes da casca
eram de vidro, contra um Material 3 que só pinta no estado *scrolled* e uma nav bar do iOS
transparente até a primeira rolagem. **O desvio era da casa, não da minha home.**

**`catalogo-diletta` v0.90.0 → v0.94.0 · `TelaEmFoco.de(context)`.** O gancho `fundoDoFrame` agora
sabe qual tela está desenhando, e devolve `Widget?`. Os cinco fundos conferidos em pixel: home,
conta e aprovação com arte; Área Pix e extrato sólidos em `(255,237,243)` uniforme.

### Removido — `fundoDaTelaEmFoco`, no prazo que estava escrito nela

A variável mutável de biblioteca que eu tinha declarado como dívida durou **um dia**, que é o que o
`///` dela prometia: *"ela morre no dia em que o gancho receber a tela."* O veredito registrou o que
isso ensina, e é a linha que vale guardar: **escrever o prazo na dívida foi o que impediu ela de
virar paisagem.**

Ficou uma lápide de seis linhas no lugar dela, porque a próxima dívida temporária precisa saber que
a anterior foi cobrada.

### O que saiu do app

O comentário *"SEM glass/fill/stroke — só o conteúdo"* virou uma linha que aponta pra linguagem. Ele
era uma **divergência declarada de um lado só** — a peça do app dizia a regra num comentário e a do
pacote fazia o contrário —, e foi exatamente isso que fez a home do catálogo não parecer com a home
do aparelho.

### Aberto, e já com nome e formato

As duas versões do cabeçalho da home ainda são duas. Elas convergem quando a do pacote aceitar
`avatarHeroTag` — é ela que faz o avatar VOAR da home pro Perfil, e adotar sem isso apaga a
animação. Vai no formato novo de pedido, que chegou hoje, com o «Já tentei» preenchido.

## [0.38.1] — 2026-08-11

### Corrigido — o gate do vocabulário media o PREFIXO, e agora mede a substância

Era a dívida que eu tinha declarado com nome na v0.37.0, e ela vinha de duas frases do mesmo dia. O
pai, no veredito do `DilettaFrame.flow`: *"com o `.flow` entrando, o caso concreto some; **o buraco
do gate não**."* O dono, por outro caminho: *"no catálogo não deve ter NADA fora do DS — então ou a
gente enriquece."*

O gate cobrava que o bloco emitisse algo começando com `ds.`. Um bloco podia começar com `ds.` e
montar a tela com `Row`, `Column` e `Stack` crus por dentro — e o `grade` fazia exatamente isso.

**O `grade` foi consertado antes do gate**: as linhas viraram `ds.DilettaFrame.row(gap:)` nos dois
lados (o `build` e o `codegen`), e o espaçador entre células virou `gap` do frame. Espaçador como
filho é o que o `DilettaFrame` existe pra apagar.

### Duas coisas que o gate novo achou nele mesmo

**Ele confundia `DilettaAppListRow` com `Row`.** `contains('Row(')` acusou a linha de valor, que
emite um componente do PAI cujo nome termina em `Row`. Um gate que grita onde não há nada é tão
inútil quanto o que não grita onde há — virou busca por fronteira de palavra, com controle nas duas
direções.

**Ele media o ramo que ninguém usa.** Bloco com slot emite o código de verdade pelo `slotsCodegen`;
o gate só chamava o `codegen`, que num bloco com filhos devolve a versão VAZIA. Descobri pondo o
`Row(` cru de volta no `grade` de propósito: **o gate passou verde.** Um gate que mede o ramo sem
filhos é o mesmo defeito do prefixo, um andar abaixo.

### A exceção que ficou, e ela tem dono

`SizedBox` no `divisor` vertical — ele não tem eixo próprio, e quem o dá é quem o hospeda. É exceção
por BLOCO e por NOME, não uma categoria: exceção sem dono vira categoria, e categoria é o que apaga
um gate por dentro.

`Expanded` e `Flexible` não estão na lista de proibidos, e isso é declaração e não esquecimento: o
`///` do `DilettaFrame` diz que *"um filho 'fill' no eixo principal é um `Expanded`/`Flexible`
passado como filho"*. Proibir seria o gate contradizendo o contrato do pai.

## [0.38.0] — 2026-08-11

### Corrigido — as TRÊS divergências que sobraram entre o desenho e o aparelho

Todas as três apareceram comparando o PNG com o print, e nenhuma delas seria achada lendo código.

**1 · a linha do extrato emitia uma fábrica que o app não usa.** O aparelho escreve `06:12 • Pix` e
o bloco desenhava `Pix • 06:12`. A causa não era ordem de prop, era composição: o bloco emitia
`DilettaAppListRow.transactionItem`, e o `grep` dessa fábrica neste produto dá **zero**. O extrato
compõe `spotIcon(outline)` + `titleSubtitleSubtitle(subtitle: HORA, accessorySubtitle: método)` +
`amount(cashIn/cashOut)`.

**Uma fábrica com zero uso no produto é uma fábrica que o catálogo estava ensinando errado.** O bloco
perdeu o `ctor`/`args` (a tabela lê `Ctor(args)`, e isto é composição de três acessórios) e ganhou
entrada no leitor.

**2 · o card de saldo mostrava `Extrato ›` dentro do extrato.** Quem já está lá não tem pra onde ir.
O componente já sabia — atalho nulo esconde o link, e é requisito escrito no contrato dele desde que
ele nasceu. O BLOCO é que cravava o callback. Virou prop.

**3 · o fundo é por TELA e o gancho é por produto.** Este produto tem sete fundos e escolhe por tela:
a aba Início pinta a arte, as outras abas mostram o secundário, a Área Pix crava sólido. O extrato
com a cidade atrás **não é estilo, é a tela errada**.

Pintar o fundo certo por fora não resolve: o `buildScreenLayout` pinta o gancho por dentro e vence.
Está pedido ao motor; enquanto não vem, `fundoDaTelaEmFoco` — variável mutável de biblioteca, que é
exatamente o que este repo evita, **declarada com prazo** no `///` dela.

### O que fica da rodada

As três divergências tinham a mesma forma: **o componente estava certo e a DECLARAÇÃO estava
errada.** O contrato do saldo já exigia o atalho opcional; o extrato do app já compunha a linha; a
regra do fundo já estava escrita num comentário do shell há meses. Nenhuma das três era uma peça
faltando — as três eram o catálogo dizendo uma coisa que o produto não diz.

## [0.37.0] — 2026-08-11

### Recebeu — `ds-diletta` **v0.66.1 → v0.67.0**, os dois pedidos do dia

**`DilettaFrame.flow`.** A forma `fluida` do bloco `grade` deixou de embrulhar um `Wrap` do Flutter.
O veredito trouxe uma correção no doc do próprio pai: o `Wrap` estava listado em *"deixar cru — sem
decisão estética"*, e `Row`/`Column`/`Stack` também não têm estética e têm wrapper. **O que o frame
encapsula nunca foi o eixo, é o RITMO** — e o `Wrap` precisa de dois.

**`DilettaInputChip.selecionavel`.** O `BoldChipDeFiltro` virou casca de uma linha. Duas coisas
saíram maiores que o chip: o desenho **já tinha a variante há dois dias** (`State: Selected` no
Figma desde 09/08) e o mapa desenho↔código não perguntava — 23 de 39 pares na mesma situação.

### Corrigido — eu estava errado sobre o alvo de toque, e o erro tem classe

Eu citei **2.5.5** pros 44 do chip. **2.5.5 é AAA**; o mínimo AA é o **2.5.8** da WCAG 2.2, que pede
**24×24** — e a pílula existente tem exatamente 24. Ou seja: o chip **não falhava**, estava em cima
do piso com margem zero.

É a mesma classe de erro que o pai me apontou em 10/08 sobre **regressão e lacuna**: dois estados
diferentes com números parecidos, e o rótulo errado muda a urgência de quem lê.

### As telas de loja foram REDESENHADAS contra o aparelho

O dono comparou o que eu tinha desenhado com o app e disse o que era: *"não tem nada a ver."* Ele
estava certo, e a causa não era uma só.

**Ler o código dá o que a tela PODE mostrar; o print dá o que ela mostra.** A minha home tinha
"Enviar para" e a linha de Autorizações porque o código as constrói — e o aparelho não tem nenhuma
das duas, porque as seções somem sem dado. Menu, rótulos e valores vieram do print: `Minha conta`,
`Cobrar` no lugar de `Autorizações`, `Letti` no lugar de `Lia`.

### Corrigido — a ferramenta de desenho mentia sobre a PRIMEIRA tela

A home saía sem a arte da cidade nos dois temas; as outras quatro saíam com ela. Não era a tela, era
a ordem: `AssetImage` decodifica fora do relógio do teste, e a home é a primeira de cada laço — da
segunda em diante a imagem já estava em cache.

**Um artefato que mente sobre a primeira tela e acerta as outras quatro é pior que um que erra
todas**: ele passa por decisão de design. Entrou `precacheImage` dentro de `runAsync`.

### Aberto, com nome

- **o gate do vocabulário mede o PREFIXO e precisa medir a substância.** Ele cobra que o bloco emita
  algo que comece com `ds.`, e o `grade` com `colunas: 2` ainda emite `Row(children: [Expanded(…)])`
  cru por dentro. O pai registrou no veredito (*"o caso concreto some, o buraco do gate não"*) e o
  dono disse o mesmo por outro caminho: *"no catálogo não deve ter NADA fora do DS."*
- **o topo da home é vidro na linguagem e não é nada no aparelho** — pedido aberto.

## [0.36.0] — 2026-08-11

### O pedido era screenshot de loja. Ele virou a maior auditoria de adoção deste repo.

O dono pediu quatro telas em alta fidelidade pro catálogo — home, Área Pix, Gestão da conta e
extrato — e depois a de aprovação. **As cinco travaram no mesmo lugar**: peças que só existiam
dentro do aparelho.

A frase dele é a régua desta versão: *"era pra tudo estar no catálogo porque era pra tudo estar no
DS."*

### Adicionado — **oito componentes**, e eles são três dívidas diferentes

| peça | o que era | alcance no app |
|---|---|---|
| `BoldLadrilhoDeMenu` | **lacuna** — `BoldMenuTile`, sem par na linguagem | 4 |
| `BoldChipDeFiltro` | **lacuna** — `BoldFilterChip` | 3 |
| `BoldLinhaDeAviso` | **lacuna** — `BoldNoticeRow` | 2 |
| `BoldCartaoPromocional` | **lacuna** — `BoldPromoCard` | 2 |
| `BoldFileiraDeAvatares` | adotada, **do lado errado da fronteira** | 3 |
| `BoldGrupoDoDia` | adotada, do lado errado da fronteira | 1 |
| `BoldCartaoDaConta` | **classe privada dentro de uma tela** (`_AccountHeader`) | 1 |
| `BoldCartaoDePedido` | classe privada dentro de uma tela (`_PendingCard`) | 1 |

As quatro primeiras eram as **últimas lacunas** do inventário de adoção. As outras quatro não
apareciam em inventário nenhum, e é aí que está a lição:

1. **adotada e alcançável não são a mesma coisa.** A fileira de avatares compunha o `DilettaAvatar`
   do pai desde 08/08 e ainda assim não podia ser desenhada, porque morava em
   `app-newbold/lib/design_system/` — e o catálogo consome o PACOTE, nunca o app;
2. **widget privado que a tela constrói é invisível pra qualquer gate.** É a quarta classe de dívida
   que este repo achou, e a única que nenhuma varredura via: peça órfã, classe pública morta e
   widget privado não construído aparecem em `grep`; widget privado COM uso não aparece em nada.

Os oito têm contrato escrito (`kBoldSpecs` foi de 12 para 19, com o teto de ~30 ainda de pé) e gate
próprio nas bordas que importam.

### Corrigido — **o saldo oculto sumia quando era baixo**

Print do dono: saldo de R$ 0,14 com o olho fechado mostrava só `R$`. A largura reservada era a do
valor REAL, e isso só funciona enquanto ele for mais largo que a máscara — `R$ ••••••` não é.

O contrato do `saldo` já exigia isso desde que foi escrito (*"SHALL manter a mesma largura do valor
visível"*), e o gate media com `R$ 2.912,47` — um exemplo do lado confortável da desigualdade.
**Um exemplo testa o exemplo.** Agora a largura é o máximo dos dois estados, e o gate mede no valor
curto, com controle no valor longo.

### Corrigido — o ladrilho compacto estourava 4 pixels

Consequência da mudança de casa: `BoldType.tileLabel` (10/12) não existe na escada do pai e virou
`labelSm` (11/16) — duas linhas passaram de 24 para 32, e o cartão de 80 recebeu 84. O respiro do
compacto foi de 12 para 8, que também dá mais 8 de largura pro rótulo.

O degrau de 10px saiu porque tinha **um usuário só**, e um degrau com um usuário não é escada.

### Corrigido — o progresso de aprovação estourava o cartão em 85 pixels

Dentro do `BoldCartaoDePedido` ele vai na forma compacta, e o afastamento do prazo é `spaceBetween` e
não `Spacer`: `Spacer` é `Expanded`, então ele disputava o espaço livre com o `Flexible` do progresso
meio a meio. **Espaçador que compete com conteúdo** é a causa mais silenciosa de estouro num `Row`.

## [0.35.0] — 2026-08-10

### Recebeu — **a conformidade voltou VAZIA, sem asterisco**

`ds-diletta` **v0.66.0 → v0.66.1**: filtro e escolha no lugar do percurso. Os números desta paleta,
com o trilho em `#3D3939` nos dois temas:

| | `normal` | `warningGrafico` | `error` | vs página |
|---|---|---|---|---|
| claro | 3,29 | 5,48 | 3,10 | 11,40 |
| escuro | 4,18 | 6,39 | 3,51 | 1,72 |
| esqueleto | | | | **1,41 / 1,41** |

**Três tags do pai num dia e nenhum hex meu se moveu** — o critério era dele: *identidade não paga
piso*. A baseline do teste de conformidade voltou a ser `isEmpty`.

### O que eu levo, e é sobre como MEDIR

1. **Regressão e lacuna não são o mesmo dado.** Eu reportei `error: 3,11 → 1,41` como uma linha numa
   tabela de quatro; ele separou a linha e disse o que ela era — *"não foi um caso que faltou fechar,
   foi um caso que estava certo e eu piorei"*. Uma diz **falta**, a outra diz **estragou**, e a
   segunda é mais urgente mesmo com número parecido.

2. **Restrição não é escolha.** Eu propus *"o mais longe das tintas"*; faltava dizer qual entre os que
   fecham. Ele acrescentou *o mais discreto*, com a razão: **trilho é o que sobra atrás do
   preenchimento, não elemento que se anuncia.** A minha metade dizia onde NÃO pode estar.

3. **Duas paletas concordando é coincidência, não amostra.** Ele escreveu isso duas vezes hoje, nas
   duas contra si mesmo. Vale igual aqui: **os meus gates de vocabulário medem ESTA paleta**, e nenhum
   prova que a regra sobrevive a outra.

## [0.34.0] — 2026-08-10

### Recebeu — **os dois pedidos entraram na mesma tag, porque eram a mesma doença**

`ds-diletta` **v0.64.0 → v0.66.0**. Os três papéis derivados (`trilhoDeMedidor`, `warningGrafico`,
`surfaceLoading`) pararam de ser DEGRAU e passaram a ser DISTÂNCIA. O veredito citou a frase deste
repo como a regra: *"o primeiro é degrau não viaja entre PALETAS; o segundo é degrau não viaja entre
TEMAS — nos dois, o que se quis dizer era uma DISTÂNCIA."*

**O esqueleto fechou**: era 1,41 no claro contra **2,51** no escuro, e agora é **1,41 e 1,41**, sem
tocar num hex. Tem gate próprio, medindo o **peso** e não a cor — cor muda com a rampa, peso é a
intenção.

**A conformidade encolheu de 3 pra 2**, e a que sobrou virou pedido novo: a busca do trilho percorre
a rampa do claro pro médio, e o rosa desta marca tem luminância média — descer o trilho o aproxima da
tinta antes de afastar. `normal` foi de 2,93 pra **1,32** e `error` de 3,11 (passava) pra **1,41**.

### O que eu levo dos vereditos, e nenhum é sobre cor

1. **"A v0.64.0 passaria verde sem esta correção."** Nas duas paletas do repo do pai, degrau fixo e
   derivação por contraste escolhem *o mesmo valor* — a suíte inteira ficava verde com a derivação
   errada. Só apareceu porque eu rodei numa terceira rampa. **Suíte verde com duas paletas não prova
   que a regra viaja: prova que as duas concordam.**

2. **O defeito do esqueleto na paleta dele era o OPOSTO do meu**: aqui pesava 2,51 (bloco que chama
   atenção), lá pesava **1,00** — o esqueleto não existia, porque `surfaceLoading` e `surface` eram a
   mesma cor. O meu era feio; o dele era invisível, e **invisível passa em qualquer teste que olhe só
   a cor declarada.**

3. **Ele usou a minha REGRA e não o meu valor.** Eu propus `neutral01` pro trilho escuro; ele pôs a
   regra (*"o primeiro neutro que se separa da página"*), que na minha paleta cai no `neutral01` e na
   dele fica onde estava. *"Mesma regra, valores diferentes: é isso que viajar quer dizer."*

## [0.33.0] — 2026-08-10

### Recebeu — **`trilhoDeMedidor` e `warningGrafico`, e rodar o comando dele achou 3 dívidas MINHAS**

`ds-diletta` **v0.63.0 → v0.64.0**. O pedido do trilho entrou, e o veredito veio com uma instrução em
vez de um número: *"rode `violacoesDeConformidade(BoldPalette.bold)` — ele mede o par da SUA paleta e
diz o número, sem eu ter que adivinhar."*

**O conserto funcionou onde eu pedi**: o par tinta×trilho no escuro passou (era `warning` em 1,04).

**E o comando achou três violações que eu não tinha medido:**

```
[trilho-do-medidor] normal/trilhoDeMedidor (light)      — 2,93:1   piso 3,0
[trilho-do-medidor] warning/trilhoDeMedidor (light)     — 2,85:1   piso 3,0
[trilho-do-medidor-invisivel] trilhoDeMedidor/bg (dark) — 1,08:1   piso 1,1
```

A causa é uma só, e virou pedido: **os dois papéis novos derivam por DEGRAU FIXO** (`neutral09`,
`warning03`, `surfaceEscura`), e degrau não viaja entre paletas. O mesmo `warning03` dá **4,80 na
referência e 2,85 aqui** — a mesma regra que ele escreveu (*"contraste não se herda de outra paleta"*)
aplicada à medição, mas não à derivação.

### A baseline NÃO ficou vazia, e ela lista uma a uma

O teste da conformidade passou a declarar **as três violações pelo nome**, com o pedido junto. Não por
contagem: **baseline com número esconde troca** — uma sai, outra entra, e o total não se mexe.

### Duas coisas que eu levo do veredito

1. **Ele mediu quatro candidatos e nenhum dos meus passou.** Eu pedi `surfaceMuted`; ela derruba o
   `error` no escuro pra 2,40. O que salvou o pedido foi eu ter escrito *"ou o papel que você julgar"*;
2. **A cobrança que eu não tinha feito**: `bg` e `surface` passavam nas três tintas e ele recusou
   porque **somem contra a página** — *"teria escolhido `bg` e entregado uma barra sem trilho"*. Eu
   medi tinta×trilho e parei ali; faltava trilho×página, e ela virou regra da conformidade, onde
   protege os dois filhos em vez de só este.

## [0.32.0] — 2026-08-10

### Recebeu — **os dois pedidos de ontem entraram, e os dois vereditos me corrigiram**

`ds-diletta` **v0.62.2 → v0.63.0**: `DilettaDialog.content` e `DilettaProgressBar.tone`.

- **O slot do diálogo** entrou não pela contagem (3 sítios), mas pelo **custo do substituto**. Eu tinha
  escrito no pedido que *"a folha não trava a tela, então o voltar do sistema fecha sem resposta e o
  fluxo segue como se a pessoa tivesse cancelado"*, e o veredito transformou isso na razão:
  **peça errada com comportamento errado é pior que slot faltando** — a primeira obriga a compor à mão,
  a segunda obriga a conviver.

  Conferindo os três pra trocar, achei o que eu não tinha medido: o de **autorizar aparelho** grava um
  nome e dispara a geração do código. Voltar sem responder ali não é cancelar — **é o operador achando
  que autorizou.**

- **O tom da barra** entrou, e o veredito derrubou a minha contagem: eu escrevi *"2 sítios, exatamente o
  segundo caso da régua"* e ele respondeu que **o mesmo medidor duas vezes é UM caso, não dois**. O que
  promoveu foi a classe: `SpotIcon` muda por `state`, `StatusTag` por `tone`, e a barra pintava sempre
  igual sem razão escrita.

  Regra que sai daqui, e ela é minha: **antes de escrever o número, perguntar se ele mede coisas
  diferentes ou a mesma coisa repetida.** Sítio repetido é alcance; caso é forma. No pedido do spot
  herói eu tinha contado *discordância* (quatro diâmetros, três formas) e acertado; aqui contei cópia.

### Mudou aqui — **o texto entrou junto com a tinta**

O veredito veio com o número que eu não tinha: contra o trilho `neutral07`, `warning` dá **1,82 no
claro e 1,17 no escuro**, e o piso de elemento gráfico é **3:1** (WCAG 1.4.11). Somado à 1.4.1 (cor
sozinha não é informação), o aviso passou a ser **escrito**: `perto do teto` acima de 80%, além do
`teto consumido` que já existia no estouro.

O segundo medidor só falava no estouro — **a faixa de aviso era cor pura.** Sem o número do pai eu
teria trocado a tinta, fechado o item, e deixado a barra menos visível no escuro do que antes.

E a ressalva que ele fez e eu não tinha feito: eu usei *"o texto ao lado só mostra o valor, não a
proximidade do teto"* como argumento PRO tom, sem ver que era a descrição de um defeito meu.

### Fechou — `LinearProgressIndicator` 3 → 0

Era a última exceção nomeada no gate `a_tela_nao_desenha_sozinha_test`, e ela morreu como exceção deve
morrer: **pelo pedido, não pela tolerância.**

## [0.31.0] — 2026-08-10

### Recebeu — **o release do pai não move nada aqui, e medi-lo achou um corpo**

`ds-diletta` **v0.61.0 → v0.62.2** e motor **v0.86.1 → v0.90.0**. As três tags do pai (tracejado do
cartão de conclusão, respiro do stepper, contrato do slot do banner) e a do motor (`slot-de-um-com-mais`)
**vieram todas do filho A**, e eu conferi peça por peça em vez de aceitar pelo changelog:

| peça que mudou | sítios neste app |
|---|---|
| `DilettaChatCompletionCard` | **0** |
| `DilettaStatusBanner` | **0** |
| `DilettaStepper` | **0** |

Zero é resposta, e ela vale escrita: subir a ref custou nada e mantém a fronteira — filho atrás do pai
é dívida que ninguém vê até precisar de uma peça nova.

### E o zero do stepper era um CORPO

Fui medir se o respiro de 4px do `DilettaStepper` chegava aqui, e não chegava porque **nada usa
stepper neste app**. As nove telas de onboarding que mostram progresso usam outra peça — a
`OnboardingProgressBar`, uma barra de 4px.

O `BoldStepper` e a fábrica `BoldTopBar.stepper` estavam vivos **só pelos dois testes que os
exercitavam**. É o quarto tipo de código morto desta adoção, e passa pelos três gates que já existem:
tem consumidor no `lib`, é classe pública citada, e é construído. **O consumidor é o teste.**

> Um teste que é o único consumidor de uma peça não está protegendo o produto: está mantendo a peça
> viva pra si.

A garantia que aqueles testes guardavam é real — *a segunda linha entra DENTRO da casca do pai* — e
ela **mudou de veículo em vez de sumir**: hoje quem a exercita é a FAIXA de "agindo em nome de", que é
o ocupante vivo do mesmo slot. Gate novo: `nenhuma_peca_vive_so_pelo_teste_test`.

**E o pai já sabia, do lado dele.** O `///` do `DilettaStepper` diz *"o único consumidor real do
stepper nos dois filhos é quem pediu a troca"* — o filho A. A medição dele e a minha bateram sem
combinar, e é isso que dá confiança nas duas.

### Segue aberto — os dois pedidos de 09/08

`content` no `DilettaDialog` (2 sítios com campo dentro) e `state` na `DilettaProgressBar` (o medidor
de limite, 2 sítios). Nenhum dos dois entrou em código na v0.62.2 — conferido lendo a assinatura das
duas peças, não o changelog.

## [0.30.0] — 2026-08-08

### Recebeu — **a linguagem passou a RECEBER valor, e o spot herói ganhou degrau**

`ds-diletta` **v0.54.0 → v0.61.0**, com dois vereditos que saíram de dois pedidos medidos aqui:

- **`DilettaAmountField({controller, size, prefixo, placeholder, inputFormatters})`** — o campo de
  valor. A medição que decidiu foi a assimetria: **três peças pra MOSTRAR valor** (`DilettaAmount`,
  `DilettaAmountDisplay`, `DilettaReceiptRow`) e **nenhuma pra RECEBER**. O veredito chamou de *"metade
  de um gesto que a linguagem afirma cobrir"*, e não passou pela régua do segundo filho: *"buraco de
  simetria não espera promoção"*.

  O que fechou o desenho foi uma frase minha que eu não tinha percebido ser o argumento: *"os dois lados
  do mesmo gesto pediram os mesmos dois portes, sem combinar"* — o `AmountDisplay.hero` já existia na
  leitura, e as 6 telas de entrada daqui pediram a mesma divisão sozinhas. **Duas medições
  independentes chegando na mesma divisão é a definição operacional de gramática.**

- **`DilettaSpotIcon.heroi`** — o círculo grande da marca (96 = `DilettaSpacing.s24`). O pedido não
  levou tela nenhuma: levou a **discordância**. Seis telas desenhando `Container` com gradiente na mão,
  **quatro diâmetros e três formas**. Eu declarei não ter o número certo — tenho quatro, que é a prova
  de que ninguém decidiu —, e o veredito escolheu pela escala: *"96 é o único dos quatro que cai num
  degrau desta linguagem; 110 e 100 não existem em lugar nenhum"*.

### Mudou aqui — `BoldDinheiro.formatter(comSimbolo: false)`

A máquina de centavos ganhou o modo SEM símbolo, e a razão é do pai: o `AmountField` põe o `R$` num
`Text` próprio, num degrau **menor** que o número — *"ele é referência, não valor: o que se lê primeiro
é quanto, não em quê"*. Com o símbolo dentro do texto, ele herdaria o porte do número.

O default continua `true`. Os campos BORDADOS do app (9 pontos) mostram o símbolo dentro, porque ali
não há slot separado pra ele.

### Adotado no app no mesmo dia

`BoldCurrencyField` virou casca nas 6 telas de mandar dinheiro, e `DilettaSpotIcon.heroi` entrou nas 5
telas de estado. **`BoldGradients.brand` fora do DS caiu de 6 usos pra 1** — o que sobrou é o item de
tipo de conta, que o próprio veredito separou por *"nem ser o mesmo gesto"*.

Duas coisas que eu ia pedir e não pedi, e as duas viraram régua:

- **`focusNode` no `AmountField`.** Não precisa: `Focus.onFocusChange` num envelope enxerga o
  descendente ganhar foco. Quatro linhas aqui valem menos que um repasse pedido ao pai;
- **o `double` do `onChanged`.** Com o símbolo fora do texto, a conversão virou uma chamada só ao
  `BoldDinheiro.emReais` — o que sumiu não foi o `double` (o modelo de quem chama é `double`), foi a
  SEGUNDA máquina de centavos, que era o risco de verdade.

### Segue aberto — **quatro glifos aceitos e zero entregues**

O pedido do `clipboard-light` (colar) voltou **aceito no mérito e travado na arte**, e é a segunda vez
em dois dias. O pai transformou o padrão em pergunta ao dono, e ela não é minha nem dele:

> **Quem é o dono do kit de ícones da família?**

Enquanto não tiver resposta, os quatro glifos ficam parados com veredito escrito e classe medida: as
três negações (`calendar-xmark`, `user-minus`, `key-slash`) e a prancheta. O `clipboard-list-check-light`
segue como o menos errado nas 3 telas de colar — **com a nota de que o ✓ dele não corresponde a nada**.

## [0.29.0] — 2026-08-08

### Recebeu — **o input repassa os três que o campo dele já tinha**

`ds-diletta` **v0.53.0 → v0.54.0**: `autofocus`, `onSubmitted` e `textInputAction` no `DilettaInput`,
com defaults preservados. O veredito saiu no mesmo dia porque **é repasse e não peça** — os três moram
no `DilettaField` desde sempre, e o organismo que o monta por dentro não tinha campo. *"Não havia
decisão de desenho: havia uma parede entre o átomo e quem o consome."*

**Uma decisão que eu não pedi**: o `autofocus` atravessa só na variante de UMA LINHA. Abrir teclado
sozinho em campo de texto longo é outro pedido, e ele deixou escrito que o número que promove é meu —
e eu tenho dois, medidos, que não são texto longo (ver a nota no pedido).

### E a nota dele sobre as negações vale mais que o item

O dono manteve os três positivos, contra a recomendação dele de usar `userCircleMinusLightFull` num
deles. A nota que ele escreveu depois é a lição:

> *"Eu apliquei o argumento em dois dos três e ele aplicou nos três. A inconsistência era minha — eu
> tratei o caso que tinha substituto disponível de um jeito e os que não tinham de outro, e ter
> substituto não é critério de significado. **A existência de uma opção não é razão pra escolhê-la.**"*

## [0.28.0] — 2026-08-07

### Recebeu — **o diálogo ganhou glifo, e o número do spot é o da família porque eu não tinha o meu**

`ds-diletta` **v0.52.0 → v0.53.0**: `DilettaDialog({icon, state})`. Nulo ⇒ o diálogo de antes, então
nenhum consumidor muda.

O pedido saiu de uma assimetria medida: das cinco peças de atenção da linguagem, quatro carregam
glifo — toast, estado vazio, info card, banner — e a **mais interruptiva** era a única sem. O veredito
usou a leitura da v0.40.0: *"buraco de simetria não espera promoção"*.

**Duas coisas que eu NÃO pedi decidiram o desenho**, e vale escrever porque é método:

- **cor por parâmetro** ficou fora, e o número é meu: *21 de 21 chamadas passam glifo, zero passam
  cor*. Quem chama escolhe o glifo, o tom sai do `state` — mesma divisão do toast;
- **o spot ficou 34**, o default da família, e não os 56 do meu desenho. Eu declarei não ter medição
  que sustentasse o 56, e a resposta dele foi direta: *"sem número medido, o número da família ganha"*.

A frase do veredito que fecha o método: **declarar o que não se tem medição pra sustentar é o que
deixa o pai escolher sem inventar.** Se eu tivesse afirmado o 56, ele teria que aceitar o número de um
produto na linguagem ou recusar o item inteiro.

## [0.27.0] — 2026-08-07

### Recebeu — **a linguagem passa a saber dizer "estou te ouvindo"**

`ds-diletta` **v0.51.0 → v0.52.0**: `microphoneLight` e `microphoneSlashLight`. **355 no conjunto.**

O pedido saiu da adoção do app e a medição mudou o que estava sendo pedido: não era par incompleto
como o avião de ontem — `micro*`, `voice`, `audio`, `sound`, `speaker` e `volume` davam **zero** nas
353, e o `monitor-waveform` é onda de saída, o oposto de captação. **Família inteira ausente.**

Os dois entraram juntos pelo argumento do ternário: `micEnabled ? 'mic' : 'mic-off'` é **par de
ESTADO**, e meio par é um botão que muda de significado quando se toca nele. Só o peso `light` entrou
— o sólido não tem consumidor medido, que é a régua que ele aplicou ontem às três famílias sem par.

### E o diff dos dois conjuntos virou classe no lado dele

O número que a limpeza do app produziu: dos **355** SVGs que o app carregava, **11** não existiam no
conjunto do pai, e só **2** eram dívida. Os outros 9 eram lixo herdado com zero uso — **incluindo os
seis exports crus que ele mesmo apagou na v0.45.0**, que seguiram embarcando no app por mais de uma
semana. A frase do veredito é a lição: *"apagar um asset no pai não apaga a cópia que um consumidor
fez antes, e nada media a diferença entre os dois conjuntos."*

Os outros **344 eram cópia byte a byte** — e é isso que prova que era cópia, e não uma família
parecida que alguém tinha ajustado.

## [0.26.0] — 2026-08-07

### Recebeu — **o par leve do avião de enviar, e o conjunto vai a 353**

`ds-diletta` **v0.48.0 → v0.51.0**, e a entrada é o pedido que a adoção do app produziu ontem:
`DilettaIcons.paperPlaneTopLight`. O app tinha 76 nomes de glifo, 75 existiam lá, e o que sobrava era
o botão de enviar do compositor de conversa.

**O veredito mediu a CLASSE antes do caso**, e o número dele vale mais que o meu pedido: das 157
famílias do conjunto, **sete têm só o sólido** — três são marca (`apple`, `google`, `whatsapp`), onde
peso leve não faz sentido, e sobram quatro reais. A minha era **a única das quatro com consumidor
medido**, e é o que a fez entrar sozinha; as outras três esperam alguém desenhar tela com elas.

E ele **não aceitou a arte, mediu**: o meu SVG carrega um `<g transform>` que 351 dos 352 não têm, e
transform num glifo é suspeita de arte reescalada — que num conjunto significa um ícone com peso
visual diferente dos irmãos. Ele mediu a caixa de tinta dos dois com o transform aplicado
(`0,98..17,05` contra `1,00..17,06`) e concluiu que era encaixe no box de 18, não reescala.

Nada muda neste pacote. Quem consome é o app, e é por isso que esta entrada existe: sem a tag, ele não
alcança o glifo — e com ela some a última razão de o app manter conjunto de ícones próprio.

## [0.25.6] — 2026-08-06

### Consertou — **o 39 que eu escrevi ontem estava errado, e pelo mesmo defeito que eu tinha acabado de nomear**

Ontem eu troquei o `~50 papéis` da minha prosa por **39**, medido. O pai foi conferir porque o número dele
dizia 32, rodou por CAMPO e achou **53** — e o meu 39 tem a causa exata do `grep -c` dele: **o meu regex
contava LINHA de declaração.** `final Color warning, onWarning, warningSubtle;` é uma linha e três papéis,
e eu li como um.

A frase dele é a régua nova, e ela está uma casa acima das outras três:

> **A 4b confere se o comando devolve o número da frase. Ela não confere se o comando responde a PERGUNTA
> da frase.**

O meu comando respondia *"quantas declarações existem"* com precisão. A frase perguntava *"quantos
papéis"*. Os dois números são inteiros, os dois saem de medição, e o errado parecia mais honesto que o
chute que ele substituiu — **medir a coisa errada produz um número com cara de fonte.**

Este número já errou cinco vezes entre os dois repos: `~50` (chute meu) · `27` (contagem velha dele) · `58`
(glob errado) · `32` (`grep -c`, linha) · `39` (meu regex, linha). **Agora é 53, e o comando que responde a
pergunta certa ficou ao lado dele na prosa** — `grep -oE 'final Color\??[^;]+;' … | tr ',' '\n' | wc -l`,
verificado devolvendo 53.

### Reconferido — **os outros números destas cinco rodadas, contra a pergunta nova**

Fui atrás de todos os que eu produzi desde v0.25.0 pra ver quais respondiam outra pergunta:

- **Os de runtime passam por construção**: `Ds.blocos.length` (56), specs (77 + 12), ícones (352), telas
  (5), `ctor`/`args` (46 · 42), as medições de pixel. `.length` de um mapa não tem como contar linha.
- **Os dois de regex eu remedi pela via que responde a pergunta**: as 12 opcionais da paleta (uma por
  parâmetro `this.x` — parâmetro não lista dois nomes, e eu já tinha conferido nome por nome) e os **21
  papéis** do catálogo, recontados por par `'chave': p(` em vez de por chave solta. Bateram.

**A distinção dele sobre o `~` entra como regra**: aproximação sobre grandeza CONTÍNUA é cuidado
(`~30px de dissolução`); sobre coisa CONTÁVEL é licença que ninguém deu. Papel, bloco e spec se contam com
um comando — não há o que aproximar, e o til só disfarça.

## [0.25.5] — 2026-08-06

### Consertou — **a minha varredura de ontem era FECHADA como a dele, e a aberta achou OITO**

O pai foi ver por que o gate dele (classe 4 da limpa, *"números afirmados"*) não pegou os seis documentos
derivados: **a lista de substantivos era fechada e `nomes` não estava nela.** Fechada dava 5 candidatos,
aberta dá 24. A forma é a que este repo proíbe em switch de tipo — `_ => cinza` faz o caso novo se
disfarçar de nenhum caso.

**Eu tinha a mesma forma, um dia depois de escrever a lição.** A minha varredura de ontem procurou
`blocos|ícones|telas|contratos|componentes` — cinco palavras que eu já sabia que estavam erradas. Rodei a
versão aberta dele (número + plural, menos tempo e palavra funcional): **91 candidatos, e 8 números vivos
errados que a lista fechada não alcançava.**

| onde | dizia | é |
|---|---|---|
| `conta_bold_design_system` · cabeçalho | *"os ~50 papéis do scheme"* | **39** |
| `conta_bold_design_system` · o que o consumidor recebe | *"os 100 componentes do pai"* | **77 com contrato** |
| `conta_bold_design_system` · o defeito do asset | *"nem os 414 testes"* | 125 + 86 — o número saiu, porque o argumento nunca dependeu do tamanho da suíte |
| `bold_contratos` · cabeçalho | *"o pai entrega 64 specs"* | **77** |
| `catalog/main` · o dicionário | *"as 64 specs passaram a viajar"* | 64 **à época**, 77 hoje — marcado como história |
| `ds_do_bold` · papéis do catálogo (2 sítios) | *"os 17 papéis"* | **21** |
| `ds_do_bold` · rampas e papéis (2 sítios) | *"os ~51 do esquema"* | **39** |

**O `~` não protege.** Três dos oito eram aproximações escritas com til (`~50`, `~51`), e til dá licença de
arredondar, não de errar por 12. Aproximação envelhece igual, e ainda por cima sem culpa aparente.

**E as duas citações de "124 telas" FICARAM**: as duas são fala do pai com versão ao lado (*"um filho tem
124 telas, o outro tem ZERO"*, motor v0.55.0). Citação atribuída e datada é registro, e é o mesmo critério
que manteve o `44` no CHANGELOG dele.

### Medido e sem custo — **as 12 opcionais da paleta do pai, eu declaro as 12**

O detector novo dele acendeu em `55 cores` e achou o contrato do filho dizendo *"7 opcionais"* onde são 9.
Fui conferir o que isso me cobra: **nada.** `BoldPalette` declara os 12 campos opcionais (as 9 cores mais
`blurDeVidro`, `cardDeVidro` e `raioDeBotao`) — conferido campo por campo contra o construtor dele.

## [0.25.4] — 2026-08-06

### Mede — **a base "é fixa" e o que eu media era "pinta depois do último bloco"**

Nenhum aviso chegou nesta rodada: o pai da FERRAMENTA rodou a mesma varredura no motor dele, no repo dele,
e achou **1 defeito em 12 frouxas de geometria** — uma asserção cujo `reason:` falava da altura da CAMADA e
que media um TEXTO de 8px contra um teto de 170. A frase dele é a terceira pergunta do crivo:

> **O valor medido é o que o `reason:` fala?** E o que distingue é a ÂNCORA.

Fui aplicar às minhas, e a que caiu é a mesma forma. `expect(dyDe('b1'), greaterThan(dyDe('c3')))` com o
comentário dizendo *"a BASE é fixa: ela fica no fim da tela, e não no fim do conteúdo"*. **Ela só dizia que
a base pinta depois do último bloco — que é exatamente o que aconteceria se a base ROLASSE junto.** Passava
nos dois mundos, e os 400 de folga que eu tinha anotado ontem como *"exercida"* faziam ela parecer sólida.

O erro é meu e é anterior ao comparador: eu tinha triado essa asserção **duas vezes** nas rodadas passadas,
pelas duas primeiras perguntas (*o exato é conhecível?* e *está em cima do limite?*), e as duas responderam
"está boa". Nenhuma das duas pergunta se o número medido **é o assunto da frase**.

Ancorada agora na borda do frame: a distância da base até o fim do frame é **8** — a mesma borda que o
bloco de topo tem em cima, medida contra `dys[0]` pra que a simetria seja o gate. Se a base seguisse o
conteúdo, esse vão passaria de **400**.

## [0.25.3] — 2026-08-06

### Consertou — **sete números vivos na minha prosa tinham derivado, e o pior era o do escopo**

O pai levou a minha frase (*"frouxo não é o defeito, não-exercido é"*) pro documento de gate e mandou de
volta o achado que ela produziu no lado dele: um teto de contagem escondendo **seis documentos** com o
número errado. Fui procurar a mesma classe aqui, e ela existe — **em prosa, não em asserção**.

Medido hoje: **56 blocos · 55 com contrato · 352 ícones · 5 telas · 77 specs do pai + 12 minhas**. Contra
isso, sete afirmações em tempo presente em dois arquivos vivos:

| onde | dizia | é |
|---|---|---|
| `ds_do_bold` · cabeçalho de escopo | *"São 12 blocos"* | **56** |
| `ds_do_bold` · derivação dos contratos (2 sítios) | *"43 blocos e 64 specs"* | **56 e 89** |
| `ds_do_bold` · conjunto disponível | *"um pai com 71 palavras"* | **77** |
| `ds_do_bold` · o defeito do asset | *"os 358 ícones"* | são **352**, e o número não fazia falta ao argumento — saiu |
| `leitor_do_bold` · cabeçalho | *"a tabela cobre 22 de 29 blocos"* | **46 dos 56 declaram `ctor`** |
| `leitor_do_bold` · a tabela | *"20 dos 24 blocos declaram `ctor` + `args`"* | **42 dos 56** |

**O do escopo é o pior, e é o meu espelho do 44 dele**: o cabeçalho do arquivo mais lido deste catálogo
abria dizendo que o vocabulário tinha 12 palavras quando tem 56 — quem chegasse por ele leria um produto
que não existe mais. Passou a apontar pra contagem viva (`Ds.blocos.length`) e a datar o número.

### E NÃO entrou gate de regex pra isso, com o motivo

O discriminador aqui não é o número, é o **tempo verbal**: *"passava com 29 blocos"*, *"18 dos meus 20
blocos emitiam"*, *"238 de 1.032 blocos eram só espaço"* são registros de medição datada e ficam — corrigir
um deles seria falsificar o resultado, que é a regra que já vale pros arquivos de auditoria. Um regex não
lê tempo verbal, e um gate que acusa história vira gate que se aprende a ignorar. O que entrou no lugar é
mais barato: **o número vivo saiu da prosa e virou ponteiro pro registro** (`Ds.blocos.length`), e onde ele
precisou ficar escrito, ficou com a data ao lado.

## [0.25.2] — 2026-08-06

### Mede — **a segunda pergunta do crivo: 7 asserções passavam EM CIMA do limite, sem nunca serem exercidas**

O pai transformou o meu `spot.right <= 320` (real: 320,0) na segunda pergunta do crivo — **o valor medido
está em cima do limite?** — e ela derrubou 3 dos 13 pisos que ele tinha mantido por intenção, incluindo um
que escondia violação de diretiva de licenciamento da Apple. Rodei aqui, e ela achou mais que a primeira.

**Nos 5 frouxos de geometria que eu tinha mantido**: 1 estava em cima do limite e virou exato
(`pintado.width <= 200` com **200,0** medidos — o `FittedBox` escala pra OCUPAR a largura, então a
igualdade é a regra; o teto passaria com 150, que é o valor encolhendo sem motivo). 1 está em **igualdade
por desenho** (`c2 → c2a`, os dois em 248: o card da lista não põe respiro próprio, os 144 dele são
exatamente as duas linhas de 72) — e o que isso muda é a leitura do gate: onde há igualdade, a ordem não
distingue *dentro* de *ao lado*, quem prova o encaixe é a contenção. As outras 3 estão exercidas com folga
medida (400, 56, 2,4×), e ficou escrito ao lado de cada uma.

**E estendi pra fora da geometria, porque contagem é onde o exato é mais conhecível**:

| era | medido | virou |
|---|---|---|
| `comContrato >= 52` | **55** de 56 | a **lacuna**, `== 1` — estável quando o registro cresce, e bloco novo sem contrato reprova |
| `emitidos hasLength(> 20)` | **54** | `Ds.blocos.length - 2` — o teto aceitava perder 33 blocos com a pergunta certa no `reason:` |
| `variacoes > 50` | **61** | `== 61` — passava com 11 opções de enum perdidas |
| `c.abas.length > 1` | **7** | `== 7` — sobreviveria a perder cinco abas |
| `erros.length <= 1` | **1** | `== 1` — o resíduo do placeholder é conhecido e documentado; 0 não é melhora, é sinal de que o parágrafo que o explica virou mentira |

**O que fica frouxo, e o motivo é de classe**: os pisos de CONFORMIDADE (3:1 de objeto gráfico, 4,5:1 de
texto, os dois de gradiente). Ali o limite é o requisito, e folga acima dele é o que se quer — o exato
seria a paleta de hoje, e cravar a paleta num gate de política faz o gate reprovar por mudança de cor.

**Carteira de sistema em pai apertado**, que ele pediu que eu medisse porque o defeito dele degrada em
silêncio: **zero telas**. A única ocorrência da palavra neste repo é o ícone `walletLight` numa linha de
lista. Se alguma tela puser a peça em coluna estreita, o número vem daqui.

## [0.25.1] — 2026-08-05

### Mede — **a varredura da quarta forma voltou pra cá: 63 asserções frouxas, 9 de geometria, 3 escondiam número**

O pai rodou no lado dele a varredura que saiu da minha quarta forma (*asserção que concorda com qualquer
coisa acima do piso*) e achou **2 em 15**. Rodei aqui, e o crivo é o dele: **o valor exato é conhecível?**

**456 `expect`, 63 com comparador frouxo, 9 sobre geometria.** Três viraram número, uma saiu, cinco ficam.

- **`greaterThan(52)` na casca da home SAIU.** O exato de 106 nasceu ao lado dela ontem e já reprova em 52 —
  teto e piso na mesma medida fazem o frouxo parecer cobertura.
- **`spot.right <= 320` estava sentado exatamente no limite**: o valor real é **320,0**. O spot encosta na
  borda direita do componente de propósito (a margem é de quem monta a tela), e o teto passaria também se o
  título longo tivesse empurrado o spot pra 319 — que é justamente o defeito que o teste diz medir. Exato,
  mais a largura do spot em 38: agora empurrão de 1px reprova.
- **O fator do alongamento do ponto ativo não estava medido por ninguém.** `larguras[2] > larguras[0]`
  passava com 8,1 contra 8,0 — alongamento invisível. O contrato é **2,75×**, e a asserção passou a ser os
  quatro números: `8 · 8 · 22 · 8`.
- **A espessura da aba ativa é o DOBRO, e era só "maior"**: `[1.0, 2.0]`. A espessura existe pra ser a
  redundância de quem não distingue matiz — 1,1 contra 1,0 satisfaz o `greaterThan` e não se vê.
- **Ficam 5, e é por intenção**: as três de ORDEM no gate de montagem (`dy` crescente — o teste é sobre
  ordem de leitura, exato ali mediria outra coisa), o par que prova o `FittedBox` (natural > pintado é o
  controle) e o teto de contenção do valor.

**Procurei também a segunda classe que ele achou — piso protegendo prosa errada — e aqui deu zero**: nenhum
`reason:` com número desmentido pela medição. O sweep foi por asserção frouxa com número na prosa.

## [0.25.0] — 2026-08-05

### Recebeu — **o respiro da casca era 8 e nunca tinha sido medido: a minha casca da home desce 2px**

`ds-diletta` **v0.47.0 → v0.48.0**. Nenhuma API muda. O `SizedBox(height: 8)` do fim da segunda linha da
casca virou `DilettaSpacing.s1_5` (**6**), e o meu `BoldCabecalhoDaHome` monta em
`DilettaTopAppBar.app(navBar:, conteudo:)` — então a casca montada sai de **108 pra 106** (52 da barra +
48 da minha segunda linha + 6 do respiro). Os `118` do aviso dele são a conta DELE: segunda linha de 20 e
inset de 40. O termo que os dois compartilham é o respiro, e é o único que ele moveu.

A origem vale mais que os 2px: o `8` era o número da variante antiga do **stepper**, e veio de carona pro
meu conteúdo quando a casca generalizou pro meu pedido da v0.11.0. Eu recebi como *"a gramática do pai"* um
respiro que era de outra peça — e o `///` dele que eu citava dizia a mesma coisa, com o número errado dentro.

### Mede — **o gate de posição nasceu ontem e a primeira coisa que ele pega é altura de casca MONTADA**

A asserção que existia era `greaterThan(52)`, escrita pra pegar *"a segunda linha sumiu"*. Ela passa com 106
e passa com 108: **`greaterThan` não é gate de desenho, é gate de existência.** Virou número exato em
`o_cabecalho_da_home_test.dart`, e rodado contra a `v0.47.0` antes de subir — `Expected: <106> Actual:
<108.0>`. Segundo dia seguido de controle contra a versão anterior, e é o que separa medir de acreditar.

O que ele mede que os outros não: a **composição**. O componente solto tem a altura dele; o número que o
produto vê é o da peça dentro da casca do pai, e é ali que dois valores de layout se somam com cada metade
parecendo certa sozinha.

### Pagou — **`pending` chegou na v0.27.0 e a minha espera continuou saindo como `neutral` por seis versões**

Dívida achada auditando o meu próprio ledger, e ele era o esconderijo: as duas linhas dos pedidos **família
`info`** e **casca de app real** ainda diziam *sem veredito* — o primeiro voltou `ENTRA COMO TOM`
(`DilettaStatusTone.pending`, `ds v0.27.0`) e o segundo `ENTRA` (`ds v0.40.0`), e a casca eu já uso desde
então. **Ledger que não registra o veredito faz o débito de adoção desaparecer junto.**

O `BoldPrazoDaPendencia` tinha dois sítios de espera em `neutral` + relógio à mão — exatamente o par que
`pending` existe pra dizer numa palavra. `pending` pinta igual à neutra nos dois modos de propósito (o
relógio é o estado; matiz competiria com as quatro famílias que julgam o desfecho), então **a troca não move
um pixel**: ela declara. `neutral` quer dizer *sem estado*, e pendência tem estado — ela está esperando.

Entrou junto o **gate da classe**, não dos dois sítios: nenhum estado de espera desta casa pode sair como
`neutral`. É o `espera_nao_e_atencao_test` do pai um nível abaixo, pegando a outra metade do defeito — ele
tinha o caso "pendente pintado de âmbar", e o meu era "pendente declarado sem estado". O contrato do
componente ganhou a Requirement que o gate cobra: espera `pending`, prazo curto `warning`, vencido `danger`.

Gates: DS analyze limpo e **125 testes** (1 novo) · catálogo limpo e **86**.

## [0.24.0] — 2026-08-04

### Recebeu — **o traço de home subiu 10,5px e o glifo da volta andou 20**, em cinco telas do board

`ds-diletta` **v0.46.0 → v0.47.0**. Nenhuma API muda; muda pixel em toda tela que desenha a barra de cima
ou a de baixo.

- **O traço de home** tinha `alignment: center` cancelando um `padding: bottom 8`: os dois valores se
  anulavam e o traço caía em `y 10,5` numa faixa de 34, quando o iOS e o desenho pedem **`y 21`** com 8 de
  folga embaixo.
- **O acessório esquerdo** (`.back`/`.close`) alinhava a CAIXA fora da margem e o glifo dentro dela. A regra
  ficou declarada: **o alvo de toque encosta na margem, o glifo centra dentro dele** — glifo em **44**, caixa
  de 40 (o `.close` também saiu de 32 pra 40). O título da barra anda ~11,5px como consequência.

### Mede — **posição, e não só contagem: 85 asserções minhas não sentiram nada**

Este repo tinha 85 asserções sobre o chrome e **nenhuma media onde a peça cai**. Duas coisas mudaram de
pixel em cinco telas e o verde não se mexeu — que é o mesmo defeito de cobertura que o pai achou no lado
dele, na forma mais silenciosa: **o número errado não existe.** O `8` estava certo desde sempre e nunca foi
aplicado, então varredura por valor, gate de token e auditoria de nome passariam batido.

Entrou em `as_telas_nao_duplicam_o_chrome_test.dart`, na tela que tem os dois: traço em **21**, folga **8**,
glifo da volta em **44**, caixa **40**. Rodado contra a `v0.46.0` antes de subir e reprovando com
`Expected: <21> Actual: <10.5>` — **controle, e não confiança.**

### Medido e NÃO adotado — o `DilettaInfoChip` denso

O pai deixou a promoção da variante densa (altura 20 em vez de 30) na mão de quem medir um segundo caso.
Medi: **`chipDeInfo` aparece em zero das 5 telas** deste board; as únicas citações no repo são o descritor
do catálogo. Não promove, pela régua que veio junto — *promove no caso medido, não no imaginado*.

## [0.23.0] — 2026-08-04

### Recebeu — **a dívida do aviso caiu no mesmo dia: 2,08 → 5,48:1, e o gate voltou a ser um só**

`ds-diletta` **v0.44.1 → v0.46.0**, e as duas coisas que eu pedi de manhã entraram: os cinco `onX` de
status **derivam** a tinta com piso de objeto gráfico, e o gate do spot dele passou a rodar com uma
**segunda paleta**.

No claro o glifo de aviso do `BoldResumoDaTransacao` sai do branco (`#FFFFFF`, 2,08:1) pro cinza de texto
(`#3D3939`, **5,48:1**) — o número exato que o pedido previu. O escuro não muda: 6,03 continua 6,03.

**A asserção de dívida que eu tinha escrito falhou, que era a única razão de ela existir**, e morreu. Os
quatro pares voltaram pra um laço só de 3:1, e entrou uma linha que mede a **causa** e não só a razão: a
tinta do claro não é mais `palette.white`. Sem ela, uma paleta de âmbar escuro passaria no piso com a
declaração de volta.

**O que a segunda paleta achou não era meu**, e é o que faz o pedido valer mais que o meu caso:
`outline · loading` reprovava em **2,81** no claro e **2,57** no escuro na paleta de exemplo que já morava
no repo do pai e nunca tinha sido medida pelo gate. Pedido que conserta o INSTRUMENTO segue pagando.

E o piso ficou em 3:1 por medição dele, não por conveniência: com 4,5 o âmbar da referência perderia o
branco de 3,51 (que passa como objeto gráfico) e ganharia **preto**, porque nem o cinza de texto alcança
4,5 nele. Piso alto demais troca a tinta de quem já estava legível. **Se este produto puser TEXTO sobre a
cor cheia de status, aí o piso é 4,5 e é meu** — derivo no call site.

### Recebeu — **`walletSolid`, que já embarcava no bundle deste pacote sem ter nome**

`ds v0.45.0`. O `.vec` do par sólido de `wallet-light` viajava aqui desde a v0.7.0: peso pago, símbolo
inexistente. A causa foi a **caixa da primeira letra** (`W` maiúsculo o jogou no balde de export cru), e o
gate que faltava media do nome pro arquivo — nunca do arquivo pro nome.

Aqui ele entra sozinho, porque o plugue declara `icones: DilettaIcons.all`. Saíram também 6 exports crus
do pai: **`grep` dos seis nomes neste repo deu zero**, como o aviso pediu que eu conferisse. `DilettaIcons.all`
e `assets/icons` agora são o mesmo número — **352**, e o comentário do gate do emitido que dizia 358 foi
corrigido com a fonte do lado.

## [0.22.0] — 2026-08-04

### Declarou — **a FORMA do CTA deste produto é 16, e agora ela é uma linha da paleta**

`ds-diletta` **v0.41.0 → v0.44.1**, e o que abriu a subida foi o veredito do pedido da forma: o botão do
pai era `pillAll` cravado, e adotar a casca de baixo dele (que exige o descritor, que exige o botão) viraria
**pílula em 55 telas** — redesenho, não integração. Entrou como `DilettaPalette.raioDeBotao`, campo de
paleta que o scheme deriva (`formaDoBotao`).

```dart
raioDeBotao: 16,   // nulo ⇒ pílula, que é o default dele
```

**Uma linha, num arquivo, e é o único lugar do produto que diz a forma** — pelo argumento que voltou como
regra dos dois lados: *a receita é do filho, a construção é do pai.* `borderRadius` no call site teria posto
a forma de volta no produto, 55 vezes.

O que o app vê: todo `DilettaButton` que este pacote monta passa de pílula a canto 16. `chatLift` **não**
obedece à declaração — a forma dele (24) é do desenho da variante, e o pai guarda os dois lados com teste.

### Recebeu — **o glifo do spot alcança 3:1 no escuro, e o conserto era de SEIS casos**

O pedido media um (`outline · primary`, 2,94:1 no escuro, com o dono do produto vendo antes de qualquer
medição). O gate que ele propôs achou cinco além dele, todos no `fill`, e três reprovavam no escuro.

Neste pacote quem muda de render é o `BoldResumoDaTransacao`: o glifo do spot no **escuro** passa de branco
a `onSuccess`/`onWarning` — **6,07:1** na concluída e **6,03:1** na agendada, contra os 2,x de branco sobre
verde e âmbar claros.

### Mede — **a subida trouxe um gate novo, e ele achou dívida do pai na primeira execução**

`test/a_forma_do_cta_e_o_glifo_do_spot_test.dart`: a declaração da forma medida **no render** (nenhuma
camada do botão ficou pill) e o par tinta/fundo do spot nos dois estados que a minha peça desenha.

No claro o aviso dá **2,08:1** — `onWarning` é `palette.white` pra qualquer paleta, e o âmbar desta marca
(`#F6A21A`) é claro. **Não é regressão**: o glifo já era branco antes, cravado. O gate do pai não podia ver
porque mede 28 pares com uma paleta só, a dele, cujo âmbar (`#B0810A`) segura branco em 3,51:1 — *o defeito
só existe com a paleta do filho.* Pedido aberto, e a asserção guarda o número de hoje: **ela falha no dia em
que ele consertar**, que é a diferença entre dívida e comentário.

### Corrigido — o gate do chrome do catálogo reprovava o render CERTO, desde a v0.16.0

`as_telas_nao_duplicam_o_chrome_test.dart` exigia uma `DilettaStatusBar` na home. Só que na v0.16.0 o
`cabecalhoDaHome` virou casca de **app real** (`DilettaTopAppBar.app`): inset da `SafeArea` no lugar do
relógio mock, e os dois relógios morreram junto. O certo na home é **zero** relógio.

**O achado maior é que ninguém viu**: `flutter test` no pacote do catálogo ficou sem rodar da v0.16.0 à
v0.21.0 — cinco tags com um gate vermelho. Gate que não se executa mede tanto quanto gate que não existe.

## [0.21.0] — 2026-08-04

### Mudou — **o avatar da home é 48, e o respiro dele 12**

Pedido do dono do produto olhando a home: *"o avatar na home tá menor e um pouco mais longe do Olá,
Nome"*. Era 40 com respiro 16 — os números do Redesenho v.01, desenhados antes de a linha ter foto.

48 cai na **mesma faixa de degrau** da inicial do pai (`heading` vale de 40 a 55), então o avatar cresce
e a letra dentro dele não muda de degrau: é ajuste de tamanho, não de tipografia. Medido antes de
escolher o número — 56 pularia pro `title` e mudaria a letra junto.

Os mesmos dois números estão no gêmeo que ainda vive no app (`BoldAvatarComSaudacao`), e mudar um sem o
outro é drift declarado: eles convergem quando o app adotar este componente.

## [0.20.0] — 2026-08-04

### Recebeu — **`ds v0.41.0`: quatro pedidos desta casa fecharam na mesma tag**

`ds-diletta` **v0.40.0 → v0.41.0**. Nada muda no código deste pacote, e é isso que faz a tag valer: os
quatro consertos são do pai, e chegam por herança.

| pedido | o que entrou |
|---|---|
| a aresta do vidro | `DilettaGlassSurface(aresta:)` — as duas linhas laterais da casca de topo somem em 102 telas |
| os seletores | radio, toggle **e checkbox** resolvem por papel; `palette.white` e a rampa crua saíram |
| o slot de ícones | `type` no `DilettaNavRightIcon`, default `secondary` |
| o descritor de CTA | `isLoading` no `DilettaNavigationAction` |

**Três correções que o veredito fez na minha medição, e eu registro as três:**

1 · **`DilettaButton.isLoading` já existia.** Eu medi o enum `DilettaButtonState` (`normal`, `error`) e
concluí sobre o botão — a espera nunca morou no enum. É o meu erro de família pela terceira vez na semana:
*contei um caminho de entrada e concluí sobre os dois*. O pedido virou metade do que eu pedi (só o campo no
descritor) porque a outra metade estava lá.

2 · **A aresta NÃO derivou de `borderRadius`**, que era a minha primeira ideia, e a razão foi a dúvida que eu
mesmo escrevi no pedido: *"eu não sei se a aresta interna é sempre a de BAIXO"*. Não é — a barra de baixo
separa por CIMA, e derivar acertaria as minhas 102 telas errando as quatro dele.

3 · **O polegar do toggle continua claro nos dois modos**, e um dos sete papéis que eu sugeri foi recusado
com medição: `surface` no escuro faria disco escuro sobre trilho escuro e mataria o relevo. O que mudou foi
de ONDE ele vem — do absoluto, não da rampa de marca.

**Ilha continua com as quatro arestas**: o `BoldSaldo` desta casa chama o vidro do pai com `borderRadius`, e
o pai ignora a `aresta` quando há radius. Medido antes de subir — o default novo é `nenhuma`, e sem essa
regra o cartão de saldo teria perdido o traço em silêncio.

## [0.19.0] — 2026-08-04

### Mudou — **`amostra` virou `fixo`, porque o segundo caso mostrou que o nome era do primeiro**

`BoldBackground.amostra` nasceu na v0.17.0 pro seletor de fundo. Uma hora depois, olhando o app, apareceu
o segundo caso do MESMO conceito: a tela de login declara `estilo: imagem` com a intenção escrita no
código dela — *"login sempre no fundo de cidade, independente da personalização de fundo escolhida pelo
usuário"* — e **desde a v0.4.0 ela não conseguia garantir isso.** Quem tinha um mood salvo via o mood no
login, e a tela de loading (que desenha a arte por outro caminho) ficava com fundo diferente da de login.
Foi o que o dono do produto viu: *"a tela de loading está com um bg diferente da tela de login"* e *"rosa
muito escuro no degradê"* — o rosa era o mood dele vencendo a cidade.

O conceito é um só: **o declarado vence a escolha.** `amostra` era o nome do primeiro caso, e nome de caso
vira nome errado no segundo. Renomeado com 1 call site — barato agora, caro depois.

**Migração**: `BoldBackground.amostra(...)` → `BoldBackground.fixo(...)`. Mesma assinatura, mesmo
comportamento. A v0.17.0 viveu uma hora e o único consumidor é o catálogo/app desta casa.

## [0.18.0] — 2026-08-04

### Consertou — **o brilho ganhava +30% no claro em cima da ARTE, e a razão era da base rosa**

Visto no app, no claro: *"o rosa do degradê tá muito forte, tem que ficar mais clarinho"*, com o brilho
de topo pintando por cima do skyline.

A saturação dos brilhos subia 30% em todo estilo no modo claro (`s.isDark ? 1.0 : 1.3`). A razão estava
escrita no comentário ao lado e é boa — **sobre a base `primary08`** os brilhos mesclavam com o conteúdo
e precisavam de corpo. Só que a condição na expressão não era a mesma do comentário: `imagem` assenta na
ARTE, não em `primary08`, e levava o boost sem ter o problema.

`k = (!isDark && fundo != imagem) ? 1.3 : 1.0`. Mood e sólido seguem com o corpo que precisam — os dois
assentam em `primary08` no claro; a arte volta a 1.0. A condição agora é a MESMA que escolhe a base, no
mesmo arquivo, e não uma paráfrase dela.

## [0.17.0] — 2026-08-04

### Consertou — **o seletor de fundo mostrava cinco vezes o fundo já escolhido**

Visto no app, não medido aqui. A tela de Aparência desenha as cinco opções de mood com
`BoldBackground(estilo: cada uma)`, e **as cinco desenhavam o fundo atual**: escolher outro mudava os
cinco quadradinhos juntos. Um seletor em que toda opção parece igual à atual.

A causa é a regra certa aplicada no lugar errado, e a regra é da v0.4.0: *a escolha da pessoa vence o
default da tela*. Isso está certo pra TELA — é o item 72 do QA, a Área Pix declarando `solido` e
perdendo pro fundo personalizado. E está errado pro SELETOR, onde cada quadradinho não é uma tela sob
a personalização: é o retrato de um mood ao lado dos outros quatro.

`BoldBackground.amostra(estilo:)` inverte a precedência, e é o único lugar que inverte. O `estilo` é
obrigatório nela — amostra sem mood declarado não tem o que retratar.

**Nenhum gate falhava, e não falharia**: cinco amostras concordando é um estado perfeitamente
consistente. O teste novo mede a amostra com um mood diferente no scope, e o CONTROLE ao lado mede que
a tela continua obedecendo a escolha — senão este conserto reintroduz o QA 72.

## [0.16.0] — 2026-08-04

### Consertou — **o cabeçalho da home desenhava DOIS RELÓGIOS no app real**

`ds-diletta` **v0.39.0 → v0.40.0**, e a tag é o veredito do pedido desta casa: `DilettaTopAppBar.app`
ganhou `conteudo`. Uma linha muda aqui, e ela é o defeito inteiro:

```diff
- child: DilettaTopAppBar.comConteudo(   // desenha DilettaStatusBar() — a MOCK 9:41
+ child: DilettaTopAppBar.app(           // inset REAL da SafeArea
```

O `BoldCabecalhoDaHome` monta em casca com **segunda linha**, e até a v0.40.0 a segunda linha só existia
nas variantes de status bar MOCK. Num app de verdade a mock empilha em cima da status bar do sistema: dois
relógios. **A peça de produto da home nascia inutilizável no próprio produto** — e foi essa a evidência
que fechou o pedido, nas palavras do pai: *"não é uma tela sua, é um componente seu que não podia ser
usado no seu app"*.

O `conteudo` não mudou. A gramática (a linha, depois o respiro de 8) é a mesma das duas variantes — o pai
a tirou da duplicata e pôs numa função só, então se o respiro mudar ele chega aqui sem eu saber que existe.

**O gate mudou de lado**: `o_cabecalho_da_home_test.dart` fixava `DilettaStatusBar` **presente**. Agora
mede a AUSÊNCIA, com controle na casca — senão o `findsNothing` também passaria se a casca inteira tivesse
sumido.

### Ainda de fora — as duas coisas que o veredito NÃO deu, e por quê

- **variante sem vidro** não existe porque a molécula é a versão sem vidro: `DilettaNavigationTopBar`
  direto, sem casca, é o degrau mais alto da escada e já estava lá. Registrado como 1º pedido no pai;
- **`.plain` não foi renomeado.** O nome dele quer dizer "sem status bar e sem SafeArea" e o meu quer
  dizer "sem vidro" — mesmo nome, eixo diferente. Uma quase-queda: o custo do rename cairia inteiro no
  filho que nunca se confundiu com o nome. Segundo tropeço e o nome muda.

## [0.15.0] — 2026-08-04

### Mudou — **`ds v0.39.0`, e o board passou a mostrar as TRÊS formas do divisor**

A tag do pai era pro filho A (padding do banner medido com régua contra o Figma), e nenhuma das duas
peças toca o app daqui. Mas uma delas me alcança: **`DilettaDivider.dashed()` ganhou palavra pública** —
era classe privada dentro de um card, e a razão que o pai escreveu é *"componente que existe e não tem
palavra pública não é vocabulário"*.

**A recíproca é minha, e é a mesma cobrança que ele já me fez na barra de baixo:** palavra pública que o
board não expõe também não é vocabulário pra quem monta tela aqui. Eu mostrava **1 de 3** formas. Agora
mostra as três (`linha`, `tracejado`, `vertical`) — o vertical entrou junto porque ele já existia e eu
também não mostrava.

**O que a união custou, e os gates cobraram os três:**

| gate | o que ele pegou |
|---|---|
| `bloco-sem-contrato` | união não tem `ctor`, então a derivação do contrato não alcança — entrou na lista de exceções, ao lado da casca de topo e do esqueleto |
| `bloco-sem-leitura` | a VOLTA quebrou: dois dos três emitidos não são `Ctor(args)` (um é construtor NOMEADO, o outro vem aninhado). Entrada manual no leitor, com `.dashed`/`.vertical` ANTES do liso — senão o prefixo casa os três e toda forma volta como linha |
| `o_emitido_compila` | eu emiti **`ds.SizedBox`**. O `SizedBox` é do Flutter, não do DS, e não existe em pacote nenhum. Sem este gate, montar um divisor vertical no board geraria código que não compila |

## [catalogo 0.15.0] — 2026-08-06

### Ganhou — **a aba de ADOÇÃO, e o inventário que ela mostra é do APP e não deste repo**

`diletta_catalog_core` **v0.85.1 → v0.86.0**, e é a entrega do pedido que esta casa escreveu hoje:
o catálogo tinha sete abas e nenhuma respondia *"quanto deste produto já é o DS"*. As sete descrevem
o que o DS TEM; nenhuma descrevia o que o produto ADOTOU.

**O veredito trouxe um número que eu não tinha**: o primeiro filho já mantinha uma aba `Integração`
de **997 linhas** à mão, com um `///` mandando *"mova o item de status aqui"*. Dois filhos, duas
telas, duas definições de "adotado" — e a regra de conhecimento é o que impedia cada um de ver o
outro. Só o pai podia, e é o trabalho dele.

O que subiu não é o meu desenho nem o dele: `adotado` (peça do DS **e a casca que delega**) ·
`lacuna` (+ `temParNoDs`) · `deliberado` (com razão obrigatória, senão não compila). Duas frases
minhas viraram `assert` do contrato: *exceção sem razão cresce em silêncio* ⇒ `deliberado` sem razão
não constrói; *peça morta é linha pra apagar, não linha de relatório* ⇒ **alcance 0 não constrói**.

### A conta é em ALCANCE, e a diferença é 6 pontos

O inventário do app, medido no código dele: **46 peças adotadas (690 arquivos de alcance) · 37
lacunas (436) · 1 deliberada (11, fora do denominador)**.

| conta | resultado |
|---|---|
| por ALCANCE (a do contrato) | **61,3% adotado** |
| por contagem de peça | 55,4% |

Seis pontos de diferença, e o motivo é o que faz a régua ser essa: `BoldTopBar` alcança 87 arquivos e
`BoldSummaryAction` alcança 1 — contar peça faz as duas pesarem igual.

### O inventário é GERADO, e essa foi a lição do veredito

A lista mora em `lib/adocao_do_bold.g.dart`, e o gerador é do app
(`dart run tool/inventario_de_adocao.dart`): a mesma varredura que o gate de adoção de lá usa, só
impressa no formato do motor. **O motor não mede nada** — varrer a fonte do app é do app, e isso era
metade do pedido.

Lista à mão é onde inventário e produto se separam em silêncio, e a prova estava no veredito: as 997
linhas do outro filho. O `medidoPor` viaja com o inventário pra que o número tenha a fonte ao lado.

## [0.14.0] — 2026-08-04

### Mudou — **o pai é a `v0.38.0`, e as 6 linhas que faltavam subiram**

`ds-diletta` **v0.37.0 → v0.38.0**. Nada muda neste pacote: o veredito é todo sobre o slot do MEIO da
linha de lista, que este pacote não usa. Quem consome a mudança é o app, e é por isso que esta entrada
existe — sem a tag, o app não alcança as três props.

**O que o pai deu, e o que eu tinha pedido errado:**

| eu pedi | o que entrou | por quê |
|---|---|---|
| `subtitleLoading: bool` | `subtitleLoading: bool` | igual — e a barra é DERIVADA (altura = degrau do subtítulo, largura = fração do slot, não pixel) |
| `subtitleMaxLines` / `maxLines` | os dois, default 1 | **e não era "um `bool`"**: os slots cravam `SizedBox(height: 72)`, então 10 linhas ESTOURAM em vez de crescer. Entrou a prop e entrou a consequência — a altura virou PISO quando o chamador abre |
| variante de COPIAR no slot direito | **fora** | *"o que você quer injetar não é um WIDGET, é um CALLBACK"* |

**A recusa do copiar é a minha própria fronteira, devolvida.** Eu ofereci duas formas e disse qual
preferia — uma variante que aceitasse "um componente do DS filho declarado". O pai citou a frase que eu
mesmo escrevi dois dias antes: *slot genérico faria qualquer coisa entrar numa linha de lista, e aí o
`sealed` deixaria de valer.* Variante que aceita componente declarado é a escotilha com nome melhor.

**E a minha medição da alternativa parou um passo antes do fim.** Eu medi que `RightAccessory.icon`
desenha e dispara, e concluí que perdia o retorno do "Copiada". Não perdia: o `DilettaToast` renderiza
inline e **quem decide quando ele aparece é o caller** — está no `///` dele desde sempre. O que restou do
`BoldCopiar` nos 2 sítios é uma FUNÇÃO de três linhas (copia, vibra, avisa), não um widget. `Clipboard` e
`HapticFeedback` não entram na linguagem, e o pai mediu: **zero arquivos dele tocam os dois.**

### Aberto — **o catálogo não mostra as três props novas**

O bloco `Lista de menu` do board emite `DilettaAppListRow.menuItem`, que não recebe `maxLines`,
`subtitleMaxLines` nem `subtitleLoading` — elas moram no `DilettaMiddleAccessory`, e o board não expõe o
acessório como bloco. **A linguagem cresceu e o board não acompanhou**, que é exatamente a classe de
deriva que o pai cobra nas COBRANÇAS dele. Não conserto aqui porque não é mecânico: ou nasce bloco novo
pro acessório do meio, ou a linha do board deixa de ser a fábrica de açúcar. É decisão, e vai num commit
com o número.

## [0.13.0] — 2026-08-03

### Corrigido — **a `v0.12.0` anunciou um pai que ela não consumia**

A entrada da `v0.12.0` e o README dizem `ds-diletta v0.36.0`; o `pubspec` dela diz **`v0.35.1`**. O `cd` de
um comando encadeado falhou, o `&&` engoliu a troca do `ref:` e o resto da corrente rodou como se tivesse
subido. **Tag é imutável, então o conserto mora aqui** — mesma forma que o pai usou quando a `v0.35.0` saiu
sem CHANGELOG.

A frase é dele, escrita hoje, e eu a repeti no mesmo dia: **`&&` não é gate.** A diferença entre nós dois é
só qual metade da corrente morreu.

O `ref:` foi de `v0.35.1` direto pra **`v0.37.0`**, então a `v0.36.0` (a foto no avatar) chega junto — nada
se perdeu, só chegou uma versão atrasado.

### Adicionado — a inicial do avatar é DEGRAU, e o círculo lê o material do produto

O veredito do pedido, e ele corrige a minha leitura antes de me dar razão:

- **a minha amostra era armadilha.** Eu li "15 nos dois tamanhos" como *constante*; 40 e 44 são vizinhos, e
  **qualquer escada dá o mesmo degrau pros dois**. O que a medição provava era mais estreito: 40 e 44 são o
  mesmo degrau;
- **e o defeito de verdade estava do lado dele**: `size * 0.4` num avatar de 44 dá **17,6**. *"Um DS que
  proíbe cor crua e CALCULA tamanho de fonte está sendo incoerente com a própria regra."* Saiu a fração,
  entrou uma escada de cinco degraus por diâmetro;
- **e uma correção na minha premissa**: 15 não é `labelMd` na escala do pai (lá `labelMd` é 12) — é
  `button`, que é papel de botão, não de identidade. Os 8 sítios perdem o `fontSize:` e ganham **16**, que
  é degrau (`heading`). O que muda de verdade é o que eu reclamei e não medi: **64 e 72 vão de 25,6/28,8
  pra 22**;
- **o avatar É card**, e o `cardDeVidro` que eu já declaro desde a `v0.9.0` resolve — **sem campo novo na
  paleta**. É a quinta peça da família e a primeira que a pergunta *"quais valores desta construção são do
  produto?"* responde sozinha: nenhum novo, faltava a peça ler o que já estava declarado.

Duas fronteiras que ele declarou junto, e as duas com o critério do `FeatureDetailCard`: **o `solid` não
vira vidro** (preenchimento de marca não é material) e **a foto também não** — vidro sob imagem opaca não
aparece e cobraria um `BackdropFilter` **por linha**, na linha que tem 186 usos aqui.

Gates: DS analyze limpo e **118 testes** · catálogo limpo e **85**.

## [0.12.0] — 2026-08-03

### Alterado — `ds-diletta` **v0.35.1 → v0.36.0**: o avatar aceita FOTO

`DilettaAvatar.image` (`ImageProvider?`, nulo ⇒ iniciais) e o mesmo pelo
`DilettaLeftAccessory.avatar(initials:, image:)`. É o que **destrava 10 dos 11** `LeftAccessory.custom` do
app — e com eles o `AppList`, que é **186 usos**.

Duas coisas do veredito que ficam registradas porque eu não teria escrito:

- **as iniciais NÃO ficam por baixo da foto.** Foto que não carrega mostra o círculo vazio, e círculo
  vazio é **sinal**: iniciais por baixo esconderiam a falha e ninguém distinguiria *"sem foto cadastrada"*
  de *"a foto não veio"*;
- **a escotilha que eu tinha medido não existia.** Eu comparei fábrica por fábrica e concluí que a
  linguagem era assimétrica (`custom` no `Right`, não no `Left`). Não era assimetria: **`.custom` não
  existe em slot nenhum** — eram três linhas de `///` prometendo uma API inexistente.

  > **Doc que promete API é pior que doc ausente.** Ausente manda perguntar; prometendo, você mede em cima
  > e planeja a adoção com uma peça que não está lá.

  Nada aqui muda por isso — o meu `.custom` é do app, não dele. O que muda é o método: **eu medi contra a
  doc e não contra o código**, e as duas discordavam.

### Registrado — as duas medições que o veredito pediu viraram pedido

- **o `fontSize` não diverge por ratio**: os 8 sítios passam **15 nos dois tamanhos** (40 e 44), enquanto
  40% dariam 16 e 17,6. Não é outra derivação — é a inicial sendo **texto de interface** (`labelMd`), e
  não glifo que escala com o círculo;
- **e o avatar deste produto é vidro** (`glass = true` por padrão): ele aparece na barra de topo, na linha
  de contato e no comprovante — sempre sobre a arte. É a **quinta** peça da mesma classe em dois dias, e
  por isso eu não pedi campo novo: ou o avatar é card (e o `cardDeVidro` que eu já declaro resolve), ou
  tem superfície própria. A fronteira é do pai, e eu já errei nela hoje.

**O `AppList` fica parado por causa disso** — é a única linha da classificação da B2 que muda de status
com esta versão.

Gates: DS analyze limpo e **118 testes** · catálogo limpo e **85**.

## [0.11.0] — 2026-08-03

### Adicionado — **o feixe**, e ele vem em PAR claro/escuro

`ds-diletta` **v0.34.0 → v0.35.1**, e o pedido voltou com as duas metades atendidas:

- **a varredura virou luz que atravessa**: três stops, pontas em alpha 0, banda de 0.36 da peça, e o `t`
  correndo de −0.18 a 1.18 pra o feixe **entrar e sair**. Antes eram dois stops com banda de 0.9 sobre alvo
  de largura 1 — cobria a peça inteira. A frase do veredito é a minha medição de volta: *"um banho que
  escorre, não uma luz que passa"*;
- **`brilhoDoEsqueletoClaro` + `brilhoDoEsqueletoEscuro`**, resolvidos por modo dentro do scheme.

**Aqui os dois rosas são diferentes, e o motivo é medido:**

| modo | fundo do esqueleto | cor declarada | pico medido |
|---|---|---|---|
| claro | cinza **217** | `primary07` (#FFB6CB) | `244,192,207` · R−G **52** |
| escuro | cinza **82** | `primary06` (#FF87AB) | `206,120,146` · R−G **86** |

Os dois abrem no mesmo **R (207)** — a diferença não é brilho, é **saturação**. Sobre o fundo escuro a cor
lavada perde o rosa e vira luz branca; o degrau mais forte mantém a leitura de *"luz ROSA passando"*, que é
o que foi pedido. Declarar o mesmo valor duas vezes seria pagar o campo e não usar o que ele resolve — e o
gate mede isso: os dois têm que ser **diferentes**.

### O gate ficou mais forte, porque agora existe forma pra medir

O pai tornou `feixeDoEsqueleto(scheme, t)` **público** com a razão escrita: forma que só vive dentro de um
`shaderCallback` não tem como ser medida — o callback devolve `Shader`, e `Shader` não conta stops.

Então o teste daqui mede as duas coisas em dois níveis:

- **a forma, onde ela é declarada**: três cores, pontas em alpha 0, centro acima de 0.5 e na cor da marca;
  e no instante 0 os stops se achatam na borda — o feixe ainda está entrando;
- **o resultado, em pixel**: o pico varre a peça (x=250 → 315 → 467 ao longo do ciclo) e some quando o feixe
  sai (R−G = 0 aos 900ms). Com o controle de sempre: sem shimmer, R−G = 0.

Gates: DS analyze limpo e **118 testes** · catálogo limpo e **85**.

## [0.10.2] — 2026-08-03

### Corrigido — os esqueletos que moram DENTRO deste pacote também precisavam do brilho

*"Estou olhando no app (carregar saldo por exemplo)"* — e é o caso exato que o conserto de ontem não
alcançou. Eu embrulhei os **35 esqueletos do app** e deixei os **4 que moram aqui**: três no `BoldSaldo` (o
valor e os dois selos de totais) e um no `BoldCabecalhoDaHome`.

São justamente os que aparecem primeiro: **a home abre no saldo.** Quem carrega o saldo vê estes, não
aqueles.

Nos totais é **um shimmer pro par**, e não um por selo: a varredura atravessa os dois como atravessaria o
conteúdo que vem no lugar deles. Dois wrappers dariam duas bandas fora de fase, que lê como dois
carregamentos independentes.

### O gate anterior media um lado da fronteira

O que eu tinha varria `lib/` do APP. Este pacote é o outro lado, e o mesmo defeito morava aqui —
**gate que mede um lado da fronteira acha metade do defeito.** Agora cada lado tem o seu, com a mesma
regra: todo `DilettaSkeleton` tem um `DilettaShimmer` acima.

E o gate de pixel ganhou o **controle** que faltava: sem shimmer o esqueleto sai `217,217,217` (R−G = 0);
com shimmer, `236,199,210` (R−G = 37). Sem essa metade, um `surfaceLoading` levemente quente passaria no
teste e eu concluiria que o brilho pinta quando ele não pinta nada.

Gates: DS analyze limpo e **117 testes** · catálogo limpo e **85**.

## [0.10.1] — 2026-08-03

### Corrigido — o bloco do esqueleto no board mostrava a FORMA sem o BRILHO

*"Shimmer ainda não apareceu"* — dito depois de o rosa entrar na paleta. A adoção do app já estava certa
(os 35 embrulhados), mas o **catálogo** não: o bloco `esqueleto` declarava só `DilettaSkeleton.box`, e a
forma do pai não anima sozinha — o `///` dele manda embrulhar num `DilettaShimmer`.

Então o board mostrava caixa cinza parada onde o app mostra a varredura. **Board que mostra a peça sem o
movimento dela ensina o movimento errado**, e o custo é literal: quem copia o código leva a caixa parada.

O bloco virou PAR, e isso teve três consequências que valem escritas:

- **saiu da tabela** (`ctor` fora): a tabela emite `nome: valor` num construtor só, e aninhamento de dois
  níveis não cabe. Mesmo caso da `barraDeBaixo` e da `cascaDeTopo`;
- **entrou no leitor à mão**: a volta lê `ds.DilettaShimmer` e tira as duas medidas do construtor de
  DENTRO, que é onde elas moram;
- **o contrato virou exceção declarada**: sem `ctor`, a derivação classe→slug não alcança, e o gate
  `bloco-sem-contrato` reprovou na hora. O contrato continua sendo o do pai (`design-system-skeleton`) —
  a spec dele fala das duas peças juntas.

Gate: o bloco renderizado tem **um `DilettaShimmer` e um `DilettaSkeleton`** na árvore.

Gates: catálogo analyze limpo e **85 testes** · DS **116**.

## [0.10.0] — 2026-08-03

### Adicionado — **o brilho do esqueleto é da MARCA**, e a leitura valeu mais que o campo

`ds-diletta` **v0.33.0 → v0.34.0**, e uma linha na paleta: `brilhoDoEsqueleto: BoldColors.primary07`. O rosa
volta nos **35 esqueletos** de uma vez.

O relato que abriu isto foi *"o skeleton tem um shimmer rosinha, agora só é o frame cinza"* — e o veredito
diz o que fecha o argumento melhor do que a contagem: **ele reconheceu a marca pela ausência dela.** O
esqueleto é a primeira coisa que toda tela que espera dado mostra: o momento com menos conteúdo e mais
identidade por pixel.

**O que NÃO virou declaração, e a razão fica:** o alpha da banda. Ele é a FORMA da varredura — entra e sai —,
não a identidade. A frase do pai é o limite da regra inteira:

> **Material se declara; estado não.**

E ela nasceu de uma medição dele: são **27 alphas cravados** nos componentes do pacote, a maioria de estado
(pressionado, desabilitado). Uma regra que acusasse os 27 seria a que ensina a ignorar a lista.

### A observação que eu mandei como "não é pedido" virou peça do contrato

Eu tinha escrito, no fim do pedido, que talvez faltasse **a pergunta feita uma vez** — *quais valores desta
construção são do produto?* — em vez do terceiro campo. Ela virou `DilettaPalette.camposDeMaterial` (os
sete, numa lista) e a seção **1a** do `O-QUE-O-FILHO-FORNECE`, com o que cada campo decide e o que o nulo
faz. É o que um filho lê na primeira hora em vez de descobrir um por dia — que foi o meu custo nestes dois
dias.

Com gate na LIMPA (`6b · material sem linha na doc`), e a razão de estar lá e não no pacote é a que eu
conheço de perto: teste que lê `docs/` de dentro do pacote não viaja na cópia que o filho recebe.

### O gate daqui mede a declaração E o pixel

Declarar sem pintar é meia adoção — foi assim no vidro. O teste novo desenha o esqueleto sobre fundo neutro
escuro, varre a faixa do meio e exige que a banda mais forte tenha **R−G > 12**: neutro daria R≈G. É o que
distingue *"brilha"* de *"brilha com a cor de alguém"*.

Gates: DS analyze limpo e **116 testes** (2 novos) · catálogo limpo e **84**.

## [0.9.4] — 2026-08-03

### Corrigido — **os ícones do pai não apareciam no app**, e a linha que faltava é uma

Chegou do simulador: *"as setas de voltar, os ícones da home, o `>` do extrato"* — todos sumidos ao mesmo
tempo, depois de a adoção trocar componentes do app por componentes do pai. **Nada falhou**: nem `analyze`,
nem os 414 testes do app, nem o console.

A mecânica: `DilettaIcon` desenha com `VectorGraphic(loader: AssetBytesLoader(path, packageName:))`, e
`DilettaAssets.assetPackage` nasce `null` — que significa *"assets na raiz do bundle"*. Num app que CONSOME
o pacote eles moram em `packages/diletta_design_system/…`, então o loader procura no lugar errado. E
**`VectorGraphic` com asset ausente não estoura: desenha caixa vazia.**

A linha entrou no `BoldTheme`, no primeiro acesso ao tema, e **não no `main` do app**:

> Quem liga o DS é quem sabe onde o DS guarda coisa.

É a mesma razão que o catálogo escreveu no plugue dele quando os 358 ícones dele estavam invisíveis. No
`main` isso vira uma linha que todo app novo precisa lembrar de copiar — o primeiro filho resolveu no `main`
do catálogo dele e tem o mesmo buraco do lado do app.

Não existe caminho que desenhe componente do pai sem passar por `BoldTheme.light`/`dark`: o
`DilettaThemeScope` é obrigatório pra qualquer um deles. E é `??=`, então quem hospeda os ícones em outro
pacote (o contrato do pai prevê) continua mandando — tem teste pra isso.

Gates: DS analyze limpo e **114 testes** (3 novos) · catálogo limpo e **84**.

## [0.9.3] — 2026-08-03

### Alterado — `ds-diletta` **v0.32.0 → v0.33.0**: o cartão de destaque também é vidro

O quarto card entrou. O dono do produto viu o "Conta PJ" sólido ao lado de duas listas em vidro no catálogo
publicado, e o veredito veio com o que eu tinha pedido — **um conserto e uma razão**:

- **`DilettaFeatureCard` ENTRA.** O pai foi direto ao ponto sobre por que ele tinha ficado de fora: *"eu fui
  pela lista de quatro que você mediu, em vez de varrer a minha própria pasta"*. A minha lista estava certa
  sobre o que cobria; o buraco era ela não ser a varredura dele;
- **`DilettaFeatureDetailCard` NÃO entra, e a razão está escrita**: a superfície dele é **gradiente de
  marca**, e vidro descartaria a marca em silêncio — mesmo critério do `NoticeBanner`. O `if (isDark)` que eu
  li como sintoma da falta de vidro é outra coisa: **assimetria de paleta** (o `primary09` não tem papel no
  escuro). Se incomodar, é outro pedido, e ele já tem um caso medido.

E o **gate inverso que eu sugeri entrou como eu desenhei**: todo widget de card monta pelo `CardSurface` ou
está numa lista com o motivo escrito — seis exceções, cada uma com a razão no código. Ele acrescentou duas
asserções que eu não pedi e que a minha própria frase exigia: **exceção pra arquivo que não existe mais
falha**, e **motivo curto demais falha** (a segunda já o pegou).

### O meu gate de pixel passou a medir os QUATRO, um por um

`findsWidgets` no conjunto passaria com três de quatro — que é exatamente o defeito desta rodada. Agora cada
um é medido dentro do próprio tipo:

```dart
for (final tipo in [DilettaEmptyState, DilettaQuickAccessCard, DilettaFeatureCard])
  expect(find.descendant(of: find.byType(tipo), matching: find.byType(BackdropFilter)), findsWidgets);
```

**Eu não escrevi uma linha de material**: a declaração é `cardDeVidro: true` desde a `v0.9.0`, e o que
faltava era a peça ler. É a melhor prova de que a fronteira ficou no lugar certo.

Gates: DS analyze limpo e **111 testes** · catálogo limpo e **84**.

## [0.9.2] — 2026-08-03

### Adicionado — **a versão da build no título da aba**, e ela existe por um defeito de duas horas

Dois prints seguidos do dono do produto eram de **bundle velho** — o navegador servia cache de um service
worker registrado ANTES de eu tirar o service worker, e SW já registrado continua servindo o que tem. Cada
print custou uma volta pra descobrir qual build estava na tela, e **não havia como saber olhando**.

Agora a aba diz: `Conta BOLD · DS Catalog v0.9.2`. O valor sai do `pubspec` por `--dart-define` no
`build_web.sh`, então ele não é digitado no Dart e não pode divergir. Num `flutter run` (sem o define) o
título fica o de sempre, em vez de dizer "vazio".

**E o servidor mudou de porta: 8081.** Service worker é registrado por ORIGEM (host + porta), então porta
nova é origem limpa. O 8080 foi derrubado — origem que serve bundle velho e não tem como se corrigir sozinha
é pior que origem que não responde.

### Adicionado — o gate do vidro passou a medir **PIXEL**, e não tipo de widget

Os dois prints discutiram material olhando, e olhar não decide: vidro sobre fundo claro parece branco, e
branco chapado também. O teste novo desenha o card sobre um azul forte, lê o `RepaintBoundary` e compara dois
pixels — um dentro do card, um fora:

- **dentro**, o canal B tem que estar >20 acima do R: o azul de trás ATRAVESSA o tinte branco@50%. Fill
  daria R≈G≈B;
- e o R tem que passar de 60, senão não há tinte nenhum — seria o fundo cru.

Um detalhe que custou dez minutos de timeout e vale escrito: **`toImage()` precisa de `runAsync`**. Fora
dele o relógio do teste é falso e a codificação — que é assíncrona de verdade — nunca completa.

Gates: DS analyze limpo e **111 testes** · catálogo limpo e **84**.

## [0.9.1] — 2026-08-03

### Alterado — as duas listas da home são CARD, e o print que pediu isso era de um bundle velho

O dono do produto mandou print dizendo *"o card ainda tá fill"*. Medi antes de mexer, e o print **não era da
build atual**: ele mostrava o rodapé com o CTA rosa "Continuar", que só existia até a `v0.8.0` — de lá pra cá
a home mostra a barra de abas. O navegador dele estava servindo bundle em cache por um **service worker
registrado antes** de eu tirar o service worker: a remoção só vale pra quem carrega a página de novo, e um SW
já registrado continua servindo o que tem.

O que a build atual desenha, medido na árvore em vez de no olho: **1 `DilettaCardSurface`** e **4
`BackdropFilter`** na home (o saldo, a casca de topo, a barra de abas e o card de lista). O card É vidro.

E o print mostrou uma coisa REAL: a lista de ATALHOS não tinha card nenhum (`idioma: menu` desenha rows
soltas), então ela e a lista de baixo apareciam com materiais diferentes na mesma tela. As duas passaram a ser
`carded` — no app aquela seção é uma grade de cartões de vidro, e duas listas com materiais diferentes lado a
lado é pior que as duas erradas iguais.

**Como eu passei a servir**: porta **8081**. Service worker é registrado por ORIGEM (host + porta), então
porta nova é origem limpa — nenhum SW velho pra brigar. Custa uma linha no comando e economiza a explicação de
como desregistrar SW no DevTools.

Gates: catálogo analyze limpo e **84 testes** · DS **110**.

## [0.9.0] — 2026-08-03

### Adicionado — **o card de conteúdo é VIDRO**, e são seis versões do pai num `ref:`

`ds-diletta` **v0.26.0 → v0.32.0**, e as duas pontas são os vereditos dos meus pedidos de hoje.

**`cardDeVidro: true` na `BoldPalette.bold`** — uma linha, e ela fecha o defeito que o dono do produto viu
no board: *"o fundo nos cards (lista) também é glassy e eles estão solid"*. Converte três peças do
vocabulário de uma vez: `AppList.carded`, `EmptyState` e `QuickAccessCard`.

O veredito veio pela forma que eu tinha pedido, e o argumento dele corrige o meu enquadramento:

> *"não é falta de parâmetro, é uma **fronteira desenhada errado**"* — dos 4 arquivos do pai que usavam o
> vidro, os 4 eram chrome. A construção já era dele; o vocabulário só a oferecia pra barra.

O gate mede as **duas** metades, porque declarar sem renderizar é meia adoção: a paleta declara, e o card
desenha `BackdropFilter` nos dois modos. Cor com alpha passaria no olho e não desfoca nada — foi o argumento
que descartou "pintar por cima" quando eu pedi.

### Removido — o CONTORNO do gate de chrome, porque o pai apagou a cópia

O outro veredito (`ds v0.31.0`) foi **deleção**: a `DilettaNav` desenhava o traço de home num
`_NavHomeIndicator` privado, e agora usa o público. Então o meu `expect` voltou a contar a peça em vez de
contar quem-desenha:

```diff
- final tracos = find.byType(DilettaBottomHomeIndicator).evaluate().length +
-     find.byType(DilettaNav).evaluate().length;         // contorno: classe privada não se referencia
+ expect(find.byType(DilettaBottomHomeIndicator), findsOneWidget);
```

A medição dele achou uma **segunda** cópia que eu não tinha como ver (`DilettaKeyboardIndicator`, pública,
existindo só pra pôr um fundo que o público já aceita por parâmetro). Contorno que sai depois do conserto é
contorno que estava no lugar certo.

### Sobre as outras quatro versões do caminho

`v0.27.0` (`StatusTone.pending`) · `v0.28.0` e `v0.29.0` (as carteiras de sistema, com **quebra declarada**
na marca de par) · `v0.30.0` (arte de carteira por extensão). **Nenhuma me custou linha**: `grep` de
`Wallet`/`carteira` neste repo devolve zero — a quebra não me alcança porque eu não uso a peça. O caminho
passou por ela, e é isso que faz seis versões caberem num `ref:`.

Gates: DS analyze limpo e **110 testes** (3 novos, os do vidro) · catálogo limpo e **84**.

## [0.8.1] — 2026-08-03

### A LIMPA rodou, e o conserto foi de PROTOCOLO, não de conteúdo

136 símbolos fantasma na primeira execução. O que a triagem mostrou:

- **83 dos 136 eram nome que mora no `app-newbold`.** A limpa aceita repo irmão no corpo de leitura
  (`faz_a_limpa.py . ../app-newbold`), e sem ele o registro da adoção — que fala dos componentes do app por
  nome — enche a lista de ruído. **O comando com o irmão está no README**, porque ferramenta que só funciona
  certo quando alguém lembra do segundo argumento é ferramenta que vai rodar errado;
- **os 53 restantes eram quase todos nome que a adoção APAGOU hoje** (`BoldSkeleton`, `BoldCheckbox`,
  `BoldQuantumSeal`…). Eles ficam: são o "de onde" da tabela de migração, e apagá-los deixaria a tabela
  dizendo de onde para onde sem o de onde;
- **e o conserto certo era o NOME DO ARQUIVO.** A regra é do pai (`ds v0.25.2`): número ou nome que registra
  uma medição passada quer a isenção, e a isenção vem de o arquivo começar com a data. Dois viraram isso:
  `ADOCAO.md` → `2026-07-29-adocao-do-ds-do-bold.md`, e `PARITY_BOLD.md` →
  `docs/2026-07-30-paridade-do-ds-app-x-catalogo.md` (esse já se declarava história no corpo desde 30/07, e
  seguia na raiz sem a isenção).

Fantasmas **136 → 6**, números afirmados **4 → 0**, links quebrados 0, md órfão 0. Os 6 que sobram são
palavra de configuração em backtick no doc de deploy (`whoami`, `_redirects`, `not_found_handling`) — falso
positivo por natureza, e é o que a doc da ferramenta prevê.

O registro da adoção ganhou no topo o **ESTADO de 03/08**: o plano rodou, 23 arquivos saíram de
`lib/design_system/widgets/` do app, e as contagens dele são de 29/07 e não se corrigem.

### Registrado — os dois pedidos de hoje voltaram com veredito

| pedido | veredito | chega em |
|---|---|---|
| o card de conteúdo não sabe ser vidro | **ENTRA pela resposta 1** — `cardDeVidro` no scheme, e `DilettaCardSurface` monta os dois materiais | `ds v0.32.0` |
| o traço de home da nav é uma cópia privada | **ENTRA como deleção** — e a medição dele achou uma SEGUNDA cópia (`DilettaKeyboardIndicator`) | `ds v0.31.0` |

**Nenhum dos dois está adotado aqui**: eu consumo `ds v0.26.0`, e o caminho até a v0.32.0 passa por uma
quebra declarada (a marca de carteira, v0.29.0). É o próximo ciclo, e o ledger diz isso em vez de deixar a
linha vazia.

Uma frase do veredito do vidro que vale guardar, porque ela corrige o meu enquadramento: *"não é falta de
parâmetro, é uma **fronteira desenhada errado**"*. E uma correção de número minha: são **três** componentes
convertidos, não quatro — o `DilettaReceipt` não tem card, as duas ocorrências de `bg` que eu contei são o
spot e a caixa do rodapé.

Gates: catálogo analyze limpo e **84 testes** · DS **107**.

## [0.8.0] — 2026-08-03

### Corrigido — **27 dos 56 blocos não diziam o nome da peça da linguagem**

Cobrança do pai (motor `v0.77.0`, regra `nome-fora-da-linguagem`), e a medição dele é o argumento inteiro:
27 blocos meus contra 4 do outro filho. A frase do dono do produto que gerou a regra:

> *"topbar e bottom bar por exemplo não estão lá e eu não sei dizer qual o novo nome porque eu nunca escolhi
> outro nome pra eles! icon, applist, tudo deve se manter, porque senão vou ter que aprender coisas que eu
> nem sei quais e quantas são."*

**"Nem sei quais e quantas são" tinha número: 27.** O rótulo agora traz o nome da linguagem AO LADO do nome
de produto — `Lista · AppList`, `Barra de baixo · BottomApp`, `Casca de topo · TopAppBar`, `Campo de texto ·
Input`, `Selo de status · StatusTag`. O português fica; o que não podia ficar é o nome da linguagem não
existir em lugar nenhum.

**Dois entraram sem a regra pedir**: `lista` e `icone` passavam por ACIDENTE (`List` é sufixo de `AppList` e
cabe dentro de "lista"; `Icon` cabe dentro de "icone"). Passar por acidente não é dizer o nome — e as duas
palavras que o dono citou por escrito foram justamente `applist` e `icon`.

### Adicionado — a barra de baixo expõe as **cinco** variantes, e era uma

`DilettaBottomApp` tem sete factories; eu expunha só a `.button`. O dono escolheu as cinco sem chat, e a
razão é a regra deste registro — variante que produto nenhum usa é desenho especulativo:

`defaultVariant` · `nav` · `button` · `keyboard` · `buttonAndKeyboard`

- **um bloco de UNIÃO, não cinco tipos**: a peça do pai é uma só, e cinco tipos na paleta obrigariam quem
  procura "barra de baixo" a escolher antes de ver;
- **`visibleProps` é o que faz a união não virar ruído**: `label`/`labelSecundario` só nas duas com botão,
  `abas`/`abaAtiva` só na `nav`, e só `variante` nas outras duas. Prop que não faz nada é prop que ensina
  errado;
- **e a `nav` fechou um buraco declarado ontem**: a home do board mostrava uma barra de CTA "Continuar"
  porque era a única variante que existia. Agora mostra as abas, com os três itens que o app tem de verdade
  (`Início`, `Câmera`, `Lia`).

### Achado — declarar a variante encontrou um defeito **do pai**, e virou pedido

O gate de chrome conta `DilettaBottomHomeIndicator` e exige um. Na `.nav` ele achou **zero**, com o traço
desenhado na tela: a `DilettaNav` usa um `_NavHomeIndicator` **privado**, cópia linha por linha do público —
e sem as três regras dele: recolher com teclado aberto, **não desenhar pill fake em device real**, e o
`DilettaDevInfo`. As duas primeiras são comportamento de aparelho, e o comentário do próprio público promete
*"robusto p/ toda variante do BottomApp"*.

Pedido aberto (`docs/pedidos/2026-08-03-o-traco-de-home-da-nav-e-uma-copia-privada.md`); o conserto que eu
peço é deleção. Do meu lado o gate passou a contar `DilettaBottomHomeIndicator` + `DilettaNav`, que é o que
sobrevive às duas formas.

> **Enquanto eu expunha 1 das 7, a `.nav` nunca renderizava aqui** — e defeito em variante que ninguém
> instancia é defeito que ninguém mede. Cobertura de variante não era conveniência de editor.

**Minor**: nada muda pra quem consome o DS. O que mudou é a paleta do editor e as telas do board.

Gates: catálogo analyze limpo e **84 testes** · DS **107**.

## [0.7.2] — 2026-08-03

### Corrigido — as telas do board não tinham `specId`, e por isso metade dos botões ficava muda

Segundo relato do mesmo clique: o editor não abriu, e o **Anotar** respondeu *"Selecione uma tela
spec-first pra anotar"*. A frase é do motor e está certa — a nota se guarda por SLUG, e o board lê o slug
do `specId` da tela.

Eu montava as telas do board com `handoffFromSpec(spec)`, que é o helper para tela **publicada do
compositor**: ele põe a spec inline e um `child` renderizado na hora, e não tem como saber a chave da tela
na fonte. Para tela que mora no repo, o certo é o que o primeiro filho faz — `HandoffScreen(label:,
caption:, specId:)`, e nada mais:

- **`specId` é a chave na FONTE.** Sem ele ficam mudos o anotar, o status e o "salvar no repo", que precisa
  saber qual das cinco entradas do `screen_specs.g.dart` a edição substitui;
- **e o `child` era pior que inútil**: ele é um SNAPSHOT do render feito quando a lista de grupos é
  montada, e o preview prefere o `child` à spec. Tela spec-first não tem mock — ela renderiza a fonte, que
  é o que faz o board mostrar o que o arquivo diz.

O gate mede as duas metades: toda tela do board tem `specId`, o `specId` existe em
`Conteudo.especificacoes`, nenhuma tem mock, e a contagem do board é igual à da fonte.

### Corrigido — o build web não tem mais service worker

`--pwa-strategy=none` no `build_web.sh`. O service worker servia o bundle em cache depois de um rebuild, e
isso custou uma volta inteira nesta sessão: o conserto do "editar tela" estava no disco, e o navegador
continuava executando o bundle velho. **Quem está do outro lado conclui que o conserto não funcionou, e
não que ele não chegou.**

Num catálogo que é ferramenta o offline não paga nada, e o Flutter já deprecou o próprio service worker —
o `index.html` gerado diz isso em comentário. O arquivo velho foi apagado do `build/web`: cliente que
ainda tenha o SW registrado recebe 404 na checagem e o larga.

Gates: catálogo analyze limpo e **84 testes** · DS **107**.

## [0.7.1] — 2026-08-03

### Corrigido — o **"✎ Editar tela" era um botão morto**, e faltava o fio no meio

Achado clicando, não lendo: o dono do produto abriu a aba Telas, clicou em editar e **nada aconteceu**.
Nenhum erro, nada no console, nenhuma aba trocada — o pior modo de falhar que existe.

As duas metades estavam prontas desde sempre:

- o board do pai faz a parte dele: `ComposerInbox.requestEditSpec` guarda a tela e chama `openBuilder`;
- `openBuilder` é gancho da **casca do filho**, e com razão — quem sabe o id da aba do compositor é quem
  declara as abas. Eu nunca o pluguei, e nunca declarei `navegacao:` no `CatalogoConfig`. A caixa de
  entrada do compositor enchia em silêncio.

Entraram as duas linhas que faltavam: `final nav = NavegacaoDoCatalogo()` + `navegacao: nav` na config, e
`ComposerInbox.instance.openBuilder = () => nav.abrir('montar')`.

> É a MESMA classe dos 6 campos calados do plugue de conteúdo, um nível acima: **capacidade pronta nos dois
> lados e sem o fio no meio.** A `v0.7.0` declarou o alvo e o transporte; sem esta, não havia como chegar
> na tela pra editar.

### O gate mede o fio de ponta a ponta

`o_editar_tela_abre_o_compositor_test` — pede a edição pelo mesmo canal que o board usa
(`requestEditSpec` com a spec da home) e exige quatro coisas: que a config declare o canal, que o gancho
esteja plugado, que o destino pedido seja **uma aba que existe** (`'montar'`, e o id vem da lista de abas,
não de uma string solta) e que a tela chegue na caixa como SPEC — por código abriria um bloco sem preview.
Mais um controle que reprova de propósito.

Gates: catálogo analyze limpo e **83 testes** · DS **107**.

## [0.7.0] — 2026-08-03

### Adicionado — **editar tela no compositor e SALVAR NO REPO**, e o arquivo virou dois

O motor foi pra `v0.76.0` e o pai fechou o transporte do "salvar no repo" (o servidor de autoria agora
viaja no pacote dele). Faltavam os três degraus deste lado, e o terceiro era decisão minha:

- **os dois alvos, declarados** no `PlugueDeConteudo`: `caminhoDoArquivoDeSpecs`
  (`lib/builder/screen_specs.g.dart`), `caminhoDoArquivoDeLigacoes` (`lib/builder/ligacoes.g.dart`) e o
  `importDoTipoDeLigacao`. Eu tinha declarado 5 dos 11 campos do plugue porque a doc dele listava 5 — e os
  6 calados eram justamente os da edição. **Doc que cala custa o mesmo que doc que mente**;
- **o transporte documentado no README**, com o comando e os dois `--permite`. Ele é a única peça que fala
  com quem roda o servidor, e o servidor **não lê o Dart**;
- **o arquivo partiu em dois, por PAPEL**. O motor gera o alvo por inteiro a partir do estado, então
  apontar pro `telas_do_bold.dart` apagaria as 490 linhas de prosa na primeira gravação. Agora:
  **a fonte** é `screen_specs.g.dart` (`especificacoes: kScreenSpecsJson`, e `telasDoBold()` decodifica
  com `decodeSpecCom(registro: Ds.blocos)`), e **o registro** é o `telas_do_bold.dart` de 168 linhas — os
  cinco slugs, cada um com a razão da tela dele. Nada do registro é lido pelo board, e é de propósito.

  > As duas coisas viviam no mesmo arquivo **porque só havia um**. Quando apareceu o segundo, ficou claro
  > que a prosa nunca foi a fonte — ela é o que sobra quando a fonte é gerada.

- **os 12 gates não mudaram de forma, mudaram de fonte**: quem chamava `telasDoBold()` continua chamando.

### Adicionado — o gate da dívida que o PAI declarou como dele

`os_alvos_de_autoria_test`, 5 casos. Ele escreveu: *"nada me avisa se você apontar o caminho pra um arquivo
escrito à mão"* — e está certo em não medir, porque **quais arquivos são gerados aqui é conhecimento
daqui**:

- os dois caminhos declarados existem e começam com `// GERADO`;
- o conteúdo é **função pura do estado**: decodifica, codifica de volta com as funções do pai, e exige
  igualdade **byte a byte**. Arquivo editado à mão não sobrevive — nem uma vírgula. É o mais perto de um
  parser de Dart que dá pra chegar sem ter um;
- e o pareamento README ⇄ Dart, porque os `--permite` do servidor e os caminhos do plugue vivem em lugares
  diferentes. Divergir ali dá **403 sem explicação** no salvar, que é o modo de falhar que a release do pai
  descreve.

**Minor**: nada muda pra quem consome o DS. O que mudou é como o catálogo é autorado.

Gates: DS analyze limpo e **107 testes** · catálogo limpo e **81**.

## [0.6.2] — 2026-08-03

### Corrigido — **o board desenhava o chrome DUAS VEZES**, e o CTA flutuava fora da barra

Três defeitos no mesmo print da aba Telas, mandado por quem estava olhando o board. Os três são spec
minha pedindo peça que a casca do pai já traz:

- **dois relógios de 9:41 empilhados.** As cinco telas declaravam `barraDeStatus` no `top`, e
  `DilettaTopAppBar.defaultVariant`/`.comConteudo` compõem `DilettaStatusBar` por dentro. O bloco saiu
  das cinco;
- **o CTA solto no `bottom`.** Três telas de fluxo declaravam `botao` direto na região de baixo: no
  aparelho ele flutuava sobre a arte, sem o vidro que separa ação de conteúdo, e com o traço de home
  logo abaixo. Agora é `barraDeBaixo` com `label` (+ `labelSecundario`), que é o que o app faz —
  `BoldBottomApp.button`. De graça, o empilhamento dos dois CTAs virou o do pai (gap 12) em vez do meu;
- **dois traços de home.** `indicadorDeHome` declarado ao lado da barra, e **toda** variante de
  `DilettaBottomApp` termina em `DilettaBottomHomeIndicator`.

A regra que sai: *quem declara a casca não declara o chrome que ela traz.* Os dois blocos continuam no
vocabulário pra tela sem casca — o que estava errado era a coexistência.

### Corrigido — **`gatilhosDeSaida` estava VAZIO**, e as setas diziam "gatilho não documentado"

- O terceiro rótulo vermelho do mesmo print, e o de causa mais distante: sem critério de gatilho no
  plugue, o motor não tem como ancorar a seta num componente — ela sai da borda do frame e o board
  **escreve a falta**. Degradação honesta dele, falta minha;
- entraram quatro critérios, na ordem da hierarquia de ação deste produto: `barraDeBaixo` (rótulo = o
  label do botão), `botao`, `cartaoDeAcesso` e `linha` (rótulo = o título). A linha é a última porque a
  saída da HOME é o item "Pix" da lista, não um CTA;
- os ids das setas declaradas **andaram** com a troca (`b_8`→`b_7`, `b_12`→`b_11`), e quem cobrou foi o
  gate que DERIVA o CTA em vez de repetir o id. É a razão de ele existir.

### O gate novo mede na spec E na árvore

`as_telas_nao_duplicam_o_chrome_test` — 10 casos. Três na spec (nenhuma tela declara `barraDeStatus`
junto de casca, nem `indicadorDeHome` junto de barra, nem `botao` no `bottom`), um de gatilho, cinco
**renderizando cada tela e CONTANDO** `DilettaStatusBar` e `DilettaBottomHomeIndicator` — um de cada —,
e um controle que reprova de propósito. A contagem na árvore é a que fecha a porta: se a casca do pai
mudar de forma, o defeito aparece aqui e não num print.

**Patch**: nada muda pra quem consome o DS. O que mudou é o catálogo — spec de tela, plugue e gate.

Gates: DS analyze limpo e **107 testes** · catálogo limpo e **71**.

## [0.6.1] — 2026-08-03

### Corrigido — o número da `v0.6.0` era **10** e são **9**

- A doc do próprio widget virava consumidor no `grep`: `BoldMoneyInputFormatter.parse` aparecia dez
  vezes em `lib/` + `test/` do app, e uma delas era o exemplo dentro do arquivo que eu estava
  apagando. Nove são chamada de produto;
- corrigido nos três lugares que afirmavam o presente (entrada da `v0.6.0`, `ADOCAO.md`, doc de
  `emReais`). **Só doc**: nenhuma linha de código mudou, e quem está na `v0.6.0` não precisa subir
  por causa disto;
- registrado em vez de apagado porque é a MESMA classe de erro das duas pontas desta história —
  contar o próprio exemplo como uso é o espelho de contar o próprio teste como uso, que foi a
  justificativa da remoção em julho.

## [0.6.0] — 2026-08-03

### Corrigido — **o copiar tinha perdido o haptic**, e nada na tela dizia isso

- A adaptação de `BoldCopyButton` → `BoldCopiar` deixou cair
  `HapticFeedback.selectionClick()`, e a doc do componente listou quatro mudanças sem citar esta.
  **Era a única chamada de `HapticFeedback` do app inteiro** (`grep`: 1 ocorrência, nesse widget);
- copiar não muda nada na tela além de um aviso de 1.8s **atrás do dedo** — sem o retorno tátil,
  quem copiou com o polegar em cima do ícone não sabe se copiou. Defeito que só o dedo percebe é
  defeito que nenhum golden pega;
- o gate agora é o dedo: `o toque VIBRA` espiona `SystemChannels.platform` e exige
  `HapticFeedback.vibrate` depois do toque. **Fica no filho e não sobe pro pai**: o DS pai tem zero
  haptics, e um caso não vira família — é a mesma régua que a `ds v0.25.1` usou pro `info`.

### Adicionado — **`BoldDinheiro.emReais`** volta, e a medição que a tirou estava errada

- Ela saiu na auditoria com a justificativa *"zero consumidor — os campos de dinheiro guardam
  `_cents` (int)"*. Isso vale pro campo de valor GRANDE. Os campos **bordados** leem o texto do
  controller de volta, e são **9 pontos de uso** no app: a tela de valor do Pix, os quatro
  acréscimos da cobrança com vencimento, o valor da cobrança em três fluxos e os limites;
- sem ela, o custo da adoção era `centavosDe(t) / 100.0` escrito em dez telas — a máscara
  reimplementada por fora, que é o defeito que este componente existe pra não ter;
- **`centavosDe` continua sendo a preferida** e a doc diz por quê (inteiro não perde centavo por
  arredondamento). `emReais` é `centavosDe/100`, e o teste amarra as duas pra não virarem duas
  contas que divergem numa borda;
- **minor**: símbolo novo, nada mudou de forma. Quem adota não muda uma linha.

**Correção do número, depois da tag** (o commit da `v0.6.0` dizia 10): são **9** chamadas de produto. A
décima era o **exemplo na doc do próprio widget** — `grep` conta comentário, e eu não separei. Fica
registrado em vez de sumir: contar o próprio exemplo como consumidor é a mesma classe de erro que fez a
função ser removida em julho.

### Sobre como as duas apareceram

As duas saíram da **adoção rodando no app de verdade** (fase B1b: pontos de página, copiar, abas,
segmentos, saldo, escada de alçadas, selo quântico, resumo da transação, autorização pendente). Nenhuma
das duas era visível de dentro deste repo: a primeira porque teste de widget não tem dedo, a segunda
porque a medição olhou o campo errado. **Adoção é a única leitura que enxerga as duas.**

Gates: DS analyze limpo e **107 testes** · catálogo limpo e **66**.

## [0.5.0] — 2026-08-03

### Alterado — **`ds-diletta` v0.24.4 → v0.26.0**, e a baseline de specs zerou por conserto do pai

- Três releases do pai num `ref:`: `v0.25.0` (a rampa é a fonte), `v0.25.1` (o `info` registrado, sem
  código) e `v0.26.0` (5 specs novas, os três `cpfSeguro*` removidos, `DilettaTextLinkTone.cpf` →
  `.brand`);
- **o ganho que aparece aqui é a spec do teclado.** `keyboard` entrou nas 5 da `v0.26.0` — o conjunto do
  pai foi de 71 pra 76 — e a única linha da minha
  `baselineDeSpecsQueFaltam` (`PlugueDoDs.contratos['teclado']`) virou **fantasma na hora**: o teste
  anti-fantasma reprovou no minuto seguinte ao `pub get`, antes de qualquer outro. A baseline agora é
  `<String>{}`, e as duas do repo estão vazias;

  > Baseline que só encolhe é baseline. A que cresce é dívida com outro nome.

- **as duas metades da v0.25.0 já estavam feitas**: `BoldColors` saiu na minha `v0.3.0`, do veredito
  **ENTRA COMO FORMA** do mesmo pedido. Subir o `ref:` só trouxe a regra pro lado de onde ela é cobrada;
- **minor e não major, e o motivo é medição e não conveniência.** A tabela acima diz *"símbolo removido →
  major"*, e três símbolos saíram da superfície que este pacote reexporta. Nenhum deles é meu, todos
  tinham janela aberta desde **30/07** com o caminho de cada arquivo, e a contagem de hoje é **zero
  chamadas** nos três consumidores — DS, catálogo e `app-newbold`. `DilettaTextLinkTone.cpf` segue
  resolvendo `@Deprecated` até a `v0.27.0` do pai, então nem call site que existisse quebraria. **Quem
  adota não muda uma linha** — e é isso que a coluna da tabela promete, não o número.

Gates: DS analyze limpo e **105 testes** · catálogo limpo e **66**.

## [0.4.0] — 2026-08-02

### Corrigido — **a escolha da pessoa vencia ou não o fundo da tela, dependendo do repo**, e a minha ordem era a errada

- `BoldBackground` resolvia `estilo ?? scope?.estilo`; o app resolve `escolhido ?? padraoDaTela`.
  **São ordens opostas**, e a minha regride um defeito que o app já tinha consertado: com ela, toda
  tela que declara o próprio fundo passa a ignorar a personalização — na Área Pix isso foi o **item
  72 do QA**, com o hub declarando `solido` e o fundo escolhido em Aparência não aparecendo;
- achado **trocando o widget de verdade**, não lendo: eu ia adotar o meu por cima do do app e a
  medição do call site mostrou a inversão. Copiar comportamento de um app e não copiar a ORDEM em
  que ele resolve é a forma silenciosa de perder um conserto;
- `BoldBackdropScope.estilo` virou **opcional**, e a diferença é semântica: nulo é *"ninguém
  personalizou"* — aí o default da tela vale. Antes era obrigatório, e obrigar um valor apagava a
  distinção entre "escolheu sólido" e "não escolheu";
- o gate lê o valor que o componente **declara** (`DilettaDevInfo.props['estilo']`) em vez de inferir
  por cor: no escuro, sólido e mood assentam no mesmo `bg`, então cor não distingue os dois — o
  teste passaria com o defeito de volta.

**Minor e não patch**: `BoldBackdropScope.estilo` deixou de ser `required`, e a ordem de precedência
muda comportamento em tela. Quem chama não muda uma linha.

## [0.3.0] — 2026-08-02

### Adicionado — **`BoldColors`: a rampa vira a FONTE**, e a paleta se monta dela

- Os 46 degraus saíram de dentro do construtor de `BoldPalette.bold` e viraram
  `static const Color` em **`BoldColors`**. A paleta continua igual, e agora é **derivada**;
- **é o que o consumidor ganha, e era o que faltava**: `static const Color acao =
  BoldColors.primary04;` compila. `BoldPalette.bold.primary04` nunca compilou em posição
  const — acesso a campo de instância não é expressão constante em Dart, mesmo com a
  instância `const`;
- veio do veredito **ENTRA COMO FORMA** do pai (`ds v0.25.0`, `O-QUE-O-FILHO-FORNECE.md` §1):
  *"a rampa é a fonte; a paleta é derivada dela"*. O pedido saiu daqui com o custo medido no
  app real — 84 constantes copiadas, 51 linhas `const` que `static final` quebraria, 427
  chamadas que perderiam o `const`;
- **o gate quase não tem corpo**, e é de propósito: `a_rampa_e_legivel_em_const_test` declara
  `static const BoxDecoration caixa = BoxDecoration(color: BoldColors.primary08);` — **a
  asserção é a compilação.** Se a rampa voltar pra dentro do construtor, o arquivo não
  compila. A segunda metade compara paleta com rampa campo a campo, pra a paleta não virar
  uma cópia que combina por enquanto;
- nada some: `BoldPalette.bold` tem a mesma forma e os mesmos valores. **Minor** porque um
  símbolo público nasceu.

### Alterado — em dia com os dois pais, e a razão de subir é a quinta pergunta deles

- `ds-diletta` **v0.24.0 → v0.24.4** · `catalogo-diletta` **v0.73.0 → v0.74.1**;
- **nada aqui muda pra quem adota.** As sete releases são ferramenta e arrumação do lado do pai: a
  limpa deixou de acusar arquivo gerado e o próprio ledger, a varredura passou a enxergar
  `## Nota do filho`, e o compositor do motor foi cortado por método em três passos;
- o motivo de subir mesmo sem ganhar nada é a **quinta pergunta** que a varredura do pai ganhou na
  `ds v0.24.4` — *que filho está ATRÁS*. Eu estava: 4 releases no DS e 3 no motor.

  > **Tag publicada não é tag adotada** — a frase é do pai, e do lado de quem usa, um conserto que não
  > chegou é indistinguível de um que não existe.

Gates: DS analyze limpo e **102 testes** · catálogo limpo e **66**.

## [0.2.0] — 2026-08-02

### Alterado — os dois pais sobem, e o que chega é CONTEÚDO das specs

- `ds-diletta` **v0.23.4 → v0.24.0** · `catalogo-diletta` **v0.70.0 → v0.73.0**;
- o que o app ganha ao subir: **`## Compõe` em 69 das 71 specs** do pai (era 8). As specs viajam no
  pacote (`kDilettaSpecs`), então isto é conteúdo novo chegando em quem adota — não é só versão;
- no catálogo, a **Árvore de dependências** aparece sozinha: a aba de Fundamentos aqui é a do motor
  inteira, e a quarta vista entra assim que houver composição declarada;
- **os 12 contratos deste filho já declaravam `## Compõe`** — medido, 12 de 12. O aviso do pai
  supunha que eles teriam nó sem aresta; não é o caso, e a árvore nasce ligada dos dois lados;
- `DilettaWalletCard.cpfSeguro` virou `.brand` no pai nesse intervalo. **Zero linha aqui** — este
  filho não usa o componente, e os dois gates confirmam.

Sem mudança de API deste pacote. Gates no commit: DS analyze limpo e **99 testes** · catálogo limpo e
**66** · `build_web.sh` fecha com o gate do Cloudflare em zero.

## [0.1.0] — 2026-08-01

**A primeira tag.** É a versão que os dois `pubspec.yaml` declaram, e agora `v0.1.0` é o commit que o app
pode pedir por `git:` — antes disso não havia nada pra pedir. Ela aparece aqui como número, e não como
"não lançado", porque é assim que o gate da limpa compara o pubspec com este arquivo — e um pubspec que
ninguém consegue conferir é a classe que ele existe pra pegar.

Medido no commit da tag, não afirmado: DS `flutter analyze` limpo e **99 testes** passando · catálogo
`analyze` limpo e **66** passando · a limpa do pai com as classes 1, 5, 7, 8 e 9 em **nada**.

- **19 arquivos de componente**, 23 tipos públicos `Bold*`, medidos por uso no app — não por catálogo de
  desejo. Oito componentes do pai com uso ZERO não foram declarados, de propósito;
- **5 TELAS declaradas** — o fluxo de Pix inteiro (`home → valor → revisar → enviado`, com **3 setas**
  `push`) e as autorizações da PJ. Eram zero até 2026-07-31; a aba **Telas** mostra fluxo, doc e código;
- **4 slots** declarados (2 fechados por medição, 2 abertos por decisão) — os containers COMPÕEM;
- **56 blocos** no plugue do catálogo, todos em grupo, todos desenhando com os próprios defaults, e o
  emitido de cada um compilando — em **135 variações** de opção de enum, não só no default;
- **paleta como INSTÂNCIA** do tipo do pai, com ~51 papéis derivados. O filho fornece a paleta e mais nada
  obrigatório;
- **99 testes** no DS, **66** no catálogo, analyzer limpo. Conformidade do pai com baseline vazia no DS e
  uma linha declarada no catálogo (`teclado`, componente do pai ainda sem spec);
- **dois sweeps de layout** sobre os 56 blocos, a 900 e a 320 de largura;
- **a montagem da tela conferida contra a geometria pintada** — a doc do contrato contra o `dy` real de
  cada bloco, e o slot contra o retângulo do pai;
- pais: `ds-diletta` **v0.23.4** · `catalogo-diletta` **v0.70.0**.

### O que ainda NÃO é entrega

O app **não adotou**. `ADOCAO.md` tem o caminho, e a decisão é de quem cuida do app — nada aqui mexeu em
`app-newbold`. Enquanto isso, este pacote é medido contra o app, não instalado nele.
