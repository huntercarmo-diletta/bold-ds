import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';

/// Conta BOLD — App background presets.
///
/// The backdrop is a USER-EDITABLE token (the app's "personalização" area will
/// let people pick one). [image] is the default — the futuristic skyline behind
/// a dark wash, which makes the glass cards read as real frosted glass. The
/// rest are image-free gradient moods built from the brand palette.
enum BoldBackdrop {
  /// City image + wash + brand glow. The most literal "glass". DEFAULT.
  image,

  /// One soft pink glow on a clean base. Minimal / elegant.
  brilhoRosa,

  /// Violet + pink glow. Cooler, premium.
  vidroFrio,

  /// Pink + coral + violet mesh. Vivid, uses the whole palette.
  aurora,

  /// Brand sunset bleeding from a corner. Warm.
  porDoSol,

  /// Subtle tech grid + pink glow. Techy.
  gradeTech,
}

/// Conta BOLD — App background. Wrap a screen body with it.
///
/// ```dart
/// Scaffold(body: BoldBackground(child: SafeArea(child: ...)));
/// BoldBackground(style: BoldBackdrop.aurora, child: ...);
/// ```
class BoldBackground extends StatelessWidget {
  const BoldBackground({
    super.key,
    required this.child,
    this.style,
  });

  final Widget child;

  /// Backdrop a pintar. `null` (default) = resolve pela personalização do app
  /// via [BoldBackdropScope]; sem scope, cai em [BoldBackdrop.image]. Passe um
  /// valor explícito só quando a tela precisa FIXAR um backdrop.
  final BoldBackdrop? style;

  /// Asset path — keep in sync with the pubspec declaration.
  static const String skylineAsset =
      'lib/design_system/assets/city-cyberpunk.webp';

  // brand glow colours (same in both themes)
  static const _pink = Color(0xFFFE3976);
  static const _coral = Color(0xFFFE7B5E);
  static const _yellow = Color(0xFFFEED35);
  static const _violet = Color(0xFF7B3FF2);

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Explícito > personalização do app (scope) > default imagem.
    final backdrop = style ?? BoldBackdropScope.of(context) ?? BoldBackdrop.image;
    return Container(
      color: c.background,
      child: Stack(children: [
        ..._layers(c, backdrop),
        child,
      ]),
    );
  }

  List<Widget> _layers(BoldScheme c, BoldBackdrop style) {
    // Glows read a touch softer on a light base.
    final k = c.isDark ? 1.0 : 0.7;
    switch (style) {
      case BoldBackdrop.image:
        return _imageLayers(c);
      case BoldBackdrop.brilhoRosa:
        return [_glow(const Alignment(0, -1), 1.15, _pink.withValues(alpha: .34 * k))];
      case BoldBackdrop.vidroFrio:
        return [
          _glow(const Alignment(-0.5, -1), 1.2, _violet.withValues(alpha: .34 * k)),
          _glow(const Alignment(0.95, -0.6), 1.0, _pink.withValues(alpha: .30 * k)),
        ];
      case BoldBackdrop.aurora:
        return [
          _glow(const Alignment(-0.7, -0.8), 0.9, _pink.withValues(alpha: .32 * k)),
          _glow(const Alignment(0.85, -0.9), 0.85, _coral.withValues(alpha: .30 * k)),
          _glow(const Alignment(0.5, 0.95), 1.0, _violet.withValues(alpha: .32 * k)),
        ];
      case BoldBackdrop.porDoSol:
        return [
          _glow(const Alignment(1, -1), 1.1, _yellow.withValues(alpha: .22 * k)),
          _glow(const Alignment(0.7, -0.85), 0.9, _coral.withValues(alpha: .26 * k)),
          _glow(const Alignment(-1, 1), 1.0, _pink.withValues(alpha: .30 * k)),
        ];
      case BoldBackdrop.gradeTech:
        return [
          Positioned.fill(
              child: CustomPaint(
                  painter: _GridPainter(c.border.withValues(alpha: c.isDark ? .6 : 1)))),
          _glow(const Alignment(0, -1), 1.1, _pink.withValues(alpha: .32 * k)),
        ];
    }
  }

  // Scrim theme-aware de 80% sobre a foto: PRETO no dark (ink branco lê por
  // cima) ou BRANCO no light (ink neutral-01 lê por cima). Token único, usado
  // pelo backdrop E pelo [statusBarScrim].
  static Color _scrim(BoldScheme c) =>
      (c.isDark ? BoldColors.black : BoldColors.white).withValues(alpha: 0.80);

  // Imagem de fundo (recorte de [skylineAsset]) + scrim theme-aware por cima.
  List<Widget> _imageLayers(BoldScheme c) {
    return [
      Positioned.fill(
        child: Image.asset(
          skylineAsset,
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
      Positioned.fill(child: ColoredBox(color: _scrim(c))),
    ];
  }

  /// Repinta o backdrop recortado à FAIXA DA STATUS BAR — pra mascarar o
  /// conteúdo que rola por baixo do notch quando o topo rola junto. Colocar num
  /// slot de altura `MediaQuery.padding.top`, fixo no topo do Stack da tela.
  ///
  /// Segue o backdrop selecionado (via [BoldBackdropScope]): renderiza um
  /// [BoldBackground] com a altura da TELA e recorta a faixa do topo, então a
  /// pintura bate exatamente com o fundo por trás — inclusive quando o usuário
  /// troca o fundo na personalização (antes fixava a imagem).
  static Widget statusBarScrim(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: screenH,
        maxHeight: screenH,
        child: const BoldBackground(child: SizedBox.expand()),
      ),
    );
  }

  // A radial brand glow that fades to transparent.
  Widget _glow(Alignment center, double radius, Color color) => Positioned.fill(
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: center,
                radius: radius,
                colors: [color, color.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      );
}

/// Escopo de personalização do backdrop. Envolva o app (root) com ele — todo
/// [BoldBackground] sem `style` explícito passa a pintar este backdrop. Trocar
/// o valor (ex.: via provider/setting) re-tema todas as telas de uma vez.
///
/// ```dart
/// BoldBackdropScope(backdrop: ref.watch(backdropProvider), child: MaterialApp(...))
/// ```
class BoldBackdropScope extends InheritedWidget {
  const BoldBackdropScope(
      {super.key, required this.backdrop, required super.child});

  final BoldBackdrop backdrop;

  static BoldBackdrop? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BoldBackdropScope>()
      ?.backdrop;

  @override
  bool updateShouldNotify(BoldBackdropScope oldWidget) =>
      oldWidget.backdrop != backdrop;
}

/// Faint square grid for [BoldBackdrop.gradeTech].
class _GridPainter extends CustomPainter {
  _GridPainter(this.color);
  final Color color;
  static const double _step = 34;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += _step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += _step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}
