import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAbsoluteColors;
import 'package:flutter/widgets.dart';

/// **CoreflowElevacao** — as três sombras deste produto.
///
/// Vieram de `lib/design_system/theme/bold_metrics.dart` do app em 01/09, e lá elas eram hex cru
/// dentro de uma classe de métrica. São poucas de propósito: este produto eleva por MATERIAL (o
/// vidro, a superfície elevada da paleta) e usa sombra em três lugares só.
///
/// **O que NÃO veio junto:** a `nav({dark})`, com zero chamada nas 155 telas. Sombra sem chamador é
/// dívida disfarçada de patrimônio.
///
/// ## Por que não são as do pai
///
/// O pai tem a escada inteira (`low`/`medium`/`soft`/`overlay`/`heavy`) e o par de marca
/// (`brandLowDe(paleta)` e companhia). As três daqui não são degrau dessa escada:
///
/// - a [glow] é a **auréola da marca** sob um spot herói, e a forma mais próxima no pai — o
///   `heroLift(base)` — está `@Deprecated` desde 30/07 com a razão *"zero chamada na família"*.
///   **Este produto tem seis**, com outro alfa (0,40 contra 0,35) e outro blur (26 contra 24).
///   Está escrito como aviso ao pai: peça que se deprecia por contagem some debaixo de quem já usa
///   a forma dela com outro número;
/// - a [raised] usa preto a **55%**, e a escada de alfa do pai pula de 40 pra 85. Ela deriva do
///   absoluto dele em vez de cravar um sétimo hex — por isso não é `const`.
class CoreflowElevacao {
  CoreflowElevacao._();

  /// Rente à superfície: preto a 40% · (0,1) · blur 2. O par apagado do [glow] no cartão de
  /// escolha — quando o cartão não está escolhido, ele não brilha, ele só assenta.
  static const List<BoxShadow> rente = [
    BoxShadow(color: DilettaAbsoluteColors.blackAlpha40, blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Cartão que sai da página: preto a **55%** · (0,12) · blur 30.
  ///
  /// Não é `const` porque o 55% não existe na escada de absolutos do pai, e derivar do preto dele é
  /// melhor que cravar um hex que ninguém encontra depois.
  static List<BoxShadow> get destacada => [
        BoxShadow(
          color: DilettaAbsoluteColors.black.withValues(alpha: 0.55),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];

  /// A AURÉOLA DA MARCA: a cor pedida a [opacidade] · (0,10) · blur 26.
  ///
  /// Os seis sítios deste produto passam o papel `primary` do esquema — então **um filho já ganha a
  /// auréola dele** sem tocar nesta função. A cor entra por parâmetro justamente pra isso: sombra de
  /// marca com a cor cravada é a única que não viaja.
  static List<BoxShadow> auroleo(Color cor, {double opacidade = 0.4}) => [
        BoxShadow(
          color: cor.withValues(alpha: opacidade),
          blurRadius: 26,
          offset: const Offset(0, 10),
        ),
      ];
}
