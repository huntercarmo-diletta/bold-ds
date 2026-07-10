import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';

/// Conta BOLD — HomeIndicator (átomo). Slot inferior mínimo: a barra de gesto
/// do iOS (pill 134×5 num container h34). Consome só tokens.
///
/// - [color]: cor do pill (default neutral-01; use branco sobre fundos escuros).
/// - [background]: bg do container (default transparente).
class BoldHomeIndicator extends StatelessWidget {
  const BoldHomeIndicator({
    super.key,
    this.color = BoldColors.neutral01,
    this.background,
  });

  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      color: background,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(color: color, borderRadius: BoldRadius.pillR),
        ),
      ),
    );
  }
}
