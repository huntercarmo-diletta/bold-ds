import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import '../theme/bold_metrics.dart';
import 'bold_icon_button.dart';

/// Conta BOLD — BottomSheet (organismo). O CONTAINER de sheet que faltava:
/// o [BoldTopBar.sheet] só dava o cabeçalho e o [BoldDialog] é modal central.
///
/// Painel ancorado no rodapé, cantos superiores arredondados, com grip iOS +
/// título/fechar opcionais + conteúdo. Sobe do rodapé sobre um scrim escuro.
///
/// Use direto como widget (dentro de um Stack/overlay próprio) ou via o helper
/// imperativo [BoldSheet.show], que embrulha `showModalBottomSheet` com a
/// aparência do DS e devolve o valor do `Navigator.pop`.
///
/// ```dart
/// final ok = await BoldSheet.show<bool>(
///   context,
///   title: 'Escolha uma conta',
///   builder: (ctx) => Column(children: [...]),
/// );
/// ```
class BoldSheet extends StatelessWidget {
  const BoldSheet({
    super.key,
    this.title,
    this.onClose,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 20),
  });

  final String? title;
  final VoidCallback? onClose;
  final Widget child;
  final EdgeInsets padding;

  /// Abre o sheet via `showModalBottomSheet` com o estilo do DS.
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required WidgetBuilder builder,
    bool dismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: BoldColors.blackAlpha40,
      isDismissible: dismissible,
      builder: (ctx) => BoldSheet(
        title: title,
        onClose: dismissible ? () => Navigator.of(ctx).maybePop() : null,
        child: builder(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(BoldRadius.sheet)),
        border: Border.all(color: c.border, width: 1),
      ),
      // Empurra o conteúdo acima do teclado quando aberto.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grip iOS.
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            decoration: BoxDecoration(
              color: c.textMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title!,
                        style: BoldType.headlineSm
                            .copyWith(color: c.textPrimary)),
                  ),
                  if (onClose != null)
                    BoldIconButton(
                      icon: 'close',
                      semanticLabel: 'Fechar',
                      type: BoldIconButtonType.tertiary,
                      size: BoldIconButtonSize.sm,
                      onPressed: onClose,
                    ),
                ],
              ),
            ),
          Flexible(child: Padding(padding: padding, child: child)),
        ],
      ),
    );
  }
}
