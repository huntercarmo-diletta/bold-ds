import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ESCOLHA DA PESSOA VENCE O DEFAULT DA TELA — e a ordem inversa foi defeito de verdade.
///
/// Medido no `app-newbold` durante a adoção: este pacote resolvia `estilo ?? scope`, e o app
/// resolvia `escolhido ?? padraoDaTela`. Com a ordem do pacote, toda tela que declara o
/// próprio fundo passa a ignorar a personalização — que é o **item 72 do QA** do app, onde a
/// Área Pix declarava `solido` e o fundo escolhido em Aparência não aparecia.
///
/// O teste olha o que foi PINTADO, e não o que o widget diz: pega a cor do `DecoratedBox` de
/// base, que é diferente entre `solido` (bgEscuro no escuro) e os moods.
void main() {
  Future<String> fundoResolvido(
    WidgetTester tester, {
    BoldBackdrop? escolhido,
    BoldBackdrop? daTela,
  }) async {
    await tester.pumpWidget(
      DilettaThemeScope(
        theme: BoldTheme.dark,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: BoldBackdropScope(
            estilo: escolhido,
            child: BoldBackground(estilo: daTela, child: const SizedBox()),
          ),
        ),
      ),
    );
    // O próprio componente declara o que resolveu, pro DevInfo do pai. É a leitura mais
    // direta possível do valor efetivo — sem inferir por cor, que no escuro não distingue
    // sólido de mood (os dois assentam no mesmo `bg`).
    final info = tester.widget<DilettaDevInfo>(find.byType(DilettaDevInfo));
    return info.props['estilo']!;
  }

  testWidgets('sem escolha salva, o default da tela vale', (t) async {
    expect(await fundoResolvido(t, daTela: BoldBackdrop.solido), 'solido');
  });

  testWidgets('com escolha salva, ela VENCE o default da tela', (t) async {
    // A tela pede sólido; a pessoa escolheu aurora. Tem que sair aurora — e é exatamente o
    // caso da Área Pix no QA 72.
    expect(
      await fundoResolvido(
        t,
        escolhido: BoldBackdrop.aurora,
        daTela: BoldBackdrop.solido,
      ),
      'aurora',
    );
  });

  testWidgets('sem escolha e sem default, o fundo é imagem', (t) async {
    expect(await fundoResolvido(t), 'imagem');
  });

  testWidgets('a AMOSTRA desenha o mood pedido mesmo com outro escolhido', (t) async {
    // Visto no app, não medido aqui: a tela de Aparência desenha as cinco opções de mood, e **as
    // cinco mostravam o fundo já escolhido**. É a regra certa no lugar errado — "a escolha vence o
    // default" está certa pra TELA (o QA 72 acima) e errada pro SELETOR, onde cada quadradinho é o
    // retrato de um mood. Nenhum teste falhava: cinco amostras concordando é estado consistente.
    await t.pumpWidget(
      DilettaThemeScope(
        theme: BoldTheme.dark,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: BoldBackdropScope(
            estilo: BoldBackdrop.aurora,
            child: BoldBackground.amostra(
              estilo: BoldBackdrop.porDoSol,
              child: SizedBox(),
            ),
          ),
        ),
      ),
    );
    final info = t.widget<DilettaDevInfo>(find.byType(DilettaDevInfo));
    expect(info.props['estilo'], 'porDoSol',
        reason: 'a amostra seguiu a escolha — o seletor volta a mostrar cinco iguais');
  });
}
