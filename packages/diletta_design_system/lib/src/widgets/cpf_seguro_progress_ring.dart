import 'dart:math' as math;
import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator, AlwaysStoppedAnimation;
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — ProgressRing (átomo).
///
/// Anel de progresso circular com label central. Distinto do
/// [DilettaProgressBar] (linear). Usado em linhas de serviço (% restante).
///
/// - [progress] 0..1 (fração preenchida).
/// - [label] texto central opcional (ex. dias restantes).
///
/// **Composição** — só tokens.
class DilettaProgressRing extends StatelessWidget {
  const DilettaProgressRing({
    super.key,
    required this.progress,
    this.label,
    this.size = 40,
  });

  /// Fração preenchida (0..1).
  final double progress;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaProgressRing',
      props: {'progress': progress.toStringAsFixed(2), if (label != null) 'label': "'$label'"},
      tokens: const ['track primary-07 · valor primary-04 · label bodySm primary-04 · strokeCap round'],
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: -math.pi / 2,
              child: CircularProgressIndicator(
                value: progress.clamp(0, 1),
                backgroundColor: s.primaryTrack,
                valueColor: AlwaysStoppedAnimation(s.primary),
                strokeCap: StrokeCap.round,
              ),
            ),
            if (label != null)
              Text(
                label!,
                maxLines: 1,
                style: DilettaType.bodySm.copyWith(color: s.primary),
              ),
          ],
        ),
      ),
    );
  }
}
