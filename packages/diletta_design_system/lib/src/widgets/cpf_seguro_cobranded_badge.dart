import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — CobrandedBadge.
///
/// Selo discreto "Protegido por [logo CPF SEGURO]" pra usar dentro do app do
/// parceiro (SDK) indicando que o login é gerenciado pelo CPF SEGURO.
/// Cobranding sutil — destaca sem competir com a marca do parceiro.
///
/// Diferente de [DilettaCobrandMark] (chat), que é "{PARCEIRO} + logo" ATIVO —
/// este é passivo, uma nota de rodapé.
///
/// ```dart
/// DilettaCobrandedBadge(),                       // 'Protegido por [logo]'
/// DilettaCobrandedBadge(prefix: 'Login por'),
/// ```
class DilettaCobrandedBadge extends StatelessWidget {
  const DilettaCobrandedBadge({
    super.key,
    this.prefix = 'Protegido por',
  });

  final String prefix;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaCobrandedBadge',
      props: {'prefix': "'$prefix'"},
      tokens: const ['cobranding CPF SEGURO × parceiro'],
      child: Semantics(
      label: '$prefix CPF SEGURO',
      container: true,
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prefix, style: DilettaType.labelSm.copyWith(color: s.textMuted)),
          const SizedBox(width: 6),
          DilettaLogo(variant: DilettaLogoVariant.full, size: 40, color: s.primary),
        ],
      ),
    ),
    );
  }
}
