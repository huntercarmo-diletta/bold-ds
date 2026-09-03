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
  // As seis que atravessaram a fronteira, em 11/08. Quatro eram LACUNA no inventário de adoção e
  // duas eram peças adotadas que moravam dentro do app — invisíveis pro catálogo, que consome o
  // pacote. O teto declarado lá em cima (~30 contratos) segue de pé: são 18.
  'ladrilhoDeMenu': _ladrilhoDeMenu,
  'linhaDeAviso': _linhaDeAviso,
  'chipDeFiltro': _chipDeFiltro,
  'cartaoPromocional': _cartaoPromocional,
  'fileiraDeAvatares': _fileiraDeAvatares,
  'grupoDoDia': _grupoDoDia,
  // As duas que eram classe PRIVADA dentro de uma tela — a quarta classe de dívida deste repo, e a
  // mais silenciosa: widget privado que a tela CONSTRÓI é invisível pra qualquer varredura.
  'cartaoDaConta': _cartaoDaConta,
  'cartaoDePedido': _cartaoDePedido,
  // A grade não é componente — é o container de linha que a gramática `top/blocks/bottom` não
  // tinha. Ela tem contrato pelo mesmo motivo que os outros: sem ele a aba desenha nome e para.
  'grade': _grade,
  // A amostra de fundo é a VITRINE de um token deste DS, e ela chegou com a tela de Aparência: o
  // `CoreflowBackdrop` tinha sete valores e nenhuma peça que os mostrasse fora do aparelho.
  'amostraDeFundo': _amostraDeFundo,
  // A pílula da home. Ela veio por um print — o board desenhava a barra ANCORADA do pai, e este
  // produto usa a flutuante. Dois desenhos válidos e nenhum gate media a escolha.
  'navFlutuante': _navFlutuante,
  // ── As peças que entraram no catálogo em 03/09 ────────────────────────────────────────────────
  //
  // Elas existiam no DS e não no plugue: quem compunha uma tela não tinha como pedir um cartão, um
  // disco ou o pegador de uma folha sem sair do design system. Contrato escrito junto porque é o
  // mínimo que o `COMPONENTE-DO-FILHO.md` do pai pede — componente sem contrato funciona, só não se
  // explica.
  'cartao': _cartao,
  'disco': _disco,
  'ponto': _ponto,
  'pegador': _pegador,
  'heroi': _heroi,
  'busca': _busca,
  'campoDeValor': _campoDeValor,
  'botoesDeNavegacao': _botoesDeNavegacao,
  'painelDeEntrada': _painelDeEntrada,
  'anelDeEscolha': _anelDeEscolha,
  'faixaDeOperacao': _faixaDeOperacao,
  // O chrome de página e de folha, que entrou no catálogo em 03/09.
  'pagina': _pagina,
  'folhaDoProduto': _folhaDoProduto,
  'acaoDeRodape': _acaoDeRodape,
  'cabecalhoDeFolha': _cabecalhoDeFolha,
  'fecharFolha': _fecharFolha,
  'larguraDeConteudo': _larguraDeConteudo,
  'esperando': _esperando,
  'rodapeDoProduto': _rodapeDoProduto,
  'corpoDeFolha': _corpoDeFolha,
  'larguraInteira': _larguraInteira,
  'paginaDeResumo': _paginaDeResumo,
  'paginaComRodapeFlutuante': _paginaComRodapeFlutuante,
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
O componente SHALL receber `CoreflowEstadoDaTransacao` e resolver o par. Passar ícone e tom separados
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

const _ladrilhoDeMenu = r'''
## Purpose

O ladrilho do menu: vidro, ícone em cima, rótulo embaixo, tudo alinhado à esquerda. É a peça do menu
2×2 da home, da grade compacta da Área Pix e dos atalhos do login recorrente.

## Guidelines

### Quando usar
Numa GRADE de destinos equivalentes, onde a pessoa escolhe um. Destino único ou destino com
subtítulo é linha de lista, não ladrilho.

### Faça
- escolha o porte pela grade, não pelo gosto: `compacto` para ~3 colunas, `largo` para 2, `alto` para
  a fileira de atalhos do login
- mantenha o rótulo curto — o compacto quebra em duas linhas e o largo trunca em uma
- deixe o vidro passar a arte do fundo: é ele que separa este ladrilho de um botão

### Evite
- usar no lugar do `cartaoDeAcesso` (`DilettaQuickAccessCard`): aquele é 75×84, ícone em pill,
  conteúdo CENTRADO e com estado `locked`. Este é alinhado à esquerda, sem pill e sem estado. Trocar
  um pelo outro redesenha a tela por baixo
- misturar portes na mesma grade — o porte é a coluna, e duas alturas na mesma fileira lê como erro

## Compõe

- DilettaGlassSurface
- DilettaIcon
- DilettaText
- DilettaTappable

## Requirements

### Requirement: cada porte tem a sua altura
Os três portes SHALL render alturas distintas (80 · 82 · 100). Enum cujos valores desenham igual é
enum decorativo, e o próximo conserto o apaga sem ninguém ver.

### Requirement: o compacto tem largura própria
No porte `compacto` a peça SHALL travar em 85 de largura. Ela vive num `Wrap` de ~3 colunas, e herdar
a largura do pai a faria ocupar a fileira inteira.
''';

