import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';

/// Tamanhos do [BoldSpinner] — diâmetro / espessura do traço.
enum BoldSpinnerSize { sm, md, lg }

/// Conta BOLD — Spinner (átomo). Indicador de progresso indeterminado.
///
/// Evolução do arco "seco" (traço chapado) para um **arco com gradiente** que
/// desvanece de transparente → cor base, com ponta arredondada, girando sobre
/// um trilho sutil. Lê como movimento (a cabeça do arco é sólida, a cauda some)
/// e não como um C estático rodando.
///
/// ```dart
/// BoldSpinner();                          // md, rosa da marca
/// BoldSpinner(size: BoldSpinnerSize.sm, color: BoldColors.success04);
/// ```
class BoldSpinner extends StatefulWidget {
  const BoldSpinner({
    super.key,
    this.size = BoldSpinnerSize.md,
    this.color,
    this.label = 'Carregando',
  });

  final BoldSpinnerSize size;

  /// Cor do arco. Default = rosa da marca (primary-04).
  final Color? color;

  /// Rótulo de acessibilidade.
  final String label;

  double get _d => switch (size) {
        BoldSpinnerSize.sm => 22,
        BoldSpinnerSize.md => 40,
        BoldSpinnerSize.lg => 60,
      };
  double get _stroke => switch (size) {
        BoldSpinnerSize.sm => 2.5,
        BoldSpinnerSize.md => 3.5,
        BoldSpinnerSize.lg => 4.5,
      };

  @override
  State<BoldSpinner> createState() => _BoldSpinnerState();
}

class _BoldSpinnerState extends State<BoldSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? BoldColors.primary04;
    return Semantics(
      label: widget.label,
      value: 'em progresso',
      child: SizedBox(
        width: widget._d,
        height: widget._d,
        child: RotationTransition(
          turns: _ctrl,
          child: CustomPaint(
            painter: _SpinnerPainter(color: color, stroke: widget._stroke),
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({required this.color, required this.stroke});
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - stroke) / 2;

    // Trilho sutil (anel completo).
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color.withValues(alpha: 0.13);
    canvas.drawCircle(center, radius, track);

    // Arco com gradiente: cauda transparente → cabeça sólida, ponta arredondada.
    // Sweep de ~300° começando no topo.
    const start = -math.pi / 2;
    const sweep = math.pi * 2 * 0.82;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: sweep,
        colors: [color.withValues(alpha: 0.0), color],
        stops: const [0.0, 1.0],
        transform: GradientRotation(start),
      ).createShader(rect);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter o) =>
      o.color != color || o.stroke != stroke;
}
