import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_action.dart';
import 'cpf_seguro_amount.dart';
import 'cpf_seguro_avatar.dart';
import 'cpf_seguro_progress_ring.dart';
import 'cpf_seguro_checkbox.dart';
import 'cpf_seguro_icon_accessory.dart';
import 'cpf_seguro_spot_icon.dart';
import 'cpf_seguro_divider.dart';
import 'cpf_seguro_text.dart';
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_icon_button.dart';
import 'cpf_seguro_status_tag.dart';
import 'cpf_seguro_toggle_switch.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// # AppList
///
/// Row canônica do DS, sempre composta por 3 slots:
///
/// ```
/// [ Left ] [ Middle (expanded) ] [ Right ]
/// ```
///
/// Cada slot é uma sealed class com **named constructors** — cada variante
/// suportada vira uma factory `const`. A rule é: qualquer conteúdo dentro
/// dos slots é UMA das variantes fornecidas, ou `.custom(child: ...)` como
/// escape hatch.
///
/// - [DilettaLeftAccessory]  — spotIcon · avatar · iconAccessory · illustration
/// - [DilettaMiddleAccessory] — title · titleSubtitle · labelTitleSubtitle · titleSubtitleSubtitle
/// - [DilettaRightAccessory] — action · chevron · statusTag · time · timeStatus · toggle · checkbox
///
/// Composição típica:
///
/// ```dart
/// DilettaAppList(
///   left: DilettaLeftAccessory.spotIcon(icon: DilettaIcons.userLight),
///   middle: DilettaMiddleAccessory.titleSubtitle(
///     title: 'Dados pessoais',
///     subtitle: 'Nome, CPF, nascimento',
///   ),
///   right: DilettaRightAccessory.action(direction: DilettaActionDirection.right),
///   onTap: openDadosPessoais,
/// )
/// ```
///
/// Os widgets `DilettaSpotIcon`, `DilettaAvatar` e `DilettaIconAccessory`
/// também vivem standalone (fora do AppList) — os named constructors do
/// LeftAccessory os embrulham com padding vertical 72h.

// ═══════════════════════════════════════════════════════════════════════════
// LEFT ACCESSORY · sealed com named constructors
// ═══════════════════════════════════════════════════════════════════════════

/// Slot esquerdo do [DilettaAppList].
///
/// Variantes (todas os named constructors são `const`):
/// - [DilettaLeftAccessory.spotIcon]      — círculo colorido com ícone
/// - [DilettaLeftAccessory.avatar]        — iniciais em círculo 40
/// - [DilettaLeftAccessory.iconAccessory] — ícone puro + badge opt
/// - [DilettaLeftAccessory.progressRing]  — anel de progresso + label
///
/// Sempre `height: 72` (encaixe do row). Centraliza vertical.
sealed class DilettaLeftAccessory extends StatelessWidget {
  const DilettaLeftAccessory({super.key});

  const factory DilettaLeftAccessory.spotIcon({
    Key? key,
    required String icon,
    DilettaSpotType type,
    DilettaSpotState state,
    DilettaBadge badge,
    double size,
  }) = _LeftSpotIcon;

  const factory DilettaLeftAccessory.avatar({
    Key? key,
    required String initials,
    DilettaAvatarVariant variant,
    Color borderColor,
    double size,
  }) = _LeftAvatar;

  const factory DilettaLeftAccessory.iconAccessory({
    Key? key,
    required String icon,
    double size,
    Color? color,
    DilettaBadge badge,
    bool danger,
  }) = _LeftIconAccessory;

  /// Consome [DilettaProgressRing] (anel de progresso + label). Ex.: % de uso
  /// de um serviço.
  const factory DilettaLeftAccessory.progressRing({
    Key? key,
    required double progress,
    String? label,
    double size,
  }) = _LeftProgressRing;

  /// Renderiza o conteúdo específico da variante. Override nas subclasses.
  Widget _renderChild();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 72, child: Center(child: _renderChild()));
  }
}

class _LeftSpotIcon extends DilettaLeftAccessory {
  const _LeftSpotIcon({
    super.key,
    required this.icon,
    this.type = DilettaSpotType.fill,
    this.state = DilettaSpotState.normal,
    this.badge = DilettaBadge.none,
    this.size = 34,
  });

  final String icon;
  final DilettaSpotType type;
  final DilettaSpotState state;
  final DilettaBadge badge;
  final double size;

  @override
  Widget _renderChild() =>
      DilettaSpotIcon(icon: icon, type: type, state: state, badge: badge, size: size);
}

class _LeftAvatar extends DilettaLeftAccessory {
  const _LeftAvatar({
    super.key,
    required this.initials,
    this.variant = DilettaAvatarVariant.outlined,
    this.borderColor,
    this.size = 40,
  });

  final String initials;
  final DilettaAvatarVariant variant;
  /// `null` = a borda SUAVE do tema (papel `borderSubtle`). Default const não
  /// consegue ler o tema, por construção.
  final Color? borderColor;
  final double size;

  @override
  Widget _renderChild() =>
      DilettaAvatar(initials: initials, variant: variant, borderColor: borderColor, size: size);
}

class _LeftIconAccessory extends DilettaLeftAccessory {
  const _LeftIconAccessory({
    super.key,
    required this.icon,
    this.size = 20,
    this.color,
    this.badge = DilettaBadge.none,
    this.danger = false,
  });

  final String icon;
  final double size;
  final Color? color;
  final DilettaBadge badge;

  /// Tinge o ícone com o role `danger` (`scheme.error`) — ação destrutiva.
  /// Precede [color].
  final bool danger;

  @override
  Widget _renderChild() =>
      DilettaIconAccessory(icon: icon, size: size, color: color, badge: badge);

  @override
  Widget build(BuildContext context) {
    if (!danger) return super.build(context);
    final c = DilettaTheme.schemeOf(context).error;
    return SizedBox(
      height: 72,
      child: Center(
        child: DilettaIconAccessory(
          icon: icon,
          size: size,
          color: c,
          badge: badge,
        ),
      ),
    );
  }
}

