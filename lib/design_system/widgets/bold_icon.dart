import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';

/// Conta BOLD — icon.
///
/// Renders a branded SVG glyph (FontAwesome set herdado do DS do CPF Seguro)
/// recolorido para [color] (default = cor de corpo do tema). O "accessory de
/// tamanho" do componente do Figma = o parâmetro [size].
///
/// Aceita um **nome semântico** (ver [alias]) ou o nome cru do arquivo (sem
/// `.svg`):
/// ```dart
/// BoldIcon('home');                       // → house-light.svg
/// BoldIcon('bell', size: 20, color: pink);
/// BoldIcon('gear-solid');                 // nome cru também funciona
/// ```
class BoldIcon extends StatelessWidget {
  const BoldIcon(this.name, {super.key, this.size = BoldIconSize.md, this.color});

  final String name;
  final double size;
  final Color? color;

  /// Pasta dos SVGs. Mutável pra quem integrar o DS por outro caminho.
  static String basePath = 'lib/design_system/assets/icons';

  /// Nome semântico → arquivo SVG real (kebab, pesos light/solid do FontAwesome).
  static const Map<String, String> alias = {
    // marca Pix (FontAwesome — mesma viewBox/margem dos outros, fica no padrão;
    // use 'pix' p/ chrome de ícone, BoldPixMark só p/ marca grande/hero)
    'pix': 'pix-light', 'pix-solid': 'pix-solid',
    // chrome / navegação
    'home': 'house-light', 'home-solid': 'house-solid',
    'pay': 'file-invoice-light', 'pay-solid': 'file-invoice-solid',
    'cards': 'credit-card-light', 'cards-solid': 'credit-card-solid',
    'bell': 'bell-light', 'gear': 'gear-light', 'edit': 'sliders-light',
    'close': 'xmark-light', 'add': 'plus-light',
    'chevron-right': 'angle-right-light', 'chevron-down': 'angle-down-light',
    'arrow-forward': 'arrow-right-long-light',
    'share': 'arrow-up-from-bracket-light',
    'copy': 'clone-light', 'qr': 'qrcode-light',
    // dinheiro / ações
    'eye': 'eye-light', 'eye-off': 'eye-slash-light-full',
    'send': 'paper-plane-light', 'transfer': 'arrow-right-arrow-left-light',
    'smartphone': 'mobile-light', 'barcode': 'barcode-light',
    // finanças / descobrir
    'trending-up': 'chart-line-light', 'invest': 'arrow-trend-up-light',
    'shield': 'shield-user-light-full', 'bank': 'landmark-light',
    'verified': 'circle-check-light',
    // perfil / segurança
    'fingerprint': 'fingerprint-light', 'lock': 'lock-light', 'key': 'key-light',
    'logout': 'arrow-right-from-bracket-light', 'help': 'circle-question-light',
    'language': 'globe', 'moon': 'moon-stars-light', 'sun': 'sun-light',
  };

  @override
  Widget build(BuildContext context) {
    final file = alias[name] ?? name;
    final col = color ?? BoldColors.of(context).textSecondary;
    // UnconstrainedBox guarantees the icon renders at EXACTLY [size], centered,
    // even inside a fixed-size box (e.g. a 40px chip) that would otherwise
    // stretch it with tight constraints. This keeps icon sizes consistent
    // regardless of their container.
    return UnconstrainedBox(
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset(
          '$basePath/$file.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(col, BlendMode.srcIn),
        ),
      ),
    );
  }
}
