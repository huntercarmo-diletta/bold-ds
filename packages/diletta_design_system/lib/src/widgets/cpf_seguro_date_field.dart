import 'package:flutter/material.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon.dart';
import 'cpf_seguro_input.dart';
import 'cpf_seguro_calendar.dart';

/// CPF SEGURO — DateField.
///
/// Campo de data = gatilho com cara de [DilettaInput] (readOnly + ícone de
/// calendário) que abre o [DilettaCalendar] num bottomsheet. Separa o CAMPO
/// (input) da SUPERFÍCIE (calendar) — a data escolhida volta formatada.
///
/// Formatação default `dd/MM/aaaa`; troque via [format] pra localizar.
///
/// ```dart
/// DilettaDateField(
///   label: 'Data de nascimento',
///   value: nascimento,
///   lastDay: DateTime.now(),
///   onChanged: (d) => setState(() => nascimento = d),
/// )
/// ```
class DilettaDateField extends StatelessWidget {
  const DilettaDateField({
    super.key,
    required this.onChanged,
    this.value,
    this.label,
    this.placeholder = 'dd/mm/aaaa',
    this.error,
    this.disabled = false,
    this.firstDay,
    this.lastDay,
    this.format,
    this.sheetTitle,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  final String? label;
  final String placeholder;
  final String? error;
  final bool disabled;

  /// Limites passados ao [DilettaCalendar].
  final DateTime? firstDay;
  final DateTime? lastDay;

  /// Como renderizar a data no campo. Default: `dd/MM/aaaa` zero-padded.
  final String Function(DateTime)? format;

  final String? sheetTitle;

  String _fmt(DateTime d) {
    if (format != null) return format!(d);
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CalendarSheet(
        title: sheetTitle ?? label ?? 'Selecione a data',
        selectedDate: value,
        firstDay: firstDay,
        lastDay: lastDay,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final controller = TextEditingController(text: value == null ? '' : _fmt(value!));
    return DilettaInput(
      label: label,
      placeholder: placeholder,
      error: error,
      disabled: disabled,
      readOnly: true,
      controller: controller,
      onTap: disabled ? null : () => _open(context),
      rightAccessory: DilettaIcon(
        name: DilettaIcons.calendarLight,
        size: 18,
        color: disabled ? s.palette.neutral05 : s.textMuted,
      ),
    );
  }
}

/// Bottomsheet que embrulha o [DilettaCalendar]. Fecha retornando a data ao
/// primeiro toque num dia (sem botão confirmar — pick imediato).
class _CalendarSheet extends StatelessWidget {
  const _CalendarSheet({
    required this.title,
    this.selectedDate,
    this.firstDay,
    this.lastDay,
  });

  final String title;
  final DateTime? selectedDate;
  final DateTime? firstDay;
  final DateTime? lastDay;

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            DilettaSpacing.s5,
            DilettaSpacing.s3,
            DilettaSpacing.s5,
            DilettaSpacing.s4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: s.divider,
                    borderRadius: DilettaRadius.all200,
                  ),
                ),
              ),
              const SizedBox(height: DilettaSpacing.s4),
              Text(
                title,
                style: DilettaType.title.copyWith(color: s.fg),
              ),
              const SizedBox(height: DilettaSpacing.s4),
              DilettaCalendar(
                selectedDate: selectedDate,
                firstDay: firstDay,
                lastDay: lastDay,
                onDateSelected: (d) => Navigator.of(context).pop(d),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
