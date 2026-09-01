import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSearchInput;
import 'package:flutter/widgets.dart';
import 'bold_radius.dart' show CoreflowRadius;
import 'bold_scheme.dart' show CoreflowScheme;

/// Conta BOLD — SearchInput (molécula). Campo de busca compacto (lupa +
/// placeholder inline, h48 pill).
///
/// **Composição** — CoreflowIcone (átomo) + TextField + tokens.
///
/// Usa [TextField] (não `EditableText` cru) para herdar todo o comportamento
/// nativo do campo: menu Recortar/Copiar/**Colar**, alças de seleção, lupa e o
/// callout "Colar" ao tocar num campo vazio (iOS). Um `EditableText` sozinho não
/// registra esses gestos.
///
/// ```dart
/// CoreflowBusca(controller: _c, placeholder: 'Buscar serviço…');
/// ```
class CoreflowBusca extends StatefulWidget {
  const CoreflowBusca({
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
  State<CoreflowBusca> createState() => _CoreflowBuscaState();
}

class _CoreflowBuscaState extends State<CoreflowBusca> {
  @override
  Widget build(BuildContext context) {
    // O DESENHO É DO PAI (`DilettaSearchInput`): campo, lupa, placeholder e o botão
    // de limpar. Os cinco campos batem nome por nome — o daqui era a mesma peça
    // reescrita, com o `controller` obrigatório em vez de opcional.
    //
    // O `error` NÃO delega, e são **1 chamada em 7**: o pai não tem estado de erro
    // na busca, e a razão dele é boa — busca não valida, busca procura. O sítio que
    // usa é a busca de chave Pix, onde o texto digitado PODE ser inválido como
    // chave. Enquanto for um, fica embrulhado aqui: um caso não vira pedido.
    if (!widget.error) {
      return DilettaSearchInput(
        controller: widget.controller,
        placeholder: widget.placeholder,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: CoreflowScheme.of(context).danger, width: 1),
        borderRadius: BorderRadius.circular(CoreflowRadius.field),
      ),
      child: DilettaSearchInput(
        controller: widget.controller,
        placeholder: widget.placeholder,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
      ),
    );
  }
}
