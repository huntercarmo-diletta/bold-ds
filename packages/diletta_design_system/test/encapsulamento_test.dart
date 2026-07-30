import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// COMPONENTE ENCAPSULADO É UM LUGAR PRA CONSERTAR, NÃO DEZ.
///
/// Este gate não é sobre estilo. Ele mede uma perda CONCRETA: o DS instrumenta os
/// próprios primitivos, e construção crua do Flutter fica fora da instrumentação.
///
/// - **`DilettaText`** envolve cada texto num `DilettaDevInfo` que publica o
///   preset de tipografia, o tamanho, o peso e **o token de cor**. `Text` cru não
///   publica nada. Consequência real: o dev mode não mostra aquele texto, e a
///   medição de dark do catálogo é cega a ele — foi exatamente por isso que ela
///   precisou do canal do `DevInfo` pra ver ícone.
/// - **`DilettaGap`** publica o valor do espaço no dev mode. `SizedBox(height: 8)`
///   é um número mágico: não é token, não aparece, e ninguém sabe de onde veio.
///
/// Ou seja: cada construção crua é um pedaço do DS que a ferramenta não consegue
/// explicar. E é o oposto do que um design system existe pra fazer.
///
/// A dívida está medida e travada por baseline, igual às primitivas de cor. Só cai.
void main() {
  /// Dívida de encapsulamento por arquivo, medida em 2026-07-28.
  ///
  /// Mapa `arquivo → (textoCru, espacoCru)`.
  const baseline = <String, (int, int)>{};

  /// Total medido em 2026-07-28. É o número que interessa e ele está escrito aqui
  /// pra o progresso aparecer no diff do teste, não numa soma que ninguém faz.
  const totalInicialTexto = 160;
  const totalInicialEspaco = 163;

  (int, int) medirArquivo(String fonte) {
    // `Text(` cru — não conta `DilettaText(`, nem `RichText`, nem `Text.rich`
    // dentro do próprio wrapper.
    final texto = RegExp(r'(?<![a-zA-Z])Text\(').allMatches(fonte).length -
        RegExp(r'RichText\(').allMatches(fonte).length;
    // `SizedBox` usado como ESPAÇO: só uma dimensão, valor literal.
    final espaco = RegExp(r'SizedBox\((height|width): [\d.]+\)')
        .allMatches(fonte)
        .length;
    return (texto < 0 ? 0 : texto, espaco);
  }

  Map<String, (int, int)> medir() {
    final out = <String, (int, int)>{};
    for (final f in Directory('lib/src/widgets').listSync()) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      // Os próprios wrappers são a exceção óbvia: é o trabalho deles.
      final nome = f.uri.pathSegments.last;
      if (nome == 'cpf_seguro_text.dart' || nome == 'cpf_seguro_gap.dart') continue;
      final m = medirArquivo(f.readAsStringSync());
      if (m.$1 > 0 || m.$2 > 0) out[nome] = m;
    }
    return out;
  }

  test('o total de construção CRUA não cresce', () {
    final atual = medir();
    final texto = atual.values.fold<int>(0, (a, b) => a + b.$1);
    final espaco = atual.values.fold<int>(0, (a, b) => a + b.$2);
    expect(texto, lessThanOrEqualTo(totalInicialTexto),
        reason: 'texto cru: $texto (medição inicial $totalInicialTexto). '
            '`Text` cru fica fora do `DilettaDevInfo`: o dev mode não o mostra e '
            'a medição de tema do catálogo não o vê.');
    expect(espaco, lessThanOrEqualTo(totalInicialEspaco),
        reason: 'espaço cru: $espaco (medição inicial $totalInicialEspaco). '
            '`SizedBox(height: N)` é número mágico — não é token e não aparece no '
            'dev mode.');
  });

  test('a baseline por arquivo, quando existir, é exata', () {
    // Começa vazia de propósito: o número global é o que importa primeiro. Quando
    // alguém for atacar arquivo por arquivo, esta lista passa a valer — e o mesmo
    // rigor das primitivas se aplica (baseline que não encolhe vira desculpa).
    if (baseline.isEmpty) return;
    final atual = medir();
    for (final e in baseline.entries) {
      expect(atual[e.key] ?? (0, 0), e.value, reason: e.key);
    }
  });
}
