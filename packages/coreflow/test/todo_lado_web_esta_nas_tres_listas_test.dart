// TODO LADO WEB ESTÁ NAS TRÊS LISTAS — e quem cobra isso é esta folha, não a memória de quem faz o
// filho nascer.
//
// Um lado web novo entra em três lugares, cada um com o seu pedaço do mesmo par
// `caminho → prefixo da tag → nome do pacote`:
//
//     tool/espelha_o_web.sh                    o `case` que EMITE a tag (`bluon)` → pacote, prefixo)
//     uma_versao_e_uma_tag_test.dart           o `Filho(...)` que confere os dois números
//     toda_tag_web_carrega_o_pacote_test.dart  o `_pacotePorPrefixo` que confere a tag publicada
//
// Os dois últimos diziam «mudar um sem os outros reprova lá», e só o primeiro deles reprovava: ele
// varre o disco e cobra o `Filho`. O espelho e a régua da tag ninguém conferia. A Confia nasceu sem
// as listas (`7966876`) e deixou a `main` vermelha; a BluOn entrou nas três porque alguém lembrou
// (`83dcb79`); o Banco Fibra entrou numa só (`b83a098`), e o gate ficou VERDE — sem o caso no
// espelho a tag dele não sai, e o `web/README.md` do próprio pacote ensina um comando que responde
// «filho desconhecido».
//
// ## Por que lê TEXTO
//
// As três listas moram num script de shell e em duas constantes privadas de teste, e nenhuma se
// importa. Uma lista só, que os três leiam, é o conserto de raiz; enquanto ela não existir, esta
// folha lê as três como texto, e o primeiro teste confere que a leitura acha o Bold em cada uma —
// senão um formato mudado aprovaria tudo por não achar nada.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `../bluon_coreflow/web` → `packages/bluon_coreflow/web`, o caminho como o espelho o escreve.
String _daRaiz(String doPai) => doPai.replaceFirst(RegExp(r'^\.\./'), 'packages/');

/// Os lados web do DISCO, caminho → nome do pacote npm. A mesma varredura do
/// `uma_versao_e_uma_tag_test`: `packages/*/web/` e o pacote irmão `*_web`, como o do Bold.
Map<String, String> _noDisco() {
  final lados = <String, String>{};
  for (final d in Directory('..').listSync().whereType<Directory>()) {
    for (final p in ['${d.path}/web/package.json', if (d.path.endsWith('_web')) '${d.path}/package.json']) {
      final f = File(p);
      if (!f.existsSync()) continue;
      lados[_daRaiz(f.parent.path)] = (jsonDecode(f.readAsStringSync()) as Map)['name'] as String;
    }
  }
  return lados;
}

/// Um caso do `case "$filho"` do espelho: `bluon)`, `pacote=…`, `prefixo="…"`.
class _Caso {
  const _Caso(this.nome, this.pacote, this.prefixo);

  final String nome;
  final String pacote;
  final String prefixo;
}

List<_Caso> _doEspelho(String espelho) => RegExp(
      r'^\s*([a-z][a-z-]*)\)\s*\n\s*pacote=(\S+)\s*\n\s*prefixo="([^"]+)"',
      multiLine: true,
    ).allMatches(espelho).map((m) => _Caso(m[1]!, m[2]!, m[3]!)).toList();

/// Os `Filho(...)` do `uma_versao_e_uma_tag_test`, caminho → prefixo. Lá o prefixo vem SEM o `v`
/// (`bluon-web-`); no espelho e na régua da tag, com ele (`bluon-web-v`).
Map<String, String> _daReguaDaVersao() {
  final t = File('test/uma_versao_e_uma_tag_test.dart').readAsStringSync();
  return {
    for (final m in RegExp(r"Filho\(\s*'[^']*',\s*'[^']*',\s*'([^']*)',\s*'([^']*)'").allMatches(t))
      _daRaiz(File(m[1]!).parent.path): m[2]!,
  };
}

/// O `_pacotePorPrefixo` do `toda_tag_web_carrega_o_pacote_test`, prefixo → nome do pacote.
Map<String, String> _daReguaDaTag() {
  final t = File('test/toda_tag_web_carrega_o_pacote_test.dart').readAsStringSync();
  final bloco = RegExp(r'const _pacotePorPrefixo = \{(.*?)\};', dotAll: true).firstMatch(t)?[1] ?? '';
  return {for (final m in RegExp(r"'([^']+)':\s*'([^']+)'").allMatches(bloco)) m[1]!: m[2]!};
}

