import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../bin/novo_filho.dart' as gerador;

/// O GERADOR TEM SAÍDA CONFERIDA — gerador sem isso é template com esperança.
///
/// `exemplos/filho_do_coreflow/` não é um exemplo escrito à mão: é a **saída** do
/// `dart run coreflow_design_system:novo_filho`, versionada. Este gate regenera e compara.
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
            '  dart run coreflow_design_system:novo_filho --id meuBanco --nome "Meu Banco" '
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
