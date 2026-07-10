import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_button.dart';

/// Conta BOLD — Critical confirmation dialog.
///
/// Centered icon in a tinted circle, title, description, and a two-button row
/// (cancel outline + a filled action). Defaults to the destructive red action.
///
/// ```dart
/// final ok = await BoldDialog.confirm(
///   context,
///   icon: Icons.delete_outline,
///   title: 'Excluir esta chave PIX?',
///   message: 'Você precisará cadastrá-la de novo para receber por ela.',
///   confirmLabel: 'Excluir',
/// );
/// ```
class BoldDialog {
  BoldDialog._();

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    IconData icon = Icons.error_outline,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    Color accent = BoldColors.dangerBright,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => Dialog(
        backgroundColor: BoldColors.surfaceDeep,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BoldRadius.sheetR,
          side: BorderSide(color: BoldColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 27, color: accent),
              ),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: BoldType.title.copyWith(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(message,
                    textAlign: TextAlign.center,
                    style: BoldType.bodySmall.copyWith(
                        fontSize: 13.5, color: BoldColors.textSecondary)),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: BoldButton(
                      cancelLabel,
                      variant: BoldButtonVariant.secondary,
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _FilledActionButton(
                      label: confirmLabel,
                      color: accent,
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }
}

class _FilledActionButton extends StatelessWidget {
  const _FilledActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: BoldElevation.glow(color),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Center(
              child: Text(label,
                  style: BoldType.button.copyWith(fontSize: 14)),
            ),
          ),
        ),
      ),
    );
  }
}
