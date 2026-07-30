import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — ProgressBar (molécula).
///
/// Barra de progresso h5 + caption opcional. UMA molécula, duas skins —
/// mesma geometria, cores por contexto:
///
/// - [DilettaProgressBar.banner] — dentro do StatusBanner (pausa ativa):
///   trilho whiteAlpha24 + border whiteAlpha38 · fill secure-05 ·
///   caption primary-07. Usar via `DilettaStatusBanner(progress:)`.
/// - [DilettaProgressBar.activity] — footer de row de atividade
///   (CPF Pausado no Histórico/Home): trilho neutral-07 · fill primary-04 ·
///   caption neutral-05. Usar via `DilettaAppListRow.activityItem(footer:)`.
/// - [DilettaProgressBar.value] — progresso CONTÍNUO (0..1), skin activity
///   (trilho neutral-07 · fill primary-04). Pro consumidor que dirige o valor
///   (ex.: loading animado por AnimationController) — a animação fica no app.
///
/// Figma 15:15679 (banner) · 99:4042 (atividade).
class DilettaProgressBar extends StatelessWidget {
  const DilettaProgressBar.banner({
    super.key,
    required this.confirmed,
    required this.total,
    this.caption,
  })  : _variant = _Variant.banner,
        _rawValue = null;

  const DilettaProgressBar.activity({
    super.key,
    required this.confirmed,
    required this.total,
    this.caption,
  })  : _variant = _Variant.activity,
        _rawValue = null;

  /// Progresso contínuo dirigido pelo consumidor: [value] em 0..1.
  const DilettaProgressBar.value({
    super.key,
    required double value,
    this.caption,
  })  : _variant = _Variant.value,
        _rawValue = value,
        confirmed = 0,
        total = 0;

  final int confirmed;
  final int total;
  final String? caption;
  final _Variant _variant;
  final double? _rawValue;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final raw = _rawValue;
    final pct = raw != null
        ? raw.clamp(0.0, 1.0)
        : (total > 0 ? (confirmed / total).clamp(0.0, 1.0) : 0.0);
    final isBanner = _variant == _Variant.banner;

    final track = BoxDecoration(
      color: isBanner ? DilettaAbsoluteColors.whiteAlpha24 : s.palette.neutral07,
      border: isBanner
          ? Border.all(color: DilettaAbsoluteColors.whiteAlpha38, width: 0.5)
          : null,
      borderRadius: isBanner ? DilettaRadius.pillAll : DilettaRadius.all8,
    );
    final fillColor = isBanner ? s.palette.secure05 : s.primary;
    final captionColor = isBanner ? s.palette.primary07 : s.textPlaceholder;

    return DilettaDevInfo(
      component: 'DilettaProgressBar',
      props: {
        'skin': _variant.name,
        'progress': _rawValue != null ? pct.toStringAsFixed(2) : '$confirmed/$total',
      },
      tokens: const ['banner: trilho whiteAlpha24 fill secure-05 · activity: trilho neutral-07 fill primary-04'],
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 5,
          child: Stack(
            children: [
              Positioned.fill(child: DecoratedBox(decoration: track)),
              FractionallySizedBox(
                widthFactor: pct,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: DilettaRadius.all8,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DilettaType.labelSm.copyWith(color: captionColor),
          ),
        ],
      ],
    ),
    );
  }
}

enum _Variant { banner, activity, value }
