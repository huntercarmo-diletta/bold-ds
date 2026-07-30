import 'package:flutter/widgets.dart';

/// CPF SEGURO — Box (caixa decorada).
///
/// Encapsula o `Container`/`DecoratedBox` decorado: raio, sombra, borda, cor,
/// gradiente e padding num só lugar, alimentados por **tokens** (`DilettaRadius`,
/// `DilettaElevation`, `CpfSeguroColors`, `DilettaGradients`). É a caixa
/// genérica que faltava — o `DilettaSurface` é scaffold de TELA (top/content/
/// bottom), não serve pra isso. Centraliza os `BorderRadius`/`decoration` crus
/// espalhados, matando drift e habilitando rebrand num ponto único.
///
/// `color` nulo = sem preenchimento (transparente), a menos que haja `gradient`.
class DilettaBox extends StatelessWidget {
  const DilettaBox({
    super.key,
    this.child,
    this.color,
    this.gradient,
    this.radius,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadow,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.clip = false,
  });

  final Widget? child;

  /// Cor de preenchimento (use um papel do tema: `DilettaTheme.schemeOf(context).surface`).
  final Color? color;

  /// Gradiente (use `DilettaGradients.*`). Tem prioridade sobre [color].
  final Gradient? gradient;

  /// Raio dos cantos (use `DilettaRadius.*`).
  final BorderRadiusGeometry? radius;

  /// Cor da borda (token). Nulo = sem borda.
  final Color? borderColor;
  final double borderWidth;

  /// Sombra (use `DilettaElevation.*`).
  final List<BoxShadow>? boxShadow;

  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  /// Clipa o conteúdo no raio (antiAlias).
  final bool clip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: radius,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
