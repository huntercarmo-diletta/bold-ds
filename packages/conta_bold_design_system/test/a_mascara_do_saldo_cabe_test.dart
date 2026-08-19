import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// A MÁSCARA CABE NA CAIXA — e o gate existe porque o medidor não sabia em que fonte o texto ia
/// sair.
///
/// O card reserva a largura do MAIOR entre o valor real e a máscara, pra alternar o olho não fazer
/// a tela pular. A conta usava um `TextPainter` alimentado com o degrau de tipo cru — e degrau de
/// tipo desta linguagem **não fixa família nem escala**, ele herda do tema. O `TextPainter` não
/// herda nada: media um texto que a tela ia pintar diferente.
///
/// O sintoma é o pior tipo, porque parece decisão de produto: `R$ ••••••` é mais larga que
/// `R$ 0,14`, então numa conta com saldo baixo o valor oculto aparecia CORTADO — sumia depois do
/// `R$`, como se a peça não tivesse máscara nenhuma.
///
/// O gate mede a caixa contra a largura intrínseca do texto, com a escala do sistema dobrada. A
/// escala é o lever mais honesto num teste: ela reproduz o mesmo defeito por outra causa — o
/// medidor ignorando algo que a tela aplica.
void main() {
  Future<void> montar(WidgetTester tester,
      {required double escala, required bool oculto}) async {
    await tester.pumpWidget(MaterialApp(
      theme: BoldTemaMaterial.claro,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(escala)),
        child: DilettaThemeScope(
          theme: BoldTheme.light,
          child: Scaffold(
            body: Center(
              child: BoldSaldo(valor: r'R$ 0,14', oculto: oculto),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  /// A caixa reservada e o que o texto realmente precisa, no mesmo `pump`.
  ({double caixa, double precisa}) medir(WidgetTester tester, String texto) {
    final paragrafo = tester.renderObject<RenderParagraph>(
        find.text(texto, findRichText: true).first);
    final caixa = tester
        .renderObject<RenderBox>(find
            .ancestor(
                of: find.text(texto, findRichText: true).first,
                matching: find.byType(SizedBox))
            .first)
        .size
        .width;
    return (caixa: caixa, precisa: paragrafo.getMaxIntrinsicWidth(double.infinity));
  }

  for (final escala in [1.0, 2.0]) {
    testWidgets('a máscara cabe inteira com escala ${escala}x', (tester) async {
      await montar(tester, escala: escala, oculto: true);
      final m = medir(tester, r'R$ ••••••');
      expect(m.caixa, greaterThanOrEqualTo(m.precisa),
          reason: 'a caixa reservada (${m.caixa}) é menor que a máscara '
              '(${m.precisa}) — o valor oculto sai cortado, e quem olha a tela '
              'conclui que a peça não tem máscara');
    });

    testWidgets('e o valor VISÍVEL também, com escala ${escala}x', (tester) async {
      await montar(tester, escala: escala, oculto: false);
      final m = medir(tester, r'R$ 0,14');
      expect(m.caixa, greaterThanOrEqualTo(m.precisa));
    });
  }

  testWidgets('e a caixa NÃO MUDA ao virar o olho — que é a razão de ela existir',
      (tester) async {
    await montar(tester, escala: 1.0, oculto: false);
    final visivel = medir(tester, r'R$ 0,14').caixa;
    await montar(tester, escala: 1.0, oculto: true);
    final ocultoW = medir(tester, r'R$ ••••••').caixa;
    expect(ocultoW, visivel,
        reason: 'a largura é o MÁXIMO dos dois estados: se ela mudar, o card '
            'encolhe e a tela pula quando a pessoa esconde o saldo');
  });
}
