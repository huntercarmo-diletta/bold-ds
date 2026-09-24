// UMA VERSÃO, UMA TAG — POR FILHO, e este gate nasceu de uma entrega que parou no meio.
//
// Em 21/09 a `v0.113.0` subiu com o avô na `v0.204.0`. O `pubspec` foi para 0.113.0, o
// `package.json` do pacote web ficou em **0.112.0**, e a **`web-v0.113.0` nunca foi emitida**. Os
// 497 testes desta casa passaram assim mesmo. O consumidor esperou um dia por um pacote que não
// existia, e nada acusou porque nada olhava.
//
// ## Por que ele MUDOU DE CASA e passou a andar por filho
//
// A primeira versão morava em `coreflow_design_system/test/` e conhecia um filho só: lia o
// `pubspec` dali e o `package.json` do pacote web ao lado, os dois cravados. Em 22/09 a família
// ganhou um segundo produto com lado web — o `norte_benk_coreflow` —, e um gate que conhece um
// filho não é catraca: é uma catraca com um buraco do tamanho do segundo produto.
//
// Ele vive agora no `coreflow`, que é onde moram os gates que olham os irmãos.
//
// ## O ESPAÇO DE TAGS É DECLARADO, e a forma já estava escrita no molde
//
// O `novo_filho.dart` gera, no `web/README.md` de todo filho, uma seção «Como este pacote sai
// daqui»: *«o `npm` não tem o `path:` do `pub` — subpasta de repo não se instala. Quem consumir
// precisa de uma TAG ÓRFÃ cuja raiz seja este diretório. O padrão está no `conta-bold-ds`
// (`tool/espelha_o_web.sh`)»*.
//
// Ou seja, a forma não é escolha deste gate: é a do Bold, e o molde manda seguir. O que falta é o
// NOME distinguir, porque o espaço é o mesmo repositório — e aí `web-` sozinho não serve para dois.
// A extensão mínima é o nome do pacote npm mais `-v`: `norte-benk-web-v0.1.0`. O `web-` do Bold
// fica como exceção histórica, porque derivar do nome dele
// (`coreflow-design-system-web-v…`) quebraria a tag que o Internet Banking já consome.
//
// E O MOLDE JÁ DIZ QUE FILHO VERSIONA SOZINHO: o `pubspec.yaml` gerado nasce em `version: 0.1.0`,
// e não no número da casa. O Bold está em `0.114.0` porque ele É a versão do monorepo — ele é o
// caso especial, e é isso que o `segueOMonorepo` abaixo marca.
//
// Sobre nomenclatura de release, e o que eu NÃO sei: o `app-newbold` e o IB usam
// `R_PRODUCTION_vX.Y.Z-BUILD` e `R_HOMOLOGATION_…` — medido nos dois repositórios, e marca CANAL DE
// PUBLICAÇÃO, não artefato. Não há repositório de app da Norte Benk ao alcance para conferir se ela
// segue o mesmo, então esta folha não afirma nada sobre isso: o que se cobra aqui é o número do que
// ESTE repositório publica.
//
// ## O que ele mede, e o que deliberadamente NÃO mede
//
// Mede o que dá para medir sem rede: os dois números de cada filho, e — para o filho cujo espaço é
// o do monorepo — se cada tag `vX.Y.Z` tem a `web-vX.Y.Z` ao lado. **Não** confere o conteúdo da
// tag publicada: isso exige o remoto, e gate que precisa de rede fica amarelo na primeira queda de
// wifi.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Um filho com lado web: onde mora o número no Dart, onde mora no npm, e o espaço de tags dele.
class Filho {
  const Filho(this.nome, this.pubspec, this.packageJson, this.prefixo, {this.segueOMonorepo = false});

  final String nome;
  final String pubspec;
  final String packageJson;

  /// O prefixo da tag do artefato web. **Declarado**, e não derivado — ver o cabeçalho.
  final String prefixo;

  /// O Bold versiona junto com o monorepo: a tag `vX.Y.Z` da casa é a versão dele. Os outros
  /// filhos versionam sozinhos, e aí não há par de tag do monorepo para cobrar.
  final bool segueOMonorepo;
}

const _filhos = <Filho>[
  Filho('Conta BOLD', '../coreflow_design_system/pubspec.yaml',
      '../coreflow_design_system_web/package.json', 'web-', segueOMonorepo: true),
  Filho('Norte Benk', '../norte_benk_coreflow/pubspec.yaml',
      '../norte_benk_coreflow/web/package.json', 'norte-benk-web-'),
];

String _versaoDoPubspec(String caminho) {
  final l = File(caminho).readAsLinesSync().firstWhere((x) => x.startsWith('version:'));
  return l.split(':')[1].trim();
}

String _versaoDoPacoteWeb(String caminho) =>
    (jsonDecode(File(caminho).readAsStringSync()) as Map)['version'] as String;

/// As tags deste repo. Vazio quando não há git (um zip baixado), e aí o teste pula.
List<String> _tags() {
  final r = Process.runSync('git', ['tag', '-l'], workingDirectory: '..');
  if (r.exitCode != 0) return const [];
  return (r.stdout as String).split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}

int _numero(String v) {
  final p = v.replaceFirst('v', '').split('.').map(int.parse).toList();
  return p[0] * 1000000 + p[1] * 1000 + p[2];
}

