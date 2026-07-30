import 'package:flutter/widgets.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import '../theme/cpf_seguro_theme.dart';

/// CPF SEGURO — StatusBannerButton.
///
/// CTA pill full-width dentro do banner — "Ver detalhes", "Reenviar documento".
/// Bg branco, h 28, radius pill, label label-md primary-04 + arrow 12.
/// Usar via `button` do [DilettaStatusBanner].
class DilettaStatusBannerButton extends StatelessWidget {
  const DilettaStatusBannerButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DilettaTappable(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s3),
          decoration: const BoxDecoration(
            color: DilettaAbsoluteColors.white,
            borderRadius: DilettaRadius.pillAll,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: DilettaType.label.copyWith(color: DilettaTheme.schemeOf(context).primary),
              ),
              const SizedBox(width: 8),
              DilettaIconAccessory(
                icon: DilettaIcons.arrowRightLongLight,
                padding: 0,
                size: 12,
                color: DilettaTheme.schemeOf(context).primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
