import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'coreflow_scheme.dart' show CoreflowScheme;

/// SearchInput (molécula). Campo de busca compacto (lupa +
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
    //
    // A ÁRVORE TEM UMA FORMA SÓ, com erro ou sem. Era `DilettaSearchInput` na raiz sem erro e
    // `DecoratedBox(child: DilettaSearchInput)` com erro, e trocar a raiz RECRIA o campo: o
    // `FocusNode` interno do avô morre no `dispose`, a conexão de texto fecha e o teclado desce
    // no mesmo frame em que a mensagem de erro aparece. Medido no app em 26/10, na Área Pix,
    // digitando `1`. Sem erro a moldura fica na árvore, só que sem borda.
    //
    // E a borda vai em `foreground`: o campo do avô pinta fundo opaco e a própria borda no mesmo
    // retângulo, então o vermelho em `background` ficava embaixo e nunca apareceu.
    final esquema = CoreflowScheme.of(context);
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: widget.error ? Border.all(color: esquema.danger, width: 1) : null,
        borderRadius: esquema.formaDoCampo,
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
