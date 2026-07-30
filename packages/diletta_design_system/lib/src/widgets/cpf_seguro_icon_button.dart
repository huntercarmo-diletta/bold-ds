import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_palette.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_tappable.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Peso visual do IconButton (mesmas opções do DilettaButton).
enum DilettaIconButtonType {
  primary,
  secondary,
  secondaryPrimary,
  tertiary,
  tertiaryPrimary,
}

/// Tamanho canônico do IconButton.
enum DilettaIconButtonSize { sm, md, lg }

/// Estado semântico — `error` adota paleta destrutiva.
enum DilettaIconButtonState { normal, error }

/// CPF SEGURO — IconButton.
///
/// Botão só com glyph. Match direto com o Figma (mesmas props que
/// DilettaButton, sem label). Radius 12 (não pill — regra do DS).
///
/// - `size` sm(32) · md(40) · lg(56).
/// - `iconSize` opcional pra override (defaults 14/18/22).
/// - `badge=true` desenha um dot vermelho canto superior direito.
/// - `rotate` gira o glyph em graus (útil pra reusar seta).
/// - `flush` encosta o glyph no edge (compensa padding do botão).
///
/// ```dart
/// DilettaIconButton(icon: DilettaIcons.bellLight, semanticLabel: 'Notificações'),
/// DilettaIconButton(
///   icon: DilettaIcons.angleRightLight,
///   semanticLabel: 'Voltar',
///   type: DilettaIconButtonType.tertiary,
///   rotate: 180,
///   flush: DilettaIconFlush.left,
///   onPressed: goBack,
/// ),
/// ```
class DilettaIconButton extends StatefulWidget {
  const DilettaIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.type = DilettaIconButtonType.secondary,
    this.size = DilettaIconButtonSize.md,
    this.state = DilettaIconButtonState.normal,
    this.iconSize,
    this.disabled = false,
    this.onPressed,
    this.badge = false,
    this.rotate,
    this.flush,
  });

  final String icon;
  final String semanticLabel;
  final DilettaIconButtonType type;
  final DilettaIconButtonSize size;
  final DilettaIconButtonState state;

  /// Override de tamanho do glyph. Se null, usa default por [size].
  final double? iconSize;

  final bool disabled;
  final VoidCallback? onPressed;

  /// Dot vermelho canto superior direito.
  final bool badge;

  /// Rotação em graus (só o glyph, não o box).
  final double? rotate;

  /// Encosta o glyph no edge esquerdo/direito (compensa padding interno).
  /// Útil pra back-button num TopAppBar com edge padding 24.
  final DilettaIconFlush? flush;

  @override
  State<DilettaIconButton> createState() => _CpsIconButtonState();
}

enum DilettaIconFlush { left, right }

class _CpsIconButtonState extends State<DilettaIconButton> {
  bool _hover = false;

  // Disabled é ESTADO EXPLÍCITO — onPressed null significa só
  // não-interativo (mocks/handoff), não muda o visual.
  bool get _disabled => widget.disabled;

  @override
  Widget build(BuildContext context) {
    final s = _sizeSpec(widget.size);
    final iconSize = widget.iconSize ?? s.icon;
    final innerPad = (s.box - iconSize) / 2;
    final scheme = DilettaTheme.schemeOf(context);

    // Visual reage ao `pressed` que o DilettaTappable expõe (detecção única).
    Widget boxFor(bool pressed) {
      final v = _resolveStyle(
          widget.type, widget.state, _resolveStatus(pressed), scheme);
      Widget glyph = DilettaIconAccessory(
          icon: widget.icon, padding: 0, size: iconSize, color: v.color);
      if (widget.rotate != null) {
        glyph = Transform.rotate(
            angle: widget.rotate! * 3.1415926535 / 180, child: glyph);
      }
      Widget box = AnimatedContainer(
        duration: DilettaMotion.micro,
        width: s.box,
        height: s.box,
        decoration: BoxDecoration(
          color: v.bg,
          borderRadius: DilettaRadius.pillAll,
          border: v.border == null
              ? null
              : Border.all(color: v.border!, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: glyph),
            if (widget.badge)
              const Positioned(top: 6, right: 6, child: _BadgeDot()),
          ],
        ),
      );
      if (widget.flush != null) {
        box = Transform.translate(
          offset: widget.flush == DilettaIconFlush.left
              ? Offset(-innerPad, 0)
              : Offset(innerPad, 0),
          child: box,
        );
      }
      return box;
    }