const _linhaDeAviso = r'''
## Purpose

A linha-aviso da home — a das *Autorizações*: vidro de largura cheia, ladrilho da marca com o glifo
branco, título e subtítulo, e a CONTAGEM do que está esperando.

## Guidelines

### Quando usar
Quando há uma FILA esperando a pessoa, e o número dela importa. É o que separa esta peça de um item
de menu: menu leva a um lugar, isto informa que há trabalho parado.

### Faça
- deixe a contagem nula (ou zero) quando não há fila: o disco some, e a linha continua sendo o atalho
- use o subtítulo pra dizer o que fazer, não pra repetir o título
- mantenha o ladrilho na cor da marca — é ele que separa "espera você" de "mais um item"

### Evite
- desenhar o disco com zero: um "0" num disco lê como *tem uma coisa aqui*
- usar como linha de lista: a lista do pai (`DilettaAppListRow.menuItem`) tem seta, e seta e contador
  não convivem — a pessoa lê o número como valor

## Compõe

- DilettaGlassSurface
- DilettaIcon
- DilettaText
- DilettaTappable

## Requirements

### Requirement: fila vazia não mostra número
Com contagem nula OU zero o disco SHALL não existir na árvore. A borda é o ZERO, não o nulo.
''';

const _chipDeFiltro = r'''
## Purpose

A pílula de filtro: *Todos · Entradas · Saídas*. Numa fila onde exatamente um está escolhido, e a
leitura tem que ser instantânea.

## Guidelines

### Quando usar
Filtro de escolha ÚNICA sobre uma coleção. Filtro aplicado e removível é `chipDeEntrada`
(`DilettaInputChip`), que é outra peça e outra leitura.

### Faça
- deixe sempre um escolhido: fila sem nenhum marcado não diz o que está sendo mostrado
- mantenha os rótulos curtos e paralelos entre si

### Evite
- usar como o `chipDeEntrada` do pai: aquele fica no mesmo tom nos dois estados (`filled` é
  `primarySubtle`), porque ele marca um filtro numa fila de filtros aplicados. Este INVERTE — fundo
  `primary` cheio e tinta `onPrimary` — porque ele marca A escolha numa fila de opções
- confiar só na cor: o peso do rótulo vai de 400 a 600 junto, e é o que faz a escolha sobreviver a
  quem não distingue as duas tintas

## Compõe

- DilettaText
- DilettaTappable

## Requirements

### Requirement: escolhido inverte fundo E peso
O estado escolhido SHALL trocar a tinta do rótulo e SHALL levar o peso a 600. Cor sozinha não é
informação.

### Requirement: o alvo de toque é 44 e o desenho não
A área tocável SHALL ter 44 de altura com a pílula em ~26. O respiro mora FORA do desenho — invertê-los
engorda a pílula e não muda o alvo.
''';

const _cartaoPromocional = r'''
## Purpose

O cartão do carrossel da home: título, subtítulo, arte de 100 à direita e um X. É a SUGESTÃO — a que
espera ser dispensada.

## Guidelines

### Quando usar
Pra oferecer algo que a pessoa pode ignorar sem custo: habilitar passkey, revisar dispositivos. Se a
oferta precisa ser atendida, é `DilettaPromoBanner`, que tem botão e não tem X.

### Faça
- passe a arte pelo app: asset de produto não mora no DS, e sem arte o cartão desenha a moldura
- deixe o cartão inteiro ser o alvo — ele não tem botão de propósito

### Evite
- desenhar o X sem ter o que ele faça: um X que não dispensa promete e não cumpre
- empilhar dois destes na mesma dobra — sugestão repetida vira ruído, e o carrossel existe por isso

## Compõe

- DilettaGlassSurface
- DilettaIcon
- DilettaText
- DilettaTappable

## Requirements

### Requirement: o X só existe quando fecha
Sem `aoFechar`, o glifo de fechar SHALL não existir na árvore.
''';

