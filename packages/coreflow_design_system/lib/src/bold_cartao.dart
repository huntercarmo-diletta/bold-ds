import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAbsoluteColors, DilettaCardSurface;
import 'package:flutter/material.dart';
import 'bold_vidro.dart';
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_radius.dart' show CoreflowRadius;
import 'bold_produto.dart' show CoreflowProduto;
import 'bold_scheme.dart' show CoreflowScheme;

/// Conta BOLD — Card surface.
///
/// The default container: dark surface, hairline border, 24 radius. Wrap any
/// content. Set [onTap] to make it a tappable block (action cards), [gradient]
/// for hero / featured cards.
///
/// ```dart
/// CoreflowCartao(child: Text('…'));
/// CoreflowCartao(onTap: open, child: Row(children: [...]));
/// ```
class CoreflowCartao extends StatelessWidget {
  const CoreflowCartao({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DilettaSpacing.s5),
    this.onTap,
    this.color,
    this.borderColor,
    this.semBorda = false,
    this.sombra,
    this.larguraDaBorda,
    this.transicao,
    this.gradiente,
    this.forma,
    this.fio,
    this.radius = CoreflowRadius.card,
    this.glass = false,
    this.highlight = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  /// **SEM BORDA — e este eixo nasceu de um defeito que eu mesmo escrevi.**
  ///
  /// O cartão tem hairline por default, e isso está certo: um cartão deste produto tem borda, e
  /// [borderColor] existe pra trocar a cor dela, não pra tirá-la. `null` significa *a cor padrão*.
  ///
  /// Em 01/09 uma varredura converteu 49 `BoxDecoration` das telas em `CoreflowCartao`. Metade
  /// delas — as `borderRadius + color` sem `border:` — **não tinha borda nenhuma**, e a conversão
  /// omitia `borderColor`, que o default preencheu. Vinte e cinco telas ganharam um fio que
  /// ninguém pediu, com 848 testes verdes: **gate não vê pixel.**
  ///
  /// A API não sabia dizer "sem borda", e é isso que este campo conserta. Não é
  /// `borderColor: transparent`: transparente é uma cor, e cor transparente ainda ocupa 1 lógico de
  /// espessura no layout.
  final bool semBorda;

  /// A SOMBRA, quando a superfície precisa sair da página.
  ///
  /// Ela não tem default, e isso é a regra deste produto: **este produto eleva por MATERIAL** — o
  /// vidro, a superfície elevada da paleta — e sombra é a exceção com sítio contado. Doze telas
  /// pediam uma (`CoreflowElevacao.destacada`, quase todas), e antes de o eixo existir elas
  /// desenhavam a caixa inteira à mão só pra ter onde pendurá-la.
  final List<BoxShadow>? sombra;

  /// A ESPESSURA da borda, quando ela não é 1 — e este eixo é uma pergunta em aberto, não uma
  /// resposta.
  ///
  /// A varredura das telas em 01/09 achou **nove** bordas com espessura diferente de 1, e cinco
  /// delas são CONDICIONAIS: `selected ? 2 : 1`, `selected ? 2 : 1.5`, `selected ? 1.5 : 2`,
  /// `uploaded ? 1.4 : 1`, `golden ? 1.3 : 1`. Cinco telas dizendo *"escolhido"* com **quatro
  /// espessuras diferentes** — 1.3, 1.4, 1.5 e 2 —, e uma delas com a lógica invertida em relação
  /// às outras.
  ///
  /// **Este pacote já respondeu essa pergunta uma vez**, e a resposta foi outra: o
  /// `CoreflowCartaoDePedido` marca `selecionada` trocando a COR da borda (`s.primary` contra
  /// `s.border`), não a espessura. Uma linguagem que diz a mesma coisa de dois jeitos tem um jeito
  /// a mais.
  ///
  /// O eixo entra assim mesmo, e de propósito: converter as cinco telas pra cor **mudaria pixel em
  /// cinco lugares numa passada que ninguém abriu pra olhar**, e a régua desta casa é que gate não
  /// vê forma. Com ele, o desenho sai das telas hoje e a pergunta fica em pé pra quem olha — em
  /// `docs/pedidos/`, com os cinco números.
  ///
  /// Quando a pergunta for respondida, este campo sai e as cinco viram `borderColor`.
  final double? larguraDaBorda;

  /// **A TRANSIÇÃO da superfície** — quando o cartão MUDA, e não quando ele aparece.
  ///
  /// Três superfícies de escolha deste produto eram `AnimatedContainer` desenhado à mão: o cartão de
  /// tipo de conta, o ladrilho do editor de menu e o passo da selfie do KYC. As três animam a mesma
  /// coisa — cor de fundo e cor de borda mudando quando a pessoa escolhe —, com 150 e 200 ms.
  ///
  /// Não é enfeite: uma superfície que troca de cor sem transição LÊ como redesenho, e a pessoa
  /// perde o vínculo entre o toque dela e o que mudou. Com transição, o toque e a mudança são o
  /// mesmo evento.
  ///
  /// `null` — o default — não anima, que é o comportamento de todos os outros cartões. Um cartão que
  /// não muda não tem o que transicionar, e animar por padrão custaria um `AnimatedContainer` em
  /// cada um dos ~90 sítios que nunca mudam.
  final Duration? transicao;

  /// O GRADIENTE, quando a superfície é pintura de marca e não cor chapada.
  ///
  /// Três sítios: o cartão de tipo de conta quando escolhido, a arte do cartão físico e o vidro da
  /// tela de entrada. Os três passam um valor de `CoreflowGradients` — o eixo existe pra que a
  /// CAIXA seja a peça, não pra que o gradiente seja inventado na tela.
  ///
  /// Quando presente, ele vence [color]: um gradiente e uma cor chapada na mesma superfície é uma
  /// das duas sendo ignorada, e melhor que seja por contrato do que por ordem de pintura.
  final Gradient? gradiente;

  /// A FORMA, quando o raio não é uniforme.
  ///
  /// [radius] cobre o caso comum — um `double` que vira os quatro cantos — e não cobre dois sítios
  /// deste produto: o balão do trilho de aprovações (cantos vivos onde ele aponta) e a barra de
  /// faixa da alçada (arredondada só à esquerda, porque ela é o COMEÇO de uma faixa contínua).
  ///
  /// Não é escada nova: é a mesma escada montada em quatro cantos diferentes. Quando presente,
  /// vence [radius].
  final BorderRadiusGeometry? forma;

  /// O FIO DE UMA ARESTA SÓ — o divisor colado numa barra.
  ///
  /// Dois sítios, com o mesmo hairline em `c.border` e arestas opostas: o cabeçalho da lista de
  /// personalização (embaixo) e a barra de seleção das notificações (em cima).
  ///
  /// **Por que não é `DilettaDivider`**: o divisor é um widget IRMÃO, e usá-lo trocaria a caixa por
  /// `Column(barra + divisor)` — reestruturar a árvore por um fio. Aqui ele é o que já era: uma
  /// aresta da própria superfície.
  final BoxBorder? fio;

  /// ## A PÍLULA É ESTE CARTÃO COM `radius: CoreflowRadius.pill`
  ///
  /// Em 01/09 eu escrevi uma `CoreflowPilula` — cápsula tingida com glifo e rótulo — a partir de uma
  /// contagem que dizia **treze sítios**. Aí medi as cores, e a contagem não se sustentou: dos nove
  /// candidatos, só **dois** tinham fundo e borda derivando da mesma cor. Os outros ou não têm
  /// fundo, ou têm cores independentes, ou o par é condicional.
  ///
  /// Dois sítios não pagam uma peça. Uma cápsula é este cartão com o raio pill, e o que ela precisa
  /// — cor, borda, respiro — já são eixos daqui. A peça foi apagada no mesmo dia em que nasceu, e a
  /// razão fica escrita porque o erro foi de método e não de gosto: **eu agrupei por FORMA
  /// (`pillR`) e concluí sobre CONTEÚDO.** Treze coisas com o mesmo raio não são treze da mesma
  /// coisa.
  final double radius;

  /// Card surface treatment from [_CardSurface] (the "no-fundo" look, no
  /// solid fill). Frosted glass is now reserved for the nav bar only — kept
  /// named `glass` so existing callers don't change. Pair with [highlight].
  final bool glass;

  /// Within the [glass] surface: `true` = the brand "destaque" card (pink wash
  /// + pink gradient stroke); `false` = the calm default (sober grey stroke,
  /// no wash). Two tiers, one source.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    final br = BorderRadius.circular(radius);

    final inner = onTap == null
        ? Padding(padding: padding, child: child)
        : Material(
            color: DilettaAbsoluteColors.transparent,
            borderRadius: br,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(padding: padding, child: child),
            ),
          );

