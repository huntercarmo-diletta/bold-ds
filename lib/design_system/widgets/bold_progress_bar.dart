import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — ProgressBar (molécula). Trilho h5 + preenchimento + caption
/// opcional. [onGlass] = skin sobre superfície escura/foto (trilho branco
/// translúcido); padrão = trilho neutro + fill primary.
///
/// Portado do DS CPF Seguro (adaptado aos tokens Bold*).
///
/// ```dart
/// BoldProgressBar(value: 0.4, caption: '2 de 5 confirmados');
/// BoldProgressBar(value: 0.4, onGlass: true);
/// ```
class BoldProgressBar extends StatelessWidget {
  const BoldProgressBar({
    super.key,
    required this.value,
    this.caption,
    this.onGlass = false,
  });

  /// Progresso 0..1 (clampado).
  final double value;
  final String? caption;
  final bool onGlass;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final pct = value.clamp(0.0, 1.0);

    final track = BoxDecoration(
      color: onGlass ? BoldColors.whiteAlpha24 : c.border,
      border: onGlass
          ? Border.all(color: BoldColors.whiteAlpha38, width: 0.5)
          : null,
      borderRadius: BorderRadius.circular(8),
    );
    final fillColor = onGlass ? BoldColors.white : c.primary;
    final captionColor = onGlass ? BoldColors.whiteAlpha80 : c.textMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 5,
          child: Stack(children: [
            Positioned.fill(child: DecoratedBox(decoration: track)),
            FractionallySizedBox(
              widthFactor: pct,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ]),
        ),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BoldType.labelSm.copyWith(color: captionColor)),
        ],
      ],
    );
  }
}
