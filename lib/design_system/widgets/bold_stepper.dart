import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — Stepper (molécula). "{label} · Passo X de Y" + linha de N
/// segmentos: passados = primary-04, futuros = primary-07 (wash). Vive no
/// [BoldTopBar.stepper] ou standalone em fluxos multi-etapa (onboarding, PIX).
///
/// **Composição** — Text (tokens de tipo) + segmentos (tokens de cor).
///
/// ```dart
/// BoldStepper(current: 2, total: 4, labelText: 'Abertura de conta');
/// ```
class BoldStepper extends StatelessWidget {
  const BoldStepper({
    super.key,
    required this.current,
    required this.total,
    this.label,
    this.labelText,
  }) : assert(label != null || labelText != null,
            'Passe label (widget) OU labelText (string).');

  final int current;
  final int total;
  final Widget? label;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final labelStyle = BoldType.monoCaption.copyWith(
      fontFamily: BoldType.fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: BoldColors.neutral05,
    );
    final leftWidget = label ?? Text(labelText!, style: labelStyle);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: leftWidget),
                Text('Passo $current de $total', style: labelStyle),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(children: [
            for (var i = 0; i < total; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: i < current
                        ? BoldColors.primary04
                        : BoldColors.primary07,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ]),
        ],
      ),
    );
  }
}
