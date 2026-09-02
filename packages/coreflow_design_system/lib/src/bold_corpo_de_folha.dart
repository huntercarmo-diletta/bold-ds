import 'package:flutter/widgets.dart';

import 'bold_radius.dart' show CoreflowRadius;
import 'bold_scheme.dart' show CoreflowScheme;

/// **CoreflowCorpoDeFolha** — o painel de uma folha que a TELA monta, e ele tinha 13 cópias.
///
/// O [CoreflowFolha] é o LANÇADOR: ele abre um `showModalBottomSheet`, desenha o painel, o pegador e
/// o título. Só que treze folhas deste produto não são lançadas por ele — são
/// `DraggableScrollableSheet` montadas dentro da tela, porque precisam de rolagem própria e de
/// tamanho arrastável. Elas remontavam o painel à mão:
///
/// ```dart
/// Container(decoration: BoxDecoration(
///   color: cs.surface,
///   borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
/// ))
/// ```
///
/// **E o 24 estava errado nas treze.** O raio de folha deste produto é `CoreflowRadius.sheet`, que
/// vale **22** — o número está declarado desde a `v0.44.0` e o pedido de 22/08 ao pai é justamente
/// sobre o `r24` cravado na variante `.bottomsheet` dele. As folhas montadas à mão copiaram o
/// número do pai em vez de ler o do produto, e ninguém tinha como ver os dois pixels de diferença
/// numa folha por vez.
///
/// A superfície também variava: `surface`, `background` e uma que declarava `surface` com um
/// comentário explicando que branco fixo apagava o título. Aqui é `surface`, e quem precisa de
/// outra passa [cor].
class CoreflowCorpoDeFolha extends StatelessWidget {
  const CoreflowCorpoDeFolha({super.key, required this.child, this.cor});

  final Widget child;

  /// A superfície, quando ela não é a `surface` do tema.
  final Color? cor;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: cor ?? CoreflowScheme.of(context).surface,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(CoreflowRadius.sheet)),
        ),
        child: child,
      );
}
