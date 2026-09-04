import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A SEPARAÇÃO TEM NÚMERO — o ratchet dos 300.
///
/// `docs/2026-09-04-adr-o-coreflow-e-o-pai.md` mediu 300 referências ao Bold em `lib/` (33 dos 66
/// arquivos): 176 no que É do Bold, 109 em componentes `Coreflow*` que leem constante do Bold, 15
/// em comentário. O pai (`packages/coreflow`) só recebe componente quando esse componente marca
/// zero na régua — então o número aqui é o que FALTA separar, e ele só anda pra baixo.
///
/// A régua é lida do script, não repetida: `tool/levanta_a_separacao.sh --total` e este teste têm
/// que dar o mesmo número, e a única forma de dois medidores concordarem sempre é serem um só.
void main() {
  /// O teto de hoje. Desce a cada corte, no mesmo commit; nunca sobe.
  const teto = 300;

  late final RegExp regua;

  setUpAll(() {
    final script = File('tool/levanta_a_separacao.sh').readAsStringSync();
    final p = RegExp(r"^P='(.+)'$", multiLine: true).firstMatch(script);
    expect(p, isNotNull, reason: "o script perdeu a linha P='…' que este teste lê");
    regua = RegExp(p!.group(1)!);
  });

  int mede() {
    var n = 0;
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      for (final l in f.readAsLinesSync()) {
        n += regua.allMatches(l).length;
      }
    }
    return n;
  }

  test('as referências ao Bold em lib/ não passam do teto', () {
    final total = mede();
    expect(total, lessThanOrEqualTo(teto),
        reason: 'subiu: $total referências ao Bold em lib/ contra o teto de $teto. Separar é '
            'tirar, e o número novo entra no pai como componente — não aqui como const.');
  });

  test('e o teto acompanha a medida', () {
    // Ratchet honesto: quando um corte derruba o número, o teto desce no mesmo commit. Um teto
    // frouxo é um teto que deixa o próximo commit subir de volta sem ninguém ver.
    final total = mede();
    expect(total, teto,
        reason: 'mediu $total, teto diz $teto — desça o `teto` deste teste pra $total.');
  });

  test('toda classe/enum pública Bold* declarada aqui casa com a régua', () {
    // Fecha a classe "a regex deixou passar um nome novo": um `BoldQualquerCoisa` novo tem que
    // entrar na `P=` do script no mesmo commit, ou o número da separação mente pra baixo.
    final declara = RegExp(
        r'^\s*(?:(?:abstract|sealed|final|base|interface|mixin)\s+)*'
        r'(?:class|enum|mixin|extension(?:\s+type)?|typedef)\s+(Bold\w*)');
    final fora = <String>[];
    final vistos = <String>{};
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        final m = declara.firstMatch(linhas[i]);
        if (m == null) continue;
        final nome = m.group(1)!;
        vistos.add(nome);
        if (!regua.hasMatch(nome)) fora.add('${f.path}:${i + 1}  $nome');
      }
    }
    // As seis de hoje. Se a lista mudar, é decisão: a marca ganhou ou perdeu um símbolo.
    expect(vistos, {
      'BoldColors', 'BoldPalette', 'BoldSeloEstado', 'BoldSeloQuantico', 'BoldFonts', 'BoldVinho',
    });
    expect(fora, isEmpty,
        reason: 'símbolo Bold* declarado fora da régua do script:\n${fora.join("\n")}');
  });

  test('e a régua SABE ver o que procura', () {
    expect(regua.hasMatch('      color: BoldPalette.bold.primary04,'), isTrue);
    expect(regua.hasMatch('CoreflowProduto.bold.paleta'), isTrue);
    expect(regua.hasMatch('CoreflowProduto.boldo'), isFalse, reason: r'o \b do script vale aqui');
    expect(regua.hasMatch('FontWeight.bold'), isFalse);
  });
}
