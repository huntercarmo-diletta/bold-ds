/// A FONTE DE VERDADE nos testes deste pacote.
///
/// O `flutter_test` roda com uma fonte de fallback em que **todo glifo é um quadrado de 1em**, e quem mede
/// LAYOUT com ela mede uma tela que não existe. A diferença, medida aqui:
///
/// ```
/// 'Seu saldo' em labelLg · fonte de teste  → 138,6px
/// 'Seu saldo' em labelLg · Inter           →  78,7px
/// ```
///
/// **76% mais larga.** Isso invalidou números que eu já tinha reportado ao pai: o estouro do
/// `BoldSegmentos` que eu disse ser de 22px num telefone de 390 foi medido na fonte quadrada. O defeito era
/// real (nada apertava o texto), o NÚMERO era um teto.
///
/// Duas coisas que este arquivo aprendeu, e as duas são silenciosas:
///
/// 1. **quem aplica a família é o `ThemeData` do app hospedeiro**, não o `DilettaType`. Sem
///    `theme: ThemeData(fontFamily: ...)` no `MaterialApp` do teste, o texto sai na fonte quadrada mesmo com
///    o `FontLoader` carregado;
/// 2. **o nome da família importa**: `Inter` cru e `packages/conta_bold_design_system/Inter` são duas
///    famílias diferentes pro engine. Registrar só uma deixa metade do texto na fonte errada, e nada falha.
library;

import 'dart:async';
import 'dart:io';

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  var carregadas = 0;
  final loaders = [FontLoader(BoldFonts.familyRaw), FontLoader(BoldFonts.family)];
  for (final arquivo in const [
    'Inter-Regular.ttf',
    'Inter-Medium.ttf',
    'Inter-SemiBold.ttf',
    'Inter-Bold.ttf',
    'Inter-ExtraBold.ttf',
  ]) {
    final f = File('assets/fonts/$arquivo');
    if (!f.existsSync()) continue;
    for (final l in loaders) {
      l.addFont(f.readAsBytes().then((b) => ByteData.sublistView(b)));
    }
    carregadas++;
  }
  if (carregadas == 0) {
    throw StateError('nenhuma fonte carregada de assets/fonts — os gates de layout deste pacote '
        'passariam a medir com a fonte quadrada do flutter_test');
  }
  for (final l in loaders) {
    await l.load();
  }

  await testMain();
}
