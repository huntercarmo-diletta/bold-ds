import 'package:flutter/widgets.dart';

import 'bold_radius.dart' show CoreflowRadius;
import 'bold_scheme.dart' show CoreflowScheme;

/// **CoreflowPegador** — a barrinha de arrastar no topo de uma folha, e ela tinha DUAS receitas.
///
/// 40 × 4, canto pill. O que divergia era a tinta, e a divergência é a razão desta peça existir:
///
/// | onde | tinta |
/// |---|---|
/// | `CoreflowFolha` (o lançador) | `textMuted` @ 50% |
/// | as cinco folhas montadas à mão nas telas | `textPrimary` @ 40 (de 255, ≈16%) |
///
/// **O mesmo objeto, dois cinzas.** Nenhum dos dois está errado sozinho; ter os dois é o defeito.
/// Uma folha aberta pelo lançador e uma folha montada à mão na tela seguinte mostravam pegadores
/// diferentes, e ninguém tinha como ver os dois lado a lado.
///
/// A tinta que ficou é a do lançador (`textMuted` a 50%), porque ela é PAPEL: acompanha o tema e a
/// paleta. O `textPrimary` a 16% é a mesma ideia derivada à mão, e derivar à mão é como se chega a
/// dois valores.
///
/// **Isto não fecha o pedido do pegador** (o de 21/08, sobre o porte e a tinta cheia): aquele é
/// sobre o pegador DELE. Este resolve a divergência interna deste produto, que é o que estava na
/// minha mão.
/// **O respiro fica de fora**, na regra do dono: *"o padding a gente arruma por fora, na tela, não
/// dentro do componente"*. O lançador embrulha num `Padding`; as folhas montadas à mão já tinham o
/// `SizedBox` delas.
class CoreflowPegador extends StatelessWidget {
  const CoreflowPegador({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: CoreflowScheme.of(context).textMuted.withValues(alpha: 0.5),
          // `pillR` e não `circular(2)`: numa barra de 4 de altura os dois dão o mesmo pixel, e
          // o nome diz a FORMA em vez de repetir metade da altura como número.
          borderRadius: CoreflowRadius.pillR,
        ),
      );
}
