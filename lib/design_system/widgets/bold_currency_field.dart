import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — CurrencyField (átomo). Campo de valor em CENTAVOS: mostra sempre
/// o "R$ " fixo, formata milhar/decimal, ZERA ao focar (o usuário digita do
/// zero), máx 10 dígitos (R$ 99.999.999,99). Borderless, centralizado,
/// theme-aware. Porte do texto pelo [large] (hero) vs médio.
///
/// Espelha o comportamento do antigo `AppCurrencyField` (ds_compat), mas lê
/// cor/typografia dos tokens do DS novo.
///
/// **Composição** — só tokens ([BoldType], [BoldColors]).
class BoldCurrencyField extends StatefulWidget {
  const BoldCurrencyField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.large = false,
    this.validator,
  });

  final TextEditingController? controller;
  final double? initialValue;
  final ValueChanged<double>? onChanged;

  /// `true` = número hero (display/46); `false` = médio (28).
  final bool large;
  final String? Function(String?)? validator;

  @override
  State<BoldCurrencyField> createState() => _BoldCurrencyFieldState();
}

class _BoldCurrencyFieldState extends State<BoldCurrencyField> {
  late final TextEditingController _ctrl;
  final FocusNode _focus = FocusNode();
  bool _ownsCtrl = false;
  int _cents = 0;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialValue;
    _cents = (init != null && init > 0) ? (init * 100).round() : 0;
    if (widget.controller != null) {
      _ctrl = widget.controller!;
      if (_ctrl.text.isEmpty) _ctrl.text = _format(_cents);
    } else {
      _ownsCtrl = true;
      _ctrl = TextEditingController(text: _format(_cents));
    }
    _ctrl.addListener(_onChanged);
    _focus.addListener(_onFocus);
  }

  /// Ao focar, zera mantendo o "R$ " e o cursor à direita — digita do zero.
  void _onFocus() {
    if (!_focus.hasFocus) return;
    _setValue(0);
    widget.onChanged?.call(0);
  }

  void _setValue(int cents) {
    _cents = cents;
    _updating = true;
    final t = _format(cents);
    _ctrl.value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
    _updating = false;
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onChanged);
    _focus.removeListener(_onFocus);
    _focus.dispose();
    if (_ownsCtrl) _ctrl.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_updating) return;
    final digits = _ctrl.text.replaceAll(RegExp(r'\D'), '');
    // Máximo de 10 dígitos → R$ 99.999.999,99
    final trimmed =
        digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    final newCents = trimmed.isEmpty ? 0 : int.parse(trimmed);
    if (_ctrl.text != _format(newCents)) {
      _setValue(newCents);
    } else {
      _cents = newCents;
    }
    widget.onChanged?.call(_cents / 100.0);
  }

  String _format(int cents) {
    if (cents == 0) return 'R\$ ';
    final dec = (cents % 100).toString().padLeft(2, '0');
    return 'R\$ ${_thousands(cents ~/ 100)},$dec';
  }

  String _thousands(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final style = (widget.large
            ? BoldType.display
            : BoldType.display.copyWith(fontSize: 28, letterSpacing: -0.8))
        .copyWith(color: c.textPrimary);
    return TextFormField(
      controller: _ctrl,
      focusNode: _focus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: c.primary,
      validator: widget.validator,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: style,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}