const _fileiraDeAvatares = r'''
## Purpose

O *"Enviar para"*: a fileira de contatos favoritos com iniciais, primeiro nome e banco, mais o "+"
tracejado que leva à agenda.

## Guidelines

### Quando usar
Como ATALHO pra um destino frequente — home e Área Pix. Não é lista de contatos: quem procura alguém
usa a busca.

### Faça
- passe `rotulos` pra forma rotulada; sem eles a fileira é só os círculos
- deixe a fileira rolar na horizontal em vez de cortar a lista em N
- mantenha o "+" no fim: ele é a saída pra agenda inteira

### Evite
- cravar cor ou tamanho de inicial: o círculo é o `DilettaAvatar` do pai, e a inicial sai do DEGRAU
  que o diâmetro escolhe — não de uma fração dele

## Compõe

- DilettaAvatar
- DilettaIcon
- DilettaText
- DilettaTappable

## Requirements

### Requirement: rótulo liga a forma
Passar `rotulos` SHALL ligar a forma rotulada; sem eles, nome e banco SHALL não aparecer. A forma é uma
consequência do dado, não um parâmetro à parte.
''';

const _grupoDoDia = r'''
## Purpose

O grupo de um dia no extrato: a data, o saldo consolidado do dia à direita dela, e os lançamentos
separados por fio.

## Guidelines

### Quando usar
Numa coleção agrupada por data em que o grupo carrega um VALOR no cabeçalho. É a única razão de esta
peça existir em vez do `DilettaAppList`, que tem `title` e não tem onde pôr o valor.

### Faça
- passe os lançamentos como `linhaDeValor` — o grupo é o envelope, a linha é o dado
- deixe o acessório mostrar o saldo do dia, não o do mês

### Evite
- usar como lista comum: sem acessório, `DilettaAppList` é a peça certa e traz o resto de graça

## Compõe

- DilettaDivider
- DilettaText

## Requirements

### Requirement: N lançamentos, N-1 fios — e UM leva fio
O fio SHALL vir depois de cada lançamento menos o último, E SHALL vir no dia de lançamento único,
onde ele fecha o grupo por baixo em vez de separar dois itens.

### Requirement: o fio é do tema
O separador SHALL ser o `DilettaDivider`. Cor de fio escrita à mão foi o defeito de 10/08: branco a
12% cravado, legível no escuro e invisível no claro.
''';

const _cartaoDaConta = r"""
## Purpose

O cabeçalho da tela de Conta: nome da conta, selo do tipo, o NÚMERO em manchete e a linha de agência
com banco. É o cartão que a pessoa abre pra ler o número em voz alta.

## Guidelines

### Quando usar
Uma vez, no topo da tela de conta. Não é resumo de conta em lista — ali a linha de lista basta.

### Faça
- passe o número já com o dígito separado: a formatação é do produto
- deixe o nome vazio quando a listagem ainda carrega — o rótulo genérico segura o lugar

### Evite
- pôr o saldo aqui: esta tela é sobre a IDENTIDADE da conta, e saldo tem card próprio na home
- tirar o espaçamento entre letras do número: dígito colado se lê errado quando é ditado

## Compõe

- DilettaGlassSurface
- DilettaStatusTag
- DilettaIcon
- DilettaText

## Requirements

### Requirement: nome vazio não colapsa a linha
Com nome vazio o componente SHALL desenhar "Conta". Linha que some muda a altura do cartão entre
dois carregamentos e faz a tela pular.
""";

