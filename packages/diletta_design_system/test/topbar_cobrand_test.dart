import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A CO-MARCA PARA DE TROCAR DE LUGAR.
///
/// Ela vivia em dois lugares: rótulo do stepper (nas telas com stepper) e bloco solto no começo do
/// content (nas outras) — e ali a posição dependia de quanto conteúdo vinha antes. Marca que muda de
/// lugar a cada tela lê como descuido, e é justo a informação que precisa ser constante: quem
/// protege esta jornada.
///
/// A variante `.cobrand` põe a marca DENTRO da barra, centralizada e no fim dela.
void main() {
  Widget emTela(Widget filho) => MaterialApp(
        home: DilettaThemeScope(
          theme: DilettaTheme.resolve(
              palette: DilettaPalette.referencia, brightness: Brightness.light),
          child: Scaffold(body: filho),
        ),
      );

  testWidgets('a marca fica DENTRO da barra, e centralizada', (t) async {
    final chave = GlobalKey();
    await t.pumpWidget(emTela(SizedBox(
      width: 393,
      child: DilettaTopAppBar.cobrand(
        key: chave,
        navBar: const DilettaNavigationTopBar(
          left: DilettaNavigationLeftAccessory.back(),
          title: 'Dados pessoais',
        ),
        partnerName: 'Banco Aurora',
      ),
    )));
    await t.pump();

    final barra = t.getRect(find.byKey(chave));
    final marca = t.getRect(find.byType(DilettaCobrandMark));
    expect(barra.contains(marca.center), isTrue, reason: 'a marca é da barra, não do content');
    // Centralizada: o centro dela e o centro da barra coincidem no eixo horizontal.
    expect((marca.center.dx - barra.center.dx).abs(), lessThan(1));
    // No FIM da barra: mais perto do rodapé dela do que do topo.
    expect(barra.bottom - marca.bottom, lessThan(marca.top - barra.top));
  });

  testWidgets('a barra sem co-marca segue existindo, e não desenha marca nenhuma', (t) async {
    await t.pumpWidget(emTela(SizedBox(
      width: 393,
      child: DilettaTopAppBar.defaultVariant(
        navBar: const DilettaNavigationTopBar(title: 'Sem marca'),
      ),
    )));
    await t.pump();
    expect(find.byType(DilettaCobrandMark), findsNothing);
  });
}
