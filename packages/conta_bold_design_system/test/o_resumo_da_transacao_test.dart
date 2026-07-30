import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O RESUMO DA TRANSAÇÃO — o cabeçalho que três telas de comprovante escreviam à mão, com números
/// diferentes (valor 32 no Pix e no boleto, 34 na TED).
void main() {
  Widget naTela(Widget filho, {bool escuro = false, double largura = 360}) => Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: largura, child: filho),
          ),
        ),
      );

  testWidgets('mostra o que foi, quanto e quando — nos dois modos', (t) async {
    for (final escuro in [false, true]) {
      await t.pumpWidget(naTela(
        const BoldResumoDaTransacao(
          titulo: 'Pix enviado',
          valor: r'R$ 120,00',
          quando: '30 de julho · 14:32',
        ),
        escuro: escuro,
      ));
      await t.pump(const Duration(milliseconds: 50));
      expect(t.takeException(), isNull);
      expect(find.text('Pix enviado'), findsOneWidget);
      expect(find.text(r'R$ 120,00'), findsOneWidget);
      expect(find.text('30 de julho · 14:32'), findsOneWidget);
    }
  });

  testWidgets('o ESTADO decide o ícone e o tom do spot — o par que era ternário na tela', (t) async {
    // Eram dois argumentos calculados em cada tela (`statusIcon` e `statusTone` sobre `isScheduled`),
    // em quatro pontos de uso: quatro chances de acertar o ícone e errar o tom.
    String iconeDe(BoldEstadoDaTransacao e) =>
        t.widget<DilettaSpotIcon>(find.byType(DilettaSpotIcon)).icon;

    await t.pumpWidget(naTela(const BoldResumoDaTransacao(
        titulo: 'Boleto pago', valor: r'R$ 90,00', quando: 'hoje')));
    await t.pump(const Duration(milliseconds: 50));
    expect(iconeDe(BoldEstadoDaTransacao.concluida), DilettaIcons.circleCheckLight);
    expect(t.widget<DilettaSpotIcon>(find.byType(DilettaSpotIcon)).state,
        DilettaSpotState.success);

    await t.pumpWidget(naTela(const BoldResumoDaTransacao(
      titulo: 'Boleto agendado',
      valor: r'R$ 90,00',
      quando: 'Para 12/08',
      estado: BoldEstadoDaTransacao.agendada,
    )));
    await t.pump(const Duration(milliseconds: 50));
    expect(iconeDe(BoldEstadoDaTransacao.agendada), DilettaIcons.calendarLight);
    expect(t.widget<DilettaSpotIcon>(find.byType(DilettaSpotIcon)).state,
        DilettaSpotState.warning);
  });

  testWidgets('valor grande ENCOLHE, e não vira reticências', (t) async {
    // `R$ 1.234...` lê como um valor menor do que é. Cortar dinheiro é pior que diminuir a fonte,
    // então o teste mede as duas coisas: o texto inteiro está na árvore E não estourou o layout.
    await t.pumpWidget(naTela(
      const BoldResumoDaTransacao(
        titulo: 'Pix enviado',
        valor: r'R$ 1.234.567,89',
        quando: 'hoje',
      ),
      largura: 200,
    ));
    await t.pump(const Duration(milliseconds: 50));

    expect(t.takeException(), isNull, reason: 'estourou em tela estreita');
    expect(find.text(r'R$ 1.234.567,89'), findsOneWidget);

    // A PROVA de que encolheu: `getRect` passa pela transformação do `FittedBox`, então o retângulo
    // PINTADO cabe nos 200 — enquanto `getSize` devolve o tamanho natural do texto, que é maior.
    // Medir só um dos dois não distingue "encolheu" de "cortou".
    final pintado = t.getRect(find.text(r'R$ 1.234.567,89'));
    final natural = t.getSize(find.text(r'R$ 1.234.567,89'));
    expect(pintado.width, lessThanOrEqualTo(200),
        reason: 'o valor pintado vazou a largura da tela');
    expect(natural.width, greaterThan(pintado.width),
        reason: 'sem escala aplicada este teste não mede nada — se os dois batem, o FittedBox saiu');
  });

  testWidgets('título longo cabe em duas linhas e não empurra o spot pra fora', (t) async {
    await t.pumpWidget(naTela(
      const BoldResumoDaTransacao(
        titulo: 'Comprovante de pagamento de boleto agendado para o próximo mês',
        valor: r'R$ 10,00',
        quando: 'hoje',
        estado: BoldEstadoDaTransacao.agendada,
      ),
      largura: 320,
    ));
    await t.pump(const Duration(milliseconds: 50));

    expect(t.takeException(), isNull);
    final spot = t.getRect(find.byType(DilettaSpotIcon));
    expect(spot.right, lessThanOrEqualTo(320));
  });

  testWidgets('o spot NÃO é anunciado pelo leitor de tela — o estado já está no título', (t) async {
    // Ícone que repete o que o texto já diz é ruído: quem ouve "Boleto agendado" não precisa ouvir
    // "calendário" logo depois.
    await t.pumpWidget(naTela(const BoldResumoDaTransacao(
        titulo: 'Boleto agendado',
        valor: r'R$ 90,00',
        quando: 'Para 12/08',
        estado: BoldEstadoDaTransacao.agendada)));
    await t.pump(const Duration(milliseconds: 50));

    expect(
      find.ancestor(
        of: find.byType(DilettaSpotIcon),
        matching: find.byType(ExcludeSemantics),
      ),
      findsOneWidget,
    );
  });
}
