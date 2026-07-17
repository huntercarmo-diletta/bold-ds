import 'package:flutter/widgets.dart';
import 'bold_app_bar.dart' show BoldAvatar;

/// Conta BOLD — GlassAvatar. **Alias** do [BoldAvatar] unificado (que já é vidro
/// por default). Mantido pros call-sites existentes; em código novo prefira
/// `BoldAvatar(initials: ..., glass: true)`.
class BoldGlassAvatar extends StatelessWidget {
  const BoldGlassAvatar({
    super.key,
    required this.initial,
    this.size = 40,
    this.image,
    this.fontSize,
  });

  final String initial;
  final double size;
  final ImageProvider? image;
  final double? fontSize;

  @override
  Widget build(BuildContext context) => BoldAvatar(
        initials: initial,
        size: size,
        image: image,
        fontSize: fontSize,
        // glass já é o default do BoldAvatar.
      );
}
