@Tags(['ferramenta'])
library;

import 'dart:io';

import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/builder/screen_specs.g.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'telas_de_loja.dart';

/// FERRAMENTA, não gate: escreve `builder/screen_specs.g.dart` a partir das telas declaradas em
/// `telas_de_loja.dart` mais as que já estavam no arquivo.
///
/// O compositor é quem grava este arquivo no fluxo normal. Aqui a tela nasce escrita, então a
/// gravação precisa do mesmo gerador — senão o gate `as specs são função pura do estado` reprova, e
/// com razão: duas formas de escrever o mesmo arquivo é o começo de duas fontes.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  test('escreve as telas', () {
    final todas = <String, String>{...kScreenSpecsJson, ...kTelasDeLoja};
    final normalizadas = {
      for (final e in todas.entries)
        e.key: encodeSpec(decodeSpecCom(e.value, registro: Ds.blocos)),
    };
    // A ordem do arquivo é a das CHAVES ordenadas — é o que o gerador do pai faz, e é o que faz
    // duas gravações seguidas darem o mesmo texto.
    File(Conteudo.caminhoDoArquivoDeSpecs)
        .writeAsStringSync(gerarScreenSpecsDart(normalizadas));
  });
}
