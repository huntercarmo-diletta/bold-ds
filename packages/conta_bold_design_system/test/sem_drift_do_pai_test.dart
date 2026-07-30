import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

/// A CÓPIA DO PAI NÃO FOI EDITADA — o gate que torna sync seguro.
///
/// `packages/diletta_design_system/` é código DESTE repo, produzido a partir do
/// `ds-diletta` por `tool/sincroniza_pai_ds.py`. O ADR-003 decidiu assim e a razão é
/// política: fazer o build do app do CLIENTE depender da infra privada do FORNECEDOR é
/// passivo real. O catálogo pode ser dependência porque é ferramenta da Diletta; o DS
/// não, porque é entrega.
///
/// O medo legítimo do sync é DRIFT: alguém precisa de um ajuste, edita a cópia, e ela
/// descola do pai em silêncio. Aí o próximo sync sobrescreve o ajuste (e a pessoa
/// aprende a não sincronizar), ou o ajuste sobrevive e o pai deixa de ser o pai.
///
/// Este teste faz drift virar gate. Ele recalcula a impressão digital do conteúdo e
/// compara com a que o sync gravou em `.sync.json`. É a mesma técnica que já resolveu
/// drift duas vezes neste repo — `tokens_parity_test` (o Dart tem que ser exatamente o
/// DTCG regerado) e o golden do descriptor.
///
/// **E ele roda offline.** Nada de comparar com o remoto: a digital foi gravada no
/// momento do sync, então o que se verifica é "ninguém mexeu depois". Um gate que
/// precisa de rede é um gate que alguém vai desligar.
///
/// ## Se este teste falhar, o caminho é um só
///
/// O ajuste vai pro PAI (`ds-diletta`), sai numa tag nova, e volta por
/// `python3 tool/sincroniza_pai_ds.py --tag <nova>`. Parece burocracia e é o contrário:
/// é o que faz o próximo filho receber o mesmo ajuste sem ninguém lembrar dele.
void main() {
  final copia = Directory('../diletta_design_system');

  /// Mesma regra do script de sync — se as duas listas divergirem, a digital nunca bate
  /// e o gate mente. Estão escritas duas vezes de propósito: um teste que importa a
  /// definição do que ele verifica verifica a si mesmo.
  const ignorar = {
    '.dart_tool',
    'build',
    'node_modules',
    'pubspec.lock',
    '.DS_Store',
    'exemplos',
    '.sync.json', // a digital é calculada ANTES dele existir
  };

  List<File> arquivos() {
    final out = <File>[];
    for (final e in copia.listSync(recursive: true)) {
      if (e is! File) continue;
      final rel = e.path.substring(copia.path.length + 1);
      if (rel.split('/').any(ignorar.contains)) continue;
      out.add(e);
    }
    out.sort((a, b) => a.path.compareTo(b.path));
    return out;
  }

  String digital() {
    final acc = <int>[];
    for (final f in arquivos()) {
      final rel = f.path.substring(copia.path.length + 1);
      acc
        ..addAll(utf8.encode(rel))
        ..add(0)
        ..addAll(sha256.convert(f.readAsBytesSync()).bytes);
    }
    return sha256.convert(acc).toString();
  }

  test('a cópia do pai declara DE ONDE veio', () {
    // Sem procedência, "sincronizado" é folclore. O arquivo diz repo, tag e commit —
    // então dá pra abrir exatamente o código que gerou esta cópia.
    final marca = File('${copia.path}/.sync.json');
    expect(marca.existsSync(), isTrue,
        reason: 'faltou .sync.json — rode tool/sincroniza_pai_ds.py');

    final j = jsonDecode(marca.readAsStringSync()) as Map<String, dynamic>;
    expect(j['origem'], contains('ds-diletta'));
    expect(j['tag'], matches(RegExp(r'^v\d+\.\d+\.\d+')));
    expect((j['commit'] as String).length, 40);
  });

  test('a cópia do pai NÃO foi editada depois do sync', () {
    final j = jsonDecode(File('${copia.path}/.sync.json').readAsStringSync())
        as Map<String, dynamic>;
    expect(digital(), j['impressaoDigital'],
        reason: 'a cópia da LINGUAGEM foi editada neste repo.\n\n'
            'Isso descola o filho do pai em silêncio: o próximo sync desfaz a edição, '
            'ou ela sobrevive e o pai deixa de ser o pai.\n\n'
            'O caminho é o pai: leve o ajuste pro ds-diletta, publique uma tag e rode\n'
            '  python3 tool/sincroniza_pai_ds.py --tag <nova>\n\n'
            'Se o ajuste é só deste produto, ele não pertence à linguagem — mora no '
            'pacote do filho.');
  });

  test('a cópia tem o tamanho de um DS inteiro, não de um resto', () {
    // Guarda contra o sync ter copiado meia árvore e o gate ter gravado a digital do
    // meio. Um número frouxo, mas que pega o caso "copiou 12 arquivos e passou".
    expect(arquivos().length, greaterThan(400),
        reason: 'a cópia do pai está pequena demais pra ser a linguagem inteira');
  });
}
