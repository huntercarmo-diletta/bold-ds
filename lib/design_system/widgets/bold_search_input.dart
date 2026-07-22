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
    this.error = false,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// Estado de erro — borda vermelha (o dado digitado não foi reconhecido).
  final bool error;

  @override
  State<BoldSearchInput> createState() => _BoldSearchInputState();
}

class _BoldSearchInputState extends State<BoldSearchInput> {
  FocusNode? _own;
  FocusNode get _node => widget.focusNode ?? (_own ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _node.removeListener(_onFocusChange);
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    // Foco = stroke rosa (mesma variante do BoldTextField).
    final focused = _node.hasFocus;
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: c.isDark ? c.field : BoldColors.white,
        border: Border.all(
            color: widget.error
                ? c.danger
                : (focused
                    ? BoldColors.primary
                    : (c.isDark ? c.border : BoldColors.neutral08)),
            width: (widget.error || focused) ? 1.5 : 1),
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
              selectionColor: BoldColors.primary.withValues(alpha: 0.25),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ]),
        ),
        // Botão de limpar (X) — aparece só com texto; limpa tudo e avisa via
        // onChanged('') para o caller voltar ao estado inicial.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (_, v, __) => v.text.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: BoldIcon('circle-xmark-light',
                        size: BoldIconSize.md, color: c.textMuted),
                  ),
                ),
        ),
      ]),
    );
  }
}