    // O VIDRO É O DO PAI desde 2026-08-07, e ele é o material de card desta
    // família: a paleta declara `cardDeVidro: true`, então `DilettaCardSurface`
    // resolve em `DilettaGlassSurface` com o tinte e o blur que ESTA paleta declara.
    //
    // Medido antes de trocar, e é por isso que a troca é segura: os dois lados usam
    // os MESMOS números. Tinte escuro `#16060A` a 50% aqui e `0x8016060A` na paleta;
    // claro branco a 50% e `0x80FFFFFF`; blur 15 nos dois. A cópia era cópia.
    //
    // O que MUDA é o traço: aqui ele era cinza sóbrio pintado por `CustomPaint`, e lá
    // é o `tracoDeVidro` da paleta (`primary08` no claro, rosa a 30% no escuro). São
    // 19 sítios, e o fio fica com a cor da marca em vez de cinza.
    //
    // UMA coisa não delega, e ela é medida: o `highlight` — o traço em GRADIENTE rosa, pintura
    // própria que não existe como declaração no vidro do pai. **1 sítio**
    // (`ativar_acesso_rapido_screen`, com `highlight: selected`), e é pedido aberto.
    //
    // As props `gradient` e `shadow` saíram em 21/08: **zero sítios de chamada nas 53**, medido com
    // parênteses balanceados e só o nível de topo do construtor (a contagem por `grep` do nome
    // dava 35 pra `color:`, porque casava `TextStyle(color:` lá dentro — o mesmo erro de medição
    // que já deu duas vezes nesta adoção). Prop que ninguém passa é ramo que ninguém viu quebrar.
    if (glass && !highlight) {
      return DilettaCardSurface(
        // `vidro: true` desde 22/08 (pai `v0.143.0`), e não mais o default da paleta: quem sabe o
        // que está ATRÁS do card é o SÍTIO, e aqui o sítio disse `glass: true`. Enquanto era só a
        // paleta, os dois caminhos desta casca liam a mesma declaração e discordavam do chamador.
        vidro: true,
        radius: br,
        padding: onTap == null ? padding : null,
        child: onTap == null ? child : inner,
      );
    }
    if (glass) {
      return ClipRRect(
        borderRadius: br,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: CoreflowVidro.filtro(CoreflowProduto.bold.paleta),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _CardSurface.fill(c.isDark),
              borderRadius: br,
            ),
            child: CustomPaint(
              foregroundPainter: _CardSurface.strokePainter(radius, c.isDark),
              child: inner,
            ),
          ),
        ),
      );
    }

    // Superfície SÓLIDA (os 33 sítios sem `glass:`), e ela **passou a ser do pai em 22/08**.
    //
    // Era o pedido desta casca, e voltou ENTRA na `v0.143.0`: o material do card deixou de ser
    // propriedade do produto e passou a ser do FUNDO, que é por sítio. O `corSolida`/`bordaSolida`
    // que eu não alcançava — porque o ramo do vidro retornava antes deles — agora chega, e o
    // `clipBehavior: Clip.antiAlias` do `Container` dele faz o que o `ClipRRect` fazia aqui.
    // Com espessura própria a borda sai daqui e não do material do pai: o `DilettaCardSurface`
    // declara `width: 1` e não tem eixo — nem deveria ganhar um por causa de uma pergunta que este
    // produto ainda não respondeu.
    final larguraPropria = larguraDaBorda != null && larguraDaBorda != 1;
    // Gradiente, forma livre ou fio de aresta: a superfície é desenhada aqui, porque o
    // `DilettaCardSurface` do pai recebe cor chapada, raio uniforme e borda de quatro lados.
    if (gradiente != null || forma != null || fio != null) {
      final caixa = DecoratedBox(
        decoration: BoxDecoration(
          color: gradiente == null ? (color ?? c.surface) : null,
          gradient: gradiente,
          borderRadius: forma ?? (radius == 0 ? null : br),
          border: fio ??
              (semBorda ? null : Border.all(color: borderColor ?? c.border, width: larguraDaBorda ?? 1)),
          boxShadow: sombra,
        ),
        child: inner,
      );
      return caixa;
    }
    if (transicao != null) return _animado(context, c, br, inner);
    final solida = DilettaCardSurface(
      vidro: false,
      radius: br,
      corSolida: color ?? c.surface,
      bordaSolida: (semBorda || larguraPropria) ? null : (borderColor ?? c.border),
      child: inner,
    );
    if (larguraPropria) {
      final comBorda = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: br,
          border: Border.all(color: borderColor ?? c.border, width: larguraDaBorda!),
        ),
        child: solida,
      );
      if (sombra == null) return comBorda;
      return DecoratedBox(
        decoration: BoxDecoration(borderRadius: br, boxShadow: sombra),
        child: comBorda,
      );
    }
    if (sombra == null) return solida;
    // A sombra vai POR FORA e não dentro da superfície do pai: ela é do sítio, não do material, e
    // `DilettaCardSurface` não tem eixo pra ela — nem deveria, porque a escada de elevação dele já
    // existe e este produto não a usa em cartão.
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: br, boxShadow: sombra),
      child: solida,
    );
  }
}

