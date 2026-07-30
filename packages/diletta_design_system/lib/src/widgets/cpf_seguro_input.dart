import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_field.dart';
import 'cpf_seguro_icon.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Tipo do campo — governa masking, keyboard e visual.
enum DilettaInputType {
  text,
  password,

  /// Multi-line (textarea equivalente).
  long,
}

/// CPF SEGURO — Input.
///
/// Campo de formulário do DS. Compõe **label** (topo) + **[DilettaField]**
/// (o átomo de texto, com border/ring + acessórios esq/dir opcionais) +
/// **tooltip** (bottom, vira mensagem de erro se [error] estiver setado).
///
/// O núcleo de texto é o mesmo [DilettaField] usado por SearchInput/ChatInput
/// — uma raiz de input só pra todo o DS. Esta casca cuida de label, moldura,
/// estados de foco/hover/erro e o olho de senha.
///
/// Focus renderiza duas bordas:
/// 1. Inner 1px saturada (`primary-04` ou `error-04`).
/// 2. Outer 3px ring tint (`primary-07` ou `error-07`).
///
/// ```dart
/// DilettaInput(
///   label: 'Nome completo',
///   controller: nomeCtrl,
/// ),
/// DilettaInput(
///   label: 'CPF',
///   controller: cpfCtrl,
///   error: 'CPF inválido',
///   keyboardType: TextInputType.number,
/// ),
/// ```
class DilettaInput extends StatefulWidget {
  const DilettaInput({
    super.key,
    this.controller,
    this.label,
    this.type = DilettaInputType.text,
    this.helper,
    this.error,
    this.disabled = false,
    this.placeholder,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.leftAccessory,
    this.rightAccessory,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
  });

  /// Opcional (igual ao `TextField` do Flutter): se `null`, o componente cria
  /// e gerencia um controller interno. Passe um quando a tela precisar ler/
  /// setar o texto — a lógica de tela mora fora, o componente só o consome.
  final TextEditingController? controller;
  final String? label;
  final DilettaInputType type;
  final String? helper;

  /// Se não-nulo, sobrepõe [helper] e liga estado de erro.
  final String? error;

  final bool disabled;
  final String? placeholder;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final Widget? leftAccessory;
  final Widget? rightAccessory;

  final ValueChanged<String>? onChanged;

  /// Toque no campo. Com [readOnly] true vira o padrão "picker" (abre um
  /// bottomsheet/seletor sem abrir teclado).
  final VoidCallback? onTap;

  /// Campo somente-leitura (não edita, mas continua tocável via [onTap]).
  final bool readOnly;

  /// Auto-capitalização do teclado (nome próprio, frase, etc.).
  final TextCapitalization textCapitalization;

  final FocusNode? focusNode;

  @override
  State<DilettaInput> createState() => _CpsInputState();
}

class _CpsInputState extends State<DilettaInput> {
  late FocusNode _focusNode;

  bool _focused = false;

  /// Hover de ponteiro (web/desktop). No touch nunca dispara — inerte no mobile.
  bool _hovered = false;

  /// Password oculto (toggle do olho). Só relevante em type password.
  bool _obscure = true;

  bool get _isError => widget.error != null;