class _LeftProgressRing extends DilettaLeftAccessory {
  const _LeftProgressRing({super.key, required this.progress, this.label, this.size = 40});

  final double progress;
  final String? label;
  final double size;

  @override
  Widget _renderChild() => DilettaProgressRing(progress: progress, label: label, size: size);
}

// ═══════════════════════════════════════════════════════════════════════════
// MIDDLE ACCESSORY · sealed com named constructors
// ═══════════════════════════════════════════════════════════════════════════

/// Tamanho do slot middle.
///
/// - **md** — 72h (usa `titleSm 14/20` / `bodySm 12/16`)
/// - **sm** — 36h (usa `labelMd 12/16` / `labelSm 11/16`)
enum DilettaMiddleSize { sm, md }

/// Slot do meio do [DilettaAppList] — sempre `Expanded`.
///
/// Mirror do Figma "Middle accessory list" (2517:38361). 9 variantes de
/// layout + custom (escape hatch):
///
/// - [DilettaMiddleAccessory.title]                        — só título (+ favorite md)
/// - [DilettaMiddleAccessory.subtitle]                     — só body/subtitle
/// - [DilettaMiddleAccessory.titleSubtitle]                — título + subtitle (+ favorite md)
/// - [DilettaMiddleAccessory.titleSubtitleSubtitle]        — título + `subtitle • accessorySubtitle` inline
/// - [DilettaMiddleAccessory.titleSubtitleTag]             — título + subtitle esq + statusTag dir
/// - [DilettaMiddleAccessory.titleSubtitleAtitleTag]       — título/subtitle esq + accessoryTitle/statusTag dir (md)
/// - [DilettaMiddleAccessory.titleSubtitleAtitleAsubtitle] — 2 colunas: (title/sub) · (aTitle/aSub) — md
/// - [DilettaMiddleAccessory.labelTitleSubtitle]           — eyebrow label + título + subtitle (+ favorite md)
/// - [DilettaMiddleAccessory.titleBodyLabel]               — título + body + label (sm)
/// - [DilettaMiddleAccessory.custom]                       — widget livre
///
/// `disabled: true` dim todos os textos (neutral-05 no título, neutral-06 no sub).
sealed class DilettaMiddleAccessory extends StatelessWidget {
  const DilettaMiddleAccessory({super.key});

  // ─── Textos simples ─────────────────────────────────────────────────────

  const factory DilettaMiddleAccessory.title({
    Key? key,
    required String title,
    DilettaMiddleSize size,
    bool favorite,
    bool disabled,
    bool danger,
  }) = _MiddleTitle;

  const factory DilettaMiddleAccessory.subtitle({
    Key? key,
    required String subtitle,
    DilettaMiddleSize size,
    bool disabled,
  }) = _MiddleSubtitle;

  const factory DilettaMiddleAccessory.titleSubtitle({
    Key? key,
    required String title,
    String? subtitle,
    DilettaMiddleSize size,
    bool favorite,
    bool disabled,
    bool danger,
  }) = _MiddleTitleSubtitle;

  const factory DilettaMiddleAccessory.titleSubtitleSubtitle({
    Key? key,
    required String title,
    String? subtitle,
    String? accessorySubtitle,
    DilettaMiddleSize size,
    bool disabled,
  }) = _MiddleTitleSubtitleSubtitle;

  const factory DilettaMiddleAccessory.labelTitleSubtitle({
    Key? key,
    String? label,
    required String title,
    String? subtitle,
    DilettaMiddleSize size,
    bool favorite,
    bool disabled,
  }) = _MiddleLabelTitleSubtitle;

  const factory DilettaMiddleAccessory.titleBodyLabel({
    Key? key,
    required String title,
    String? body,
    String? label,
    bool disabled,
  }) = _MiddleTitleBodyLabel;

  // ─── Combinados com tag/accessory ──────────────────────────────────────

  const factory DilettaMiddleAccessory.titleSubtitleTag({
    Key? key,
    required String title,
    String? subtitle,
    required String tagLabel,
    required DilettaStatusTone tagTone,
    String? tagIcon,
    DilettaMiddleSize size,
    bool disabled,
  }) = _MiddleTitleSubtitleTag;

  const factory DilettaMiddleAccessory.titleSubtitleAtitleTag({
    Key? key,
    required String title,
    String? subtitle,
    required String accessoryTitle,
    required String tagLabel,
    required DilettaStatusTone tagTone,
    String? tagIcon,
    bool disabled,
  }) = _MiddleTitleSubtitleAtitleTag;

  const factory DilettaMiddleAccessory.titleSubtitleAtitleAsubtitle({
    Key? key,
    required String title,
    String? subtitle,
    required String accessoryTitle,
    String? accessorySubtitle,
    bool disabled,
  }) = _MiddleTitleSubtitleAtitleAsubtitle;

  Widget _renderChildren(DilettaScheme s);

  /// Altura do slot: 72 em md, 36 em sm.
  double get _height => DilettaMiddleSize.md == _sizeHint() ? 72 : 36;

