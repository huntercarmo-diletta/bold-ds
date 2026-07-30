import 'dart:ui' show ImageFilter;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// OS DOIS PEDIDOS DO SEGUNDO FILHO QUE ENTRARAM NA v0.4.0.
///
/// Aqui fica o lado do PAI: o default não mudou, e a barra aceita cabeçalho que o pai não conhece.
/// Que a receita de vidro de OUTRA marca chega no componente é a Aurora que prova
/// (`exemplos/aurora`) — o pai não inventa a paleta de um filho pra testar, é pra isso que o
/// segundo filho existe.
void main() {
  // `Align` no topo não é enfeite: na raiz do `pumpWidget` as constraints são TIGHT (800×600), e um
  // `SizedBox(width: 390)` ali é ignorado — foi o que fez a primeira versão deste teste medir 712.
  Widget comTema(Widget filho, {DilettaTheme? tema}) => Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaThemeScope(
          theme: tema ?? DilettaTheme.referenciaLight,
          child: Align(alignment: Alignment.topLeft, child: filho),
        ),
      );

  testWidgets('o vidro sem receita declarada é o de sempre: blur 10 e nenhum traço', (t) async {
    // Este teste guarda o pixel do PRIMEIRO filho. Blur e traço nasceram por pedido do segundo, e
    // pedido de um filho não pode mudar o desenho do outro.
    await t.pumpWidget(comTema(
      const DilettaGlassSurface(child: SizedBox(width: 100, height: 40)),
    ));

    expect(t.widget<BackdropFilter>(find.byType(BackdropFilter)).filter,
        ImageFilter.blur(sigmaX: 10, sigmaY: 10));
    expect(
      find.descendant(
        of: find.byType(DilettaGlassSurface),
        matching: find.byType(Container),
      ),
      findsNothing,
      reason: 'sem traço declarado o vidro não ganha caixa nenhuma',
    );
  });

  testWidgets('o cabeçalho livre entra na barra, e pode tomar a linha', (t) async {
    // O pedido bloqueante: a hierarquia era `sealed` sem saída, então não havia caminho de
    // composição — o filho carregava a barra inteira própria por causa de 3 telas em 113.
    const marca = Key('cabecalho-do-filho');
    await t.pumpWidget(comTema(const SizedBox(
      width: 390,
      child: DilettaNavigationTopBar(
        title: 'não deve aparecer',
        left: DilettaNavigationLeftAccessory.livre(
          ocupaALinha: true,
          child: SizedBox(key: marca, height: 40),
        ),
      ),
    )));

    expect(find.byKey(marca), findsOneWidget);
    expect(find.text('não deve aparecer'), findsNothing,
        reason: 'cabeçalho que pede a linha não convive com título centralizado');
    // A prova de que ele recebeu a LINHA e não a largura natural: 390 menos 24+24 de padding, menos
    // os 40 do slot direito vazio.
    expect(t.getSize(find.byKey(marca)).width, 390 - 24 - 24 - 40);
  });

  testWidgets('sem ocupaALinha, o título continua no centro', (t) async {
    await t.pumpWidget(comTema(const SizedBox(
      width: 390,
      child: DilettaNavigationTopBar(
        title: 'Título',
        left: DilettaNavigationLeftAccessory.livre(
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    )));
    expect(find.text('Título'), findsOneWidget);
  });

  testWidgets('os acessórios tipados continuam funcionando', (t) async {
    // A abertura não pode ter custo pra quem não a usa: as fábricas documentadas seguem sendo o
    // caminho normal, e é por isso que elas não viraram "livre" com um helper.
    await t.pumpWidget(comTema(const SizedBox(
      width: 390,
      child: DilettaNavigationTopBar(
        title: 'Detalhe',
        left: DilettaNavigationLeftAccessory.back(),
        right: DilettaNavigationRightAccessory.inputChip(label: 'Meu CPF'),
      ),
    )));
    expect(find.text('Detalhe'), findsOneWidget);
    expect(find.text('Meu CPF'), findsOneWidget);
  });
}
