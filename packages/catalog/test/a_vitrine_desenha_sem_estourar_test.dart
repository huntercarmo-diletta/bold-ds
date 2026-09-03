import 'package:diletta_catalog_core/aba_de_componentes.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **TODA CATEGORIA DA VITRINE DESENHA SEM ESTOURAR — e este gate nasceu de um estouro real.**
///
/// A aba de componentes virou VITRINE no motor `v0.110.0` (decisão do dono: *"a vitrine do CPF vira
/// o novo motor"*), e com ela a cobertura mudou de classe: o índice desenhava **a peça que a pessoa
/// clicava**, a vitrine desenha a categoria inteira. Duas fragilidades apareceram na primeira
/// renderização, e nenhuma delas era nova — só nunca tinham sido alcançadas:
///
/// - no filho A, uma peça com `Spacer` na raiz derrubava a página;
/// - **aqui**, um cartão estourava **88px** dentro da célula de 320 da matriz de variantes, e
///   pintava a tarja vermelha por cima de tudo. A matriz é a mesma nos dois modos — quem clicasse
///   naquele componente no índice via o mesmo. A vitrine só mostrou sem o clique.
///
/// O conserto foi do motor (`v0.110.3`: teto de 560 e `ClipRect`), e este gate é do FILHO: o teto é
/// do motor, mas quem tem componente largo é o produto. Peça nova que não caiba acende aqui.
void main() {
  testWidgets('nenhuma categoria estoura layout', (t) async {
    // 2600 de altura: a vitrine é alta por definição, e um estouro VERTICAL de falta de tela seria
    // ruído em cima do que se quer medir, que é o horizontal das amostras.
    t.view.physicalSize = const Size(1500, 2600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: Scaffold(body: AbaDeComponentes())));
    await t.pump();

    final problemas = <String>[];
    for (final categoria in Ds.grupos.keys) {
      await t.tap(find.text(categoria));
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      Object? e;
      while ((e = t.takeException()) != null) {
        problemas.add('$categoria: $e');
      }
    }
    expect(problemas, isEmpty,
        reason: 'componente que não cabe na amostra pinta tarja vermelha por cima da página '
            'inteira:\n${problemas.join('\n')}');
  });

  testWidgets('e o gate SABE ver — uma categoria inexistente não passa calada', (t) async {
    // Sem isto, um `Ds.grupos` vazio deixaria o laço acima sem iteração e o teste verde pra sempre.
    expect(Ds.grupos, isNotEmpty);
    expect(Ds.grupos.length, greaterThan(5),
        reason: 'este produto declara 12 grupos; se caiu, ou o plugue mudou ou a régua está cega');
  });
}
