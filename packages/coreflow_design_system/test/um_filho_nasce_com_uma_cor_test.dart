import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// UM FILHO DO COREFLOW NASCE COM UMA COR — e o gate mede as três promessas do `daMarca`.
///
/// O gate vizinho (`o_neto_monta_o_tema_inteiro`) prova que um produto com paleta PRÓPRIA monta o
/// tema sem rosa vazando. Este mede o degrau anterior, que era o que faltava pra "fácil": o produto
/// que **não tem paleta** — só uma cor — nasce com a gramática deste DS e a identidade dele.
void main() {
  const verde = Color(0xFF1B5E20);
  final filho = CoreflowProduto.daMarca(marca: verde, id: 'meuBanco', nome: 'Meu Banco');

  /// Tudo que é cor de marca do Conta BOLD. Se aparecer no filho, é rosa vazando.
  const rosaDoBold = <Color>[
    BoldColors.primary01, BoldColors.primary02, BoldColors.primary03,
    BoldColors.primary04, BoldColors.primary05, BoldColors.primary06,
    BoldColors.primary07, BoldColors.primary08, BoldColors.primary09,
  ];

  test('a marca dele entra INTOCADA, no degrau que a claridade dela pede', () {
    final degrau = DilettaRampa.degrauDe(verde);
    final rampa = [
      filho.paleta.primary01, filho.paleta.primary02, filho.paleta.primary03,
      filho.paleta.primary04, filho.paleta.primary05, filho.paleta.primary06,
      filho.paleta.primary07, filho.paleta.primary08, filho.paleta.primary09,
    ];
    expect(rampa[degrau], verde);
  });

  test('e NENHUM degrau do Bold sobra na paleta dele', () {
    final rampa = [
      filho.paleta.primary01, filho.paleta.primary02, filho.paleta.primary03,
      filho.paleta.primary04, filho.paleta.primary05, filho.paleta.primary06,
      filho.paleta.primary07, filho.paleta.primary08, filho.paleta.primary09,
      filho.paleta.primaryStateSelected, filho.paleta.primaryStateHover,
    ];
    for (final c in rampa) {
      expect(rosaDoBold, isNot(contains(c)),
          reason: 'herdar a gramática é o objetivo; herdar o rosa é o defeito');
    }
  });

  test('HERDA a gramática do material — é o que o faz parecer Coreflow', () {
    expect(filho.paleta.cardDeVidro, isTrue, reason: 'card de vidro é o material deste DS');
    expect(filho.paleta.raioDeBotao, 16);
    expect(filho.paleta.raioDeFolha, 22);
    expect(filho.paleta.blurDeVidro, 15);
    expect(filho.paleta.papeisExtras.keys,
        containsAll(<String>['superficieElevada', 'fluxoSecundario', 'info']));
  });

  test('e o material que carrega COR deriva da marca dele, não do vinho do Bold', () {
    expect(filho.paleta.tinteDeVidroEscuro, isNot(BoldPalette.bold.tinteDeVidroEscuro),
        reason: 'o tinte do vidro escuro do Bold é o vinho da marca DELE');
    expect(filho.paleta.tracoDeVidroEscuro, isNot(BoldPalette.bold.tracoDeVidroEscuro));
    expect(filho.paleta.tracoDeVidroClaro, filho.paleta.primary08,
        reason: 'a regra do traço claro é o degrau 08, e ela viaja');
    expect(filho.paleta.brilhoDoEsqueletoClaro, isNot(BoldPalette.bold.brilhoDoEsqueletoClaro));
  });

  test('o semântico NÃO deriva, e é regra', () {
    expect(filho.paleta.error04, DilettaPalette.referencia.error04);
    expect(filho.paleta.warning04, DilettaPalette.referencia.warning04);
    expect(filho.paleta.success04, DilettaPalette.referencia.success04);
  });

  test('o tema inteiro sai dele — os quatro, sem paleta escrita à mão', () {
    for (final t in [filho.materialClaro, filho.materialEscuro]) {
      expect(t.colorScheme.primary, isNot(BoldColors.primary04));
      expect(t.scaffoldBackgroundColor, isNotNull);
    }
    expect(filho.claro.brightness, Brightness.light);
    expect(filho.escuro.brightness, Brightness.dark);
  });

  testWidgets('e uma tela do DS desenha com ele — a porta provada no olho', (t) async {
    await t.pumpWidget(MaterialApp(
      theme: filho.materialClaro,
      home: DilettaThemeScope(
        theme: filho.claro,
        child: const Scaffold(
          body: Center(
            child: CoreflowLinhaDeAviso(
                icone: 'circle-check-light', titulo: 'Nasci com uma cor.'),
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('Nasci com uma cor.'), findsOneWidget);
    expect(tester0Excecoes(t), isTrue);
  });
}

/// Nenhuma exceção de framework — peça que estoura por falta de papel não "quase funciona".
bool tester0Excecoes(WidgetTester t) => t.takeException() == null;
