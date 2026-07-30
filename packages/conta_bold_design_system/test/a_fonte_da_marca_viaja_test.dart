import 'dart:io';

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// A FONTE DA MARCA VIAJA NESTE PACOTE — e este teste mede os jeitos de isso ser mentira.
///
/// Fonte é o token mais fácil de declarar e não entregar, porque a falha é silenciosa: o
/// Flutter não reclama de família inexistente, ele cai no fallback da plataforma. Foi
/// exatamente o que este produto fazia — o código pedia uma família que o `pubspec` não
/// empacotava, e ninguém viu, porque texto continua aparecendo.
///
/// Os jeitos de isso ser mentira, e quem pega cada um — medido por regressão deliberada:
///
/// 1. **declarar e não copiar**: o próprio Flutter recusa o bundle ("unable to locate asset
///    entry"), antes de qualquer teste rodar. Mérito da toolchain, não meu — e por isso a
///    checagem de existência aqui é rede de segurança, não a linha de frente;
/// 2. **apagar a declaração junto com o arquivo**: aí o Flutter fica contente, porque nada foi
///    declarado. É o caso que o conjunto de pesos `{400…800}` pega — a fonte de verdade do
///    teste é o `pubspec` lido, não uma lista repetida aqui;
/// 3. **arquivo presente e corrompido ou truncado**: `FontLoader.load()` estoura, e o teste de
///    render é o que chega lá.
void main() {
  final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
  final familias = (pubspec['flutter'] as YamlMap)['fonts'] as YamlList;

  test('a família declarada é a que o código anuncia', () {
    expect(familias, hasLength(1), reason: 'uma família de marca, não duas');
    expect((familias.first as YamlMap)['family'], BoldFonts.familyRaw);
    expect(BoldFonts.family, 'packages/${BoldFonts.package}/${BoldFonts.familyRaw}');
    expect(BoldFonts.empacotada, isTrue,
        reason: 'o campo existe pra dizer a verdade sobre o pacote');
  });

  test('todo peso declarado tem ARQUIVO, e o mapa da tipografia usa os cinco', () {
    final pesos = <int>{};
    for (final f in (familias.first as YamlMap)['fonts'] as YamlList) {
      final m = f as YamlMap;
      final arquivo = File(m['asset'] as String);
      expect(arquivo.existsSync(), isTrue,
          reason: 'declarado no pubspec e ausente no disco: ${m['asset']}');
      expect(arquivo.lengthSync(), greaterThan(50000),
          reason: '${m['asset']} é pequeno demais pra ser uma fonte');
      pesos.add(m['weight'] as int);
    }
    // Os cinco degraus que o mapa da tipografia escolheu. Peso declarado a menos = peso que
    // cai no mais próximo, e aí `w600` renderiza como `w700` sem ninguém perceber.
    expect(pesos, {400, 500, 600, 700, 800});
  });

  test('a licença OFL viaja junto, porque ela mesma exige', () {
    // Inter é SIL Open Font License 1.1: redistribuir sem a licença é o tipo de dívida que
    // não aparece em teste nenhum até aparecer num lugar caro.
    final ofl = File('assets/fonts/OFL.txt');
    expect(ofl.existsSync(), isTrue);
    expect(ofl.readAsStringSync(), contains('SIL Open Font License'));
  });

  testWidgets('os cinco arquivos CARREGAM e o texto renderiza com a família', (t) async {
    // Este é o único que pega arquivo corrompido ou truncado: `FontLoader` estoura no load.
    final loader = FontLoader(BoldFonts.familyRaw);
    for (final f in (familias.first as YamlMap)['fonts'] as YamlList) {
      loader.addFont(
          rootBundle.load((f as YamlMap)['asset'] as String).then((d) => d));
    }
    await loader.load();

    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: BoldFonts.familyRaw),
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: const Scaffold(
          body: DilettaText('Conta BOLD', style: DilettaType.headlineMd),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    expect(t.takeException(), isNull);
    // A família chega no texto pelo TEMA, não pelo preset — os presets do pai não fixam
    // família de propósito, e é isso que faz uma linha no `ThemeData` alcançar tudo.
    final texto = t.widget<RichText>(find.byType(RichText).first);
    expect((texto.text.style?.fontFamily), BoldFonts.familyRaw);
  });
}
