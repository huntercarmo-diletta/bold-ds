import 'dart:convert';
import 'dart:typed_data';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Um PNG de 1×1 em memória. `AssetImage` de arquivo inexistente derruba o serviço de imagem do
/// teste, e o que se quer aferir aqui não é carregamento — é por onde a foto passa.
final _foto = MemoryImage(Uint8List.fromList(base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFAAH/q842iQAAAABJRU5ErkJggg==')));

/// O AVATAR DA HOME VOA — e as três asserções cobrem três jeitos diferentes de isso dar errado.
///
/// O pedido de 12/08 foi respondido na `v0.115.0` do pai (`DilettaAvatar.heroTag`, a primeira
/// transição declarada da linguagem). Este cabeçalho é o consumidor, e o que ele faz é REPASSAR a
/// identidade — não animar nada.
void main() {
  Widget montar({Object? tag, ImageProvider? foto}) => MaterialApp(
        theme: CoreflowTemaMaterial.claro,
        home: DilettaThemeScope(
          theme: CoreflowTheme.light,
          child: Scaffold(
            body: CoreflowCabecalhoDaHome(nome: 'Ranter', conta: 'Minha conta', foto: foto, heroTag: tag),
          ),
        ),
      );

  testWidgets('sem tag não existe Hero na árvore', (tester) async {
    // O default tem que ser byte a byte o de antes: `Hero` que aparece sem ninguém pedir é o que
    // derruba o app na tela em que o avatar existe duas vezes.
    await tester.pumpWidget(montar());
    await tester.pumpAndSettle();
    expect(find.byType(Hero), findsNothing);
  });

  testWidgets('com tag o Hero envolve o CÍRCULO, não a casca', (tester) async {
    // É o número do pedido: `Hero` por fora faria voar 300+ × 100+ (casca, ícones, segunda linha)
    // onde devem voar 48 × 48. A asserção é o TAMANHO, porque é ele que estava errado.
    await tester.pumpWidget(montar(tag: 'avatar-do-titular'));
    await tester.pumpAndSettle();

    final hero = find.byType(Hero);
    expect(hero, findsOneWidget);
    expect(tester.widget<Hero>(hero).tag, 'avatar-do-titular');
    expect(tester.getSize(hero), const Size(48, 48),
        reason: 'o que voa é o círculo de 48; qualquer coisa maior que isso quer dizer que a '
            'identidade subiu pra um ancestral e a casca inteira vai junto');
  });

  testWidgets('e a FOTO passa pelo avatar do pai — o voo mora na peça', (tester) async {
    // O ramo da foto desenhava o círculo à mão aqui dentro. Um `Hero` sobre aquele `DecoratedBox`
    // voaria sem o `flightShuttleBuilder` da peça, e a foto viraria QUADRADO no meio do caminho.
    await tester.pumpWidget(montar(
      tag: 'avatar-do-titular',
      foto: _foto,
    ));
    await tester.pumpAndSettle();

    final avatar = find.byType(DilettaAvatar);
    expect(avatar, findsOneWidget);
    expect(tester.widget<DilettaAvatar>(avatar).image, isNotNull);
    expect(tester.widget<DilettaAvatar>(avatar).heroTag, 'avatar-do-titular');
  });

  testWidgets('a borda de marca é do ramo da FOTO, e só dele', (tester) async {
    // Passar `s.primary` nos dois ramos trocaria a borda de todo avatar SEM foto, que sempre usou o
    // default do pai. Mudança de desenho entrando de carona numa mudança de estrutura.
    await tester.pumpWidget(montar());
    await tester.pumpAndSettle();
    expect(tester.widget<DilettaAvatar>(find.byType(DilettaAvatar)).borderColor, isNull);

    await tester.pumpWidget(montar(foto: _foto));
    await tester.pumpAndSettle();
    expect(tester.widget<DilettaAvatar>(find.byType(DilettaAvatar)).borderColor, isNotNull);
  });
}