  /// Sobrescrever nas subclasses que aceitam [size].
  DilettaMiddleSize _sizeHint() => DilettaMiddleSize.md;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Expanded(
      child: SizedBox(
        height: _height,
        child: _renderChildren(s),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Middle · style tokens por size
// ═══════════════════════════════════════════════════════════════════════════

TextStyle _mTitleStyle(DilettaMiddleSize size, bool disabled, DilettaScheme s,
    {bool danger = false}) {
  final base = size == DilettaMiddleSize.md ? DilettaType.subheading : DilettaType.label;
  return base.copyWith(
    color: disabled
        ? s.palette.neutral05
        : danger
            ? s.error
            : s.fg,
  );
}

TextStyle _mSubStyle(DilettaMiddleSize size, bool disabled, DilettaScheme s) {
  final base = size == DilettaMiddleSize.md ? DilettaType.caption : DilettaType.labelSm;
  return base.copyWith(
    color: disabled ? s.palette.neutral06 : s.textTertiary,
  );
}

/// Label como eyebrow do labelTitleSubtitle · sempre bodySm neutral-03.
TextStyle _mEyebrowStyle(bool disabled, DilettaScheme s) => DilettaType.caption.copyWith(
      color: disabled ? s.palette.neutral06 : s.textTertiary,
    );

/// Label do titleBodyLabel (footer sm) · labelSm 11 neutral-05.
TextStyle _mFooterLabelStyle(bool disabled, DilettaScheme s) => DilettaType.labelSm.copyWith(
      color: disabled ? s.palette.neutral06 : s.textPlaceholder,
    );

/// Ícone estrela 16px na direita (favorite=true em variants md).
Widget _favoriteIcon(bool disabled, DilettaScheme s) => Padding(
      padding: const EdgeInsets.only(left: DilettaSpacing.s4),
      child: DilettaIconAccessory(
        icon: DilettaIcons.starSolid,
        size: 16,
        padding: 0,
        color: disabled ? s.palette.neutral07 : s.palette.warning04,
      ),
    );

// ═══════════════════════════════════════════════════════════════════════════
// Middle · variantes
// ═══════════════════════════════════════════════════════════════════════════

class _MiddleTitle extends DilettaMiddleAccessory {
  const _MiddleTitle({
    super.key,
    required this.title,
    this.size = DilettaMiddleSize.md,
    this.favorite = false,
    this.disabled = false,
    this.danger = false,
  });
  final String title;
  final DilettaMiddleSize size;
  final bool favorite;
  final bool disabled;

  /// Título no role `danger` (`scheme.error`) — ação destrutiva.
  final bool danger;

  @override
  DilettaMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(DilettaScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(title,
                maxLines: 1,
                style: _mTitleStyle(size, disabled, s, danger: danger)),
          ),
          if (favorite && size == DilettaMiddleSize.md) _favoriteIcon(disabled, s),
        ],
      );
}

class _MiddleSubtitle extends DilettaMiddleAccessory {
  const _MiddleSubtitle({
    super.key,
    required this.subtitle,
    this.size = DilettaMiddleSize.md,
    this.disabled = false,
  });
  final String subtitle;
  final DilettaMiddleSize size;
  final bool disabled;

  @override
  DilettaMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(DilettaScheme s) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          subtitle,
          maxLines: 1,
          style: DilettaType.caption.copyWith(
            color: disabled ? s.palette.neutral06 : s.palette.neutral01,
          ),
        ),
      );
}

class _MiddleTitleSubtitle extends DilettaMiddleAccessory {
  const _MiddleTitleSubtitle({
    super.key,
    required this.title,
    this.subtitle,
    this.size = DilettaMiddleSize.md,
    this.favorite = false,
    this.disabled = false,
    this.danger = false,
  });
  final String title;
  final String? subtitle;
  final DilettaMiddleSize size;
  final bool favorite;
  final bool disabled;

  /// Título no role `danger` (`scheme.error`) — ação destrutiva.
  final bool danger;

  @override
  DilettaMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(DilettaScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s, danger: danger)),
                if (subtitle != null) Text(subtitle!, maxLines: 1, style: _mSubStyle(size, disabled, s)),
              ],
            ),
          ),
          if (favorite && size == DilettaMiddleSize.md) _favoriteIcon(disabled, s),
        ],
      );
}

class _MiddleTitleSubtitleSubtitle extends DilettaMiddleAccessory {
  const _MiddleTitleSubtitleSubtitle({
    super.key,
    required this.title,
    this.subtitle,
    this.accessorySubtitle,
    this.size = DilettaMiddleSize.md,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String? accessorySubtitle;
  final DilettaMiddleSize size;
  final bool disabled;

  @override
  DilettaMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(DilettaScheme s) {
    final subStyle = _mSubStyle(size, disabled, s);
    final bulletParts = <String>[
      if (subtitle != null) subtitle!,
      if (accessorySubtitle != null) accessorySubtitle!,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s)),
        if (bulletParts.isNotEmpty)
          Text(bulletParts.join(' • '), maxLines: 1, style: subStyle),
      ],
    );
  }
}

class _MiddleLabelTitleSubtitle extends DilettaMiddleAccessory {
  const _MiddleLabelTitleSubtitle({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.size = DilettaMiddleSize.md,
    this.favorite = false,
    this.disabled = false,
  });
  final String? label;
  final String title;
  final String? subtitle;
  final DilettaMiddleSize size;
  final bool favorite;
  final bool disabled;

  @override
  DilettaMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(DilettaScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null) Text(label!, maxLines: 1, style: _mEyebrowStyle(disabled, s)),
                Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s)),
                if (subtitle != null) Text(subtitle!, maxLines: 1, style: _mSubStyle(size, disabled, s)),
              ],
            ),
          ),
          if (favorite && size == DilettaMiddleSize.md) _favoriteIcon(disabled, s),
        ],
      );
}

class _MiddleTitleBodyLabel extends DilettaMiddleAccessory {
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
  DilettaMiddleSize _sizeHint() => DilettaMiddleSize.sm;

  @override
  Widget _renderChildren(DilettaScheme s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, maxLines: 1, style: _mTitleStyle(DilettaMiddleSize.md, disabled, s)),
          if (body != null)
            Text(
              body!,
              maxLines: 1,
              style: DilettaType.caption.copyWith(
                color: disabled ? s.palette.neutral06 : s.palette.neutral03,
              ),
            ),
          if (label != null) Text(label!, maxLines: 1, style: _mFooterLabelStyle(disabled, s)),
        ],
      );
}

