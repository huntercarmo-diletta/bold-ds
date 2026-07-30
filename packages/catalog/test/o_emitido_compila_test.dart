import 'dart:io';

import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// O EMITIDO COMPILA — o gate que fecha uma família de quatro defeitos.
///
/// Em dois dias, o código gerado por este catálogo esteve errado QUATRO vezes com todos os gates
/// verdes, e a propriedade que faltava foi outra em cada uma:
///
/// | quando | o defeito | o gate que faltava |
/// |---|---|---|
/// | v0.30.0 | omitia argumento igual ao default (`const ds.X()`) | conteúdo |
/// | v0.32.1 | argumento posicional saía como `(: 'oi')` | sintaxe |
/// | v0.33.1 | callback não saía: 12 blocos sem handler | completude |
/// | — | lista obrigatória que a tabela não declara | ? |
///
/// Cada conserto virou um regex, e o regex seguinte nasceu do defeito que o anterior não previa.
/// Perseguir sintoma não termina. Este gate mede a PROPRIEDADE: monta um arquivo com o emitido de
/// todos os blocos e roda `dart analyze` nele.
///
/// O pai fez o mesmo do lado dele (`emitido_compila_test`, v0.35.0), com widgets do Flutter, porque o
/// motor não tem DS pra compilar. **A cobertura contra o DS de verdade é daqui** — é o único lugar onde
/// os dois lados existem juntos.
///
/// ## O contrato do código gerado, escrito como stub
///
/// O emitido referencia identificadores que a TELA gerada precisa ter: os handlers (`aoContinuar`) e os
/// dados de runtime (`alvosDetectados`). Declará-los aqui não é contorno — é a declaração explícita do
/// que o catálogo assume da tela que recebe o código. Se um bloco novo referenciar algo fora desta
/// lista, o gate falha, e falhar é o certo: ninguém deve descobrir isso colando o código no app.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  test('todo bloco emite código que o analisador aceita', () async {
    final emitidos = <String, String>{};
    for (final def in Ds.blocos.values) {
      if (Ds.ehChromeDeDispositivo(def.type)) continue; // não emite código, por contrato
      final codigo = temTabela(def)
          ? codigoDeBlocoDeclarado(def, def.defaults())
          : def.codegen(def.defaults());
      if (codigo.trim().isEmpty) continue;
      emitidos[def.type] = codigo;
    }
    expect(emitidos, hasLength(greaterThan(20)), reason: 'o registro encolheu?');

    final arquivo = File('.dart_tool/gate_do_emitido/tela_gerada.dart');
    await arquivo.parent.create(recursive: true);
    await arquivo.writeAsString(_arquivoDeTeste(emitidos));

    final r = await Process.run('dart', ['analyze', '--no-fatal-warnings', arquivo.path]);
    final saida = '${r.stdout}${r.stderr}';

    // CONTROLE, e ele existe por uma razão medida: o pai escreveu este mesmo gate com uma flag que não
    // existe, o `dart analyze` saiu com 64 imprimindo o *usage*, e a checagem de texto dele daria verde
    // tendo lido ZERO linha de código. Aqui: se o analisador não rodou de verdade, o teste para.
    expect(r.exitCode, anyOf(0, 1, 2, 3),
        reason: 'o `dart analyze` nem rodou (código ${r.exitCode}):\n$saida');
    expect(saida, isNot(contains('Usage: dart analyze')),
        reason: 'flag inválida — o analisador imprimiu ajuda em vez de analisar');

    final erros = saida
        .split('\n')
        .where((l) => l.contains('error') && l.contains('.dart:'))
        .toList();

    // A dívida do `$` MORREU na v0.38.1 do motor: `_escapa` passou a cobrir barra, apóstrofe e dólar,
    // na ordem que o pedido indicou. Este gate voltou a exigir ZERO erro de qualquer classe, que é onde
    // ele deveria estar desde o começo — e foi o próprio gate que mediu o conserto.
    expect(erros, isEmpty,
        reason: 'o código gerado NÃO compila:\n${erros.join('\n')}\n\n'
            'emitido:\n${emitidos.entries.map((e) => '${e.key}: ${e.value}').join('\n')}');
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('e o gate SABE falhar — controle com código inválido de propósito', () async {
    // Gate que não constrói o defeito não prova nada (frase do pai, e ela custou três consertos pra
    // virar rotina aqui). Este caso monta um construtor sem argumento obrigatório — o defeito da
    // v0.30.0 — e cobra vermelho.
    final arquivo = File('.dart_tool/gate_do_emitido/controle.dart');
    await arquivo.parent.create(recursive: true);
    await arquivo.writeAsString(_arquivoDeTeste({
      'defeitoDeProposito': 'ds.DilettaPageTitle()',
    }));

    final r = await Process.run('dart', ['analyze', '--no-fatal-warnings', arquivo.path]);
    final saida = '${r.stdout}${r.stderr}';
    final erros = saida
        .split('\n')
        .where((l) => l.contains('error') && l.contains('.dart:'))
        .toList();
    expect(erros, isNotEmpty,
        reason: 'o analisador aceitou `ds.DilettaPageTitle()` sem `title` — então este gate '
            'não estava medindo nada');
  }, timeout: const Timeout(Duration(minutes: 3)));
}