void main() {
  test('todo filho com lado web está declarado aqui — senão o gate tem um buraco do tamanho dele', () {
    // A varredura acha os lados web de verdade; a lista acima diz o que cada um é. Um filho novo
    // aparece na varredura e não na lista, e o gate cobra a declaração em vez de ignorá-lo.
    final noDisco = <String>[];
    for (final d in Directory('..').listSync().whereType<Directory>()) {
      if (File('${d.path}/web/package.json').existsSync()) noDisco.add('${d.path}/web/package.json');
      // o Bold guarda o lado web num pacote IRMÃO, e não dentro do seu — a forma varia
      if (d.path.endsWith('_web') && File('${d.path}/package.json').existsSync()) {
        noDisco.add('${d.path}/package.json');
      }
    }
    final declarados = _filhos.map((f) => f.packageJson).toSet();
    final semDeclarar = noDisco.where((p) => !declarados.contains(p)).toList()..sort();
    expect(semDeclarar, isEmpty,
        reason: 'estes lados web não estão na lista deste gate — o número deles não é conferido e a '
            'tag deles não é cobrada:\n${semDeclarar.join('\n')}');
    expect(noDisco, isNotEmpty, reason: 'a varredura não achou lado web nenhum — o caminho mudou');
  });

  test('cada filho diz o MESMO número no Dart e no npm', () {
    final fora = <String>[];
    for (final f in _filhos) {
      final dart = _versaoDoPubspec(f.pubspec);
      final npm = _versaoDoPacoteWeb(f.packageJson);
      if (dart != npm) fora.add('${f.nome}: pubspec $dart × package.json $npm');
    }
    expect(fora, isEmpty,
        reason: 'dois números no mesmo filho. Quem publica usa o do `pubspec` para nomear a tag e o '
            'do `package.json` para o pacote — e aí um repo com dois números publica certo e mente '
            'para quem lê o código:\n${fora.join('\n')}');
  });

  /// As versões do monorepo SEM instância web, cada uma com a razão — e a razão é medida, não
  /// desculpa. A `web-v0.117.0` foi emitida em 24/09 a partir da tag (faltava desde 23/09); a
  /// `v0.116.0` não tem como sair: o `package.json` dela pina `web-v0.207.0`, a tag do avô que
  /// aponta para o MONOREPO (aviso `2026-09-22-a-tag-que-nao-carrega-o-pacote.md`), e o emissor
  /// recusa copiar um avô que não é pacote. Quem consome a web pula da `web-v0.115.0` para a
  /// `web-v0.117.0`, e o que a `v0.116.0` entregou chega nela.
  const _semInstanciaWebDeclarada = <String, String>{
    'v0.116.0': 'pina web-v0.207.0, a tag do avô que aponta para o monorepo; o emissor recusa copiar '
        'um avô que não é pacote. O conteúdo dela chega na web-v0.117.0.',
  };

  test('o filho que versiona com o monorepo tem a tag web de cada versão', () {
    final tags = _tags();
    if (tags.isEmpty) return; // sem git, não há o que medir — e dizer isso é melhor que fingir
    final versoes = tags.where((t) => RegExp(r'^v\d+\.\d+\.\d+$').hasMatch(t)).toSet();
    for (final f in _filhos.where((x) => x.segueOMonorepo)) {
      final web = tags.where((t) => t.startsWith(f.prefixo)).map((t) => t.substring(f.prefixo.length)).toSet();
      // A `v0.98.1` e as anteriores nasceram antes de existir instância web (a primeira é a
      // `web-v0.103.0`). O corte é declarado, e não um `skip` que cresce sozinho.
      const primeiraComWeb = 'v0.103.0';
      final orfas = versoes
          .where((v) => _numero(v) >= _numero(primeiraComWeb) && !web.contains(v))
          .where((v) => !_semInstanciaWebDeclarada.containsKey(v))
          .toList()
        ..sort();
      // A exceção declarada tem de continuar sendo exceção: se a tag web dela aparecer, a razão
      // aqui virou mentira e a linha sai.
      for (final e in _semInstanciaWebDeclarada.entries) {
        expect(web.contains(e.key), isFalse,
            reason: '${e.key} ganhou instância web — apague a exceção declarada em _semInstanciaWebDeclarada');
        expect(e.value.trim().length, greaterThan(40), reason: 'exceção sem razão escrita: ${e.key}');
      }
      expect(orfas, isEmpty,
          reason: '${f.nome}: estas versões não têm instância web publicada:\n${orfas.join('\n')}\n'
              'A tag do monorepo NÃO emite o pacote web — rode `sh tool/espelha_o_web.sh <tag>` e '
              'publique a `${f.prefixo}<tag>`. Quem consome a web fica sem o que esta versão entregou.');
    }
  });

  test('nenhum filho publica no espaço de outro', () {
    // Dois filhos com o mesmo prefixo seriam duas versões disputando o mesmo nome de tag. E o
    // prefixo de um não pode ser começo do de outro: `web-` casaria com `web-v…` E com nada mais,
    // mas um `nortebenk-` e um `nortebenk-web-` se sobreporiam na leitura.
    final prefixos = _filhos.map((f) => f.prefixo).toList();
    expect(prefixos.toSet().length, prefixos.length, reason: 'dois filhos com o mesmo prefixo');
    for (final a in _filhos) {
      for (final b in _filhos) {
        if (identical(a, b)) continue;
        expect(b.prefixo.startsWith(a.prefixo), isFalse,
            reason: 'o prefixo de ${a.nome} (`${a.prefixo}`) é começo do de ${b.nome} '
                '(`${b.prefixo}`) — a leitura de um vai pegar as tags do outro');
      }
    }
  });

  test('e o gate sabe reprovar — uma versão inventada não tem par', () {
    final tags = _tags();
    if (tags.isEmpty) return;
    expect(tags.where((t) => t.startsWith('web-v')), isNotEmpty,
        reason: 'nenhuma tag `web-v*` foi lida — a leitura do git quebrou e o gate ficou cego');
    expect(tags.contains('web-v99.0.0'), isFalse);
    expect(_numero('v1.2.3'), 1002003);
  });
}
