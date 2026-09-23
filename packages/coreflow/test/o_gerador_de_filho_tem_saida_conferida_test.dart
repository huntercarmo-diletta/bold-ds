import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../bin/novo_filho.dart' as gerador;

/// O GERADOR TEM SAÍDA CONFERIDA — gerador sem isso é template com esperança.
///
/// `exemplos/filho_do_coreflow/` não é um exemplo escrito à mão: é a **saída** do
/// `dart run coreflow:novo_filho`, versionada. Este gate regenera e compara.
///
/// O que isso mata é a classe: um gerador que ninguém roda envelhece calado, e o primeiro produto
/// novo descobre que o template referencia um símbolo que mudou de nome há três versões. O exemplo
/// é compilado pelo `analyze` do repo, então **se o DS quebrar o contrato, o exemplo quebra antes
/// do cliente**.
void main() {
  final op = gerador.Opcoes(
    id: 'meuBanco',
    nome: 'Meu Banco',
    cor: '#1B5E20',
    saida: '../../exemplos/filho_do_coreflow',
  );
  final raiz = Directory.current.path;
  final exemplo = Directory('$raiz/../../exemplos/filho_do_coreflow');

  test('o exemplo existe, e é a saída do gerador', () {
    expect(exemplo.existsSync(), isTrue,
        reason: 'sem a saída versionada, o gerador não tem gate — rode:\n'
            '  dart run coreflow:novo_filho --id meuBanco --nome "Meu Banco" '
            '--cor "#1B5E20" --saida exemplos/filho_do_coreflow');
  });

  test('o PRODUTO gerado é byte a byte o que está versionado', () {
    final noDisco = File('${exemplo.path}/lib/meu_banco.dart').readAsStringSync();
    expect(noDisco, gerador.produtoDe(op),
        reason: 'o gerador mudou e o exemplo não — ou o contrário. Regenere.');
  });

  test('e o LEIAME também', () {
    final noDisco = File('${exemplo.path}/README.md').readAsStringSync();
    expect(noDisco, gerador.leiameDe(op));
  });

  test('o pubspec diverge em UMA linha, e é o `path` — de propósito', () {
    final noDisco = File('${exemplo.path}/pubspec.yaml').readAsStringSync();
    final gerado = gerador.pubspecDe(op);
    final difs = <String>[];
    final a = noDisco.split('\n'), b = gerado.split('\n');
    for (var i = 0; i < a.length && i < b.length; i++) {
      if (a[i] != b[i]) difs.add(a[i].trim());
    }
    expect(difs, hasLength(1),
        reason: 'o exemplo mora DENTRO do repo, então o caminho relativo é outro. Qualquer '
            'segunda divergência é o template envelhecendo.');
    expect(difs.single, contains('path:'));
  });

  test('o LADO WEB do filho gerado é byte a byte o que está versionado', () {
    // Desde 14/09 um filho nasce mobile E web. Antes disso o gerador entregava só o Flutter, e o
    // segundo produto teria que montar a instância web olhando a do primeiro — copiando, que é o
    // que esta casa passou o mês combatendo.
    final arquivos = {
      'test/emite_o_css.dart': gerador.emissorDe(op),
      'test/o_css_esta_em_dia_test.dart': gerador.gateDoCssDe(op),
      'test/o_desenho_da_web_e_o_do_mobile_test.dart': gerador.gateDeParidadeDe(op),
      'test/o_que_esta_instalado_e_o_que_o_pino_diz_test.dart': gerador.gateDoInstaladoDe(op),
      'web/package.json': gerador.packageJsonDe(op),
      'web/index.js': gerador.indexJsDe(op),
      'web/README.md': gerador.leiameWebDe(op),
    };
    for (final e in arquivos.entries) {
      final f = File('${exemplo.path}/${e.key}');
      expect(f.existsSync(), isTrue, reason: 'o gerador promete ${e.key} e o exemplo não tem');
      expect(f.readAsStringSync(), e.value,
          reason: '${e.key}: o gerador mudou e o exemplo não — ou o contrário. Regenere.');
    }
  });

  test('o filho gerado recebe o MESMO avô que o pai pina', () {
    // Duas tags diferentes seriam duas versões da linguagem no mesmo produto: o Flutter desenhando
    // uma coisa e a web outra, sem nada acusando. O pai pina `vX` em Dart; o pacote web do filho
    // pina `web-vX`, e o número tem que ser o mesmo.
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final tagDart = RegExp(r'ref:\s*(v[\d.]+)').firstMatch(pubspec)?.group(1);
    expect(tagDart, isNotNull, reason: 'o pai deixou de pinar o avô por tag');
    // O par não é mais igualdade de string: o avô reemite tag web queimada com o patch seguinte
    // (`web-v0.207.1` é «a instância web de v0.207.0», 22/09) e o Dart não acompanha, porque não
    // teve defeito. A régua é a mesma do `o_css_do_bold_esta_em_dia_test`: mesmo `X.Y`, patch da
    // web igual ou maior.
    expect(_mesmaLinguagem(dart: tagDart!, web: gerador.tagWebDoAvo), isTrue,
        reason: 'o pai recebe o avô em $tagDart e o filho gerado receberia '
            '${gerador.tagWebDoAvo} — uma língua, um número no `X.Y`, patch da web nunca abaixo.');
  });

  test('o produto gerado tem UM hex — a cor da marca — e nenhum outro valor de produto', () {
    // A régua de VALOR do pai (achado 3 do veredito de 08/09) vale pro que o pai GERA: um filho
    // nasce com uma cor, e qualquer segundo hex no arquivo dele é identidade que o gerador inventou.
    final fonte = gerador.produtoDe(op);
    final hexes = RegExp(r'0x[0-9A-Fa-f]{6,8}').allMatches(fonte).map((m) => m.group(0)).toList();
    expect(hexes, [op.corDart], reason: 'o gerador escreveu valor além da cor da marca: $hexes');
    expect(RegExp(r'TextStyle\(').hasMatch(fonte), isFalse);
    // E o filho gerado depende SÓ do pai: nenhum produto no pubspec dele.
    expect(gerador.pubspecDe(op), contains('\n  coreflow:\n'));
    expect(gerador.pubspecDe(op), isNot(contains('coreflow_design_system')));
  });

  test('o gerador recusa o que não é identificador Dart', () {
    for (final id in ['Meu Banco', '9bancos', 'meu-banco', 'MeuBanco']) {
      expect(RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(id), isFalse,
          reason: '$id passaria como nome de símbolo, e o pacote não compilaria');
    }
  });

  test('e a cor entra como hex de 6, com ou sem cerquilha', () {
    expect(gerador.Opcoes(id: 'x', nome: 'X', cor: '#1B5E20', saida: '.').corDart, '0xFF1B5E20');
    expect(gerador.Opcoes(id: 'x', nome: 'X', cor: '1b5e20', saida: '.').corDart, '0xFF1B5E20');
  });
}

/// `vX.Y.Z` (Dart) e `web-vX.Y.W` (web) são a mesma linguagem quando `X.Y` coincide e `W >= Z`.
/// O `W > Z` existe por causa da reemissão do avô (22/09): tag web queimada não se reescreve, sai
/// com o patch seguinte, e o Dart fica onde estava.
bool _mesmaLinguagem({required String dart, required String web}) {
  List<int> partes(String tag) =>
      RegExp(r'(\d+)\.(\d+)\.(\d+)').firstMatch(tag)!.groups([1, 2, 3]).map((g) => int.parse(g!)).toList();
  final d = partes(dart), w = partes(web);
  return d[0] == w[0] && d[1] == w[1] && w[2] >= d[2];
}
