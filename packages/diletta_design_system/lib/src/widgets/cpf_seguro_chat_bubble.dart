import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_chat_tokens.dart';

/// Lado da fala.
enum DilettaChatFrom { bot, user }

/// Tom da bolha do bot. `neutral` = cinza padrão; `alert` = aviso (warning) pra
/// mensagens de erro/atenção do bot.
enum DilettaChatBubbleTone { neutral, alert }

/// CPF SEGURO — ChatBubble.
///
/// - Bot: cinza neutral-09, anchored bottom-left (canto 4 chato).
/// - User: azul primary-04, anchored bottom-right.
/// Max width 85% (ou 90% com [wide=true]). [tone]=alert pinta o bot de warning.
class DilettaChatBubble extends StatelessWidget {
  const DilettaChatBubble({
    super.key,
    required this.from,
    required this.child,
    this.editable = false,
    this.onEdit,
    this.wide = false,
    this.tone = DilettaChatBubbleTone.neutral,
  });

  final DilettaChatFrom from;
  final Widget child;

  /// Mostra link "Alterar" abaixo (só quando [from]=user).
  final bool editable;
  final VoidCallback? onEdit;

  final bool wide;

  /// Tom do bot (neutral/alert). Ignorado quando [from]=user.
  final DilettaChatBubbleTone tone;

  BorderRadius _radius() {
    const r = DilettaChatTokens.radius;
    const a = DilettaChatTokens.anchor;
    return from == DilettaChatFrom.bot
        ? const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomRight: Radius.circular(r),
            bottomLeft: Radius.circular(a),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomRight: Radius.circular(a),
            bottomLeft: Radius.circular(r),
          );
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final isBot = from == DilettaChatFrom.bot;
    final alert = isBot && tone == DilettaChatBubbleTone.alert;
    final bubbleColor = alert
        ? s.palette.warning07
        : (isBot ? s.surfaceMuted : s.primary);
    final textColor = alert
        ? s.palette.warning02
        : (isBot ? s.textSecondary : s.palette.white);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Figma 6:4343: bubble hug-content, wmax 270 (bot E user). `wide=true`
        // solta o teto (CriteriaBubble multi-item). Clampa se a tela for < 270.
        final maxW = wide
            ? constraints.maxWidth
            : (constraints.maxWidth < DilettaChatTokens.maxWidth
                ? constraints.maxWidth
                : DilettaChatTokens.maxWidth);
        return Align(
          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Column(
            crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: _radius(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DilettaChatTokens.px,
                      vertical: DilettaChatTokens.py,
                    ),
                    child: DefaultTextStyle(
                      style: DilettaType.chatBody.copyWith(color: textColor),
                      child: child,
                    ),
                  ),
                ),
              ),
              if (editable && from == DilettaChatFrom.user) ...[
                const SizedBox(height: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: DilettaTappable(
                    onTap: onEdit,
                    child: Text(
                      'Alterar',
                      style: DilettaType.label.copyWith(
                        color: s.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
