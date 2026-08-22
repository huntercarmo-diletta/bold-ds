import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CARD DE SALDO — composição, e a regra que ele tem que ele mesmo não escolhe.
void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          child: Scaffold(body: filho),
        ),
      );

  testWidgets('renderiza nos dois modos, com e sem os totais', (t) async {
    for (final escuro in [false, true]) {
      for (final comTotais in [false, true]) {
        await t.pumpWidget(montar(
          CoreflowSaldo(
            valor: r'R$ 2.912,47',
            aoAbrirExtrato: () {},
            entradas: comTotais ? r'R$ 300,00' : null,
            saidas: comTotais ? r'R$ 120,00' : null,
          ),
          escuro: escuro,
        ));
        await t.pump(const Duration(milliseconds: 50));
        expect(t.takeException(), isNull);
        expect(find.text('Seu saldo'), findsOneWidget);
      }
    }
  });

  testWidgets('OCULTAR cobre o valor E os totais', (t) async {
    // Decisão de produto, não detalhe: esconder o saldo e deixar as entradas visíveis não esconde
    // nada — quem vê "entrou R$ 300" já sabe a ordem de grandeza.
    await t.pumpWidget(montar(CoreflowSaldo(
      valor: r'R$ 2.912,47',
      oculto: true,
      entradas: r'R$ 300,00',
      saidas: r'R$ 120,00',
    )));
    await t.pump(const Duration(milliseconds: 50));

    expect(find.text(r'R$ 2.912,47'), findsNothing);
    expect(find.text(r'R$ 300,00'), findsNothing);
    expect(find.text(r'R$ 120,00'), findsNothing);
    expect(find.text(r'R$ ••••••'), findsOneWidget);
    expect(find.text(r'R$ ••••'), findsNWidgets(2));
  });

  testWidgets('a largura NÃO muda ao ocultar — a tela não pula', (t) async {
    // Era o motivo do `Stack` de opacidade na versão antiga. Trocado por medição de texto, e este
    // teste é o que garante que a troca preservou a garantia.
    Future<double> largura({required bool oculto}) async {
      await t.pumpWidget(montar(Align(
        alignment: Alignment.topLeft,
        child: CoreflowSaldo(valor: r'R$ 2.912,47', oculto: oculto),
      )));
      await t.pump(const Duration(milliseconds: 50));
      return t.getSize(find.byType(CoreflowSaldo)).width;
    }

    expect(await largura(oculto: false), await largura(oculto: true));
  });

  testWidgets('SALDO CURTO ocultado ainda cabe — a máscara é mais larga que ele',
      (t) async {
    // O defeito de 11/08, achado por print: saldo baixo, olho fechado, e o card
    // mostrava só `R$`. A largura reservada era a do valor REAL, e isso só
    // funciona enquanto o valor for mais largo que a máscara. `R$ 0,14` não é.
    //
    // O teste acima existia e passava, porque media com `R$ 2.912,47` — um
    // exemplo do lado confortável da desigualdade. É a lição do pai outra vez:
    // **um exemplo testa o exemplo**. O que separa "reserva o valor" de
    // "reserva o maior dos dois" é justamente o valor curto.
    // **A asserção mudou em 19/08, e o motivo é que a antiga virou proxy de nada.**
    //
    // Ela comparava a largura RENDERIZADA dos dois textos e exigia que a máscara fosse maior. Isso
    // media o defeito por tabela: com a caixa mudando de tamanho conforme o estado, a máscara maior
    // provava que a caixa tinha crescido. Só que caixa que muda por estado é o defeito do teste
    // logo acima — o card pula. Hoje a caixa é a mesma nos dois estados (o máximo dos dois textos,
    // medido sempre nos dois), então a comparação dava 252 contra 252 e não dizia mais nada.
    //
    // O que se quer saber é direto: **a máscara CABE na caixa reservada?** É isso que a linha
    // abaixo pergunta, e ela continua reprovando o defeito de 11/08.
    await t.pumpWidget(montar(Align(
      alignment: Alignment.topLeft,
      child: const CoreflowSaldo(valor: r'R$ 0,14', oculto: true),
    )));
    await t.pump(const Duration(milliseconds: 50));

    final alvo = find.text(r'R$ ••••••', findRichText: true).first;
    final precisa = t
        .renderObject<RenderParagraph>(alvo)
        .getMaxIntrinsicWidth(double.infinity);
    final caixa = t
        .renderObject<RenderBox>(
            find.ancestor(of: alvo, matching: find.byType(SizedBox)).first)
        .size
        .width;

    expect(caixa, greaterThanOrEqualTo(precisa),
        reason: 'a máscara `R\$ ••••••` tem mais caracteres que `R\$ 0,14`; se a '
            'caixa não a comporta, os pontos são cortados e o saldo some');
  });

  testWidgets('o valor LONGO manda na largura — o controle do teste de cima',
      (t) async {
    // Sem este, trocar a medição do valor pela medição da máscara passaria o
    // teste acima e reintroduziria o pulo do card em toda conta com saldo alto:
    // a caixa encolheria de `R$ 2.912,47` para `R$ ••••••` ao fechar o olho.
    await t.pumpWidget(montar(Align(
      alignment: Alignment.topLeft,
      child: const CoreflowSaldo(valor: r'R$ 2.912.345,67', oculto: true),
    )));
    await t.pump(const Duration(milliseconds: 50));
    final comValorLongo = t.getSize(find.text(r'R$ ••••••')).width;

    await t.pumpWidget(montar(Align(
      alignment: Alignment.topLeft,
      child: const CoreflowSaldo(valor: r'R$ 0,14', oculto: true),
    )));
    await t.pump(const Duration(milliseconds: 50));
    final comValorCurto = t.getSize(find.text(r'R$ ••••••')).width;

    expect(comValorLongo, greaterThan(comValorCurto),
        reason: 'a mesma máscara ocupa a largura do valor que ela esconde — '
            'é isso que impede o card de pular quando o olho vira');
  });

  testWidgets('o botão de extrato só existe quando há o que abrir', (t) async {
    await t.pumpWidget(montar(const CoreflowSaldo(valor: r'R$ 10,00')));
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('Extrato'), findsNothing);

    var abriu = 0;
    await t.pumpWidget(montar(
      CoreflowSaldo(valor: r'R$ 10,00', aoAbrirExtrato: () => abriu++),
    ));
    await t.pump(const Duration(milliseconds: 50));
    await t.tap(find.text('Extrato'));
    expect(abriu, 1);
  });

  testWidgets('carregando troca por skeleton, sem pop-in dos selos', (t) async {
    await t.pumpWidget(montar(const CoreflowSaldo(
      valor: r'R$ 2.912,47',
      carregandoValor: true,
      carregandoTotais: true,
      entradas: r'R$ 300,00',
    )));
    await t.pump(const Duration(milliseconds: 50));

    expect(find.text(r'R$ 2.912,47'), findsNothing);
    expect(find.text(r'R$ 300,00'), findsNothing,
        reason: 'o selo não pode aparecer antes do skeleton dele sair');
    expect(find.byType(DilettaSkeleton), findsNWidgets(3));
  });
}
