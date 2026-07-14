import 'package:flutter/widgets.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Uma opção do [BoldRadioList].
class BoldRadioOption {
  const BoldRadioOption({required this.value, required this.label});
  final String value;
  final String label;
}

/// Conta BOLD — RadioList. Lista single-select com título opcional. Selecionada
/// pinta o ring + dot com `primary`; texto vira textPrimary.
///
/// Portado do DS CPF Seguro (adaptado aos tokens Bold*).
///
/// ```dart
/// BoldRadioList(
///   title: 'Selecione o motivo',
///   value: motivo,
///   onChanged: (v) => setState(() => motivo = v),
///   options: const [
///     BoldRadioOption(value: 'oferta', label: 'Recebi oferta de outro banco'),
///     BoldRadioOption(value: 'tarifas', label: 'Preço das tarifas'),
///   ],
/// );
/// ```
class BoldRadioList extends StatelessWidget {
  const BoldRadioList({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.title,
  });

  final List<BoldRadioOption> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(title!,
              style: BoldType.titleMd.copyWith(color: c.textSecondary)),
          const SizedBox(height: 16),
        ],
        for (var i = 0; i < options.length; i++) ...[
          _RadioRow(
            option: options[i],
            selected: value == options[i].value,
            onSelect: () => onChanged(options[i].value),
          ),
          if (i < options.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final BoldRadioOption option;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      label: option.label,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _RadioDot(selected: selected),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.label,
                  style: BoldType.body.copyWith(
                      color: selected ? c.textPrimary : c.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.surface,
        border: Border.all(
          color: selected ? c.primary : c.border,
          width: 1.5,
        ),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: c.primary),
            )
          : null,
    );
  }
}
