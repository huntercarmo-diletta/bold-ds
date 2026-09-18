import 'coreflow_vinho.dart';
import 'coreflow_vocabulario.dart';
import 'package:flutter/material.dart' show Brightness, Color, ThemeData;

import 'coreflow_gradients.dart';
import 'coreflow_scheme.dart';
import 'coreflow_tema_material.dart';
import 'package:diletta_design_system/diletta_design_system.dart';

/// UM PRODUTO FEITO COM ESTE DS — paleta e marca, e tudo o mais deriva.
///
/// Esta classe é **a porta que não existia**. Até 20/08 os atalhos de tema do primeiro produto
/// cravavam a paleta dele em quatro pontos, e o único lugar parametrizado da pilha era o
/// [CoreflowScheme.de] — que aceita paleta e **não tinha ninguém acima dele que aceitasse**. Medido: um
/// filho do Bold conseguia montar o ESQUEMA com a paleta dele e não conseguia registrá-lo como
/// `ThemeExtension`, que é de onde os ~500 `CoreflowScheme.of(context)` leem. Parava na porta com a
/// chave na mão.
///
/// Um produto novo escreve duas coisas e recebe as quatro:
///
/// ```dart
/// final meu = CoreflowProduto(paleta: minhaPaleta, marca: minhaMarca);
///
/// MaterialApp(
///   theme: meu.materialClaro,
///   darkTheme: meu.materialEscuro,
///   builder: (_, filho) => DilettaThemeScope(theme: meu.claro, child: filho!),
/// )
/// ```
///
/// **O par claro/escuro sai do mesmo objeto de propósito.** O `///` do [CoreflowTemaMaterial] já dizia
/// *"os dois saem da mesma paleta, e o app monta os dois do mesmo brilho"* — era invariante escrita
/// em prosa, e aqui ela é estrutura: não existe caminho que monte o `ThemeData` de uma paleta e o
/// `DilettaTheme` de outra.
///
/// Os quatro são **cacheados por instância** (`late final`), e isso não é otimização: o
/// `DilettaThemeScope` decide rebuild comparando o tema, então devolver instância nova a cada
/// leitura faria a árvore inteira remontar a cada frame.
class CoreflowProduto {
  CoreflowProduto({
    required this.paleta,
    required this.marca,
    this.tipografia = CoreflowTipografia.doAvo,
    this.ajustesDePapel = const [],
    CoreflowGradients? gradientes,
  }) : _gradientes = gradientes;


