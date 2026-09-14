// OS GATES QUE O IB NÃO TEM.
//
// O Internet Banking mantém os tokens de cor, tipo, espaço e raio transcritos à mão a partir do Dart
// deste repo, e ZERO gates ligando a transcrição à fonte — então a pergunta "isto ainda é a nossa
// cor?" não tem resposta lá. Estes existem pra que ela tenha resposta aqui, todo dia, de graça.
import 'dart:io';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css_do_bold.dart' show cssDoBold;

/// As colisões DECLARADAS entre o esquema deste produto e os papéis do avô.
///
/// Colidir é o mecanismo, não o defeito: o produto declara `primary` e o dele ganha do papel genérico
/// da linguagem, que é o white label acontecendo na cascata. O `border` colide com o MESMO valor, e
/// fica na lista porque ausência calada não conta.
///
/// **O gate não proíbe colisão — proíbe colisão que ninguém declarou.** A terceira que aparecer sem
/// entrar aqui é um papel do avô sendo roubado sem ninguém ver.
const _colisoesDeclaradas = {'primary', 'border'};

void main() {
  test('o CSS emitido é o que está no disco', () {
    final f = File('../coreflow_design_system_web/tokens/bold-tokens.css');
    expect(f.existsSync(), isTrue,
        reason: 'bold-tokens.css não existe — rode `flutter test test/emite_o_css_do_bold.dart`');
    expect(
      f.readAsStringSync(),
      cssDoBold(),
      reason: 'o CSS do disco divergiu da fonte. Alguém editou à mão, ou a tinta mudou e ninguém '
          'reemitiu: `flutter test test/emite_o_css_do_bold.dart`',
    );
  });

  test('a folha cobre os mesmos papéis de cor que o avô', () {
    final nossos = RegExp(r'--cps-([A-Za-z]+):')
        .allMatches(coreflowPapeisCss(BoldPalette.bold, produto: 'x'))
        .map((m) => m.group(1)!)
        .toSet();
    final semTinta = dilettaNomesDePapelGen.where((p) => !nossos.contains(p)).toList();
    // Os dois sem tinta são do avô e declarados por ele (`glassStroke`, `skeletonShimmer`). O que
    // este gate proíbe é um TERCEIRO aparecer sem ninguém ver.
    expect(semTinta.length, lessThanOrEqualTo(2),
        reason: 'papéis sem tinta na folha do Bold: $semTinta');
  });

  test('o esquema do produto só sobrescreve o que está declarado', () {
    Set<String> nomes(String css) =>
        RegExp(r'--cps-([A-Za-z]+):').allMatches(css).map((m) => m.group(1)!).toSet();
    final doAvo = nomes(coreflowPapeisCss(BoldPalette.bold, produto: 'x'));
    final doProduto = nomes(coreflowEsquemaCss(BoldPalette.bold));
    expect(doProduto.intersection(doAvo), _colisoesDeclaradas,
        reason: 'o esquema deste produto sobrescreve papel do avô fora da lista declarada — '
            'ou o avô ganhou um papel com nome que já era nosso. Os dois casos pedem decisão, '
            'não uma linha a mais na constante.');
  });

  test('a escala de tipo emitida tem os 20 degraus do CoreflowType', () {
    final degraus = RegExp(r'--cps-type-([A-Za-z0-9]+)-size:')
        .allMatches(cssDoBold())
        .map((m) => m.group(1)!)
        .toSet();
    // A tabela do emissor é escrita à mão porque `TextStyle` estático não se enumera. Este número é
    // a catraca: degrau novo no `CoreflowType` sem entrar na tabela reprova aqui.
    expect(degraus.length, 20, reason: 'degraus emitidos: ${degraus.length} — a tabela do emissor '
        'ficou para trás do CoreflowType, ou alguém a encolheu');
  });
}
