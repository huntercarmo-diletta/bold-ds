import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';

/// Direção da transição.
enum DilettaScreenDirection { forward, back }

/// CPF SEGURO — ScreenTransition.
///
/// Animação de troca de página INSIDE do container pai (PhoneShell / Scaffold).
/// Consome o contexto de motion `page` ([DilettaMotion.page]): duração `slow`
/// (400) · entra desacelerando (`enter`), sai acelerando (`exit`).
///
/// - forward: nova entra deslizando da direita (push)
/// - back:    atual sai deslizando pra direita (pop)
///
/// Cada child ocupa 100% do espaço via `Positioned.fill` internamente.
class DilettaScreenTransition extends StatefulWidget {
  const DilettaScreenTransition({
    super.key,
    required this.pageKey,
    required this.child,
    this.duration = DilettaMotion.slow,
    this.direction = DilettaScreenDirection.forward,
    this.background,
  });

  final String pageKey;
  final Widget child;
  final Duration duration;
  final DilettaScreenDirection direction;

  /// Bg opaco de cada page — sem isso, a leaving revela a nova como
  /// "flutuando". Default = transparent (pai controla).
  final Color? background;

  @override
  State<DilettaScreenTransition> createState() => _CpsScreenTransitionState();
}

class _CpsScreenTransitionState extends State<DilettaScreenTransition> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: DilettaMotion.enter,
      switchOutCurve: DilettaMotion.exit,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: widget.direction == DilettaScreenDirection.forward
              ? const Offset(1, 0)
              : const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(
          position: slide,
          child: widget.background == null
              ? child
              : ColoredBox(color: widget.background!, child: child),
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: KeyedSubtree(key: ValueKey(widget.pageKey), child: widget.child),
    );
  }
}
