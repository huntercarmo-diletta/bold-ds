import 'dart:io';

import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A FORMA SEGUE A FAMÍLIA QUE O PRODUTO DECLAROU — cartão, vidro, nav e campo.
///
/// Irmão do `a_folha_segue_o_raio_declarado_test`, e ele nasce do veredito de 14/09: o pedido pedia
/// quatro campos na paleta, o pai recusou o campo (41 opcionais no plugue com a condição de conserto
/// escrita em 45) e abriu `DilettaPalette.medidas` — **papel de medida → valor**, seis famílias, com
/// os `raioDeX` de sempre virando alias da mesma tabela.
///
/// O número que fez a forma subir por FAMÍLIA é da prévia do Berço: entre o tom de voz mais anguloso
/// e o mais redondo, a Home do filho gerado ficava **praticamente igual**, porque o que a Home tem é
/// cartão, vidro e nav — e o único raio declarável era o do botão, que não está nela.
void main() {
  DilettaPalette com(Map<String, double> medidas) =>
      DilettaPalette.referencia.comMaterial(medidas: medidas);

  CoreflowScheme esquema(Map<String, double> medidas) =>
      CoreflowScheme.de(com(medidas), brilho: Brightness.light);

  double raioDe(BorderRadius b) => b.topLeft.x;

  group('o esquema lê a TABELA da paleta', () {
    test('declarado vence, família por família', () {
      final c = esquema(const {
        DilettaMedida.formaDeCartao: 4,
        DilettaMedida.formaDeVidro: 6,
        DilettaMedida.formaDeNav: 8,
        DilettaMedida.formaDeCampo: 10,
      });
      expect(raioDe(c.formaDoCartao), 4);
      expect(c.raioDoCartao, 4);
      expect(raioDe(c.formaDoVidro), 6);
      expect(raioDe(c.formaDaNav), 8);
      expect(raioDe(c.formaDoCampo), 10);
    });

    test('sem declaração, cada uma cai na gramática DESTE DS', () {
      final c = esquema(const {});
      expect(raioDe(c.formaDoCartao), 24);
      expect(raioDe(c.formaDoVidro), 16);
      expect(raioDe(c.formaDaNav), 24);
      expect(raioDe(c.formaDoCampo), 16);
      // E a folha segue onde estava: 22, a gramática daqui contra os 24 da linguagem.
      expect(raioDe(c.formaDaFolha), 22);
    });

    test('a TABELA ganha do alias quando os dois existem', () {
      // A ordem é a do avô, e a razão é dele: alias que vence a forma nova faz a migração andar pra
      // trás. `raioDeFolha` e `raioDeCampo` continuam válidos pra quem declarou ontem.
      final paleta = DilettaPalette.referencia.comMaterial(
        raioDeFolha: 30,
        raioDeCampo: 30,
        medidas: const {DilettaMedida.formaDeFolha: 8, DilettaMedida.formaDeCampo: 8},
      );
      final c = CoreflowScheme.de(paleta, brilho: Brightness.light);
      expect(raioDe(c.formaDaFolha), 8);
      expect(raioDe(c.formaDoCampo), 8);
    });

    test('o alias sozinho continua desenhando — ninguém precisa migrar', () {
      final c = CoreflowScheme.de(
          DilettaPalette.referencia.comMaterial(raioDeCampo: 4), brilho: Brightness.light);
      expect(raioDe(c.formaDoCampo), 4);
    });
  });

  testWidgets('o cartão e a superfície do avô concordam — a conferência que o pai pediu', (t) async {
    // O veredito dele: *"declare as três e monte, na mesma tela, um CoreflowCartao, um
    // DilettaSurface e a sua nav — os três cantos têm que concordar"*.
    //
    // O `DilettaSurface` lê `formaDaFolha` do esquema DELE e o `CoreflowCartao` lê `formaDoCartao`
    // do esquema DAQUI; as duas contas saem da MESMA paleta, e é isso que o teste mede. Com a
    // família declarada não há mais um terceiro número escondido dentro da peça.
    final paleta = DilettaPalette.referencia.comMaterial(
      raioDeFolha: 12,
      medidas: const {DilettaMedida.formaDeCartao: 12},
    );
    final produto = CoreflowProduto(paleta: paleta, marca: DilettaBrand.nenhuma);

    await t.pumpWidget(Theme(
      data: produto.materialClaro,
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: CoreflowCartao(child: SizedBox(height: 40, width: 100)),
      ),
    ));

    final caixa = t.widget<DecoratedBox>(find
        .descendant(of: find.byType(CoreflowCartao), matching: find.byType(DecoratedBox))
        .first);
    final doCartao = (caixa.decoration as BoxDecoration).borderRadius! as BorderRadius;
    final doAvo = DilettaScheme.de(paleta, DilettaModo.claro).formaDaFolha;

    expect(raioDe(doCartao), 12);
    expect(raioDe(doAvo), 12, reason: 'a peça do avô lê a mesma paleta, não uma const dela');
  });

  test('o tema material do produto leva cartão e campo', () {
    final tema = CoreflowProduto(
      paleta: com(const {DilettaMedida.formaDeCartao: 4, DilettaMedida.formaDeCampo: 6}),
      marca: DilettaBrand.nenhuma,
    ).materialClaro;

    expect(
        raioDe((tema.cardTheme.shape! as RoundedRectangleBorder).borderRadius as BorderRadius), 4);
    expect(
        raioDe((tema.inputDecorationTheme.border! as OutlineInputBorder).borderRadius), 6);
  });

  test('um produto que nasce da marca já declara as três', () {
    // É o que o Berço entrega ao filho gerado: a forma da Home — cartão, vidro e nav — e não só a
    // do botão, que a Home não tem.
    final p = CoreflowProduto.daMarca(marca: const Color(0xFF1B5E20), id: 'x', nome: 'X').paleta;
    expect(p.medidas[DilettaMedida.formaDeCartao], 24);
    expect(p.medidas[DilettaMedida.formaDeVidro], 16);
    expect(p.medidas[DilettaMedida.formaDeNav], 24);
  });

  test('nenhuma peça deste pacote desenha a const das quatro famílias', () {
    // O gate que teria achado os 19 sítios sem ninguém ir procurá-los à mão. As isenções são
    // nominais e cada uma diz por quê — isenção sem razão escrita é o mesmo que não ter gate.
    const isento = {
      'lib/src/coreflow_radius.dart': 'declara as consts',
      'lib/src/coreflow_scheme.dart': 'são os defaults das quatro formas, num lugar só',
      'lib/src/coreflow_vocabulario.dart': 'a gramática nomeia as consts, não as desenha',
      // O `coreflow_css.dart` estava nesta lista quando este gate foi escrito, com a razão «emite a
      // gramática e não recebe paleta». Saiu no mesmo dia: o emissor passou a resolver as seis
      // formas pelo plugue de medida (`ca33d6c`), e isenção que virou mentira é pior que gate
      // nenhum.

      'lib/src/coreflow_cartao_de_pedido.dart':
          'o ladrilho de 46 usa o raio que a REGRA do pai dá (46 ⇒ all16), e está escrito no ///',
    };
    final alvo = RegExp(r'DilettaRadius\.all(16|24)\b|'
        r'CoreflowRadius\.(card|cardR|vidro|nav|field|fieldR)\b');
    final achados = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      final caminho = f.path.replaceAll(r'\', '/');
      if (isento.containsKey(caminho)) continue;
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        final l = linhas[i];
        if (alvo.hasMatch(l) && !l.trimLeft().startsWith('///') && !l.trimLeft().startsWith('//')) {
          achados.add('$caminho:${i + 1} · ${l.trim()}');
        }
      }
    }
    expect(achados, isEmpty,
        reason: 'quem precisa da forma lê o CoreflowScheme:\n${achados.join('\n')}');
  });
}