const _cartaoDePedido = r"""
## Purpose

O cartão de um pedido esperando assinatura, visto por quem aprova. Responde quatro perguntas na
ordem em que elas são feitas: quem pediu e quanto, quanto falta pra sair, por que precisa de mim, e
o que eu faço.

## Guidelines

### Quando usar
Na fila de pendentes e no detalhe de uma pendência. É a peça da conta PJ com alçada.

### Faça
- deixe o CRIADOR ser o protagonista da linha de cima; o destinatário vai no detalhe
- mostre a IDADE da pendência quando não houver prazo no contrato — contagem regressiva inventada
  mente sobre o que o backend sabe
- escreva o motivo com a origem e o escopo da regra: é o que responde "por que eu?"

### Evite
- desabilitar os botões pra quem já assinou: use `jaAprovei`, que troca as ações por uma linha de
  estado. Botão cinza convida a tentar, e não há o que fazer
- repetir o valor no detalhe — ele já está à direita, em peso 800

## Compõe

- CoreflowProgressoDeAprovacao
- CoreflowPrazoDaPendencia
- DilettaButton
- DilettaCardSurface
- DilettaIcon
- DilettaText

## Requirements

### Requirement: já aprovei não tem botão
Com `jaAprovei` o cartão SHALL trocar as duas ações por uma linha de estado, e SHALL não desenhar
botão desabilitado.

### Requirement: rejeitar é o tipo secundário
A ação destrutiva SHALL sair como `secondary`, não como tipo próprio. São 16 sítios de destrutivo no
app e nenhum deles é um tipo — a medição é do botão.
""";

const _grade = r"""
## Purpose

O container de LINHA: põe blocos lado a lado onde a gramática do catálogo empilharia. É o menu 2×2
da home, a grade de 3 colunas da Área Pix e a fileira de chips do extrato.

## Guidelines

### Quando usar
Quando os itens são EQUIVALENTES e a comparação entre eles é o ponto. Lista de destinos com
subtítulo continua sendo lista — grade é pra item que cabe num rótulo.

### Faça
- use `2` ou `3` colunas quando os itens devem ter a MESMA largura (menu de ladrilhos)
- use `fileira` quando cada item tem largura própria (chips, botões curtos)
- mantenha o vão igual ao ritmo da tela — `s4` na home, `s2` entre chips

### Evite
- passar de 3 colunas: o rótulo encurta e a grade vira adivinhação
- aninhar grade em grade — isso é layout, e layout aninhado é o que este vocabulário existe pra
  evitar

## Compõe

- DilettaFrame.column
- DilettaFrame.row

## Requirements

### Requirement: a última linha ímpar não estica
Com `2` ou `3` colunas e um número ímpar de itens, o último SHALL ocupar UMA célula e não a linha
inteira. A célula que sobra é vazia de propósito.

### Requirement: fileira e colunas são coisas diferentes
Em `fileira` o item SHALL manter a largura própria; em `2`/`3` ele SHALL herdar a da célula. Não é
estética: no primeiro caso o item decide, no segundo a grade decide.
""";

const _amostraDeFundo = r'''
## Purpose

O retrato de um dos moods de `CoreflowBackdrop`, com rótulo e marca de escolha. É a peça com que a tela de
Aparência oferece os cinco fundos personalizáveis.

## Guidelines

### Quando usar
Seletor de FUNDO, e só ele. Escolha de tema (Claro · Escuro · Do sistema) é lista de linhas com check
(`linhaDeEscolha`), porque tema é rótulo e fundo é imagem — mostrar tema em quadradinho obriga a
adivinhar, e mostrar fundo em lista de texto esconde o que se está escolhendo.

### Faça
- desenhe o fundo pelo `CoreflowBackground.fixo`: é o construtor que faz o mood DECLARADO vencer a escolha
  da pessoa, e sem ele as cinco amostras pintam o fundo já escolhido — escolher outro muda as cinco
- ofereça os moods de PERSONALIZAÇÃO, e não os sete valores do enum: `solido` é o fundo dos fluxos
  empurrados, decisão de tela, não gosto de quem usa

### Evite
- marcar a escolha só pelo anel: o anel é cor, e cor sozinha não é informação
- deixar o anel sumir no não escolhido: transparente e não ausente, senão o retrato pula 5 pixels ao
  ser tocado
- cravar tamanho de fonte no rótulo: ele é `DilettaType.labelSm`, e o 10px do aparelho não é degrau da
  escada

## Compõe

- CoreflowBackground.fixo
- DilettaIcon
- DilettaText
- DilettaTappable

## Requirements

### Requirement: o declarado vence a escolha
A amostra SHALL desenhar o mood que recebe, ignorando o `CoreflowBackdropScope`. Seletor em que toda opção
parece a atual não é seletor.

### Requirement: a escolha é marcada em três canais
O estado escolhido SHALL somar anel, check e peso 700 no rótulo. Nenhum dos três sozinho responde por
quem não distingue as duas tintas.

### Requirement: mood novo entra com amostra
Valor novo em `CoreflowBackdrop` que seja personalizável SHALL ganhar amostra no mesmo commit. Mood que
existe e ninguém consegue escolher é mood que só o código sabe que tem.
''';

