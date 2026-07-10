import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';

/// Peso visual do [BoldIconButton] (mesmas opções do BoldButton em espírito).
enum BoldIconButtonType {
  /// Sólido primário (rosa), glyph branco.
  primary,

  /// Bg branco + border neutra, glyph neutro.
  secondary,

  /// Bg branco + border/glyph primários.
  secondaryPrimary,

  /// Ghost neutro (sem bg até pressionar).
  tertiary,

  /// Ghost primário.
  tertiaryPrimary,
}

/// Tamanho canônico — sm(32) · md(40) · lg(56).
enum BoldIconButtonSize { sm, md, lg }

/// Estado semântico — `error` adota a paleta destrutiva.
enum BoldIconButtonState { normal, error }

/// Encosta o glyph no edge (compensa o padding interno do box).
enum BoldIconFlush { left, right }

/// Conta BOLD — IconButton (molécula). Botão só com glyph, pill. Acessório
/// canônico de TopBar/BottomApp. App-first: sem hover — feedback só no pressed.
///
/// **Composição** — BoldIcon (átomo) + tokens (escala de shade: base 04 →
/// pressed 03; ghost pressed = wash 08).
///
/// ```dart
/// BoldIconButton(icon: 'bell', semanticLabel: 'Notificações', badge: true);
/// BoldIconButton(
///   icon: 'arrow-left-light',
///   semanticLabel: 'Voltar',
///   type: BoldIconButtonType.tertiary,
///   flush: BoldIconFlush.left,
///   onPressed: pop,
/// );
/// ```
class BoldIconButton extends StatefulWidget {
  const BoldIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.type = BoldIconButtonType.secondary,
    this.size = BoldIconButtonSize.md,
    this.state = BoldIconButtonState.normal,
    this.iconSize,
    this.disabled = false,
    this.onPressed,
    this.badge = false,
    this.rotate,
    this.flush,
  });

  final String icon;
  final String semanticLabel;
  final BoldIconButtonType type;
  final BoldIconButtonSize size;
  final BoldIconButtonState state;

  /// Override do tamanho do glyph (default 14/18/22 por [size]).
  final double? iconSize;

  final bool disabled;
  final VoidCallback? onPressed;

  /// Dot de notificação no canto superior direito.
  final bool badge;

  /// Rotação do glyph em graus (só o glyph, não o box).
  final double? rotate;

  /// Compensa o padding interno pra alinhar o glyph com o edge do layout.
  final BoldIconFlush? flush;

  @override
  State<BoldIconButton> createState() => _BoldIconButtonState();
}

class _BoldIconButtonState extends State<BoldIconButton> {
  bool _pressed = false;

  bool get _disabled => widget.disabled || widget.onPressed == null;

  @override
  Widget build(BuildContext context) {
    final s = _sizeSpec(widget.size);
    final iconSize = widget.iconSize ?? s.icon;
    final v = _resolveStyle(
        widget.type, widget.state,
        _disabled ? _S.disabled : (_pressed ? _S.pressed : _S.normal),
        onDark: BoldColors.of(context).isDark);
    final innerPad = (s.box - iconSize) / 2;

    Widget glyph = BoldIcon(widget.icon, size: iconSize, color: v.color);
    if (widget.rotate != null) {
      glyph = Transform.rotate(
          angle: widget.rotate! * 3.1415926535 / 180, child: glyph);
    }

    Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: s.box,
      height: s.box,
      decoration: BoxDecoration(
        color: v.bg,
        borderRadius: BoldRadius.pillR,
        border: v.border == null ? null : Border.all(color: v.border!, width: 1),
      ),
      child: Stack(alignment: Alignment.center, children: [
        Center(child: glyph),
        if (widget.badge)
          const Positioned(top: 6, right: 6, child: _BadgeDot()),
      ]),
    );

    if (widget.flush != null) {
      box = Transform.translate(
        offset: widget.flush == BoldIconFlush.left
            ? Offset(-innerPad, 0)
            : Offset(innerPad, 0),
        child: box,
      );
    }

    return Semantics(
      button: true,
      enabled: !_disabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _disabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: _disabled ? null : (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _disabled ? null : widget.onPressed,
        child: box,
      ),
    );
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: BoldColors.danger,
        shape: BoxShape.circle,
        border: Border.all(color: BoldColors.white, width: 1.5),
      ),
    );
  }
}

// ── style resolvers ─────────────────────────────────────────────────────────
enum _S { normal, pressed, disabled }

