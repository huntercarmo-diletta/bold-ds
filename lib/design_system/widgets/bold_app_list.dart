import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_app_bar.dart' show BoldAvatar;
import 'bold_card.dart';
import 'bold_checkbox.dart';
import 'bold_controls.dart';
import 'bold_icon.dart';
import 'bold_icon_button.dart';
import 'bold_list.dart';

export 'bold_status_tag.dart' show BoldStatusTone, BoldStatusTagData;

/// # BoldAppList — a row canônica do DS (portada do "App list" do cpf-seguro,
/// adaptada ao Redesenho v.01: ink BRANCO + superfície glass).
///
/// Sempre 3 slots: `[ Left ] [ Middle (expanded) ] [ Right ]`. Cada slot é uma
/// sealed class com named constructors `const` — cada variante suportada vira
/// uma factory. Reusa os componentes BOLD já existentes ([BoldSpotIcon],
/// [BoldAvatar], [BoldStatusTag], [BoldCheckbox], [BoldSwitch], [BoldIcon],
/// [BoldIconButton], [BoldListTime]/[BoldListAmount]).
///
/// ```dart
/// BoldAppList(
///   left: BoldLeftAccessory.spotIcon(icon: 'user-light', tone: BoldSpotTone.primary),
///   middle: BoldMiddleAccessory.titleSubtitle(title: 'Dados', subtitle: 'Nome, CPF'),
///   right: const BoldRightAccessory.action(),
///   onTap: abrir,
/// )
/// ```

// ═══════════════════════════════════════════════════════════════════════════
// Helpers / badge
// ═══════════════════════════════════════════════════════════════════════════

/// Dot de atenção no canto sup-direito de um ícone.
enum BoldBadge { none, primary, danger, success }

Color? _badgeColor(BoldBadge b) => switch (b) {
      BoldBadge.none => null,
      BoldBadge.primary => BoldColors.primary04,
      BoldBadge.danger => BoldColors.error04,
      BoldBadge.success => BoldColors.success04,
    };

/// Wrapper de ícone + badge dot opcional (leading "solto", sem círculo).
class BoldIconAccessory extends StatelessWidget {
  const BoldIconAccessory({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.badge = BoldBadge.none,
  });

  final String icon;
  final double size;
  final Color? color;
  final BoldBadge badge;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final bc = _badgeColor(badge);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
        BoldIcon(icon, size: size, color: color ?? c.textPrimary),
        if (bc != null)
          Positioned(
            top: -1,
            right: -1,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: bc, shape: BoxShape.circle),
            ),
          ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LEFT ACCESSORY
// ═══════════════════════════════════════════════════════════════════════════

/// Slot esquerdo. Variantes: spotIcon · avatar · iconAccessory · custom.
/// Sempre centralizado no [BoldAppList] (altura da row).
sealed class BoldLeftAccessory extends StatelessWidget {
  const BoldLeftAccessory({super.key});

  const factory BoldLeftAccessory.spotIcon({
    Key? key,
    required String icon,
    BoldSpotTone tone,
    bool filled,
    bool badge,
    double size,
  }) = _LeftSpotIcon;

  const factory BoldLeftAccessory.avatar({
    Key? key,
    required String initials,
    double size,
  }) = _LeftAvatar;

  const factory BoldLeftAccessory.iconAccessory({
    Key? key,
    required String icon,
    double size,
    Color? color,
    BoldBadge badge,
  }) = _LeftIconAccessory;

  const factory BoldLeftAccessory.custom({
    Key? key,
    required Widget child,
  }) = _LeftCustom;
}

class _LeftSpotIcon extends BoldLeftAccessory {
  const _LeftSpotIcon({
    super.key,
    required this.icon,
    this.tone = BoldSpotTone.neutral,
    this.filled = false,
    this.badge = false,
    this.size = 38,
  });
  final String icon;
  final BoldSpotTone tone;
  final bool filled;
  final bool badge;
  final double size;

  @override
  Widget build(BuildContext context) =>
      BoldSpotIcon(icon, tone: tone, filled: filled, badge: badge, size: size);
}

class _LeftAvatar extends BoldLeftAccessory {
  const _LeftAvatar({super.key, required this.initials, this.size = 40});
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) =>
      BoldAvatar(initials: initials, size: size);
}

