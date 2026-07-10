import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';
import '../theme/bold_typography.dart';
import 'bold_button.dart';
import 'bold_icon.dart';
import 'bold_icon_button.dart';
import 'bold_input_chip.dart';

// ═══════════════════════════════════════════════════════════════════════════
// BoldNavLeftAccessory (molécula) — 3 variantes: back / close / home
// ═══════════════════════════════════════════════════════════════════════════

/// Slot esquerdo do [BoldNavTopBar].
///
/// - `.back(onPressed:)`  → IconButton ghost com seta
/// - `.close(onPressed:)` → IconButton ghost com xmark
/// - `.home(firstName:)`  → avatar circulado primário + "Olá, {name}!"
sealed class BoldNavLeftAccessory extends StatelessWidget {
  const BoldNavLeftAccessory({super.key});

  const factory BoldNavLeftAccessory.back({
    Key? key,
    VoidCallback? onPressed,
  }) = _NavLeftBack;

  const factory BoldNavLeftAccessory.close({
    Key? key,
    VoidCallback? onPressed,
  }) = _NavLeftClose;

  const factory BoldNavLeftAccessory.home({
    Key? key,
    required String firstName,
    VoidCallback? onOpenProfile,
    String? accountLabel,
    VoidCallback? onSwitchAccount,
  }) = _NavLeftHome;
}

class _NavLeftBack extends BoldNavLeftAccessory {
  const _NavLeftBack({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BoldIconButton(
      icon: 'arrow-left-light',
      semanticLabel: 'Voltar',
      type: BoldIconButtonType.tertiary,
      flush: BoldIconFlush.left,
      onPressed: onPressed,
    );
  }
}

class _NavLeftClose extends BoldNavLeftAccessory {
  const _NavLeftClose({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BoldIconButton(
      icon: 'close',
      semanticLabel: 'Fechar',
      type: BoldIconButtonType.tertiary,
      size: BoldIconButtonSize.sm,
      iconSize: 18,
      flush: BoldIconFlush.left,
      onPressed: onPressed,
    );
  }
}

class _NavLeftHome extends BoldNavLeftAccessory {
  const _NavLeftHome({
    super.key,
    required this.firstName,
    this.onOpenProfile,
    this.accountLabel,
    this.onSwitchAccount,
  });
  final String firstName;
  final VoidCallback? onOpenProfile;

