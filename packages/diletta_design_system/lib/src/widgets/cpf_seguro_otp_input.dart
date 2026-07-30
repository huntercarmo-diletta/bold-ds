import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — OtpInput.
///
/// Campo de código OTP (6 boxes 40×40 por default). **Interativo**: um
/// `TextField` transparente por cima dos boxes captura a digitação (teclado
/// numérico, só dígitos, limite = [length]); os boxes renderizam o valor. Tocar
/// em qualquer box foca o campo.
///
/// - [controller]/[focusNode] opcionais (internos se null). [value] semeia o
///   controller interno.
/// - [onChanged] a cada dígito · [onCompleted] quando enche.
/// - [obscure] mascara com "•". [error] pinta todos os boxes + mensagem.
/// - Sem [onChanged]/[controller] e sem [autofocus] → funciona como display.
///
/// Estados por box: default neutral-07 · filled neutral-01 · focused primary-04
/// · error error-04 (todos).
///
/// ```dart
/// DilettaOtpInput(onCompleted: (code) => verify(code), autofocus: true),
/// DilettaOtpInput(value: '12345', error: 'Código incorreto'), // display
/// ```
class DilettaOtpInput extends StatefulWidget {
  const DilettaOtpInput({
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.length = 6,
    this.error,
    this.onChanged,
    this.onCompleted,
    this.obscure = false,
    this.autofocus = false,
    this.enabled = true,
  });

  /// Valor inicial (semeia o controller interno quando [controller] é null).
  final String value;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int length;
  final String? error;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool obscure;
  final bool autofocus;
  final bool enabled;

  @override
  State<DilettaOtpInput> createState() => _CpsOtpInputState();
}

class _CpsOtpInputState extends State<DilettaOtpInput> {
  late final TextEditingController _c =
      widget.controller ?? TextEditingController(text: widget.value);
  late final FocusNode _f = widget.focusNode ?? FocusNode();
  bool get _ownController => widget.controller == null;
  bool get _ownFocus => widget.focusNode == null;

  @override
  void initState() {
    super.initState();
    _c.addListener(_onChanged);
    _f.addListener(_onFocus);
  }

  void _onChanged() {
    setState(() {});
    widget.onChanged?.call(_c.text);
    if (_c.text.length == widget.length) widget.onCompleted?.call(_c.text);
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _c.removeListener(_onChanged);
    _f.removeListener(_onFocus);
    if (_ownController) _c.dispose();
    if (_ownFocus) _f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _c.text;
    final isError = widget.error != null;
    final focusIndex =
        _f.hasFocus && text.length < widget.length ? text.length : -1;

    return DilettaDevInfo(
      component: 'DilettaOtpInput',
      props: {
        'length': '${text.length}/${widget.length}',
        if (widget.obscure) 'obscure': 'true',
        if (isError) 'error': "'${widget.error}'",
      },
      tokens: const ['6 boxes 40×40 · radius 8 · otpDigit', 'input transparente'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    _OtpBox(
                      char: i >= text.length
                          ? ''
                          : (widget.obscure ? '•' : text[i]),
                      focused: i == focusIndex,
                      error: isError,
                    ),
                  ],
                ],
              ),
              // Campo transparente que captura a digitação (cobre os boxes).
              Positioned.fill(
                child: TextField(
                  controller: _c,
                  focusNode: _f,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.number,
                  maxLength: widget.length,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  style: const TextStyle(color: Color(0x00000000), height: 0.01),
                  cursorColor: const Color(0x00000000),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          if (isError) ...[
            const SizedBox(height: 8),
            Text(
              widget.error!,
              textAlign: TextAlign.center,
              style:
                  DilettaType.labelSm.copyWith(color: DilettaTheme.schemeOf(context).error),
            ),
          ],
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.char, required this.focused, required this.error});
  final String char;
  final bool focused;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final borderColor = error
        ? s.palette.error04
        : focused
            ? s.primary
            : char.isNotEmpty
                ? s.fg
                : s.palette.neutral07;
    return AnimatedContainer(
      duration: DilettaMotion.micro,
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: s.surface,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: DilettaRadius.all8,
      ),
      child: Text(
        char,
        style: DilettaType.numeric.copyWith(
          color: error ? s.palette.error04 : s.fg,
        ),
      ),
    );
  }
}