class _LeftIconAccessory extends BoldLeftAccessory {
  const _LeftIconAccessory({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.badge = BoldBadge.none,
  });
  final String icon;
  final double size;
  final Color? color;
  final BoldBadge badge;

  @override
  Widget build(BuildContext context) =>
      BoldIconAccessory(icon: icon, size: size, color: color, badge: badge);
}

class _LeftCustom extends BoldLeftAccessory {
  const _LeftCustom({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}

// ═══════════════════════════════════════════════════════════════════════════
// MIDDLE ACCESSORY (sempre Expanded)
// ═══════════════════════════════════════════════════════════════════════════

/// Slot do meio — sempre `Expanded`. Variantes de layout de texto.
/// `disabled` esmaece (title→muted, sub→mais muted).
sealed class BoldMiddleAccessory extends StatelessWidget {
  const BoldMiddleAccessory({super.key});

  const factory BoldMiddleAccessory.title({
    Key? key,
    required String title,
    bool disabled,
    int maxLines,
  }) = _MiddleTitle;

  const factory BoldMiddleAccessory.titleSubtitle({
    Key? key,
    required String title,
    String? subtitle,
    bool disabled,
  }) = _MiddleTitleSubtitle;

  /// título + `subtitle • accessorySubtitle` inline (extrato).
  const factory BoldMiddleAccessory.titleSubtitleSubtitle({
    Key? key,
    required String title,
    String? subtitle,
    String? accessorySubtitle,
    bool disabled,
  }) = _MiddleTitleSubSub;

  const factory BoldMiddleAccessory.labelTitleSubtitle({
    Key? key,
    String? label,
    required String title,
    String? subtitle,
    bool disabled,
  }) = _MiddleLabelTitleSub;

  /// título/subtítulo esq + [BoldStatusTag] à direita.
  const factory BoldMiddleAccessory.titleSubtitleTag({
    Key? key,
    required String title,
    String? subtitle,
    required String tagLabel,
    required BoldStatusTone tagTone,
    String? tagIcon,
    bool disabled,
  }) = _MiddleTitleSubTag;

  /// Só subtítulo/body (sem título). Portado do DS CPF Seguro.
  const factory BoldMiddleAccessory.subtitle({
    Key? key,
    required String subtitle,
    bool disabled,
  }) = _MiddleSubtitle;

  /// Título + body + label (rodapé). Portado do DS CPF Seguro.
  const factory BoldMiddleAccessory.titleBodyLabel({
    Key? key,
    required String title,
    String? body,
    String? label,
    bool disabled,
  }) = _MiddleTitleBodyLabel;

  /// 2 colunas: (título/subtítulo) esq · (accessoryTitle + tag) dir. Portado
  /// do DS CPF Seguro — rows de extrato/status com valor à direita.
  const factory BoldMiddleAccessory.titleSubtitleAtitleTag({
    Key? key,
    required String title,
    String? subtitle,
    required String accessoryTitle,
    required String tagLabel,
    required BoldStatusTone tagTone,
    String? tagIcon,
    bool disabled,
  }) = _MiddleTitleSubAtitleTag;

  /// 2 colunas: (título/subtítulo) esq · (accessoryTitle/accessorySubtitle)
  /// dir. Portado do DS CPF Seguro.
  const factory BoldMiddleAccessory.titleSubtitleAtitleAsubtitle({
    Key? key,
    required String title,
    String? subtitle,
    required String accessoryTitle,
    String? accessorySubtitle,
    bool disabled,
  }) = _MiddleTitleSubAtitleAsub;

  const factory BoldMiddleAccessory.custom({
    Key? key,
    required Widget child,
  }) = _MiddleCustom;
}

// estilos (ink branco no dark)
TextStyle _mTitle(BoldScheme c, bool disabled) => BoldType.title.copyWith(
    fontSize: 15, color: disabled ? c.textMuted : c.textPrimary);
TextStyle _mSub(BoldScheme c, bool disabled) => BoldType.bodySmall.copyWith(
    fontSize: 12.5, color: disabled ? c.textMuted : c.textSecondary);
TextStyle _mEyebrow(BoldScheme c) =>
    BoldType.bodySmall.copyWith(fontSize: 12, color: c.textSecondary);

class _MiddleTitle extends BoldMiddleAccessory {
  const _MiddleTitle(
      {super.key, required this.title, this.disabled = false, this.maxLines = 1});
  final String title;
  final bool disabled;

  /// Nº de linhas antes de reticenciar. Default 1 (linha única, comportamento
  /// antigo); use 2 quando o rótulo for longo e não deva truncar.
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Text(title, maxLines: maxLines, overflow: TextOverflow.ellipsis,
        style: _mTitle(c, disabled));
  }
}

class _MiddleTitleSubtitle extends BoldMiddleAccessory {
  const _MiddleTitleSubtitle(
      {super.key, required this.title, this.subtitle, this.disabled = false});
  final String title;
  final String? subtitle;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: _mTitle(c, disabled)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mSub(c, disabled)),
        ],
      ],
    );
  }
}

