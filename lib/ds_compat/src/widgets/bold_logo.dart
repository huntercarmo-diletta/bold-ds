import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

/// Conta BOLD — Marca / logotipo oficial.
///
/// Reproduz fielmente o símbolo do wireframe: um quadrado branco com cantos
/// arredondados contendo um anel (donut) preenchido com gradiente
/// vermelho → laranja → amarelo, na diagonal (canto inferior-esquerdo →
/// canto superior-direito).
///
/// ```dart
/// const BoldLogoMark(size: 64)                 // só o símbolo
/// const BoldLogoMark(size: 40, wordmark: true) // símbolo + "BOLD"
/// ```
class BoldLogoMark extends StatelessWidget {
  const BoldLogoMark({
    super.key,
    this.size = 56,
    this.wordmark = false,
    this.wordmarkColor,
    this.wordmarkSpacing = 12,
  });

  /// Lado do símbolo quadrado, em logical pixels.
  final double size;

  /// Se `true`, exibe o texto "BOLD" ao lado do símbolo.
  final bool wordmark;

  /// Cor do texto "BOLD" (default: branco em telas dark).
  final Color? wordmarkColor;

  /// Espaço entre o símbolo e o texto.
  final double wordmarkSpacing;

  @override
  Widget build(BuildContext context) {
    final mark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BoldMarkPainter()),
    );

    if (!wordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: wordmarkSpacing),
        Text(
          'BOLD',
          style: AppTextStyles.displaySm.copyWith(
            color: wordmarkColor ?? AppColors.textDark,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _BoldMarkPainter extends CustomPainter {
  static const _gradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFFF2D55), Color(0xFFFF6B2B), Color(0xFFFFD60A)],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final rect = Offset.zero & Size(s, s);

    // Cartão branco arredondado (rx = 22% no wireframe).
    final cardPaint = Paint()..color = Colors.white;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(s * 0.22));
    canvas.drawRRect(rrect, cardPaint);

    // Anel: raio externo 40%, interno 22% (do wireframe) → traço centrado
    // em 31% com espessura 18%.
    final center = rect.center;
    final ringRadius = s * 0.31;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18
      ..shader = _gradient.createShader(rect);
    canvas.drawCircle(center, ringRadius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _BoldMarkPainter oldDelegate) => false;
}
