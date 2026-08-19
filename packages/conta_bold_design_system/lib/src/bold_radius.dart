/// CONTA BOLD — os RAIOS, e eles vieram do app em 19/08 junto com o tema.
///
/// Vieram porque o `ThemeData` deste pacote precisa de três deles (campo, card e folha) pra
/// montar `inputDecorationTheme`, `cardTheme` e `bottomSheetTheme`. Deixá-los no app faria o
/// tema do pacote declarar os números de novo — que é a duplicação que esta mudança existe pra
/// matar.
///
/// **Dois dos quatro derivam do pai, e a regra é casar por VALOR e nunca por nome.** O `card` é
/// a razão de a regra estar escrita: `DilettaRadius.card` vale 16 e o card do Bold desenha 24.
/// Casar pelo nome mudaria 36 cantos, compilaria e não avisaria ninguém.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Cantos generosos em tudo; controles são pílula inteira.
abstract final class BoldRadius {
  const BoldRadius._();

  /// 16 — `DilettaRadius.all16`.
  static const double field = 16;

  /// 24 — `DilettaRadius.all24`, e **não** `DilettaRadius.card` (que é 16).
  static const double card = 24;

  /// 22 — **o último raio fora da escada do pai**, e ele é o único que sobrou.
  ///
  /// A escada dele é 0·2·4·8·16·24·32·40·56·200 e a folha dele é 24. O item `raioDeFolha` está
  /// ABERTO no ledger do pai, levantado pelo primeiro filho, e este produto é o segundo número da
  /// mesma pergunta — dois filhos com folha de 22 contra a folha de 24 da linguagem. Nota enviada
  /// em 18/08.
  static const double sheet = 22;

  /// Pílula inteira — botões, segmented, switches, nav.
  /// O pai usa 200; 999 e 200 desenham o mesmo em qualquer altura de controle.
  static const double pill = 999;

  static const BorderRadius fieldR = DilettaRadius.all16;
  static const BorderRadius cardR = DilettaRadius.all24;
  static const BorderRadius sheetR = BorderRadius.all(Radius.circular(sheet));
  static const BorderRadius pillR = DilettaRadius.pillAll;
}
