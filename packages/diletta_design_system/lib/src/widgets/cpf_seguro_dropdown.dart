import 'package:flutter/material.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon.dart';
import 'cpf_seguro_input.dart';

/// CPF SEGURO — Dropdown.
///
/// Palavra própria (não é um [DilettaInput] com truque): é OUTRA forma de
/// entrada — o usuário ESCOLHE um valor de uma lista fechada, não digita. O
/// gatilho tem a cara do Input (readOnly + chevron), e a seleção acontece numa
/// superfície idiomática de mobile — um bottomsheet (padrão iOS HIG / Material
/// pra listas), não um menu ancorado minúsculo.
///
/// ```dart
/// DilettaDropdown(
///   label: 'Tipo de chave',
///   placeholder: 'Selecione',
///   value: tipo,
///   items: const ['CPF', 'Celular', 'E-mail', 'Aleatória'],
///   onChanged: (v) => setState(() => tipo = v),
/// )
/// ```
class DilettaDropdown extends StatelessWidget {
  const DilettaDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.placeholder,
    this.error,
    this.disabled = false,
    this.sheetTitle,
  });

  /// Opções da lista (fechada).
  final List<String> items;

  /// Valor selecionado atual. Null = nada escolhido (mostra [placeholder]).
  final String? value;

  /// Chamado ao escolher uma opção.
  final ValueChanged<String> onChanged;

  final String? label;
  final String? placeholder;

  /// Mensagem de erro (liga o estado de erro do campo).
  final String? error;
  final bool disabled;

  /// Título do bottomsheet de seleção. Default: [label] ou "Selecione".
  final String? sheetTitle;

  Future<void> _open(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DropdownSheet(
        title: sheetTitle ?? label ?? 'Selecione',
        items: items,
        selected: value,
      ),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    // Controller efêmero só pra pintar o valor/placeholder no campo readOnly.
    final controller = TextEditingController(text: value ?? '');
    return DilettaInput(
      label: label,
      placeholder: placeholder,
      error: error,
      disabled: disabled,
      readOnly: true,
      controller: controller,
      onTap: disabled ? null : () => _open(context),
      rightAccessory: DilettaIcon(
        name: DilettaIcons.chevronDownLight,
        size: 12,
        color: disabled ? s.palette.neutral05 : s.textMuted,
      ),
    );
  }
}

/// Corpo do bottomsheet de seleção — lista DS de opções (single-select).
/// Retorna a opção tocada via `Navigator.pop`.
class _DropdownSheet extends StatelessWidget {
  const _DropdownSheet({
    required this.title,
    required this.items,
    required this.selected,
  });

  final String title;
  final List<String> items;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: s.surface,
          borderRadius: const BorderRadius.vertical(top: DilettaRadius.r24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grabber.
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: DilettaSpacing.s3),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: s.divider,
                  borderRadius: DilettaRadius.all200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DilettaSpacing.s5,
                DilettaSpacing.s4,
                DilettaSpacing.s5,
                DilettaSpacing.s2,
              ),
              child: Text(
                title,
                style: DilettaType.title.copyWith(color: s.fg),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: DilettaSpacing.s4),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  final isSel = item == selected;
                  return DilettaTappable(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DilettaSpacing.s5,
                        vertical: DilettaSpacing.s4,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: s.divider, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: DilettaType.button.copyWith(
                                color: s.fg,
                                fontWeight:
                                    isSel ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSel)
                            DilettaIcon(
                              name: DilettaIcons.checkSolid,
                              size: 16,
                              color: s.palette.primary04,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
