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
  /// Usado na HOME e nas abas da navegação inferior (via [BoldHomeBackground]).
  image,

  /// Cor SÓLIDA plana ([BoldScheme.secondaryFlow]) — sem imagem nem glow. É o
  /// backdrop dos FLUXOS SECUNDÁRIOS (tudo que não faz parte da navegação
  /// inferior: telas empurradas como Área Pix, Segurança, Configurações…).
  solid,

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
    this.style = BoldBackdrop.image,
  });

  final Widget child;

  /// Which backdrop preset to paint (editable token).
  final BoldBackdrop style;

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
    // O backdrop sólido pinta a própria cor de base; os demais partem do
    // background padrão e sobrepõem imagem/glows.
    final base = style == BoldBackdrop.solid ? c.secondaryFlow : c.background;
    return Container(
      color: base,
      child: Stack(children: [
        ..._layers(c),
        // Material transparente: dá ancestral [Material] ao conteúdo da tela
        // (sem ele o Flutter desenha o sublinhado âmbar de "faltou Material"
        // em telas montadas só sobre este fundo, ex.: rotas empurradas).
        Material(type: MaterialType.transparency, child: child),
      ]),
    );
  }

  List<Widget> _layers(BoldScheme c) {
    // Glows read a touch softer on a light base.
    final k = c.isDark ? 1.0 : 0.7;
    switch (style) {
      case BoldBackdrop.image:
        return _imageLayers(c);
      case BoldBackdrop.solid:
        // Cor sólida (pintada pelo container base) + glow sutil da marca.
        return _solidGlowLayers(c);
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

  // Overlay da HOME: degradê ROSA → LARANJA da marca @ 80% sobre a foto
  // (substitui o antigo scrim escuro). Fixo nos dois temas. Token único, usado
  // pelo backdrop de imagem E pelo [statusBarScrim].
  static const LinearGradient _homeOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xCCFE3976), Color(0xCCFF9A52)], // rosa → laranja @ 80%
  );

  // Camada de LEGIBILIDADE sobre o degradê: branco no light / bg escuro no
  // dark, @ 65%. Deixa o texto legível — a imagem + degradê transparecem ~35%,
  // preservando o toque da marca sem saturar.
  static Color _legibilityWash(BoldScheme c) =>
      (c.isDark ? BoldColors.background : BoldColors.white)
          .withValues(alpha: 0.65);

  // Imagem de fundo (recorte de [skylineAsset]) + overlay degradê rosa→laranja
  // + wash de legibilidade (branco no light / escuro no dark) @ 80%.
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
      const Positioned.fill(
        child: DecoratedBox(decoration: BoxDecoration(gradient: _homeOverlay)),
      ),
      Positioned.fill(child: ColoredBox(color: _legibilityWash(c))),
    ];
  }

  /// Repinta o backdrop (imagem + scrim) recortado à FAIXA DA STATUS BAR — pra
  /// mascarar o conteúdo que rola por baixo do notch quando o topo rola junto.
  /// Colocar num slot de altura `MediaQuery.padding.top`, fixo no topo do Stack
  /// da tela. Reusa exatamente o mesmo asset + scrim do backdrop (zero
  /// duplicação).
  static Widget statusBarScrim(BuildContext context) {
    final c = BoldColors.of(context);
    final screenH = MediaQuery.of(context).size.height;
    return ClipRect(
      child: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenH,
          child: Image.asset(
            skylineAsset,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        // Mesmas camadas do backdrop (degradê + wash de legibilidade), à altura
        // da tela, pra que a faixa do topo case exatamente com a home.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenH,
          child: const DecoratedBox(
            decoration: BoxDecoration(gradient: _homeOverlay),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenH,
          child: ColoredBox(color: _legibilityWash(c)),
        ),
      ]),
    );
  }

  // A radial brand glow that fades to transparent.
  Widget _glow(Alignment center, double radius, Color color) =>
      _radialGlow(center, radius, color);
}

/// Glow radial da marca que esmaece para transparente. Top-level pra ser
/// compartilhado por [BoldBackground] e [BoldSecondaryBackground].
Widget _radialGlow(Alignment center, double radius, Color color) =>
    Positioned.fill(
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

// Glows do backdrop SÓLIDO / secundário: rosa da marca vindo do topo + véu
// violeta embaixo, bem discretos (a base wine-ink já carrega a marca) — dá
// profundidade sem competir com os cards. Único ponto de verdade, usado por
// [BoldBackdrop.solid] e por [BoldSecondaryBackground] (ficam idênticos).
List<Widget> _solidGlowLayers(BoldScheme c) {
  final k = c.isDark ? 1.0 : 0.7;
  return [
    _radialGlow(const Alignment(0.7, -0.95), 1.15,
        BoldBackground._pink.withValues(alpha: .16 * k)),
    _radialGlow(const Alignment(-0.85, 1.0), 1.05,
        BoldBackground._violet.withValues(alpha: .12 * k)),
  ];
}

/// Conta BOLD — Fundo da HOME (e das abas da navegação inferior).
///
/// Componente semântico que encapsula o backdrop de imagem da marca (a skyline
/// cyberpunk + wash + glow), para que o "fundo da home" seja um token único e
/// reutilizável — em vez de espalhar `BoldBackground(style: BoldBackdrop.image)`
/// pelas telas. Use este nos contextos que fazem parte da navegação inferior;
/// nos fluxos secundários use [BoldBackground] com [BoldBackdrop.solid].
///
/// ```dart
/// Scaffold(body: BoldHomeBackground(child: SafeArea(child: ...)));
/// ```
class BoldHomeBackground extends StatelessWidget {
  const BoldHomeBackground({super.key, required this.child});

  final Widget child;

  /// Repinta o backdrop recortado à faixa da status bar (delega ao
  /// [BoldBackground.statusBarScrim], mesmo asset + scrim, zero duplicação).
  static Widget statusBarScrim(BuildContext context) =>
      BoldBackground.statusBarScrim(context);

  @override
  Widget build(BuildContext context) =>
      BoldBackground(style: BoldBackdrop.image, child: child);
}

/// Conta BOLD — Fundo dos FLUXOS SECUNDÁRIOS (tudo fora da navegação inferior).
///
/// Camada `Positioned.fill` (drop-in nos `Stack` de scaffold/shell, igual ao
/// antigo fundo atmosférico) que pinta a cor sólida [BoldScheme.secondaryFlow]
/// + o glow sutil da marca — o mesmo visual de `BoldBackground(style:
/// BoldBackdrop.solid)`, mas no formato de camada. Fonte única do fundo
/// secundário do app: mude o token/glow uma vez e todas as telas seguem.
///
/// Com [child] nulo é uma camada pura (use dentro de um `Stack`). Com [child]
/// vira um wrapper de tela inteira, como [BoldBackground].
class BoldSecondaryBackground extends StatelessWidget {
  const BoldSecondaryBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final fill = Stack(fit: StackFit.expand, children: [
      ColoredBox(color: c.secondaryFlow),
      ..._solidGlowLayers(c),
    ]);
    // Modo CAMADA (sem child): pura camada de fundo pra usar dentro de um Stack
    // de scaffold/shell (o Scaffold já provê o [Material]).
    if (child == null) return Positioned.fill(child: fill);
    // Modo TELA (com child): envolve o conteúdo num [Material] transparente pra
    // dar ancestral Material (evita o sublinhado âmbar do Flutter em rotas
    // montadas só sobre este fundo).
    return Stack(children: [
      Positioned.fill(child: fill),
      Material(type: MaterialType.transparency, child: child!),
    ]);
  }
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