const _navFlutuante = r"""
## Purpose

A navegação da home: pílula de vidro FLUTUANTE que abraça os itens, com o ativo num spot cheio de
`primary`. É o rodapé da home e das telas empilhadas sobre ela.

## Guidelines

### Quando usar
Navegação entre abas da home. Rodapé de CTA é `barraDeBaixo` (`.button`), e barra de navegação
ANCORADA full-width é a `nav` daquela união — que é outro desenho, do pai, e não o deste produto.

### Faça
- passe ícone em TODO item: a pílula é glifo em cima e rótulo embaixo, e item sem glifo deixa um vazio
  redondo onde a fila tem um spot
- declare o `indicadorDeHome` ao lado dela na tela: a pílula flutua com margem de 16 e NÃO traz o traço
  de home por dentro, ao contrário de toda variante do `DilettaBottomApp`
- deixe o índice ativo fora da lista quando nenhuma aba é a atual — é o caso da tela empilhada sobre a
  home, e nenhum spot acende

### Evite
- trocar por `DilettaBottomApp.nav` achando que é a mesma peça: aquela é ancorada, full-width, com os
  itens em `Expanded` e o círculo do ativo estourando a borda de cima. Trocar é decisão de PRODUTO, e
  foi um print que achou a divergência — nenhum gate mede qual das duas a tela usa
- pintar o rótulo do ativo com a cor da marca: ele fica no ink do tema nos dois estados, e quem marca a
  escolha é o spot mais o peso
- pôr a sombra dentro do clip do vidro: atrás de um `BackdropFilter` ela é reamostrada pelo blur e vira
  halo

## Compõe

- DilettaGlassSurface
- DilettaFrame
- DilettaIcon
- DilettaText
- DilettaTappable

## Requirements

### Requirement: hug, e não fill
A pílula SHALL abraçar os itens e crescer com eles, centrada, com margem de baixo. Barra que ocupa a
largura inteira é a do pai — e é outro desenho.

### Requirement: o círculo do inativo é transparente, não ausente
O item inativo SHALL manter o mesmo espaço do spot. Sem ele a fila desalinha ao trocar de aba.

### Requirement: a sombra mora FORA do clip
A elevação SHALL ser aplicada no container externo ao `ClipRRect` do vidro.
""";

const _cartao = r'''
## Purpose

A superfície padrão deste produto: fundo, hairline e raio 24. É onde quase todo conteúdo mora, e é o
componente com mais sítios no app.

## Guidelines

### Quando usar
Sempre que um bloco de conteúdo precisa se separar do fundo. Se a superfície é a página inteira, o
componente é a página; se é um pedaço dela, é este.

### Faça
- diga ESCOLHIDO por `selecionado`, e não engrossando a borda à mão: é borda `primary` mais fundo
  `primaryWash`, e é o jeito único desta linguagem desde 02/09
- use `semBorda` quando o cartão for só agrupamento de fundo — a borda é o default porque um cartão
  deste produto tem fio, mas nem todo agrupamento é cartão
- deixe a elevação por MATERIAL (o vidro, a superfície elevada); a sombra é exceção com sítio contado

### Evite
- passar `borderColor` pra dizer escolhido: dois jeitos de dizer a mesma coisa é um jeito a mais, e
  foi assim que cinco telas acabaram com quatro espessuras diferentes
- desenhar um `BoxDecoration` equivalente na tela: o que se perde é o material do pai e o raio da
  escada

## Compõe

- DilettaCardSurface
''';

const _disco = r'''
## Purpose

O círculo que SEGURA alguma coisa, com anel opcional. Ele não sabe de estado — só de forma.

## Guidelines

### Quando usar
Quando o conteúdo é redondo por decisão de layout: avatar improvisado, número dentro de um círculo,
glifo que não é de estado.

### Faça
- deixe `tamanho` nulo quando o filho já tem tamanho próprio — o disco se ajusta a ele
- use o anel pra marcar presença sem preencher: preencher esconde o que está dentro

### Evite
- usá-lo onde o conteúdo é um GLIFO DE ESTADO: aí a peça é o spot, que carrega o tom junto
- substituir o `CircleAvatar` do Material por um disco com foto sem conferir o recorte

## Compõe

- DilettaBox
''';