class _MiddleTitleSubSub extends BoldMiddleAccessory {
  const _MiddleTitleSubSub({
    super.key,
    required this.title,
    this.subtitle,
    this.accessorySubtitle,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String? accessorySubtitle;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final parts = <String>[
      if (subtitle != null) subtitle!,
      if (accessorySubtitle != null) accessorySubtitle!,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: _mTitle(c, disabled)),
        if (parts.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(parts.join(' • '), maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mSub(c, disabled)),
        ],
      ],
    );
  }
}

class _MiddleLabelTitleSub extends BoldMiddleAccessory {
  const _MiddleLabelTitleSub({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.disabled = false,
  });
  final String? label;
  final String title;
  final String? subtitle;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mEyebrow(c)),
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: _mTitle(c, disabled)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mSub(c, disabled)),
        ],
      ],
    );
  }
}

class _MiddleTitleSubTag extends BoldMiddleAccessory {
  const _MiddleTitleSubTag({
    super.key,
    required this.title,
    this.subtitle,
    required this.tagLabel,
    required this.tagTone,
    this.tagIcon,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String tagLabel;
  final BoldStatusTone tagTone;
  final String? tagIcon;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: _mTitle(c, disabled)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: _mSub(c, disabled)),
            ],
          ],
        ),
      ),
      const SizedBox(width: 12),
      BoldStatusTag(label: tagLabel, tone: tagTone, icon: tagIcon),
    ]);
  }
}

class _MiddleSubtitle extends BoldMiddleAccessory {
  const _MiddleSubtitle({super.key, required this.subtitle, this.disabled = false});
  final String subtitle;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: _mSub(c, disabled)),
    );
  }
}

class _MiddleTitleBodyLabel extends BoldMiddleAccessory {
  const _MiddleTitleBodyLabel({
    super.key,
    required this.title,
    this.body,
    this.label,
    this.disabled = false,
  });
  final String title;
  final String? body;
  final String? label;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: _mTitle(c, disabled)),
        if (body != null) ...[
          const SizedBox(height: 2),
          Text(body!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mSub(c, disabled)),
        ],
        if (label != null) ...[
          const SizedBox(height: 2),
          Text(label!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mEyebrow(c)),
        ],
      ],
    );
  }
}

class _MiddleTitleSubAtitleTag extends BoldMiddleAccessory {
  const _MiddleTitleSubAtitleTag({
    super.key,
    required this.title,
    this.subtitle,
    required this.accessoryTitle,
    required this.tagLabel,
    required this.tagTone,
    this.tagIcon,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String accessoryTitle;
  final String tagLabel;
  final BoldStatusTone tagTone;
  final String? tagIcon;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: _mTitle(c, disabled)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: _mSub(c, disabled)),
            ],
          ],
        ),
      ),
      const SizedBox(width: 12),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(accessoryTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mTitle(c, disabled)),
          const SizedBox(height: 2),
          BoldStatusTag(label: tagLabel, tone: tagTone, icon: tagIcon),
        ],
      ),
    ]);
  }
}

class _MiddleTitleSubAtitleAsub extends BoldMiddleAccessory {
  const _MiddleTitleSubAtitleAsub({
    super.key,
    required this.title,
    this.subtitle,
    required this.accessoryTitle,
    this.accessorySubtitle,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String accessoryTitle;
  final String? accessorySubtitle;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: _mTitle(c, disabled)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: _mSub(c, disabled)),
            ],
          ],
        ),
      ),
      const SizedBox(width: 12),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(accessoryTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: _mTitle(c, disabled)),
          if (accessorySubtitle != null) ...[
            const SizedBox(height: 2),
            Text(accessorySubtitle!, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: _mSub(c, disabled)),
          ],
        ],
      ),
    ]);
  }
}

