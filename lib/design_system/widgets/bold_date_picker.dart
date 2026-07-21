import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_button.dart';
import 'bold_icon_button.dart';
import 'bold_sheet.dart';

/// Conta BOLD — seletor de data (calendário) em bottom sheet.
///
/// Baseado no componente "Date picker" do Figma CPF Seguro (fluxo QR com
/// vencimento): cabeçalho com mês/ano + navegação, grade de dias (Seg→Dom), dia
/// selecionado com spot [BoldScheme.primary], hoje marcado com um ponto, e CTA
/// "Salvar". Lê 100% dos tokens do DS ([BoldColors]/[BoldType]/[BoldSpace]).
///
/// Uso:
/// ```dart
/// final data = await BoldDatePicker.show(
///   context,
///   initialDate: DateTime.now(),
///   firstDate: DateTime.now(),
///   lastDate: DateTime.now().add(const Duration(days: 365)),
/// );
/// ```
class BoldDatePicker extends StatefulWidget {
  const BoldDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.title = 'Selecionar data',
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String title;

  /// Abre o seletor e devolve a data escolhida (ou `null` se cancelado).
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Selecionar data',
  }) {
    return BoldSheet.show<DateTime>(
      context,
      title: title,
      builder: (_) => BoldDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
      ),
    );
  }

  @override
  State<BoldDatePicker> createState() => _BoldDatePickerState();
}

class _BoldDatePickerState extends State<BoldDatePicker> {
  static const _meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];
  static const _semana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  late DateTime _visibleMonth; // sempre no dia 1º do mês exibido
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    final base = _dateOnly(widget.initialDate ?? DateTime.now());
    _selected = widget.initialDate != null ? base : null;
    _visibleMonth = DateTime(base.year, base.month);
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _disabled(DateTime d) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null && d.isBefore(_dateOnly(first))) return true;
    if (last != null && d.isAfter(_dateOnly(last))) return true;
    return false;
  }

  void _step(int months) {
    setState(() => _visibleMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + months));
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final today = _dateOnly(DateTime.now());

    // Grade Seg→Dom: quantos "vazios" antes do dia 1º.
    final firstWeekday = _visibleMonth.weekday; // Seg=1 … Dom=7
    final leading = firstWeekday - 1;
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;

    final cells = <Widget>[];
    for (var i = 0; i < leading; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
      cells.add(_DayCell(
        day: day,
        selected: _selected != null && _sameDay(date, _selected!),
        isToday: _sameDay(date, today),
        disabled: _disabled(date),
        onTap: () => setState(() => _selected = date),
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          BoldSpace.x2, BoldSpace.x2, BoldSpace.x2, BoldSpace.x2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabeçalho do mês
          Row(
            children: [
              BoldIconButton(
                icon: 'chevron-left',
                semanticLabel: 'Mês anterior',
                type: BoldIconButtonType.tertiary,
                size: BoldIconButtonSize.sm,
                onPressed: () => _step(-1),
              ),
              Expanded(
                child: Text(
                  '${_meses[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                  textAlign: TextAlign.center,
                  style: BoldType.titleMd.copyWith(color: c.textPrimary),
                ),
              ),
              BoldIconButton(
                icon: 'chevron-right',
                semanticLabel: 'Próximo mês',
                type: BoldIconButtonType.tertiary,
                size: BoldIconButtonSize.sm,
                onPressed: () => _step(1),
              ),
            ],
          ),
          const SizedBox(height: BoldSpace.x3),
          // Cabeçalho dos dias da semana
          Row(
            children: [
              for (final w in _semana)
                Expanded(
                  child: Text(w,
                      textAlign: TextAlign.center,
                      style: BoldType.labelMd.copyWith(color: c.textSecondary)),
                ),
            ],
          ),
          const SizedBox(height: BoldSpace.x2),
          // Grade de dias
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.1,
            children: cells,
          ),
          const SizedBox(height: BoldSpace.x5),
          BoldButton(
            'Salvar',
            onPressed: _selected == null
                ? null
                : () => Navigator.of(context).pop(_selected),
          ),
          const SizedBox(height: BoldSpace.x2),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.disabled,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool isToday;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    final Color fg = disabled
        ? c.textMuted
        : selected
            ? c.onPrimary
            : c.textPrimary;

    return Center(
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.primary : BoldColors.transparent,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$day',
                  style: BoldType.body.copyWith(
                      color: fg,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w400)),
              // Ponto de "hoje" (só quando não selecionado).
              if (isToday && !selected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                      color: c.primary, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
