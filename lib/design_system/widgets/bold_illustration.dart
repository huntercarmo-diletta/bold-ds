import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Conta BOLD — Illustration (átomo). Wrapper que renderiza uma ilustração
/// multicolor do kit num tamanho canônico.
///
/// Diferente do [BoldSpotIcon]/[BoldIcon] (glyph mono recolorido via
/// ColorFilter), a ilustração é **multicor por design** (figura + cena) —
/// então NÃO recolorimos, só escalamos. Serve heros, empty states e onboarding.
///
/// Passe um [name] do registro abaixo ou um [asset] cru (caminho do bundle).
/// Tamanhos canônicos 100 / 200 / 300 / 400 (aceita qualquer double).
///
/// ```dart
/// BoldIllustration('city', size: 300);
/// BoldIllustration.asset('lib/design_system/assets/quantum-seal.png', size: 160);
/// ```
class BoldIllustration extends StatelessWidget {
  const BoldIllustration(this.name, {super.key, this.size = 300})
      : asset = null;

  const BoldIllustration.asset(this.asset, {super.key, this.size = 300})
      : name = null;

  final String? name;
  final String? asset;
  final double size;

  static const String _base = 'lib/design_system/assets';

  /// Registro nome → caminho (multicolor). Some crescer conforme o kit.
  /// Imagens de fundo (city*) vivem em `assets/images/` (padrão do app); o resto
  /// (selos/logo) fica nos assets do DS.
  static const Map<String, String> registry = {
    'city': 'assets/images/city-cyberpunk.webp',
    'city-fresh': 'assets/images/city-skyline-fresh.png',
    'quantum-seal': '$_base/quantum-seal.png',
    'quantum-seal-failed': '$_base/quantum-seal-failed.png',
    'logo': '$_base/bold-logo.webp',
  };

  @override
  Widget build(BuildContext context) {
    final path = asset ?? registry[name] ?? '$_base/$name';
    final w = SizedBox(
      width: size,
      height: size,
      child: path.endsWith('.svg')
          ? SvgPicture.asset(path, width: size, height: size, fit: BoxFit.contain)
          : Image.asset(path, width: size, height: size, fit: BoxFit.contain),
    );
    return Semantics(label: name ?? 'ilustração', image: true, child: w);
  }
}
