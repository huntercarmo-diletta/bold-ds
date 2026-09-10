/// CONTA BOLD — a ação em voo, e ela veio do app em 21/08.
///
/// Ficou no app até aqui com a razão `deliberado` *"comportamento: trava o formulário em voo, não é
/// desenho"*. A razão está certa e a conclusão estava errada — **comportamento deste produto é
/// vocabulário DESTE produto, e o pacote é o DS dele.** É a terceira vez que a mesma frase muda de
/// conclusão: aconteceu com o logo, com as 16 ilustrações, e agora aqui.
///
/// O que a mudança de casa paga: quem monta tela com as peças do pacote passa a poder travar o
/// formulário sem depender de o app declarar a peça — e a regra deixa de existir em dois lugares no
/// dia em que um segundo produto precisar dela.
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';

/// Escopo de "ação em voo" — publicado por [CoreflowBusy], lido pelos inputs do DS.
///
/// Existe para o campo não depender da tela lembrar de passar `enabled: false`
/// em cada um. Quem envolve o formulário declara UMA vez que está ocupado, e
/// todo input abaixo se desabilita sozinho.
class CoreflowBusyScope extends InheritedWidget {
  const CoreflowBusyScope({super.key, required this.busy, required super.child});

  final bool busy;

  /// `true` quando existe uma ação em voo acima deste ponto da árvore.
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CoreflowBusyScope>()?.busy ??
      false;

  @override
  bool updateShouldNotify(CoreflowBusyScope old) => busy != old.busy;
}

/// **CoreflowBusy** — trava o formulário enquanto a ação está em voo.
///
/// Botão em loading resolve metade do problema: impede o segundo toque no
/// próprio botão. A outra metade é o usuário continuar editando depois de
/// mandar — aí a tela mostra um valor e o servidor recebeu outro, e a
/// divergência só aparece no comprovante.
///
/// ```dart
/// CoreflowBusy(
///   busy: _enviando,
///   child: Column(children: [ ...campos... ]),
/// )
/// ```
///
/// Faz três coisas, e as três são necessárias:
///
/// 1. **Desabilita os inputs do DS** pelo [CoreflowBusyScope]. `AbsorbPointer`
///    sozinho NÃO resolve: ele bloqueia ponteiro, e um campo que já está com
///    foco continua recebendo o teclado. Era exatamente esse o furo — botão
///    girando e a senha ainda editável.
/// 2. **Tira o foco** ao travar, o que recolhe o teclado e deixa claro que a
///    tela saiu do modo de edição.
/// 3. **Bloqueia toque** no resto do conteúdo, que não é input (tiles,
///    seletores, links).
///
/// O que NÃO faz: limpar o que foi digitado. Se a ação falhar, o usuário volta
/// exatamente para onde estava — perder o preenchimento por um erro de rede é
/// pior que o próprio erro.
class CoreflowBusy extends StatefulWidget {
  const CoreflowBusy({
    super.key,
    required this.busy,
    required this.child,
    this.dim = 0.55,
  });

  final bool busy;
  final Widget child;

  /// Opacidade enquanto trava. O apagado é o sinal de "não mexe agora" — sem
  /// ele o toque morre em silêncio e parece bug.
  final double dim;

  @override
  State<CoreflowBusy> createState() => _BoldBusyState();
}

class _BoldBusyState extends State<CoreflowBusy> {
  @override
  void didUpdateWidget(CoreflowBusy old) {
    super.didUpdateWidget(old);
    // Ao TRAVAR, solta o foco: sem isto o teclado fica aberto sobre um campo
    // desabilitado, e o usuário digita no vazio.
    if (widget.busy && !old.busy) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoreflowBusyScope(
      busy: widget.busy,
      child: AnimatedOpacity(
        duration: DilettaMotion.short,
        opacity: widget.busy ? widget.dim : 1,
        child: AbsorbPointer(absorbing: widget.busy, child: widget.child),
      ),
    );
  }
}
