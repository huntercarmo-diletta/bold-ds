import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpotIcon, DilettaSpotState;
import 'package:flutter/widgets.dart';

import 'bold_elevacao.dart' show CoreflowElevacao;
import 'bold_scheme.dart' show CoreflowScheme;

/// **CoreflowHeroi** — o spot grande com a AURÉOLA da marca por trás.
///
/// Cinco telas deste produto abrem com ele: o aguardo do KYC, a conta aprovada, os dois convites de
/// operador e a configuração de passkey. As cinco escreviam exatamente a mesma coisa — um
/// `DecoratedBox` circular com `CoreflowElevacao.auroleo(esquema.primary)` embrulhando um
/// `DilettaSpotIcon.heroi` no estado `primary`:
///
/// ```dart
/// DecoratedBox(
///   decoration: BoxDecoration(
///     shape: BoxShape.circle,
///     boxShadow: CoreflowElevacao.auroleo(CoreflowScheme.of(context).primary),
///   ),
///   child: const DilettaSpotIcon.heroi(icon: 'key-light', state: DilettaSpotState.primary),
/// )
/// ```
///
/// **Cinco cópias idênticas não são cinco decisões, são uma peça que faltou.** E a razão de a
/// auréola ficar por FORA continua valendo, escrita nos comentários que estas telas carregavam:
/// sombra de marca é receita da paleta, não da peça do pai — ele não tem eixo pra ela, e nem
/// deveria, porque a escada de elevação dele não é esta.
///
/// A cor da auréola sai do papel `primary` do esquema — então **um filho já ganha a auréola dele**
/// sem tocar nesta peça, que é a mesma razão pela qual `auroleo` recebe a cor por parâmetro.
class CoreflowHeroi extends StatelessWidget {
  const CoreflowHeroi(this.glifo, {super.key, this.estado = DilettaSpotState.primary});

  final String glifo;

  /// O estado do spot. Os cinco sítios usam `primary`, e o default é ele — mas um herói de erro ou
  /// de sucesso é a mesma peça com outro tom, e não uma segunda peça.
  final DilettaSpotState estado;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: CoreflowElevacao.auroleo(CoreflowScheme.of(context).primary),
        ),
        child: DilettaSpotIcon.heroi(icon: glifo, state: estado),
      );
}
