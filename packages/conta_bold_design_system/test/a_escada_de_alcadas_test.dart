import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ESCADA DE ALÇADAS — o vocabulário da conta PJ: quem pode mandar quanto, e com quantas mãos.
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

  /// As duas faixas que o modelo de dados produz quando o backend NÃO manda escalonamento — que é o
  /// caso comum, e o que derrubou a rampa de calor do componente antigo.
  const duasFaixas = [
    BoldDegrauDeAlcada(ate: r'R$ 5.000,00', aprovacoes: 0),
    BoldDegrauDeAlcada(aprovacoes: 2, exigeMaster: true),
  ];

  testWidgets('lê a regra em palavras: até, acima de, e a exigência', (t) async {
    await t.pumpWidget(naTela(const BoldEscadaDeAlcadas(degraus: duasFaixas)));
    await t.pump(const Duration(milliseconds: 50));

    expect(t.takeException(), isNull);
    expect(find.text(r'Até R$ 5.000,00'), findsOneWidget);
    expect(find.text('Faz sozinho'), findsOneWidget);
    expect(find.text(r'Acima de R$ 5.000,00'), findsOneWidget);
    expect(find.text('2 aprovações · 1 master'), findsOneWidget);
  });

  testWidgets('a FAIXA sai de dois degraus, não de um — "De X a Y"', (t) async {
    // A faixa é a distância entre dois degraus, então quem compõe é a escada. Se o degrau soubesse
    // sozinho, a linha do meio diria "Até Y" e perderia o piso.
    await t.pumpWidget(naTela(const BoldEscadaDeAlcadas(degraus: [
      BoldDegrauDeAlcada(ate: r'R$ 1.000,00', aprovacoes: 0),
      BoldDegrauDeAlcada(ate: r'R$ 10.000,00', aprovacoes: 1),
      BoldDegrauDeAlcada(aprovacoes: 3),
    ])));
    await t.pump(const Duration(milliseconds: 50));

    expect(find.text(r'De R$ 1.000,00 a R$ 10.000,00'), findsOneWidget);
    expect(find.text('1 aprovação'), findsOneWidget, reason: 'singular');
    expect(find.text('3 aprovações'), findsOneWidget);
  });

  testWidgets('escada de um degrau terminal diz "Qualquer valor"', (t) async {
    await t.pumpWidget(naTela(const BoldEscadaDeAlcadas(
        degraus: [BoldDegrauDeAlcada(aprovacoes: 1)])));
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('Qualquer valor'), findsOneWidget);
  });

  testWidgets('escada VAZIA não desenha moldura vazia', (t) async {
    // Moldura sem conteúdo lê como "carregando", que é o oposto de "não há regra declarada".
    await t.pumpWidget(naTela(const BoldEscadaDeAlcadas(degraus: [])));
    await t.pump(const Duration(milliseconds: 50));
    expect(find.byType(DilettaBox), findsNothing);
  });

  test('o texto da exigência passa AA nos dois modos — o antigo não passava', () {
    // O DEFEITO que a adaptação achou: o componente antigo pintava o rótulo com o tom CHEIO sobre um
    // banho de 10% do mesmo tom. Este teste mede os dois pares com a razão de contraste do próprio
    // pai, e cobra o piso de AA de texto de corpo (4.5) no par novo — declarando o antigo pra a
    // comparação não virar memória.
    for (final escuro in [false, true]) {
      final s = escuro
          ? DilettaScheme.dark(BoldPalette.bold)
          : DilettaScheme.light(BoldPalette.bold);
      final modo = escuro ? 'escuro' : 'claro';

      final antigoPrimary = cpfSeguroContrastRatio(s.primary, s.primarySubtle);
      final novoPrimary = cpfSeguroContrastRatio(s.onPrimarySubtle, s.primarySubtle);
      final antigoSuccess = cpfSeguroContrastRatio(s.success, s.successSubtle);
      final novoSuccess = cpfSeguroContrastRatio(s.onSuccessSubtle, s.successSubtle);

      expect(novoPrimary, greaterThanOrEqualTo(4.5),
          reason: 'exigência ilegível no $modo: $novoPrimary');
      expect(novoSuccess, greaterThanOrEqualTo(4.5),
          reason: 'autonomia ilegível no $modo: $novoSuccess');
      // A comparação é o registro: se algum dia o par antigo passar, o defeito era outro.
      expect(antigoPrimary, lessThan(4.5));
      expect(antigoSuccess, lessThan(4.5));
    }
  });

  testWidgets('a cor sai de PAPEL, e não de alpha sobre papel', (t) async {
    // O que impede a rampa de calor de voltar: as cores das caixas são exatamente os papéis do pai,
    // então qualquer `withValues(alpha:)` reaparecendo aqui faz este teste falhar.
    await t.pumpWidget(naTela(const BoldEscadaDeAlcadas(degraus: duasFaixas)));
    await t.pump(const Duration(milliseconds: 50));

    final s = DilettaScheme.light(BoldPalette.bold);
    final fundos = t
        .widgetList<DilettaBox>(find.byType(DilettaBox))
        .map((b) => b.color?.toARGB32())
        .whereType<int>()
        .toSet();
    expect(fundos, {s.successSubtle.toARGB32(), s.primarySubtle.toARGB32()});
  });

  testWidgets('linha cheia não estoura — e o teste mede o PIOR caso, de propósito', (t) async {
    // Este teste achou um estouro de 55px, e vale dizer o que ele mede: sem fonte carregada, o teste
    // desenha com a métrica de fallback, onde cada glifo é um quadrado de 1em — "4 aprovações ·
    // 1 master" ocupou 264px onde a Inter ocuparia perto da metade. Não é o número da tela real.
    //
    // Fica assim porque o pior caso é o que interessa aqui: o estouro EXISTE na estrutura antiga (a
    // exigência não era flexível), e a fonte só mudava a largura em que ele aparecia. Gate que só
    // reprova no caso médio deixa passar o aparelho pequeno com fonte grande do sistema.
    await t.pumpWidget(naTela(
      const BoldEscadaDeAlcadas(degraus: [
        BoldDegrauDeAlcada(ate: r'R$ 1.234.567,89', aprovacoes: 0),
        BoldDegrauDeAlcada(ate: r'R$ 9.876.543,21', aprovacoes: 4, exigeMaster: true),
        BoldDegrauDeAlcada(aprovacoes: 5),
      ]),
      largura: 280,
    ));
    await t.pump(const Duration(milliseconds: 50));
    expect(t.takeException(), isNull, reason: 'estourou em tela estreita');
  });
}
