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
  }) {
    final rampa = DilettaRampa.daMarca(marca);
    final so = DilettaPalette.daMarca(marca: marca, id: id, nome: nome);
    final paleta = so.comMaterial(
      // A GRAMÁTICA, da linguagem.
      cardDeVidro: CoreflowGramatica.cardDeVidro,
      raioDeBotao: CoreflowGramatica.raioDeBotao,
      raioDeFolha: CoreflowGramatica.raioDeFolha,
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
    );
  }

  /// A rampa deste produto. Todo papel de cor sai dela.
  final DilettaPalette paleta;

  /// O plugue de marca: logo, e o mapa hex→degrau das artes deste produto.
  final DilettaBrand marca;

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
  DilettaBrand marcaNo(Brightness brilho) {
    if (marca.corDoLogo != null) return marca;
    return DilettaBrand(
      pacote: marca.pacote,
      logo: marca.logo,
      logoFull: marca.logoFull,
      logoParceiro: marca.logoParceiro,
      bandeiraDoCartao: marca.bandeiraDoCartao,
      carteirasDeSistema: marca.carteirasDeSistema,
      selosDeLoja: marca.selosDeLoja,
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
        palette: paleta, brand: marcaNo(Brightness.light));
  }();

  /// O tema do PAI no escuro.
  late final DilettaTheme escuro = () {
    _garanteOsAssetsDoPai();
    return DilettaTheme.resolve(
        palette: paleta,
        brand: marcaNo(Brightness.dark),
        brightness: Brightness.dark);
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
