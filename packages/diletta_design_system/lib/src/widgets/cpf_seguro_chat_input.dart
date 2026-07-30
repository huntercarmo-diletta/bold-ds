import 'package:flutter/widgets.dart';
import 'cpf_seguro_tappable.dart';
import 'package:flutter/services.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_checkbox.dart';
import 'cpf_seguro_field.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_status_tag.dart';

/// Tipo de teclado do [DilettaChatInput]. Atalho pros casos comuns; pra um
/// [TextInputType] arbitrário (email, etc.) use [DilettaChatInput.keyboardType].
enum DilettaChatInputType { text, numeric, tel }

/// Descriptor do "checkbox chip" que aparece ABAIXO do [DilettaChatInput].
///
/// Usa [DilettaCheckbox] (átomo) + [Text] + tooltip icon opcional. Casos:
/// "Não há nome da mãe no documento", "Não tenho apelido", etc.
class DilettaChatInputCheckbox {
  const DilettaChatInputCheckbox({
    required this.label,
    required this.checked,
    required this.onChanged,
    this.showTooltipIcon = true,
    this.onTooltipTap,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool showTooltipIcon;
  final VoidCallback? onTooltipTap;
}

/// CPF SEGURO — ChatInput.
///
/// Barra de input do chat: **[DilettaField]** (o átomo de texto robusto) +
/// toggle eye + botão send + chip de checkbox opcional. Height 56, radius 24,
/// drop shadow. Send vira primary-04 quando pronto (has value ou [sendReady]).
///
/// Como todo input do DS, o núcleo de texto é o [DilettaField] — herda
/// seleção, IME, autofill e acessibilidade do engine da plataforma, o que
/// permite o app delegar 100% do input inclusive em fluxos auth-críticos.
///
/// Aceita [keyboardType] arbitrário, [inputFormatters] (máscaras), [onChanged],
/// [textCapitalization], [focusNode] externo, [readOnly] (com hint próprio via
/// [placeholder] + [readOnlyPrefixIcon]). A VALIDAÇÃO e o gate de send
/// (validator/onError/merge de erro) ficam no consumidor, que passa o
/// [errorText] final.
///
/// **Variações:**
/// - [errorText] setado → [DilettaStatusTag] tone=danger em cima + border
///   error-04 no input.
/// - [checkbox] setado → chip com [DilettaCheckbox] + Text + tooltip embaixo.
class DilettaChatInput extends StatefulWidget {
  const DilettaChatInput({
    super.key,
    required this.controller,
    this.placeholder = '',
    this.type = DilettaChatInputType.text,
    this.keyboardType,
    this.inputFormatters,
    this.password = false,
    this.visible = false,
    this.onToggleVisible,
    this.onSend,
    this.onChanged,
    this.sendDisabled = false,
    this.disabled = false,
    this.readOnly = false,
    this.readOnlyPrefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.autofocus = false,
    this.maxLength,
    this.sendReady = false,
    this.errorText,
    this.checkbox,
  });

  final TextEditingController controller;
  final String placeholder;
  final DilettaChatInputType type;

  /// Override do teclado (tem prioridade sobre [type]).
  final TextInputType? keyboardType;

  /// Máscaras/limites (CPF, telefone, data, etc.).
  final List<TextInputFormatter>? inputFormatters;

  final bool password;
  final bool visible;
  final VoidCallback? onToggleVisible;
  final VoidCallback? onSend;
  final ValueChanged<String>? onChanged;
  final bool sendDisabled;

  /// Desabilitado "duro": cinza (neutral-10) + não editável.
  final bool disabled;

  /// Somente-leitura: não edita (mantém a superfície normal), mostra o
  /// [placeholder] como hint e, se [readOnlyPrefixIcon] setado, o ícone prefixo.
  final bool readOnly;
  final String? readOnlyPrefixIcon;

  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final bool autofocus;
  final int? maxLength;

  /// Força send em primary-04 mesmo sem texto (útil pra snapshots).
  final bool sendReady;

  /// Mensagem de erro (já resolvida pelo consumidor: validação + server).
  final String? errorText;

  /// Chip de checkbox abaixo do input (opt-out específico como "Não há X").
  final DilettaChatInputCheckbox? checkbox;

  @override
  State<DilettaChatInput> createState() => _CpfSeguroChatInputState();
}

class _CpfSeguroChatInputState extends State<DilettaChatInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant DilettaChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  // Reflete o estado do send (ativo quando há texto) sem depender do consumidor.
  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  bool get _nonEditable => widget.disabled || widget.readOnly;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final hasError = widget.errorText != null;
    final input = _buildInput(s: s, hasError: hasError);

    if (!hasError && widget.checkbox == null) return input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasError) ...[
          DilettaStatusTag(
            label: widget.errorText!,
            tone: DilettaStatusTone.danger,
            icon: DilettaIcons.xmarkSolid,
          ),
          const SizedBox(height: 8),
        ],
        input,
        if (widget.checkbox != null) ...[
          const SizedBox(height: 8),
          _CheckboxChip(descriptor: widget.checkbox!),
        ],
      ],
    );
  }

  Widget _buildInput({required DilettaScheme s, required bool hasError}) {
    final hasValue = widget.controller.text.isNotEmpty;
    final showSendActive =
        widget.sendReady || (!widget.sendDisabled && hasValue);
    final keyboardType = widget.keyboardType ??
        switch (widget.type) {
          DilettaChatInputType.numeric => TextInputType.number,
          DilettaChatInputType.tel => TextInputType.phone,
          DilettaChatInputType.text => TextInputType.text,
        };

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(
          left: DilettaSpacing.s5,
          right: DilettaSpacing.s2,
          top: DilettaSpacing.s2,
          bottom: DilettaSpacing.s2,
        ),
        decoration: BoxDecoration(
          // Fill = surface; vira neutral-10 (cinza) só quando disabled (não readOnly).
          color: widget.disabled ? s.palette.neutral10 : s.surface,
          borderRadius: DilettaRadius.all24,
          border: hasError
              ? Border.all(color: s.palette.error04, width: 1.5)
              : null,
          boxShadow: DilettaElevation.medium,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.readOnly && widget.readOnlyPrefixIcon != null) ...[
              DilettaIconAccessory(
                icon: widget.readOnlyPrefixIcon!,
                padding: 0,
                size: 20,
                color: s.textMuted,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: DilettaField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                placeholder: widget.placeholder,
                keyboardType: keyboardType,
                inputFormatters: widget.inputFormatters,
                textCapitalization: widget.textCapitalization,
                obscureText: widget.password && !widget.visible,
                readOnly: _nonEditable,
                maxLength: widget.maxLength,
                onChanged: widget.onChanged,
                onSubmitted: (_) {
                  if (!widget.sendDisabled) widget.onSend?.call();
                },
              ),
            ),
            if (widget.password)
              Semantics(
                button: true,
                label: widget.visible ? 'Esconder senha' : 'Mostrar senha',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: DilettaTappable(
                    onTap: widget.onToggleVisible,
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: DilettaIconAccessory(
                        icon: widget.visible
                            ? 'eye-slash-light-full'
                            : 'eye-light',
                        padding: 0,
                        size: 20,
                        color: s.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            Semantics(
              button: true,
              label: 'Enviar',
              enabled: !widget.sendDisabled,
              child: MouseRegion(
                cursor: widget.sendDisabled
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.click,
                child: DilettaTappable(
                  onTap: widget.sendDisabled ? null : widget.onSend,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: DilettaIconAccessory(
                      icon: DilettaIcons.sendCpfSeguro,
                      padding: 0,
                      size: 20,
                      color: showSendActive ? s.primary : s.textPlaceholder,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _CheckboxChip — chip branco pill que aparece embaixo do ChatInput quando
// [DilettaChatInput.checkbox] é setado. Composto de átomos:
// Checkbox + Text + Icon (tooltip opt).
class _CheckboxChip extends StatelessWidget {
  const _CheckboxChip({required this.descriptor});
  final DilettaChatInputCheckbox descriptor;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DilettaSpacing.s4, vertical: DilettaSpacing.s3),
      decoration: BoxDecoration(
        color: s.surface,
        borderRadius: DilettaRadius.pillAll,
        boxShadow: DilettaElevation.low,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DilettaCheckbox(
            checked: descriptor.checked,
            variant: DilettaCheckboxVariant.neutral,
            onChanged: descriptor.onChanged,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              descriptor.label,
              style: DilettaType.bodyMd.copyWith(color: s.textSecondary),
            ),
          ),
          if (descriptor.showTooltipIcon) ...[
            const SizedBox(width: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: DilettaTappable(
                onTap: descriptor.onTooltipTap,
                child: DilettaIconAccessory(
                  icon: DilettaIcons.circleInfoLight,
                  padding: 0,
                  size: 20,
                  color: s.textMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
