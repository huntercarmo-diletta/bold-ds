import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_gradients.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — AvatarStack (molécula). Mini-avatares de iniciais empilhados
/// com overlap (favoritos, participantes). Gradiente da marca + anel branco.
///
/// **Composição** — círculos com tokens (gradiente, tipografia).
///
/// ```dart
/// BoldAvatarStack(initials: ['CM', 'BL', 'RS']);
/// ```
class BoldAvatarStack extends StatelessWidget {
  const BoldAvatarStack({
    super.key,
    required this.initials,
    this.size = 32,
    this.overlap = 10,
    this.bordered = true,
  });

  /// Iniciais de cada avatar, na ordem de empilhamento.
  final List<String> initials;
  final double size;

  /// Quanto cada avatar invade o anterior.
  final double overlap;

  /// Anel branco em volta de cada avatar (spec: banner NÃO tem).
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final step = size - overlap;
    return SizedBox(
      width: initials.isEmpty ? 0 : step * (initials.length - 1) + size,
      height: size,
      child: Stack(children: [
        for (var i = 0; i < initials.length; i++)
          Positioned(
            left: i * step,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: BoldGradients.brand,
                shape: BoxShape.circle,
                border: bordered
                    ? Border.all(color: BoldColors.white, width: 2)
                    : null,
              ),
              child: Text(initials[i],
                  style: BoldType.bodySmall.copyWith(
                      fontSize: size * 0.30,
                      fontWeight: FontWeight.w700,
                      color: BoldColors.onGradient)),
            ),
          ),
      ]),
    );
  }
}
