import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_card.dart';
import 'bold_icon.dart';

/// Conta BOLD — Accordion (molécula). Card tocável que abre/fecha revelando o
/// [child]; título em negrito + chevron que gira (180°) e conteúdo com
/// cross-fade. Começa FECHADO por default. Base do FAQ "Saiba mais" do Pix
/// Automático (Figma DPS 2025).
///
/// **Composição** — BoldCard + BoldIcon + tokens.
///
/// ```dart
/// BoldAccordion(
///   title: 'O que é o Pix Automático?',
///   child: Text('...', style: BoldType.bodySm),
/// );
/// ```
class BoldAccordion extends StatefulWidget {
  const BoldAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
  });

  final String title;

  /// Conteúdo revelado ao abrir (geralmente um [Text], mas aceita qualquer
  /// widget).
  final Widget child;

  /// Se começa aberto. Default `false` (fechado no primeiro acesso).
  final bool initiallyOpen;

  @override
  State<BoldAccordion> createState() => _BoldAccordionState();
}

class _BoldAccordionState extends State<BoldAccordion> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return BoldCard(
      padding: const EdgeInsets.all(BoldSpace.x4),
      radius: 16,
      onTap: () => setState(() => _open = !_open),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(widget.title,
                    style: BoldType.body.copyWith(
                        color: c.textPrimary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: BoldSpace.x3),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: BoldIcon('chevron-down-light',
                      size: 14, color: c.textSecondary),
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: BoldSpace.x3),
              child: widget.child,
            ),
            crossFadeState:
                _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