extension on CoreflowCartao {
  /// A versão que TRANSICIONA, e ela desenha a superfície aqui em vez de delegar.
  ///
  /// `DilettaCardSurface` monta um `Container` comum: pra animar a decoração seria preciso um
  /// `AnimatedContainer` lá dentro, e isso é um eixo do pai por causa de três sítios deste produto.
  /// Aqui a superfície sólida é uma `BoxDecoration` de três campos — cor, raio, borda —, e os três
  /// são os mesmos que o `corSolida`/`bordaSolida` dele recebe.
  Widget _animado(BuildContext context, CoreflowScheme c, BorderRadius br, Widget filho) =>
      AnimatedContainer(
        duration: transicao!,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: color ?? c.surface,
          borderRadius: br,
          border: semBorda
              ? null
              : Border.all(
                  color: borderColor ?? c.border, width: larguraDaBorda ?? 1),
          boxShadow: sombra,
        ),
        child: filho,
      );
}

/// O material do card de vidro deste app: o tinte e o traço em gradiente do destaque.
///
/// Era `BoldCardSurface`, PÚBLICA, e virou privada em 21/08 pela frase que a exceção do gate já
/// dizia sobre ela: *"o que ela tem de errado é o nome público, não a vida"*. Depois que o caminho
/// de vidro sem destaque passou a delegar pro pai e as props mortas saíram, o que sobrou tem UM
/// chamador, no mesmo arquivo. Peça com um chamador dentro de casa não é palavra pública.
class _CardSurface {
  /// Fill do card glass, e ele **vem do pacote desde 20/08**.
  ///
  /// Eram os mesmos dois valores por um terceiro caminho: `glassFill @ 50%` no escuro e
  /// `glassFillLight @ 50%` no claro. A receita do vidro mora na paleta desde a `v0.4.0` do pai
  /// (`tinteDeVidroEscuro`/`Claro`), o `BoldGlass` daqui já passou a lê-la em 19/08 — e este ficou
  /// atrás, remontando o mesmo tinte com o mesmo alpha.
  ///
  /// **Terceira fonte do mesmo material.** Conferido byte a byte antes de trocar: idêntico.
  // A paleta é a do produto Bold: estes dois helpers recebem `bool isDark` e não o esquema, e
  // trocar a assinatura por aqui atravessaria 4 sítios de tela pra ganhar o que a casca já é —
  // o adaptador DESTE app.
  static Color fill(bool isDark) =>
      CoreflowVidro.tinte(CoreflowProduto.bold.paleta, escuro: isDark);

