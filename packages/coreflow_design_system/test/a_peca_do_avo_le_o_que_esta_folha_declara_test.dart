// O GATE QUE FALTAVA, e a falta custou uma release quase publicada.
//
//     flutter test test/a_peca_do_avo_le_o_que_esta_folha_declara_test.dart
//
// ## O que aconteceu em 17/09
//
// A `v0.198.0` do avô renomeou toda variável de `--cps-*` para `--diletta-*` **e passou a ler os
// nomes novos dentro das peças**. Ele emitiu uma ponte — `--cps-x: var(--diletta-x)` — e ela serve
// para quem ESCREVE o nome velho na própria folha. Um consumidor.
//
// Nós não escrevemos: nós SOBRESCREVEMOS. E sobrescrever o nome velho não alcança quem lê o novo.
//
// Medido num diretório vazio, com o pacote instalado pela tag, antes de publicar: o
// `<diletta-button>` desenhou em **#17a37d** — o verde de referência — com a nossa folha declarando
// `--cps-primary: #f66fa0` logo ao lado. **Sem um erro no console.** É o modo de falhar que o README
// deste pacote já descrevia («fora de ordem, a referência ganha e a tela sai verde») chegando por
// outra porta: não pela ordem, pelo NOME.
//
// ## Por que os 440 testes passaram
//
// Todos conferiam a folha contra a FONTE dela: que a emissão corresponde ao Dart, que a versão
// instalada casa com o pino, que os degraus resolvem. Todos certos, e nenhum perguntava a única
// coisa que este pacote existe para garantir: **a peça do avô, desenhada, sai na cor deste
// produto?**
//
// Este gate faz a pergunta do jeito estático: o nome que a PEÇA lê tem que ser o nome que a FOLHA
// declara. Não precisa de navegador para pegar a classe inteira — precisava só de alguém olhar os
// dois lados ao mesmo tempo.
import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css_do_bold.dart' show cssDoBoldComPonte;

/// Todo `var(--x)` lido pelos fontes das peças do avô.
Set<String> _lidosPelasPecas() {
  final dir = Directory('../coreflow_design_system_web/node_modules/diletta-design-system-web/src');
  if (!dir.existsSync()) return const {};
  final fora = <String>{};
  for (final f in dir.listSync().whereType<File>().where((f) => f.path.endsWith('.js'))) {
    for (final m in RegExp(r'var\(\s*(--[A-Za-z0-9_-]+)').allMatches(f.readAsStringSync())) {
      fora.add(m.group(1)!);
    }
  }
  return fora;
}

/// Todo `--x:` declarado pela folha deste produto.
Set<String> _declaradosPorNos(String css) =>
    RegExp(r'(--[A-Za-z0-9_-]+)\s*:').allMatches(css).map((m) => m.group(1)!).toSet();

String? _semPrefixo(String nome) {
  for (final p in const [prefixoDaLinguagem, prefixoDaPonte]) {
    if (nome.startsWith(p)) return nome.substring(p.length);
  }
  return null;
}

void main() {
  final css = cssDoBoldComPonte();
  final lidos = _lidosPelasPecas();
  final nossos = _declaradosPorNos(css);

  test('a varredura acha os dois lados de verdade', () {
    // Sem isto, um caminho errado devolveria conjunto vazio e o gate aprovaria qualquer coisa —
    // que é exatamente como esta classe passou despercebida até agora.
    expect(lidos.length, greaterThan(20), reason: 'não li os fontes das peças do avô');
    expect(nossos.length, greaterThan(250), reason: 'não li a folha deste produto');
    expect(lidos, contains('${prefixoDaLinguagem}primary'));
  });

  test('todo papel que esta folha sobrescreve é lido pelas peças no MESMO nome', () {
    final mudos = <String>[];
    for (final lido in lidos) {
      final papel = _semPrefixo(lido);
      if (papel == null) continue; // variável interna da peça, não é papel da língua
      // A peça lê este papel. Nós o declaramos em ALGUM prefixo?
      final declaramos = nossos.contains('$prefixoDaLinguagem$papel') ||
          nossos.contains('$prefixoDaPonte$papel');
      if (!declaramos) continue; // papel que não é nosso — o avô que responde por ele
      // Declaramos. Então precisa ser no nome que a peça LÊ.
      if (!nossos.contains(lido)) {
        mudos.add(lido);
      }
    }
    expect(mudos, isEmpty,
        reason: 'esta folha declara estes papéis com OUTRO nome do que a peça lê — a tinta do '
            'produto não chega, e o navegador não reclama:\n${mudos.join('\n')}');
  });

  test('a ponte não substitui a declaração — ela acompanha', () {
    // O conserto errado seria declarar SÓ o nome velho e confiar na ponte do avô. A ponte dele
    // aponta velho → novo, então o nosso valor ficaria num apelido que ninguém lê.
    for (final papel in const ['primary', 'onPrimary', 'surface', 'textPrimary']) {
      expect(nossos, contains('$prefixoDaLinguagem$papel'),
          reason: '$papel precisa ser declarado no nome da LINGUAGEM, que é o que a peça lê');
      expect(nossos, contains('$prefixoDaPonte$papel'),
          reason: '$papel precisa continuar com apelido, para o consumidor que já escreveu o velho');
    }
  });
}
