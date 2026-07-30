import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// CPF SEGURO — FaceIdCard (molécula).
///
/// Card inline de autenticação biométrica do fluxo Pagar: quadrado
/// neutral-10 radius 16 com glifo Face ID + label. Diferente do
/// `DilettaBiometriaOverlay` (que é overlay em cima da tela) — este
/// senta no corpo da tela enquanto o Face ID roda. Figma 1200:46256.
///
/// **Composição** — Icon (átomo) + tokens.
class DilettaFaceIdCard extends StatelessWidget {
  const DilettaFaceIdCard({
    super.key,
    this.label = 'Face ID',
    this.size = 156,
  });

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaFaceIdCard',
      props: {'label': "'$label'", 'size': '${size.toInt()}'},
      tokens: const ['bg neutral-10 · radius 16 · glifo face-id-light 56 neutral-02'],
      child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: DilettaRadius.all16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DilettaIconAccessory(icon: DilettaIcons.faceIdLight, padding: 0, size: 56, color: s.textSecondary),
          const SizedBox(height: 12),
          Text(
            label,
            style: DilettaType.heading.copyWith(
              color: s.isDark ? s.fg : s.palette.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
