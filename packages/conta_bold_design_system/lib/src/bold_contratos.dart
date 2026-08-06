/// OS CONTRATOS DOS COMPONENTES NASCIDOS AQUI.
///
/// O pai entrega **77 specs** (`kDilettaSpecs`, medido em 2026-08-06) pros componentes DELE. Os 12 que
/// nasceram neste filho não tinham contrato nenhum, e o gate `bloco-sem-contrato` (v0.36.0 do motor)
/// estava certo em cobrar: sem
/// contrato, a aba de componentes desenha nome e matriz e para ali — sem "quando usar", sem faça/evite.
///
/// ## Por que Dart e não markdown em `docs/`
///
/// Pela mesma razão que fez o pai gerar `kDilettaSpecs`: markdown como ASSET exige `rootBundle`, que é
/// assíncrono e não existe em teste sem bundle. E aqui não há cópia — **este arquivo É a fonte**. O pai
/// tem markdown em `specs/` e gera o Dart; com doze componentes, gerador seria peça a mais pra manter.
///
/// Ceiling declarado: se isto passar de ~30 contratos, o caminho é o dele — markdown na árvore e um
/// gerador. Trinta strings longas num arquivo é onde a leitura começa a doer.
///
/// ## O formato é o do pai, e não por gosto
///
/// `## Purpose` · `## Guidelines` com `### Quando usar`/`### Faça`/`### Evite` · `## Compõe` ·
/// `## Requirements` com `### Requirement:`. É o que o `contrato_de_componente.dart` do motor lê — se eu
/// inventasse seção, ela não apareceria na tela e nada avisaria.
library;

/// `slug → markdown`. O slug é o TIPO DO BLOCO no catálogo, porque é por ele que o motor pergunta.
const Map<String, String> kBoldSpecs = {
  'seloQuantico': _seloQuantico,
  'saldo': _saldo,
  'copiar': _copiar,
  'abas': _abas,
  'segmentos': _segmentos,
  'pontosDePagina': _pontosDePagina,
  'visorDeCodigo': _visorDeCodigo,
  'cabecalhoDaHome': _cabecalhoDaHome,
  'resumoDaTransacao': _resumoDaTransacao,
  'escadaDeAlcadas': _escadaDeAlcadas,
  'progressoDeAprovacao': _progressoDeAprovacao,
  'prazoDaPendencia': _prazoDaPendencia,
};

const _seloQuantico = r'''
## Purpose

O selo de autorização do Conta BOLD: a peça que diz se uma transação foi autorizada pelo par
quântico. É marca e é estado ao mesmo tempo — o desenho é do produto, e o que ele comunica é
irreversível (autorizado, negado, aguardando).

## Guidelines

### Quando usar
Numa tela cujo assunto É a autorização quântica: pareamento, confirmação, comprovante de transação
autorizada. Fora desse assunto, o estado se comunica com `selo` (status tag), que é vocabulário.

### Faça
- deixe o rótulo aparecer quando a tela não disser o estado em outro lugar
- use os três estados do enum; o desenho de cada um é decisão de marca, não de tela
- reserve o tamanho grande (200) pra tela cujo único assunto é o selo

### Evite
- usar como ícone de status genérico — é marca, e marca repetida deixa de significar
- passar cor por fora: o estado escolhe a cor, e é isso que impede "autorizado em vermelho"
- animar em lista: o selo tem movimento próprio, e vinte deles numa lista competem com o conteúdo

## Compõe

- DilettaBox
- DilettaText
- CustomPaint (o anel é desenho, não composição)

## Requirements

### Requirement: o estado é um enum FECHADO, e o switch é exaustivo
O componente SHALL receber `BoldSeloEstado` e resolver cor, ícone e rótulo por `switch` sem `_ =>`.
Estado novo SHALL quebrar a compilação em vez de cair no visual de outro estado.

### Requirement: três estados, não dois booleanos
O componente SHALL expressar `autorizado`/`negado`/`aguardando` como UM valor. A versão anterior usava
dois booleanos, e a combinação impossível (`autorizado && negado`) era representável.

### Requirement: o rótulo respeita o tema
O texto SHALL sair de papel do scheme, não de branco cravado — o selo aparece sobre fundo claro e sobre
arte escura.
''';

