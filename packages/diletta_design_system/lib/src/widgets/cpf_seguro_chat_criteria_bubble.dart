import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_criteria_list.dart';
import 'cpf_seguro_chat_tokens.dart';

/// CPF SEGURO — ChatCriteriaBubble.
///
/// Bubble wide (90%) do bot com uma [DilettaCriteriaList] (regras de senha,
/// validações). A lista de critérios foi extraída pro átomo standalone
/// [DilettaCriteriaList] — este bubble só dá a casca de chat.
class DilettaChatCriteriaBubble extends StatelessWidget {
  const DilettaChatCriteriaBubble({
    super.key,
    required this.items,
    this.title,
  });

  final List<DilettaCriteriaItem> items;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: s.surfaceMuted,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(DilettaChatTokens.radius),
                  topRight: Radius.circular(DilettaChatTokens.radius),
                  bottomRight: Radius.circular(DilettaChatTokens.radius),
                  bottomLeft: Radius.circular(DilettaChatTokens.anchor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DilettaChatTokens.px,
                  vertical: DilettaChatTokens.py,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(title!,
                          style: DilettaType.chatBody
                              .copyWith(color: s.textSecondary)),
                      const SizedBox(height: 12),
                    ],
                    DilettaCriteriaList(items: items),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
