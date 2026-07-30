import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import '../theme/cpf_seguro_theme.dart';

/// CPF SEGURO — StatusBannerCTA.
///
/// CTA circular 40×40 bg branco + ícone primary-04 — helper pro
/// `rightAccessory` do [DilettaStatusBanner] (chama a ação principal).
///
/// [rotate] em graus (útil pra reusar arrow-left-light com rotate 180 =
/// arrow-right visual, mesmo padrão do React banner).
class DilettaStatusBannerCTA extends StatelessWidget {
  const DilettaStatusBannerCTA({
    super.key,
    this.onPressed,
    this.icon = 'arrow-left-light',
    this.rotate = 180,
  });

  final VoidCallback? onPressed;
  final String icon;
  final double rotate;

  @override
  Widget build(BuildContext context) {
    Widget glyph = DilettaIconAccessory(icon: icon, padding: 0, size: 18, color: DilettaTheme.schemeOf(context).primary);
    if (rotate != 0) {
      glyph = Transform.rotate(angle: rotate * 3.1415926535 / 180, child: glyph);
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DilettaTappable(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: DilettaAbsoluteColors.white,
            shape: BoxShape.circle,
          ),
          child: glyph,
        ),
      ),
    );
  }
}
