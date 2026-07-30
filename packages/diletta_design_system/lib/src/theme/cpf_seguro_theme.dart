import 'package:flutter/widgets.dart';
import 'cpf_seguro_palette.dart';
import 'cpf_seguro_scheme.dart';
import 'diletta_brand_assets.dart';

/// CPF SEGURO — Theme (tier 3, resolvido + provido).
///
/// Amarra **flavor** ([DilettaPalette]) + **modo** ([Brightness]) num
/// [DilettaScheme] resolvido, e distribui pela árvore via [InheritedWidget].
/// Widget consome com `DilettaTheme.of(context)`.
///
/// Trocar de flavor OU de modo = trocar o [DilettaThemeScope] que envolve a
/// tela; todo mundo abaixo repontar. É assim que o SDK white-label e o
/// dark/light vão funcionar sem tocar em cada widget.
@immutable
class DilettaTheme {
  const DilettaTheme({required this.scheme, this.brand = DilettaBrand.nenhuma});

  /// Constrói a partir de flavor + modo (atalho comum).
  /// O default é a paleta de REFERÊNCIA, não a de um produto.
  ///
  /// Era `DilettaPalette.cpf`: quem chamasse `resolve()` sem argumento recebia a
  /// marca do CPF SEGURO como se fosse o padrão da linguagem. O filho tem o
  /// próprio `resolve` com o default dele — é lá que produto entra.
  DilettaTheme.resolve({
    DilettaPalette palette = DilettaPalette.referencia,
    Brightness brightness = Brightness.light,
    this.brand = DilettaBrand.nenhuma,
  }) : scheme = brightness == Brightness.dark
            ? DilettaScheme.dark(palette)
            : DilettaScheme.light(palette);

  final DilettaScheme scheme;

  /// Os arquivos de MARCA deste tema (logo, cobrand). Viajam aqui pela mesma razão
  /// que a paleta viaja: são identidade, e identidade chega pelo scope.
  final DilettaBrand brand;

  DilettaPalette get palette => scheme.palette;
  Brightness get brightness => scheme.brightness;
  bool get isDark => scheme.isDark;

  /// Tema da paleta de REFERÊNCIA — o default da linguagem, de marca nenhuma.
  ///
  /// Os atalhos `cpfLight`/`cpfDark` moravam aqui, e eram identidade de produto
  /// dentro do pai. Foram pro filho (`CpfSeguroTheme`), onde o app continua
  /// achando eles pelo mesmo nome.
  static final DilettaTheme referenciaLight =
      DilettaTheme.resolve(palette: DilettaPalette.referencia);
  static final DilettaTheme referenciaDark = DilettaTheme.resolve(
      palette: DilettaPalette.referencia, brightness: Brightness.dark);

  /// Lê o tema do contexto. Sem scope, cai na paleta de REFERÊNCIA — o default da
  /// linguagem, que não é a marca de ninguém.
  static DilettaTheme of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<DilettaThemeScope>();
    // Sem scope cai na REFERÊNCIA, não num produto. Se isto pintar verde em algum
    // lugar, o lugar está sem `DilettaThemeScope` — e é melhor descobrir assim do
    // que herdando a marca de um filho por acidente.
    return scope?.theme ?? referenciaLight;
  }

  static DilettaScheme schemeOf(BuildContext context) => of(context).scheme;

  /// Constrói lendo o SCHEME em lugar que não tem `context`.
  ///
  /// Existe por causa de um padrão que apareceu três vezes na dívida de primitiva
  /// crua: **construtor de VALOR estático** (`DilettaRightAccessory.time(...)`),
  /// `CustomPainter` e callback. Nenhum dos três recebe `context`, então quem
  /// escreveu pintou a primitiva direto e deixou um comentário dizendo que era
  /// dívida "sem saída". Tinha saída, e é uma linha.
  ///
  /// ```dart
  /// static DilettaRightAccessory time({required String time, bool disabled = false}) =>
  ///     _RightCustom(child: DilettaTheme.comEsquema((s) => Text(time,
  ///         style: DilettaType.caption.copyWith(
  ///             color: disabled ? s.textDisabled : s.textTertiary))));
  /// ```
  ///
  /// A leitura acontece no `build` do [Builder], já dentro da árvore — então o
  /// acessório recebe a identidade do filho e reage ao tema, sem mudar uma vírgula
  /// da API pública de quem chama.
  static Widget comEsquema(Widget Function(DilettaScheme s) constroi) =>
      Builder(builder: (ctx) => constroi(schemeOf(ctx)));
}

/// Envolve uma subárvore com um [DilettaTheme]. Colocar na raiz da tela
/// (ou do phone shell) e trocar pra alternar modo/flavor.
class DilettaThemeScope extends InheritedWidget {
  const DilettaThemeScope({
    super.key,
    required this.theme,
    required super.child,
  });

  final DilettaTheme theme;

  @override
  bool updateShouldNotify(DilettaThemeScope oldWidget) =>
      oldWidget.theme.scheme != theme.scheme;
}
