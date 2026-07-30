import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_palette.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_tappable.dart';

/// Peso visual do botão (mirror Figma DS).
enum DilettaButtonType {
  primary,
  secondary,
  secondaryPrimary,

  /// Filled branco: superfície branca (surface) + texto PRIMARY + borda neutra
  /// sutil. `secondary` é o cinza SEM fundo.
  white,
  tertiary,
  tertiaryPrimary,

  /// Conteúdo BRANCO pra fundo colorido/escuro (onboarding/splash):
  /// secondaryWhite = outline branco SEM fundo; tertiaryWhite = fill
  /// translúcido branco. Borda 1px.
  secondaryWhite,
  tertiaryWhite,
}

/// Tamanho (mirror Figma DS).
enum DilettaButtonSize { sm, md, lg }

/// Estado semântico — `error` adota paleta destrutiva (bg vermelho, hover
/// darker red), sem mudar o resto da estrutura.
enum DilettaButtonState { normal, error }

/// CPF SEGURO — Button.
///
/// Primitivo do DS. Match direto com o component do Figma:
///
/// - **type** → 5 pesos visuais.
/// - **size** → sm (32h) · md (40h) · lg (56h).
/// - **state** → `normal` | `error` (state=error adota paleta destrutiva).
/// - **leadIcon / trailIcon** → nome do SVG em `assets/icons/`.
///
/// Radius sempre pill (100). Gap 8 entre ícones e label.
///
/// ```dart
/// DilettaButton(label: 'Continuar', onPressed: submit),
/// DilettaButton(
///   label: 'Excluir',
///   type: DilettaButtonType.primary,
///   state: DilettaButtonState.error,
///   size: DilettaButtonSize.lg,
///   fullWidth: true,
///   onPressed: onConfirmDelete,
/// ),
/// DilettaButton(label: 'Cancelar', type: DilettaButtonType.secondary, onPressed: onClose),
/// ```
class DilettaButton extends StatefulWidget {
  const DilettaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = DilettaButtonType.primary,
    this.size = DilettaButtonSize.lg,
    this.state = DilettaButtonState.normal,
    this.leadIcon,
    this.trailIcon,
    this.disabled = false,
    this.isLoading = false,
    this.fullWidth = false,
    this.chatLift = false,
    this.gradient = false,
  });

  /// Variante "chat" — usada quando o botão fica flutuando dentro do chat.
  /// Aplica shadow `primary04Alpha18` + radius 24 (não-pill). Substitui o
  /// antigo `CpfSeguroChatButton` (consolidado como variante deste widget).
  ///
  /// ```dart
  /// DilettaButton.chatLift(label: 'Abrir termos', onPressed: openTerms)
  /// ```
  const DilettaButton.chatLift({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
  })  : type = DilettaButtonType.primary,
        size = DilettaButtonSize.lg,
        state = DilettaButtonState.normal,
        leadIcon = null,
        trailIcon = null,
        isLoading = false,
        fullWidth = true,
        chatLift = true,
        gradient = false;

  final String label;
  final VoidCallback? onPressed;
  final DilettaButtonType type;
  final DilettaButtonSize size;
  final DilettaButtonState state;
  final String? leadIcon;
  final String? trailIcon;
  final bool disabled;

  /// Mostra spinner (three-bounce) e bloqueia o toque, mantendo a cor do tipo.
  final bool isLoading;
  final bool fullWidth;
  final bool chatLift;

  /// Versão DEGRADE (brandLift, o azul mais forte) — vale pra todas as
  /// hierarquias: primary = fill gradient · secondary(s) = border + label
  /// gradient · tertiary(s) = label gradient. Ignorado em disabled/error.
  final bool gradient;

  @override
  State<DilettaButton> createState() => _CpsButtonState();
}

class _CpsButtonState extends State<DilettaButton> {
  bool _hover = false;
  bool _pressed = false;

  // Disabled é ESTADO EXPLÍCITO — onPressed null é só não-interativo
  // (mocks/handoff); o visual default permanece.
  bool get _disabled => widget.disabled;

