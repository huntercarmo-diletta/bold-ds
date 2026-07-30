import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O BARRIL ENTREGA TUDO QUE O FILHO PRECISA.
///
/// Um filho consome o pai por UM import. Se algo que ele precisa não está no barril, o único
/// caminho é `package:diletta_design_system/src/...` com `ignore: implementation_imports` —
/// e aí o filho passa a depender da árvore interna do pai, que é justamente o que o barril
/// existe pra evitar.
///
/// Isso aconteceu duas vezes, e as duas foram achadas por FILHO, não por teste:
///
/// - `DilettaAbsoluteColors` (o branco canônico) ficou fora quando os absolutos nasceram;
/// - a **suíte de conformidade** ficou fora desde sempre. Ela mora em `lib/` justamente pra o
///   filho poder chamá-la, e o segundo filho (o Bold) topou nisso na primeira hora de adoção.
///   O primeiro filho nunca percebeu porque tinha a conformidade dentro do próprio pacote.
///
/// Um pai cujo contrato só é verificado por quem adota tem um contrato que falha na frente do
/// cliente. Este teste move a verificação pra cá.
void main() {
  final barril = File('lib/diletta_design_system.dart');

  /// Arquivos que são INTERNOS de propósito. Cada um com a razão, porque lista de exceção sem
  /// motivo escrito vira lugar onde se esconde o próximo esquecimento.
  const internos = {
    // Os `*Consts` gerados são consumidos pelas classes públicas (`DilettaSpacing`,
    // `DilettaAbsoluteColors`…). Um filho usa a classe, nunca o const.
    'src/theme/generated/cps_absolute_tokens.g.dart',
    'src/theme/generated/cps_dimension_tokens.g.dart',
    'src/theme/generated/cps_duration_tokens.g.dart',
    'src/theme/generated/cps_elevation_tokens.g.dart',
    'src/theme/generated/cps_type_tokens.g.dart',
  };

  /// Alcance TRANSITIVO, não export direto. A primeira versão deste teste media export direto
  /// e acusou cinco arquivos que o filho alcança sem problema — eles são reexportados por
  /// outro arquivo do barril.
  ///
  /// A propriedade que importa é "o filho chega", não "o barril lista". Medir a errada teria me
  /// feito inflar o barril com cinco linhas que não resolvem nada.
  Set<String> alcancaveis() {
    final vistos = <String>{};
    final fila = <String>['diletta_design_system.dart'];
    while (fila.isNotEmpty) {
      final atual = fila.removeLast();
      final f = File('lib/$atual');
      if (!f.existsSync()) continue;
      final pasta = atual.contains('/')
          ? atual.substring(0, atual.lastIndexOf('/'))
          : '';
      // O regex aceita combinador (`show`/`hide`) depois da URI. A primeira versão exigia
      // `;` imediato e perdeu `export 'cpf_seguro_assets.dart' show DilettaAssets;` — ou seja,
      // acusou como inalcançável exatamente o que a Aurora compila sem esforço.
      for (final m in RegExp(r"export '([^':]+)'[^;]*;").allMatches(f.readAsStringSync())) {
        final bruto = m.group(1)!;
        // Resolve relativo à pasta de quem exporta.
        var alvo = pasta.isEmpty ? bruto : '$pasta/$bruto';
        while (alvo.contains('/../')) {
          final i = alvo.indexOf('/../');
          final antes = alvo.substring(0, i);
          alvo = antes.substring(0, antes.lastIndexOf('/') + 1) +
              alvo.substring(i + 4);
        }
        if (vistos.add(alvo)) fila.add(alvo);
      }
    }
    return vistos;
  }

  test('todo arquivo de lib/src chega ao filho, ou é interno declarado', () {
    final exportados = alcancaveis();

    final fora = <String>[];
    for (final f in Directory('lib/src').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      final rel = f.path.replaceFirst('lib/', '');
      if (exportados.contains(rel) || internos.contains(rel)) continue;
      fora.add(rel);
    }

    expect(fora, isEmpty,
        reason: 'estes arquivos não chegam ao filho pelo barril: $fora.\n\n'
            'Ou entram no barril, ou entram em `internos` COM a razão escrita. A terceira '
            'opção (deixar assim) obriga o filho a importar de `src/` e a depender da árvore '
            'interna deste pacote.');
  });

  test('a lista de internos não cresce sem explicação', () {
    // Cinco arquivos gerados, todos da mesma natureza. Se essa lista crescer, alguém está
    // tornando interno algo que o filho pode precisar — e a pergunta certa é por quê.
    expect(internos.length, lessThanOrEqualTo(6),
        reason: 'a lista de internos cresceu; cada item precisa da razão escrita ao lado');
    expect(internos.every((f) => f.contains('generated/')), isTrue,
        reason: 'entrou um interno que não é arquivo gerado — justifique no comentário');
  });
}
