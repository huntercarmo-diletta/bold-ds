import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:diletta_coreflow/diletta_coreflow.dart' show Diletta, kDilettaFundamentos;
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
        // A marca chega com as letras do lockup decididas por modo (`marcaNo`, 0.99.0): compara o que
        // identifica a marca, e cobra a tinta certa em vez da identidade do objeto.
        expect(tema.brand.logoFull, marca.logoFull);
        expect(tema.brand.pacote, marca.pacote);
        expect(tema.brand.corDoLogo, escuro ? DilettaAbsoluteColors.white : DilettaAbsoluteColors.black);
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

  // STYLES E FUNDAMENTOS SEGUEM A MARCA. O motor lê `Ds.estilos`/`Ds.fundamentos` do plugue atual, e o
  // plugue assina `CC.marca`: trocar a marca no seletor replugue com a paleta e a prosa daquela marca.
  // Mede as três coisas que mudam (cores, papéis, prosa) e a que NÃO muda (a linguagem), e volta.
  group('Styles e Fundamentos seguem a marca escolhida', () {
    tearDown(() {
      CC.marca.value = null;
      configurarDsDoBold();
    });

    test('com a Diletta escolhida, o inventário e a prosa são dela', () {
      CC.marca.value = 'diletta';
      final inv = Ds.estilos;
      expect(inv.cores['primary04'], Diletta.vermelho);
      expect(inv.cores['vinho.marca'], CoreflowVinho.marcaDe(Diletta.produto.paleta),
          reason: 'vinho da Diletta é o derivado da rampa dela, não o declarado do Bold');
      expect(inv.papeis['primary']?.claro, Diletta.produto.claro.scheme.primary);
      expect(inv.papeis['bg']?.escuro, Diletta.produto.escuro.scheme.bg);
      expect(Ds.fundamentos.keys.toSet(), {'A linguagem (do pai)', ...kDilettaFundamentos.keys});
      expect(Ds.fundamentos['A linguagem (do pai)'], same(kDilettaLinguagem),
          reason: 'a linguagem é a mesma nas duas marcas — é o que o white label promete');
      // O que é linguagem não muda com a marca.
      final doBold = _comMarca('bold', () => Ds.estilos);
      expect(inv.tipos.keys, doBold.tipos.keys);
      expect(inv.raios, doBold.raios);
      expect(inv.descricoesDeToken, doBold.descricoesDeToken);
    });

    test('voltando pro Conta BOLD, a página é a de antes — byte a byte nas cores', () {
      CC.marca.value = 'diletta';
      CC.marca.value = 'bold';
      final inv = Ds.estilos;
      expect(inv.cores['primary04'], BoldPalette.bold.primary04);
      expect(inv.cores['vinho.marca'], BoldVinho.marca);
      expect(inv.cores['vinho.ink'], BoldVinho.ink);
      expect(Ds.fundamentos.keys, contains('A paleta do Bold'));
      expect(Ds.fundamentos.keys, isNot(contains('A paleta da Diletta')));
    });

    test('a conformidade do motor não ganha violação nova com a Diletta plugada', () {
      final doBold = violacoesDoFilho().map(chaveDaViolacao).toSet();
      CC.marca.value = 'diletta';
      final daDiletta = violacoesDoFilho().map(chaveDaViolacao).toSet();
      expect(daDiletta.difference(doBold), isEmpty,
          reason: 'alias do papel apontando pra entrada que a paleta da Diletta não publica, ou par sem contraste');
    });

    testWidgets('a aba de Styles desenha a paleta da Diletta, e troca sem sair dela', (t) async {
      t.view.physicalSize = const Size(1400, 6000);
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(
        child: Ds.tema(
          ValueListenableBuilder<String?>(
            valueListenable: CC.marca,
            builder: (_, m, __) => KeyedSubtree(key: ValueKey(m ?? 'bold'), child: const AbaDeStyles()),
          ),
          escuro: false,
        ),
      ))));
      await t.pumpAndSettle();
      const hexDaDiletta = '#E60000';
      final hexDoBold = '#${(BoldPalette.bold.primary04.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
      expect(find.textContaining(hexDoBold, findRichText: true), findsWidgets);
      expect(find.textContaining(hexDaDiletta, findRichText: true), findsNothing);

      CC.marca.value = 'diletta';
      await t.pumpAndSettle();
      expect(find.textContaining(hexDaDiletta, findRichText: true), findsWidgets);
      expect(find.textContaining(hexDoBold, findRichText: true), findsNothing);
    });
  });

  testWidgets('sem marca pedida, o default continua sendo o Conta BOLD', (t) async {
    late DilettaTheme tema;
    await t.pumpWidget(Ds.tema(Builder(builder: (ctx) {
      tema = DilettaTheme.of(ctx);
      return const SizedBox();
    })));
    expect(tema.brand.logoFull, ContaBold.marca.logoFull);
    expect(tema.brand.pacote, ContaBold.marca.pacote);
  });
}

/// Roda [le] com a marca [m] plugada e devolve ao estado anterior.
T _comMarca<T>(String m, T Function() le) {
  final antes = CC.marca.value;
  CC.marca.value = m;
  try {
    return le();
  } finally {
    CC.marca.value = antes;
  }
}