  @override
  Widget build(BuildContext context) {
    final scheme = DilettaTheme.schemeOf(context);
    final s = _sizeSpec(widget.size);
    final status = _resolveStatus();
    final v = _resolveStyle(widget.type, widget.state, status, scheme);

    final bool useGradient = widget.gradient &&
        !_disabled &&
        widget.state == DilettaButtonState.normal;
    final bool gradientFill = useGradient && widget.type == DilettaButtonType.primary;
    final bool gradientOutline = useGradient &&
        (widget.type == DilettaButtonType.secondary ||
            widget.type == DilettaButtonType.secondaryPrimary);
    // Nas variantes não-fill, o conteúdo renderiza branco e o ShaderMask
    // recolore com o degrade (srcIn).
    final Color contentColor = useGradient && !gradientFill ? scheme.palette.white : v.color;

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leadIcon != null) ...[
          DilettaIconAccessory(icon: widget.leadIcon!, size: s.icon, color: contentColor),
          const SizedBox(width: 8),
        ],
        // Flexible: em largura apertada o label encolhe (fade) em vez de
        // estourar o Row. Sem isto, o Text pega a largura intrínseca e overflow.
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: contentColor,
              fontSize: s.font,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ),
        if (widget.trailIcon != null) ...[
          const SizedBox(width: 8),
          DilettaIconAccessory(icon: widget.trailIcon!, size: s.icon, color: contentColor),
        ],
      ],
    );

    if (widget.isLoading) {
      content = _ThreeBounce(color: contentColor);
    } else if (useGradient && !gradientFill) {
      content = ShaderMask(
        shaderCallback: (bounds) =>
            DilettaGradients.brandLiftDe(scheme.palette).createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: content,
      );
    }

    if (useGradient) {
      Widget gBox;
      if (gradientFill) {
        gBox = Container(
          height: s.h,
          padding: EdgeInsets.symmetric(horizontal: s.px),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: DilettaGradients.brandLiftDe(scheme.palette),
            borderRadius: DilettaRadius.pillAll,
          ),
          child: content,
        );
      } else if (gradientOutline) {
        // Border degrade = camada gradient de 1px com miolo branco.
        gBox = Container(
          height: s.h,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            gradient: DilettaGradients.brandLiftDe(scheme.palette),
            borderRadius: DilettaRadius.pillAll,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: s.px - 1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: DilettaRadius.pillAll,
            ),
            child: content,
          ),
        );
      } else {
        gBox = Container(
          height: s.h,
          padding: EdgeInsets.symmetric(horizontal: s.px),
          alignment: Alignment.center,
          child: content,
        );
      }
      if (widget.fullWidth) gBox = SizedBox(width: double.infinity, child: gBox);
      return DilettaDevInfo(
        component: 'DilettaButton',
        props: {
          'label': "'${widget.label}'",
          'type': widget.type.name,
          'size': widget.size.name,
          'gradient': 'true (brandLift)',
        },
        tokens: const ['gradient: brandLift (primary-03 → 05)', 'radius: pill (200)'],
        child: Semantics(
        button: true,
        enabled: !_disabled,
        label: widget.label,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: DilettaTappable(
            onTap: (_disabled || widget.isLoading) ? null : widget.onPressed,
            child: gBox,
          ),
        ),
        ),
      );
    }

    Widget box = AnimatedContainer(
      duration: DilettaMotion.micro,
      height: s.h,
      padding: EdgeInsets.symmetric(horizontal: s.px),
      decoration: BoxDecoration(
        color: v.bg,
        // chatLift = radius 24 (não-pill) + shadow lift azul.
        borderRadius: widget.chatLift ? DilettaRadius.all24 : DilettaRadius.pillAll,
        border: v.border == null ? null : Border.all(color: v.border!, width: 1),
        boxShadow: widget.chatLift ? DilettaElevation.brandLowDe(scheme.palette) : null,
      ),
      alignment: Alignment.center,
      child: content,
    );

    if (widget.fullWidth) {
      box = SizedBox(width: double.infinity, child: box);
    }

    return DilettaDevInfo(
      component: 'DilettaButton',
      props: {
        'label': "'${widget.label}'",
        'type': widget.type.name,
        'size': '${widget.size.name} (${s.h.toInt()}h)',
        'state': widget.state.name,
        if (widget.gradient) 'gradient': 'true (brandLift)',
        if (widget.leadIcon != null) 'leadIcon': widget.leadIcon!,
        if (widget.trailIcon != null) 'trailIcon': widget.trailIcon!,
      },
      tokens: [
        'bg: ${nomeDoToken(context, v.bg)}',
        'label: ${nomeDoToken(context, v.color)} · ${s.font.toInt()}/500',
        if (v.border != null) 'border: ${nomeDoToken(context, v.border)}',
        'radius: pill (200)',
      ],
      child: Semantics(
      button: true,
      enabled: !_disabled,
      label: widget.label,
      child: MouseRegion(
        cursor: _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() {
          _hover = false;
          _pressed = false;
        }),
        child: DilettaTappable(
          onTap: (_disabled || widget.isLoading) ? null : widget.onPressed,
          onPressedChange: (p) => setState(() => _pressed = p),
          pressedOpacity: 1.0,
          child: box,
        ),
      ),
      ),
    );
  }

  _Status _resolveStatus() {
    if (_disabled) return _Status.disabled;
    if (_pressed) return _Status.pressed;
    if (_hover) return _Status.hover;
    return _Status.normal;
  }
}