class _MiddleCustom extends BoldMiddleAccessory {
  const _MiddleCustom({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}

// ═══════════════════════════════════════════════════════════════════════════
// RIGHT ACCESSORY
// ═══════════════════════════════════════════════════════════════════════════

/// Slot direito. Variantes: action(chevron) · icon · status · amount ·
/// time · timeStatus · toggle · checkbox · radio · custom.
sealed class BoldRightAccessory extends StatelessWidget {
  const BoldRightAccessory({super.key});

  const factory BoldRightAccessory.action({Key? key}) = _RightAction;

  const factory BoldRightAccessory.icon({
    Key? key,
    required String icon,
    required String semanticLabel,
    VoidCallback? onPressed,
    BoldIconButtonType type,
  }) = _RightIcon;

  const factory BoldRightAccessory.status({
    Key? key,
    required String label,
    required BoldStatusTone tone,
    String? icon,
  }) = _RightStatus;

  const factory BoldRightAccessory.amount({
    Key? key,
    required String value,
    bool negative,
    bool credit,
    bool strikethrough,
  }) = _RightAmount;

  /// Valor (texto) + chevron — linha que abre pra editar (ex.: Meus Limites,
  /// configurações com valor atual). Combina [amount] read-only com [action].
  const factory BoldRightAccessory.valueAction({
    Key? key,
    required String value,
  }) = _RightValueAction;

  /// Valor num chip (pill): ícone opcional + valor. Portado do DS CPF Seguro —
  /// crédito destacado no extrato/atividade.
  const factory BoldRightAccessory.amountChip({
    Key? key,
    required String amount,
    String? icon,
    BoldStatusTone tone,
  }) = _RightAmountChip;

  const factory BoldRightAccessory.time({Key? key, required String time}) =
      _RightTime;

  const factory BoldRightAccessory.timeStatus({
    Key? key,
    required String time,
    required BoldStatusTagData status,
  }) = _RightTimeStatus;

  const factory BoldRightAccessory.toggle({
    Key? key,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) = _RightToggle;

  const factory BoldRightAccessory.checkbox({
    Key? key,
    required bool checked,
    required ValueChanged<bool> onChanged,
  }) = _RightCheckbox;

  const factory BoldRightAccessory.radio({
    Key? key,
    required bool selected,
    required VoidCallback onPressed,
  }) = _RightRadio;

  const factory BoldRightAccessory.custom({Key? key, required Widget child}) =
      _RightCustom;
}

class _RightAction extends BoldRightAccessory {
  const _RightAction({super.key});
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return BoldIcon('chevron-right', size: BoldIconSize.md, color: c.textMuted);
  }
}

class _RightIcon extends BoldRightAccessory {
  const _RightIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.type = BoldIconButtonType.tertiary,
  });
  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final BoldIconButtonType type;
  @override
  Widget build(BuildContext context) => BoldIconButton(
      icon: icon,
      semanticLabel: semanticLabel,
      type: type,
      size: BoldIconButtonSize.md,
      onPressed: onPressed);
}

class _RightStatus extends BoldRightAccessory {
  const _RightStatus(
      {super.key, required this.label, required this.tone, this.icon});
  final String label;
  final BoldStatusTone tone;
  final String? icon;
  @override
  Widget build(BuildContext context) =>
      BoldStatusTag(label: label, tone: tone, icon: icon);
}

class _RightAmount extends BoldRightAccessory {
  const _RightAmount({
    super.key,
    required this.value,
    this.negative = false,
    this.credit = false,
    this.strikethrough = false,
  });
  final String value;
  final bool negative;
  final bool credit;
  final bool strikethrough;
  @override
  Widget build(BuildContext context) => BoldListAmount(value,
      negative: negative, credit: credit, strikethrough: strikethrough);
}

