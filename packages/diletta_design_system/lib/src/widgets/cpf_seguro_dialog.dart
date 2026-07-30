import 'package:flutter/material.dart' show showDialog;
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_box.dart';
import 'cpf_seguro_frame.dart';
import 'cpf_seguro_text.dart';

/// CPF SEGURO — Dialog (modal central de marca).
///
/// Encapsula o `AlertDialog`/`Dialog` do Material: card central com raio,
/// sombra, tipografia e espaçamento por **token** (compõe [DilettaBox],
/// [DilettaText], [DilettaFrame]). Só existiam sheets no DS; este é o
/// diálogo central. [actions] recebe os botões (ex.: `DilettaButton`).
class DilettaDialog extends StatelessWidget {
  const DilettaDialog({
    super.key,
    required this.title,
    this.message,
    this.actions = const [],
  });

  final String title;
  final String? message;
  final List<Widget> actions;

  /// Abre o diálogo centralizado (barrier padrão do Material).
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? message,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => DilettaDialog(
          title: title, message: message, actions: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final msg = message?.trim();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DilettaSpacing.s6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: DilettaBox(
            color: s.surface,
            radius: DilettaRadius.all24,
            boxShadow: DilettaElevation.medium,
            padding: const EdgeInsets.all(DilettaSpacing.s6),
            child: DilettaFrame.column(
              mainAxisSize: MainAxisSize.min,
              gap: DilettaSpacing.s3,
              children: [
                DilettaText(title, style: DilettaType.titleMd),
                if (msg != null && msg.isNotEmpty)
                  DilettaText(msg,
                      style: DilettaType.bodyMd
                          .copyWith(color: s.textSecondary)),
                if (actions.isNotEmpty)
                  DilettaFrame.column(
                    mainAxisSize: MainAxisSize.min,
                    gap: DilettaSpacing.s2,
                    children: actions,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
