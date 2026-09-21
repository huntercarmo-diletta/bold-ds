// UMA VERSÃO, UMA TAG — e este gate nasceu de uma entrega que parou no meio.
//
// Em 21/09 a `v0.113.0` subiu com o avô na `v0.204.0`, que traz o conserto dos renders e o anel de
// foco visível. O `pubspec` foi para 0.113.0, o `package.json` do pacote web ficou em **0.112.0**, e
// a **`web-v0.113.0` nunca foi emitida**. Os 497 testes desta casa passaram assim mesmo.
//
// O consumidor esperou um dia por um pacote que não existia. Nada acusou, porque nada olhava.
//
// ## Por que não é caso, é classe
//
// A tag do monorepo NÃO publica a instância web — quem publica é `tool/espelha_o_web.sh`, rodado à
// mão depois. Quem sobe a versão precisa lembrar de um segundo passo que o primeiro não menciona.
// Memória de pessoa não é gate, e o pai desta casa já mediu a mesma classe do lado dele: 23 tags de
// 279 entregavam um número diferente do nome (`ds-diletta/docs/TAG-PUBLICADA.md`).
//
// ## O que ele mede, e o que deliberadamente NÃO mede
//
// Mede as duas coisas que dão para medir sem rede: os dois números do repo, e se cada tag `vX.Y.Z`
// tem a `web-vX.Y.Z` ao lado. **Não** confere o conteúdo da tag publicada — isso exige o remoto, e
// gate que precisa de rede é gate que fica amarelo na primeira queda de wifi.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _versaoDoPubspec() {
  final l = File('pubspec.yaml').readAsLinesSync().firstWhere((x) => x.startsWith('version:'));
  return l.split(':')[1].trim();
}

String _versaoDoPacoteWeb() {
  final j = jsonDecode(File('../coreflow_design_system_web/package.json').readAsStringSync());
  return (j as Map)['version'] as String;
}

/// As tags deste repo, lidas do git. Vazio quando não há git (um zip baixado), e aí o teste pula.
List<String> _tags() {
  final r = Process.runSync('git', ['tag', '-l'], workingDirectory: '..');
  if (r.exitCode != 0) return const [];
  return (r.stdout as String).split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}

void main() {
  test('o pubspec do filho e o pacote web dizem o MESMO número', () {
    expect(_versaoDoPacoteWeb(), _versaoDoPubspec(),
        reason: 'o `pubspec.yaml` diz ${_versaoDoPubspec()} e o `package.json` do pacote web diz '
            '${_versaoDoPacoteWeb()}. São o mesmo produto, e a tag publicada leva o número do NOME '
            'da tag — então um repo com dois números publica certo e mente para quem lê o código.');
  });

  test('toda tag de versão tem a instância web ao lado', () {
    final tags = _tags();
    if (tags.isEmpty) return; // sem git, não há o que medir — e dizer isso é melhor que fingir
    final versoes = tags.where((t) => RegExp(r'^v\d+\.\d+\.\d+$').hasMatch(t)).toSet();
    final web = tags.where((t) => t.startsWith('web-v')).map((t) => t.substring(4)).toSet();
    // A `v0.98.1` e as anteriores nasceram antes de existir instância web (a primeira é a
    // `web-v0.103.0`). O corte é declarado, e não um `skip` que cresce sozinho.
    const primeiraComWeb = 'v0.103.0';
    int numero(String v) {
      final p = v.substring(1).split('.').map(int.parse).toList();
      return p[0] * 1000000 + p[1] * 1000 + p[2];
    }
    final orfas = versoes.where((v) => numero(v) >= numero(primeiraComWeb) && !web.contains(v)).toList()..sort();
    expect(orfas, isEmpty,
        reason: 'estas versões não têm instância web publicada:\n${orfas.join('\n')}\n'
            'A tag do monorepo NÃO emite o pacote web — rode `sh tool/espelha_o_web.sh <tag>` e '
            'publique a `web-<tag>`. Quem consome a web fica sem o que esta versão entregou.');
  });

  test('e o gate sabe reprovar — uma versão inventada não tem par', () {
    // Prova por mutação embutida: sem ela, um erro de leitura que devolvesse conjuntos vazios
    // aprovaria para sempre.
    final tags = _tags();
    if (tags.isEmpty) return;
    expect(tags.where((t) => t.startsWith('web-v')), isNotEmpty,
        reason: 'nenhuma tag `web-v*` foi lida — a leitura do git quebrou e o gate ficou cego');
    expect(tags.contains('web-v99.0.0'), isFalse);
  });
}
