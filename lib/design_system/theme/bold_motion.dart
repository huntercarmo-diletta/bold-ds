import 'package:flutter/widgets.dart';

/// Conta BOLD — Motion tokens. Durações e curvas padrão do DS, pra toda
/// transição falar a mesma língua (em vez de cada tela inventar a sua).
class BoldMotion {
  BoldMotion._();

  /// 150ms — micro-interações (hover, toggle, ripple).
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms — padrão (fade/slide de conteúdo, sheets curtos).
  static const Duration base = Duration(milliseconds: 250);

  /// 400ms — transições de tela / sheets grandes.
  static const Duration slow = Duration(milliseconds: 400);

  /// Entrada padrão — desacelera no fim (natural pra algo que "chega").
  static const Curve standard = Curves.easeOutCubic;

  /// Ênfase — acelera e desacelera (movimento expressivo).
  static const Curve emphasized = Curves.easeInOutCubic;

  /// Saída — acelera (algo "indo embora").
  static const Curve exit = Curves.easeInCubic;
}

/// Presets de entrada do [BoldAnimateIn] — o preset acopla movimento +
/// direção (na prática toast sempre desce do topo, sheet sempre sobe, etc).
enum BoldMotionPreset { fade, slideUp, slideDown, scaleIn }

/// Conta BOLD — anima um filho ENTRANDO em tela, uma vez, ao montar.
///
/// Em vez de cada tela reimplementar controller + Tween + wrapper, embrulhe o
/// filho num [BoldAnimateIn] com um preset. Respeita `prefers-reduced-motion`
/// (aparece direto, sem animar) via [MediaQuery.disableAnimations].
///
/// ```dart
/// BoldAnimateIn(preset: BoldMotionPreset.slideUp, child: BoldCard(...));
/// ```
class BoldAnimateIn extends StatefulWidget {
  const BoldAnimateIn({
    super.key,
    required this.child,
    this.preset = BoldMotionPreset.fade,
    this.duration = BoldMotion.base,
    this.delay = Duration.zero,
    this.curve = BoldMotion.standard,
  });

  final Widget child;
  final BoldMotionPreset preset;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  @override
  State<BoldAnimateIn> createState() => _BoldAnimateInState();
}

class _BoldAnimateInState extends State<BoldAnimateIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _t =
      CurvedAnimation(parent: _ctrl, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Respeita reduced-motion: mostra o resultado final direto.
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _t,
      builder: (_, child) {
        final v = _t.value;
        switch (widget.preset) {
          case BoldMotionPreset.fade:
            return Opacity(opacity: v, child: child);
          case BoldMotionPreset.slideUp:
            return Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(0, (1 - v) * 16), child: child),
            );
          case BoldMotionPreset.slideDown:
            return Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(0, (1 - v) * -16), child: child),
            );
          case BoldMotionPreset.scaleIn:
            return Opacity(
              opacity: v,
              child: Transform.scale(scale: 0.92 + 0.08 * v, child: child),
            );
        }
      },
      child: widget.child,
    );
  }
}
