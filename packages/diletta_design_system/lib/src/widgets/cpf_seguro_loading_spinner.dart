import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_theme.dart';

/// Tamanho do LoadingSpinner — mirror do Figma DS (node 1539:3239).
enum DilettaSpinnerSize { sm, md, lg }

/// CPF SEGURO — LoadingSpinner.
///
/// Indicador de carregamento circular: track neutral-07 + arco 75% primary-04.
/// Rotação contínua 900ms linear infinite.
///
/// ```dart
/// DilettaLoadingSpinner(),                                  // md · 40
/// DilettaLoadingSpinner(size: DilettaSpinnerSize.sm),      // 22
/// DilettaLoadingSpinner(size: DilettaSpinnerSize.lg),      // 60
/// ```
class DilettaLoadingSpinner extends StatefulWidget {
  const DilettaLoadingSpinner({
    super.key,
    this.size = DilettaSpinnerSize.md,
    this.semanticLabel = 'Carregando',
  });

  final DilettaSpinnerSize size;
  final String semanticLabel;

  @override
  State<DilettaLoadingSpinner> createState() => _CpsLoadingSpinnerState();
}

class _CpsLoadingSpinnerState extends State<DilettaLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: DilettaMotion.spinner,
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec(widget.size);
    return DilettaDevInfo(
      component: 'DilettaLoadingSpinner',
      props: {'size': widget.size.name},
      tokens: const ['track neutral-07 · arco 75% primary-04'],
      child: Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: RotationTransition(
        turns: _c,
        child: SizedBox(
          width: spec.d,
          height: spec.d,
          child: CustomPaint(
              painter: _SpinnerPainter(
                spec: spec,
                // `CustomPainter` não recebe context: a cor entra resolvida daqui.
                cor: DilettaTheme.schemeOf(context).primary,
              ),
            ),
        ),
      ),
    ),
    );
  }
}

class _Spec {
  const _Spec({required this.d, required this.stroke});
  final double d;
  final double stroke;
}

_Spec _spec(DilettaSpinnerSize size) => switch (size) {
      DilettaSpinnerSize.sm => const _Spec(d: 22, stroke: 2),
      DilettaSpinnerSize.md => const _Spec(d: 40, stroke: 3),
      DilettaSpinnerSize.lg => const _Spec(d: 60, stroke: 4),
    };

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.spec, required this.cor});
  final _Spec spec;

  /// Cor do arco, já resolvida do tema pelo widget (painter não tem context).
  final Color cor;

  @override
  void paint(Canvas canvas, Size size) {
    // Usa o tamanho REAL do box (não spec.d hardcoded): se um pai constrange o
    // widget (ex. SizedBox de altura menor), o arco continua centrado no box —
    // então a RotationTransition (que gira em torno do centro do box) gira no
    // próprio eixo em vez de "orbitar" um ponto fora do arco.
    final d = size.shortestSide > 0 ? size.shortestSide : spec.d;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (d - spec.stroke) / 2;

    // Só o arco azul em degrade: cauda transparente afinando até a cabeça
    // opaca. Sem track cinza, sem dot.
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Arco longo (90%) → fade bem gradual, sem cara de "bloco".
    const sweep = 2 * math.pi * 0.9;
    final shader = SweepGradient(
      colors: [
        cor.withValues(alpha: 0),
        cor,
      ],
      stops: const [0.0, 0.9],
      transform: const GradientRotation(-math.pi / 2),
    ).createShader(rect);
    final comet = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = spec.stroke
      // butt (não round): sem a bolinha sólida na ponta opaca do degrade.
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, comet);
  }

  @override
  // A cor agora VEM DE FORA (do tema), então `false` passou a ser errado: trocar
  // de tema não repintaria o arco. Compara o que o painter usa.
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) =>
      oldDelegate.cor != cor || oldDelegate.spec != spec;
}
