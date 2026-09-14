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
abstract final class CoreflowRadius {
  const CoreflowRadius._();

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
  ///
  /// **Desde 14/09 ela é DEFAULT, não desenho.** Quem precisa do raio da folha lê
  /// `CoreflowScheme.formaDaFolha`, que devolve o que o produto declarou em `raioDeFolha` e cai
  /// aqui quando não declara. Cinco peças deste pacote desenhavam este número direto e ignoravam o
  /// produto; o gate `a_folha_segue_o_raio_declarado_test` não deixa voltar.
  static const double sheet = 22;

  /// 16 — a superfície de VIDRO (saldo, ladrilho, promocional, aviso, cabeçalho da Home).
  ///
  /// Estava escrita como `DilettaRadius.all16` em seis sítios e não tinha nome aqui: o número
  /// existia, a FAMÍLIA não. Desde 14/09 é o default de `CoreflowScheme.formaDoVidro`, e o valor é
  /// o mesmo do avô — aqui a coincidência é real, e é por isso que ela pode ser lida por nome.
  static const double vidro = 16;

  /// 24 — a pílula flutuante de navegação, o único elemento persistente da tela.
  ///
  /// O `///` da peça já registrava que o desenho pedia 26 e que 26 não é degrau da escada do avô.
  /// Continua sendo 24 por default; o que muda é que agora o produto pode declarar o dele.
  static const double nav = 24;

  /// Pílula inteira — botões, segmented, switches, nav.
  /// O pai usa 200; 999 e 200 desenham o mesmo em qualquer altura de controle.
  static const double pill = 999;

  static const BorderRadius fieldR = DilettaRadius.all16;
  static const BorderRadius cardR = DilettaRadius.all24;
  /// Os quatro cantos no raio de folha. **Nada deste pacote desenha com ela** desde 14/09 — ficou
  /// porque três folhas montadas à mão no app a leem (`raffle_dialogs.dart`), e elas têm o mesmo
  /// defeito que as cinco daqui tinham: só mudam de raio quando este número muda.
  static const BorderRadius sheetR = BorderRadius.all(Radius.circular(sheet));
  static const BorderRadius pillR = DilettaRadius.pillAll;
}
