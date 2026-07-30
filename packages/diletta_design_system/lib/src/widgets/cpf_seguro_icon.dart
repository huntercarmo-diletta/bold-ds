import 'package:flutter/widgets.dart';
import 'cpf_seguro_assets.dart';
import 'cpf_seguro_dev_inspect.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// CPF SEGURO — Icon.
///
/// Renderiza um ícone do kit por nome (sem extensão). Paridade com o Icon do
/// React — mesmo naming (ex: `angle-right-light`, `bell-light`,
/// `user-viewfinder-light-full`).
///
/// **Entrega precompilada (`.vec`).** O source é SVG (`svg_src/icons/`,
/// exportado do Figma, não vai no bundle). O build compila cada SVG num binário
/// `vector_graphics` (`assets/icons/<name>.svg.vec`, gerado por
/// `tool/gen_icons_vec.sh`) e é esse que é shippado e renderizado via
/// [VectorGraphic]. Sem parse de XML em runtime; a Picture decodificada é
/// cacheada pelo [AssetBytesLoader].
///
/// A cor é aplicada via [ColorFilter.srcIn], então ícones monocromáticos
/// respeitam o [color]. Ícones multicoloridos (badges, marca) usam [color]
/// apenas se explicitamente passado.
///
/// A resolução package-vs-catálogo é nativa via
/// [DilettaAssets.assetPackage] (`AssetBytesLoader(packageName:)`).
///
/// ```dart
/// DilettaIcon(name: DilettaIcons.bellLight, size: 18, color: DilettaTheme.schemeOf(context).textSecondary),
/// DilettaIcon(name: DilettaIcons.userLight),  // 18px default, currentColor via DefaultTextStyle
/// ```
class DilettaIcon extends StatelessWidget {
  const DilettaIcon({
    super.key,
    required this.name,
    this.size = 18,
    this.color,
    this.semanticLabel,
  });

  /// Nome do arquivo em `assets/icons/`, sem extensão.
  final String name;

  /// Lado do bounding box (o ícone é quadrado). Default 18.
  final double size;

  /// Cor aplicada via ColorFilter. Null = herda do `DefaultTextStyle`.
  final Color? color;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effective = color ?? DefaultTextStyle.of(context).style.color;
    final filter = effective == null
        ? null
        : ColorFilter.mode(effective, BlendMode.srcIn);

    return DilettaDevInfo(
      component: 'DilettaIcon',
      props: {'name': name, 'size': '${size.toInt()}'},
      tokens: [
        'color: ${nomeDoToken(context, effective)}',
        'asset: assets/icons/$name.svg.vec (precompiled)'
      ],
      child: VectorGraphic(
        loader: DilettaAssets.vecLoader('assets/icons/$name.svg.vec'),
        width: size,
        height: size,
        colorFilter: filter,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}
