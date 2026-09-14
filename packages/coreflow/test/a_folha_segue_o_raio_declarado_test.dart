import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


/// A FOLHA SEGUE O RAIO QUE O PRODUTO DECLAROU — e até 14/09 cinco peças daqui não seguiam.
///
/// O avô resolveu isto em 22/08: o filho declara `raioDeFolha` na paleta, o componente lê
/// `formaDaFolha` do esquema, e nove sítios da linguagem passaram por lá de uma vez. **As folhas
/// deste pacote ficaram fora da mudança** e continuaram desenhando a const `CoreflowRadius.sheet`
/// = 22. Um produto que declarasse 8 via as nove folhas do avô obedecerem e a folha principal
/// daqui ignorar — e não havia como ver isso sem montar dois produtos lado a lado.
///
/// Achado medindo o que o Berço Coreflow consegue entregar ao filho que ele gera: a etapa de
/// estilo passou a oferecer TOM DE VOZ (do mais anguloso ao mais redondo), e a folha era uma das
/// peças que a prévia mudava e o app não.
///
/// O teste tem duas metades de propósito. A primeira mede o DESENHO em três das cinco peças; a
/// segunda é um gate de fonte, porque as outras duas (`CoreflowFolha` e a variante folha da barra
/// de topo) só se montam dentro de rota modal e o gate pega as cinco pelo mesmo preço.
void main() {
  DilettaPalette comFolha(double? raio) =>
      DilettaPalette.referencia.comMaterial(raioDeFolha: raio);

  double raioDe(BorderRadius b) => b.topLeft.x;

  group('o esquema lê o que a paleta declarou', () {
    test('declarado vence, e dois produtos não desenham a mesma folha', () {
      final anguloso = CoreflowScheme.de(comFolha(8), brilho: Brightness.light);
      final redondo = CoreflowScheme.de(comFolha(32), brilho: Brightness.light);
      expect(raioDe(anguloso.formaDaFolha), 8);
      expect(raioDe(redondo.formaDaFolha), 32);
    });

    test('sem declaração cai na gramática DESTE DS (22), não no 24 do avô', () {
      // A régua é "casar por VALOR e nunca por nome", a mesma que faz o card daqui valer 24 contra
      // o `DilettaRadius.card` de 16. A paleta de referência do avô é a única deste repo que não
      // declara o raio, e é a fixture: com 22 ela desenha o que desenhava antes do getter existir.
      expect(raioDe(CoreflowScheme.de(comFolha(null), brilho: Brightness.light).formaDaFolha), 22);
      expect(DilettaPalette.referencia.raioDeFolha, isNull);
    });
  });

  testWidgets('o corpo de folha desenha o raio do produto, não a const', (t) async {
    Future<double> raioDoCorpo(double raio) async {
      // `Theme` cru, e não `MaterialApp`: o tema do MaterialApp é ANIMADO, e medir logo depois do
      // pump pega o tema a meio caminho do anterior — a segunda medição saía igual à primeira.
      await t.pumpWidget(Theme(
        data: CoreflowProduto(paleta: comFolha(raio), marca: DilettaBrand.nenhuma).materialClaro,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: CoreflowCorpoDeFolha(child: SizedBox(height: 40)),
        ),
      ));
      final d = t.widget<DecoratedBox>(find
          .descendant(of: find.byType(CoreflowCorpoDeFolha), matching: find.byType(DecoratedBox))
          .first);
      return raioDe((d.decoration as BoxDecoration).borderRadius! as BorderRadius);
    }

    expect(await raioDoCorpo(8), 8);
    expect(await raioDoCorpo(32), 32);
  });

  test('o bottomSheetTheme do produto também', () {
    BorderRadius formaDoTema(double raio) {
      final tema = CoreflowProduto(paleta: comFolha(raio), marca: DilettaBrand.nenhuma).materialClaro;
      return (tema.bottomSheetTheme.shape! as RoundedRectangleBorder).borderRadius as BorderRadius;
    }

    // A GEOMETRIA não mudou junto com o valor: continuam os quatro cantos, como sempre foram.
    // Numa folha ancorada embaixo os de baixo não aparecem, e mexer nos dois esconderia qual deles
    // mudou a tela.
    expect(raioDe(formaDoTema(8)), 8);
    expect(formaDoTema(8).bottomLeft.x, 8);
    expect(raioDe(formaDoTema(32)), 32);
  });

  test('nenhuma peça deste pacote desenha a const da folha', () {
    // O gate que teria pego as cinco antes de alguém ir procurá-las à mão. `CoreflowRadius.sheet`
    // continua existindo — ela é o DEFAULT de `CoreflowScheme.formaDaFolha`, e é lá, num lugar só,
    // que ela pode ser lida.
    final permitido = {
      'lib/src/coreflow_radius.dart': 'declara a const',
      'lib/src/coreflow_scheme.dart': 'é o default de formaDaFolha, num lugar só',
    }.keys.toSet();
    final achados = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      final caminho = f.path.replaceAll(r'\', '/');
      if (permitido.contains(caminho)) continue;
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        if (linhas[i].contains(RegExp(r'CoreflowRadius\.sheetR?\b')) &&
            !linhas[i].trimLeft().startsWith('///')) {
          achados.add('$caminho:${i + 1} · ${linhas[i].trim()}');
        }
      }
    }
    expect(achados, isEmpty,
        reason: 'quem precisa do raio da folha lê CoreflowScheme.formaDaFolha:\n${achados.join('\n')}');
  });
}