class _MiddleTitleSubtitleTag extends DilettaMiddleAccessory {
  const _MiddleTitleSubtitleTag({
    super.key,
    required this.title,
    this.subtitle,
    required this.tagLabel,
    required this.tagTone,
    this.tagIcon,
    this.size = DilettaMiddleSize.md,
    this.disabled = false,
  });
  final String title;
  final String? subtitle;
  final String tagLabel;
  final DilettaStatusTone tagTone;
  final String? tagIcon;
  final DilettaMiddleSize size;
  final bool disabled;

  @override
  DilettaMiddleSize _sizeHint() => size;

  @override
  Widget _renderChildren(DilettaScheme s) {
    final left = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, maxLines: 1, style: _mTitleStyle(size, disabled, s)),
          if (subtitle != null) Text(subtitle!, maxLines: 1, style: _mSubStyle(size, disabled, s)),
        ],
      ),
    );
    final tag = DilettaStatusTag(label: tagLabel, tone: tagTone, icon: tagIcon);
    if (size == DilettaMiddleSize.sm) {
      // sm: tag empilha à direita do bloco (fim do row)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [left, const SizedBox(width: 16), tag],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [left, const SizedBox(width: 16), tag],
    );
  }
}

class _MiddleTitleSubtitleAtitleTag extends DilettaMiddleAccessory {
  const _MiddleTitleSubtitleAtitleTag({
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
  final DilettaStatusTone tagTone;
  final String? tagIcon;
  final bool disabled;

  @override
  DilettaMiddleSize _sizeHint() => DilettaMiddleSize.md;

  @override
  Widget _renderChildren(DilettaScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, style: _mTitleStyle(DilettaMiddleSize.md, disabled, s)),
                if (subtitle != null)
                  Text(subtitle!, maxLines: 1, style: _mSubStyle(DilettaMiddleSize.md, disabled, s)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(accessoryTitle, maxLines: 1, style: _mTitleStyle(DilettaMiddleSize.md, disabled, s)),
              DilettaStatusTag(label: tagLabel, tone: tagTone, icon: tagIcon),
            ],
          ),
        ],
      );
}

class _MiddleTitleSubtitleAtitleAsubtitle extends DilettaMiddleAccessory {
  const _MiddleTitleSubtitleAtitleAsubtitle({
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
  DilettaMiddleSize _sizeHint() => DilettaMiddleSize.md;

  @override
  Widget _renderChildren(DilettaScheme s) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, style: _mTitleStyle(DilettaMiddleSize.md, disabled, s)),
                if (subtitle != null)
                  Text(subtitle!, maxLines: 1, style: _mSubStyle(DilettaMiddleSize.md, disabled, s)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(accessoryTitle, maxLines: 1, style: _mTitleStyle(DilettaMiddleSize.md, disabled, s)),
              if (accessorySubtitle != null)
                Text(accessorySubtitle!, maxLines: 1, style: _mSubStyle(DilettaMiddleSize.md, disabled, s)),
            ],
          ),
        ],
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// RIGHT ACCESSORY · sealed com named constructors
// ═══════════════════════════════════════════════════════════════════════════

/// Slot direito do [DilettaAppList].
///
/// Mirror do Figma "Right accessory" (2456:35494) — 7 variantes canônicas +
/// escape hatch:
///
/// - [DilettaRightAccessory.action]     — [DilettaAction] (chevron, more, check, etc)
/// - [DilettaRightAccessory.icon]       — IconButton 36×36 (ícone secundário)
/// - [DilettaRightAccessory.status]     — pill de [DilettaStatusTag]
/// - [DilettaRightAccessory.amountChip] — pill com plus + valor (R$ 560,00)
/// - [DilettaRightAccessory.toggle]     — [DilettaToggleSwitch]
/// - [DilettaRightAccessory.checkbox]   — [DilettaCheckbox]
/// - [DilettaRightAccessory.radio]      — radio dot 20×20
/// - [DilettaRightAccessory.custom]     — widget livre (escape hatch)
///
/// Sempre `height: 72`. Alinha vertical center, horizontal end.
sealed class DilettaRightAccessory extends StatelessWidget {
  const DilettaRightAccessory({super.key});

