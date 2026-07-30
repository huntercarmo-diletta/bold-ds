import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Todo asset PRÓPRIO do DS tem que ser carregado com `package:`.
///
/// Bug real: `DilettaLogo` fazia `SvgPicture.asset('assets/logos/logo.svg')`
/// sem `package:`. Isso funcionava enquanto o DS era o package raiz do catálogo;
/// quando ele virou package consumido, a chave passou a ser
/// `packages/cpf_seguro_design_system/...` e o logo sumiu das telas. No app real
/// estava quebrado desde antes, silenciosamente.
///
/// Este teste é de FONTE, não de render: varre os widgets do DS procurando
/// chamada de asset sem `package:`. Teste de render pegaria um caso; isto pega a
/// classe.
void main() {
  /// Chamadas onde o caminho vem de FORA (o consumidor passa o asset dele), e
  /// portanto NÃO devem levar o package do DS.
  const consumidorPassaOCaminho = {
    'cpf_seguro_wallet_card.dart': ['partnerLogo', 'networkLogo'],
  };

  test('asset próprio do DS é carregado com package:', () {
    final suspeitos = <String>[];
    final chamada = RegExp(r'(SvgPicture\.asset|Image\.asset|AssetImage)\(');

    for (final f in Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      // Comentário fora: a PRÓPRIA explicação de "usa package:" satisfazia a
      // busca e o teste passava sem o argumento. Primeira versão era vazia.
      final src = f
          .readAsStringSync()
          .split('\n')
          .where((l) => !l.trimLeft().startsWith('//'))
          .join('\n');
      for (final m in chamada.allMatches(src)) {
        // Pega o argumento e o resto da chamada (até 400 chars) pra checar se
        // `package:` aparece antes de fechar.
        final trecho = src.substring(
            m.start, (m.start + 400).clamp(0, src.length));
        final nome = f.uri.pathSegments.last;
        final isentos = consumidorPassaOCaminho[nome] ?? const [];
        if (isentos.any(trecho.contains)) continue;
        // `package:` como ARGUMENTO, não como string de import
        // ('package:flutter/...') nem como texto solto.
        final temArg = RegExp(r"(?<!')package:\s*[A-Za-z]").hasMatch(trecho);
        if (!temArg) {
          final linha = src.substring(0, m.start).split('\n').length;
          suspeitos.add('$nome:$linha — ${m.group(1)} sem package:');
        }
      }
    }

    expect(suspeitos, isEmpty,
        reason: 'asset do DS carregado sem `package:` — invisível no app '
            'consumidor:\n${suspeitos.join('\n')}');
  });
}
