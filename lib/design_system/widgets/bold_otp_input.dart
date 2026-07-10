import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — OtpInput (molécula). Display de código OTP (6 boxes por default);
/// visual apenas — a digitação vem de um keypad externo (o pai passa [value]).
///
/// **Composição** — boxes (átomos) + tokens.
///
/// Estados por box: default (border neutral-07) · preenchido (neutral-01) ·
/// foco/próximo (primário) · erro (danger em todos + mensagem).
///
/// ```dart
/// BoldOtpInput(value: '123');
/// BoldOtpInput(value: '12345', error: 'Código incorreto');
/// ```
class BoldOtpInput extends StatelessWidget {
  const BoldOtpInput({
    super.key,
    required this.value,
    this.error,
    this.length = 6,
  });

  final String value;
  final String? error;
  final int length;

  @override
  Widget build(BuildContext context) {
    final digits = List<String>.generate(
        length, (i) => i < value.length ? value[i] : '');
    final focusIndex = value.length < length ? value.length : -1;
    final isError = error != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              _OtpBox(digit: digits[i], focused: i == focusIndex, error: isError),
            ],
          ],
        ),
        if (isError) ...[
          const SizedBox(height: 8),
          Text(error!,
              textAlign: TextAlign.center,
              style: BoldType.label
                  .copyWith(color: BoldColors.danger, letterSpacing: 0)),
        ],
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox(
      {required this.digit, required this.focused, required this.error});
  final String digit;
  final bool focused;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final borderColor = error
        ? BoldColors.danger
        : focused
            ? BoldColors.primary
            : digit.isNotEmpty
                ? BoldColors.neutral01
                : BoldColors.neutral07;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 44,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: BoldColors.white,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BoldRadius.chipR,
      ),
      child: Text(digit,
          style: BoldType.title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: error ? BoldColors.danger : BoldColors.neutral01)),
    );
  }
}
