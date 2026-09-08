import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// QUEM LÊ O `primary` DO AVÔ SE EXPLICA — e os quatro que podem estão listados com a razão.
///
/// Um produto desta linguagem tem DOIS `primary`: o do avô (`DilettaTheme.schemeOf`, o rosa da
/// marca no primeiro produto) e o do `CoreflowScheme` (o degrau profundo no claro, escolhido pra
/// passar contraste como tinta). No escuro os dois coincidem, e é por isso que uma troca errada
/// sobrevive: ela só aparece num modo. A varredura de 02/09 achou cinco leitores do avô no filho;
/// quatro pintavam (legítimo) e um escrevia texto pequeno a 2,63:1 (defeito).
///
/// Os quatro legítimos vieram pro pai em 08/09 com a peça deles. A régua veio junto: peça nova
/// que leia o `primary` do avô se declara aqui, com a razão — ou lê o profundo do esquema.
void main() {
  test('quem lê o `primary` do avô está declarado, e o quinto tem que se explicar', () {
    // O que os torna legítimos é o mesmo: nenhum deles é TINTA sobre claro.
    const legitimos = {
      'lib/src/bold_autorizacao.dart': 'o tom da barra de progresso — superfície CHEIA, e o que '
          'precisa de contraste é o que vai por cima dela, não ela contra o fundo.',
      'lib/src/bold_cabecalho_da_home.dart': 'o anel do avatar quando há foto. O contraste é contra '
          'a FOTO, que é conteúdo arbitrário: nenhum dos dois degraus ganha essa por número.',
      'lib/src/bold_nav_flutuante.dart': 'o preenchimento da aba ativa — pintura, e a marca é o que '
          'ela tem que dizer.',
      'lib/src/bold_pontos_de_pagina.dart': 'o ponto da página atual. Objeto gráfico, piso 3,0, e a '
          'marca do primeiro produto dá 3,46:1 sobre branco.',
    };
    final lendo = <String>{};
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final s = f.readAsStringSync();
      final vars = RegExp(r'final\s+(\w+)\s*=\s*DilettaTheme\.scheme\w*\(')
          .allMatches(s)
          .map((m) => m.group(1)!)
          .toSet();
      for (final v in vars) {
        if (RegExp('\\b$v\\.primary\\b').hasMatch(s)) lendo.add(f.path);
      }
      if (RegExp(r'DilettaTheme\.scheme\w*\([^)]*\)\.primary\b').hasMatch(s)) lendo.add(f.path);
    }
    expect(lendo.difference(legitimos.keys.toSet()), isEmpty,
        reason: 'peça nova lendo o `primary` do avô. Se ela PINTA, declare aqui com a razão; se ela '
            'escreve, o `primary` é o do esquema — o profundo.');
    expect(legitimos.keys.toSet().difference(lendo), isEmpty,
        reason: 'declarado aqui e não lê mais — razão escrita sobre peça que mudou é documentação '
            'mentindo');
  });

  test('todo glifo que este pacote pede do avô existe no avô', () {
    // `VectorGraphic` com asset ausente não estoura: desenha caixa vazia. A seta que não desenha
    // é affordância invisível, e nenhum teste de árvore vê.
    final cfg = File('.dart_tool/package_config.json');
    final raiz = cfg.absolute.uri.resolve(
        '${RegExp(r'"name":"diletta_design_system","rootUri":"([^"]+)"').firstMatch(cfg.readAsStringSync().replaceAll(RegExp(r'\s+'), ''))!.group(1)}/');
    final noAvo = Directory.fromUri(raiz.resolve('assets/icons/'))
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last.replaceAll('.svg.vec', ''))
        .toSet();
    expect(noAvo, isNotEmpty, reason: 'não achei os glifos do avô — a régua está medindo o vazio');

    final quebrados = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      for (final m in RegExp(r"DilettaIcon\(\s*name:\s*'([a-z0-9-]+)'").allMatches(f.readAsStringSync())) {
        if (!noAvo.contains(m.group(1))) {
          quebrados.add('${f.path}: DilettaIcon(\'${m.group(1)}\') — o avô não tem esse asset');
        }
      }
    }
    expect(quebrados, isEmpty, reason: quebrados.join('\n'));
  });
}
