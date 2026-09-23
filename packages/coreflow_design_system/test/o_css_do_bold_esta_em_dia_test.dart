// OS GATES QUE O IB NÃO TEM.
//
// O Internet Banking mantém os tokens de cor, tipo, espaço e raio transcritos à mão a partir do Dart
// deste repo, e ZERO gates ligando a transcrição à fonte — então a pergunta "isto ainda é a nossa
// cor?" não tem resposta lá. Estes existem pra que ela tenha resposta aqui, todo dia, de graça.
import 'dart:io';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css_do_bold.dart' show cssDoBold, cssDoBoldComPonte;

/// As colisões DECLARADAS entre o esquema deste produto e os papéis do avô.
///
/// Colidir é o mecanismo, não o defeito: o produto declara `primary` e o dele ganha do papel genérico
/// da linguagem, que é o white label acontecendo na cascata. O `border` colide com o MESMO valor, e
/// fica na lista porque ausência calada não conta.
///
/// **O gate não proíbe colisão — proíbe colisão que ninguém declarou.** A terceira que aparecer sem
/// entrar aqui é um papel do avô sendo roubado sem ninguém ver.
const _colisoesDeclaradas = {'primary', 'border'};

void main() {
  test('o CSS emitido é o que está no disco', () {
    final f = File('../coreflow_design_system_web/tokens/bold-tokens.css');
    expect(f.existsSync(), isTrue,
        reason: 'bold-tokens.css não existe — rode `flutter test test/emite_o_css_do_bold.dart`');
    expect(
      f.readAsStringSync(),
      cssDoBoldComPonte(),
      reason: 'o CSS do disco divergiu da fonte. Alguém editou à mão, ou a tinta mudou e ninguém '
          'reemitiu: `flutter test test/emite_o_css_do_bold.dart`',
    );
  });

  test('a folha cobre os mesmos papéis de cor que o avô', () {
    final nossos = RegExp('${RegExp.escape(prefixoDaLinguagem)}([A-Za-z]+):')
        .allMatches(coreflowPapeisCss(BoldPalette.bold, produto: 'x'))
        .map((m) => m.group(1)!)
        .toSet();
    final semTinta = dilettaNomesDePapelGen.where((p) => !nossos.contains(p)).toList();
    // Os dois sem tinta são do avô e declarados por ele (`glassStroke`, `skeletonShimmer`). O que
    // este gate proíbe é um TERCEIRO aparecer sem ninguém ver.
    expect(semTinta.length, lessThanOrEqualTo(2),
        reason: 'papéis sem tinta na folha do Bold: $semTinta');
  });

  test('o esquema do produto só sobrescreve o que está declarado', () {
    Set<String> nomes(String css) =>
        RegExp('${RegExp.escape(prefixoDaLinguagem)}([A-Za-z]+):').allMatches(css).map((m) => m.group(1)!).toSet();
    final doAvo = nomes(coreflowPapeisCss(BoldPalette.bold, produto: 'x'));
    final doProduto = nomes(coreflowEsquemaCss(BoldPalette.bold));
    expect(doProduto.intersection(doAvo), _colisoesDeclaradas,
        reason: 'o esquema deste produto sobrescreve papel do avô fora da lista declarada — '
            'ou o avô ganhou um papel com nome que já era nosso. Os dois casos pedem decisão, '
            'não uma linha a mais na constante.');
  });

  test('a folha emitida segue o raio que o PRODUTO declarou, não a gramática', () {
    // O conserto de 14/09: `coreflowMedidasCss` emitia a const, então um filho com `raioDeFolha: 8`
    // recebia 22px no CSS e via o Flutter desenhar 8. Este gate é o que impede a volta — e ele mede
    // com uma paleta DIFERENTE da nossa, porque a do Bold declara justamente 22 e esconderia o
    // defeito por coincidência.
    // `DilettaPalette` é imutável e não tem `copyWith` — um produto declara a forma dele no
    // `comMaterial`, que é por onde um filho nasce. Montar assim é usar o caminho de verdade.
    final outra = DilettaPalette.daMarca(marca: const Color(0xFF2F6FC4), id: 'x', nome: 'X')
        .comMaterial(raioDeFolha: 8);
    expect(coreflowMedidasCss(outra), contains('${prefixoDaLinguagem}formaDeFolha: 8px;'));
    expect(coreflowMedidasCss(BoldPalette.bold), contains('${prefixoDaLinguagem}formaDeFolha: 22px;'));
  });

  test('o pacote WEB recebe o mesmo avô que este pacote Dart', () {
    // O GATE QUE FALTAVA, e a falta foi medida: em 14/09 o `ref:` do Dart subiu pra v0.194.0 e o
    // `package.json` do web ficou na v0.193.0, porque quem subiu não tinha npm pra re-resolver o
    // lock. Eu tinha escrito a guarda equivalente no GERADOR — ela pegou, e o filho hipotético
    // recebeu v0.194.0 enquanto o produto de verdade ficou atrás.
    //
    // **Guardar o futuro e deixar o presente aberto é a forma de gate que não serve.**
    final dart = RegExp(r'ref:\s*(v[\d.]+)')
        .firstMatch(File('pubspec.yaml').readAsStringSync())
        ?.group(1);
    expect(dart, isNotNull, reason: 'este pacote deixou de pinar o avô por tag');
    final web = RegExp(r'ds-diletta#(web-v[\d.]+)')
        .firstMatch(File('../coreflow_design_system_web/package.json').readAsStringSync())
        ?.group(1);
    expect(web, isNotNull, reason: 'o pacote web deixou de pinar o avô por tag `web-vX`');
    //
    // «Uma língua, um número» vale no `X.Y`; o patch da web anda sozinho. Em 22/09 o avô queimou
    // `web-v0.207.0` e `web-v0.208.0` (as duas apontavam pro monorepo, 1575 e 1577 arquivos) e,
    // por não reescrever tag publicada, REEMITIU com nome novo: `web-v0.207.1` é «a instância web
    // de v0.207.0», 45 arquivos, e entre ela e a `web-v0.208.1` muda uma linha — a versão. Não há
    // `v0.207.1` em Dart, e não vai haver: o Dart não teve defeito. Então a regra que pega o
    // incidente de 14/09 (web parada numa versão ATRÁS) sem proibir a reemissão é esta: mesmo
    // maior e menor, e o patch da web nunca abaixo do do Dart.
    expect(_mesmaLinguagem(dart: dart!, web: web!), isTrue,
        reason: 'o Dart recebe o avô em $dart e o pacote web recebe $web — uma língua, um número '
            'no `X.Y`; o patch da web só pode ser igual ou maior (reemissão). Suba o `package.json` '
            'e rode `npm install "diletta-design-system-web@bitbucket:diletta/ds-diletta#web-$dart"` '
            'pra re-resolver o lock.');
  });

  test('a forma emitida segue o ALIAS do produto, não a gramática', () {
    // Segunda vez que a mesma classe de defeito aparece nesta função, e as duas vezes por pular um
    // degrau da cadeia. As formas resolvem em três: tabela de medidas → campo `raioDeX` (o alias) →
    // desenho da linguagem. Ler a tabela direto devolve nulo pro Conta BOLD, que declara
    // `raioDeBotao: 16` e receberia 999 — a pílula, num produto cujo botão não é pílula.
    expect(coreflowMedidasCss(BoldPalette.bold), contains('${prefixoDaLinguagem}formaDeBotao: 16px;'),
        reason: 'o alias `raioDeBotao` do produto parou de ser lido');

    // E o controle: uma paleta que não declara NADA recebe o desenho da LINGUAGEM, sem herdar o 16
    // deste produto. Filho de outro banco não nasce com o botão do Bold.
    //
    // O número é 200 e não 999 porque o default é do avô, e o `///` do `CoreflowRadius` já diz por
    // que os dois convivem: *"o pai usa 200; 999 e 200 desenham o mesmo em qualquer altura de
    // controle"*. Quem cai no default cai no dele — é a linguagem ganhando, que é a regra.
    final outra = DilettaPalette.daMarca(marca: const Color(0xFF2F6FC4), id: 'x', nome: 'X');
    expect(coreflowMedidasCss(outra), contains('${prefixoDaLinguagem}formaDeBotao: 200px;'));
  });

  test('a escala de tipo emitida tem os 20 degraus do CoreflowType', () {
    final degraus = RegExp('${RegExp.escape(prefixoDaLinguagem)}type-([A-Za-z0-9]+)-size:')
        .allMatches(cssDoBold())
        .map((m) => m.group(1)!)
        .toSet();
    // A tabela do emissor é escrita à mão porque `TextStyle` estático não se enumera. Este número é
    // a catraca: degrau novo no `CoreflowType` sem entrar na tabela reprova aqui.
    expect(degraus.length, 20, reason: 'degraus emitidos: ${degraus.length} — a tabela do emissor '
        'ficou para trás do CoreflowType, ou alguém a encolheu');
  });
}

/// `vX.Y.Z` (Dart) e `web-vX.Y.W` (web) são a mesma linguagem quando `X.Y` coincide e `W >= Z`.
/// O `W > Z` existe por causa da reemissão do avô (22/09): tag web queimada não se reescreve, sai
/// com o patch seguinte, e o Dart fica onde estava.
bool _mesmaLinguagem({required String dart, required String web}) {
  List<int> partes(String tag) =>
      RegExp(r'(\d+)\.(\d+)\.(\d+)').firstMatch(tag)!.groups([1, 2, 3]).map((g) => int.parse(g!)).toList();
  final d = partes(dart), w = partes(web);
  return d[0] == w[0] && d[1] == w[1] && w[2] >= d[2];
}
