import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O `ThemeData` MORA AQUI, e o gate existe por causa de um defeito que durou semanas.
///
/// Enquanto o tema morava no app, quem servia o `MaterialApp` era a camada legada — que pedia
/// **Nunito** — enquanto os 644 sítios que leem um degrau da escada saíam em **Inter**. Duas fontes
/// na mesma tela, e nenhum teste olhava, porque cada metade estava certa sozinha.
///
/// As asserções aqui são as duas metades juntas: o tema que este pacote entrega pede a família da
/// marca, e ele registra o esquema que as peças leem. Sem a segunda, `BoldColors.of(context)` cai
/// no escuro em silêncio dentro de um app claro.
void main() {
  for (final (nome, tema, esperado) in [
    ('claro', BoldTemaMaterial.claro, Brightness.light),
    ('escuro', BoldTemaMaterial.escuro, Brightness.dark),
  ]) {
    group('o tema $nome', () {
      test('pede a família da marca em toda a escada', () {
        for (final degrau in [
          tema.textTheme.bodyMedium,
          tema.textTheme.bodyLarge,
          tema.textTheme.titleLarge,
          tema.textTheme.labelLarge,
          tema.textTheme.displayLarge,
        ]) {
          expect(degrau?.fontFamily, BoldFonts.family);
        }
      });

      test('registra o esquema, e ele é do modo certo', () {
        final s = tema.extension<BoldScheme>();
        expect(s, isNotNull,
            reason: 'sem a extensão, `BoldColors.of(context)` devolve o escuro '
                'por fallback — dentro de um app claro, e sem erro nenhum');
        expect(s!.brightness, esperado);
        expect(tema.brightness, esperado);
      });

      test('o Material e o esquema não discordam da paleta', () {
        final s = tema.extension<BoldScheme>()!;
        expect(tema.colorScheme.primary, BoldColors.primary04);
        expect(tema.colorScheme.error, BoldColors.error04);
        // A tinta sobre a marca sai do PAPEL. Se um dia ela virar branco cru de novo, este par
        // deixa de bater e o teste diz onde.
        expect(tema.colorScheme.onPrimary, s.onPrimary);
        expect(tema.colorScheme.surface, s.surface);
        expect(tema.scaffoldBackgroundColor, s.background);
        expect(tema.canvasColor, s.background);
      });
    });
  }

  test('o esquema DERIVA do pai — e o que não deriva é decisão de marca', () {
    // Onze dos catorze no escuro e nove dos catorze no claro saem do `DilettaScheme`. O gate mede
    // uma amostra dos derivados: se o pai mudar um degrau, o filho acompanha sem ninguém tocar
    // aqui — e se alguém cravar um hex por cima, o par para de bater.
    final escuro = BoldScheme.dark();
    final doPaiEscuro = DilettaScheme.dark(BoldPalette.bold);
    expect(escuro.background, doPaiEscuro.bg);
    expect(escuro.surface, doPaiEscuro.surface);
    expect(escuro.textPrimary, doPaiEscuro.fg);
    expect(escuro.border, doPaiEscuro.border);

    final claro = BoldScheme.light();
    final doPaiClaro = DilettaScheme.light(BoldPalette.bold);
    expect(claro.surface, doPaiClaro.surface);
    expect(claro.textPrimary, doPaiClaro.fg);
    expect(claro.textMuted, doPaiClaro.textMuted);
    expect(claro.border, doPaiClaro.border);

    // E o que NÃO deriva: a marca deste produto é o degrau 04 nos dois modos, contra o 05 que o
    // pai clareia no escuro. Trocar isto muda a cor da marca em toda tela — por isso tem gate.
    expect(escuro.primary, BoldColors.primary04);
    expect(escuro.primary, isNot(doPaiEscuro.primary));
  });
}
