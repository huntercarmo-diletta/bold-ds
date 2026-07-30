import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;

/// CPF SEGURO — StatusBannerActionIcon.
///
/// Ícone 40×40 quadrado com bg semi-transparente branco — helper pro
/// `leftAccessory` do [DilettaStatusBanner] (ex: câmera, id-card, shield).
///
/// [bg]/[borderColor]/[iconColor] parametrizáveis pra variar o tom —
/// ex: amarelo secure na pausa ativa:
/// ```dart
/// DilettaStatusBannerActionIcon(
///   icon: DilettaIcons.lockLight,
///   bg: s.secure,
///   borderColor: s.secureSubtle.withValues(alpha: 0.38),
/// )
/// ```
class DilettaStatusBannerActionIcon extends StatelessWidget {
  const DilettaStatusBannerActionIcon({
    super.key,
    required this.icon,
    this.bg = DilettaAbsoluteColors.whiteAlpha24,
    this.borderColor = DilettaAbsoluteColors.whiteAlpha38,
    this.iconColor = DilettaAbsoluteColors.white,
  });

  final String icon;
  final Color bg;
  final Color borderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: DilettaRadius.all8,
      ),
      child: DilettaIconAccessory(icon: icon, padding: 0, size: 18, color: iconColor),
    );
  }
}