void main() {
  final disco = _noDisco();
  final espelho = File('../../tool/espelha_o_web.sh').readAsStringSync();
  final casos = _doEspelho(espelho);
  final daVersao = _daReguaDaVersao();
  final daTag = _daReguaDaTag();
  const bold = 'packages/coreflow_design_system_web';

  /// O prefixo com que a tag deste lado sai: o do espelho, senão o do `Filho`, senão o do molde.
  String prefixoDe(String lado) =>
      casos.where((c) => c.pacote == lado).map((c) => c.prefixo).firstOrNull ??
      (daVersao[lado] != null ? '${daVersao[lado]}v' : '${disco[lado]}-v');

  test('a leitura acha o Bold nas quatro fontes — senão a régua aprova por cegueira', () {
    expect(disco[bold], 'coreflow-design-system-web', reason: 'a varredura do disco não achou o Bold');
    expect(casos.where((c) => c.nome == 'bold' && c.pacote == bold && c.prefixo == 'web-v'), hasLength(1),
        reason: 'o caso `bold)` sumiu da leitura do espelho — o formato do `case` mudou');
    expect(daVersao[bold], 'web-',
        reason: 'o `Filho` do Bold sumiu da leitura do `uma_versao_e_uma_tag_test`');
    expect(daTag['web-v'], 'coreflow-design-system-web',
        reason: 'o `web-v` sumiu da leitura do `_pacotePorPrefixo`');
  });

  test('todo lado web do disco tem caso no espelho, e todo caso tem lado web', () {
    final pacotes = casos.map((c) => c.pacote).toSet();
    final fora = [
      for (final l in disco.keys.where((l) => !pacotes.contains(l)))
        '$l  →  falta o caso, com `pacote=$l` e `prefixo="${prefixoDe(l)}"`',
      for (final p in pacotes.where((p) => !disco.containsKey(p))) '$p  →  caso sem lado web no disco',
    ]..sort();
    expect(fora, isEmpty,
        reason: 'o `tool/espelha_o_web.sh` não emite a tag destes — quem roda responde «filho '
            'desconhecido»:\n${fora.join('\n')}');
  });

  test('o `uma_versao_e_uma_tag_test` dá a cada lado web o prefixo que o espelho usa', () {
    final fora = <String>[];
    for (final l in disco.keys) {
      final declarado = daVersao[l];
      if (declarado == null) {
        final semV = prefixoDe(l).replaceFirst(RegExp(r'v$'), '');
        fora.add('$l  →  falta o `Filho(...)`, com o prefixo `$semV`');
      } else if ('${declarado}v' != prefixoDe(l)) {
        fora.add('$l  →  `$declarado` lá, `${prefixoDe(l)}` no espelho');
      }
    }
    fora.addAll(
        daVersao.keys.where((l) => !disco.containsKey(l)).map((l) => '$l  →  `Filho` sem lado web'));
    expect(fora, isEmpty,
        reason: 'o gate dos dois números não confere estes, ou confere no espaço de tags errado:\n'
            '${(fora..sort()).join('\n')}');
  });

  test('o `toda_tag_web_carrega_o_pacote_test` conhece o prefixo de cada lado web, com o nome do pacote', () {
    final fora = <String>[];
    for (final l in disco.keys) {
      final prefixo = prefixoDe(l);
      final nome = daTag[prefixo];
      if (nome == null) {
        fora.add("$l  →  falta '$prefixo': '${disco[l]}' no `_pacotePorPrefixo`");
      } else if (nome != disco[l]) {
        fora.add("$prefixo  →  '$nome' lá, '${disco[l]}' no package.json");
      }
    }
    final prefixos = disco.keys.map(prefixoDe).toSet();
    fora.addAll(daTag.keys.where((p) => !prefixos.contains(p)).map((p) => "'$p'  →  prefixo sem lado web"));
    expect(fora, isEmpty,
        reason: 'a régua da tag publicada não enxerga as tags destes — elas podem sair com a raiz do '
            'monorepo e ninguém acusa:\n${(fora..sort()).join('\n')}');
  });

  test('o «filho desconhecido» do espelho lista exatamente os casos que ele tem', () {
    final lista = RegExp(r'conheço: ([^)]*)\)').firstMatch(espelho)?[1];
    expect(lista, isNotNull, reason: 'a mensagem «conheço: …» sumiu do espelho');
    expect(lista!.split(',').map((s) => s.trim()).toSet(), casos.map((c) => c.nome).toSet(),
        reason: 'quem erra o nome lê a lista desta mensagem para acertar');
  });

  test('o comando que o README de cada lado web ensina emite aquele lado', () {
    final fora = <String>[];
    for (final l in disco.keys) {
      final readme = File('../../$l/README.md');
      if (!readme.existsSync()) continue;
      final comandos = RegExp(r'espelha_o_web\.sh <tag-do-monorepo> ([a-z][a-z-]*)')
          .allMatches(readme.readAsStringSync());
      for (final m in comandos) {
        final caso = casos.where((c) => c.nome == m[1]).firstOrNull;
        if (caso == null) {
          fora.add('$l/README.md  →  ensina `${m[1]}`, e o espelho não conhece esse filho');
        } else if (caso.pacote != l) {
          fora.add('$l/README.md  →  `${m[1]}` emite `${caso.pacote}`');
        }
      }
    }
    expect(fora, isEmpty,
        reason: 'estes READMEs ensinam um comando que não emite o pacote deles:\n${fora.join('\n')}');
  });
}
