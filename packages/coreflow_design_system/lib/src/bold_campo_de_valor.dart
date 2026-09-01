import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAmountField, DilettaAmountFieldSize;
import 'package:flutter/material.dart';

import 'bold_dinheiro.dart';

/// Conta BOLD — CurrencyField. Campo de valor: `R$` à esquerda, número grande e
/// centralizado, sem moldura.
///
/// **CASCA do [DilettaAmountField]** desde 2026-08-08 (`ds v0.61.0`), e o pedido
/// que a destravou mediu a assimetria: a linguagem tinha **três peças pra MOSTRAR
/// valor** (`DilettaAmount`, `DilettaAmountDisplay`, `DilettaReceiptRow`) e
/// **nenhuma pra RECEBER**. O veredito chamou de *"metade de um gesto que a
/// linguagem afirma cobrir"*.
///
/// ## O que ficou aqui, e por quê
///
/// - **a moeda**: `R$` é de um país, não desta linguagem. O pai deixou o slot
///   `prefixo` e nulo não desenha nada;
/// - **a máquina de centavos**: dígito pela direita, milhar sozinho, teto de 10
///   dígitos. É comportamento de produto e mora no `inputFormatters`, que é a
///   mesma divisão que o `DilettaInput` já fazia. Aqui ela nem é local: é o
///   `CoreflowDinheiro`, que já é peça deste DS;
/// - **o zerar ao focar**: quem toca no valor quer digitar outro, não editar o
///   que está lá.
///
/// O que SAIU foi a pintura — degrau tipográfico por porte, centralização e a
/// ausência de moldura agora são do pai. E uma decisão dele que eu não tinha:
/// **o símbolo não acompanha o degrau do número**, porque ele é referência e não
/// valor. O que se lê primeiro é *quanto*, não *em quê*.
///
/// ```dart
/// CoreflowCampoDeValor(controller: ctrl, large: true, onChanged: (v) => setState(...));
/// ```
class CoreflowCampoDeValor extends StatefulWidget {
  const CoreflowCampoDeValor({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.large = false,
    this.validator,
  });

  final TextEditingController? controller;
  final double? initialValue;
  final ValueChanged<double>? onChanged;

  /// `true` = número herói (o número É a tela); `false` = médio (divide espaço
  /// com o formulário). Os dois portes são do pai — e eles apareceram dos DOIS
  /// lados do gesto sem combinar: o `AmountDisplay.hero` já existia na leitura, e
  /// as 6 telas de entrada daqui pediram a mesma divisão.
  final bool large;

  /// Validação é do produto: o pai respondeu isso no pedido do `Form`, e vale
  /// igual aqui. 1 dos 6 sítios usa.
  final String? Function(String?)? validator;

  @override
  State<CoreflowCampoDeValor> createState() => _CoreflowCampoDeValorState();
}

class _CoreflowCampoDeValorState extends State<CoreflowCampoDeValor> {
  late final TextEditingController _ctrl;
  bool _ownsCtrl = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialValue;
    final centavos = (init != null && init > 0) ? (init * 100).round() : 0;
    final texto = CoreflowDinheiro.formatar(centavos, comSimbolo: false);
    if (widget.controller != null) {
      _ctrl = widget.controller!;
      if (_ctrl.text.isEmpty) _ctrl.text = texto;
    } else {
      _ownsCtrl = true;
      _ctrl = TextEditingController(text: texto);
    }
  }

  /// Ao focar, zera. Quem toca no valor quer digitar OUTRO — editar o que está lá
  /// dígito a dígito, num campo que formata a cada tecla, não é o gesto de
  /// ninguém.
  ///
  /// O gancho é um `Focus` POR FORA e não um `focusNode` no campo: o
  /// `DilettaAmountField` não expõe o nó, e não precisa — `Focus.onFocusChange`
  /// dispara para os descendentes, então o envelope enxerga o campo ganhar foco
  /// sem o campo ter que dizer nada. Quatro linhas aqui valem menos que um
  /// repasse pedido ao pai.
  void _aoFocar(bool ganhou) {
    if (!ganhou) return;
    _ctrl.clear();
    widget.onChanged?.call(0);
  }

  @override
  void dispose() {
    if (_ownsCtrl) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campo = DilettaAmountField(
      controller: _ctrl,
      size: widget.large
          ? DilettaAmountFieldSize.heroi
          : DilettaAmountFieldSize.medio,
      prefixo: r'R$',
      placeholder: '0,00',
      // Sem símbolo DENTRO do texto: ele mora no `prefixo`, num degrau menor. Com
      // o símbolo no texto ele herdaria o porte do número.
      inputFormatters: [CoreflowDinheiro.formatter(comSimbolo: false)],
      onChanged: (t) => widget.onChanged?.call(CoreflowDinheiro.emReais(t)),
    );
    final comFoco = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _aoFocar,
      child: campo,
    );
    if (widget.validator == null) return comFoco;
    // O `validator` é do produto e o campo do pai não valida. O `FormField` de
    // fora dá o hook do `Form.validate()` sem o campo saber de nada.
    return FormField<String>(
      validator: (_) => widget.validator!(_ctrl.text),
      builder: (estado) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          comFoco,
          if (estado.errorText != null) ...[
            const SizedBox(height: 6),
            Text(estado.errorText!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
    );
  }
}