const _saldo = r'''
## Purpose

O card de saldo da home: valor em destaque, entradas e saídas do período, e o atalho pro extrato. É o
primeiro número que a pessoa procura ao abrir o app.

## Guidelines

### Quando usar
Só na home, uma vez. Saldo repetido em duas telas cria duas fontes de verdade visual.

### Faça
- passe o valor JÁ FORMATADO: moeda é decisão de locale, e locale é do produto
- use `oculto` pra o modo privacidade em vez de trocar o texto por asteriscos na tela
- deixe entradas e saídas nulas quando o período não tem movimento — o componente encolhe

### Evite
- recalcular a largura do valor a cada troca: a largura é RESERVADA de propósito, pra mascarar não
  deslocar o resto da tela
- pôr o botão de ocultar aqui — ele mora na barra de topo, porque é ação de tela e não de card
- usar onde bastaria o `valor` (`DilettaAmountDisplay`): aquele é UM número entre hairlines, e serve
  detalhe de transação e header de extrato. Este é o organismo da home, com modo oculto, entradas e
  saídas e o atalho do extrato. Se a tela mostra um número e nada mais, o certo é o outro

## Compõe

- DilettaAmountDisplay
- DilettaBox
- DilettaText
- DilettaIcon

## Requirements

### Requirement: mascarar NÃO desloca a tela
Com `oculto: true` o componente SHALL manter a mesma largura do valor visível. Sem isso a tela dança a
cada toque no olho.

### Requirement: o extrato é opcional e explícito
`aoAbrirExtrato` nulo SHALL esconder o atalho, não desenhar um alvo morto.
''';

const _copiar = r'''
## Purpose

O botão de copiar de uma chave, código ou linha digitável: copia e CONFIRMA que copiou. Sem a
confirmação a pessoa toca duas vezes e não sabe se funcionou.

## Guidelines

### Quando usar
Ao lado de um valor que a pessoa vai colar em outro lugar: chave Pix, linha digitável, código de
autorização.

### Faça
- escreva o rótulo de acessibilidade dizendo O QUE se copia ("Copiar chave Pix"), não "copiar"
- deixe a confirmação sumir sozinha: ela é feedback, não estado

### Evite
- copiar sem confirmar
- usar em texto longo que a pessoa deveria ler antes de colar

## Compõe

- DilettaTappable
- DilettaIcon
- DilettaText

## Requirements

### Requirement: o aviso de copiado tem chave própria
O componente SHALL identificar o aviso de confirmação com uma chave estável. Sem isso, um teste que
mede opacidade encontra a animação interna de outro componente e passa medindo a coisa errada — foi o
que aconteceu na primeira versão.

### Requirement: o timer é cancelado no dispose
O componente SHALL cancelar o temporizador da confirmação ao ser descartado, senão ele dispara sobre
um State morto.
''';

const _abas = r'''
## Purpose

Abas sublinhadas: trocam a LISTA que está sendo mostrada. O sublinhado ativo é mais grosso que o
inativo, então a seleção não depende só de matiz.

## Guidelines

### Quando usar
Quando a tela mostra conjuntos alternativos do mesmo tipo de conteúdo — "Ativos" e "Encerrados",
"Tudo", "Entradas", "Saídas".

### Faça
- duas a quatro abas; acima disso o rótulo encurta e a navegação vira adivinhação
- mantenha o conteúdo no mesmo lugar ao trocar: a aba troca a lista, não o layout

### Evite
- usar pra escolher um PARÂMETRO do que já está na tela — isso é `segmentos`, e a forma diferente é o
  que ensina o que vai acontecer. `pix_meus_qr_flow.dart` usa os dois seis linhas um do outro, e é a
  prova de que a distinção é do produto e não minha
- deixar a seleção só na cor

## Compõe

- DilettaTappable
- DilettaText
- DilettaBox

## Requirements

### Requirement: a área de toque é a ABA, não o texto
A região tocável SHALL cobrir a faixa inteira da aba. A primeira versão respondia só sobre o rótulo, e
a faixa acima e abaixo era morta.

### Requirement: rótulo longo encurta, e só quando não cabe
As abas SHALL dividir a largura igualmente apenas quando não couberem todas; senão cada uma ocupa o
que precisa. Dividir sempre cortava a maior enquanto a menor sobrava espaço.
''';

