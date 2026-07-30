import 'package:flutter/material.dart'
    show TextField, InputDecoration, InputBorder;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';

/// CPF SEGURO — Field.
///
/// O **átomo de input** do DS: o núcleo de texto robusto sobre o qual todo
/// componente com entrada de texto se compõe (Input, SearchInput, ChatInput,
/// DateField, Dropdown). Não desenha superfície, borda, label nem acessórios —
/// só o texto. Quem dá a moldura é o componente que o embrulha.
///
/// **Fundação, não engine.** Roda sobre o [TextField] da plataforma (seleção,
/// IME/composição, autofill, magnifier, acessibilidade, hint nativo, foco no
/// toque — tudo de graça e mantido pelo Flutter), porém DESPIDO de qualquer
/// cara do Material: [InputBorder.none], `filled: false`, `contentPadding` zero,
/// `isCollapsed`. O resultado é um campo puro-token: você controla 100% do
/// visual via os componentes do DS, sem herdar chrome do Material e sem
/// reimplementar edição de texto.
///
/// [controller] e [focusNode] são opcionais — quando `null`, o átomo cria e
/// gerencia os internos (e só descarta os que ele mesmo criou).
class DilettaField extends StatefulWidget {
  const DilettaField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.placeholderStyle,
    this.textStyle,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.readOnly = false,
    this.showCursorWhenReadOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.cursorColor,
    this.placeholderAlignTop = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Hint nativo (renderizado pelo próprio [TextField]).
  final String? placeholder;

  /// Override do estilo do placeholder (default: bodyMd textPlaceholder).
  final TextStyle? placeholderStyle;

  /// Override do estilo do texto digitado (default: bodyMd fg).
  final TextStyle? textStyle;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final bool obscureText;

  /// Não editável (mantém valor + hint; bloqueia edição).
  final bool readOnly;

  /// Mostrar cursor mesmo em [readOnly] (default esconde, padrão picker).
  final bool showCursorWhenReadOnly;

  final bool autofocus;
  final int maxLines;
  final int? minLines;

  /// Limite de caracteres (aplicado por formatter; sem contador do Material).
  final int? maxLength;

  final Color? cursorColor;

  /// Alinha o placeholder ao topo (para campos multiline).
  final bool placeholderAlignTop;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  @override
  State<DilettaField> createState() => _CpfSeguroFieldState();
}

class _CpfSeguroFieldState extends State<DilettaField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocus = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _ownsFocus = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant DilettaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (_ownsFocus) _focusNode.dispose();
      _ownsFocus = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocus) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DilettaScheme s = DilettaTheme.schemeOf(context);
    final formatters = <TextInputFormatter>[
      if (widget.inputFormatters != null) ...widget.inputFormatters!,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(widget.maxLength),
    ];
    final multiline = widget.maxLines != 1;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      showCursor: widget.readOnly ? widget.showCursorWhenReadOnly : true,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      cursorColor: widget.cursorColor ?? s.primary,
      style: widget.textStyle ?? DilettaType.bodyMd.copyWith(color: s.fg),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      inputFormatters: formatters.isEmpty ? null : formatters,
      decoration: InputDecoration(
        isCollapsed: true,
        filled: false,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        counterText: '',
        alignLabelWithHint: multiline || widget.placeholderAlignTop,
        hintText:
            (widget.placeholder?.isEmpty ?? true) ? null : widget.placeholder,
        hintStyle: widget.placeholderStyle ??
            DilettaType.bodyMd.copyWith(color: s.textPlaceholder),
        hintMaxLines: multiline ? null : 1,
      ),
    );
  }
}
