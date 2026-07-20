import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/bold_colors.dart';

/// Conta BOLD wordmark — the official "CONTA / BOLD" lockup (the "O" in BOLD
/// carries the brand gradient). Single source for the logo across the app.
///
/// Por padrão segue o tema: superfície escura → wordmark branco; superfície
/// clara → wordmark preto (o "O" mantém o gradiente nas duas). Passe [onDark]
/// só quando a superfície contradiz o tema (ex.: card branco num app dark).
///
/// ```dart
/// const BoldLogo(width: 200);                // segue o tema
/// const BoldLogo(width: 160, onDark: false); // força preto (superfície clara)
/// ```
class BoldLogo extends StatelessWidget {
  const BoldLogo({super.key, this.width = 200, this.onDark});

  /// Rendered width; height follows the wordmark's aspect ratio.
  final double width;

  /// `true` → white wordmark; `false` → black wordmark; `null` → segue o tema
  /// ([BoldColors.of].isDark).
  final bool? onDark;

  static const String _light =
      'lib/design_system/assets/bold-wordmark-light.svg';
  static const String _brand =
      'lib/design_system/assets/bold-wordmark-brand.svg';

  @override
  Widget build(BuildContext context) {
    final dark = onDark ?? BoldColors.of(context).isDark;
    return SvgPicture.asset(
      dark ? _light : _brand,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