const _segmentos = r'''
## Purpose

Seletor segmentado: escolhe UMA entre poucas opções, e a escolha é um PARÂMETRO do que já está na tela
— período, tipo de conta, tema.

## Guidelines

### Quando usar
Duas ou três opções mutuamente exclusivas que filtram ou configuram o conteúdo visível.

### Faça
- dois ou três rótulos curtos
- deixe o efeito da troca visível na mesma tela: segmento que navega é aba disfarçada

### Evite
- usar pra NAVEGAR entre listas — isso é `abas`. A mesma tela deste produto usa os dois, seis linhas um
  do outro, e a forma é o que distingue
- passar quatro ou mais opções: a pílula não cabe em tela de telefone, e o componente certo passa a ser
  lista ou dropdown

## Compõe

- DilettaBox
- DilettaTappable
- DilettaText

## Requirements

### Requirement: cada segmento anuncia se está SELECIONADO
Cada opção SHALL expor `selected` na semântica. Sem isso o leitor de tela lê três botões idênticos e
não diz qual está ativo — que é a única informação que o componente carrega.

### Requirement: só a opção ativa tem pastilha, e ela é do tema
A pastilha SHALL sair de papel do scheme. Branco cravado deixava uma pastilha de branco puro dentro de
um trilho escuro no modo noite.
''';

const _pontosDePagina = r'''
## Purpose

Indicador de página de carrossel ou onboarding: diz onde a pessoa está numa sequência curta. O ativo
ALONGA em pílula, além de mudar de cor.

## Guidelines

### Quando usar
Numa sequência de duas a cinco telas ou cartões que a pessoa percorre.

### Faça
- controle a página fora: este componente é presentacional
- mantenha o tamanho padrão; o ponto é referência, não elemento

### Evite
- usar com uma página só — um ponto sozinho não indica nada e ocupa espaço vertical
- usar com muitas páginas: acima de cinco pontos ninguém conta, e o certo é um contador

## Compõe

- DilettaBox

## Requirements

### Requirement: o ativo ALONGA, não só muda de cor
O ponto ativo SHALL ter largura maior que os inativos. Indicador que muda só de matiz não é lido por
quem não distingue matiz — a mesma decisão do sublinhado das abas.

### Requirement: a linha é uma frase pro leitor de tela
O componente SHALL anunciar "Página X de N" como rótulo único, em vez de expor N caixas vazias.
''';

const _visorDeCodigo = r'''
## Purpose

O visor do leitor de código: desenha o retículo, os alvos detectados e o rastro da varredura sobre a
imagem da câmera. É o diferencial deste produto — nenhum outro filho lê QR e código de barras.

## Guidelines

### Quando usar
Sobre um preview de câmera, quando a tela existe pra LER algo: Pix por QR, boleto por código de
barras, autorização de transação.

### Faça
- passe os alvos já classificados: o visor desenha, não decide o que é o código
- use a fase da varredura pra o rastro; ela vem de quem controla a animação
- declare o bloco como tela cheia no catálogo — ele é overlay, e numa coluna de scroll pede altura
  infinita

### Evite
- arrastar o plugin de câmera pro DS: a tela de scanner tem 603 linhas e depende de `mobile_scanner`,
  `permission_handler`, roteador e estado. Nada disso entra aqui
- desenhar mensagem de erro de permissão dentro do visor — isso é tela

## Compõe

- CustomPaint
- DilettaText
- DilettaBox

## Requirements

### Requirement: os argumentos de runtime vêm de fora
`alvos`, `fase` e `tamanhoDaImagem` SHALL ser fornecidos pelo consumidor. O componente não observa
câmera nem temporizador.

### Requirement: alvo sem rótulo não desenha caixa vazia
Alvo sem rótulo SHALL desenhar apenas o retículo.
''';

