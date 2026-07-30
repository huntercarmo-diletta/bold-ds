import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_cobrand_eyebrow.dart' show DilettaCobrandEyebrow;
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_partner_button.dart';

/// CPF SEGURO — SdkScreen.
///
/// Layout base pra screens do SDK que NÃO são chat: Welcome (T2), ErrorFatal,
/// telas de saída. Estrutura fixa (top-down):
///
/// 1. **CobrandEyebrow** — "{PARCEIRO} + logo CPF SEGURO"
/// 2. Espaço flexível
/// 3. **IllustrationAccessory** hero (opcional)
/// 4. **Title** — DilettaType.title
/// 5. **Subtitle** — DilettaType.bodyMd
/// 6. Espaço flexível
/// 7. **PartnerButton** — CTA principal
///
/// Bg = [DilettaGradients.screenBg] por default (white → primary-08).
/// Usar `bg` pra sobrepor.
///
/// ```dart
/// DilettaSdkScreen(
///   partnerName: 'Banco Aurora',
///   illustration: DilettaIllustration.fingerprint,
///   title: 'Seu login agora é com a gente',
///   subtitle: 'Crie uma senha pelo CPF SEGURO em menos de 1 minuto.',
///   primaryLabel: 'Criar nova senha',
///   onPrimary: () => next(),
/// )
/// ```
class DilettaSdkScreen extends StatelessWidget {
  const DilettaSdkScreen({
    super.key,
    required this.partnerName,
    required this.title,
    required this.primaryLabel,
    this.subtitle,
    this.illustration,
    this.illustrationSize = DilettaIllustrationSize.md,
    this.onPrimary,
    this.gradient,
  });

  /// Nome do parceiro pro CobrandEyebrow.
  final String partnerName;

  /// Token da ilustração hero (ex: [DilettaIllustration.fingerprint]). Se
  /// null, o hero é omitido.
  final DilettaIllustration? illustration;

  /// Degrau canônico da ilustração hero.
  final DilettaIllustrationSize illustrationSize;

  /// Título principal — title (22/28 · 600).
  final String title;

  /// Subtítulo opcional — bodyMd neutral-03.
  final String? subtitle;

  /// Label do CTA rodapé (PartnerButton).
  final String primaryLabel;

  /// Callback do CTA.
  final VoidCallback? onPrimary;

  /// Gradient de fundo. Default: [DilettaGradients.screenBg].
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    // Screen bg: em dark, fundo sólido s.bg; em light, o gradient sutil
    // (white → primary-08). Override explícito de [gradient] sempre vence.
    final decoration = gradient != null
        ? BoxDecoration(gradient: gradient)
        : (s.isDark
            ? BoxDecoration(color: s.bg)
            : BoxDecoration(gradient: DilettaGradients.screenBgDe(s.palette)));
    return DecoratedBox(
      decoration: decoration,
      // Safe area top=40 (StatusBar glass) + 24 respiro; bottom=34 (BottomBar
      // glass) + 24 respiro. Content vai por baixo dos containers glass.
      // PREENCHE quando cabe, ROLA quando não cabe. Os `Spacer` daqui precisam
      // de altura limitada; com título de duas linhas + subtítulo + ilustração
      // no tamanho padrão o conteúdo passava 2px da tela de 852 e estourava.
      // `SliverFillRemaining(hasScrollBody: false)` resolve os dois casos com um
      // mecanismo só — é o mesmo que o `DilettaSurface` já usa pro content de
      // altura limitada.
      //
      // O PADDING VAI DENTRO do sliver, e essa linha é o conserto de um defeito medido: com
      // `SliverPadding(sliver: SliverFillRemaining(...))`, o sliver recebe a viewport INTEIRA como
      // espaço restante — ele NÃO desconta o padding do pai. O filho ficava mais alto que a área
      // padded e o CTA era pintado dentro dos 34 reservados pro home indicator: no aparelho, um
      // botão que não se toca; no catálogo, a barrinha por cima do botão.
      //
      // O mesmo defeito estava no frame de preview do catálogo, com a mesma forma e a mesma causa.
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
          padding: const EdgeInsets.fromLTRB(DilettaSpacing.s6, DilettaSpacing.s10 + DilettaSpacing.s6, DilettaSpacing.s6, 34 + DilettaSpacing.s6),
          child: Column(
          children: [
            DilettaCobrandEyebrow(partnerName: partnerName),
            const Spacer(),
            if (illustration != null)
              DilettaIllustrationAccessory(illustration: illustration!, size: illustrationSize),
            if (illustration != null) const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: DilettaType.title.copyWith(
                color: s.fg,
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: DilettaType.bodyMd.copyWith(color: s.textTertiary),
              ),
            ],
            const Spacer(),
            DilettaPartnerButton(label: primaryLabel, onPressed: onPrimary),
          ],
          ),
          ),
        ),
      ]),
    );
  }
}