  void _setHover(bool v) {
    if (widget.disabled || !mounted || _hovered == v) return;
    setState(() => _hovered = v);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant DilettaInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final tooltip = widget.error ?? widget.helper;

    return DilettaDevInfo(
      component: 'DilettaInput',
      props: {
        'label': "'${widget.label}'",
        if (widget.error != null) 'error': "'${widget.error}'",
        if (widget.disabled) 'disabled': 'true'
      },
      tokens: const [
        'field h48 · radius 16 · inputText bodyMd',
        'border neutral-08 (focus primary-04 · error error-04)'
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            _CpsInputLabel(text: widget.label!, error: _isError),
            const SizedBox(height: 8),
          ],
          MouseRegion(
            onEnter: (_) => _setHover(true),
            onExit: (_) => _setHover(false),
            // Tap-to-focus do container inteiro (padding + acessórios). No
            // texto em si, o próprio Field/TextField já foca no toque.
            child: DilettaTappable(
              pressedOpacity: 1.0,
              behavior: HitTestBehavior.opaque,
              onTap: widget.disabled
                  ? null
                  : () {
                      widget.onTap?.call();
                      // Picker (readOnly) não abre teclado; campo normal foca.
                      if (!widget.readOnly) _focusNode.requestFocus();
                    },
              child: widget.type == DilettaInputType.long
                  ? _buildTextarea()
                  : _buildField(),
            ),
          ),
          if (tooltip != null) ...[
            const SizedBox(height: 8),
            _CpsInputTooltip(text: tooltip, error: _isError),
          ],
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    final s = DilettaTheme.schemeOf(context);
    final border = _isError
        ? s.palette.error04
        : widget.disabled
            ? s.divider
            : _focused
                ? s.primary
                : _hovered
                    ? s.palette.neutral07
                    : s.border;

    final ring = (_focused && !widget.disabled)
        ? [
            BoxShadow(
              color:
                  _isError ? s.palette.error07 : s.palette.primary07,
              blurRadius: 0,
              spreadRadius: 3,
            ),
          ]
        : null;

    return BoxDecoration(
      color: widget.disabled ? s.palette.neutral10 : s.surface,
      border: Border.all(color: border, width: 1),
      borderRadius: DilettaRadius.all16,
      boxShadow: ring,
    );
  }

  /// Olho de password embutido (toggle). Só quando type password e sem
  /// rightAccessory custom. Ícones alinhados ao app (eyeLight/eyeSlashLightFull).
  Widget? _passwordEye() {
    if (widget.type != DilettaInputType.password || widget.disabled) {
      return null;
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DilettaTappable(
        onTap: () => setState(() => _obscure = !_obscure),
        child: DilettaIcon(
          name: _obscure
              ? DilettaIcons.eyeSlashLightFull
              : DilettaIcons.eyeLight,
          size: 18,
          color: DilettaTheme.schemeOf(context).textMuted,
        ),
      ),
    );
  }

  TextStyle _placeholderStyle({required bool multiline}) {
    final s = DilettaTheme.schemeOf(context);
    return (multiline ? DilettaType.button : DilettaType.bodyMd).copyWith(
      color: widget.disabled ? s.palette.neutral05 : s.textMuted,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );
  }

  // Field readOnly (picker/disabled) fica inerte ao toque pra o GestureDetector
  // externo dono do onTap. Editável, o Field foca/digita normalmente.
  Widget _wrapPointer(Widget field) {
    if (widget.readOnly || widget.disabled) {
      return IgnorePointer(child: field);
    }
    return field;
  }

  Widget _buildField() {
    final s = DilettaTheme.schemeOf(context);
    final right = widget.rightAccessory ?? _passwordEye();
    return AnimatedContainer(
      duration: DilettaMotion.micro,
      // Altura fixa 48 + padding horizontal 12 (pedido). Gaps pros acessórios
      // no Row (SizedBox 8), separados do padding do container.
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s3),
      decoration: _decoration(),
      child: Row(
        children: [
          if (widget.leftAccessory != null) ...[
            widget.leftAccessory!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: _wrapPointer(
              DilettaField(
                controller: widget.controller,
                focusNode: _focusNode,
                placeholder: widget.placeholder,
                placeholderStyle: _placeholderStyle(multiline: false),
                textStyle: DilettaType.bodyMd.copyWith(
                  color: widget.disabled ? s.palette.neutral05 : s.fg,
                ),
                readOnly: widget.disabled || widget.readOnly,
                obscureText:
                    widget.type == DilettaInputType.password && _obscure,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                textCapitalization: widget.textCapitalization,
                maxLength: widget.maxLength,
                onChanged: widget.onChanged,
              ),
            ),
          ),
          if (right != null) ...[
            const SizedBox(width: 8),
            right,
          ],
        ],
      ),
    );
  }

  Widget _buildTextarea() {
    final s = DilettaTheme.schemeOf(context);
    return AnimatedContainer(
      duration: DilettaMotion.micro,
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(
          horizontal: DilettaSpacing.s4, vertical: DilettaSpacing.s4),
      decoration: _decoration(),
      child: _wrapPointer(
        DilettaField(
          controller: widget.controller,
          focusNode: _focusNode,
          placeholder: widget.placeholder,
          placeholderStyle: _placeholderStyle(multiline: true),
          placeholderAlignTop: true,
          textStyle: DilettaType.button.copyWith(
            color: widget.disabled ? s.palette.neutral05 : s.fg,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          readOnly: widget.disabled || widget.readOnly,
          textCapitalization: widget.textCapitalization,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLines: 8,
          minLines: 3,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class _CpsInputLabel extends StatelessWidget {
  const _CpsInputLabel({required this.text, required this.error});
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Text(
      text,
      style: DilettaType.label.copyWith(
        color: error ? s.palette.error04 : s.textTertiary,
      ),
    );
  }
}

class _CpsInputTooltip extends StatelessWidget {
  const _CpsInputTooltip({required this.text, required this.error});
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Padding(
      // padding esq 16 alinha com o texto DENTRO do input (que tem edge 16).
      padding: const EdgeInsets.only(left: DilettaSpacing.s4),
      child: Text(
        text,
        style: DilettaType.labelSm.copyWith(
          color: error ? s.palette.error04 : s.textMuted,
        ),
      ),
    );
  }
}
