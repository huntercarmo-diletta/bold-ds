import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// Orientação do MenuButton.
enum DilettaMenuButtonVariant {
  /// Icon acima de label (rail vertical, ex: WebNavRail).
  vertical,

  /// Icon à esquerda de label (menu horizontal/contextual).
  horizontal,

  /// Card de atalho sólido 97×97 (fill primary, ícone + label brancos). Ação
  /// one-shot da home pix — sem estado active/hover. Decisão: mesmo word do
  /// nav-item, variantes distintas.
  tile,
}

/// CPF SEGURO — MenuButton.
///
/// Botão de item de menu. Hover é capturado internamente; `active` liga o
/// estado "selected" externamente.
///
/// **Vertical** (rail):
/// - default:  glyph neutral-02 + label neutral-02 (label invisível pra reservar espaço)
/// - hover:    círculo com border primary-04, glyph primary-04, label primary-04
/// - selected: círculo fill primary-04, glyph branco, label primary-04
///
/// **Horizontal**:
/// - default:  bg transparent, glyph+label neutral-04
/// - hover:    bg primary-state-hover, glyph+label neutral-02
/// - selected: bg primary-state-selected, glyph+label primary-04
///
/// ```dart
/// DilettaMenuButton(icon: DilettaIcons.chartLineSolid, label: 'Dashboard', active: tab == 'dash'),
/// DilettaMenuButton(
///   icon: DilettaIcons.fileLight,
///   label: 'Arquivos',
///   variant: DilettaMenuButtonVariant.horizontal,
///   onPressed: () => selectFiles(),
/// ),
/// ```
class DilettaMenuButton extends StatefulWidget {
  const DilettaMenuButton({
    super.key,
    required this.icon,
    required this.label,
    this.variant = DilettaMenuButtonVariant.vertical,
    this.active = false,
    this.onPressed,
    this.semanticLabel,
  });

  final String icon;
  final String label;
  final DilettaMenuButtonVariant variant;
  final bool active;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  State<DilettaMenuButton> createState() => _CpsMenuButtonState();
}

enum _MenuState { normal, hover, selected }

class _CpsMenuButtonState extends State<DilettaMenuButton> {
  bool _hover = false;

  _MenuState get _state {
    if (widget.active) return _MenuState.selected;
    if (_hover) return _MenuState.hover;
    return _MenuState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final content = switch (widget.variant) {
      DilettaMenuButtonVariant.vertical => _vertical(s, _state),
      DilettaMenuButtonVariant.horizontal => _horizontal(s, _state),
      DilettaMenuButtonVariant.tile => _tile(s),
    };

    return DilettaDevInfo(
      component: 'DilettaMenuButton',
      props: {'label': "'${widget.label}'", 'icon': widget.icon, 'variant': widget.variant.name, 'active': '${widget.active}'},
      tokens: const ['radius 8 · ativo bg primary-08 / label primary-04'],
      child: Semantics(
      button: true,
      selected: widget.active,
      label: widget.semanticLabel ?? widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: DilettaTappable(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: content,
        ),
      ),
    ),
    );
  }

  Widget _vertical(DilettaScheme s, _MenuState state) {
    final isDefault = state == _MenuState.normal;
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _VerticalIconBubble(icon: widget.icon, state: state),
          const SizedBox(height: 4),
          Visibility(
            visible: !isDefault,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Text(
              widget.label,
              style: DilettaType.label.copyWith(
                color: s.primary,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(DilettaScheme s) {
    return Container(
      width: 97,
      height: 97,
      padding: const EdgeInsets.all(DilettaSpacing.s4),
      decoration: BoxDecoration(
        color: s.primary,
        borderRadius: DilettaRadius.all16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DilettaIconAccessory(
              icon: widget.icon,
              padding: 0,
              size: 22,
              color: s.palette.white),
          Text(
            widget.label,
            maxLines: 2,
            style: DilettaType.subheading.copyWith(
                color: s.palette.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _horizontal(DilettaScheme s, _MenuState state) {
    final bg = state == _MenuState.selected
        ? s.primaryPressed
        : state == _MenuState.hover
            ? s.primaryHover
            : DilettaAbsoluteColors.transparent;
    final color = state == _MenuState.selected
        ? s.primary
        : state == _MenuState.hover
            ? s.textSecondary
            : s.textMuted;
    return AnimatedContainer(
      duration: DilettaMotion.micro,
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2, vertical: DilettaSpacing.s1),
      decoration: BoxDecoration(color: bg, borderRadius: DilettaRadius.all16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaIconAccessory(icon: widget.icon, padding: 0, size: 12, color: color),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: DilettaType.subheading.copyWith(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _VerticalIconBubble extends StatelessWidget {
  const _VerticalIconBubble({required this.icon, required this.state});
  final String icon;
  final _MenuState state;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final isSelected = state == _MenuState.selected;
    final isHover = state == _MenuState.hover;
    final bg = isSelected ? s.primary : DilettaAbsoluteColors.transparent;
    final border = isHover ? s.primary : DilettaAbsoluteColors.transparent;
    final glyph = isSelected
        ? s.palette.white
        : isHover
            ? s.primary
            : s.textSecondary;
    return AnimatedContainer(
      duration: DilettaMotion.micro,
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(color: border, width: 1),
      ),
      child: DilettaIconAccessory(icon: icon, padding: 0, size: 18, color: glyph),
    );
  }
}
