import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ABA DE SPECS — o dicionário do pai, LIDO e não copiado.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  /// `Scaffold` porque é o que a casca do pai monta — e é dele que vem o `Material` que a tinta do
  /// card exige. Harness que não espelha a casca acusa defeito que a tela real não tem: foi assim que
  /// eu quase carreguei um `Material` pra sempre dentro do card de componentes.
  Widget aba() => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) => configDoCatalogoDoBold()
                .abas
                .firstWhere((a) => a.id == 'specs')
                .constroi(ctx),
          ),
        ),
      );

  testWidgets('lista as specs do pai, sem exceção', (t) async {
    t.view.physicalSize = const Size(1400, 12000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final erros = <String>[];
    final anterior = FlutterError.onError;
    FlutterError.onError = (d) => erros.add(d.exceptionAsString().split('\n').first);
    await t.pumpWidget(aba());
    await t.pump(const Duration(milliseconds: 300));
    FlutterError.onError = anterior;
    t.takeException();

    expect(erros, isEmpty, reason: erros.take(3).join(' | '));
    // 69 desde a v0.17.0 do pai: as cinco que faltavam (`text`, `icon`, `gap`, `divider`,
    // `illustration`) entraram por medição minha — eram a base de qualquer tela e as únicas sem
    // dicionário. O número fica AFIRMADO aqui de propósito: se ele mudar, eu quero saber por quê.
    expect(kDilettaSpecs, hasLength(69));
    // O número na tela sai do MAPA, não de um literal que eu digitei.
    expect(find.textContaining('${kDilettaSpecs.length} contratos'), findsOneWidget);
  });

  testWidgets('NÃO copia spec: o markdown vem do pacote do pai', (t) async {
    // A garantia é estrutural e vale escrever: se algum dia alguém colar o markdown aqui, este teste
    // continua passando — mas o `faz_a_limpa` acusa md órfão, e o pai avisou por quê: cópia de
    // dicionário envelhece calada. O que ESTE teste prova é que a fonte é o pacote.
    expect(kDilettaSpecs['design-system-button'], contains('DilettaButton'));
    expect(kDilettaSpecs['design-system-button'], contains('SHALL'));
  });

  testWidgets('cruza spec com BLOCO — o que só o filho sabe fazer', (t) async {
    // O pai não sabe quais componentes este produto declarou. Este cruzamento é o que transforma 64
    // documentos numa medida de cobertura, e o slug é DERIVADO do nome da classe: tabela à mão com 64
    // linhas erra e a spec só "aparece sem bloco".
    t.view.physicalSize = const Size(1400, 12000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    await t.pumpWidget(aba());
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();

    // O botão tem bloco (`botao`), então a spec dele mostra o bloco em vez de "sem bloco aqui".
    expect(find.text('botao'), findsWidgets,
        reason: 'a spec do button não achou o bloco que a implementa');
    // E uma que o Bold não usa continua marcada como não usada — a aba não finge cobertura.
    expect(find.text('sem bloco aqui'), findsWidgets);
  });

  testWidgets('o corpo da spec abre no toque, e não antes', (t) async {
    // 64 specs abertas de uma vez é uma parede de texto. Fechado por padrão é decisão, não economia.
    t.view.physicalSize = const Size(1400, 12000);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    await t.pumpWidget(aba());
    await t.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('SHALL'), findsNothing);

    await t.tap(find.text('button'));
    await t.pump(const Duration(milliseconds: 300));
    t.takeException();
    expect(find.textContaining('SHALL'), findsWidgets,
        reason: 'abriu e não mostrou requisito nenhum');
  });
}
