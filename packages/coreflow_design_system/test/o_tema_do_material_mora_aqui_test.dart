import 'package:coreflow_design_system/coreflow_design_system.dart';
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
    ('claro', CoreflowTemaMaterial.claro, Brightness.light),
    ('escuro', CoreflowTemaMaterial.escuro, Brightness.dark),
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
        final s = tema.extension<CoreflowScheme>();
        expect(s, isNotNull,
            reason: 'sem a extensão, `BoldColors.of(context)` devolve o escuro '
                'por fallback — dentro de um app claro, e sem erro nenhum');
        expect(s!.brightness, esperado);
        expect(tema.brightness, esperado);
      });

      test('o Material e o esquema não discordam da paleta', () {
        final s = tema.extension<CoreflowScheme>()!;
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
    final escuro = CoreflowScheme.dark();
    final doPaiEscuro = DilettaScheme.dark(BoldPalette.bold);
    expect(escuro.background, doPaiEscuro.bg);
    expect(escuro.surface, doPaiEscuro.surface);
    expect(escuro.textPrimary, doPaiEscuro.fg);
    expect(escuro.border, doPaiEscuro.border);

    final claro = CoreflowScheme.light();
    final doPaiClaro = DilettaScheme.light(BoldPalette.bold);
    expect(claro.surface, doPaiClaro.surface);
    expect(claro.textPrimary, doPaiClaro.fg);
    expect(claro.textMuted, doPaiClaro.textMuted);
    expect(claro.border, doPaiClaro.border);

    // **A marca do ESCURO passou a ser a do pai em 19/08**, por decisão do dono. O gate inverteu de
    // lado: antes ele guardava o `primary04` cravado aqui, agora ele guarda a derivação — e é ele que
    // reprova se alguém recravar o rosa do logo no escuro sem passar pela mesma decisão.
    expect(escuro.primary, doPaiEscuro.primary);
    expect(escuro.onPrimary, doPaiEscuro.onPrimary);
    expect(escuro.primary, isNot(BoldColors.primary04),
        reason: 'o escuro usa o degrau 05, que o pai clareia de propósito');

    // E o que sobra sem derivar no escuro é UM: o wash translúcido contra o subtle sólido dele.
    expect(escuro.primaryWash, isNot(doPaiEscuro.primarySubtle));
  });

  test('a TINTA ASSUMIDA é honrada no claro, derivada no escuro — e o número confere', () {
    // O veredito da `v0.115.0` do pai, medido dos dois lados. A exceção só vale se deixar NÚMERO, e
    // a auditoria dele confere o declarado contra o pior modo — número melhor que a realidade
    // transforma dívida assumida em dívida escondida.
    final excecoes = excecoesDeTintaAssumida(BoldPalette.bold);
    expect(excecoes, hasLength(1));
    final t = excecoes.single;
    expect(t.papel, 'onPrimary');
    expect(t.honradaEm, {'claro'},
        reason: 'no escuro o pai clareia a marca pro degrau 05 e o branco cai pra 2,73 — abaixo do '
            'teto de 3:1, então a derivação segue mandando. Assumir ali seria decidir por ilegível');
    expect(t.medidas['claro']!, closeTo(3.46, 0.01));
    expect(t.declarada, lessThanOrEqualTo(t.medidas.values.reduce((a, b) => a < b ? a : b) + 0.05));

    expect(violacoesDaTintaAssumida(BoldPalette.bold), isEmpty);

    // E o efeito, que é o que o dono do produto vê: no claro a tinta sobre a marca é BRANCA nas
    // peças do pai — o mesmo branco que o CTA deste produto sempre usou.
    expect(DilettaScheme.light(BoldPalette.bold).onPrimary,
        DilettaAbsoluteColors.white);
  });
}
