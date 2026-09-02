import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// ID VAZIO É AUSÊNCIA, NÃO RÓTULO EM BRANCO — e a régua mede COMPORTAMENTO.
///
/// O rodapé do comprovante checava `transactionId != null`, e o repositório de um produto devolve
/// **string vazia** quando o servidor não manda o id. Resultado: *"ID da transação"* impresso com
/// nada embaixo, lido num QA como *"não exibe ID"* (bug #90 da 3.4.0).
///
/// O gate que pegou isso lá lia o CÓDIGO — procurava `(transactionId ?? '').isNotEmpty` no arquivo.
/// Ele funcionava, e parou de funcionar no dia em que o arquivo mudou de repo. Este mede o que
/// aparece na tela, e é mais forte pela mesma razão: **um `isNotEmpty` escrito no lugar errado
/// passa na leitura e não passa aqui.**
void main() {
  Widget comprovante(String? id) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(
          theme: CoreflowTheme.light,
          child: Scaffold(
            body: SingleChildScrollView(
              child: CoreflowComprovante(
                title: 'Comprovante',
                timestamp: '02 Set 2026 - 10:00',
                transactionId: id,
              ),
            ),
          ),
        ),
      );

  for (final (nome, id) in [('vazio', ''), ('só espaço', '   '), ('nulo', null)]) {
    testWidgets('ID $nome não desenha o rótulo', (t) async {
      await t.pumpWidget(comprovante(id));
      await t.pumpAndSettle();
      expect(find.text('ID da transação'), findsNothing,
          reason: 'rótulo sem valor embaixo lê como "não tem ID" — e o campo existe');
    });
  }

  testWidgets('e com ID de verdade o rótulo aparece, com o copiar', (t) async {
    // O CONTROLE: sem ele, um rodapé que parasse de desenhar o ID passaria os três de cima.
    await t.pumpWidget(comprovante('E60746948202608051930abc'));
    await t.pumpAndSettle();
    expect(find.text('ID da transação'), findsOneWidget);
    expect(find.byType(CoreflowCopiar), findsOneWidget);
  });

  test('e o crivo do copiável descarta os marcadores de ausência', () {
    // As telas escrevem `—`, `-` ou `N/A` quando não há ID. Sem o crivo, o botão ofereceria copiar
    // um travessão.
    for (final falso in ['', '   ', '—', '-', 'N/A', 'abc']) {
      expect(CoreflowComprovante.idCopiavel(falso), isFalse, reason: '"$falso" não é ID');
    }
    expect(CoreflowComprovante.idCopiavel('E6074694'), isTrue);
  });
}
