import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — SectionHeader.
///
/// Cabeçalho de seção da home: label esquerda (label-md · neutral-03) +
/// slot opcional à direita (típico: [DilettaSeeAllLink]).
///
/// SEM padding embutido — margem lateral é responsabilidade da tela
/// (padding do scroll), não da molécula.
///
/// ```dart
/// DilettaSectionHeader(label: 'ACESSO RÁPIDO', trailing: DilettaSeeAllLink(onPressed: openAll)),
/// ```
class DilettaSectionHeader extends StatelessWidget {
  const DilettaSectionHeader({
    super.key,
    required this.label,
    this.trailing,
  });

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaSectionHeader',
      props: {'label': "'\$label'", if (trailing != null) 'trailing': 'widget'},
      tokens: const ['label: label textTertiary (neutral-03)'],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flexible + ellipsis: label longo ('NÍVEL 2 · SELFIE (OPCIONAL)')
          // estourava o Row por meio pixel e derrubava a tela inteira. Fit é
          // responsabilidade do componente, não da tela — mesmo conserto já
          // feito no Button e no CobrandMark.
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DilettaType.label.copyWith(color: s.textTertiary)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
