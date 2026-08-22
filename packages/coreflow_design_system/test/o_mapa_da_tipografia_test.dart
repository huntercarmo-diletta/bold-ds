import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// O MAPA DA TIPOGRAFIA — cada preset do Bold antigo e o degrau do pai que o substitui.
///
/// A escala é LINGUAGEM por decisão do ADR-003: o filho fornece a paleta e a família, não a
/// escala. Então "fechar a tipografia" aqui não é declarar token, é decidir a substituição UMA
/// vez — senão ela é decidida de novo em cada tela, e aí o produto ganha duas escalas.
///
/// ## Como eu escolhi
///
/// Medi os 19 presets do produto antigo contra os 23 do pai. **Sete são idênticos** em tamanho
/// e peso, o que era esperado: o DS do Bold nasceu se integrando com o do primeiro filho.
///
/// Nos outros doze a regra foi **papel primeiro, métrica depois**. Quando um degrau do pai
/// tinha a métrica exata mas o papel errado (o `labelLg` do Bold é 14/500, e o pai tem
/// `titleSm` 14/500 e `labelLg` 14/600), escolhi pelo papel: o nome do papel é o que o próximo
/// dev lê, e um `titleSm` fazendo trabalho de label mente pra ele. Peso de 100 a mais é uma
/// diferença que se vê olhando; papel errado é uma diferença que se descobre seis telas depois.
///
/// Nos cinco degraus que só existiam no Bold (10, 13, 17, 30, 46), três estavam a **1px** de um
/// degrau do pai — isso é arredondamento acumulado, não escala. Os outros dois (13 e 30) eu
/// resolvi pela LADEIRA: o produto tinha display 46 · h1 30 · h2 22, e o pai tem displayMd 45 ·
/// headlineLg 32 · titleLg 22. Mapear degrau a degrau mantém a proporção entre eles, que é o
/// que o olho lê — em vez de escolher cada um pelo vizinho mais próximo e achatar a hierarquia.
///
/// ## O que este teste faz, e por que ele existe
///
/// Ele fixa os degraus ESCOLHIDOS. Se o pai mudar tamanho ou peso de um deles numa versão
/// futura, este gate fala — em vez de a tipografia do produto mudar no `pub get` e alguém
/// descobrir comparando telas. É o mesmo raciocínio do teste de vazamento de cor: a decisão foi
/// medida uma vez, então ela vira medida.
void main() {
  /// preset antigo → (degrau do pai, tamanho, peso, o que muda)
  const mapa = <String, (TextStyle, double, int, String)>{
    // ── Idênticos: nada muda ────────────────────────────────────────────────
    'headlineMd': (DilettaType.headlineMd, 28, 600, 'idêntico'),
    'headlineSm': (DilettaType.headlineSm, 24, 600, 'idêntico'),
    'titleMd': (DilettaType.titleMd, 16, 500, 'idêntico'),
    'labelMd': (DilettaType.labelMd, 12, 500, 'idêntico'),
    'labelSm': (DilettaType.labelSm, 11, 500, 'idêntico'),
    'bodySm': (DilettaType.bodySm, 12, 400, 'idêntico'),
    'bodyLg': (DilettaType.bodyLg, 16, 400, 'idêntico'),

    // ── Mesmo tamanho, peso diferente: papel decide ─────────────────────────
    'labelLg': (DilettaType.labelLg, 14, 600, 'peso 500 → 600'),
    'button': (DilettaType.button, 15, 600, 'peso 700 → 600'),
    'label': (DilettaType.label, 12, 600, 'peso 700 → 600'),
    'h2': (DilettaType.title, 22, 600, 'peso 700 → 600'),

    // ── Degraus que só o Bold tinha ─────────────────────────────────────────
    // 46 → 45 e 17 → 16 são 1px: drift, não escala.
    'display': (DilettaType.displayMd, 45, 600, '46/800 → 45/600'),
    'title': (DilettaType.heading, 16, 600, '17/700 → 16/600'),
    // 10 → 11: o menor degrau do pai. Abaixo de 11 ele não tem, e pedir um degrau de 10
    // seria pedir que a linguagem descesse pra caber num arredondamento meu.
    'tileLabel': (DilettaType.labelSm, 11, 500, '10 → 11'),
    // Estes dois pela LADEIRA, não pelo vizinho: mantêm a proporção display/h1/h2.
    'h1': (DilettaType.headlineLg, 32, 600, '30/800 → 32/600'),
    'body': (DilettaType.bodyMd, 14, 400, '15/500 → 14/400'),
    'bodySmall': (DilettaType.bodySm, 12, 400, '13/500 → 12/400'),

    // ── Dado técnico: os degraus que ESTE filho pediu, e que entraram ───────
    // O `mono` do produto nunca foi monoespaçado — era a fonte da marca com dígitos
    // tabulares, que é a resposta certa pra CPF, chave e valor. O pai só tinha o degrau de
    // 22; os de 13 e 11 entraram na v0.1.9 por este pedido mais o de outro filho.
    'mono': (DilettaType.numericSm, 13, 500, '13/400 → numericSm 13/500, tabular'),
    'monoCaption': (DilettaType.numericXs, 11, 500, '11/400 → numericXs 11/500, tabular'),
  };

  test('os 19 degraus escolhidos ainda valem o que eu medi', () {
    for (final (antigo, (estilo, tamanho, peso, nota)) in mapa.entries.map((e) => (e.key, e.value))) {
      expect(estilo.fontSize, tamanho,
          reason: 'o degrau escolhido pra "$antigo" mudou de tamanho no pai ($nota)');
      expect(estilo.fontWeight, FontWeight.values.firstWhere((w) => w.value == peso),
          reason: 'o degrau escolhido pra "$antigo" mudou de peso no pai ($nota)');
    }
  });

  test('dado técnico é TABULAR nos dois degraus, que é a razão deles existirem', () {
    // Sem figura tabular, numa lista o dígito de largura variável faz a coluna dançar entre
    // as linhas. Foi a medição que fez o pai criar os dois.
    for (final e in [DilettaType.numericSm, DilettaType.numericXs, DilettaType.numeric]) {
      expect(e.fontFeatures, contains(const FontFeature.tabularFigures()));
    }
  });

  test('nenhum degrau do mapa fixa família — a fonte vem do tema, uma vez', () {
    // É o desenho do pai, e é o que faz `BoldFonts.family` no `ThemeData` alcançar tudo. Um
    // preset com família fixa seria um lugar onde a Inter não chega — e foi exatamente esse o
    // defeito que o pai consertou na v0.5.0, num `DefaultTextStyle` substituído em vez de
    // mesclado.
    for (final e in mapa.values) {
      expect(e.$1.fontFamily, isNull,
          reason: 'degrau com família fixa: a fonte do produto não alcançaria');
    }
  });
}