  /// UM FILHO DO COREFLOW NASCE COM **UMA COR** — e herda a gramática, não a identidade.
  ///
  /// ```dart
  /// final meuBanco = CoreflowProduto.daMarca(
  ///   marca: const Color(0xFF1B5E20),
  ///   id: 'meuBanco',
  ///   nome: 'Meu Banco',
  /// );
  ///
  /// MaterialApp(
  ///   theme: meuBanco.materialClaro,
  ///   darkTheme: meuBanco.materialEscuro,
  ///   builder: (_, filho) => DilettaThemeScope(theme: meuBanco.claro, child: filho!),
  /// );
  /// ```
  ///
  /// ## O que ele HERDA, e por que isso não é preguiça
  ///
  /// A **gramática do material** deste DS ([CoreflowGramatica]): card de vidro, botão de canto 16,
  /// folha de canto 22, blur 15. Essas não são identidade de produto nenhum — são o jeito deste
  /// sistema montar superfície, e é o que faz um produto novo PARECER Coreflow em vez de parecer
  /// Material puro pintado de outra cor.
  ///
  /// Também nasce com o **vocabulário extra** (superfície elevada, pressionada, fluxo secundário,
  /// informação e o vinho) DECLARADO, pela regra da linguagem sobre a rampa dele
  /// ([CoreflowVocabulario.extrasDe], [CoreflowVinho.derivadosDe]). Até 04/09 esses vinham copiados
  /// do primeiro produto como reserva — um navy que era decisão de marca dele. Quem discordar declara
  /// o seu — a paleta é o lugar, e `comMaterial` é o caminho.
  ///
  /// ## O que DERIVA da cor dele
  ///
  /// A rampa de marca inteira, pelo [DilettaRampa] do pai — nove degraus em OKLCH com o croma
  /// limitado ao gamute. E as três coisas de material que carregam a marca:
  ///
  /// | o quê | de onde sai |
  /// |---|---|
  /// | tinte do vidro ESCURO | o degrau 01 da marca dele a 50% |
  /// | traço do vidro CLARO | o degrau 08 dele |
  /// | traço do vidro ESCURO | o degrau 06 dele a 30% |
  /// | brilho do esqueleto | os degraus 05 e 02 |
  ///
  /// ## O que ele NÃO herda
  ///
  /// A MARCA visual: logo, mapa da arte e os hexes. Sem declaração, `DilettaBrand.nenhuma`: os
  /// componentes desenham, e os que precisam de arquivo de marca somem em vez de quebrar. Até 08/09
  /// o default era a marca do primeiro produto — filho gerado nascia com o lockup do outro.
  ///
  /// O primeiro produto desta casa não mora aqui: ele é uma INSTÂNCIA desta classe, declarada no
  /// pacote dele com o nome dele (veredito de 08/09, decisão 1: sem atalho de produto com nome de
  /// linguagem, e sem sombra homônima).
  ///
  /// Cor semântica também não: erro, aviso, sucesso, cofre e a rampa neutra vêm da referência do
  /// pai, porque cor semântica é invariante nesta linguagem.
  factory CoreflowProduto.daMarca({
    required Color marca,
    required String id,
    required String nome,
    DilettaBrand? marcaVisual,
    CoreflowTipografia tipografia = CoreflowTipografia.doAvo,
    CoreflowGradients? gradientes,
    List<DilettaAjusteDePapel> ajustesDePapel = const [],
  }) {
    final rampa = DilettaRampa.daMarca(marca);
    final so = DilettaPalette.daMarca(marca: marca, id: id, nome: nome);
    final paleta = so.comMaterial(
      // A GRAMÁTICA, da linguagem.
      cardDeVidro: CoreflowGramatica.cardDeVidro,
      raioDeBotao: CoreflowGramatica.raioDeBotao,
      raioDeFolha: CoreflowGramatica.raioDeFolha,
      // A FORMA POR FAMÍLIA, na tabela que o veredito de 14/09 abriu (`ds v0.194.0`). Os dois de
      // cima continuam campo porque são a grafia antiga da mesma decisão e o avô os mantém como
      // alias; as três de baixo só existem aqui. **Um filho gerado passa a poder declarar a forma
      // da Home inteira** — que é cartão, vidro e nav, e não o botão, que a Home não tem.
      medidas: const {
        DilettaMedida.formaDeCartao: CoreflowGramatica.raioDeCartao,
        DilettaMedida.formaDeVidro: CoreflowGramatica.raioDeVidro,
        DilettaMedida.formaDeNav: CoreflowGramatica.raioDaNav,
      },
      blurDeVidro: CoreflowGramatica.blurDeVidro,
      // O vocabulário extra, DECLARADO pela regra da linguagem sobre a rampa dele: superfície
      // elevada, pressionada, fluxo secundário, informação — e o vinho, refeito nos mesmos pontos da
      // rampa em que ele cai na do primeiro produto. Nada aqui é copiado de outro produto: um banco
      // verde herdando o vinho de um banco rosa teria vidro escuro vermelho.
      papeisExtras: {
        ...CoreflowVocabulario.extrasDe(so),
        ...CoreflowVinho.derivadosDe(so),
      },
      // O MATERIAL QUE CARREGA A COR, derivado da marca dele.
      tinteDeVidroClaro: CoreflowGramatica.tinteDeVidroClaro,
      tinteDeVidroEscuro: rampa[0].withValues(alpha: 0.50),
      tracoDeVidroClaro: rampa[7],
      tracoDeVidroEscuro: rampa[5].withValues(alpha: 0.30),
      brilhoDoEsqueletoClaro: rampa[4],
      brilhoDoEsqueletoEscuro: rampa[1],
    );
    return CoreflowProduto(
      paleta: paleta,
      // SEM marca declarada, nenhuma — não a do primeiro produto. Era a marca dele como reserva, e um filho
      // gerado nascia com o lockup do Bold. O `///` do avô diz o comportamento: um tema sem marca
      // desenha os componentes todos, menos os que precisam de um arquivo de marca; esses somem em
      // vez de quebrar. (Veredito de 08/09, item 1: "uma linha, hoje".)
      marca: marcaVisual ?? DilettaBrand.nenhuma,
      tipografia: tipografia,
      gradientes: gradientes,
      ajustesDePapel: ajustesDePapel,
    );
  }