class _RightValueAction extends BoldRightAccessory {
  const _RightValueAction({super.key, required this.value});
  final String value;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: BoldType.labelMd.copyWith(color: c.textPrimary)),
      const SizedBox(width: 6),
      BoldIcon('chevron-right', size: BoldIconSize.md, color: c.textMuted),
    ]);
  }
}

class _RightAmountChip extends BoldRightAccessory {
  const _RightAmountChip({
    super.key,
    required this.amount,
    this.icon,
    this.tone = BoldStatusTone.neutral,
  });
  final String amount;
  final String? icon;
  final BoldStatusTone tone;
  @override
  Widget build(BuildContext context) =>
      BoldStatusTag(label: amount, tone: tone, icon: icon);
}

class _RightTime extends BoldRightAccessory {
  const _RightTime({super.key, required this.time});
  final String time;
  @override
  Widget build(BuildContext context) => BoldListTime(time);
}

class _RightTimeStatus extends BoldRightAccessory {
  const _RightTimeStatus({super.key, required this.time, required this.status});
  final String time;
  final BoldStatusTagData status;
  @override
  Widget build(BuildContext context) =>
      BoldListTimeStatus(time: time, status: status);
}

class _RightToggle extends BoldRightAccessory {
  const _RightToggle(
      {super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) =>
      BoldSwitch(value: value, onChanged: onChanged);
}

class _RightCheckbox extends BoldRightAccessory {
  const _RightCheckbox(
      {super.key, required this.checked, required this.onChanged});
  final bool checked;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) =>
      BoldCheckbox(checked: checked, onChanged: onChanged);
}

class _RightRadio extends BoldRightAccessory {
  const _RightRadio(
      {super.key, required this.selected, required this.onPressed});
  final bool selected;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Inativo em textSecondary (não no border/hairline, que some no dark).
          border: Border.all(
              color: selected ? BoldColors.primary04 : c.textSecondary,
              width: selected ? 1.5 : 2),
        ),
        child: selected
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: BoldColors.primary04))
            : null,
      ),
    );
  }
}

