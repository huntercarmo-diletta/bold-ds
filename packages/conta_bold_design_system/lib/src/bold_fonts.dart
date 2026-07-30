/// CONTA BOLD — a fonte da marca.
///
/// **Inter** é a resposta, confirmada em 2026-07-29 pelo dono do produto. Ela precisava ser
/// confirmada porque o repo tinha TRÊS respostas: o código pedia `Poppins`, o `pubspec`
/// empacotava **Nunito** (5 pesos) mais JetBrains Mono, e o comentário da dependência dizia
/// "Inter — fonte principal do design system". O tema aplicava
/// `fontFamily: BoldType.fontFamily`, então o app pedia uma família que não estava
/// empacotada e o Flutter caía no fallback da plataforma: nem Poppins, nem Nunito.
///
/// O comentário da dependência era o único certo. O `pubspec` já traz `google_fonts`, então
/// há dois caminhos: empacotar os `.ttf` aqui (o que o primeiro filho faz, e o que não
/// depende de rede no primeiro launch) ou resolver por `google_fonts` no app. Empacotar é a
/// recomendação — fonte de marca que depende de download é fonte que às vezes não é a da
/// marca.
///
/// Os `TextStyle` do `DilettaType` não fixam família de propósito — eles herdam do tema.
/// Então o app consumidor aplica a fonte UMA vez:
///
/// ```dart
/// MaterialApp(theme: ThemeData(fontFamily: BoldFonts.family), …)
/// ```
///
/// ## Os arquivos ainda não estão aqui, e isto é o registro disso
///
/// [family] usa o prefixo `packages/<pkg>/<família>`, que é a forma do Flutter resolver
/// fonte que vem de um pacote — e só funciona depois de os `.ttf` entrarem em
/// `assets/fonts/` e serem declarados no `pubspec`. Declarar no `pubspec` antes de ter os
/// arquivos quebra o build, então a ordem é: arquivos, `pubspec`, e aí [empacotada] vira
/// `true`.
///
/// Enquanto [empacotada] for `false`, quem usa [family] recebe o fallback da plataforma —
/// que é exatamente o que o app já faz hoje, então não há regressão. O que há é o registro
/// de uma pendência que estava invisível.
///
/// Pesos necessários (os mesmos que o Nunito ocupa hoje): 400 · 500 · 600 · 700 · 800.
abstract final class BoldFonts {
  static const String package = 'conta_bold_design_system';

  /// Nome cru da família — o que o catálogo mostra e o que o Figma diz.
  static const String familyRaw = 'Inter';

  /// Família qualificada, pra `ThemeData.fontFamily` no app consumidor.
  static const String family = 'packages/$package/$familyRaw';

  /// `true` quando os arquivos da fonte viajam neste pacote.
  ///
  /// Existe pra a pendência ser LEGÍVEL por código em vez de virar folclore: o catálogo
  /// mostra o estado, e um teste pode cobrar. Mentira uniforme é pior que ausência.
  static const bool empacotada = false;

  /// A família monoespaçada que o Bold já empacota no app (JetBrains Mono).
  ///
  /// Registrada aqui porque resolve, do lado do produto, o buraco que o token `mono` do
  /// pai tem: o `mono` dele é a fonte da marca com tracking apertado, e não alinha em
  /// coluna. Dado técnico (CPF, chave, valor) é Poppins com dígitos TABULARES — isso é
  /// `DilettaType.numericSm`/`numericXs`, que entraram na v0.1.9 a pedido deste filho.
  /// Código é outra coisa, e código quer isto.
  static const String monoRaw = 'JetBrains Mono';
}
