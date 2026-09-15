// O QUE ESTÁ INSTALADO, E O QUE AS PEÇAS PEDEM.
//
// Os gates desta casa medem o que está ESCRITO — o pino no `package.json`, a escala no `.css`, os
// degraus no Dart. Nenhum abria a pasta de dependências pra ver o que está lá DE VERDADE, e a
// subida do avô de 15/09 mostrou as duas metades do buraco:
//
//   1. troquei a tag no `package.json` de `web-v0.194.0` pra `web-v0.194.3`, rodei `npm install`, e
//      ele respondeu «up to date». O que estava instalado continuava sendo a **0.194.0** — o lock
//      guarda o commit já resolvido, e trocar o NOME da tag não o invalida. Quem sobe o pino,
//      confia na resposta e publica, publica a versão velha achando que subiu;
//
//   2. a `v0.194.2` do avô consertou 6 peças que saíam com `font: inherit` — com o tamanho e o peso
//      da PÁGINA hospedeira. Elas passaram a ler `--cps-type-<degrau>-*`, que é o que esta casa
//      emite. Só que **o nome do degrau quem escolhe é a peça dele, não a nossa folha**: se ele
//      pedir um nome que ninguém declara, a variável não resolve, a declaração morre no navegador
//      sem erro, e a peça volta a desenhar com a letra da página — o mesmo defeito, agora calado.
//
// O gate de paridade que já existe anda os 20 degraus que o Bold DECLARA e confere que a web os
// escreve. Ele nunca faz a pergunta inversa: *todo degrau que as peças PEDEM tem valor pra ler?*
//
// **Cobrir a fonte não é o mesmo que cobrir a demanda.**
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A raiz do pacote do avô DENTRO da pasta de dependências do nosso pacote web.
final _instalado = Directory('../coreflow_design_system_web/node_modules/diletta-design-system-web');

/// As duas folhas, na ordem da cascata: a do avô primeiro, a nossa depois.
///
/// A ordem importa pro navegador e NÃO importa aqui: o gate pergunta se o nome existe em ALGUMA das
/// duas, que é o que decide se a variável resolve. Qual das duas ganha é assunto do gate de
/// paridade, que compara valor a valor.
String _folhaDoAvo() => File('${_instalado.path}/tokens/cps-tokens.css').readAsStringSync();
String _folhaDoBold() =>
    File('../coreflow_design_system_web/tokens/bold-tokens.css').readAsStringSync();

/// Os degraus que as peças instaladas PEDEM — colhidos do código delas, não de uma lista nossa.
///
/// Lista escrita à mão aqui envelheceria calada na próxima versão do avô, que é exatamente a classe
/// que este arquivo existe pra fechar.
Set<String> _degrausPedidos() => Directory('${_instalado.path}/src')
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith('.js'))
    .expand((f) => RegExp(r"degrau\('([A-Za-z0-9]+)'\)").allMatches(f.readAsStringSync()))
    .map((m) => m.group(1)!)
    .toSet();

/// As quatro faces que `degrau(nome)` escreve. Quem cobrar só o tamanho deixa passar um rótulo com
/// o peso da página, que é metade do defeito que a `v0.194.2` consertou.
const _faces = ['size', 'weight', 'line-height', 'spacing'];

bool _declara(String folha, String degrau, String face) =>
    folha.contains('--cps-type-$degrau-$face:');

/// Os degraus que resolvem MISTURADO — parte na nossa folha, parte na do avô.
///
/// Não é defeito por si: o Bold declara a escala dele e cala nas faces que não tem opinião, e calar
/// é o mecanismo do white label. **É defeito quando ninguém sabe**, porque o app e a web preenchem o
/// silêncio por caminhos diferentes — na web a face que falta cai na folha do avô, no Flutter ela
/// cai no que o contexto de texto der. Dois silêncios, dois valores.
///
/// `button` é o caso vivo: o Bold declara 15px/700/15, não declara tracking, e a peça web pede
/// `button` — então o rótulo do botão sai com o **-0,1px do avô** enquanto o app não tem tracking
/// nenhum declarado. `title` está na mesma situação e nenhuma peça o pede hoje.
///
/// A lista é catraca: um terceiro nome aparecer aqui é uma face nova sendo preenchida por outra
/// casa sem ninguém decidir.
const _misturadosDeclarados = {'button', 'title'};