const _ponto = r'''
## Purpose

O marcador redondo, do tamanho que o sítio pedir. Nasceu de seis lugares desenhando o mesmo círculo
com números diferentes.

## Guidelines

### Quando usar
Como marcador de presença ou de item numa lista curta — o ponto ao lado de um nome, o sinal de "há
algo novo".

### Faça
- passe a cor pelo esquema; o ponto não tem cor própria porque o significado é do sítio
- mantenha o 8 quando não houver razão medida pra outro número

### Evite
- montar uma fileira deles à mão pra indicar página: a peça disso é o indicador de página, que sabe
  alongar o ativo
- inventar um tamanho novo sem medir o sítio: os seis que existiam mediam 3 · 6 · 7 · 7 · 8 · 10, e
  foi por isso que este eixo é número livre e não escada

## Compõe

- DilettaBox
''';

const _pegador = r'''
## Purpose

A alça da folha: a barrinha que diz "isto arrasta". Sem eixo nenhum, de propósito.

## Guidelines

### Quando usar
No topo de qualquer folha que a pessoa possa arrastar pra fechar.

### Faça
- deixe-a no topo, centrada, antes do cabeçalho
- confie no componente: ele tinha DOIS cinzas diferentes no app antes de virar peça, e o eixo que
  não existe é o que impede o terceiro

### Evite
- desenhá-la à mão pra "ajustar um pouco" a cor ou a largura
- pôr alça em folha que não arrasta: a alça é promessa de gesto

## Compõe

- DilettaBox
''';

const _heroi = r'''
## Purpose

O disco grande do topo de uma folha de confirmação — o glifo que resume o que acabou de acontecer.

## Guidelines

### Quando usar
Uma vez por folha, no topo, quando o desfecho precisa ser lido antes do texto.

### Faça
- escolha o estado pelo DESFECHO e não pela cor que fica bonita: sucesso, erro e atenção têm papel
- deixe-o sozinho na sua linha; ele é o ponto de entrada visual da folha

### Evite
- usar dois na mesma tela — dois heróis não são hierarquia, são confusão
- usá-lo como ícone de lista: o tamanho dele é a razão de ele existir

## Compõe

- DilettaSpotIcon
''';

const _busca = r'''
## Purpose

Campo de uma linha com a lupa dentro. Filtra o que já está na tela — não busca no servidor sem
aviso.

## Guidelines

### Quando usar
Numa lista longa o bastante para a pessoa não achar o item rolando.

### Faça
- deixe o controller na tela: o texto é estado dela, não do componente
- use `error` pra pintar a borda; a MENSAGEM de uma busca sem resultado é a lista vazia, e ela mora
  abaixo

### Evite
- pôr texto de erro sob o campo: duplica o que o resultado vazio já diz
- usá-lo com menos de dez itens — buscar em cinco é mais trabalho que ler cinco

## Compõe

- DilettaInput
''';

const _campoDeValor = r'''
## Purpose

O campo de dinheiro. Formata enquanto se digita e devolve número, não texto.

## Guidelines

### Quando usar
Sempre que a pessoa digitar um valor em reais.

### Faça
- use `large` na tela em que o valor É a tela — transferência, recarga, cobrança
- deixe o teclado numérico abrir com a tela: o campo é a única coisa a fazer ali

### Evite
- montar máscara à mão em cima de um campo de texto: a formatação e o cursor são o trabalho todo
- usar o porte grande dentro de um formulário com outros campos, onde ele vira grito

## Compõe

- DilettaInput
''';

const _botoesDeNavegacao = r'''
## Purpose

O par de ações do rodapé: primária, secundária e uma terceira em texto. A ORDEM e o respiro são da
peça.

## Guidelines

### Quando usar
No fim de um passo que continua ou volta.

### Faça
- ponha a ação que AVANÇA como primária, sempre — mesmo quando voltar é mais provável
- deixe a secundária nula quando não houver volta: um botão sozinho é o par com um lado

### Evite
- empilhar dois botões à mão: quatro espaçamentos diferentes foi o que existia antes desta peça
- usar a terceira em texto para algo destrutivo — texto não carrega peso de aviso

## Compõe

- CoreflowBotao
''';

