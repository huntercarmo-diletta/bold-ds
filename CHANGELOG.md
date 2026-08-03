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
