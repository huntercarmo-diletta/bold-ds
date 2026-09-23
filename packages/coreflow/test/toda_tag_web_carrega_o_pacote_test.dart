// TODA TAG `web-*` CARREGA O PACOTE, E NÃO O REPOSITÓRIO.
//
// Conselho do pai, 22/09/2026 (`docs/avisos/2026-09-22-a-tag-que-nao-carrega-o-pacote.md`), escrito
// depois de o defeito acontecer DUAS vezes na casa dele em 24 horas — a segunda enquanto ele julgava
// a primeira.
//
// ## O que erra não é a emissão
//
// O `espelha_o_web.sh` nunca produz raiz de monorepo. Nas duas ocorrências alguém digitou
// `git tag web-vX.Y.Z` sobre o commit de release, e **isso tem a mesma cara de sucesso no terminal**.
//
// O modo de falhar é o caro: o `npm` instala a RAIZ do que clona, então nada quebra na hora. Quebra
// na primeira instalação limpa de outra pessoa — que costuma ser a da esteira, no dia da entrega. E
// como tag publicada não se reescreve, cada ocorrência custa uma versão queimada.
//
// ## Por que a régua é NOSSA e não a dele
//
// Ele ofereceu o arquivo e recusou que o copiássemos: *«as duas casas já dividem um
// `espelha_o_web.sh` e isso basta de superfície comum. Leia o contrato e escreva o seu, que é meia
// hora e fica com os números do seu pacote.»* O contrato são as quatro asserções abaixo; o nome do
// pacote e o teto são nossos.
//
// ## O limite, dito porque muda o valor da régua
//
// **Ela acusa DEPOIS do push.** Enquanto cortar tag for um comando que alguém digita, isto troca
// «versão queimada em silêncio» por «versão queimada com alarme» — que é melhor, e não é o conserto.
// O conserto é a emissão sair da mão e ir para a esteira.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O par `prefixo de tag → nome do pacote npm`. É a MESMA lista que o `espelha_o_web.sh` e o
/// `uma_versao_e_uma_tag_test.dart` declaram — mudar um sem os outros reprova lá.
const _pacotePorPrefixo = {
  'web-v': 'coreflow-design-system-web',
  'norte-benk-web-v': 'norte-benk-web',
};

/// O TETO que separa pacote de repositório, e ele não opina sobre o tamanho da emissão.
///
/// **Derivado da medição, e não arredondado.** Nas 16 tags em 22/09: 4 a 5 arquivos antes de a tag
/// embutir o avô (`web-v0.103.0` a `web-v0.109.0`) e 45 a 47 depois; o nosso monorepo tem 581. O
/// teto fica no meio dessa distância, com folga dos dois lados — **3× acima da maior emissão** (47)
/// e **3,9× abaixo do repositório** (581).
///
/// A primeira tentativa foi 200, escolhido a olho porque o monorepo do pai tem mais de mil. O
/// autoteste abaixo reprovou: o NOSSO repositório é menor que o dele, e 200 não deixava a folga que
/// o próprio teste exige. Foi a régua medindo a régua.
const _teto = 150;

String _correGit(List<String> args) =>
    (Process.runSync('git', args, workingDirectory: '../..').stdout as String).trim();

/// As nossas tags de artefato web. Vazio quando não há git (um zip baixado), e aí o teste pula.
List<String> _tagsWeb() {
  final r = Process.runSync('git', ['tag', '-l'], workingDirectory: '../..');
  if (r.exitCode != 0) return const [];
  return (r.stdout as String)
      .split('\n')
      .map((s) => s.trim())
      .where((t) => _pacotePorPrefixo.keys.any((p) => RegExp('^$p\\d+\\.\\d+\\.\\d+\$').hasMatch(t)))
      .toList()
    ..sort();
}