  /// A rampa deste produto. Todo papel de cor sai dela.
  final DilettaPalette paleta;

  /// O plugue de marca: logo, e o mapa hex→degrau das artes deste produto.
  final DilettaBrand marca;

  /// Os AJUSTES DE PAPEL POR COMPONENTE deste produto — adaptação limitada, não slot livre.
  ///
  /// A linguagem permite um produto dizer *"neste componente, o papel X passa a ler o Y"*, com `de` e
  /// `para` da mesma família e um motivo declarado. Serve pra marca e pra contraste, e o avô fecha o
  /// escopo no `///` dele: *"nunca uma coisa muito fora disso"*.
  ///
  /// **Estava chegando em lugar nenhum até 14/09.** O `DilettaTheme.resolve` aceita a lista desde
  /// sempre, e este produto montava o tema sem passá-la — então um filho do Coreflow podia declarar
  /// ajuste e nada acontecia, nem no Flutter. Achado indo construir o lado WEB do mecanismo: não dá
  /// pra emitir CSS de um eixo que o Dart não liga.
  ///
  /// Do lado web o ajuste vira cascata — `coreflowAjustesCss` emite `<tag> { --cps-de: var(--cps-para) }`
  /// —, e o gate de paridade cobra que os dois lados apliquem o mesmo.
  final List<DilettaAjusteDePapel> ajustesDePapel;

  /// A tipografia deste produto: a família (uma vez) e os degraus que o `ThemeData` recebe.
  final CoreflowTipografia tipografia;

  /// ONDE OS ASSETS DO PAI MORAM — uma linha, e sem ela nenhum ícone do pai aparece.
  ///
  /// `DilettaAssets.assetPackage` nasce `null`, que significa "assets na raiz do bundle". Num app
  /// que CONSOME o pacote eles moram em `packages/diletta_design_system/…`, então o
  /// `AssetBytesLoader` procura no lugar errado. E `VectorGraphic` com asset ausente **não
  /// estoura**: desenha caixa vazia.
  ///
  /// Chegou como *"os ícones não estão aparecendo no app"*, depois de a adoção trocar
  /// `IconButton` do app por `DilettaIconButton`: as setas de voltar, os ícones da home e o `>` do
  /// extrato sumiram juntos. Nada falhou — nem `analyze`, nem a suíte inteira, nem o console.
  ///
  /// **Fica AQUI e não no `main` do app**: quem liga o DS é quem sabe onde o DS guarda coisa. No
  /// `main` isso é uma linha que todo app novo tem que lembrar de copiar — e o primeiro filho, que
  /// resolveu no `main` do catálogo dele, tem o mesmo buraco de um lado só.
  static void _garanteOsAssetsDoPai() {
    DilettaAssets.assetPackage ??= DilettaAssets.package;
  }

  /// O esquema de cor deste produto no claro — os papéis que as peças do pacote leem.
  late final CoreflowScheme esquemaClaro =
      CoreflowScheme.de(paleta, brilho: Brightness.light, gradientes: gradientes);

