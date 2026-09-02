import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A PEÇA DESTE PACOTE NÃO DESENHA SOZINHA — a varredura que veio do app junto com o código.
///
/// Ela morava em `app-newbold/test/a_tela_nao_desenha_sozinha_test.dart`, em três testes que
/// varriam `lib/design_system/` do app. Em 01/09 essa pasta deixou de existir: as 40 peças vieram
/// pra cá.
///
/// **Se o gate não viesse junto, a regra morria com a pasta** — e isso é pior que não ter tido a
/// regra, porque o número que ela protegia (zero) continuaria escrito em três documentos como se
/// alguém ainda estivesse conferindo.
///
/// A régua é a da fronteira, e ela é diferente da do app: aqui a cor NASCE. Hex é permitido onde
/// ela é declarada — a rampa, os gradientes, as sombras, o material do vidro — e proibido onde ela
/// é **usada**, dentro de um widget. As outras três colunas (`Colors.*` do Material, raio cravado,
/// degrau tipográfico) não têm exceção: o pai declara as três escadas.
void main() {
  /// Onde a cor NASCE. Fora daqui, hex num widget é uma cor que ninguém encontra depois.
  const declaram = {
    'bold_palette.dart',      // a rampa
    'bold_gradients.dart',    // as paradas dos gradientes
    'bold_elevacao.dart',     // as sombras
    'bold_vidro.dart',        // o material
    'bold_scheme.dart',       // os papéis, derivados da rampa
    'bold_fundamentos.dart',  // a tabela de fundamentos do catálogo
    'bold_selo_quantico.dart',// narrativa de marca (veredito do dono, 29/07)
    'bold_produto.dart',      // as instâncias de produto
    'bold_vinho.dart',        // o vinho da marca — três degraus, e é aqui que eles nascem
  };

  Iterable<File> pecas() => Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  String semComentario(File f) => f
      .readAsStringSync()
      .split('\n')
      .where((l) => !l.trimLeft().startsWith('//'))
      .join('\n');

  void cobraZero(String nome, RegExp padrao, String comoConsertar,
      {Set<String> isentos = const {}}) {
    final achados = <String, int>{};
    for (final f in pecas()) {
      final base = f.uri.pathSegments.last;
      if (isentos.contains(base)) continue;
      final n = padrao.allMatches(semComentario(f)).length;
      if (n > 0) achados[base] = n;
    }
    expect(achados, isEmpty, reason: '$nome. $comoConsertar\n$achados');
  }

  test('a cor de um widget vem do tema — nem `Colors.*`, nem hex', () {
    cobraZero('cor do Material dentro do pacote', RegExp(r'(?<![\w.])Colors\.\w+'),
        'O pai declara os absolutos em `DilettaAbsoluteColors` e os papéis no `CoreflowScheme`.');
    cobraZero('hex cru fora de onde a cor nasce', RegExp(r'Color\(0x[0-9A-Fa-f]{8}\)'),
        'Hex num widget é cor que ninguém encontra depois. Ela nasce na paleta.',
        isentos: declaram);
  });

  test('a forma vem da escada — raio cravado não', () {
    // Só o NÚMERO cru: `circular(CoreflowRadius.cardR)` passa, porque o valor é token.
    cobraZero('raio cravado', RegExp(r'BorderRadius\.circular\(\s*[\d.]+\s*\)'),
        'A escada é 0·2·4·8·16·24·32·40·pill — `CoreflowRadius` e `DilettaRadius`.');
  });

  test('o degrau tipográfico vem da escala — `fontSize` cravado não', () {
    // Cobra-se o DEGRAU (`fontSize:`), não todo `TextStyle`: peso num `TextSpan` filho é ÊNFASE, e
    // ele herda tamanho e família de cima.
    cobraZero('degrau tipográfico inventado', RegExp(r'fontSize:\s*[\d.]+'),
        'A escala é `CoreflowType` / `DilettaType`.',
        isentos: {'bold_selo_quantico.dart', 'bold_type.dart'});
  });

  test('e o gate SABE ver — a varredura enxerga peça', () {
    // Sem isto, um `listSync` que parasse de achar arquivo passaria os três testes acima medindo
    // nada. Foi assim que a fila anterior deste repo morreu.
    expect(pecas().length, greaterThan(30),
        reason: 'a varredura parou de achar peça — ela é que quebrou');
  });
}
