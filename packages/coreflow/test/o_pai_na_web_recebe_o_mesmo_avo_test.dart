// O PAI NA WEB RECEBE O MESMO AVÔ QUE O PAI EM DART — E QUE O FILHO QUE JÁ PUBLICA.
//
// `packages/coreflow_web` (`coreflow-web`) nasceu em 16/10/2026: é o `coreflow` do lado web —
// reexporta o avô e abre o ponto de extensão `coreflow/` (proposta
// `docs/propostas/2026-10-16-a-camada-web-do-coreflow.md`, aprovada pela Agatha). Os filhos vão
// apontar o `#avo` para ele, e a partir daí o avô que eles veem é o que ESTE pacote pina. Um pino
// diferente aqui seria duas versões da linguagem no mesmo produto, sem nada acusando — a classe que
// `o_lock_do_exemplo_aponta_pro_mesmo_commit_test.dart` fecha entre o exemplo e o Bold.
//
// ## Por que o pai não carrega o `o_que_esta_instalado_e_o_que_o_pino_diz` dos filhos
//
// Aquele gate mede a FOLHA do filho contra os degraus que as peças instaladas pedem, e o pai não
// tem folha: não pinta. A metade que vale para ele é a do PINO — o que está instalado é o que o
// `package.json` diz —, e ela mora aqui, com a mesma condição: sem `npm install` não há o que medir,
// e o teste pula com o motivo escrito, nunca em silêncio.
//
// ## E o que mais ele cobra
//
// Que o pai seja PUBLICÁVEL (fala com o avô pelo apelido `#avo`, como o
// `todo_filho_web_usa_o_apelido_do_avo_test.dart` cobra dos filhos — aquele varre `*/web/` e não
// enxerga um pacote irmão), que o ponto de extensão exista e esteja declarado, e que o pai NÃO
// PINTE: sem `tokens/`, sem folha nos `exports`, sem um hex no JS.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _pacoteDoAvo = 'diletta-design-system-web';
final _pai = Directory('../coreflow_web');
final _bold = Directory('../coreflow_design_system_web');
final _instalado = Directory('${_pai.path}/node_modules/$_pacoteDoAvo');

Map<String, dynamic> _json(String caminho) =>
    jsonDecode(File(caminho).readAsStringSync()) as Map<String, dynamic>;

/// O que o `package.json` PEDE — `bitbucket:diletta/ds-diletta#web-vX.Y.Z`.
String _pino(Directory d) =>
    (_json('${d.path}/package.json')['dependencies'] as Map<String, dynamic>)[_pacoteDoAvo] as String;

/// O COMMIT que o `npm` resolveu — o que decide o que desce no disco.
String _commitNoLock(Directory d) {
  final pacotes = _json('${d.path}/package-lock.json')['packages'] as Map<String, dynamic>;
  final entrada = pacotes.entries.firstWhere((e) => e.key.endsWith(_pacoteDoAvo));
  return ((entrada.value as Map<String, dynamic>)['resolved'] as String).split('#').last;
}

/// `vX.Y.Z` (Dart) e `web-vX.Y.W` (web) são a mesma linguagem quando `X.Y` coincide e `W >= Z` —
/// a régua do `o_gerador_de_filho_tem_saida_conferida_test.dart`: tag web queimada do avô sai com
/// o patch seguinte, e o Dart fica onde estava.
bool _mesmaLinguagem({required String dart, required String web}) {
  List<int> partes(String tag) =>
      RegExp(r'(\d+)\.(\d+)\.(\d+)').firstMatch(tag)!.groups([1, 2, 3]).map((g) => int.parse(g!)).toList();
  final d = partes(dart), w = partes(web);
  return d[0] == w[0] && d[1] == w[1] && w[2] >= d[2];
}

/// Todo JS que o pacote PUBLICA — a entrada e o ponto de extensão, sem o `node_modules`.
List<File> _jsDoPai() => [
      File('${_pai.path}/index.js'),
      ...Directory('${_pai.path}/coreflow')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.js')),
    ];