/// O prefixo declarado que esta tag usa. O mais LONGO que casa, senão `norte-benk-web-v…` casaria
/// com `web-v` por acidente e a régua cobraria o nome do pacote errado.
String _prefixoDe(String tag) => _pacotePorPrefixo.keys
    .where((p) => tag.startsWith(p))
    .reduce((a, b) => a.length >= b.length ? a : b);

void main() {
  final tags = _tagsWeb();

  test('a varredura acha tag de verdade — senão a régua aprova por cegueira', () {
    if (tags.isEmpty) return; // sem git não há o que medir, e dizer isso é melhor que fingir
    expect(tags.length, greaterThan(5));
    expect(tags.where((t) => t.startsWith('norte-benk-web-v')), isNotEmpty,
        reason: 'o segundo filho sumiu da varredura — o prefixo dele é o que a régua precisa cobrir');
    expect(tags.where((t) => RegExp(r'^web-v').hasMatch(t)), isNotEmpty);
  });

  test('o TETO separa duas ordens de grandeza — e não é número escolhido a esmo', () {
    if (tags.isEmpty) return;
    // Autoteste do próprio teto: ele precisa ficar MUITO abaixo do repositório que a tag errada
    // entregaria. Sem esta linha, alguém «conserta» uma reprovação subindo o teto e a régua cala.
    final noRepo = _correGit(['ls-tree', '-r', '--name-only', 'HEAD']).split('\n').length;
    expect(noRepo, greaterThan(_teto * 3),
        reason: 'o teto ($_teto) deixou de separar pacote de repositório: o repo tem $noRepo arquivos');
    // E do outro lado: teto apertado demais vira alarme em emissão que só cresceu. A maior emissão
    // precisa caber com folga, senão a régua passa a cobrar tamanho em vez de NATUREZA.
    final maior = tags
        .map((t) => _correGit(['ls-tree', '-r', '--name-only', t]).split('\n').length)
        .reduce((a, b) => a > b ? a : b);
    expect(maior * 2, lessThanOrEqualTo(_teto),
        reason: 'a maior emissão tem $maior arquivos e o teto é $_teto — apertado demais para medir '
            'natureza em vez de tamanho');
  });

  for (final tag in tags) {
    test('$tag carrega o pacote', () {
      final prefixo = _prefixoDe(tag);
      final esperado = _pacotePorPrefixo[prefixo]!;
      final arquivos = _correGit(['ls-tree', '-r', '--name-only', tag]).split('\n');
      final raiz = _correGit(['ls-tree', '--name-only', tag]).split('\n');

      // 1. a raiz tem `package.json` E `index.js`
      expect(raiz, contains('package.json'),
          reason: '$tag não tem `package.json` na raiz — quem a instalar não recebe um pacote');
      expect(raiz, contains('index.js'),
          reason: '$tag não tem `index.js` na raiz');

      // 2. o `package.json` é o do PACOTE, e não o do monorepo — compara pelo nome
      final manifesto = jsonDecode(_correGit(['show', '$tag:package.json'])) as Map<String, dynamic>;
      expect(manifesto['name'], esperado,
          reason: '$tag entrega o `package.json` de `${manifesto['name']}` e não o de `$esperado`. É '
              'a assinatura de tag cortada à mão sobre o commit de release: o `npm` instala a RAIZ do '
              'que clona, então isso não quebra na hora — quebra na primeira instalação limpa de '
              'outra pessoa');

      // 3. a versão declarada é a do NOME da tag
      expect(manifesto['version'], tag.substring(prefixo.length),
          reason: '$tag declara a versão ${manifesto['version']}. Nome e versão dizendo coisas '
              'diferentes é a metade do defeito que o `npm ci` NÃO pega, porque ele resolve por '
              'commit e não por versão');

      // 4. a contagem fica abaixo do teto que separa pacote de repositório
      expect(arquivos.length, lessThanOrEqualTo(_teto),
          reason: '$tag tem ${arquivos.length} arquivos, acima do teto de $_teto. Isso não é emissão '
              'grande: é ordem de grandeza de repositório');
    });
  }
}