  const factory DilettaRightAccessory.action({
    Key? key,
    required DilettaActionDirection direction,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) = _RightAction;

  const factory DilettaRightAccessory.icon({
    Key? key,
    required String icon,
    required String semanticLabel,
    VoidCallback? onPressed,
    DilettaIconButtonType type,
    DilettaIconButtonState state,
    bool disabled,
  }) = _RightIcon;

  const factory DilettaRightAccessory.status({
    Key? key,
    required String label,
    required DilettaStatusTone tone,
    String? icon,
  }) = _RightStatus;

  /// Ícone BARE tonalizado por role (sem label, sem chrome de botão). Espelha
  /// [DilettaLeftAccessory.iconAccessory] no lado direito. Serve indicador de
  /// status (check verde/relógio neutro/x vermelho) E marcador simples (lápis
  /// neutro = editar). NÃO é StatusTag (tem label) nem `.icon` (botão).
  /// Substitui o antigo `.custom(DilettaIcon(...))`.
  const factory DilettaRightAccessory.iconAccessory({
    Key? key,
    required String icon,
    DilettaStatusTone tone,
    double size,
  }) = _RightIconAccessory;

  const factory DilettaRightAccessory.amountChip({
    Key? key,
    required String amount,
    String icon,
  }) = _RightAmountChip;

  /// Consome um [DilettaAmount] (o acessório não desenha — só posiciona).
  /// Ex.: `right.amount(DilettaAmount.cashIn(value: 'R\$ 560,00'))`.
  const factory DilettaRightAccessory.amount(DilettaAmount amount, {Key? key}) = _RightAmount;

  const factory DilettaRightAccessory.toggle({
    Key? key,
    required bool value,
    required ValueChanged<bool> onChanged,
    DilettaToggleSize size,
    bool disabled,
    String? semanticLabel,
  }) = _RightToggle;

  const factory DilettaRightAccessory.checkbox({
    Key? key,
    required bool checked,
    required ValueChanged<bool> onChanged,
    bool indeterminate,
    bool disabled,
    DilettaCheckboxVariant variant,
    DilettaCheckboxSize size,
  }) = _RightCheckbox;

  const factory DilettaRightAccessory.radio({
    Key? key,
    required bool selected,
    required VoidCallback onPressed,
    bool disabled,
  }) = _RightRadio;

  // ─── Sugar helpers (não Figma) ────────────────────────────────────────────
  // Retornam .custom(...) internamente — usados no ActivityRecent do app.

  /// Texto de tempo à direita (ex: "14min"). Sugar sobre `.custom`.
  static DilettaRightAccessory time({
    required String time,
    bool disabled = false,
    Key? key,
  }) {
    return _RightCustom(
      key: key,
      child: DilettaTheme.comEsquema((s) => Text(
            time,
            maxLines: 1,
            style: DilettaType.caption.copyWith(
              color: disabled ? s.textDisabled : s.textTertiary,
            ),
          )),
    );
  }

  /// Time em cima, [DilettaStatusTag] embaixo. Sugar sobre `.custom`.
  static DilettaRightAccessory timeStatus({
    required String time,
    required DilettaStatusTagData status,
    bool disabled = false,
    Key? key,
  }) {
    return _RightCustom(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaTheme.comEsquema((s) => Text(
                time,
                maxLines: 1,
                style: DilettaType.caption.copyWith(
                  color: disabled ? s.textDisabled : s.textTertiary,
                ),
              )),
          const SizedBox(height: 4),
          DilettaStatusTag(label: status.label, tone: status.tone, icon: status.icon),
        ],
      ),
    );
  }

  /// Filhos do slot (podem ser 1 ou N empilhados vertical com gap 4).
  List<Widget> _renderChildren(DilettaScheme s);

  @override
  Widget build(BuildContext context) {
    final children = _renderChildren(DilettaTheme.schemeOf(context));
    return SizedBox(
      height: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 4),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _RightAction extends DilettaRightAccessory {
  const _RightAction({
    super.key,
    required this.direction,
    this.onPressed,
    this.semanticLabel,
  });

  final DilettaActionDirection direction;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        DilettaAction(direction: direction, onPressed: onPressed, semanticLabel: semanticLabel),
      ];
}

class _RightIcon extends DilettaRightAccessory {
  const _RightIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.type = DilettaIconButtonType.tertiary,
    this.state = DilettaIconButtonState.normal,
    this.disabled = false,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final DilettaIconButtonType type;
  final DilettaIconButtonState state;
  final bool disabled;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        DilettaIconButton(
          icon: icon,
          semanticLabel: semanticLabel,
          onPressed: onPressed,
          type: type,
          state: state,
          disabled: disabled,
          size: DilettaIconButtonSize.md,
        ),
      ];
}

class _RightStatus extends DilettaRightAccessory {
  const _RightStatus({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  final String label;
  final DilettaStatusTone tone;
  final String? icon;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        DilettaStatusTag(label: label, tone: tone, icon: icon),
      ];
}

class _RightIconAccessory extends DilettaRightAccessory {
  const _RightIconAccessory({
    super.key,
    required this.icon,
    this.tone = DilettaStatusTone.neutral,
    this.size = 18,
  });

  final String icon;
  final DilettaStatusTone tone;
  final double size;

  Color _toneColor(DilettaScheme s) => switch (tone) {
        DilettaStatusTone.danger => s.palette.error04,
        DilettaStatusTone.success => s.palette.success04,
        DilettaStatusTone.warning => s.palette.warning04,
        DilettaStatusTone.primary => s.palette.primary04,
        DilettaStatusTone.secure => s.palette.secure03,
        DilettaStatusTone.neutral => s.palette.neutral03,
      };

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        DilettaIconAccessory(icon: icon, padding: 0, size: size, color: _toneColor(s)),
      ];
}

class _RightAmountChip extends DilettaRightAccessory {
  const _RightAmountChip({
    super.key,
    required this.amount,
    this.icon = 'plus-solid',
  });

  final String amount;
  final String icon;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2, vertical: DilettaSpacing.s1),
          decoration: BoxDecoration(
            color: s.palette.neutral09,
            borderRadius: DilettaRadius.all8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DilettaIconAccessory(icon: icon, size: 12, padding: 0, color: s.palette.neutral02),
              const SizedBox(width: 4),
              Text(amount, style: DilettaType.labelSm.copyWith(color: s.palette.neutral02)),
            ],
          ),
        ),
      ];
}

/// Valor de transação alinhado à direita ("—  R$ 560,00"). O travessão
/// prefixa valores negativos (débito), padrão do extrato da Carteira.
class _RightAmount extends DilettaRightAccessory {
  const _RightAmount(this.amount, {super.key});

  final DilettaAmount amount;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [amount];
}

class _RightToggle extends DilettaRightAccessory {
  const _RightToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = DilettaToggleSize.md,
    this.disabled = false,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final DilettaToggleSize size;
  final bool disabled;
  final String? semanticLabel;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        DilettaToggleSwitch(
          value: value,
          onChanged: onChanged,
          size: size,
          disabled: disabled,
          semanticLabel: semanticLabel,
        ),
      ];
}

class _RightCheckbox extends DilettaRightAccessory {
  const _RightCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
    this.indeterminate = false,
    this.disabled = false,
    this.variant = DilettaCheckboxVariant.primary,
    this.size = DilettaCheckboxSize.md,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool indeterminate;
  final bool disabled;
  final DilettaCheckboxVariant variant;
  final DilettaCheckboxSize size;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        DilettaCheckbox(
          checked: checked,
          onChanged: onChanged,
          indeterminate: indeterminate,
          disabled: disabled,
          variant: variant,
          size: size,
        ),
      ];
}

