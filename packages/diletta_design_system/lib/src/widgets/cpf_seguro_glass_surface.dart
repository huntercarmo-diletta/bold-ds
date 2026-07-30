import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';

/// CPF SEGURO — GlassSurface.
///
/// Superfície glassy única do DS. Encapsula a spec exata do glass effect:
/// **white @ 80% opacity + blur uniforme 10** (sigmaX=10, sigmaY=10).
///
/// Se um dia mudar a spec do glass no DS, muda aqui — propaga automático
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

  /// Blur uniforme aplicado à superfície. Spec do DS = 10.
  static const double _blur = 10;

  @override
  Widget build(BuildContext context) {
    // Tint vem do scheme (light = white@80, dark = tint escuro).
    final tint = DilettaTheme.schemeOf(context).glassTint;
    final surface = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
      child: ColoredBox(color: tint, child: child),
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: surface);
    }
    return ClipRect(child: surface);
  }
}
