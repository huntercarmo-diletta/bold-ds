import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';

/// GlassSurface.
///
/// Superfície glassy única do DS. Encapsula **como** se constrói vidro — o clip
/// colado no `BackdropFilter`, o tinte por cima, e a regra de não pôr sombra
/// atrás (sombra atrás de vidro é reamostrada pelo filtro e vira halo sujo).
///
/// **A receita é do FILHO, a construção é do pai.** Os três valores saem da
/// paleta e chegam pelo scheme:
///
/// | | de onde | nulo ⇒ |
/// |---|---|---|
/// | tinte | `tinteDeVidroClaro/Escuro` (v0.1.9) | branco@80 · `neutral01`@80 |
/// | blur | `blurDeVidro` (v0.4.0) | 10 |
/// | traço | `tracoDeVidroClaro/Escuro` (v0.4.0) | sem traço |
///
/// O blur e o traço entraram por medição de um segundo filho: 18 leituras de
/// vidro em 7 componentes dele, com blur 15 e traço de 1px — e a razão do traço
/// escrita no código dele, "a borda branca sumia sobre fundo claro".
///
/// Se um dia mudar a CONSTRUÇÃO do glass, muda aqui — propaga automático
/// pra TopAppBar, BottomChatBar, BottomActionBar, ChatTopBar, Toast, Sheet.
///
/// Glass é **característica** de containers, não de elementos. Se um elemento
/// aparece com glass, é porque o container acima dele é glass — não porque
/// ele próprio é. StatusBar, ChatHeader, HomeIndicator NUNCA são glass sozinhos.
///
/// ```dart
/// DilettaGlassSurface(
///   child: Column(children: [statusBar, header, progress]),
/// )
/// ```
class DilettaGlassSurface extends StatelessWidget {
  const DilettaGlassSurface({super.key, required this.child, this.borderRadius});

  final Widget child;

  /// Radius opcional — cards glass arredondados (ex: instruções do
  /// "Aproxime do cartão"). O clip PRECISA ser o pai direto do
  /// BackdropFilter (clip duplo/afastado deixa o blur vazar pra tela toda),
  /// por isso o radius é param daqui e não um ClipRRect por fora.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    Widget surface = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: s.glassBlur, sigmaY: s.glassBlur),
      child: ColoredBox(color: s.glassTint, child: child),
    );
    // O traço vai como `foregroundDecoration`: pinta POR CIMA do vidro sem entrar no layout, e
    // com o mesmo radius do clip. Borda por fora do clip ficaria meio pixel deslocada do
    // arredondamento — e é o arredondamento que denuncia.
    if (s.glassStroke != null) {
      surface = Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: s.glassStroke!, width: 1),
          borderRadius: borderRadius,
        ),
        child: surface,
      );
    }
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: surface);
    }
    return ClipRect(child: surface);
  }
}
