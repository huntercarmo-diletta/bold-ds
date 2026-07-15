import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import 'bold_button.dart';
import 'bold_keypad.dart';
import 'bold_sheet.dart';

/// Conta BOLD — PasswordSheet (organismo). Evolução: empacota as peças soltas
/// (`BoldPinDots` + `BoldKeypad` + link + CTA) num fluxo pronto de confirmação
/// por senha/PIN, ancorado num [BoldSheet]. Coleta [length] dígitos; o pai
/// valida no [onSubmit].
///
/// ```dart
/// final pin = await BoldPasswordSheet.show(context, onForgot: () {...});
/// if (pin != null) validar(pin);
/// ```
class BoldPasswordSheet extends StatefulWidget {
  const BoldPasswordSheet({
    super.key,
    this.length = 6,
    this.subtitle,
    this.confirmLabel = 'Continuar',
    this.onForgot,
    required this.onSubmit,
  });

  final int length;
  final String? subtitle;
  final String confirmLabel;
  final VoidCallback? onForgot;
  final ValueChanged<String> onSubmit;

  /// Abre o sheet de senha e resolve com o PIN digitado (ou null se fechado).
  static Future<String?> show(
    BuildContext context, {
    String title = 'Digite sua senha',
    int length = 6,
    String? subtitle,
    VoidCallback? onForgot,
  }) {
    return BoldSheet.show<String>(
      context,
      title: title,
      builder: (ctx) => BoldPasswordSheet(
        length: length,
        subtitle: subtitle,
        onForgot: onForgot,
        onSubmit: (pin) => Navigator.of(ctx).pop(pin),
      ),
    );
  }

  @override
  State<BoldPasswordSheet> createState() => _BoldPasswordSheetState();
}

class _BoldPasswordSheetState extends State<BoldPasswordSheet> {
  String _value = '';

  void _key(String d) {
    if (_value.length >= widget.length) return;
    setState(() => _value += d);
  }

  void _del() {
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final complete = _value.length == widget.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.subtitle != null) ...[
          Text(widget.subtitle!,
              textAlign: TextAlign.center,
              style: BoldType.bodySmall.copyWith(color: c.textSecondary)),
          const SizedBox(height: 20),
        ],
        BoldPinDots(length: widget.length, filled: _value.length),
        const SizedBox(height: 16),
        if (widget.onForgot != null)
          BoldButton('Esqueci minha senha',
              variant: BoldButtonVariant.text,
              expand: false,
              onPressed: widget.onForgot),
        const SizedBox(height: 8),
        BoldButton(
          widget.confirmLabel,
          onPressed: complete ? () => widget.onSubmit(_value) : null,
        ),
        const SizedBox(height: 16),
        BoldKeypad(onKey: _key, onDelete: _del),
      ],
    );
  }
}