/// O arquivo que vai ao analisador: os stubs que a tela gerada precisa ter, e o emitido dentro deles.
String _arquivoDeTeste(Map<String, String> emitidos) {
  final linhas = emitidos.entries.map((e) => '      // ${e.key}\n      ${e.value},').join('\n');
  return '''
// GERADO PELO GATE — não editar. Ver test/o_emitido_compila_test.dart.
// ignore_for_file: unused_local_variable, unused_element, unused_field
${Ds.importNoCodigo}
import 'package:flutter/widgets.dart';

/// Os identificadores que o código emitido referencia. É o CONTRATO do que o catálogo assume da tela
/// que recebe o código gerado — handler e dado de runtime.
class TelaGerada extends StatelessWidget {
  const TelaGerada({super.key});

  // handlers
  void aoContinuar() {}
  void aoTocar() {}
  void aoTocarNaLinha() {}
  void abrirExtrato() {}
  void aoTrocarAba(int i) {}
  void aoTrocarSegmento(int i) {}
  void aoTrocar(bool v) {}
  void aoMarcar(bool? v) {}
  void aoBuscar(String v) {}
  void aoFiltrar() {}
  void onContinuar() {}
  void onVoltar() {}
  void onX() {}

  // dados de runtime
  //
  // Cada linha aqui é uma coisa que o catálogo ASSUME da tela que recebe o código — e foi o gate que
  // obrigou a declarar, uma por uma, com o TIPO certo. `rows: linhasDoComprovante` sendo
  // `List<DilettaReceiptRow>` é contrato; se eu declarasse `List<Widget>` o analisador acusaria.
  List<ds.DilettaReceiptRow> get linhasDoComprovante => const [];
  List<ds.DilettaReceiptSection> get secoesDoComprovante => const [];
  Widget get conteudoDaFolha => const SizedBox.shrink();
  List<Widget> get acoesDoDialogo => const [];
  List<ds.DilettaRadioOption> get opcoesDoRadio => const [];
  List<ds.DilettaCriteriaItem> get criteriosDaSenha => const [];
  List<String> get opcoesDoCampo => const [];
  List<Widget> get conteudoDoExpansivel => const [];
  Color get corDaMarca => const Color(0xFFFE3976);
  void aoFechar() {}
  void aoVoltar() {}
  void aoEscolher(String v) {}
  void aoEscolherData(DateTime d) {}
  void aoTeclar(String t) {}
  void aoApagar() {}
  DateTime? get dataEscolhida => null;
  List<ds.BoldAlvo> get alvosDetectados => const [];
  List<String> get rotulosDasAbas => const ['Tudo', 'Entradas'];
  double get faseDaVarredura => 0;
  Size get tamanhoDoFrame => Size.zero;
  List<ds.BoldDegrauDeAlcada> get degrausDaAlcada => const [];

  @override
  Widget build(BuildContext context) {
    final blocos = <Widget>[
$linhas
    ];
    return ds.DilettaFrame.column(children: blocos);
  }
}
''';
}
