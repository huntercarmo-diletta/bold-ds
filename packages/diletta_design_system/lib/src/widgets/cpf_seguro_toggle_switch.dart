import 'package:flutter/material.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Tamanho do ToggleSwitch — mirror do Figma DS (node 2365:32193).
enum DilettaToggleSize { sm, md }

/// CPF SEGURO — ToggleSwitch.
///
/// Switch binário on/off. Track primary-04 quando on, neutral-09 quando off.
/// Hover: primary-03 / neutral-07. Disabled: neutral-09 + thumb neutral-07.
/// Focus ring #F1F2F6 4px (opt-in via [showFocusRing]).
///
/// ```dart
/// DilettaToggleSwitch(value: bio, onChanged: (v) => setState(() => bio = v)),
/// DilettaToggleSwitch(value: skip, onChanged: onSkipChange, size: DilettaToggleSize.sm),
/// ```
class DilettaToggleSwitch extends StatefulWidget {
  const DilettaToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = DilettaToggleSize.md,
    this.disabled = false,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final DilettaToggleSize size;
  final bool disabled;
  final String? semanticLabel;

  @override
  State<DilettaToggleSwitch> createState() => _CpsToggleSwitchState();
}

class _CpsToggleSwitchState extends State<DilettaToggleSwitch> {
  bool _hover = false;
  bool _focus = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final sz = _sizing(widget.size);
    final trackColor = _trackColor(s);
    final thumbColor = widget.disabled ? s.palette.neutral07 : s.palette.white;
    final disabled = widget.disabled || widget.onChanged == null;

    Widget core = AnimatedContainer(
      duration: DilettaMotion.control.duration,
      width: sz.width,
      height: sz.height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: DilettaRadius.pillAll,
        boxShadow: _focus && !disabled
            ? [BoxShadow(color: s.surfaceMuted, blurRadius: 0, spreadRadius: 4)]
            : null,
      ),
      child: AnimatedAlign(
        duration: DilettaMotion.control.duration,
        curve: DilettaMotion.control.curve,
        alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: DilettaMotion.control.duration,
          width: sz.thumb,
          height: sz.thumb,
          decoration: BoxDecoration(
            color: thumbColor,
            shape: BoxShape.circle,
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(color: DilettaAbsoluteColors.slateAlpha10, blurRadius: 3, offset: Offset(0, 1)),
                    BoxShadow(color: DilettaAbsoluteColors.slateAlpha6, blurRadius: 2, offset: Offset(0, 1)),
                  ],
          ),
        ),
      ),
    );

    return DilettaDevInfo(
      component: 'DilettaToggleSwitch',
      props: {'value': '${widget.value}', 'size': widget.size.name, if (widget.disabled) 'disabled': 'true'},
      tokens: const ['track on primary-04 / off neutral-08 · thumb white · radius pill'],
      child: Semantics(
      label: widget.semanticLabel,
      toggled: widget.value,
      enabled: !disabled,
      button: true,
      child: MouseRegion(
        cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Focus(
          focusNode: _focusNode,
          onFocusChange: (f) => setState(() => _focus = f),
          child: DilettaTappable(pressedOpacity: 1.0, 
            onTap: disabled ? null : () => widget.onChanged!(!widget.value),
            child: core,
          ),
        ),
      ),
    ),
    );
  }

  Color _trackColor(DilettaScheme s) {
    if (widget.disabled) return s.palette.neutral09;
    if (widget.value) return _hover ? s.palette.primary03 : s.primary;
    return _hover ? s.palette.neutral07 : s.surfaceMuted;
  }
}

class _Sizing {
  const _Sizing({required this.width, required this.height, required this.thumb});
  final double width;
  final double height;
  final double thumb;
}

_Sizing _sizing(DilettaToggleSize size) => switch (size) {
      DilettaToggleSize.sm => const _Sizing(width: 36, height: 20, thumb: 16),
      DilettaToggleSize.md => const _Sizing(width: 44, height: 24, thumb: 20),
    };