// ============================================================================
// Style resolvers
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

// As duas paletas internas do botão eram `const` no topo do arquivo — e por isso
// só podiam ler a classe ESTÁTICA de cores. Agora são função da paleta do tema:
// é o que faz a identidade de um DS-filho chegar até aqui.
_Palette _paletaDeMarca(DilettaPalette p) => _Palette(
      base: p.primary04,
      hover: p.primary03,
      pressed: p.primary02,
      onBase: p.onPrimary,
      bgHoverGhost: p.primary08,
    );

_Palette _paletaDeErro(DilettaPalette p) => _Palette(
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

_StyleShape _resolveStyle(
    DilettaButtonType type, DilettaButtonState state, _Status status, DilettaScheme s) {
  final bool isError = state == DilettaButtonState.error;
  final p = isError ? _paletaDeErro(s.palette) : _paletaDeMarca(s.palette);

  if (status == _Status.disabled) {
    if (type == DilettaButtonType.secondaryWhite) {
      return _StyleShape(
          bg: Colors.transparent,
          color: s.palette.white.withValues(alpha: 0.4),
          border: s.palette.white.withValues(alpha: 0.4));
    }
    if (type == DilettaButtonType.tertiaryWhite) {
      return _StyleShape(
          bg: s.palette.white.withValues(alpha: 0.06),
          color: s.palette.white.withValues(alpha: 0.4),
          border: s.palette.white.withValues(alpha: 0.25));
    }
    // Filled surface (secondaryPrimary/white) mantém superfície + borda;
    // secondary (outline) fica transparente + borda; tertiary sem borda.
    final bool filled = type == DilettaButtonType.secondaryPrimary ||
        type == DilettaButtonType.white;
    final bool outlined = type == DilettaButtonType.secondary;
    return _StyleShape(
      bg: type == DilettaButtonType.primary
          ? s.palette.neutral08
          : type == DilettaButtonType.white
              ? s.palette.white
              : filled
                  ? s.surface
                  : Colors.transparent,
      color: s.palette.neutral05,
      // white = sem borda (só fill); só secondaryPrimary/secondary levam borda.
      border: (type == DilettaButtonType.secondaryPrimary || outlined)
          ? s.palette.neutral08
          : null,
    );
  }

  // Marca resolvida pelo scheme (dark clareia). Error mantém paleta destrutiva.
  final Color brandBase = isError ? p.base : s.primary; // primary04 → s.primary
  final Color brandGhost = isError ? p.bgHoverGhost : s.primarySubtle; // primary08 → s.primarySubtle

  switch (type) {
    case DilettaButtonType.primary:
      final bg = status == _Status.hover
          ? p.hover
          : status == _Status.pressed
              ? p.pressed
              : brandBase;
      return _StyleShape(bg: bg, color: p.onBase);
    case DilettaButtonType.secondary:
      // Outline cinza SEM fundo (error = outline vermelho). Hover/pressed = wash.
      final bg = status == _Status.hover
          ? s.surfaceMuted
          : status == _Status.pressed
              ? s.palette.neutral08
              : Colors.transparent;
      final c = isError ? s.palette.error04 : s.textTertiary;
      return _StyleShape(bg: bg, color: c, border: c);
    case DilettaButtonType.white:
      // SEMPRE branco (dark tbm) + texto primary/error. SEM borda (só fill).
      final bg = status == _Status.hover
          ? s.palette.neutral10
          : status == _Status.pressed
              ? s.palette.neutral09
              : s.palette.white;
      return _StyleShape(
          bg: bg,
          color: isError ? s.palette.error03 : s.palette.primary04);
    case DilettaButtonType.secondaryPrimary:
      final bg = (status == _Status.hover || status == _Status.pressed)
          ? brandGhost
          : Colors.transparent;
      return _StyleShape(bg: bg, color: brandBase, border: brandBase);
    case DilettaButtonType.tertiary:
      final bg = status == _Status.hover
          ? s.surfaceMuted
          : status == _Status.pressed
              ? s.palette.neutral08
              : Colors.transparent;
      return _StyleShape(
          bg: bg, color: isError ? s.palette.error04 : s.textTertiary);
    case DilettaButtonType.tertiaryPrimary:
      final bg = (status == _Status.hover || status == _Status.pressed)
          ? brandGhost
          : Colors.transparent;
      return _StyleShape(bg: bg, color: brandBase);
    case DilettaButtonType.secondaryWhite:
      // Outline BRANCO pra fundo colorido (sem fundo).
      final bg = status == _Status.hover
          ? s.palette.white.withValues(alpha: 0.10)
          : status == _Status.pressed
              ? s.palette.white.withValues(alpha: 0.16)
              : Colors.transparent;
      return _StyleShape(
          bg: bg, color: s.palette.white, border: s.palette.white);
    case DilettaButtonType.tertiaryWhite:
      // Fill translúcido branco + borda branca 1px.
      final bg = status == _Status.hover
          ? s.palette.white.withValues(alpha: 0.22)
          : status == _Status.pressed
              ? s.palette.white.withValues(alpha: 0.28)
              : s.palette.white.withValues(alpha: 0.14);
      return _StyleShape(
          bg: bg,
          color: s.palette.white,
          border: s.palette.white.withValues(alpha: 0.38));
  }
}

class _SizeSpec {
  const _SizeSpec({required this.h, required this.px, required this.font, required this.icon});
  final double h;
  final double px;
  final double font;
  final double icon;
}

_SizeSpec _sizeSpec(DilettaButtonSize size) => switch (size) {
      DilettaButtonSize.sm => const _SizeSpec(h: 32, px: 12, font: 12, icon: 14),
      DilettaButtonSize.md => const _SizeSpec(h: 40, px: 14, font: 13, icon: 16),
      DilettaButtonSize.lg => const _SizeSpec(h: 56, px: 16, font: 14, icon: 18),
    };

/// Spinner "three-bounce" inline (3 dots pulando em sequência) — evita
/// dependência de plugin no catálogo. Cor herda o conteúdo do botão.
class _ThreeBounce extends StatefulWidget {
  const _ThreeBounce({required this.color});
  final Color color;

  /// Era parâmetro opcional que nenhum chamador passava. Fica como campo (não estático)
  /// porque o `State` o lê pela instância.
  final double size = 16;

  @override
  State<_ThreeBounce> createState() => _ThreeBounceState();
}

class _ThreeBounceState extends State<_ThreeBounce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _scale(double t) {
    final v = t < 0.5 ? t * 2 : (1 - t) * 2; // triângulo 0→1→0
    return 0.1 + 0.9 * v;
  }

  @override
  Widget build(BuildContext context) {
    final dot = widget.size * 0.3;
    return SizedBox(
      width: widget.size,
      height: dot,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: dot * 0.4),
              Transform.scale(
                scale: _scale((_c.value + 1 - i * 0.25) % 1.0),
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
