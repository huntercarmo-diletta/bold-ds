// UM import: o barril do filho reexporta a linguagem.
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A BARRA DE TOPO DO PAI RECEBE O CABEÇALHO DESTE FILHO.
///
/// Este é o gate que eu prometi no pedido
/// (`docs/pedidos/2026-07-29-barra-de-topo-nao-aceita-cabecalho-do-filho.md`), e ele existe
/// porque a resposta do pai vale exatamente o que ela destrava.
///
/// O que estava travado: os acessórios da barra eram `sealed`, então não havia caminho de
/// composição — nem o de sempre ("compõe com o que existe"). A v0.4.0 abriu
/// `DilettaNavigationLeftAccessory.livre(child:, ocupaALinha:)`.
///
/// **O cabeçalho aqui é um esqueleto de propósito.** O de verdade precisa do avatar, do
/// rótulo de conta com estado de carregando e da troca de conta — três peças que ainda não
/// nasceram neste filho. O que este teste prova é o MECANISMO: a barra do pai aceita um
/// cabeçalho que ela não conhece, dá a linha inteira a ele quando pedido, e o tema do Bold
/// atravessa. Quando o cabeçalho real existir, ele entra no lugar do esqueleto e o teste
/// continua valendo.
void main() {
  /// O esqueleto: uma linha com avatar e nome, que é a forma do cabeçalho da home.
  Widget cabecalhoDaHome(BuildContext ctx) {
    final s = DilettaTheme.schemeOf(ctx);
    return DilettaFrame.row(
      gap: DilettaSpacing.s3,
      children: [
        DilettaBox(
          color: s.primary,
          radius: DilettaRadius.all16,
          child: const SizedBox(width: 36, height: 36),
        ),
        DilettaText('Olá, Ana', style: DilettaType.titleMd),
      ],
    );
  }

  testWidgets('a barra do pai aceita o cabeçalho do filho e dá a linha inteira', (t) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: Scaffold(
          body: Builder(
            builder: (ctx) => DilettaNavigationTopBar(
              left: DilettaNavigationLeftAccessory.livre(
                child: cabecalhoDaHome(ctx),
                ocupaALinha: true,
              ),
              // Ícones à direita com badge NÃO precisaram de nada: o pai já tinha, e ele
              // mediu isso antes de responder o pedido.
              right: DilettaNavigationRightAccessory.icons(
                icons: const [
                  DilettaNavRightIcon(
                    icon: DilettaIcons.bellLight,
                    semanticLabel: 'Notificações',
                    badge: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    expect(t.takeException(), isNull);
    expect(find.text('Olá, Ana'), findsOneWidget);
  });

  testWidgets('o cabeçalho sai com a cor do BOLD, e nenhuma do primeiro filho', (t) async {
    // O par do teste acima: caber não basta, tem que sair com a identidade daqui.
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.dark,
        child: Scaffold(
          body: Builder(
            builder: (ctx) => DilettaNavigationTopBar(
              left: DilettaNavigationLeftAccessory.livre(
                  child: cabecalhoDaHome(ctx), ocupaALinha: true),
            ),
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    final cores = <int>{};
    for (final w in t.allWidgets) {
      for (final prop in w.toDiagnosticsNode().getProperties()) {
        switch (prop.value) {
          case Color c:
            cores.add(c.toARGB32());
          case BoxDecoration d when d.color != null:
            cores.add(d.color!.toARGB32());
        }
      }
    }

    // No escuro o papel `primary` é o degrau 05 da paleta — o rosa que pulsa sobre fundo
    // escuro. É ele que tem que aparecer, não o 04 do claro.
    expect(cores, contains(BoldPalette.bold.primary05.toARGB32()),
        reason: 'a identidade do Bold não chegou no cabeçalho');
    expect(cores, isNot(contains(0xFF003BE0)),
        reason: 'azul do primeiro filho no cabeçalho do Bold');
  });
}