class _RightRadio extends DilettaRightAccessory {
  const _RightRadio({
    super.key,
    required this.selected,
    required this.onPressed,
    this.disabled = false,
  });

  final bool selected;
  final VoidCallback onPressed;
  final bool disabled;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [
        Semantics(
          inMutuallyExclusiveGroup: true,
          checked: selected,
          enabled: !disabled,
          button: true,
          child: MouseRegion(
            cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            child: DilettaTappable(
              behavior: HitTestBehavior.opaque,
              onTap: disabled ? null : onPressed,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: s.palette.white,
                  border: Border.all(
                    color: disabled
                        ? s.palette.neutral07
                        : (selected ? s.palette.neutral01 : s.palette.neutral07),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: disabled ? s.palette.neutral07 : s.palette.neutral01,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ];
}

class _RightCustom extends DilettaRightAccessory {
  const _RightCustom({super.key, required this.child});
  final Widget child;

  @override
  List<Widget> _renderChildren(DilettaScheme s) => [child];
}

// ═══════════════════════════════════════════════════════════════════════════
// APP LIST · row composta pelos 3 slots
// ═══════════════════════════════════════════════════════════════════════════

/// Row canônica: [left] + [middle] + [right] + [footer] opcional.
/// Figma: "App list" (141:15428).
///
/// ```dart
/// DilettaAppList(
///   left: DilettaLeftAccessory.spotIcon(icon: DilettaIcons.userLight),
///   middle: DilettaMiddleAccessory.titleSubtitle(
///     title: 'Dados pessoais',
///     subtitle: 'Nome, CPF, nascimento',
///   ),
///   right: DilettaRightAccessory.action(direction: DilettaActionDirection.right),
///   onTap: () => openDadosPessoais(),
/// )
/// ```
/// CPF SEGURO — AppListRow (a ROW pura).
///
/// Uma linha de lista: `left` · `middle` (expande) · `right` (+ `footer` opt).
/// **Não sabe nada dos vizinhos** — sem `position`, sem separator próprio. O
/// separador é responsabilidade da COLEÇÃO ([DilettaAppList] com
/// `.carded`/`.plain`/`.menu`), que é quem conhece a ordem. Uma row solta na
/// tela é só isto, sem linha.
///
/// Renderizável standalone (banner de perfil, resumo de uma linha) ou como
/// filho de uma coleção.
/// Tom de fundo de uma linha de lista — PAPEL, não cor.
///
/// Era `Color? background`, e a consequência aparecia dois níveis acima: o
/// catálogo oferecia ao autor as opções `white`, `primary08`, `primary01` e
/// `neutral01`, ou seja, escolher PRIMITIVA na hora de montar tela. Tom fecha
/// essa porta sem tirar capacidade — as mesmas quatro intenções, com nome.
enum DilettaRowTone {
  /// Sem preenchimento: a linha mostra o que está atrás.
  none,

  /// Superfície de conteúdo (o branco do tema).
  surface,

  /// A linha puxa atenção com a cor de ação da marca em versão suave.
  highlighted,

  /// Superfície invertida — escura no claro.
  inverse,
}

class DilettaAppListRow extends StatelessWidget {
  const DilettaAppListRow({
    super.key,
    this.left,
    this.middle,
    this.right,
    this.footer,
    this.tone = DilettaRowTone.none,
    this.background,
    this.radius,
    this.onTap,
  });

  /// Row estilo **menu** — spot outline primary + title/subtitle + chevron.
  /// Uso mais comum dentro de `CpfSeguroAppListGroup(title:)`.
  ///
  /// ```dart
  /// DilettaAppList.menuItem(icon: DilettaIcons.userLight, title: 'Dados', subtitle: '...', onTap: () {})
  /// ```
  factory DilettaAppListRow.menuItem({
    Key? key,
    required String icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    return DilettaAppListRow(
      key: key,
      onTap: disabled ? null : onTap,
      left: DilettaLeftAccessory.spotIcon(
        icon: icon,
        type: DilettaSpotType.outline,
        state: disabled ? DilettaSpotState.disabled : DilettaSpotState.primary,
      ),
      middle: DilettaMiddleAccessory.titleSubtitle(
        title: title,
        subtitle: subtitle,
        disabled: disabled,
      ),
      right: const DilettaRightAccessory.action(direction: DilettaActionDirection.right),
    );
  }

  /// Row estilo **histórico de atividade** — spot fill colorido por [state] +
  /// title/subtitle + acessório direito (time, status ou os dois).
  ///
  /// Passe `time` sozinho, `status` sozinho, ou os dois pra timeStatus.
  ///
  /// ```dart
  /// DilettaAppList.activityItem(
  ///   icon: DilettaIcons.shieldUserSolidFull,
  ///   iconState: DilettaSpotState.success,
  ///   title: 'Login em Banco Aurora',
  ///   subtitle: 'Por mim · Biometria',
  ///   time: '14min',
  /// )
  /// ```
  factory DilettaAppListRow.activityItem({
    Key? key,
    required String icon,
    required DilettaSpotState iconState,
    DilettaSpotType iconType = DilettaSpotType.fill,
    required String title,
    String? subtitle,
    String? time,
    DilettaStatusTagData? status,
    DilettaBadge iconBadge = DilettaBadge.none,
    Widget? footer,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    final effectiveIconState = disabled ? DilettaSpotState.disabled : iconState;
    DilettaRightAccessory? rightSlot;
    if (time != null && status != null) {
      rightSlot = DilettaRightAccessory.timeStatus(time: time, status: status, disabled: disabled);
    } else if (time != null) {
      rightSlot = DilettaRightAccessory.time(time: time, disabled: disabled);
    } else if (status != null) {
      rightSlot = DilettaRightAccessory.status(label: status.label, tone: status.tone, icon: status.icon);
    }
    return DilettaAppListRow(
      key: key,
      onTap: disabled ? null : onTap,
      left: DilettaLeftAccessory.spotIcon(
        icon: icon,
        type: iconType,
        state: effectiveIconState,
        badge: iconBadge,
      ),
      middle: DilettaMiddleAccessory.titleSubtitle(
        title: title,
        subtitle: subtitle,
        disabled: disabled,
      ),
      right: rightSlot,
      footer: footer,
    );
  }

  /// Row estilo **extrato da Carteira** — spot com logo do merchant +
  /// título/fonte/hora + valor à direita ("—  R$ 560,00").
  ///
  /// ```dart
  /// DilettaAppList.transactionItem(
  ///   title: 'Pague menos',
  ///   source: 'CPF Seguro',
  ///   time: '12:04',
  ///   amount: 'R$ 560,00',
  /// )
  /// ```
  factory DilettaAppListRow.transactionItem({
    Key? key,
    required String title,
    required String source,
    required String time,
    required String amount,
    bool negative = true,
    String icon = 'pix-light',
    VoidCallback? onTap,
  }) {
    return DilettaAppListRow(
      key: key,
      onTap: onTap,
      left: DilettaLeftAccessory.spotIcon(icon: icon, state: DilettaSpotState.normal),
      middle: DilettaMiddleAccessory.titleSubtitleSubtitle(
        title: title,
        subtitle: source,
        accessorySubtitle: time,
      ),
      right: DilettaRightAccessory.amount(
        negative
            ? DilettaAmount.cashOut(value: amount)
            : DilettaAmount.cashIn(value: amount),
      ),
    );
  }

  /// Row estilo **profile banner** — avatar solid ring primary + name/cpf +
  /// bg primary-08 + radius 24. Sem chevron. Standalone (não vai dentro de
  /// [CpfSeguroAppListGroup]).
  ///
  /// ```dart
  /// DilettaAppList.profileBanner(initials: 'AM', name: 'Ana Maria', subtitle: 'CPF 086.***.***-49')
  /// ```
  factory DilettaAppListRow.profileBanner({
    Key? key,
    required String initials,
    required String name,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return DilettaAppListRow(
      key: key,
      onTap: onTap,
      tone: DilettaRowTone.highlighted,
      radius: 24,
      left: DilettaLeftAccessory.avatar(initials: initials, variant: DilettaAvatarVariant.solid),
      middle: DilettaMiddleAccessory.titleSubtitle(title: name, subtitle: subtitle),
    );
  }

  final DilettaLeftAccessory? left;
  final DilettaMiddleAccessory? middle;
  final DilettaRightAccessory? right;

  /// Conteúdo opcional abaixo da row principal (ex: barra de progresso de
  /// pausa no histórico).
  final Widget? footer;

  /// Bg da row. **Default null** = transparente (herda do container pai). Não
  /// use white/branco solto quando a row for dentro de [CpfSeguroAppListGroup]
  /// — o fill acaba cobrindo o stroke do group nos cantos.
  ///
  /// Passe explícito só quando a row for **standalone** (banner de perfil,
  /// card destacado com cor de fundo diferente).
  /// Tom de fundo da linha. Papel, não cor: quem chama diz "destacada", e o
  /// scheme decide o valor — então a linha destacada de um filho usa a marca DELE,
  /// e no escuro ela acompanha.
  ///
  /// Era `Color? background`, e o único chamador DENTRO do DS (o factory estático
  /// de pessoa) passava `primary08` cru porque factory estático não tem `context`.
  final DilettaRowTone tone;

  /// ESCAPE HATCH: cor de fundo literal, e ela vence o [tone].
  ///
  /// Existe porque um consumidor pode ter paleta própria — o app do CPF SEGURO
  /// passa um cinza do `ColorsPalette` dele numa linha de serviço, e isso é uso
  /// legítimo: **app tem cor, o design system é que não pode ter a de um filho.**
  ///
  /// Eu tinha REMOVIDO este parâmetro ao criar o [tone], e o analisador do app
  /// mostrou o erro: trocar o vocabulário interno do DS é uma coisa, tirar
  /// capacidade de quem já consome é outra. O caminho semântico é o [tone]; este
  /// fica pra quem tem valor próprio de verdade.
  final Color? background;

  /// Radius da row. **Default null** = 0 (sem radius). Quando dentro de
  /// [CpfSeguroAppListGroup] o clip do group já dá o cantinho — não precisa
  /// duplicar. Standalone com bg custom pode passar (ex: profile banner = 24).
  final double? radius;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sch = DilettaTheme.schemeOf(context);
    final fundo = background ?? switch (tone) {
      DilettaRowTone.none => null,
      DilettaRowTone.surface => sch.surface,
      DilettaRowTone.highlighted => sch.primarySubtle,
      DilettaRowTone.inverse => sch.surfaceInverse,
    };
    final decoration = (fundo != null || radius != null)
        ? BoxDecoration(
            color: fundo,
            borderRadius:
                radius != null ? BorderRadius.circular(radius!) : null,
          )
        : null;
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (left != null) ...[left!, const SizedBox(width: 12)],
              if (middle != null) middle!,
              // Respiro entre o middle (que pode terminar em tag) e o right
              // accessory — senão a tag "Padrão" cola no radio/chevron.
              if (right != null) ...[
                if (middle != null) const SizedBox(width: 8),
                right!,
              ],
            ],
          ),
          if (footer != null)
            Padding(padding: const EdgeInsets.only(bottom: DilettaSpacing.s2), child: footer!),
        ],
      ),
    );

    if (onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: content,
        ),
      );
    }
    return DilettaDevInfo(
      component: 'DilettaAppListRow',
      props: {
        if (left != null) 'left': 'accessory',
        if (middle != null) 'middle': 'accessory',
        if (right != null) 'right': 'accessory',
        if (footer != null) 'footer': 'widget',
        if (onTap != null) 'onTap': 'true',
      },
      tokens: [
        'row Left · Middle(expanded) · Right · px 8',
        if (fundo != null) 'bg: ${nomeDoToken(context, fundo)}',
        if (radius != null) 'radius: ${radius!.toInt()}',
      ],
      child: content,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppList · a COLEÇÃO (dona ÚNICA do separador)
// ═══════════════════════════════════════════════════════════════════════════

enum _ListVariant { carded, plain, menu }

/// CPF SEGURO — AppList (a COLEÇÃO de [DilettaAppListRow]).
///
/// Dona ÚNICA do separador: a row não conhece a vizinhança, a coleção sim —
/// então nunca há linha dupla nem "último errado", e o consumidor jamais
/// calcula índice. Três idiomas, por construtor nomeado:
///
/// - [DilettaAppList.carded] — card branco com **stroke externo** + radius +
///   padding; separador entre rows, nenhum no último (a borda fecha).
/// - [DilettaAppList.plain]  — **sem stroke externo**; só as rows com
///   separador entre elas, nenhum no último. Pro grupo que não é card.
/// - [DilettaAppList.menu]   — sem stroke; divisor full-width embaixo de
///   CADA row (inclusive quando é uma só). Idioma menu/settings.
///
/// [title] opcional — eyebrow uppercase acima da coleção (antigo MenuSection).
///
/// ```dart
/// DilettaAppList.carded(children: [row1, row2])
/// DilettaAppList.plain(title: 'Meus dados', children: [row1, row2])
/// DilettaAppList.menu(children: [row1])   // item único fecha com hairline
/// ```
class DilettaAppList extends StatelessWidget {
  const DilettaAppList.carded({super.key, required this.children, this.title})
      : _variant = _ListVariant.carded;
  const DilettaAppList.plain({super.key, required this.children, this.title})
      : _variant = _ListVariant.plain;
  const DilettaAppList.menu({super.key, required this.children, this.title})
      : _variant = _ListVariant.menu;

  /// Rows da coleção. Idealmente [DilettaAppListRow], mas aceita `Widget` pra
  /// suportar RECIPES que embrulham uma row (ex.: um recipe de domínio com
  /// ShimmerLoading por cima). O contrato é soft: cada child deve SER ou
  /// EMBRULHAR uma row — a coleção só orquestra o separador entre elas.
  final List<Widget> children;

  /// Eyebrow uppercase acima da coleção. Null = sem seção.
  final String? title;

  final _ListVariant _variant;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final carded = _variant == _ListVariant.carded;
    final underEach = _variant == _ListVariant.menu;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          DecoratedBox(
            decoration: BoxDecoration(
              border: (underEach || i < children.length - 1)
                  ? Border(bottom: BorderSide(color: s.divider, width: 1))
                  : null,
            ),
            child: children[i],
          ),
      ],
    );

