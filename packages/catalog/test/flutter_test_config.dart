/// O GANCHO que o `flutter_test` roda antes de tudo.
///
/// As mesmas quatro chamadas do `main()`, e não é redundância: sem isto os testes
/// começam SEM DS plugado, e essa classe de erro não aparece como falha — aparece como
/// golden gravando a ausência do que ele deveria provar.
library;

import 'dart:async';

import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  configurarChromeDoBold();
  configurarDsDoBold();
  configurarConteudoDoBold();
  await testMain();
}
