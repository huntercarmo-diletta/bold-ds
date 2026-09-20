// O QUE ESTÁ INSTALADO, E O QUE AS PEÇAS PEDEM.
//
// Os outros gates deste pacote medem o que está ESCRITO — o pino no `package.json`, a escala no
// `.css`, os degraus no Dart. Nenhum abre a pasta de dependências pra ver o que está lá de verdade,
// e os dois buracos disso foram medidos em 15/09 subindo o avô no primeiro produto desta casa:
//
//   1. a tag no `package.json` mudou, o `npm install` respondeu «up to date», e o que estava
//      instalado continuou sendo a versão velha — o lock guarda o COMMIT já resolvido, e trocar o
//      nome da tag não o invalida. Quem sobe o pino, confia na resposta e publica, publica a versão
//      velha achando que subiu;
//
//   2. as peças web do avô leem `--diletta-type-<degrau>-*`, e **o nome do degrau quem escolhe é a peça
//      DELE**. Se ela pedir um que ninguém declara, a variável não resolve, a declaração morre no
//      navegador sem erro, e a peça desenha com a letra da PÁGINA hospedeira.
//
// O gate de paridade anda os degraus que este produto DECLARA e confere que a web os escreve. Ele
// nunca faz a pergunta inversa. **Cobrir a fonte não é o mesmo que cobrir a demanda.**
import 'dart:convert';
import 'dart:io';

// `prefixoDaLinguagem` mora aqui: o nome das variáveis é da LINGUAGEM, e um filho que o escrevesse
// à mão repetiria o erro que a troca de prefixo da v0.107.0 veio desfazer.
import 'package:coreflow/coreflow.dart';
import 'package:flutter_test/flutter_test.dart';

/// A raiz do pacote do avô dentro da pasta de dependências do lado web deste produto.
final _instalado = Directory('web/node_modules/diletta-design-system-web');

/// As duas folhas, na ordem da cascata: a do avô primeiro, a deste produto depois.
///
/// A ordem importa pro navegador e NÃO importa aqui: o gate pergunta se o nome existe em ALGUMA das
/// duas, que é o que decide se a variável resolve. Qual delas ganha é assunto do gate de paridade.
///
/// E a do avô é a que TEM OS VALORES — `diletta-tokens.css`. Era `cps-tokens.css`, e a partir da
/// v0.198.0 dele esse arquivo virou PONTE: só declara `--cps-x: var(--diletta-x)`, sem um valor
/// dentro. Gate que procura valor numa folha de apelidos reprova por motivo errado — ou, pior,
/// encontra o apelido e aprova achando que mediu o valor.
String _folhaDoAvo() =>
    File('${_instalado.path}/tokens/diletta-tokens.css').readAsStringSync();

/// A folha deste produto. Pode não existir antes da primeira emissão — e antes dela não há escala
/// nossa nenhuma, então a do avô responde sozinha, que é o estado de um produto recém-nascido.
String _nossaFolha() {
  final f = File('web/tokens/meu_banco-tokens.css');
  return f.existsSync() ? f.readAsStringSync() : '';
}

/// Os degraus que as peças instaladas PEDEM — colhidos do CÓDIGO delas, não de uma lista nossa.
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
/// o peso da página, que é metade do defeito que a `v0.194.2` do avô consertou.
const _faces = ['size', 'weight', 'line-height', 'spacing'];

bool _declara(String folha, String degrau, String face) =>
    folha.contains('${prefixoDaLinguagem}type-$degrau-$face:');

/// Os degraus que resolvem MISTURADO — parte na nossa folha, parte na do avô.
///
/// Não é defeito por si: um produto declara a escala dele e cala nas faces que não tem opinião, e
/// calar é o mecanismo do white label. **É defeito quando ninguém sabe**, porque o app e a web
/// preenchem o silêncio por caminhos diferentes — na web a face que falta cai na folha do avô, no
/// Flutter ela cai no que o contexto de texto der. Dois silêncios, dois valores.
///
/// Nasce vazio porque um produto recém-nascido não declara escala. A lista é catraca: nome novo aqui
/// é uma face sendo preenchida por outra casa sem ninguém decidir.
const _misturadosDeclarados = <String>{};

