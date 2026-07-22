import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Campo de valor monetário — input estilo ATM (só dígitos, formato brasileiro).
///
/// Cada dígito digitado desloca os centavos para a esquerda:
///   "1" → R$ 0,01 · "12" → R$ 0,12 · "123" → R$ 1,23
/// Backspace remove o dígito mais à direita.
/// Começa vazio (hint "R$ 0,00") quando initialValue == 0.
class AppCurrencyField extends StatefulWidget {
  const AppCurrencyField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.large = false,
    this.isDark = true,
    this.validator,
  });

  final TextEditingController? controller;
  final double? initialValue;
  final ValueChanged<double>? onChanged;
  final bool large;
  final bool isDark;
  final String? Function(String?)? validator;

  @override
  State<AppCurrencyField> createState() => _AppCurrencyFieldState();
}

class _AppCurrencyFieldState extends State<AppCurrencyField> {
  late final TextEditingController _ctrl;
  final FocusNode _focus = FocusNode();
  bool _ownsCtrl = false;
  int  _cents    = 0;
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

  /// Ao focar, zera o valor mantendo o "R$ " fixo e o cursor logo à direita
  /// dele — o usuário digita do zero, sem apagar zero/valor pré-existente e sem
  /// o cursor cair em cima do símbolo.
  void _onFocus() {
    if (!_focus.hasFocus) return;
    _setValue(0);
    widget.onChanged?.call(0);
  }

  /// Escreve o valor formatado ("R$ …") e deixa o cursor no fim.
  void _setValue(int cents) {
    _cents = cents;
    _updating = true;
    final t = _format(cents);
    _ctrl.value = TextEditingValue(
      text:      t,
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
    final trimmed  = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    final newCents = trimmed.isEmpty ? 0 : int.parse(trimmed);

    // Reescreve sempre que o texto não estiver no formato canônico — garante o
    // "R$ " fixo (mesmo se o usuário apagar tudo) e o cursor à direita.
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
    final s   = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:      _ctrl,
      focusNode:       _focus,
      keyboardType:    TextInputType.number,
      textAlign:       TextAlign.center,
      validator:       widget.validator,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      // Cor keyed no MESMO brilho do CONTEXTO que o fillColor do
      // InputDecorationTheme (isDark ? surf2Dark : bgLight). O `widget.isDark`
      // fixo + AppColors.textDark (brilho GLOBAL) dava branco-no-branco no tema
      // escuro quando o global e o contexto desalinhavam. #BUG1 do QA.
      style: (widget.large ? AppTextStyles.amount : AppTextStyles.amountMd).copyWith(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.textOnDark
            : AppColors.textLight,
      ),
      // FILL EXPLÍCITO casado com a MESMA fonte da cor do texto: o fill vinha
      // do InputDecorationTheme (que em algumas telas resolve claro mesmo no
      // tema escuro) e o texto do Theme.of(context) → branco-no-branco em
      // Receber Pix / Nova Cobrança (QA BUGs 48/50). Definindo os dois juntos,
      // nunca divergem.
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surf2Dark
            : AppColors.bgLight,
        // Sem hint: o campo já mostra "R$ " como texto real (nunca fica vazio).
      ),
    );
  }
}