void main() {
  test('o pai na web é um pacote publicável: nome, apelido e reexport pelo apelido', () {
    final j = _json('${_pai.path}/package.json');
    expect(j['name'], 'coreflow-web');
    expect((j['imports'] as Map<String, dynamic>)['#avo'], _pacoteDoAvo,
        reason: 'sem o apelido declarado, o `export from \'#avo\'` não resolve nem aqui nem na tag');
    final index = File('${_pai.path}/index.js').readAsStringSync();
    expect(index, contains("from '#avo'"),
        reason: 'o `index.js` não fala com o avô pelo apelido — o `espelha_o_web.sh` reprova antes');
    final deFora = index
        .split('\n')
        .where((l) => l.trimLeft().startsWith('export') && l.contains('from'))
        .where((l) => !l.contains("'#avo'") && !l.contains("'./coreflow/"))
        .toList();
    expect(deFora, isEmpty,
        reason: 'o pai reexporta algo que não é o avô pelo apelido nem o próprio `coreflow/`. Na tag '
            'publicada essa linha procura um pacote que não viaja junto:\n${deFora.join('\n')}');
  });

  test('o ponto de extensão existe, está declarado, e a lista de peças é o que o gate lê', () {
    final j = _json('${_pai.path}/package.json');
    expect(File('${_pai.path}/coreflow/index.js').existsSync(), isTrue);
    expect(j['files'], contains('coreflow/'),
        reason: 'o `files` não leva o `coreflow/` — a emissão sairia sem o ponto de extensão');
    expect((j['exports'] as Map<String, dynamic>).keys, contains('./coreflow/*'));
    expect(File('${_pai.path}/coreflow/index.js').readAsStringSync(),
        contains('export const pecasDoCoreflow'),
        reason: 'a lista `pecasDoCoreflow` é o contrato: é por ela que o catálogo e os gates sabem '
            'quais `<coreflow-*>` existem');
  });

  test('o pai na web pina a MESMA tag do avô que o filho que já publica', () {
    expect(_pino(_pai), _pino(_bold),
        reason: 'o pai e o Bold pedem tags diferentes do avô. Quando os filhos apontarem o `#avo` '
            'para o pai, o avô que eles veem é o deste pino — duas tags na mesma casa são duas '
            'versões da linguagem no mesmo produto.');
  });

  test('e, pinando a mesma tag, os dois locks resolvem o MESMO commit', () {
    expect(_commitNoLock(_pai), _commitNoLock(_bold),
        reason: 'os dois pedem ${_pino(_pai)} e resolvem commits DIFERENTES. Renomear a tag no '
            '`package.json` não invalida o commit que o lock guarda — o `npm install` responde '
            '«up to date» e o disco continua na versão velha. Refaça o lock do pai com o endereço '
            'explícito (`npm install <pacote>@<tag>`).');
  });

  test('o pai em Dart e o pai na web recebem a mesma linguagem — um número no `X.Y`', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final tagDart = RegExp(r'ref:\s*(v[\d.]+)').firstMatch(pubspec)?.group(1);
    expect(tagDart, isNotNull, reason: 'o pai deixou de pinar o avô por tag');
    final tagWeb = RegExp(r'#(web-v[\d.]+)$').firstMatch(_pino(_pai))?.group(1);
    expect(tagWeb, isNotNull, reason: 'o pai na web deixou de pinar o avô por tag `web-vX`');
    expect(_mesmaLinguagem(dart: tagDart!, web: tagWeb!), isTrue,
        reason: 'o pai recebe o avô em $tagDart no Dart e em $tagWeb na web — uma língua, um número '
            'no `X.Y`, patch da web nunca abaixo.');
  });

  const porque = 'sem `npm install` em coreflow_web não há pacote do avô instalado para medir. '
      'Rode o install para cobrir.';
  test('a versão INSTALADA do avô é a que o pino diz', skip: _instalado.existsSync() ? null : porque,
      () {
    final tag = RegExp(r'#web-v([\d.]+)$').firstMatch(_pino(_pai))?.group(1);
    expect(tag, isNotNull);
    final noDisco = _json('${_instalado.path}/package.json')['version'] as String;
    expect(noDisco, tag,
        reason: 'o `package.json` pede web-v$tag e o que está instalado é $noDisco.\n'
            'O `npm install` responde «up to date» neste estado: o lock guarda o COMMIT já '
            'resolvido, e trocar o nome da tag não o invalida. Rode:\n'
            '  npm install "$_pacoteDoAvo@bitbucket:diletta/ds-diletta#web-v$tag"');
  });

  test('o pai NÃO pinta: sem `tokens/`, sem folha nos `exports`, sem um hex no JS', () {
    expect(Directory('${_pai.path}/tokens').existsSync(), isFalse,
        reason: 'o pai ganhou uma pasta de tokens — tinta é do filho, e o pai é a linguagem de '
            'produto SEM produto');
    final exports = _json('${_pai.path}/package.json')['exports'] as Map<String, dynamic>;
    expect(exports.keys.where((k) => k.endsWith('.css')), isEmpty,
        reason: 'o pai publica uma folha — e ele não tem cor para declarar');
    // Um hex de 3, 6 ou 8 depois de `#`, e nada de identificador colado (senão `#avo` casaria com
    // três letras, uma delas hex). Vale para o código E para o comentário: hex em comentário de
    // pai é valor de produto esperando para ser copiado.
    final hex = RegExp(r'#(?:[0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{3})(?![0-9a-zA-Z_-])');
    final js = _jsDoPai();
    expect(js, isNotEmpty, reason: 'a varredura não achou JS nenhum no pai — o caminho mudou');
    for (final f in js) {
      expect(hex.hasMatch(f.readAsStringSync()), isFalse,
          reason: '${f.path} escreve um hex — o pai lê papel (`--diletta-*`), nunca cor');
    }
  });

  test('a varredura lê os arquivos de verdade — senão o gate aprova por cegueira', () {
    expect(File('${_pai.path}/package-lock.json').existsSync(), isTrue,
        reason: 'o lock do pai sumiu — é ele que prega a tag do avô num commit');
    expect(File('${_bold.path}/package-lock.json').existsSync(), isTrue);
    expect(_commitNoLock(_pai), matches(RegExp(r'^[0-9a-f]{40}$')));
    expect(_pino(_pai), contains('#web-v'));
    // e a régua de linguagem sabe reprovar
    expect(_mesmaLinguagem(dart: 'v3.19.0', web: 'web-v3.19.2'), isTrue);
    expect(_mesmaLinguagem(dart: 'v3.19.0', web: 'web-v3.18.9'), isFalse);
    expect(_mesmaLinguagem(dart: 'v3.19.1', web: 'web-v3.19.0'), isFalse);
  });
}
