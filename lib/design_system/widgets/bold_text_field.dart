import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';

/// Conta BOLD — Text field.
///
/// Pill-ish field (16 radius) with a label sitting ABOVE it (the system
/// standard — not a floating label). Focus lights a violet ring; errors switch
/// the ring and message to red.
///
/// Built on [TextFormField], so it works two ways:
///
/// 1. **Inside a `Form`** — pass a [validator]; `Form.of(context).validate()`
///    drives the error. Use this for the 16 form-based screens.
///    ```dart
///    BoldTextField(
///      label: 'Chave Pix',
///      controller: _key,
///      validator: (v) => (v == null || v.isEmpty) ? 'Informe a chave' : null,
///    );
///    ```
///
/// 2. **Controlled** — pass [errorText] yourself and validate on submit. Renders
///    a custom error row with a leading icon.
///    ```dart
///    BoldTextField(label: 'Valor', errorText: _overLimit ? 'Acima do limite' : null);
///    ```
///
/// Don't combine [validator] and [errorText] on the same field — pick one.
///
/// Masks (CPF/CNPJ/phone/agência-conta) go through [inputFormatters].
/// Multi-line fields (Pix message, charge description, dispute reason) set
/// [maxLines].
class BoldTextField extends StatelessWidget {
  const BoldTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.readOnly = false,
    this.enabled = true,
    this.mono = false,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  /// Corretor/sugestões do teclado. Desligar em campos técnicos (e-mail, chave).
  final bool autocorrect;
  final bool enableSuggestions;

  /// Trailing widget (e.g. a visibility toggle).
  final Widget? suffixIcon;

  /// Leading icon — typical for search fields.
  final IconData? prefixIcon;

  /// Controlled error message (manual / submit-time validation).
  final String? errorText;

  /// Form validator — return null when valid, an error string otherwise.
  final String? Function(String?)? validator;

  /// When to auto-run [validator] (defaults to onUserInteraction when a
  /// validator is supplied, otherwise disabled).
  final AutovalidateMode? autovalidateMode;

  final ValueChanged<String>? onChanged;

  /// Called when the user submits (keyboard action button).
  final ValueChanged<String>? onSubmitted;

  /// Called by `Form.save()`.
  final void Function(String?)? onSaved;

  final bool readOnly;

  /// Disable the field (greys it out, blocks input).
  final bool enabled;

  /// Render the value in JetBrains Mono (CPF, keys, codes).
  final bool mono;

  /// Input masks / restrictions — CPF, CNPJ, phone, agência/conta, etc.
  final List<TextInputFormatter>? inputFormatters;

  /// Hard character limit. The default counter is hidden to keep the pill clean.
  final int? maxLength;

  /// Max visible lines. Default 1; raise for multi-line fields (message,
  /// description, dispute reason). Pair with [minLines] for a taller box.
  final int maxLines;

  /// Min visible lines (multi-line fields). Null = grows from one line.
  final int? minLines;

  final TextCapitalization textCapitalization;

  /// Keyboard action button (next / done / search …).
  final TextInputAction? textInputAction;

  final bool autofocus;
  final FocusNode? focusNode;

  bool get _multiline => maxLines > 1 || (minLines != null && minLines! > 1);

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final hasControlledError = errorText != null && errorText!.isNotEmpty;
    // Custom error row is only used for controlled errors. Validator errors are
    // rendered by TextFormField itself (styled below) so Form.validate works.
    final showCustomErrorRow = hasControlledError && validator == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 7),
            child: Text(
              label!,
              style: BoldType.bodySmall.copyWith(
                color: c.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Opacity(
          opacity: enabled ? 1 : 0.55,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            keyboardType: keyboardType ??
                (_multiline ? TextInputType.multiline : null),
            obscureText: obscureText,
            autocorrect: autocorrect,
            enableSuggestions: enableSuggestions,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode ??
                (validator != null
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled),
            readOnly: readOnly,
            autofocus: autofocus,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            maxLines: obscureText ? 1 : maxLines,
            minLines: minLines,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            textAlignVertical:
                _multiline ? TextAlignVertical.top : TextAlignVertical.center,
            style: (mono ? BoldType.mono : BoldType.body).copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            cursorColor: BoldColors.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: BoldType.body.copyWith(color: c.textMuted),
              // Fill theme-aware: BRANCO no light (spec cpf-seguro, hairline
              // neutral-08) · campo ESCURO (c.field) no dark — senão o texto
              // (c.textPrimary = branco) some no fundo branco.
              filled: true,
              fillColor: c.isDark ? c.field : BoldColors.white,
              counterText: '', // hide the default maxLength counter
              alignLabelWithHint: _multiline,
              // Validator error styling (matches the controlled error row).
              errorStyle:
                  BoldType.bodySmall.copyWith(color: BoldColors.error04),
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, size: 20, color: c.textMuted),
              suffixIcon: suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BoldRadius.fieldR,
                borderSide: hasControlledError
                    ? const BorderSide(color: BoldColors.error04, width: 1.5)
                    : BorderSide(
                        color: c.isDark ? c.border : BoldColors.neutral08,
                        width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BoldRadius.fieldR,
                borderSide: BorderSide(
                  color: hasControlledError
                      ? BoldColors.error04
                      : BoldColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BoldRadius.fieldR,
                borderSide: BorderSide(color: BoldColors.error04, width: 1.5),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BoldRadius.fieldR,
                borderSide: BorderSide(color: BoldColors.error04, width: 1.5),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BoldRadius.fieldR,
                borderSide: BorderSide(color: BoldColors.neutral09, width: 1),
              ),
              border: const OutlineInputBorder(
                borderRadius: BoldRadius.fieldR,
                borderSide: BorderSide(color: BoldColors.neutral08, width: 1),
              ),
            ),
          ),
        ),
        if (showCustomErrorRow)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                const BoldIcon('circle-exclamation-light',
                    size: BoldIconSize.xs, color: BoldColors.error04),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    errorText!,
                    style: BoldType.bodySmall
                        .copyWith(color: BoldColors.error04),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
