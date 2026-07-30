import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Uma opção do RadioList.
class DilettaRadioOption {
  const DilettaRadioOption({required this.value, required this.label});
  final String value;
  final String label;
}

/// CPF SEGURO — RadioList.
///
/// Lista de radio buttons single-select, com título opcional. Selecionada
/// pinta o ring + preencher o dot com `primary-04`; texto vira `neutral-01`.
///
/// ```dart
/// DilettaRadioList(
///   title: 'Selecione o motivo',
///   value: motivo,
///   onChanged: (v) => setState(() => motivo = v),
///   options: const [
///     DilettaRadioOption(value: 'oferta',  label: 'Recebi oferta de outro banco'),
///     DilettaRadioOption(value: 'tarifas', label: 'Insatisfação com o preço das tarifas'),
///   ],
/// ),
/// ```
class DilettaRadioList extends StatelessWidget {
  const DilettaRadioList({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.title,
  });

  final List<DilettaRadioOption> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'DilettaRadioList',
      props: {if (title != null) 'title': "'$title'", 'options': '${options.length}', if (value != null) 'value': "'$value'"},
      tokens: const ['single-select · radio 20 primary-04 · rows title bodyMd'],
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(title!, style: DilettaType.subheading.copyWith(color: s.textTertiary)),
          const SizedBox(height: 16),
        ],
        for (var i = 0; i < options.length; i++) ...[
          _CpsRadioRow(
            option: options[i],
            selected: value == options[i].value,
            onSelect: () => onChanged(options[i].value),
          ),
          if (i < options.length - 1) const SizedBox(height: 8),
        ],
      ],
    ),
    );
  }
}

class _CpsRadioRow extends StatelessWidget {
  const _CpsRadioRow({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final DilettaRadioOption option;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      label: option.label,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(pressedOpacity: 1.0, 
          behavior: HitTestBehavior.opaque,
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CpsRadioDot(selected: selected),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.label,
                    style: DilettaType.bodyMd.copyWith(
                      color: selected ? s.fg : s.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CpsRadioDot extends StatelessWidget {
  const _CpsRadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return AnimatedContainer(
      duration: DilettaMotion.micro,
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: s.surface,
        border: Border.all(
          color: selected ? s.primary : s.palette.neutral07,
          width: 1.5,
        ),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: s.primary,
              ),
            )
          : null,
    );
  }
}