  /// O esquema de cor deste produto no escuro.
  late final CoreflowScheme esquemaEscuro =
      CoreflowScheme.de(paleta, brilho: Brightness.dark, gradientes: gradientes);

  /// A MARCA que vai no tema de cada modo — e é aqui que as letras do lockup param de ser rosa.
  ///
  /// O `DilettaLogo` do pai pinta o `currentColor` do arquivo com `color ?? brand.corDoLogo ??
  /// scheme.primary`. A marca do Bold não declarava `corDoLogo`, nenhuma das cinco telas do app que
  /// mostram o lockup passa `color`, e as 8 letras saíam no `primary`: rosa, nos dois modos, sobre
  /// qualquer fundo. Pedido da dona do produto (09/09): *"que as letras do logo sigam branco/preto
  /// dependendo do tema e da necessidade da tela, não rosa"*.
  ///
  /// A cor é decidida POR MODO porque `DilettaBrand.corDoLogo` é uma cor só, e quem sabe o brilho é o
  /// tema: preto absoluto no claro, branco absoluto no escuro. O que NÃO muda: o gradiente do "O" (é do
  /// arquivo, e `currentColor` não o alcança) e a tela que precisa de outra tinta — fundo fixo escuro,
  /// hero de marca —, que segue passando `color:` ao `DilettaLogo`, e `color` vence tudo.
  ///
  /// A regra só preenche AUSÊNCIA: produto que declara `corDoLogo` na marca é respeitado. Vale pra todo
  /// filho do Coreflow, não só pro Bold — logo em tinta de texto é o caso comum do white-label, e quem
  /// quiser o logo em cor de marca escreve isso na marca dele.
  ///
  /// Cópia campo a campo porque `DilettaBrand` não tem `copyWith`. O preço está escrito: um campo novo
  /// do pai que não estiver nesta lista chega no default no tema. Um `copyWith` no pai é o jeito de
  /// tirar isto daqui.
  ///
  /// **E o preço foi cobrado, em 17/09.** `nomeDaMarca` entrou no plugue depois desta lista e ninguém
  /// o acrescentou aqui: todo produto que não declara `corDoLogo` — o Bold inclusive — perdia o nome
  /// da marca ao montar o tema. O campo é o rótulo de leitor de tela da co-marca, e a peça do avô
  /// resolvia a ausência com o nome de OUTRO produto cravado (`?? "CPF Seguro"`, consertado por ele na
  /// `v0.185.0`) — então a perda daqui virava, na tela, o nome de outro cliente.
  ///
  /// O gate `a_marca_do_modo_nao_perde_campo_test` fecha a CLASSE, e não só este caso: ele conta os
  /// campos do plugue lendo o arquivo do avô e falha quando aparece um que esta lista não copia. Um
  /// `copyWith` no avô continua sendo o jeito de tirar isto daqui — está PEDIDO em
  /// `docs/pedidos/2026-09-17-a-copia-campo-a-campo-perde-campo-e-perdeu.md`.
  ///
  /// **E foi cobrado de novo no dia seguinte, com uma diferença que vale escrever.** O avô entregou
  /// `logoEscuro` e `logoFullEscuro` na `v0.196.0` — o veredito do pedido de 14/09 DESTA casa —, e em
  /// 17/09 o `ref:` subiu pra `v0.198.0` pela outra mão. **Os dois campos que nós mesmos pedimos não
  /// chegavam a filho nenhum**, porque esta lista não os copiava — e um filho desta safra já tinha
  /// nascido com a arte negativa declarada e inalcançável. O caso está medido na rodada de 18/09 de
  /// `docs/FILA-DOS-CHATS.md`, que é onde nome de produto pode aparecer.
  ///
  /// **A diferença é o gate.** Da primeira vez o campo sumiu calado e ninguém soube por seis telas; da
  /// segunda o teste ficou vermelho no merge em que o `ref:` entrou, dizendo os dois nomes. Não é a
  /// dívida resolvida — é a dívida deixando de ser silenciosa, que era o que ele prometia.
  ///
  /// *(E este parágrafo já custou um vermelho: a primeira versão dele citava o produto pelo nome e
  /// pelo caminho do arquivo, e o `o_coreflow_nao_cita_bold_test` reprovou — a régua lê comentário
  /// também, que é justamente por que ela existe.)*
  ///
  /// A ORDEM dos campos aqui é a do construtor do avô, de propósito: quem for conferir esta lista
  /// contra o arquivo dele lê as duas em paralelo.
  DilettaBrand marcaNo(Brightness brilho) {
    if (marca.corDoLogo != null) return marca;
    return DilettaBrand(
      pacote: marca.pacote,
      logo: marca.logo,
      logoFull: marca.logoFull,
      // O PAR POR BRILHO, entregue na `v0.196.0`. Sem estas duas linhas o par não atravessa o tema, e
      // um filho que declarasse o negativo veria o positivo nos dois modos — falha calada, no escuro.
      //
      // Não conflita com a `corDoLogo` logo abaixo: no avô, par declarado DESLIGA o `srcIn`
      // (`pinta = color != null || !temPar`), então a tinta que esta regra preenche deixa de alcançar o
      // desenho e a arte entra como o designer a desenhou. A precedência é dele: chamada > marca >
      // arquivo.
      logoEscuro: marca.logoEscuro,
      logoFullEscuro: marca.logoFullEscuro,
      logoParceiro: marca.logoParceiro,
      bandeiraDoCartao: marca.bandeiraDoCartao,
      carteirasDeSistema: marca.carteirasDeSistema,
      selosDeLoja: marca.selosDeLoja,
      nomeDaMarca: marca.nomeDaMarca,
      corDoLogo: brilho == Brightness.dark
          ? DilettaAbsoluteColors.white
          : DilettaAbsoluteColors.black,
      logoTingePorCurrentColor: marca.logoTingePorCurrentColor,
      proporcaoDoLockup: marca.proporcaoDoLockup,
      hexesDaArte: marca.hexesDaArte,
    );
  }

