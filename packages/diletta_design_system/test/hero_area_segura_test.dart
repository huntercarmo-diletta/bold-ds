import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CTA DO HERO NÃO PODE SER PINTADO NA ÁREA DO HOME INDICATOR.
///
/// O padding de baixo reserva 34 (a barra de gesto do iOS) + respiro. Com
/// `SliverPadding(sliver: SliverFillRemaining(...))` esse padding era ignorado: o sliver recebe a
/// viewport INTEIRA como espaço restante, o filho ficava mais alto que a área padded, e o botão caía
/// dentro da faixa do indicador. No aparelho, é um botão que não se toca.
void main() {
  testWidgets('o CTA para antes dos 34 de baixo', (t) async {
    t.view.physicalSize = const Size(393, 852);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final quadro = GlobalKey();
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: DilettaTheme.resolve(
            palette: DilettaPalette.referencia, brightness: Brightness.light),
        child: SizedBox(
          key: quadro,
          width: 393,
          height: 852,
          child: const DilettaSdkScreen(
            partnerName: 'BANCO AURORA',
            title: 'Sua sessão expirou',
            subtitle: 'Por segurança, encerramos sua sessão.',
            primaryLabel: 'Entrar de novo',
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 300));
    final cta = t.getRect(find.byType(DilettaPartnerButton));
    final tela = t.getRect(find.byKey(quadro));
    expect(tela.bottom - cta.bottom, greaterThanOrEqualTo(34),
        reason: 'o CTA invadiu a faixa do home indicator');
  });
}