    final Widget body = carded
        ? Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: s.surface,
              border: Border.all(color: s.divider, width: 1),
              borderRadius: DilettaRadius.all24,
            ),
            padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2),
            child: column,
          )
        : column;

    final devInfo = DilettaDevInfo(
      component: 'DilettaAppList',
      props: {
        'variant': _variant.name,
        'rows': '${children.length}',
        if (title != null) 'title': "'$title'",
      },
      tokens: [
        carded
            ? 'card: bg surface · stroke neutral-09 · radius 24'
            : 'sem stroke externo',
        underEach
            ? 'divisor sob cada row'
            : 'divisor entre rows (nenhum no último)',
      ],
      child: body,
    );

    if (title == null) return devInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: DilettaSpacing.s4, bottom: DilettaSpacing.s2),
          child: Text(title!.toUpperCase(),
              style: DilettaType.overline.copyWith(color: s.textMuted)),
        ),
        devInfo,
      ],
    );
  }
}

// NOTA — CpfSeguroAppListSimple foi removido (@Deprecated).
// Composição explícita: DilettaAppList(left:, middle:, right:) + variantes
// dos accessories (LeftAccessory.spotIcon, MiddleAccessory.titleSubtitle,
// RightAccessory.action/status/time/timeStatus/etc).

