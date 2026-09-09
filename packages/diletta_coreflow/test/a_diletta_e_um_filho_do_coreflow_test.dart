import 'dart:io';

import 'package:diletta_coreflow/diletta_coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// A DILETTA É UM FILHO DO COREFLOW — pela porta de UMA cor, e o pai não sabe que ela existe.
///
/// O que este gate mede é a promessa do white label: declarar uma cor, um logo e uma fonte e receber
/// o tema inteiro — sem que nenhum valor de outro produto apareça na tela.
void main() {
  test('a cor da marca é a do símbolo, e o botão pinta com ela nos dois modos', () {
    expect(Diletta.produto.paleta.primary04, Diletta.vermelho,
        reason: 'a claridade do #E60000 pede o degrau 04 — medido em 09/09, e é o degrau de ação');
    for (final s in [Diletta.temaClaro.scheme, Diletta.temaEscuro.scheme]) {
      expect(s.primary, Diletta.vermelho, reason: 'o avô honra a marca declarada quando ela cabe');
      expect(dilettaContrastRatio(s.onPrimary, s.primary), greaterThanOrEqualTo(4.5),
          reason: 'texto sobre o botão: AA é o piso');
    }
  });

  test('a paleta passa na conformidade do avô com baseline vazia', () {
    expect(violacoesDeConformidade(Diletta.produto.paleta), isEmpty);
    expect(violacoesDosExtras(Diletta.produto.paleta), isEmpty);
  });

  test('o vocabulário do Coreflow chega declarado, derivado da rampa daqui', () {
    final extras = Diletta.produto.paleta.papeisExtras;
    for (final n in ['superficieElevada', 'superficiePressionada', 'fluxoSecundario', 'info',
        'vinhoMarca', 'vinhoTinta', 'vinhoLavagem']) {
      expect(extras[n], isNotNull, reason: '`$n` não veio — o daMarca deixou de declarar');
    }
    // O vinho é o DESTE produto: vermelho quase preto, não o do primeiro filho.
    final v = Diletta.esquemaEscuro.vinhoTinta;
    expect(v.r, greaterThan(v.g));
    expect(v.r, greaterThan(v.b));
  });

  test('a marca está declarada, e os dois arquivos existem e viram com o tema', () {
    expect(Diletta.marca.pacote, 'diletta_coreflow');
    expect(Diletta.temaClaro.brand, Diletta.marca);
    expect(Diletta.marca.logoTingePorCurrentColor, isTrue);
    for (final caminho in [Diletta.marca.logo, Diletta.marca.logoFull]) {
      expect(File(caminho).existsSync(), isTrue, reason: '$caminho não está no pacote');
    }
    final lockup = File(Diletta.marca.logoFull).readAsStringSync();
    expect('currentColor'.allMatches(lockup).length, 16,
        reason: 'as 16 letras do lockup dizem `currentColor`. Reexportou do Figma sem a edição?');
    expect(lockup, contains('fill="#E60000"'), reason: 'o símbolo perdeu o vermelho fixo');
    expect(lockup.contains('fill="#1F1F1F"'), isFalse, reason: 'sobrou letra em preto fixo');
    final simbolo = File(Diletta.marca.logo).readAsStringSync();
    expect(simbolo, contains('fill="#E60000"'));
    expect(simbolo.contains('currentColor'), isFalse, reason: 'o símbolo não vira com o tema');
  });

  test('a fonte viaja empacotada, e o tema a aplica uma vez', () {
    final pub = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
    final familias = (pub['flutter'] as YamlMap)['fonts'] as YamlList;
    expect((familias.first as YamlMap)['family'], 'Inter');
    for (final f in (familias.first as YamlMap)['fonts'] as YamlList) {
      expect(File((f as YamlMap)['asset'] as String).existsSync(), isTrue, reason: '${f['asset']}');
    }
    expect(File('assets/fonts/OFL.txt').existsSync(), isTrue, reason: 'a licença viaja junto');
    expect(Diletta.tipografia.familia, 'packages/diletta_coreflow/Inter');
    expect(Diletta.materialClaro.textTheme.bodyLarge?.fontFamily, 'packages/diletta_coreflow/Inter');
    expect(Diletta.materialEscuro.textTheme.labelSmall?.fontFamily, 'packages/diletta_coreflow/Inter');
  });

  test('nada deste pacote cita outro produto', () {
    // O pai não conhece os filhos, e os filhos não conhecem os irmãos. A régua é a do pai, em duas
    // colunas: NOME (símbolo de outro produto) e VALOR (hex cru fora da declaração da marca).
    final regua = RegExp(r'\bBold[A-Z]\w*|\bContaBold\b|Conta BOLD|coreflow_design_system');
    final hex = RegExp(r'0x[0-9A-Fa-f]{6,8}');
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      final s = f.readAsStringSync();
      expect(regua.hasMatch(s), isFalse, reason: '${f.path} cita outro produto');
      final hexes = hex.allMatches(s).map((m) => m.group(0)).toList();
      if (f.uri.pathSegments.last == 'diletta.dart') {
        expect(hexes, ['0xFFE60000'], reason: 'a única cor declarada é a do símbolo');
      } else {
        expect(hexes, isEmpty, reason: '${f.path} tem hex cru — cor nasce em `diletta.dart`');
      }
    }
  });

  for (final escuro in [false, true]) {
    testWidgets('a tela de exemplo pinta a marca da casa e não a da referência — ${escuro ? 'escuro' : 'claro'}',
        (t) async {
      await t.pumpWidget(MaterialApp(home: TelaDeExemploDiletta(escuro: escuro)));
      await t.pump(const Duration(milliseconds: 100));
      final cores = <int>{};
      for (final w in t.allWidgets) {
        for (final p in w.toDiagnosticsNode().getProperties()) {
          final v = p.value;
          if (v is Color) cores.add(v.toARGB32());
          if (v is BoxDecoration) {
            if (v.color != null) cores.add(v.color!.toARGB32());
          }
          if (v is TextStyle && v.color != null) cores.add(v.color!.toARGB32());
        }
      }
      expect(cores, contains(Diletta.vermelho.toARGB32()), reason: 'o vermelho da marca não chegou à tela');
      expect(cores, isNot(contains(DilettaPalette.referencia.primary04.toARGB32())),
          reason: 'o verde da referência do avô vazou — alguma peça não leu o produto');
      expect(find.text('Diletta'), findsOneWidget);
    });
  }
}
