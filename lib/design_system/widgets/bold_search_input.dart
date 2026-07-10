import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show TextInputAction, TextInputType;
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';
import 'bold_icon.dart';

/// Conta BOLD — SearchInput (molécula). Campo de busca compacto (lupa +
/// placeholder inline, h48 pill).
///
/// **Composição** — BoldIcon (átomo) + EditableText + tokens.
///
/// ```dart
/// BoldSearchInput(controller: _c, placeholder: 'Buscar serviço…');
/// ```
class BoldSearchInput extends StatefulWidget {
  const BoldSearchInput({
    super.key,
    required this.controller,
    this.placeholder = 'Pesquisar',
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<BoldSearchInput> createState() => _BoldSearchInputState();
}

class _BoldSearchInputState extends State<BoldSearchInput> {
  FocusNode? _own;
  FocusNode get _node => widget.focusNode ?? (_own ??= FocusNode());

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: c.isDark ? c.field : BoldColors.white,
        border: Border.all(
            color: c.isDark ? c.border : BoldColors.neutral08, width: 1),
        borderRadius: BoldRadius.fieldR,
      ),
      child: Row(children: [
        BoldIcon('magnifying-glass-light',
            size: BoldIconSize.md, color: c.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(alignment: Alignment.centerLeft, children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (_, v, __) => v.text.isEmpty
                  ? Text(widget.placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BoldType.body.copyWith(color: c.textMuted))
                  : const SizedBox.shrink(),
            ),
            EditableText(
              controller: widget.controller,
              focusNode: _node,
              maxLines: 1,
              cursorColor: BoldColors.primary,
              backgroundCursorColor: BoldColors.neutral07,
              style: BoldType.body.copyWith(color: c.textPrimary),
              selectionColor: BoldColors.primary.withOpacity(0.25),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ]),
        ),
      ]),
    );
  }
}