const _painelDeEntrada = r'''
## Purpose

O vidro da tela de entrada: a superfície que segura o formulário sobre a arte de fundo.

## Guidelines

### Quando usar
Uma vez por tela de entrada, envolvendo o que a pessoa preenche.

### Faça
- deixe a arte aparecer por baixo — é o motivo de a superfície ser vidro e não cor chapada
- mantenha o conteúdo curto: o painel é a dobra inteira em telas pequenas

### Evite
- usá-lo como cartão genérico: o vidro é do momento de entrar, e repetido vira textura
- empilhar dois na mesma tela

## Compõe

- DilettaGlassSurface
''';

const _anelDeEscolha = r'''
## Purpose

O SEGUNDO jeito de dizer escolhido, e o único que se justifica: quando o miolo é justamente o que a
pessoa está escolhendo.

## Guidelines

### Quando usar
Sobre um retrato, uma foto ou uma arte que a pessoa seleciona. Se o conteúdo é texto, o jeito é o
`selecionado` do cartão.

### Faça
- deixe o anel transparente quando não escolhido, e não ausente: sem isso a peça pula cinco pixels
  ao ser tocada e a fileira inteira se reorganiza
- combine o raio com o do recorte de dentro

### Evite
- usá-lo onde o `selecionado` do cartão serve: dois jeitos de dizer escolhido é um jeito a mais
- deixá-lo fino demais — ele compete com uma imagem embaixo, não com cor chapada

## Compõe

- DilettaBox
''';

const _faixaDeOperacao = r'''
## Purpose

"Usando a conta de X." Avisa que o que se fizer nesta tela é em nome de outra pessoa.

## Guidelines

### Quando usar
Em toda tela de uma sessão operada — o aviso não é por fluxo, é por contexto.

### Faça
- deixe-a acima do conteúdo, ocupando a linha: ela é condição da tela, não item dela
- dê o toque de trocar de conta quando houver para onde trocar

### Evite
- escondê-la em telas "sem risco": o que define o risco é quem opera, não o que a tela faz
- repeti-la dentro do conteúdo

## Compõe

- DilettaIcon
''';

const _pagina = r'''
## Purpose

A moldura de uma tela deste produto: barra de topo, corpo com teto de largura e rodapé opcional.

## Guidelines

### Quando usar
Em toda tela que não é folha nem overlay.

### Faça
- deixe o teto de largura fazer o trabalho: o corpo já não atravessa um tablet
- ponha a ação principal no rodapé da página, não no fim do scroll — teclado aberto cobre o fim do
  scroll e não cobre o rodapé

### Evite
- desenhar uma barra de topo dentro do corpo: a página já tem uma, e duas barras é o defeito que o
  gate de chrome existe pra pegar
- usá-la dentro de outra página

## Compõe

- DilettaNavigationTopBar
''';

const _folhaDoProduto = r'''
## Purpose

O cartão que sobe de baixo: pegador, título e fechar, com o corpo rolando dentro.

## Guidelines

### Quando usar
Para uma decisão curta que não merece trocar de tela — confirmar, escolher entre poucos, explicar.

### Faça
- dê sempre um jeito de fechar: o X e o arrasto são a mesma promessa em dois gestos
- mantenha o conteúdo curto o bastante para caber sem rolar em telas médias

### Evite
- pôr um formulário longo numa folha: com o teclado aberto sobra meia tela
- abrir folha sobre folha

## Compõe

- DilettaSheetOverlay
''';

const _acaoDeRodape = r'''
## Purpose

A ação da base da página, com o par secundário opcional.

## Guidelines

### Quando usar
No rodapé de uma página que tem uma ação principal.

### Faça
- desligue por `enabled` quando o passo não está pronto: botão que some muda a altura da tela
- use `accent` só onde a ação é a razão da tela

### Evite
- dois primários no mesmo rodapé
- esconder a secundária quando ela é a saída: sem ela a página vira beco

## Compõe

- CoreflowBotao
''';

const _cabecalhoDeFolha = r'''
## Purpose

Pegador mais fechar, sem título — o topo de uma folha cujo conteúdo já se explica.

## Guidelines

### Quando usar
Em folha cujo primeiro elemento do corpo já diz o que ela é: um herói, um valor grande, uma arte.

### Faça
- prefira a folha com título quando o conteúdo não se apresenta sozinho

### Evite
- usá-lo e repetir o título logo abaixo, com outro tamanho: aí o título é da folha

## Compõe

- CoreflowPegador
''';

