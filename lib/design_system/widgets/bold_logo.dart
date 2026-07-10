import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Conta BOLD wordmark — the official "CONTA / BOLD" lockup (the "O" in BOLD
/// carries the brand gradient). Single source for the logo across the app.
///
/// ```dart
/// const BoldLogo(width: 200);              // white, for dark surfaces
/// const BoldLogo(width: 160, onDark: false); // black, for light surfaces
/// ```
class BoldLogo extends StatelessWidget {
  const BoldLogo({super.key, this.width = 200, this.onDark = true});

  /// Rendered width; height follows the wordmark's aspect ratio.
  final double width;

  /// `true` → white wordmark (dark backgrounds); `false` → black wordmark.
  final bool onDark;

  static const String _light =
      'lib/design_system/assets/bold-wordmark-light.svg';
  static const String _brand =
      'lib/design_system/assets/bold-wordmark-brand.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      onDark ? _light : _brand,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
