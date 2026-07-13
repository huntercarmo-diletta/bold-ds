import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Conta BOLD — CopyButton (átomo). Botão de copiar com feedback IN-PLACE: ao
/// tocar, copia [text] pro clipboard e o ícone vira um check verde com um
/// micro-rótulo ("Copiado") logo abaixo; ambos somem juntos após ~2s. Feedback
/// perto da ação (melhor que toast distante). Reutilizável em conta, chaves
/// PIX, códigos, etc.
///
/// **Composição** — BoldIcon (átomo) + tokens ([BoldColors], [BoldType]).
///
/// ```dart
/// BoldCopyButton(text: user.conta, semanticLabel: 'Copiar conta', label: 'Conta copiada');
/// ```
class BoldCopyButton extends StatefulWidget {
  const BoldCopyButton({
    super.key,
    required this.text,
    required this.semanticLabel,
    this.label = 'Copiado',
    this.onCopied,
  });

  /// Texto copiado pro clipboard.
  final String text;
  final String semanticLabel;

  /// Micro-rótulo mostrado abaixo do check.
  final String label;
  final VoidCallback? onCopied;

  @override
  State<BoldCopyButton> createState() => _BoldCopyButtonState();
}

class _BoldCopyButtonState extends State<BoldCopyButton> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.text));
    HapticFeedback.selectionClick();
    widget.onCopied?.call();
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _copy,
        // Stack sem clip: o rótulo transborda pra baixo sem empurrar o layout.
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
              child: _copied
                  ? Icon(Icons.check_rounded,
                      key: const ValueKey('check'), size: 20, color: c.success)
                  : BoldIcon('copy',
                      key: const ValueKey('copy'), size: 18, color: c.textSecondary),
            ),
            Positioned(
              top: 34,
              left: -28,
              right: -28,
              child: AnimatedOpacity(
                opacity: _copied ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Center(
                  child: Text(widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: BoldType.labelSm.copyWith(color: c.success)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
