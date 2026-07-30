import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_gradients.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — StatusBanner (organismo).
///
/// Banner grande no topo da Home (e variantes em PauseDetails/HistoryDetails).
/// Gradient brand ([DilettaGradients.brandLift]) + shadow lift.
///
/// Estrutura vertical (Column · gap 16 · só blocos presentes):
/// 1. **LevelChip** opcional — "Nível X de Y" + dots (● ○ ○)
/// 2. **[body]** OU row default com 3 slots horizontais:
///    - [leftAccessory] · ícone 40×40 quadrado (ex: [DilettaStatusBannerActionIcon])
///    - Coluna central · [eyebrow] + [title] + [subtitle]
///    - [rightAccessory] · CTA circular ([DilettaStatusBannerCTA])
/// 3. **[progress]** opcional — `DilettaProgressBar.banner` (pausa ativa)
/// 4. **[footnote]** opcional — linha label-sm primary-07 (período histórico)
/// 5. **[button]** opcional — [DilettaStatusBannerButton] pill full-width
///
/// Variantes do fluxo Home (Figma 15:14571 / React HomeBanner.tsx):
/// - **level** — chip + row (eyebrow PRÓXIMO PASSO/VERIFICADO + CTA circular)
/// - **pausa ativa** — chip + row secure (icon amarelo + subtitle) + progress + "Ver detalhes"
/// - **doc em análise** — chip + row (eyebrow EM ANÁLISE, sem CTA)
/// - **doc erro** — chip + body: [DilettaStatusBannerErrorPanel] + button
///
/// **Composição** — Icon, Text (tokens). Os slots recebem os helpers
/// `DilettaStatusBanner*` (cada um em arquivo próprio) como Widgets.
class DilettaStatusBanner extends StatelessWidget {
  const DilettaStatusBanner({
    super.key,
    this.title,
    this.eyebrow,
    this.subtitle,
    this.level,
    this.total = 3,
    this.leftAccessory,
    this.rightAccessory,
    this.body,
    this.progress,
    this.footnote,
    this.button,
  }) : assert(title != null || body != null, 'Passe title (row default) ou body (ex: ErrorPanel).');

  /// Título da row default. Ignorado se [body] for passado.
  final String? title;
  final String? eyebrow;

  /// Linha label-sm primary-07 logo abaixo do título (ex: "Pausado em … por mim").
  final String? subtitle;

  /// Nível atual (1..[total]). Renderiza chip "Nível X de Y" + dots.
  /// Deixe null pra omitir o chip.
  final int? level;
  final int total;

  /// Ícone/widget à esquerda do texto (ex: [DilettaStatusBannerActionIcon]).
  final Widget? leftAccessory;

  /// CTA/ícone à direita (ex: [DilettaStatusBannerCTA]).
  final Widget? rightAccessory;

  /// Substitui a row default inteira (ex: [DilettaStatusBannerErrorPanel]).
  final Widget? body;

  /// Barra de progresso + caption (`DilettaProgressBar.banner`).
  final Widget? progress;

  /// Linha solta label-sm primary-07 (ex: "De 12/03 até 14/03 · 12 parceiros impactados").
  final String? footnote;

  /// CTA pill full-width ([DilettaStatusBannerButton]).
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final content = body ??
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftAccessory != null) ...[
              leftAccessory!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (eyebrow != null) ...[
                    Text(
                      eyebrow!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DilettaType.labelSm.copyWith(color: s.palette.primary07),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DilettaType.heading.copyWith(color: s.palette.white, letterSpacing: 0),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DilettaType.labelSm.copyWith(color: s.palette.primary07),
                    ),
                  ],
                ],
              ),
            ),
            if (rightAccessory != null) ...[
              const SizedBox(width: 8),
              rightAccessory!,
            ],
          ],
        );

    // Blocos presentes, na ordem, com gap 16 entre eles (React shell gap-16).
    final blocks = <Widget>[
      if (level != null) _LevelChip(level: level!, total: total),
      content,
      if (progress != null) progress!,
      if (footnote != null)
        Text(
          footnote!,
          style: DilettaType.labelSm.copyWith(color: s.palette.primary07),
        ),
      if (button != null) button!,
    ];

    // Padding React: `banner-padding-x=12, banner-padding-y=16`.
    return DilettaDevInfo(
      component: 'DilettaStatusBanner',
      props: {if (title != null) 'title': "'$title'", if (eyebrow != null) 'eyebrow': "'$eyebrow'", if (level != null) 'level': '$level de $total', if (body != null) 'body': 'ErrorPanel'},
      tokens: const ['gradient brandLift · radius 24 · p 12/16 · shadow primary05Alpha40', 'blocos gap16: chip → row → progress → footnote → button'],
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s3, vertical: DilettaSpacing.s4),
      decoration: BoxDecoration(
        gradient: DilettaGradients.brandLiftDe(s.palette),
        borderRadius: DilettaRadius.all24,
        boxShadow: DilettaElevation.brandMediumDe(s.palette),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < blocks.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            blocks[i],
          ],
        ],
      ),
    ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level, required this.total});
  final int level;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s2),
      decoration: BoxDecoration(
        color: DilettaAbsoluteColors.whiteAlpha24,
        border: Border.all(color: DilettaAbsoluteColors.whiteAlpha38, width: 1),
        borderRadius: DilettaRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nível $level de $total',
            style: DilettaType.labelSm.copyWith(color: DilettaAbsoluteColors.white),
          ),
          const SizedBox(width: 6),
          // Dots feitos com Icon (circle-small-solid/light) pra manter a
          // gramática do DS — nada de Container(shape: circle) hardcoded.
          for (var n = 1; n <= total; n++)
            DilettaIconAccessory(
              icon: n <= level ? 'circle-small-solid' : 'circle-small-light',
              padding: 0,
              size: 12,
              color: n <= level ? DilettaAbsoluteColors.white : DilettaAbsoluteColors.whiteAlpha38,
            ),
        ],
      ),
    );
  }
}