    return DilettaDevInfo(
      component: 'DilettaIconButton',
      props: {'icon': widget.icon, 'type': widget.type.name, 'size': widget.size.name, 'state': widget.state.name, if (widget.disabled) 'disabled': 'true'},
      tokens: const ['radius pill · sm 32 / md 40 / lg 56 · secondary bg white border neutral-08'],
      child: Semantics(
        button: true,
        enabled: !_disabled,
        label: widget.semanticLabel,
        child: MouseRegion(
          cursor: _disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: DilettaTappable(
            onTap: _disabled ? null : widget.onPressed,
            disabled: _disabled,
            pressedOpacity: 1.0,
            builder: (_, pressed) => boxFor(pressed),
          ),
        ),
      ),
    );
  }

  _Status _resolveStatus(bool pressed) {
    if (_disabled) return _Status.disabled;
    if (pressed) return _Status.pressed;
    if (_hover) return _Status.hover;
    return _Status.normal;
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot();

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: s.palette.error04,
        shape: BoxShape.circle,
        border: Border.all(color: s.palette.white, width: 1.5),
      ),
    );
  }
}

// ============================================================================
// Style resolvers (compartilha lógica com DilettaButton — poderia extrair depois)
// ============================================================================

enum _Status { normal, hover, pressed, disabled }

class _Palette {
  const _Palette({
    required this.base,
    required this.hover,
    required this.pressed,
    required this.onBase,
    required this.bgHoverGhost,
  });
  final Color base;
  final Color hover;
  final Color pressed;
  final Color onBase;
  final Color bgHoverGhost;
}

_Palette _defaultPalette(DilettaPalette p) => _Palette(
  base: p.primary04,
  hover: p.primary03,
  pressed: p.primary02,
  onBase: p.onPrimary,
  bgHoverGhost: p.primary08,
);

_Palette _errorPalette(DilettaPalette p) => _Palette(
  base: p.error03,
  hover: p.error02,
  pressed: p.error01,
  onBase: p.white,
  bgHoverGhost: p.error07,
);

class _StyleShape {
  const _StyleShape({required this.bg, required this.color, this.border});
  final Color bg;
  final Color color;
  final Color? border;
}

_StyleShape _resolveStyle(DilettaIconButtonType type, DilettaIconButtonState state, _Status status, DilettaScheme sc) {
  final bool isError = state == DilettaIconButtonState.error;
  final p = isError ? _errorPalette(sc.palette) : _defaultPalette(sc.palette);
  // Marca "resting": no dark clareia (sc.primary); error mantém a paleta destrutiva.
  final Color brand = isError ? p.base : sc.primary;
  final Color brandGhost = isError ? p.bgHoverGhost : sc.primarySubtle;

  if (status == _Status.disabled) {
    final isSecondary = type == DilettaIconButtonType.secondary || type == DilettaIconButtonType.secondaryPrimary;
    return _StyleShape(
      bg: type == DilettaIconButtonType.primary
          ? sc.palette.neutral08
          : isSecondary
              ? sc.surface
              : Colors.transparent,
      color: sc.textPlaceholder,
      border: isSecondary ? sc.border : null,
    );
  }

  switch (type) {
    case DilettaIconButtonType.primary:
      final bg = status == _Status.hover
          ? p.hover
          : status == _Status.pressed
              ? p.pressed
              : brand;
      return _StyleShape(bg: bg, color: isError ? p.onBase : sc.onPrimary);
    case DilettaIconButtonType.secondary:
      final bg = status == _Status.hover
          ? sc.surfaceMuted
          : status == _Status.pressed
              ? sc.border
              : sc.surface;
      // Icon = fg, border = border. Puxa do scheme pra virar no dark.
      return _StyleShape(bg: bg, color: sc.fg, border: sc.border);
    case DilettaIconButtonType.secondaryPrimary:
      final bg = (status == _Status.hover || status == _Status.pressed)
          ? brandGhost
          : sc.surface;
      return _StyleShape(bg: bg, color: brand, border: brand);
    case DilettaIconButtonType.tertiary:
      final bg = status == _Status.hover
          ? sc.surfaceMuted
          : status == _Status.pressed
              ? sc.border
              : Colors.transparent;
      return _StyleShape(bg: bg, color: sc.textTertiary);
    case DilettaIconButtonType.tertiaryPrimary:
      final bg = (status == _Status.hover || status == _Status.pressed)
          ? brandGhost
          : Colors.transparent;
      return _StyleShape(bg: bg, color: brand);
  }
}

class _SizeSpec {
  const _SizeSpec({required this.box, required this.icon});
  final double box;
  final double icon;
}

_SizeSpec _sizeSpec(DilettaIconButtonSize size) => switch (size) {
      DilettaIconButtonSize.sm => const _SizeSpec(box: 32, icon: 14),
      DilettaIconButtonSize.md => const _SizeSpec(box: 40, icon: 18),
      DilettaIconButtonSize.lg => const _SizeSpec(box: 56, icon: 22),
    };
