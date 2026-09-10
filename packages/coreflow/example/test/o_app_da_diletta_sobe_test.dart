import 'package:diletta_coreflow/main.dart';
import 'package:diletta_coreflow/diletta_coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O APP SOBE VESTIDO DE DILETTA, e troca de modo com o Material e o DS de acordo.
///
/// O que se prova é a fiação da receita do pai: o `ThemeData` e o `DilettaThemeScope` saem do mesmo
/// produto e seguem o mesmo brilho; a fonte chega pelo tema; a cor da marca chega ao botão. O que a
/// tela desenha já está provado no pacote — aqui é o app.
void main() {
  testWidgets('sobe no claro com a Inter no tema e a marca no botão', (t) async {
    t.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pumpWidget(const AppDaDiletta());
    await t.pumpAndSettle();

    expect(find.byType(TelaDeExemploDiletta), findsOneWidget);
    final ctx = t.element(find.byType(TelaDeExemploDiletta));
    expect(Theme.of(ctx).textTheme.bodyMedium?.fontFamily, 'packages/diletta_coreflow/Inter',
        reason: 'a fonte do produto viaja pelo ThemeData');
    expect(DilettaTheme.of(ctx).scheme.primary, Diletta.vermelho);
    expect(DilettaTheme.of(ctx).scheme.isDark, isFalse);

    // O botão ACESO é o do modo em vigor — e o app nasce em `Sistema`.
    CoreflowVarianteDeBotao variante(String rotulo) =>
        t.widget<CoreflowBotao>(find.widgetWithText(CoreflowBotao, rotulo)).variant;
    expect(variante('Sistema'), CoreflowVarianteDeBotao.primary);
    expect(variante('Claro'), CoreflowVarianteDeBotao.secondary);
    expect(variante('Escuro'), CoreflowVarianteDeBotao.secondary);
  });

  testWidgets('os três botões trocam o modo, e Material e DS trocam juntos', (t) async {
    t.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pumpWidget(const AppDaDiletta());
    await t.pumpAndSettle();

    await t.tap(find.text('Escuro'));
    await t.pumpAndSettle();
    var ctx = t.element(find.byType(TelaDeExemploDiletta));
    expect(Theme.of(ctx).brightness, Brightness.dark);
    expect(DilettaTheme.of(ctx).scheme.isDark, isTrue, reason: 'o escopo do DS não seguiu o Material');
    expect(DilettaTheme.of(ctx).brand.corDoLogo, DilettaAbsoluteColors.white,
        reason: 'as letras do lockup seguem o tema — brancas no escuro');

    await t.tap(find.text('Claro'));
    await t.pumpAndSettle();
    ctx = t.element(find.byType(TelaDeExemploDiletta));
    expect(Theme.of(ctx).brightness, Brightness.light);
    expect(DilettaTheme.of(ctx).scheme.isDark, isFalse);
    expect(DilettaTheme.of(ctx).brand.corDoLogo, DilettaAbsoluteColors.black);

    // `Sistema` devolve a decisão ao aparelho — que neste teste está no claro.
    await t.tap(find.text('Sistema'));
    await t.pumpAndSettle();
    ctx = t.element(find.byType(TelaDeExemploDiletta));
    expect(Theme.of(ctx).brightness, Brightness.light);
  });

  testWidgets('em ThemeMode.system, quem decide é o aparelho', (t) async {
    t.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await t.pumpWidget(const AppDaDiletta());
    await t.pumpAndSettle();
    final ctx = t.element(find.byType(TelaDeExemploDiletta));
    expect(Theme.of(ctx).brightness, Brightness.dark);
    expect(DilettaTheme.of(ctx).scheme.isDark, isTrue);
  });
}
