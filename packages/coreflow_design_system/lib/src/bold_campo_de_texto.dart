import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaInput, DilettaInputType;
import 'bold_busy.dart' show CoreflowBusyScope;
import 'bold_icone.dart' show CoreflowIcone;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Conta BOLD — Text field.
///
/// Pill-ish field (16 radius) with a label sitting ABOVE it (the system
/// standard — not a floating label). Focus lights a violet ring; errors switch
/// the ring and message to red.
///
/// Built on [TextFormField], so it works two ways:
///
/// 1. **Inside a `Form`** — pass a [validator]; `Form.of(context).validate()`
///    drives the error. Use this for the 16 form-based screens.
///    ```dart
///    CoreflowCampoDeTexto(
///      label: 'Chave Pix',
///      controller: _key,
///      validator: (v) => (v == null || v.isEmpty) ? 'Informe a chave' : null,
///    );
///    ```
///
/// 2. **Controlled** — pass [errorText] yourself and validate on submit. Renders
///    a custom error row with a leading icon.
///    ```dart
///    CoreflowCampoDeTexto(label: 'Valor', errorText: _overLimit ? 'Acima do limite' : null);
///    ```
///
/// Don't combine [validator] and [errorText] on the same field — pick one.
///
/// Masks (CPF/CNPJ/phone/agência-conta) go through [inputFormatters].
/// Multi-line fields (Pix message, charge description, dispute reason) set
/// [maxLines].
class CoreflowCampoDeTexto extends StatelessWidget {
  const CoreflowCampoDeTexto({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.readOnly = false,
    this.enabled = true,
    this.mono = false,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  /// Corretor/sugestões do teclado. Desligar em campos técnicos (e-mail, chave).
  final bool autocorrect;
  final bool enableSuggestions;

  /// Trailing widget (e.g. a visibility toggle).
  final Widget? suffixIcon;

  /// Glifo à esquerda — o NOME no conjunto do pai, típico de campo de busca.
  ///
  /// Era `IconData` até 08/08, com uma ponte estática traduzindo Material →
  /// conjunto do pai. O `///` de então dizia: *"o certo é o `prefixIcon` virar
  /// `String` e os call sites falarem o nome do glifo direto; fica pra quando o
  /// campo já estiver de pé"*. Ele está de pé, e os 6 call sites falam o nome.
  final String? prefixIcon;

  /// Controlled error message (manual / submit-time validation).
  final String? errorText;

  /// Form validator — return null when valid, an error string otherwise.
  final String? Function(String?)? validator;

  /// When to auto-run [validator] (defaults to onUserInteraction when a
  /// validator is supplied, otherwise disabled).
  final AutovalidateMode? autovalidateMode;

  final ValueChanged<String>? onChanged;

  /// Called when the user submits (keyboard action button).
  final ValueChanged<String>? onSubmitted;

  /// Called by `Form.save()`.
  final void Function(String?)? onSaved;

  final bool readOnly;

  /// Disable the field (greys it out, blocks input).
  final bool enabled;

  /// Render the value in JetBrains Mono (CPF, keys, codes).
  final bool mono;

  /// Input masks / restrictions — CPF, CNPJ, phone, agência/conta, etc.
  final List<TextInputFormatter>? inputFormatters;

  /// Hard character limit. The default counter is hidden to keep the pill clean.
  final int? maxLength;

  /// Max visible lines. Default 1; raise for multi-line fields (message,
  /// description, dispute reason). Pair with [minLines] for a taller box.
  final int maxLines;

  /// Min visible lines (multi-line fields). Null = grows from one line.
  final int? minLines;

  final TextCapitalization textCapitalization;

  /// Keyboard action button (next / done / search …).
  final TextInputAction? textInputAction;

  final bool autofocus;
  final FocusNode? focusNode;

  bool get _multiline => maxLines > 1 || (minLines != null && minLines! > 1);

  // A PONTE `IconData` → glifo morreu aqui em 08/08, e ela tem história: eu tinha
  // escrito `import ds_compat` por reflexo ao montar esta casca, contra a regra do
  // dono de que o DS de hoje não importa o DS antigo. O gate teria pego; troquei por
  // uma tradução local de 7 linhas e deixei escrito que o certo era outro.
  //
  // O certo era este: os call sites falam o nome do glifo, e não sobra tradutor.
  // **Tradutor no meio do caminho é onde o vocabulário estrangeiro sobrevive** —
  // enquanto ele existe, ninguém precisa aprender o nome certo.

  @override
  Widget build(BuildContext context) {
    final habilitado = enabled && !CoreflowBusyScope.of(context);

    // O CAMPO É DO PAI desde 2026-08-08 (`ds v0.54.0`): rótulo, pill, foco, erro e
    // os dois acessórios são o `DilettaInput`. Saíram daqui 130 linhas de
    // `InputDecoration` — bordas por estado, fill por tema, contador escondido,
    // padding — que existiam porque a peça era privada.
    //
    // O que fica é o que é DO PRODUTO, e cada um tem razão medida:
    //
    // 1. **`Form`**: 17 das 87 chamadas passam `validator`, e o input do pai não é
    //    um `FormField` — nem precisa ser. O `FormField<String>` daqui registra no
    //    `Form`, roda o validador e devolve o resultado pelo `error:` que ele já
    //    tem. **Validação é comportamento do produto; o desenho do erro é dele.**
    //    Foi essa divisão, declarada no pedido, que fez o veredito caber num dia.
    // 2. **a máscara** (`inputFormatters`, 31 chamadas): CPF, CNPJ, agência/conta,
    //    linha digitável. Formato de dado é do produto.
    // 3. **o `mono`**: dígito que alinha em coluna. O pai tem o token; esta casa
    //    ainda decide onde ele entra.
    return FormField<String>(
      initialValue: controller?.text ?? '',
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode ??
          (validator != null
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled),
      builder: (campo) {
        // O erro CONTROLADO (`errorText`, 11 chamadas) e o do validador (17) caem no
        // mesmo lugar — o `error:` do pai. Antes eram dois caminhos: uma linha de
        // erro própria pro controlado e o `errorText` do `TextFormField` pro outro,
        // com dois estilos que precisavam ser mantidos iguais à mão.
        final erro = (errorText?.isNotEmpty ?? false) ? errorText : campo.errorText;
        return DilettaInput(
          controller: controller,
          focusNode: focusNode,
          label: label,
          placeholder: hint,
          error: erro,
          disabled: !habilitado,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          // `autofocus` do pai atravessa só na variante de uma linha — decisão
          // declarada por ele. Os dois sítios multilinha deste app que pedem foco
          // (a linha digitável de 47 dígitos, que QUEBRA em duas) estão medidos e
          // foram mandados como nota; enquanto isso o `_FocoNaAbertura` abaixo
          // resolve pelo lado de cá, que é comportamento e não desenho.
          autofocus: autofocus && !_multiline,
          type: obscureText
              ? DilettaInputType.password
              : (_multiline ? DilettaInputType.long : DilettaInputType.text),
          leftAccessory:
              prefixIcon == null ? null : CoreflowIcone(prefixIcon!, size: 20),
          rightAccessory: suffixIcon,
          onChanged: (v) {
            campo.didChange(v);
            onChanged?.call(v);
          },
        );
      },
    );
  }
}
