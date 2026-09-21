import 'package:coreflow/coreflow.dart';
import 'o_neto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O RODAPÉ COM AVISO É UMA BARRA SÓ.
///
/// Esta casca tinha um desvio: com conteúdo em `acima`, ela embrulhava o rodapé do pai numa SEGUNDA
/// barra de vidro, porque o `.livre` do pai exige altura declarada e o `.button` não recebia nada
/// além do botão.
///
/// O preço foi medido em pixel numa foto da tela de revisão do Pix: **duas linhas acima do botão**,
/// a 24 uma da outra, a de dentro recuada 20 de cada lado pelo padding desta casca, e o respiro de
/// baixo contado duas vezes.
///
/// E era violação escrita: a spec do pai já dizia *"NÃO SHALL haver duas barras inferiores
/// empilhadas na mesma tela"*. O slot passou a morar no pai, e esta casca só repassa.
void main() {
  Widget emTela(Widget filho) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DilettaThemeScope(
          theme: Neto.escuro,
          child: Scaffold(
            body: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(width: 393, child: filho),
            ),
          ),
        ),
      );

  CoreflowRodape rodape({Widget? acima}) => CoreflowRodape.button(
        acima: acima,
        primary: CoreflowAcaoDeNavegacao(label: 'Enviar', onPressed: () {}),
      );

  testWidgets('sem aviso: uma barra de vidro', (t) async {
    await t.pumpWidget(emTela(rodape()));
    expect(find.byType(DilettaGlassSurface), findsOneWidget);
  });

  testWidgets('COM aviso: continua uma barra de vidro, não duas', (t) async {
    await t.pumpWidget(emTela(rodape(acima: const SizedBox(height: 48, width: 100))));
    expect(find.byType(DilettaGlassSurface), findsOneWidget,
        reason: 'o aviso não pode criar uma segunda barra por cima da do pai');
    expect(find.byType(DilettaBottomHomeIndicator), findsOneWidget,
        reason: 'um indicador de home por barra — o respiro de baixo é um só');
  });

  testWidgets('o aviso vai inteiro para o pai, dentro da mesma barra', (t) async {
    const marca = Key('aviso');
    await t.pumpWidget(
        emTela(rodape(acima: const SizedBox(key: marca, height: 48, width: 100))));
    expect(
        find.descendant(
            of: find.byType(DilettaGlassSurface), matching: find.byKey(marca)),
        findsOneWidget);
  });
}