  /// Conta ativa ("Conta PF") — rende um [BoldInputChip] de troca sob o nome.
  final String? accountLabel;
  final VoidCallback? onSwitchAccount;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Avatar 40 (spec Redesenho): stroke 1px primary-04 + inicial primary-04
    // + mini-avatar 16px no canto (user-light, fill branco, stroke 0.75
    // neutral-08).
    final avatar = SizedBox(
      width: 40,
      height: 40,
      child: Stack(clipBehavior: Clip.none, children: [
        ClipOval(
          child: BackdropFilter(
            filter: BoldGlass.blurFilter,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BoldGlass.fill(c),
                shape: BoxShape.circle,
                border: Border.all(
                    color: BoldGlass.border(c), width: BoldGlass.borderWidth),
              ),
              child: Text(firstName.isEmpty ? '?' : firstName[0].toUpperCase(),
                  style: BoldType.title
                      .copyWith(fontSize: 15, color: c.textPrimary)),
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BoldColors.white,
              shape: BoxShape.circle,
              border:
                  Border.all(color: BoldColors.neutral08, width: 0.75),
            ),
            child: const BoldIcon('user-light',
                size: 8, color: BoldColors.neutral02),
          ),
        ),
      ]),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'Abrir perfil de $firstName',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onOpenProfile,
            child: avatar,
          ),
        ),
        const SizedBox(width: 16),
        // Title/medium do Redesenho, mais bold.
        Text('Olá, $firstName!',
            style: BoldType.titleMd
                .copyWith(fontWeight: FontWeight.w700, color: c.textPrimary)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BoldNavRightAccessory (molécula) — icons / botão pequeno / input chip
// ═══════════════════════════════════════════════════════════════════════════

/// Descriptor de um IconButton no [BoldNavRightAccessory.icons].
class BoldNavRightIcon {
  const BoldNavRightIcon({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.badge = false,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool badge;
}

/// Slot direito do [BoldNavTopBar].
///
/// - `.icons(icons:)`   → 1–3 IconButtons tertiary (gap 8)
/// - `.button(label:)`  → BoldButton text/sm inline
/// - `.inputChip(label:)` → chip dropdown de contexto ("Conta PF ▾")
sealed class BoldNavRightAccessory extends StatelessWidget {
  const BoldNavRightAccessory({super.key});

  const factory BoldNavRightAccessory.icons({
    Key? key,
    required List<BoldNavRightIcon> icons,
  }) = _NavRightIcons;

  const factory BoldNavRightAccessory.button({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) = _NavRightButton;

  const factory BoldNavRightAccessory.inputChip({
    Key? key,
    required String label,
    String trailIcon,
    VoidCallback? onPressed,
  }) = _NavRightInputChip;
}

class _NavRightIcons extends BoldNavRightAccessory {
  // Regra do DS: 1 a 3 ícones (não dá pra assert em const — List.length não é
  // const-evaluável).
  const _NavRightIcons({super.key, required this.icons});

  final List<BoldNavRightIcon> icons;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < icons.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          BoldIconButton(
            icon: icons[i].icon,
            semanticLabel: icons[i].semanticLabel,
            // Spec Redesenho: ícones de top bar são TERTIARY (brancos soltos).
            type: BoldIconButtonType.tertiary,
            onPressed: icons[i].onPressed,
            badge: icons[i].badge,
          ),
        ],
      ],
    );
  }
}

class _NavRightButton extends BoldNavRightAccessory {
  const _NavRightButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BoldButton(label,
        variant: BoldButtonVariant.text,
        size: BoldButtonSize.sm,
        expand: false,
        onPressed: onPressed);
  }
}

class _NavRightInputChip extends BoldNavRightAccessory {
  const _NavRightInputChip({
    super.key,
    required this.label,
    this.trailIcon = 'chevron-down',
    this.onPressed,
  });

  final String label;
  final String trailIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BoldInputChip(label: label, trailIcon: trailIcon, onTap: onPressed);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BoldNavTopBar (molécula) — left + title + right, altura 52
// ═══════════════════════════════════════════════════════════════════════════

/// Conta BOLD — NavTopBar (molécula). A LINHA de navegação `left + title +
/// right` (h52). Sem glass e sem safe-area — isso é papel do [BoldTopBar]
/// (organismo). Título centralizado por default; [titleWidget] sobrepõe.
///
/// **Composição** — BoldNavLeftAccessory/BoldNavRightAccessory (moléculas) +
/// tokens de tipografia.
class BoldNavTopBar extends StatelessWidget {
  const BoldNavTopBar({
    super.key,
    this.left,
    this.right,
    this.title,
    this.titleWidget,
    this.centerAlign = TextAlign.center,
  });

  final BoldNavLeftAccessory? left;
  final BoldNavRightAccessory? right;
  final String? title;
  final Widget? titleWidget;
  final TextAlign centerAlign;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final centerContent = titleWidget ??
        (title != null
            ? Text(title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BoldType.title
                    .copyWith(fontSize: 17, color: c.textPrimary))
            : null);

    // Sem padding vertical: os IconButtons (40×40) precisam da altura livre.
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (left != null) left! else const SizedBox(width: 40),
          if (centerAlign == TextAlign.center)
            Expanded(child: Center(child: centerContent ?? const SizedBox()))
          else
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft, child: centerContent),
            ),
          if (right != null) right! else const SizedBox(width: 40),
        ],
      ),
    );
  }
}
