import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ARTE DO FUNDO — o gate de uma ausência que degradava em silêncio.
///
/// Perguntado pelo dono do produto: *"cadê a imagem que tem como opção de bg?"* E não havia: o
/// `BoldBackground` recebe a arte pelo `BoldBackdropScope` — decisão certa do DS, que assim não crava
/// caminho de asset do app —, mas **o catálogo é um consumidor e não declarava nada**. O mood `imagem`,
/// que é o fundo da home e o componente mais usado do produto (114 chamadas), aparecia degradado: véu e
/// brilho, sem cidade.
///
/// Degradar em vez de quebrar é o desenho certo do componente. O efeito colateral é este: **a ausência
/// não falha em lugar nenhum**, e o catálogo mostrava um mood a menos sem nada acusar.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  testWidgets('o gancho do frame DECLARA a arte, nos dois modos', (t) async {
    // Pelo gancho e não por um `BoldBackdropScope` que eu montasse no teste: o que precisa estar certo é
    // o que o motor vai desenhar.
    late BoldBackdropScope? scope;
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: Builder(
          builder: (ctx) => Builder(
            builder: (dentro) {
              final w = Ds.atual.fundoDoFrame!(ctx);
              scope = w is BoldBackdropScope ? w : null;
              return w;
            },
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    expect(scope, isNotNull, reason: 'o gancho parou de declarar o scope');
    expect(scope!.arteClara, isNotNull, reason: 'sem arte no claro, o mood imagem degrada');
    expect(scope!.arteEscura, isNotNull, reason: 'sem arte no escuro, idem');
    expect(scope!.estilo, BoldBackdrop.imagem,
        reason: 'o default do produto é imagem — é o fundo da home');
  });

  testWidgets('e a arte PINTA, com o PROVIDER declarado', (t) async {
    // A pergunta que faltava: scope declarado ainda pode não pintar.
    //
    // A primeira versão deste teste procurava `DecoratedBox` com `image` — e falhou. O componente pinta
    // com `Image(image: arte)`, não com decoração. **Terceira vez hoje que uma asserção minha mede o
    // widget errado**, e a lição é a mesma: quando o vermelho é novo, o primeiro suspeito é o teste.
    //
    // Conferir o PROVIDER e não só "existe alguma imagem" é o que distingue "pintou a arte declarada" de
    // "pintou qualquer coisa" — um ícone na árvore satisfaria a versão frouxa.
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: Builder(builder: (ctx) => Ds.atual.fundoDoFrame!(ctx)),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    final providers = t
        .widgetList<Image>(find.byType(Image))
        .map((i) => i.image)
        .whereType<AssetImage>()
        .map((a) => a.assetName)
        .toList();
    expect(providers, contains('assets/demo/cidade-claro.jpg'),
        reason: 'o mood imagem não pintou a arte declarada — voltou a degradar: $providers');
  });
}