void main() {
  // SEM `npm install` NÃO HÁ O QUE MEDIR, e uma suíte Dart não pode exigir um passo de outra
  // linguagem: quem clonar e rodar `flutter test` pegaria vermelho por não ter feito algo que não
  // veio fazer. Mesma régua do gate de ajuste — pula com o motivo escrito, nunca em silêncio.
  final temPacote = _instalado.existsSync();
  const porque = 'sem `npm install` em web/ não há pacote do avô instalado para medir. '
      'Rode o install para cobrir.';

  test('a versão INSTALADA do avô é a que o pino diz', skip: temPacote ? null : porque, () {
    final pino = File('web/package.json').readAsStringSync();
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
    // Colheita vazia é o gate cego, não a casa limpa: basta o avô trocar `degrau('x')` por outra
    // forma de chamada e esta leitura seca sozinha, aprovando sem medir.
    expect(pedidos, isNotEmpty,
        reason: 'nenhuma peça instalada pede degrau — ou o avô mudou a forma de pedir e esta '
            'colheita parou de enxergar. Confira o `src/base.js` dele antes de mexer aqui.');

    final avo = _folhaDoAvo(), nossa = _nossaFolha();
    final semValor = <String>[];
    for (final d in pedidos) {
      for (final f in _faces) {
        if (!_declara(avo, d, f) && !_declara(nossa, d, f)) semValor.add('$d-$f');
      }
    }
    expect(semValor, isEmpty,
        reason: 'as peças pedem estas faces e NENHUMA das duas folhas as declara:\n'
            '${semValor.join('\n')}\n'
            'Variável que não resolve mata a declaração inteira no navegador, sem erro: a peça '
            'desenha com a letra da página.');
  });

  test('o gate SABE reprovar — degrau inventado não resolve em folha nenhuma',
      skip: temPacote ? null : porque, () {
    // Prova por mutação: sem ela, um gate que lê a folha errada passa verde para sempre.
    final avo = _folhaDoAvo(), nossa = _nossaFolha();
    for (final f in _faces) {
      expect(_declara(avo, 'degrauQueNaoExiste', f) || _declara(nossa, 'degrauQueNaoExiste', f),
          isFalse);
    }
    // E o controle positivo, pra provar que a leitura enxerga o que existe. `labelLg` é do avô e
    // está na folha dele mesmo antes deste produto declarar escala nenhuma.
    expect(_declara(avo, 'labelLg', 'size'), isTrue);
  });

  test('nenhum degrau resolve MISTURADO sem estar declarado', skip: temPacote ? null : porque, () {
    final avo = _folhaDoAvo(), nossa = _nossaFolha();
    // Só os que uma peça realmente PEDE. Degrau que ninguém lê pode ter buraco à vontade — o gate
    // mede desenho na tela, não simetria de tabela.
    final misturados = <String>[];
    for (final d in _degrausPedidos()) {
      final nossas = _faces.where((f) => _declara(nossa, d, f));
      if (nossas.isEmpty) continue; // inteiro do avô: é a linguagem ganhando, e é a regra.
      final dele = _faces.where((f) => !_declara(nossa, d, f) && _declara(avo, d, f));
      if (dele.isNotEmpty) {
        misturados.add('$d (nossas: ${nossas.join("/")} · dele: ${dele.join("/")})');
      }
    }
    final nomes = misturados.map((m) => m.split(' ').first).toSet();
    expect(nomes.difference(_misturadosDeclarados), isEmpty,
        reason: 'degrau novo resolvendo metade aqui e metade na folha do avô, sem ninguém '
            'declarar:\n${misturados.join('\n')}\n'
            'Ou este produto declara a face que falta, ou o nome entra em `_misturadosDeclarados` '
            'com a razão escrita. O que não pode é a face ser preenchida por outra casa em '
            'silêncio.');
  });
}
