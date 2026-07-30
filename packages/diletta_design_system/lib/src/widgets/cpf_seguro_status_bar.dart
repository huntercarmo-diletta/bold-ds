import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — StatusBar.
///
/// Faixa iOS no topo (9:41 · signal · wifi · battery). Altura 40.
///
/// **Filosofia DS:** StatusBar é um **elemento** que compõe a TopBar. O glass
/// é característica do container (TopAppBar), não deste elemento. Por isso
/// StatusBar sempre renderiza sem fundo — o container acima decide se ele
/// aparece atrás de um glass, de um branco sólido, ou de um bottomsheet.
///
/// NÃO se auto-posiciona — o caller decide (ex: `Positioned(top: 0, ...)`
/// no PhoneShell, ou inline no topSlot da TopAppBar).
class DilettaStatusBar extends StatelessWidget {
  const DilettaStatusBar({super.key, this.time = '9:41'});

  final String time;

  @override
  Widget build(BuildContext context) {
    // "Ink" da faixa iOS = fg do scheme (escuro no light, claro no dark).
    final Color ink = DilettaTheme.schemeOf(context).fg;
    return DilettaDevInfo(
      component: 'DilettaStatusBar',
      props: const {},
      tokens: const ['h44 · relógio mono 14/600'],
      child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time, style: DilettaType.mono.copyWith(color: ink)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Signal(color: ink),
              const SizedBox(width: 6),
              _Wifi(color: ink),
              const SizedBox(width: 6),
              _Battery(color: ink),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class _Signal extends StatelessWidget {
  const _Signal({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 17,
      height: 11,
      child: CustomPaint(painter: _SignalPainter(color)),
    );
  }
}

class _SignalPainter extends CustomPainter {
  _SignalPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    void bar(double x, double y, double h) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 3, h), const Radius.circular(0.5)),
        paint,
      );
    }
    bar(0, 7, 4);
    bar(4.5, 5, 6);
    bar(9, 2.5, 8.5);
    bar(13.5, 0, 11);
  }

  @override
  bool shouldRepaint(covariant _SignalPainter old) => old.color != color;
}

class _Wifi extends StatelessWidget {
  const _Wifi({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 11,
      child: CustomPaint(painter: _WifiPainter(color)),
    );
  }
}

class _WifiPainter extends CustomPainter {
  _WifiPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // Arco externo
    final p1 = Path()..moveTo(0.7, 2.7)..cubicTo(2.7, 1, 5.2, 0, 8, 0)..cubicTo(10.8, 0, 13.3, 1, 15.4, 2.7)
      ..lineTo(14, 4.3)..cubicTo(12.4, 2.8, 10.3, 2, 8, 2)..cubicTo(5.7, 2, 3.6, 2.8, 2.2, 4.3)
      ..close();
    canvas.drawPath(p1, paint);
    // Arco médio
    final p2 = Path()..moveTo(3.2, 5.8)..cubicTo(4.5, 4.7, 6.2, 4, 8, 4)..cubicTo(9.8, 4, 11.5, 4.7, 12.8, 5.8)
      ..lineTo(11.4, 7.3)..cubicTo(10.5, 6.5, 9.3, 6, 8, 6)..cubicTo(6.7, 6, 5.5, 6.5, 4.7, 7.4)
      ..close();
    canvas.drawPath(p2, paint);
    // Dot
    canvas.drawCircle(const Offset(8, 10), 2, paint);
  }

  @override
  bool shouldRepaint(covariant _WifiPainter old) => old.color != color;
}

class _Battery extends StatelessWidget {
  const _Battery({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    final frame = color.withValues(alpha: 0.4);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25,
          height: 12,
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: DilettaRadius.all2,
            border: Border.all(color: frame, width: 1),
          ),
          child: Container(
            width: 18,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
        Container(
          width: 1.5,
          height: 5,
          margin: const EdgeInsets.only(left: 1),
          decoration: BoxDecoration(color: frame),
        ),
      ],
    );
  }
}
