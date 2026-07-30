import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_logo.dart';

/// CPF SEGURO — CobrandMark.
///
/// Selo passivo de cobranding: "{PARCEIRO} + logo CPF SEGURO". Usar em
/// contextos SDK dentro do app do parceiro pra reforçar branding CPF SEGURO
/// sem competir com o título.
///
/// NÃO usar em "Login protegido por [logo]" — esse é CobrandedBadge.
class DilettaCobrandMark extends StatelessWidget {
  const DilettaCobrandMark({
    super.key,
    this.partnerName = 'BANCO AURORA',
    this.partnerColor,
    this.logoSize = 44,
    this.textSize = 13,
    this.center = true,
  });

  final String partnerName;
  /// Cor do PARCEIRO. `null` = o papel `partner` do tema.

  ///

  /// Era um default `const` apontando pra classe estática, e por isso um DS-filho

  /// recebia a laranja do parceiro do CPF SEGURO. Default const não consegue ler o

  /// tema, por construção — então o default virou `null` e a resolução foi pro build.

  final Color? partnerColor;
  final double logoSize;
  final double textSize;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Row(
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flexible + ellipsis: em contexto estreito (ex.: label do stepper no
        // frame 393) o nome do parceiro encolhe em vez de estourar o Row.
        Flexible(
          child: Text(
            partnerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: partnerColor ?? s.partner,
              fontSize: textSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '+',
          style: TextStyle(
            color: s.textPlaceholder,
            fontSize: textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        DilettaLogo(variant: DilettaLogoVariant.full, size: logoSize, color: s.primary),
      ],
    );
  }
}
