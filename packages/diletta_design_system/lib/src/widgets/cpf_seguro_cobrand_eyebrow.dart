import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_logo.dart';

/// CPF SEGURO — CobrandEyebrow.
///
/// Selo "{PARCEIRO} + logo CPF SEGURO" no topo de telas SDK. Tipografia
/// mais compacta que [DilettaCobrandMark] pra não competir com top bar. Usado
/// em T2 Welcome (alto) e T3 telas de chat (lembrete sutil).
class DilettaCobrandEyebrow extends StatelessWidget {
  const DilettaCobrandEyebrow({
    super.key,
    required this.partnerName,
    this.partnerColor,
  });

  final String partnerName;
  /// Cor do PARCEIRO. `null` = o papel `partner` do tema.

  ///

  /// Era um default `const` apontando pra classe estática, e por isso um DS-filho

  /// recebia a laranja do parceiro do CPF SEGURO. Default const não consegue ler o

  /// tema, por construção — então o default virou `null` e a resolução foi pro build.

  final Color? partnerColor;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DilettaSpacing.s2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            partnerName,
            style: DilettaType.label.copyWith(
              color: partnerColor ?? s.partner,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Text('+', style: DilettaType.label.copyWith(color: s.textPlaceholder)),
          const SizedBox(width: 8),
          DilettaLogo(variant: DilettaLogoVariant.full, size: 44, color: s.primary),
        ],
      ),
    );
  }
}