void main() {
  // SEM `npm install` NÃO HÁ O QUE MEDIR, e uma suíte Dart não pode exigir um passo de outra
  // linguagem: quem clonar o repo e rodar `flutter test` pegaria vermelho por não ter feito algo que
  // não veio fazer. Mesma régua do gate de ajuste — pula com o motivo escrito, nunca em silêncio.
  final temPacote = _instalado.existsSync();
  const porque = 'sem `npm install` em coreflow_design_system_web não há pacote do avô instalado '
      'para medir. Rode o install para cobrir.';

  test('a versão INSTALADA do avô é a que o pino diz', skip: temPacote ? null : porque, () {
    final pino = File('../coreflow_design_system_web/package.json').readAsStringSync();
    final tag = RegExp(r'ds-diletta#web-v([\d.]+)').firstMatch(pino)?.group(1);
    expect(tag, isNotNull, reason: 'o pacote web deixou de pinar o avô por tag `web-vX`');

    final noDisco = (jsonDecode(File('${_instalado.path}/package.json').readAsStringSync())
        as Map)['version'] as String;

    expect(noDisco, tag,
        reason: 'o `package.json` pede web-v$tag e o que está instalado é $noDisco.\n'
            'O `npm install` responde «up to date» neste estado: o lock guarda o COMMIT já '
            'resolvido, e trocar o nome da tag não o invalida. Rode:\n'
            '  npm install "diletta-design-system-web@bitbucket:diletta/ds-diletta#web-v$tag"');
  });

  test('todo degrau que as peças PEDEM resolve nas quatro faces',
      skip: temPacote ? null : porque, () {
    final pedidos = _degrausPedidos();
    // Se a colheita vier vazia, o gate aprovaria sem medir nada — e a leitura pode secar sozinha:
    // basta o avô trocar `degrau('x')` por outra forma de chamada. Vazio aqui é o gate cego, não a
    // casa limpa.
    expect(pedidos, isNotEmpty,
        reason: 'nenhuma peça instalada pede degrau — ou o avô mudou a forma de pedir e esta '
            'colheita parou de enxergar. Confira `src/base.js` dele antes de mexer aqui.');

    final avo = _folhaDoAvo(), bold = _folhaDoBold();
    final semValor = <String>[];
    for (final d in pedidos) {
      for (final f in _faces) {
        if (!_declara(avo, d, f) && !_declara(bold, d, f)) semValor.add('$d-$f');
      }
    }
    expect(semValor, isEmpty,
        reason: 'as peças pedem estas faces e NENHUMA das duas folhas as declara:\n'
            '${semValor.join('\n')}\n'
            'Variável que não resolve mata a declaração inteira no navegador, sem erro: a peça '
            'volta a desenhar com a letra da página, que é o defeito que a v0.194.2 consertou.');
  });

  test('o gate SABE reprovar — degrau inventado não resolve em folha nenhuma',
      skip: temPacote ? null : porque, () {
    // Prova por mutação: sem ela, um gate que lê a folha errada passa verde para sempre. O nome não
    // existe em lugar nenhum das duas, então as quatro faces têm que faltar.
    final avo = _folhaDoAvo(), bold = _folhaDoBold();
    for (final f in _faces) {
      expect(_declara(avo, 'degrauQueNaoExiste', f) || _declara(bold, 'degrauQueNaoExiste', f),
          isFalse);
    }
    // E o controle positivo, pra provar que a leitura enxerga o que existe.
    expect(_declara(bold, 'labelLg', 'size'), isTrue);
  });

  test('nenhum degrau resolve MISTURADO sem estar declarado', skip: temPacote ? null : porque, () {
    final avo = _folhaDoAvo(), bold = _folhaDoBold();
    // Só os que uma peça realmente PEDE. Degrau que ninguém lê pode ter buraco à vontade — o gate
    // mede desenho na tela, não simetria de tabela.
    final misturados = <String>[];
    for (final d in _degrausPedidos()) {
      final nossas = _faces.where((f) => _declara(bold, d, f));
      if (nossas.isEmpty) continue; // inteiro do avô: é a linguagem ganhando, e é a regra.
      final dele = _faces.where((f) => !_declara(bold, d, f) && _declara(avo, d, f));
      if (dele.isNotEmpty) misturados.add('$d (nossas: ${nossas.join("/")} · dele: ${dele.join("/")})');
    }
    final nomes = misturados.map((m) => m.split(' ').first).toSet();
    expect(nomes.difference(_misturadosDeclarados), isEmpty,
        reason: 'degrau novo resolvendo metade aqui e metade na folha do avô, sem ninguém '
            'declarar:\n${misturados.join('\n')}\n'
            'Ou o Bold declara a face que falta, ou o nome entra em `_misturadosDeclarados` com a '
            'razão escrita. O que não pode é a face ser preenchida por outra casa em silêncio.');
  });
}
