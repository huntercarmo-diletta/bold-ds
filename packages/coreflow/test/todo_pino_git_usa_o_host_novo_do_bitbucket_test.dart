// TODO PINO GIT USA O HOST NOVO DO BITBUCKET.
//
// O Bitbucket moveu o SSH para `ssh.bitbucket.org` em 12/11/2026; o `bitbucket.org` deixou de
// atender SSH. A chave de host é a mesma nos dois nomes (ED25519
// `SHA256:ybgmFkzwOSotHTHLJgHO0QN8L0xErw6vd0VhFA9m3SM`), então a troca é só de endereço.
//
// Este repo busca os dois pais por SSH: o avô (`ds-diletta`) no `pubspec.yaml` do motor, do Bold e
// do catálogo e no `package.json` dos sete lados web, e a ferramenta (`catalogo-diletta`) no
// catálogo. Um pino no host antigo não acusa nada aqui dentro, porque o `pub` e o `npm` usam o que
// já está em cache; quem cai é a próxima máquina limpa, ou a esteira de um produto.
//
// ## Por que o formato do `npm` mudou, e não só o nome
//
// O atalho `bitbucket:diletta/ds-diletta#…` do `npm` sempre resolve para `bitbucket.org`, e não há
// como apontá-lo para outro nome. O pino passa a ser a URL inteira,
// `git+ssh://git@ssh.bitbucket.org/diletta/ds-diletta.git#web-vX.Y.Z`. As expressões que tiram a tag
// do pino aceitam o `.git` antes do `#`.
//
// ## O que esta folha cobra
//
// - nenhum `pubspec.yaml`, `pubspec.lock`, `package.json` ou `package-lock.json` versionado fala
//   SSH com o host antigo, e cada tipo de arquivo cita os pais pelo novo (senão a varredura
//   aprovaria por não achar nada);
// - o gerador de filho escreve o pino novo no `package.json` que ele cria;
// - o espelho da tag web confere o pino no formato novo.
//
// O histórico (CHANGELOG, recibos, avisos, pedidos) cita o host antigo de propósito e fica de fora.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// SSH com o host antigo, em qualquer das formas que o `pub` e o `npm` gravam: `git@bitbucket.org:`
/// (pub), `git+ssh://git@bitbucket.org/` (lock do npm) e o atalho `bitbucket:` (pino do npm).
final _hostAntigo = RegExp(r'git@bitbucket\.org[:/]|"bitbucket:');

/// Um pai pelo host novo: `git@ssh.bitbucket.org:diletta/<repo>.git` ou
/// `git+ssh://git@ssh.bitbucket.org/diletta/<repo>.git`.
final _paiPeloHostNovo = RegExp(r'git@ssh\.bitbucket\.org[:/]diletta/(ds-diletta|catalogo-diletta)\.git');

const _tipos = ['pubspec.yaml', 'pubspec.lock', 'package.json', 'package-lock.json'];

/// Os arquivos versionados de cada tipo, pelo `git ls-files` da raiz. O que não está versionado
/// (`node_modules`, `.dart_tool`) não vai para a máquina de ninguém.
Map<String, List<String>> _versionados() {
  final r = Process.runSync('git', ['ls-files'], workingDirectory: '../..');
  if (r.exitCode != 0) fail('o `git ls-files` falhou: ${r.stderr}');
  final porTipo = {for (final t in _tipos) t: <String>[]};
  for (final caminho in (r.stdout as String).split('\n')) {
    final nome = caminho.split('/').last;
    if (porTipo.containsKey(nome)) porTipo[nome]!.add(caminho);
  }
  return porTipo;
}

/// As linhas que valem: no YAML, um comentário pode contar a história do host antigo.
List<String> _linhas(String caminho) => File('../../$caminho')
    .readAsLinesSync()
    .where((l) => !(caminho.endsWith('.yaml') && l.trimLeft().startsWith('#')))
    .toList();

void main() {
  test('nenhum pino ou lock versionado fala SSH com o host antigo, e cada tipo cita os pais pelo novo', () {
    final porTipo = _versionados();
    final noAntigo = <String>[];
    for (final tipo in _tipos) {
      var peloNovo = 0;
      for (final caminho in porTipo[tipo]!) {
        final linhas = _linhas(caminho);
        for (var i = 0; i < linhas.length; i++) {
          if (_hostAntigo.hasMatch(linhas[i])) noAntigo.add('$caminho:${i + 1}: ${linhas[i].trim()}');
        }
        if (linhas.any(_paiPeloHostNovo.hasMatch)) peloNovo++;
      }
      expect(peloNovo, greaterThan(0),
          reason: 'nenhum `$tipo` versionado cita um pai pelo `ssh.bitbucket.org`: ou o formato mudou e '
              'esta varredura não enxerga mais nada, ou os pinos sumiram');
    }
    expect(noAntigo, isEmpty,
        reason: 'o `bitbucket.org` não atende SSH desde 12/11/2026. No pubspec, '
            '`url: git@ssh.bitbucket.org:diletta/<repo>.git`; no package.json, '
            '`git+ssh://git@ssh.bitbucket.org/diletta/<repo>.git#<tag>` (o atalho `bitbucket:` sempre '
            'vai para o host antigo). Depois, `flutter pub get` ou `npm install "<pacote>@<pino>"` para o lock.');
  });

  test('o gerador de filho escreve o pino do avô pelo host novo', () {
    final gerador = File('bin/novo_filho.dart').readAsStringSync();
    expect(
        gerador,
        contains(r'"diletta-design-system-web": "git+ssh://git@ssh.bitbucket.org/diletta/ds-diletta.git#$tagWebDoAvo"'),
        reason: 'é o `package.json` que todo filho novo recebe');
    expect(_hostAntigo.hasMatch(gerador), isFalse,
        reason: 'nenhum arquivo que o gerador escreve pode ensinar o host antigo');
  });

  test('o espelho da tag web confere o pino no formato novo', () {
    final espelho = File('../../tool/espelha_o_web.sh').readAsLinesSync();
    expect(
        espelho.map((l) => l.trim()),
        contains('esperado = "git+ssh://git@ssh.bitbucket.org/diletta/ds-diletta.git#web-v" + avo["version"]'),
        reason: 'o espelho compara o pino da tag com este texto; no formato antigo, toda emissão pararia ali');
  });
}
