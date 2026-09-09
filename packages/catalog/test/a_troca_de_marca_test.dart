import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:diletta_coreflow/diletta_coreflow.dart' show Diletta;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A TROCA DE MARCA — o catálogo mostra a mesma peça na marca do Conta BOLD e na da Diletta.
///
/// É a decisão 3 do `ADR-005` do avô atravessando duas fronteiras: o motor desenha o seletor com
/// `id → rótulo` e pede ao plugue o tema daquela marca. O que este gate mede é o que o seletor
/// entrega: a marca pedida, com a paleta dela, e o default intacto pra quem não escolhe.
void main() {
  setUpAll(configurarDsDoBold);

  test('o plugue declara as duas marcas e sabe construir as duas', () {
    expect(Ds.marcas, {'bold': 'Conta BOLD', 'diletta': 'Diletta'});
    expect(Ds.trocaDeMarca, isTrue, reason: 'seletor sem gancho é botão que não faz nada');
  });

  for (final (id, marca, primario) in [
    ('bold', ContaBold.marca, ContaBold.produto.paleta.primary04),
    ('diletta', Diletta.marca, Diletta.vermelho),
  ]) {
    for (final escuro in [false, true]) {
      testWidgets('a marca `$id` chega com a paleta dela — ${escuro ? 'escuro' : 'claro'}', (t) async {
        late DilettaTheme tema;
        await t.pumpWidget(Ds.tema(
          Builder(builder: (ctx) {
            tema = DilettaTheme.of(ctx);
            return const SizedBox();
          }),
          escuro: escuro,
          marca: id,
        ));
        expect(tema.brand, marca);
        expect(tema.scheme.palette.primary04, primario);
        expect(tema.scheme.isDark, escuro);
      });

      // Decisão 2 do veredito: a fonte viaja pelo `ThemeData`. Se o seletor só puser o escopo do DS, a
      // Inter da Diletta não chega e texto sem cor cai no `DefaultTextStyle` do Material claro — foi o
      // cinza sobre fundo escuro da prévia de 09/09. Mede as duas coisas: família e cor do corpo.
      testWidgets('a marca `$id` traz o `ThemeData` do produto — ${escuro ? 'escuro' : 'claro'}',
          (t) async {
        late ThemeData material;
        late DilettaScheme s;
        await t.pumpWidget(Ds.tema(
          Builder(builder: (ctx) {
            material = Theme.of(ctx);
            s = DilettaTheme.schemeOf(ctx);
            return const SizedBox();
          }),
          escuro: escuro,
          marca: id,
        ));
        final produto = id == 'diletta' ? Diletta.produto : ContaBold.produto;
        final familia = produto.tipografia.familia;
        if (familia != null) {
          expect(material.textTheme.bodyMedium?.fontFamily, familia,
              reason: 'a família tipográfica do produto viaja pelo ThemeData');
        }
        expect(material.textTheme.bodyMedium?.color, s.fg,
            reason: 'texto sem cor herda o `fg` do esquema, e não o preto do Material claro');
        expect(material.textTheme.labelSmall?.color, s.textSecondary);
      });
    }
  }

  testWidgets('sem marca pedida, o default continua sendo o Conta BOLD', (t) async {
    late DilettaTheme tema;
    await t.pumpWidget(Ds.tema(Builder(builder: (ctx) {
      tema = DilettaTheme.of(ctx);
      return const SizedBox();
    })));
    expect(tema.brand, ContaBold.marca);
  });
}