const _cabecalhoDaHome = r'''
## Purpose

O cabeçalho da home: conta ativa e ícones na linha de cima, avatar e saudação na de baixo. É a segunda
linha de uma casca de topo do pai, não um acessório dentro da barra.

## Guidelines

### Quando usar
Só na home. É a identidade da tela inicial, e repetir cria duas cascas concorrentes.

### Faça
- passe `aoTrocarConta` só quando a troca existir: sem ele o chevron não aparece
- use `carregandoConta` pra o skeleton em vez de deixar o rótulo vazio

### Evite
- montar esta casca à mão com vidro, status bar e coluna: o pai tem
  `DilettaTopAppBar.comConteudo`, e a cópia não acompanha quando a gramática dele muda
- tentar caber isto num acessório da barra: a barra tem 52 de altura cravada e este cabeçalho tem 84

## Compõe

- DilettaTopAppBar.comConteudo
- DilettaNavigationTopBar
- DilettaAvatar
- DilettaSkeleton
- DilettaIcon

## Requirements

### Requirement: é CASCA, não acessório
O componente SHALL usar a casca de topo do pai e entregar apenas a segunda linha. Compor vidro, status
bar e coluna à mão SHALL ser considerado regressão.

### Requirement: nome vazio não quebra
Nome vazio SHALL render `?` no avatar. O nome vem de sessão, e sessão pode chegar vazia.

### Requirement: sem troca de conta, sem afordância
`aoTrocarConta` nulo SHALL esconder o chevron. Rótulo estático com afordância de clique é pior que
rótulo sem afordância.
''';

const _resumoDaTransacao = r'''
## Purpose

O cabeçalho de um comprovante: o que aconteceu, quanto, quando, e o estado em forma de spot. É
conteúdo de tela, não a tela — as seções, a lista e o CTA são blocos próprios.

## Guidelines

### Quando usar
No topo de qualquer comprovante: Pix, boleto, TED, recarga.

### Faça
- passe o valor já formatado
- use o estado pra o par ícone+tom em vez de escolher os dois na tela

### Evite
- montar a tela inteira dentro deste componente: fundo, barra e CTA são blocos, e um bloco que já é a
  tela não compõe com nada
- cortar o valor com reticências: `R$ 1.234...` lê como um valor menor do que é
- confundir com o `comprovante` (`DilettaReceipt`): **este é o CABEÇALHO DA TELA, aquele é o DOCUMENTO
  compartilhável.** Aqui o valor é herói e o spot tem tom semântico; lá o ícone é neutro e centralizado,
  as linhas são label/valor, e existe rodapé com ID da transação e logo. As duas coexistem no mesmo
  fluxo — o comprovante abre pelo CTA desta tela

## Compõe

- DilettaSpotIcon
- DilettaText

## Requirements

### Requirement: o ESTADO decide ícone e tom
O componente SHALL receber `BoldEstadoDaTransacao` e resolver o par. Passar ícone e tom separados
permite acertar um e errar o outro — eram quatro pontos de uso com o ternário repetido.

### Requirement: dinheiro ENCOLHE, nunca corta
O valor SHALL reduzir de tamanho quando não couber, e SHALL manter todos os dígitos.

### Requirement: o spot não é anunciado
O ícone de estado SHALL ficar fora da árvore de semântica: o estado já está escrito no título.
''';

