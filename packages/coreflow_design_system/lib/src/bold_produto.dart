import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart' show Brightness, Color, ThemeData;

import 'bold_gradients.dart';
import 'bold_palette.dart';
import 'bold_scheme.dart';
import 'bold_tema_material.dart';

/// UM PRODUTO FEITO COM ESTE DS — paleta e marca, e tudo o mais deriva.
///
/// Esta classe é **a porta que não existia**. Até 20/08 o `CoreflowTheme` e o `CoreflowTemaMaterial`
/// cravavam `BoldPalette.bold` em quatro pontos, e o único lugar parametrizado da pilha era o
/// [CoreflowScheme.de] — que aceita paleta e **não tinha ninguém acima dele que aceitasse**. Medido: um
/// filho do Bold conseguia montar o ESQUEMA com a paleta dele e não conseguia registrá-lo como
/// `ThemeExtension`, que é de onde os ~500 `BoldColors.of(context)` leem. Parava na porta com a
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
  /// A **gramática do material** deste DS: card de vidro, botão de canto 16, folha de canto 22,
  /// blur 15, e as superfícies do escuro. Essas não são identidade do Conta BOLD — são o jeito
  /// deste sistema montar superfície, e é o que faz um produto novo PARECER Coreflow em vez de
  /// parecer Material puro pintado de outra cor.
  ///
  /// Também herda o **vocabulário extra** (superfície elevada, pressionada, fluxo secundário,
  /// informação e o vinho), como RESERVA. Quem discordar declara o dele — a paleta é o lugar, e
  /// `comMaterial` é o caminho.
  ///
  /// ## O que DERIVA da cor dele
  ///
  /// A rampa de marca inteira, pelo [DilettaRampa] do pai — nove degraus em OKLCH com o croma
  /// limitado ao gamute. E as três coisas de material que carregam a marca:
  ///
  /// | o quê | de onde sai |
  /// |---|---|
  /// | tinte do vidro ESCURO | o degrau 01 da marca dele a 50% — no Bold é vinho porque a marca do Bold é rosa |
  /// | traço do vidro CLARO | o degrau 08 dele, que é a mesma regra do Bold |
  /// | traço do vidro ESCURO | o degrau 06 dele a 30% |
  /// | brilho do esqueleto | os degraus 05 e 02, que é o que o Bold declara na marca dele |
  ///
  /// ## O que ele NÃO herda
  ///
  /// A MARCA visual: logo, mapa da arte e os hexes. O default é a do Conta BOLD e ele existe pra a
  /// primeira tela desenhar em vez de estourar — **um produto que for pra loja com o logo do Bold é
  /// um produto que não declarou a marca dele**, e o `assets` do pacote diz de quem é o arquivo.
  ///
  /// Cor semântica também não: erro, aviso, sucesso, cofre e a rampa neutra vêm da referência do
  /// pai, porque cor semântica é invariante nesta linguagem.
  factory CoreflowProduto.daMarca({
    required Color marca,
    required String id,
    required String nome,
    DilettaBrand? marcaVisual,
    CoreflowGradients? gradientes,
  }) {
    final rampa = DilettaRampa.daMarca(marca);
    final paleta = DilettaPalette.daMarca(marca: marca, id: id, nome: nome).comMaterial(
      // A GRAMÁTICA, herdada do Bold.
      cardDeVidro: BoldPalette.bold.cardDeVidro,
      raioDeBotao: BoldPalette.bold.raioDeBotao,
      raioDeFolha: BoldPalette.bold.raioDeFolha,
      blurDeVidro: BoldPalette.bold.blurDeVidro,
      papeisExtras: BoldPalette.bold.papeisExtras,
      // O MATERIAL QUE CARREGA A COR, derivado da marca dele.
      tinteDeVidroClaro: BoldPalette.bold.tinteDeVidroClaro,
      tinteDeVidroEscuro: rampa[0].withValues(alpha: 0.50),
      tracoDeVidroClaro: rampa[7],
      tracoDeVidroEscuro: rampa[5].withValues(alpha: 0.30),
      brilhoDoEsqueletoClaro: rampa[4],
      brilhoDoEsqueletoEscuro: rampa[1],
    );
    return CoreflowProduto(
      paleta: paleta,
      marca: marcaVisual ?? marcaDoBold,
      gradientes: gradientes,
    );
  }

  /// A marca do Conta BOLD — arquivos e o mapa da arte.
  static const DilettaBrand marcaDoBold = DilettaBrand(
    pacote: 'coreflow_design_system',
    // O mesmo arquivo nos dois slots: este produto não tem símbolo exportado em SVG (o que existe é
    // um `.webp` raster), então `mark` cai no lockup até o símbolo existir. Está escrito pra ser
    // pedido ao dono da marca e não pra virar folclore de "o mark é o full aqui".
    logo: 'assets/logos/conta-bold-lockup.svg',
    logoFull: 'assets/logos/conta-bold-lockup.svg',
    logoTingePorCurrentColor: true,
    hexesDaArte: {
      '#fe3976': 'primary04', // 343 pinturas
      '#ff87ab': 'primary06', // 244
      '#f66fa0': 'primary05', // 159
      '#ffb6cb': 'primary07', // 121
      '#600627': 'primary02', // 73
      '#300313': 'primary01', // 27
      '#fff6fa': 'primary09', // 4
      // E a rampa DELE, composta e não copiada.
      //
      // Ontem eram 10 linhas copiadas daqui, porque `rampaDe` é exclusivo — declarar mapa próprio
      // desliga a tabela dele, e foi o ato de declarar o nosso rosa que fez o azul dele atravessar
      // `key_word` e `no_data` inteiras. A cópia resolvia hoje e envelhecia calada: hex que muda do
      // lado dele continuaria traduzido pelo valor velho, e o `apply` não erra alto.
      //
      // O pedido voltou ENTRA DIFERENTE com uma retificação dele que vale mais que a forma: as 59
      // artes moram no pacote DELE — foram DESENHADAS pelo primeiro filho e DOADAS ao pai. O mapa
      // que as traduz é dado dele sobre asset dele, então ele não morre em 20/09; fica público.
      // *"Uma preposição, e ela mudou de quem era o dado."*
      //
      // Vieram 3 hexes de graça na composição (`#7096ff`, `#dfe7ff`, `#f5f9ff`), que eu tinha
      // medido como faltando na tabela dele e ele conferiu por luminância. São 13 agora, não 10 —
      // e é exatamente por isso que a composição paga: eu não precisei saber que mudou.
      ...DilettaIllustrationBrand.rampaDoPai,
    },
  );


  /// O Conta BOLD, que é o primeiro produto feito com este DS e o default de tudo.
  static final CoreflowProduto bold =
      CoreflowProduto(paleta: BoldPalette.bold, marca: marcaDoBold);

  /// A rampa deste produto. Todo papel de cor sai dela.
  final DilettaPalette paleta;

  /// O plugue de marca: logo, e o mapa hex→degrau das artes deste produto.
  final DilettaBrand marca;

  /// ONDE OS ASSETS DO PAI MORAM — uma linha, e sem ela nenhum ícone do pai aparece.
  ///
  /// `DilettaAssets.assetPackage` nasce `null`, que significa "assets na raiz do bundle". Num app
  /// que CONSOME o pacote eles moram em `packages/diletta_design_system/…`, então o
  /// `AssetBytesLoader` procura no lugar errado. E `VectorGraphic` com asset ausente **não
  /// estoura**: desenha caixa vazia.
  ///
  /// Chegou como *"os ícones não estão aparecendo no app"*, depois de a adoção trocar
  /// `BoldIconButton` por `DilettaIconButton`: as setas de voltar, os ícones da home e o `>` do
  /// extrato sumiram juntos. Nada falhou — nem `analyze`, nem a suíte inteira, nem o console.
  ///
  /// **Fica AQUI e não no `main` do app**: quem liga o DS é quem sabe onde o DS guarda coisa. No
  /// `main` isso é uma linha que todo app novo tem que lembrar de copiar — e o primeiro filho, que
  /// resolveu no `main` do catálogo dele, tem o mesmo buraco de um lado só.
  static void _garanteOsAssetsDoPai() {
    DilettaAssets.assetPackage ??= DilettaAssets.package;
  }

  /// O esquema de cor deste produto no claro — os papéis que as peças do pacote leem.
  late final CoreflowScheme esquemaClaro = CoreflowScheme.de(paleta, brilho: Brightness.light);

  /// O esquema de cor deste produto no escuro.
  late final CoreflowScheme esquemaEscuro = CoreflowScheme.de(paleta, brilho: Brightness.dark);

  /// O tema do PAI no claro — o que as peças dele leem pelo `DilettaThemeScope`.
  late final DilettaTheme claro = () {
    _garanteOsAssetsDoPai();
    return DilettaTheme.resolve(palette: paleta, brand: marca);
  }();

  /// O tema do PAI no escuro.
  late final DilettaTheme escuro = () {
    _garanteOsAssetsDoPai();
    return DilettaTheme.resolve(
        palette: paleta, brand: marca, brightness: Brightness.dark);
  }();

  /// O `ThemeData` do Material no claro.
  late final ThemeData materialClaro = CoreflowTemaMaterial.de(esquemaClaro);

  /// O `ThemeData` do Material no escuro.
  late final ThemeData materialEscuro = CoreflowTemaMaterial.de(esquemaEscuro);

  /// Os gradientes deste produto — a curva do símbolo e a tinta que vai por cima.
  ///
  /// Vem com a curva do Conta BOLD por default, e é o único campo do produto que **não** deriva da
  /// paleta: a curva do lockup é uma lista ordenada com offsets que saem do arquivo do logo, não
  /// uma rampa de degraus nomeados. Um produto com símbolo próprio passa a dele.
  late final CoreflowGradients gradientes = _gradientes ?? CoreflowGradients.bold;
  final CoreflowGradients? _gradientes;
}
