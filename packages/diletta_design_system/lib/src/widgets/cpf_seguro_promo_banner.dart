import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_button.dart';
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Variante de superfície do [DilettaPromoBanner].
///
/// - **light** — fundo branco + borda/texto primary (discreto).
/// - **solid** — fundo primary + texto branco (destaque).
enum DilettaPromoBannerVariant { light, solid }

/// CPF SEGURO — PromoBanner.
///
/// Card promocional / CTA: título + subtítulo opcional + ilustração (à direita)
/// + botão opcional. É o banner de CHAMADA (ativar conta, conhecer feature) —
/// distinto do [DilettaStatusBanner], que é o banner de NÍVEL/progresso do
/// onboarding.
///
/// Consome tokens: cor primary/white por variante, radius 16, tipografia
/// (headlineSm/labelLg), e os componentes [DilettaIllustrationAccessory] e
/// [DilettaButton] — zero estética crua.
///
/// ```dart
/// DilettaPromoBanner(
///   title: 'Ative sua conta',
///   subtitle: 'Complete o cadastro pra usar o Pix.',
///   illustration: DilettaIllustration.keyWord,
///   buttonLabel: 'Continuar',
///   onPressed: () {},
/// )
/// ```
class DilettaPromoBanner extends StatelessWidget {
  const DilettaPromoBanner({
    super.key,
    required this.title,
    required this.illustration,
    this.subtitle,
    this.buttonLabel,
    this.onPressed,
    this.variant = DilettaPromoBannerVariant.light,
  });

  final String title;

  /// Token da ilustração (à direita). O átomo consome, não cria.
  final DilettaIllustration illustration;

  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  final DilettaPromoBannerVariant variant;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final light = variant == DilettaPromoBannerVariant.light;
    final fg = light ? s.palette.primary04 : s.palette.white;
    final bg = light ? s.palette.white : s.palette.primary04;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final hasButton = buttonLabel != null && buttonLabel!.isNotEmpty;

    return DilettaDevInfo(
      component: 'DilettaPromoBanner',
      props: {
        'variant': variant.name,
        if (hasButton) 'button': "'$buttonLabel'",
      },
      tokens: const [
        'bg/fg: primary04 <-> white por variante',
        'radius 16 · headlineSm/labelLg',
        'consome Illustration + Button',
      ],
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: DilettaRadius.all16,
          border: light ? Border.all(color: s.palette.primary04) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(DilettaSpacing.s4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: DilettaType.headlineSm.copyWith(color: fg)),
                    if (hasSubtitle) ...[
                      const SizedBox(height: DilettaSpacing.s1),
                      Text(subtitle!,
                          style: DilettaType.labelLg.copyWith(color: fg)),
                    ],
                    if (hasButton) ...[
                      const SizedBox(height: DilettaSpacing.s3),
                      DilettaButton(
                        label: buttonLabel!,
                        size: DilettaButtonSize.md,
                        onPressed: onPressed ?? () {},
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: DilettaSpacing.s2),
              child: DilettaIllustrationAccessory(
                illustration: illustration,
                size: DilettaIllustrationSize.sm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
