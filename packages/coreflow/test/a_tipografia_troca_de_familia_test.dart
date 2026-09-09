import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A FONTE VIAJA PELO TEMA (veredito de 08/09, decisão 2), e um filho que herda a escala do avô e
/// declara só a família precisa de um jeito de dizê-lo sem reescrever os onze degraus. É o `copyWith`.
void main() {
  test('copyWith troca só a família e preserva os onze degraus do avô', () {
    const doAvo = CoreflowTipografia.doAvo;
    final minha = doAvo.copyWith(familia: 'packages/meu_produto/MinhaFonte');
    expect(minha.familia, 'packages/meu_produto/MinhaFonte');
    expect(doAvo.familia, isNull, reason: 'o avô não declara família — é o produto que declara');
    for (final (a, b) in [
      (doAvo.displayLarge, minha.displayLarge), (doAvo.headlineLarge, minha.headlineLarge),
      (doAvo.headlineMedium, minha.headlineMedium), (doAvo.titleLarge, minha.titleLarge),
      (doAvo.bodyLarge, minha.bodyLarge), (doAvo.bodyMedium, minha.bodyMedium),
      (doAvo.labelLarge, minha.labelLarge), (doAvo.labelSmall, minha.labelSmall),
      (doAvo.botaoDeTexto, minha.botaoDeTexto), (doAvo.dica, minha.dica),
      (doAvo.rotuloDeCampo, minha.rotuloDeCampo),
    ]) {
      expect(identical(a, b), isTrue, reason: 'degrau reescrito no copyWith');
    }
    // Sem argumento, é cópia fiel — inclusive da família.
    expect(minha.copyWith().familia, minha.familia);
  });

  test('a família do copyWith chega no ThemeData inteiro', () {
    final t = CoreflowTemaMaterial.de(
      CoreflowScheme.de(DilettaPalette.referencia, brilho: Brightness.light),
      tipografia: CoreflowTipografia.doAvo.copyWith(familia: 'Fulana'),
    );
    expect(t.textTheme.bodyMedium?.fontFamily, 'Fulana');
    expect(t.textTheme.labelSmall?.fontFamily, 'Fulana');
  });
}