  /// Destaque no DARK — stroke rosa, mais forte no topo-esquerdo (gradiente).
  static const LinearGradient strokeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // Os dois degraus saem do TOKEN e não de hex: era `0xB3FE3976`/`0x12FE3976`,
    // que é o `primary04` com alpha escrito à mão. O rosa é o mesmo — o que muda
    // é que agora ele acompanha a rampa. Hex aqui prendia a marca a um valor que
    // nenhum rebrand alcança.
    colors: [
      Color.fromRGBO(254, 57, 118, 0.702),
      Color.fromRGBO(254, 57, 118, 0.071),
    ],
    stops: [0.0, 0.58],
  );

  /// Destaque no LIGHT — mesmo gesto, mas BRANCO (combina com o fill laranja).
  static const LinearGradient strokeGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(255, 255, 255, 0.8),
      Color.fromRGBO(255, 255, 255, 0.102),
    ],
    stops: [0.0, 0.58],
  );

  // O `simpleStroke` saiu em 21/08 junto com o `simpleStrokePainter`: o traço sóbrio era o do
  // caminho de vidro SEM destaque, e esse caminho delega pro `DilettaCardSurface` desde 07/08 — o
  // traço que desenha é o `tracoDeVidro` da paleta, lido lá. O que ficou aqui era o mesmo valor
  // por um segundo caminho, sem chamador.
  /// Destaque: gradiente rosa no dark, gradiente branco no light.
  static CustomPainter strokePainter(double radius, bool isDark) =>
      _CardStrokePainter(radius,
          gradient: isDark ? strokeGradient : strokeGradientLight);
}

class _CardStrokePainter extends CustomPainter {
  _CardStrokePainter(this.radius, {required this.gradient});
  final double radius;

  /// Gradiente do stroke (card destaque).
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(0.5), Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CardStrokePainter o) =>
      o.radius != radius || o.gradient != gradient;
}