class _Palette {
  const _Palette(this.base, this.pressed, this.onBase, this.ghostPressed);
  final Color base;
  final Color pressed;
  final Color onBase;
  final Color ghostPressed;
}

const _Palette _brand = _Palette(
  BoldColors.primary04,
  BoldColors.primary03,
  BoldColors.onPrimary,
  BoldColors.primary08,
);

const _Palette _error = _Palette(
  BoldColors.error03,
  BoldColors.error02,
  BoldColors.white,
  BoldColors.error07,
);

class _Style {
  const _Style({required this.bg, required this.color, this.border});
  final Color bg;
  final Color color;
  final Color? border;
}

_Style _resolveStyle(BoldIconButtonType type, BoldIconButtonState state, _S s,
    {bool onDark = false}) {
  final p = state == BoldIconButtonState.error ? _error : _brand;

  if (s == _S.disabled) {
    final isSecondary = type == BoldIconButtonType.secondary ||
        type == BoldIconButtonType.secondaryPrimary;
    return _Style(
      bg: type == BoldIconButtonType.primary
          ? BoldColors.neutral08
          : isSecondary
              ? BoldColors.white
              : BoldColors.transparent,
      color: BoldColors.neutral05,
      border: isSecondary ? BoldColors.neutral08 : null,
    );
  }

  switch (type) {
    case BoldIconButtonType.primary:
      return _Style(bg: s == _S.pressed ? p.pressed : p.base, color: p.onBase);
    case BoldIconButtonType.secondary:
      // Sem fill (spec do Figma): só o anel + glyph. Erro = vermelho (dark 05
      // claro, light 03 profundo); senão ink do tema (branco translúcido no
      // dark, neutral-02 no light). Pressed = tint leve.
      final secError = state == BoldIconButtonState.error;
      if (onDark) {
        return _Style(
          bg: s == _S.pressed
              ? (secError
                  ? BoldColors.error04.withValues(alpha: 0.20)
                  : BoldColors.whiteAlpha24)
              : BoldColors.transparent,
          color: secError ? BoldColors.error05 : BoldColors.white,
          border: secError ? BoldColors.error05 : BoldColors.whiteAlpha38,
        );
      }
      final secFg = secError ? BoldColors.error03 : BoldColors.neutral02;
      return _Style(
        bg: s == _S.pressed
            ? (secError ? BoldColors.error07 : BoldColors.neutral09)
            : BoldColors.transparent,
        color: secFg,
        border: secFg,
      );
    case BoldIconButtonType.secondaryPrimary:
      // Light = pill branco + conteúdo primário. Dark = o branco sólido brilha
      // demais; troca por vidro tintado no tom (base @ alpha) com glyph/anel no
      // tom, preservando a intenção "primary".
      if (onDark) {
        return _Style(
          bg: s == _S.pressed
              ? p.base.withValues(alpha: 0.40)
              : p.base.withValues(alpha: 0.18),
          color: p.base,
          border: p.base,
        );
      }
      return _Style(
        bg: s == _S.pressed ? p.ghostPressed : BoldColors.white,
        color: p.base,
        border: p.base,
      );
    case BoldIconButtonType.tertiary:
      // Erro = glyph vermelho (dark 05, light 03); senão ink do tema (branco no
      // dark sobre a imagem, neutral-01 no light). Pressed = wash leve.
      final terError = state == BoldIconButtonState.error;
      if (terError) {
        return _Style(
          bg: s == _S.pressed
              ? (onDark
                  ? BoldColors.error04.withValues(alpha: 0.20)
                  : BoldColors.error07)
              : BoldColors.transparent,
          color: onDark ? BoldColors.error05 : BoldColors.error03,
        );
      }
      return _Style(
        bg: s == _S.pressed
            ? (onDark ? BoldColors.whiteAlpha24 : BoldColors.neutral09)
            : BoldColors.transparent,
        color: onDark ? BoldColors.white : BoldColors.neutral01,
      );
    case BoldIconButtonType.tertiaryPrimary:
      return _Style(
        bg: s == _S.pressed ? p.ghostPressed : BoldColors.transparent,
        color: p.base,
      );
  }
}

class _SizeSpec {
  const _SizeSpec(this.box, this.icon);
  final double box;
  final double icon;
}

_SizeSpec _sizeSpec(BoldIconButtonSize size) => switch (size) {
      BoldIconButtonSize.sm => const _SizeSpec(32, 14),
      BoldIconButtonSize.md => const _SizeSpec(40, 18),
      BoldIconButtonSize.lg => const _SizeSpec(56, 22),
    };
