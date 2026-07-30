import 'package:flutter/widgets.dart';

/// CPF SEGURO — Tappable (área de toque).
///
/// Encapsula o padrão de toque do DS: hit area **opaca** + detecção de toque
/// única. Dois modos:
///
/// - **child** — feedback de pressão por **opacidade** (default do DS, não ripple
///   do Material). Substitui `GestureDetector`/`InkWell` crus em superfícies.
/// - **builder** — `builder(context, pressed)`: expõe o estado pressionado pro
///   filho desenhar o **próprio** feedback (ex.: botões com `AnimatedContainer`
///   que mudam bg/cor no pressed). A detecção de toque fica só aqui (fonte
///   única); o visual fica com o componente.
///
/// `onTap` nulo (e não desabilitado) → sem gesto. Desabilitado → sem callback
/// (no modo child, esmaecido; no modo builder, o builder recebe `pressed=false`
/// e desenha o próprio estado disabled).
class DilettaTappable extends StatefulWidget {
  const DilettaTappable({
    super.key,
    this.child,
    this.builder,
    this.onTap,
    this.onLongPress,
    this.onPressedChange,
    this.disabled = false,
    this.pressedOpacity = 0.6,
    this.disabledOpacity = 0.4,
    this.behavior = HitTestBehavior.opaque,
  }) : assert(child != null || builder != null,
            'Informe child (modo opacidade) ou builder (modo pressed).');

  /// Modo opacidade: o filho estático.
  final Widget? child;

  /// Modo builder: recebe o estado `pressed` pra desenhar o próprio feedback.
  final Widget Function(BuildContext context, bool pressed)? builder;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Notifica mudança do estado pressionado (pro componente que desenha o
  /// próprio feedback via `child` + rebuild, alternativa ao `builder`).
  final ValueChanged<bool>? onPressedChange;
  final bool disabled;
  final double pressedOpacity;
  final double disabledOpacity;
  final HitTestBehavior behavior;

  @override
  State<DilettaTappable> createState() => _CpfSeguroTappableState();
}

class _CpfSeguroTappableState extends State<DilettaTappable> {
  bool _pressed = false;

  bool get _enabled =>
      !widget.disabled && (widget.onTap != null || widget.onLongPress != null);

  void _set(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
    widget.onPressedChange?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    final Widget visual;
    if (widget.builder != null) {
      // O builder recebe `pressed` e desenha o próprio feedback.
      visual = widget.builder!(context, _pressed);
    } else {
      final opacity = widget.disabled
          ? widget.disabledOpacity
          : (_pressed ? widget.pressedOpacity : 1.0);
      visual = AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 90),
        child: widget.child,
      );
    }

    if (!_enabled) return visual;

    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: visual,
    );
  }
}
