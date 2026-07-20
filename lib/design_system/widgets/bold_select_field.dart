import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon.dart';

/// Conta BOLD — Select field (átomo). Campo bordado tocável com label acima,
/// valor (ou placeholder) e chevron — abre um picker/sheet no [onTap]. Espelha
/// o visual do [BoldTextField], mas para seleção (país, tipo, opção…).
///
/// ```dart
/// BoldSelectField(
///   label: 'País',
///   value: pais,                 // null → mostra o placeholder
///   placeholder: 'Selecionar',
///   onTap: _abrirPicker,
/// );
/// ```
class BoldSelectField extends StatelessWidget {
  const BoldSelectField({
    super.key,
    this.label,
    this.value,
    this.placeholder,
    required this.onTap,
    this.enabled = true,
  });

  final String? label;

  /// Valor selecionado. `null` → exibe [placeholder] em tom "muted".
  final String? value;
  final String? placeholder;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 7),
            child: Text(label!,
                style: BoldType.bodySmall.copyWith(
                    color: c.textSecondary, fontWeight: FontWeight.w600)),
          ),
        Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Material(
            color: c.isDark ? c.field : BoldColors.white,
            borderRadius: BoldRadius.fieldR,
            child: InkWell(
              borderRadius: BoldRadius.fieldR,
              onTap: enabled ? onTap : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BoldRadius.fieldR,
                  // Selecionado (com valor) = stroke rosa, igual ao input.
                  border: Border.all(
                      color: (enabled && hasValue)
                          ? BoldColors.primary
                          : (c.isDark ? c.border : BoldColors.neutral08),
                      width: (enabled && hasValue) ? 1.5 : 1),
                ),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      hasValue ? value! : (placeholder ?? ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BoldType.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: hasValue ? c.textPrimary : c.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BoldIcon('chevron-down', size: 18, color: c.textMuted),
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
