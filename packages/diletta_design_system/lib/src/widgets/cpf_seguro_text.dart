import 'package:flutter/widgets.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — Text (primitivo instrumentado).
///
/// Wrapper de [Text] com dev inspect — mostra o preset de tipografia, tamanho,
/// peso, altura de linha e a cor (por token). Drop-in pra `Text(str, style:)`
/// em qualquer texto SOLTO das telas de handoff. Consome o subsistema
/// [DilettaDevInfo]/[DilettaDevMode] (import acima).
class DilettaText extends StatelessWidget {
  const DilettaText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : spans = null;

  /// Variante rica: trechos (spans) com estilos diferentes, sem `RichText`/
  /// `TextSpan` cru espalhado. `style` é o estilo base herdado pelos spans.
  const DilettaText.rich(
    this.spans, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : data = null;

  final String? data;
  final List<InlineSpan>? spans;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final Widget text = spans != null
        ? Text.rich(
            TextSpan(style: style, children: spans),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap,
          )
        : Text(
            data!,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap,
          );
    if (!DilettaDevMode.of(context)) return text;
    final sz = style?.fontSize;
    final h = style?.height;
    // `.index` (0..8) estava depreciado; `.value` JÁ é o peso (100..900), então a conta
    // `(index + 1) * 100` tinha que sair junto — trocar só o getter daria `w100` virando
    // 10100 no dev inspect. Substituição de API depreciada quase nunca é drop-in.
    final peso = style?.fontWeight?.value;
    final weight = peso == null ? '' : ' · $peso';
    final line = (sz != null && h != null) ? ' · lh ${(sz * h).round()}' : '';
    return DilettaDevInfo(
      component: spans != null ? 'Text.rich' : 'Text',
      props: {'"${data ?? '(rich)'}"': ''},
      tokens: [
        'type: ${cpfSeguroTypeToken(style)}${sz != null ? ' (${sz.toInt()}px$weight$line)' : ''}',
        'color: ${nomeDoToken(context, style?.color)}',
      ],
      child: text,
    );
  }
}
