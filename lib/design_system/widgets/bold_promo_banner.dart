import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_avatar_stack.dart';
import 'bold_button.dart';
import 'bold_icon.dart';

/// Conta BOLD — PromoBanner (organismo). Banner de destaque da home (spec
/// Redesenho v.01 — "Veja as pessoas próximas"):
///
/// - fill gradiente [BoldColors.primary02] → [BoldColors.primary05] a **69°**;
/// - radius 16 · padding 16 nos 4 lados;
/// - título Title/medium branco + subtítulo Body/small branco;
/// - cluster opcional de avatares + contagem à direita;
/// - dois CTAs: primário (BoldButton `white`) + secundário (secondary branco);
/// - botão X (tertiary, glyph branco 16) a 4px do topo/direita.
///
/// **Composição** — BoldButton (moléculas) + BoldAvatarStack + BoldIcon +
/// tokens.
///
/// ```dart
/// BoldPromoBanner(
///   title: 'Veja as pessoas próximas',
///   subtitle: 'Realize transações :)',
///   primaryLabel: 'Enviar dinheiro',
///   secondaryLabel: 'Receber dinheiro',
///   avatars: ['CM', 'BL'],
///   moreCount: 400,
///   onPrimary: enviar, onSecondary: receber, onClose: fechar,
/// );
/// ```
class BoldPromoBanner extends StatelessWidget {
  const BoldPromoBanner({
    super.key,
    required this.title,
    this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
    this.avatars = const [],
    this.moreCount,
    this.onPrimary,
    this.onSecondary,
    this.onClose,
  });

  final String title;
  final String? subtitle;
  final String primaryLabel;
  final String secondaryLabel;

  /// Iniciais dos avatares empilhados (some se vazio).
  final List<String> avatars;

  /// Contagem no bubble ao lado dos avatares (some se null/0).
  final int? moreCount;

  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          // 69° na convenção Figma (0° = pra cima). Base aponta pra direita
          // (=90°) → rotaciona (69 - 90)°.
          transform: GradientRotation((69 - 90) * math.pi / 180),
          colors: [BoldColors.primary02, BoldColors.primary05],
        ),
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(BoldSpace.x4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: BoldType.titleMd
                              .copyWith(color: BoldColors.white)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!,
                            style: BoldType.bodySm
                                .copyWith(color: BoldColors.white)),
                      ],
                    ],
                  ),
                ),
                if (avatars.isNotEmpty) ...[
                  const SizedBox(width: BoldSpace.x3),
                  _AvatarCluster(avatars: avatars, moreCount: moreCount),
                ],
              ]),
              const SizedBox(height: BoldSpace.x4),
              Row(children: [
                Expanded(
                  child: BoldButton(primaryLabel,
                      variant: BoldButtonVariant.white,
                      size: BoldButtonSize.xs,
                      onPressed: onPrimary),
                ),
                const SizedBox(width: BoldSpace.x2),
                Expanded(
                  child: BoldButton(secondaryLabel,
                      variant: BoldButtonVariant.secondary,
                      size: BoldButtonSize.xs,
                      onPressed: onSecondary),
                ),
              ]),
            ],
          ),
        ),
        // X — glyph branco 16, a 4px do topo/direita (tap target 36×36).
        if (onClose != null)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child:
                        BoldIcon('close', size: 16, color: BoldColors.white),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}

/// Avatares empilhados + bubble de contagem (bg primary01, texto primary05).
class _AvatarCluster extends StatelessWidget {
  const _AvatarCluster({required this.avatars, this.moreCount});
  final List<String> avatars;
  final int? moreCount;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      BoldAvatarStack(initials: avatars, bordered: false),
      if (moreCount != null && moreCount! > 0)
        Transform.translate(
          offset: const Offset(-8, 0),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: BoldColors.primary01,
              shape: BoxShape.circle,
            ),
            child: Text('$moreCount',
                style: BoldType.labelMd.copyWith(color: BoldColors.primary05)),
          ),
        ),
    ]);
  }
}
