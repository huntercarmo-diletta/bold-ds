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
