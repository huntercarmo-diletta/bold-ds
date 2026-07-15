import 'package:flutter/services.dart';

/// Conta BOLD — formatter de input de dinheiro. Formata a digitação em CENTAVOS
/// para "R$ 1.234,56" (máx 10 dígitos → R$ 99.999.999,99). Pra usar com
/// [BoldTextField] quando o valor é um campo bordado (não o display grande do
/// [BoldCurrencyField]).
///
/// ```dart
/// BoldTextField(
///   controller: ctrl,
///   keyboardType: TextInputType.number,
///   inputFormatters: [BoldMoneyInputFormatter()],
///   onChanged: (t) => value = BoldMoneyInputFormatter.parse(t),
/// );
/// ```
class BoldMoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final trimmed =
        digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    final cents = trimmed.isEmpty ? 0 : int.parse(trimmed);
    final text = format(cents);
    return TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length));
  }

  /// Valor (reais) a partir do texto formatado. "R$ 2.500,00" → 2500.0.
  static double parse(String text) {
    final d = text.replaceAll(RegExp(r'\D'), '');
    return d.isEmpty ? 0 : int.parse(d) / 100.0;
  }

  /// Centavos → "R$ 1.234,56" (0 → "R$ ").
  static String format(int cents) {
    if (cents == 0) return 'R\$ ';
    final dec = (cents % 100).toString().padLeft(2, '0');
    final s = (cents ~/ 100).toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'R\$ $buf,$dec';
  }
}
