/// A FONTE DE VERDADE nos testes deste app — a mesma decisão dos pacotes: o `flutter_test` roda com
/// uma fonte em que todo glifo é um quadrado, e o que este app prova inclui a Inter chegando pelo tema.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// De onde a fonte vem: o pacote do produto, por caminho de arquivo — o bundle de um teste não monta
/// o asset de um pacote irmão.
const _pastaDasFontes = '../../packages/diletta_coreflow/assets/fonts';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // O nome com o prefixo do pacote é o que o `ThemeData` do produto pede.
  final loader = FontLoader('packages/diletta_coreflow/Inter');
  var carregadas = 0;
  for (final arquivo in const [
    'Inter-Regular.ttf', 'Inter-Medium.ttf', 'Inter-SemiBold.ttf', 'Inter-Bold.ttf', 'Inter-ExtraBold.ttf',
  ]) {
    final f = File('$_pastaDasFontes/$arquivo');
    if (!f.existsSync()) continue;
    loader.addFont(f.readAsBytes().then((b) => ByteData.sublistView(b)));
    carregadas++;
  }
  if (carregadas == 0) {
    throw StateError('nenhuma fonte carregada de $_pastaDasFontes — o teste mediria com a fonte quadrada');
  }
  await loader.load();
  await testMain();
}
