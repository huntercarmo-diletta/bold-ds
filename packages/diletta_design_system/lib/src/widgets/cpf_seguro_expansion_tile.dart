import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_divider.dart';
import 'cpf_seguro_frame.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_tappable.dart';
import 'cpf_seguro_text.dart';

/// CPF SEGURO — ExpansionTile (linha expansível).
///
/// Encapsula o `ExpansionTile` do Material: header (título + chevron que gira)
/// tocável e corpo que expande/colapsa animado — chevron, divisor, animação e
/// padding por **token**. Compõe [DilettaTappable], [DilettaFrame],
/// [DilettaText], [DilettaDivider].
class DilettaExpansionTile extends StatefulWidget {
  const DilettaExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.initiallyExpanded = false,
  });

  final String title;
  final List<Widget> children;
  final Widget? leading;
  final bool initiallyExpanded;

  @override
  State<DilettaExpansionTile> createState() => _CpfSeguroExpansionTileState();
}

class _CpfSeguroExpansionTileState extends State<DilettaExpansionTile> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);

    final header = DilettaTappable(
      onTap: () => setState(() => _expanded = !_expanded),
      child: DilettaFrame.row(
        gap: DilettaSpacing.s3,
        padding: const EdgeInsets.symmetric(
          horizontal: DilettaSpacing.s4,
          vertical: DilettaSpacing.s3,
        ),
        children: [
          if (widget.leading != null) widget.leading!,
          Expanded(
            child: DilettaText(widget.title, style: DilettaType.bodyMd),
          ),
          AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: DilettaMotion.micro,
            child: DilettaIconAccessory(
              icon: DilettaIcons.angleDownLight,
              padding: 0,
              size: 20,
              color: s.textSecondary,
            ),
          ),
        ],
      ),
    );

    return DilettaFrame.column(
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: DilettaFrame.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DilettaDivider(),
              ...widget.children,
            ],
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: DilettaMotion.micro,
        ),
      ],
    );
  }
}
