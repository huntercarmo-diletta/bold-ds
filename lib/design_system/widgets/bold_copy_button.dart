import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/bold_colors.dart';
import 'bold_icon.dart';
import 'bold_status_tag.dart';

/// Conta BOLD — CopyButton (átomo). Botão de copiar com feedback IN-PLACE: ao
/// tocar, copia [text] pro clipboard e o ícone de copiar (pequeno) vira um
/// [BoldStatusTag] success com check-circle + [label] ("Conta copiada"); reverte
/// após ~2s. Feedback perto da ação (melhor que toast distante).
///
/// **Composição** — BoldIcon + BoldStatusTag (átomos) + tokens.
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
      // Stack sem clip: o ícone pequeno define o footprint; o status tag do
      // feedback é FORA do fluxo (Positioned), flutuando por cima do conteúdo à
      // esquerda — não empurra/reflui nenhum componente vizinho.
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _copy,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: BoldIcon('copy', size: 13, color: c.textSecondary),
            ),
          ),
          // top-only Positioned: left/right nulos → alinha no eixo horizontal
          // pelo alignment do Stack (center), centralizando o tag sob o ícone.
          Positioned(
            top: 22,
            child: IgnorePointer(
              child: AnimatedScale(
                scale: _copied ? 1 : 0.85,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _copied ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: BoldStatusTag(
                    label: widget.label,
                    tone: BoldStatusTone.success,
                    icon: 'circle-check-solid',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
