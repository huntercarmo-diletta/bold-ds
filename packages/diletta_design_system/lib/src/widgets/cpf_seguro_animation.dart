import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';

/// Preset de animação — casos de uso nomeados que já vêm com posicionamento
/// + keyframe embutidos (paridade com [Animation] do React DS).
enum DilettaAnimationPreset {
  /// Toast/aviso deslizando do topo (top:48, left/right:16).
  topNotification,

  /// Bottomsheet subindo do rodapé.
  bottomSheet,

  /// Scrim/overlay fade-in cobrindo o parent.
  scrim,

  /// Slide horizontal (push) — filho occupa Positioned.fill.
  slideInRight,

  /// Slide horizontal (pop) — filho occupa Positioned.fill.
  slideOutRight,

  /// Fade-in puro, sem positioning.
  fadeIn,
}

/// CPF SEGURO — Animation.
///
/// Wrapa [child] com uma animação de entrada nomeada. Posicionamento
/// vem embutido nos presets fixed-position (topNotification, bottomSheet,
/// scrim, slideIn/OutRight) — nesse caso precisa de um [Stack] ancestral.
///
/// ```dart
/// DilettaAnimation(preset: DilettaAnimationPreset.topNotification, child: DilettaToast(...)),
/// ```
class DilettaAnimation extends StatefulWidget {
  const DilettaAnimation({
    super.key,
    required this.preset,
    required this.child,
  });

  final DilettaAnimationPreset preset;
  final Widget child;

  @override
  State<DilettaAnimation> createState() => _CpsAnimationState();
}

class _CpsAnimationState extends State<DilettaAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: _durationFor(widget.preset),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animated = _wrap(widget.preset, _c, widget.child);
    return _positioned(widget.preset, animated);
  }
}

Duration _durationFor(DilettaAnimationPreset p) => switch (p) {
      DilettaAnimationPreset.topNotification => DilettaMotion.toast.duration,
      DilettaAnimationPreset.bottomSheet => DilettaMotion.sheet.duration,
      DilettaAnimationPreset.scrim => DilettaMotion.fade.duration,
      DilettaAnimationPreset.slideInRight => DilettaMotion.page.duration,
      DilettaAnimationPreset.slideOutRight => DilettaMotion.page.duration,
      DilettaAnimationPreset.fadeIn => DilettaMotion.fade.duration,
    };

Widget _wrap(DilettaAnimationPreset p, AnimationController c, Widget child) {
  final ease = CurvedAnimation(parent: c, curve: DilettaMotion.enter);
  final easeIn = CurvedAnimation(parent: c, curve: DilettaMotion.exit);

  switch (p) {
    case DilettaAnimationPreset.topNotification:
      final slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(ease);
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: ease, child: child),
      );
    case DilettaAnimationPreset.bottomSheet:
      final slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(ease);
      return SlideTransition(position: slide, child: child);
    case DilettaAnimationPreset.scrim:
      return FadeTransition(opacity: ease, child: child);
    case DilettaAnimationPreset.slideInRight:
      final slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(easeIn);
      return SlideTransition(position: slide, child: child);
    case DilettaAnimationPreset.slideOutRight:
      final slide = Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0)).animate(easeIn);
      return SlideTransition(position: slide, child: child);
    case DilettaAnimationPreset.fadeIn:
      return FadeTransition(opacity: ease, child: child);
  }
}

Widget _positioned(DilettaAnimationPreset p, Widget child) {
  switch (p) {
    case DilettaAnimationPreset.topNotification:
      return Positioned(top: 48, left: 16, right: 16, child: child);
    case DilettaAnimationPreset.bottomSheet:
      return Positioned(bottom: 0, left: 0, right: 0, child: child);
    case DilettaAnimationPreset.scrim:
      return Positioned.fill(child: child);
    case DilettaAnimationPreset.slideInRight:
    case DilettaAnimationPreset.slideOutRight:
      return Positioned.fill(child: child);
    case DilettaAnimationPreset.fadeIn:
      return child;
  }
}