const _escadaDeAlcadas = r'''
## Purpose

A escada de alçadas em leitura: faixas de valor empilhadas da menor pra maior, cada uma dizendo quantas
assinaturas a saída exige. É o vocabulário da conta PJ — quem pode mandar quanto, e com quantas mãos.

## Guidelines

### Quando usar
Onde a REGRA precisa ser lida: editor de alçadas, detalhe do operador, aviso antes de enviar.

### Faça
- passe os tetos já formatados; a escada compõe as palavras da faixa ("De X a Y")
- use `densa` em lista ou dentro de card
- deixe a lista vazia quando não há regra declarada — o componente não desenha moldura vazia

### Evite
- codificar a exigência só em cor: o número de assinaturas é o dado, e ele é texto
- passar função de formatação: função não é prop vinculável a dado, e isso tira o componente do
  compositor

## Compõe

- DilettaBox
- DilettaIcon
- DilettaText

## Requirements

### Requirement: a faixa sai de DOIS degraus
O texto da faixa SHALL ser composto pela escada a partir do teto do degrau anterior. O degrau sozinho
não conhece o próprio piso.

### Requirement: contraste de AA no rótulo da exigência
A tinta SHALL ser o papel `onXSubtle` do banho correspondente. Usar o tom cheio sobre banho do mesmo
tom media 3.08:1 no claro e 2.94:1 no escuro, contra o piso de 4.5.

### Requirement: a ordem do sacrifício é declarada
Quando a linha não couber, a FAIXA SHALL ceder antes da exigência: o número de assinaturas é o que se
veio ler.
''';

const _progressoDeAprovacao = r'''
## Purpose

"1 de 2 · falta 1" com os degraus preenchidos: quantas assinaturas já foram colhidas numa pendência de
aprovação. O número vira forma pra ser lido de relance numa lista.

## Guidelines

### Quando usar
Em qualquer lugar que mostre uma autorização pendente: linha de lista, detalhe, aviso.

### Faça
- use `compacto` dentro de row de lista
- passe `exigeMaster` quando a regra pedir assinatura de aprovador master

### Evite
- confundir com o stepper do pai: lá o número é POSIÇÃO num fluxo ("Passo 1 de 2"), aqui é contagem de
  gente
- desenhar régua com exigência zero

## Compõe

- DilettaBox
- DilettaText
- DilettaIcon

## Requirements

### Requirement: completo fica VERDE
Com todas as assinaturas colhidas o componente SHALL usar a família de sucesso. Numa lista de
pendências, a que já pode executar é a que precisa saltar.

### Requirement: o leitor de tela recebe a FRASE
A régua SHALL ficar fora da semântica, e o componente SHALL anunciar "X de N assinaturas, falta Y".
''';

const _prazoDaPendencia = r'''
## Purpose

Quanto tempo resta pra uma pendência expirar. É REGRA, não desenho: o pill e os tons são a etiqueta de
status do pai.

## Guidelines

### Quando usar
Ao lado de uma autorização pendente, junto do progresso de aprovação.

### Faça
- passe `idade` quando o servidor não informar prazo
- ajuste `urgenteAbaixoDe` quando o produto tiver outro limite

### Evite
- inventar contagem quando não há prazo: sem `restante`, o que existe é a idade da pendência
- mostrar "faltam -2 h": vencido é estado terminal

## Compõe

- DilettaStatusTag

## Requirements

### Requirement: sem prazo E sem idade, não desenha
O componente SHALL não renderizar quando não há nada verdadeiro a dizer. Etiqueta vazia é pior que
ausência.

### Requirement: o pill é do PAI
O componente SHALL delegar forma e tom à `DilettaStatusTag`. Desenhar pill próprio SHALL ser
considerado regressão.

### Requirement: espera é `pending`, e não `neutral`
Estado de ESPERA (sem prazo, ou prazo largo) SHALL sair no tom `pending`; prazo curto SHALL sair em
`warning` e prazo vencido em `danger`. `neutral` quer dizer *sem estado*, e uma pendência tem estado —
ela está esperando. A tinta de `pending` é a mesma da neutra de propósito (o relógio é o estado), então
a regra é sobre DECLARAÇÃO e não sobre pixel.
''';
