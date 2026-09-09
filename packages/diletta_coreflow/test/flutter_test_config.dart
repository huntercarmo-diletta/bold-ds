/// A FONTE DE VERDADE nos testes deste pacote — a mesma decisão do primeiro filho: o `flutter_test`
/// roda com uma fonte em que todo glifo é um quadrado de 1em, 76% mais larga que a Inter, e quem
/// mede layout com ela mede uma tela que não existe.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loaders = [FontLoader('Inter'), FontLoader('packages/diletta_coreflow/Inter')];
  var carregadas = 0;
  for (final arquivo in const [
    'Inter-Regular.ttf', 'Inter-Medium.ttf', 'Inter-SemiBold.ttf', 'Inter-Bold.ttf', 'Inter-ExtraBold.ttf',
  ]) {
    final f = File('assets/fonts/$arquivo');
    if (!f.existsSync()) continue;
    for (final l in loaders) {
      l.addFont(f.readAsBytes().then((b) => ByteData.sublistView(b)));
    }
    carregadas++;
  }
  if (carregadas == 0) {
    throw StateError('nenhuma fonte carregada de assets/fonts — os gates mediriam com a fonte quadrada');
  }
  for (final l in loaders) {
    await l.load();
  }
  await testMain();
}
