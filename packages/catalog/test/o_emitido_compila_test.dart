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
/// | — | opção de enum que muda a FORMA do emitido | cobertura de variação |
///
/// Cada conserto virou um regex, e o regex seguinte nasceu do defeito que o anterior não previa.
/// Perseguir sintoma não termina. Este gate mede a PROPRIEDADE: monta um arquivo com o emitido de
/// todos os blocos e roda `dart analyze` nele.
///
/// A quarta linha é de hoje, e ela mostra o limite que a primeira versão tinha: emitir só `defaults()`
/// compila UM valor por prop de enum, e há bloco cujo emitido muda de forma com a opção
/// (`ds.DilettaAppList.${idioma}` põe o valor no nome do construtor). Dois testes, então: o emitido de
/// cada bloco, e o emitido de cada OPÇÃO.
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
    // Pelo `codigoDoBloco` DO MOTOR, e não pelas peças de baixo.
    //
    // A primeira versão fazia `temTabela(def) ? codigoDeBlocoDeclarado(def, props) : def.codegen(props)` —
    // uma cópia da precedência dele. E a precedência tem mais degraus do que eu sabia: `slotsCodegen`
    // **vence a tabela**, e `repeatCodegen` vence os dois. No dia em que um bloco meu com tabela ganhasse
    // slot, o gate mediria o caminho que o motor não usa, e verde aqui significaria nada.
    //
    // Regra que eu já tinha aprendido do outro lado hoje, na fonte: **medir pelo caminho do PRODUTOR.**
    final emitidos = <String, String>{};
    for (final def in Ds.blocos.values) {
      if (Ds.ehChromeDeDispositivo(def.type)) continue; // não emite código, por contrato
      final codigo = codigoDoBloco(_blocoDe(def, def.defaults()));
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

  test('e compila com cada OPÇÃO de enum, não só com o default', () async {
    // A quinta linha da tabela lá em cima, e ela nasceu da checagem 9 da auditoria do pai.
    //
    // O gate de cima emite `def.defaults()`, então ele compila **um** valor por prop de enum. Mas há
    // bloco cujo emitido MUDA de forma com a opção — `ds.DilettaAppList.${idioma}` põe o valor no nome
    // do CONSTRUTOR, e `carded` (o default) é o único que estava sendo compilado. Se `menu` não fosse um
    // construtor de verdade, nada aqui acusaria; o defeito apareceria em quem colasse o código.
    //
    // Limite de 12 opções por prop, e é medido: `icone` oferece os **352** ícones do pai e o valor entra
    // como string — a forma do emitido não muda de um pro outro, então compilar 352 mede o mesmo que
    // compilar um, num arquivo dez vezes maior.
    //
    // Era 358 aqui até a `ds v0.46.0`: o pai tinha 358 arquivos no disco e 351 nomeáveis, e nenhum dos
    // dois números era o que a doc dele dizia. O gate que faltava media do nome pro arquivo e não do
    // arquivo pro nome — os 6 exports crus moravam justo nessa direção. Agora os dois lados são 352.
    final emitidos = <String, String>{};
    var variacoes = 0;
    for (final def in Ds.blocos.values) {
      if (Ds.ehChromeDeDispositivo(def.type)) continue;
      for (final (nome, prop) in def.props.entries.map((e) => (e.key, e.value))) {
        if (prop.kind != 'enum' || prop.options == null) continue;
        if (prop.options!.length > 12) continue;
        final padrao = '${def.defaults()[nome]}';
        for (final opcao in prop.options!.where((o) => o != padrao)) {
          final props = {...def.defaults(), nome: opcao};
          final codigo = codigoDoBloco(_blocoDe(def, props));
          if (codigo.trim().isEmpty) continue;
          emitidos['${def.type}·$nome=$opcao'] = codigo;
          variacoes++;
        }
      }
    }
    expect(variacoes, greaterThan(50),
        reason: 'quase nenhuma variação de enum: o registro perdeu os `options`?');

    final arquivo = File('.dart_tool/gate_do_emitido/variacoes.dart');
    await arquivo.parent.create(recursive: true);
    await arquivo.writeAsString(_arquivoDeTeste(emitidos));

    final r = await Process.run('dart', ['analyze', '--no-fatal-warnings', arquivo.path]);
    final saida = '${r.stdout}${r.stderr}';
    expect(saida, isNot(contains('Usage: dart analyze')));

    final erros =
        saida.split('\n').where((l) => l.contains('error') && l.contains('.dart:')).toList();
    expect(erros, isEmpty,
        reason: 'opção de enum que emite código inválido:\n${erros.join('\n')}');
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

/// O `Block` que o motor espera, com os SLOTS preenchidos pelo primeiro tipo que cada um aceita.
///
/// Slot vazio não é o caso de uso: bloco de container existe pra ter filho, e emitir com a lista vazia
/// mediria o container e não a composição. Um filho por slot já exercita o caminho inteiro (o código do
/// filho, o embrulho do pai e o `collection-if` de visibilidade quando o slot é de lista).
Block _blocoDe(BlockDef def, Map<String, dynamic> props) {
  final slots = <String, List<Block>>{};
  def.slots.forEach((nome, slot) {
    // Slot ABERTO (`accepts` vazio) recebe um bloco qualquer — e essa linha é o conserto de um furo que eu
    // ia deixar: `accepts.firstOrNull` num slot aberto dá `null`, então os dois slots abertos deste registro
    // (`folha.conteudo` e `expansivel.conteudo`) ficariam **sem filho** e o gate mediria a casca vazia.
    // Verde, e sem exercitar a composição — que é justamente o que a conversão pra slot introduziu.
    final tipo = slot.accepts.isEmpty ? 'botao' : slot.accepts.first;
    final filho = Ds.blocos[tipo];
    if (filho == null) return;
    slots[nome] = [Block(id: 'filho-$nome', type: tipo, props: filho.defaults())];
  });
  return Block(id: 'bloco-${def.type}', type: def.type, props: props, slots: slots);
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