class _RightCustom extends BoldRightAccessory {
  const _RightCustom({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}

// ═══════════════════════════════════════════════════════════════════════════
// APP LIST — row composta pelos 3 slots
// ═══════════════════════════════════════════════════════════════════════════

/// Row canônica: [left] + [middle] + [right] (+ [footer] opcional).
class BoldAppList extends StatelessWidget {
  const BoldAppList({
    super.key,
    this.left,
    this.middle,
    this.right,
    this.footer,
    this.onTap,
    this.background,
    this.radius,
  });

  /// Row estilo **menu** — spot outline primary + title/subtitle + chevron.
  factory BoldAppList.menuItem({
    Key? key,
    required String icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool disabled = false,
  }) =>
      BoldAppList(
        key: key,
        onTap: disabled ? null : onTap,
        left: BoldLeftAccessory.spotIcon(
            icon: icon,
            tone: disabled ? BoldSpotTone.neutral : BoldSpotTone.primary),
        middle: BoldMiddleAccessory.titleSubtitle(
            title: title, subtitle: subtitle, disabled: disabled),
        right: const BoldRightAccessory.action(),
      );

  /// Row estilo **atividade** — spot fill por tom + title/subtitle + time/status.
  factory BoldAppList.activityItem({
    Key? key,
    required String icon,
    BoldSpotTone iconTone = BoldSpotTone.neutral,
    required String title,
    String? subtitle,
    String? time,
    BoldStatusTagData? status,
    VoidCallback? onTap,
  }) {
    BoldRightAccessory? right;
    if (time != null && status != null) {
      right = BoldRightAccessory.timeStatus(time: time, status: status);
    } else if (time != null) {
      right = BoldRightAccessory.time(time: time);
    } else if (status != null) {
      right = BoldRightAccessory.status(
          label: status.label, tone: status.tone, icon: status.icon);
    }
    return BoldAppList(
      key: key,
      onTap: onTap,
      left: BoldLeftAccessory.spotIcon(icon: icon, tone: iconTone, filled: true),
      middle: BoldMiddleAccessory.titleSubtitle(title: title, subtitle: subtitle),
      right: right,
    );
  }

  /// Row estilo **extrato** — spot + título/fonte/hora inline + valor à direita.
  factory BoldAppList.transactionItem({
    Key? key,
    required String title,
    required String source,
    required String time,
    required String amount,
    bool negative = true,
    String icon = 'pix-light',
    VoidCallback? onTap,
  }) =>
      BoldAppList(
        key: key,
        onTap: onTap,
        left: BoldLeftAccessory.spotIcon(icon: icon),
        middle: BoldMiddleAccessory.titleSubtitleSubtitle(
            title: title, subtitle: source, accessorySubtitle: time),
        right: BoldRightAccessory.amount(value: amount, negative: negative),
      );

  /// Row standalone estilo **banner de perfil** — avatar + nome/subtítulo,
  /// fundo primary wash arredondado. Portado do DS CPF Seguro.
  factory BoldAppList.profileBanner({
    Key? key,
    required String initials,
    required String name,
    String? subtitle,
    VoidCallback? onTap,
  }) =>
      BoldAppList(
        key: key,
        onTap: onTap,
        background: BoldColors.primary08,
        radius: 24,
        left: BoldLeftAccessory.avatar(initials: initials),
        middle:
            BoldMiddleAccessory.titleSubtitle(title: name, subtitle: subtitle),
      );

  final BoldLeftAccessory? left;
  final BoldMiddleAccessory? middle;
  final BoldRightAccessory? right;

  /// Conteúdo abaixo da row (ex.: barra de progresso).
  final Widget? footer;
  final VoidCallback? onTap;

  /// Fundo da row (standalone). Default null = transparente. Não usar dentro de
  /// [BoldAppListGroup] (o group já dá o card).
  final Color? background;

  /// Radius da row (standalone com [background]). Default null = 0.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    // Standalone com fundo/radius (ex.: profileBanner) ganha padding horizontal;
    // dentro de um group, transparente e sem radius (o group já dá o card).
    final decorated = background != null || radius != null;
    Widget content = Container(
      padding: EdgeInsets.symmetric(
          horizontal: decorated ? BoldSpace.x4 : 0, vertical: BoldSpace.x3),
      decoration: decorated
          ? BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(radius ?? 0),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (left != null) ...[left!, const SizedBox(width: 12)],
            if (middle != null) Expanded(child: middle!),
            if (right != null) ...[const SizedBox(width: 10), right!],
          ]),
          if (footer != null)
            Padding(padding: const EdgeInsets.only(top: 8), child: footer!),
        ],
      ),
    );
    if (onTap != null) {
      content = GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: onTap, child: content);
    }
    return content;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP LIST GROUP — card glass + separators automáticos + eyebrow opcional
// ═══════════════════════════════════════════════════════════════════════════

/// Agrupa [BoldAppList] rows num card GLASS com hairline branca entre elas.
/// [title] opcional = eyebrow (Label/medium) acima.
class BoldAppListGroup extends StatelessWidget {
  const BoldAppListGroup({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(const Divider(
            height: 1, thickness: 1, color: Color(0x1FFFFFFF))); // white 12%
      }
      rows.add(children[i]);
    }
    final group = BoldCard(
      glass: true,
      radius: 16,
      padding:
          const EdgeInsets.symmetric(horizontal: BoldSpace.x4, vertical: 2),
      child: Column(children: rows),
    );
    if (title == null) return group;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title!, style: BoldType.labelMd.copyWith(color: c.textPrimary)),
      ),
      group,
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP LIST DAY GROUP — grupo FLAT por dia (label + rows com hairline)
// ═══════════════════════════════════════════════════════════════════════════

/// Grupo por dia ("Hoje", "14/05") — lista FLAT (sem card), hairline entre
/// rows. Padrão do Histórico/Extrato.
class BoldAppListDayGroup extends StatelessWidget {
  const BoldAppListDayGroup(
      {super.key,
      required this.label,
      required this.children,
      this.trailing});

  final String label;
  final List<Widget> children;

  /// Conteúdo opcional na MESMA linha do label, alinhado à direita — ex.: saldo
  /// consolidado do dia no extrato.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    const divider = Divider(height: 1, thickness: 1, color: Color(0x1FFFFFFF));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(children: [
            Text(label,
                style: BoldType.bodySmall
                    .copyWith(fontSize: 12, color: c.textMuted)),
            if (trailing != null) ...[const Spacer(), trailing!],
          ]),
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1 || children.length == 1) divider,
        ],
      ],
    );
  }
}
