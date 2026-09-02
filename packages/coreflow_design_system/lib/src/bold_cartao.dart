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
    return DilettaCardSurface(
      vidro: false,
      radius: br,
      corSolida: color ?? c.surface,
      bordaSolida: semBorda ? null : (borderColor ?? c.border),
      child: inner,
    );
  }
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
