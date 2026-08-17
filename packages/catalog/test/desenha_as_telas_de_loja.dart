@Tags(['ferramenta'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_catalog/telas_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';


/// FERRAMENTA: desenha cada tela num PNG pra alguém OLHAR.
///
/// A suíte inteira passar não é a mesma coisa que a tela estar certa — o divisor invisível do
/// extrato passou por todos os gates deste repo e foi achado num print. Este arquivo existe pra que
/// o passo "abrir o artefato" custe um comando em vez de um deploy.
/// A tela SEM os bindings, e essa é a diferença entre um board e um screenshot.
///
/// O board desenha `{saldoFormatado}` no lugar do valor de propósito: ele documenta o CONTRATO, e
/// ver o nome do campo é o ponto. Uma imagem de loja documenta o PRODUTO — e nela o nome do campo é
/// exatamente o que não pode aparecer.
///
/// As props literais já estão na spec (o compositor guarda as duas coisas), então limpar o mapa de
/// bindings devolve a tela com os valores de exemplo. Nada aqui muda a fonte: é uma cópia.
ScreenSpec _semBindings(ScreenSpec tela) {
  Block limpo(Block b) => Block(
        id: b.id,
        type: b.type,
        props: b.props,
        slots: {
          for (final e in b.slots.entries) e.key: e.value.map(limpo).toList(),
        },
        fill: b.fill,
        fixedMain: b.fixedMain,
        sticky: b.sticky,
        crossAlign: b.crossAlign,
      );
  return ScreenSpec(
    name: tela.name,
    form: tela.form,
    blocks: tela.blocks.map(limpo).toList(),
    top: tela.top.map(limpo).toList(),
    bottom: tela.bottom.map(limpo).toList(),
    contentGap: tela.contentGap,
    scrollableContent: tela.scrollableContent,
  );
}

/// Os tipos declarados no TOPO da tela, em profundidade zero — chrome não mora dentro de slot. Mesma
/// leitura que o gate `as telas não duplicam o chrome` faz, e é de propósito: as duas perguntas são a
/// mesma ("esta tela já traz o relógio?"), vistas de lados opostos.
Set<String> tiposDoTopo(ScreenSpec tela) => {for (final b in tela.top) b.type};

/// O APARELHO É PARÂMETRO — a loja da Apple recusou a leva por TAMANHO e pediu 2064×2752 (iPad 13").
///
/// ```sh
/// flutter test test/desenha_as_telas_de_loja.dart \
///   --dart-define=largura=1032 --dart-define=altura=1376   # ×2 ⇒ 2064×2752
/// ```
///
/// O padrão continua 393×852: quem roda sem passar nada tira a mesma leva de sempre.
///
/// **A tela é DESENHADA no formato, não ampliada até ele.** A primeira resposta a este pedido foi
/// compor a imagem por fora — PNG de telefone ampliado e centrado numa arte de fundo —, e ela cabe na
/// loja sem responder ao dono do produto: o que sai é um telefone grande, e não dá pra validar o que
/// o produto faz na largura do iPad. Quem tinha que mudar era o frame, e mudou (`FormatoDoAparelho`).
const _largura = int.fromEnvironment('largura', defaultValue: 393);
const _altura = int.fromEnvironment('altura', defaultValue: 852);

void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  // Uma pasta por aparelho: a leva de telefone e a de iPad não se comem.
  final saida = Directory(
    'build/telas_de_loja${_largura == 393 ? '' : '_${_largura}x$_altura'}',
  )..createSync(recursive: true);

  for (final escuro in [false, true]) {
    for (final slug in [
      kSlugDaHome,
      kSlugDoHubDePix,
      kSlugDaConta,
      kSlugDoExtrato,
      kSlugDaAprovacao,
      kSlugDaAparencia,
    ]) {
      testWidgets('$slug ${escuro ? "escuro" : "claro"}', (t) async {
        // O `devicePixelRatio` 2 dá um PNG legível em tela cheia — e é o que faz 1032×1376 sair
        // como os 2064×2752 que a loja pede.
        t.view.physicalSize = const Size(_largura * 2.0, _altura * 2.0);
        t.view.devicePixelRatio = 2.0;
        addTearDown(t.view.reset);

        // A CASCA DE TOPO TRAZ O RELÓGIO; a casca de APP não, e aí ele é do aparelho.
        //
        // `cascaDeTopo` compõe `DilettaStatusBar` (o 9:41 mock) por dentro, e é por isso que as cinco
        // telas de topo saíam com relógio. A home usa `cabecalhoDaHome`, que desde a v0.16.0 do DS é
        // `DilettaTopAppBar.app`: ela reserva o INSET REAL da `SafeArea` em vez de desenhar o mock —
        // *"não é uma tela minha, é um componente meu que não podia ser usado no meu app"*.
        //
        // Num render headless o inset é ZERO, então a home saía sem faixa nenhuma e colada no topo. Num
        // aparelho quem pinta ali é o sistema. **Estas imagens são mock de aparelho**, então quem faz o
        // papel do sistema é esta ferramenta: dá o inset de 40 e pinta a faixa por cima dele.
        //
        // Fica aqui e NÃO na spec: declarar `barraDeStatus` no `top` da home seria o catálogo dizendo
        // que a tela desenha o relógio, e ela não desenha — o gate `as telas não duplicam o chrome`
        // proíbe exatamente essa coexistência, e proíbe certo.
        final chromeDoAparelho = tiposDoTopo(telasDoBold()[slug]!)
            .intersection(const {'cascaDeTopo', 'barraDeStatus'}).isEmpty;
        if (chromeDoAparelho) {
          t.view.padding = const FakeViewPadding(top: 40 * 2);
        }

        final chave = GlobalKey();
        await t.pumpWidget(RepaintBoundary(
          key: chave,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // O BRILHO VIAJA COM O TEMA, e sem esta linha a leva escura saía com TEXTO PRETO.
            //
            // Achado olhando o PNG, que é a razão desta ferramenta existir: no
            // `pf8-aparencia-escuro` as duas linhas de apoio estavam invisíveis, e no
            // `pf7-extrato-escuro` o título "Transações" também — cinza escuro sobre arte noturna.
            //
            // A causa não é o bloco. O `texto` emite `ds.DilettaText(x, style: ds.DilettaType.bodySm)`,
            // e o token de tipo NÃO carrega cor (de propósito: cor é papel, e papel vem do scheme). A
            // cor então vem do `DefaultTextStyle`, que é fornecido pelo Material — e este `ThemeData`
            // era CLARO nas duas voltas do laço. O `DilettaThemeScope` de dentro pintava fundo, card e
            // acessório certos, e o texto solto ficava com a tinta do tema errado.
            //
            // No app isso não acontece porque lá o `MaterialApp` recebe o tema do produto por modo.
            // Aqui a árvore é montada à mão, e montar à mão é onde o ambiente se perde.
            theme: ThemeData(
              fontFamily: BoldFonts.familyRaw,
              brightness: escuro ? Brightness.dark : Brightness.light,
            ),
            // `Scaffold` porque o campo de busca é `TextField`, e ele exige um ancestral Material.
            // O frame do board já dá um; aqui a árvore é montada à mão.
            home: Scaffold(
              backgroundColor: const Color(0x00000000),
              // O APARELHO em que o motor vai desenhar. Sem esta linha o frame é o telefone e o
              // `view` maior só acrescenta vazio à direita e embaixo — foi o primeiro resultado.
              body: FormatoDoAparelho(
                tamanho: const Size(_largura * 1.0, _altura * 1.0),
                child: DilettaThemeScope(
              theme: escuro ? BoldTheme.dark : BoldTheme.light,
              child: Builder(builder: (ctx) {
                final s = DilettaTheme.schemeOf(ctx);
                return ColoredBox(
                  color: s.bg,
                  child: Stack(children: [
                    // O fundo NÃO é pintado aqui, e essa é a mudança da v0.94.0 do motor: quem
                    // pinta é o `buildScreenLayout`, chamando o gancho por dentro do `TelaEmFoco`.
                    // Antes eu pintava por fora e o de dentro vencia — foi o que fez o pedido entrar.
                    buildScreenLayout(_semBindings(telasDoBold()[slug]!),
                        leaf: buildBlock),
                    // A faixa do sistema, por CIMA e no inset que a linha lá em cima reservou. Ela é a
                    // mesma peça que a casca de topo compõe (`DilettaStatusBar`, 40 de altura), então o
                    // relógio das seis imagens é um só.
                    if (chromeDoAparelho)
                      const Align(
                        alignment: Alignment.topCenter,
                        child: DilettaStatusBar(),
                      ),
                  ]),
                );
              }),
              ),
              ),
            ),
          ),
        ));
        await t.pump(const Duration(milliseconds: 600));

        // A ARTE PRECISA SER ESPERADA, e este é o defeito que a primeira leva desta ferramenta teve:
        // a home saía SEM a cidade nos dois temas, e as outras quatro saíam com ela. Não era a tela —
        // era a ordem. `AssetImage` decodifica FORA do relógio do teste, e a home é a primeira de
        // cada laço; da segunda em diante a imagem já estava no cache e aparecia.
        //
        // Um artefato que mente sobre a primeira tela e acerta as outras quatro é pior que um que
        // erra todas: ele passa por decisão de design. `precacheImage` dentro de `runAsync` é o que
        // dá ao decodificador um relógio de verdade.
        await t.runAsync(() async {
          for (final arte in const [
            AssetImage('assets/demo/cidade-claro.jpg'),
            AssetImage('assets/demo/cidade-escuro.jpg'),
          ]) {
            await precacheImage(arte, chave.currentContext!);
          }
        });
        await t.pump(const Duration(milliseconds: 600));

        await t.runAsync(() async {
          final limite = chave.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
          final imagem = await limite.toImage(pixelRatio: 2);
          final bytes = await imagem.toByteData(format: ui.ImageByteFormat.png);
          File('${saida.path}/$slug-${escuro ? "escuro" : "claro"}.png')
              .writeAsBytesSync(bytes!.buffer.asUint8List());
        });
      });
    }
  }
}
