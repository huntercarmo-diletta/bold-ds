import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_glass.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — GlassAvatar (átomo). Disco de vidro (fill + stroke + blur do
/// token [BoldGlass]) com a inicial em `textPrimary` — ou a foto real quando
/// [image] é passado. É o avatar canônico do usuário (home e perfil usam o
/// mesmo). Acessórios de canto (mini-avatar, botão de câmera) ficam por conta
/// do caller, sobrepostos num Stack.
///
/// **Composição** — só tokens ([BoldGlass], [BoldColors], [BoldType]).
///
/// ```dart
/// BoldGlassAvatar(initial: 'A', size: 40);
/// BoldGlassAvatar(initial: 'RC', size: 64, image: MemoryImage(bytes));
/// ```
class BoldGlassAvatar extends StatelessWidget {
  const BoldGlassAvatar({
    super.key,
    required this.initial,
    this.size = 40,
    this.image,
    this.fontSize,
  });

  /// Inicial(is) exibida(s) quando não há foto (1–2 caracteres).
  final String initial;
  final double size;

  /// Foto real do usuário (cobre o disco). Quando null, mostra [initial].
  final ImageProvider? image;

  /// Override do tamanho da inicial (default ≈ 36% do disco).
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return ClipOval(
      child: BackdropFilter(
        filter: BoldGlass.blurFilter,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: BoldGlass.fill(c),
            shape: BoxShape.circle,
            border: Border.all(
                color: BoldGlass.border(c), width: BoldGlass.borderWidth),
            image: image == null
                ? null
                : DecorationImage(image: image!, fit: BoxFit.cover),
          ),
          child: image != null
              ? null
              : Text(initial,
                  style: BoldType.title.copyWith(
                      fontSize: fontSize ?? size * 0.36, color: c.textPrimary)),
        ),
      ),
    );
  }
}