const _fecharFolha = r'''
## Purpose

O X da folha, com o rótulo de leitor de tela embutido.

## Guidelines

### Quando usar
Sempre que uma camada precisar de saída explícita.

### Faça
- deixe o rótulo acessível dizendo o que fecha quando "Fechar" for ambíguo

### Evite
- trocá-lo por um "Cancelar" em texto no topo: o X é o gesto que a pessoa procura no canto

## Compõe

- DilettaIconButton
''';

const _larguraDeConteudo = r'''
## Purpose

O teto de largura do corpo: o que impede uma linha de texto de atravessar um tablet inteiro.

## Guidelines

### Quando usar
Em volta de conteúdo de leitura, quando a página não o aplica sozinha.

### Faça
- deixe-o envolver o conteúdo, não a tela: o fundo continua indo de borda a borda

### Evite
- usá-lo em volta de uma lista que já rola com padding próprio — dois tetos é um a mais

## Compõe

- DilettaBox
''';

const _esperando = r'''
## Purpose

A cortina que escurece o conteúdo enquanto algo carrega, sem tirá-lo da tela.

## Guidelines

### Quando usar
Numa espera curta em que a pessoa precisa continuar vendo o que pediu.

### Faça
- mantenha o conteúdo por baixo: sumir com ele e voltar é troca de tela, não espera
- deixe o escurecimento padrão; ele foi escolhido pra dizer "bloqueado" sem apagar

### Evite
- usá-lo em espera longa — acima de alguns segundos o certo é um estado com texto
- empilhar dois

## Compõe

- DilettaBox
''';

const _rodapeDoProduto = r'''
## Purpose

A base fixa da página: os botões que não somem quando o conteúdo rola nem quando o teclado abre.

## Guidelines

### Quando usar
Em toda página com uma ação que conclui o passo.

### Faça
- deixe a ação aqui e não no fim do scroll: com o teclado aberto, o fim do scroll fica embaixo dele
- use a linha `acima` para o que precisa ser lido ANTES de decidir — saldo, taxa, prazo

### Evite
- encher o rodapé: acima de duas ações ele deixa de ser base e vira menu
- repetir no rodapé um botão que já está no corpo

## Compõe

- CoreflowBotao
''';

const _corpoDeFolha = r'''
## Purpose

A superfície interna da folha, com a cor dela — o que separa o conteúdo do fundo da camada.

## Guidelines

### Quando usar
Dentro de uma folha montada peça a peça, quando a folha inteira não serve.

### Faça
- prefira a folha completa quando ela couber: ela já traz pegador, título e fechar

### Evite
- usá-lo fora de uma folha: a cor dele é da camada, e sobre a página ele lê como cartão errado

## Compõe

- DilettaBox
''';

const _larguraInteira = r'''
## Purpose

Devolve a largura de borda a borda a um filho que está dentro de uma região com teto de leitura.

## Guidelines

### Quando usar
Para o que NÃO é texto: uma faixa, um divisor, uma arte de fundo, um carrossel.

### Faça
- use-o só no elemento que precisa atravessar, e não em volta de um bloco inteiro

### Evite
- usá-lo em texto: o teto existe porque linha longa não se lê, e devolvê-lo desfaz a razão dele

## Compõe

- DilettaBox
''';

const _paginaDeResumo = r'''
## Purpose

A tela de comprovante inteira: valor grande, estado da transação e as seções de detalhe.

## Guidelines

### Quando usar
No desfecho de um pagamento ou transferência, quando a pessoa precisa ver o que aconteceu e guardar.

### Faça
- deixe o ESTADO decidir a cor e o glifo: comprovante de coisa que falhou não sai com disco verde
- mantenha as seções vindo de dado — um comprovante é o que o servidor devolveu

### Evite
- inventar campo que o servidor não mandou pra "ficar completo"
- usá-la como página de revisão ANTES de confirmar: ali a decisão ainda é da pessoa, e o valor
  grande com estado sugere que já acabou

## Compõe

- CoreflowComprovante
''';

const _paginaComRodapeFlutuante = r'''
## Purpose

A variante em que a ação PAIRA sobre o conteúdo em vez de sentar numa base opaca.

## Guidelines

### Quando usar
Quando a base da tela é conteúdo que não pode ser tapado: mapa, câmera, lista que continua embaixo.

### Faça
- use-a só nessas telas; na página comum a base opaca é melhor, porque separa a ação do conteúdo

### Evite
- pôr texto pequeno atrás do botão flutuante: o que fica atrás dele não se lê
- usá-la e depois somar um rodapé fixo — a ação passa a existir duas vezes

## Compõe

- CoreflowPagina
''';