  /// O tema do PAI no claro — o que as peças dele leem pelo `DilettaThemeScope`.
  late final DilettaTheme claro = () {
    _garanteOsAssetsDoPai();
    return DilettaTheme.resolve(
        palette: paleta,
        brand: marcaNo(Brightness.light),
        ajustesDePapel: ajustesDePapel);
  }();

  /// O tema do PAI no escuro.
  late final DilettaTheme escuro = () {
    _garanteOsAssetsDoPai();
    return DilettaTheme.resolve(
        palette: paleta,
        brand: marcaNo(Brightness.dark),
        brightness: Brightness.dark,
        ajustesDePapel: ajustesDePapel);
  }();

  /// O `ThemeData` do Material no claro.
  late final ThemeData materialClaro = CoreflowTemaMaterial.de(esquemaClaro, tipografia: tipografia);

  /// O `ThemeData` do Material no escuro.
  late final ThemeData materialEscuro = CoreflowTemaMaterial.de(esquemaEscuro, tipografia: tipografia);

  /// Os gradientes deste produto — a curva do símbolo e a tinta que vai por cima.
  ///
  /// É o único campo do produto que **não** deriva inteiro da paleta: a curva do lockup é uma lista
  /// ordenada com offsets que saem do arquivo do logo, não uma rampa de degraus nomeados. Um produto
  /// com símbolo próprio passa a dele; quem não passa recebe [CoreflowGradients.daPaleta] — dois
  /// degraus da rampa DELE. Até 04/09 o default era a curva do primeiro produto, e um filho recebia o
  /// rosa→amarelo do outro no card de destaque.
  late final CoreflowGradients gradientes = _gradientes ?? CoreflowGradients.daPaleta(paleta);
  final CoreflowGradients? _gradientes;
}