// ═══════════════════════════════════════════════════════════════════════════
// AppListDayGroup · grupo FLAT por dia (label + rows com separator inset)
// ═══════════════════════════════════════════════════════════════════════════

/// Grupo de rows por dia ("Hoje", "14/05") — lista FLAT, sem stroke externo,
/// com separator 1px neutral-09 na largura total do elemento.
///
/// Regra do divider: entre as rows (toda row que NÃO é a última) e também
/// abaixo da row quando ela é a ÚNICA do dia — um dia de item único fecha
/// com hairline.
///
/// É o padrão do Histórico e do Extrato do cartão (Figma Frame 1407 ·
/// 510:19493). Contraste com [CpfSeguroAppListGroup], que embrulha as rows
/// num container com border — usado na Home ("Atividade Recente").
///
/// ```dart
/// DilettaAppListDayGroup(label: 'Hoje', children: [row1, row2])
/// ```
class DilettaAppListDayGroup extends StatelessWidget {
  const DilettaAppListDayGroup({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Divider ocupa a largura TOTAL do elemento (sem inset do ícone).
    final s = DilettaTheme.schemeOf(context);
    // O DS TEM divider — usar o dele em vez de montar `SizedBox` + `DecoratedBox`
    // à mão. Componente encapsulado é um lugar pra consertar, não dez.
    const divider = DilettaDivider();
    // stretch obrigatório: o divider é um SizedBox(height:1) sem width —
    // com crossAxisAlignment.start ele colapsa pra 0 de largura e some.
    return DilettaDevInfo(
      component: 'DilettaAppListDayGroup',
      props: {'label': "'$label'", 'rows': '${children.length}'},
      tokens: const ['lista FLAT sem stroke · label labelSm neutral-05', 'divider full-width entre rows (e no item único)'],
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: DilettaSpacing.s2),
          child: DilettaText(label,
              style: DilettaType.labelSm.copyWith(color: s.textPlaceholder)),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1 || children.length == 1) divider,
        ],
      ],
      ),
    );
  }
}
