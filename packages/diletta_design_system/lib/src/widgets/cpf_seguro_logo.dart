import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_assets.dart';
import 'cpf_seguro_dev_inspect.dart';

/// Variante do logo.
enum DilettaLogoVariant {
  /// Só o shield/símbolo (para top bars densas, favicon).
  mark,

  /// Símbolo + wordmark "CPF SEGURO" (áreas de branding).
  full,
}

/// CPF SEGURO — Logo oficial.
///
/// Consolida `CpfLogo` (mark) e `LogoCpfSeguro` (full/icon) do React em um
/// único widget. Aplica cor via `ColorFilter.srcIn` — SVG original é branco.
///
/// ```dart
/// DilettaLogo(),                                            // mark 40px, scheme.primary
/// DilettaLogo(variant: DilettaLogoVariant.full, size: 24),
/// DilettaLogo(color: DilettaAbsoluteColors.white, size: 32),           // sobre bg escuro
/// ```
class DilettaLogo extends StatelessWidget {
  const DilettaLogo({
    super.key,
    this.variant = DilettaLogoVariant.mark,
    this.size = 40,
    this.color,
  });

  final DilettaLogoVariant variant;

  /// Altura em px (mark é 1:1; full escala proporcionalmente).
  final double size;

  /// Cor do glyph. `null` = a cor de ação da marca (`scheme.primary`).
  ///
  /// Era `primary04` como DEFAULT const, e default const não alcança o tema: o
  /// logo de qualquer filho saía azul-CPF, e no escuro não clareava. Nulo com
  /// resolução no `build` é o que dá o default sem congelar o valor.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // O arquivo do logo é do FILHO; quem diz onde ele está é o plugue de marca.
    final tema = DilettaTheme.of(context);
    final asset = variant == DilettaLogoVariant.full
        ? tema.brand.logoFull
        : tema.brand.logo;
    final cor = color ?? tema.scheme.primary;
    return DilettaDevInfo(
      component: 'DilettaLogo',
      props: {'variant': variant.name, 'size': '${size.toInt()}'},
      tokens: ['color: ${nomeDoToken(context, cor)}', 'asset: $asset'],
      child: SvgPicture.asset(
        asset,
        // `package:` é obrigatório: o asset viaja NESTE package, então num app
        // consumidor a chave é `packages/cpf_seguro_design_system/<path>`. Sem
        // isso o logo simplesmente não aparece — e foi o que aconteceu quando o
        // DS deixou de ser o package raiz do catálogo.
        package: tema.brand.pacote ?? DilettaAssets.package,
        height: size,
        colorFilter: ColorFilter.mode(cor, BlendMode.srcIn),
        semanticsLabel: 'Logo',
      ),
    );
  }
}
