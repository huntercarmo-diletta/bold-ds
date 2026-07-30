import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// O GATE DO DEFAULT SILENCIOSO — achado pela auditoria de arquitetura.
///
/// Quatro traduções de prop-enum aqui terminavam em `_ =>`, e a auditoria cobra a classe: **opção nova
/// se disfarça de opção antiga.** As opções são declaradas em `PropDef.options`, então valor fora do
/// mapa é erro de declaração — e este teste é o que prova que ele FALHA em vez de desenhar errado.
void main() {
  setUpAll(configurarDsDoBold);

  test('prop de enum com valor DESCONHECIDO estoura em debug', () {
    // Sem o `assert`, isto desenhava um botão primário e ninguém sabia que o tipo pedido não existe.
    final botao = Ds.blocos['botao']!;
    expect(
      () => botao.build({...botao.defaults(), 'tipo': 'nao-existe'}),
      throwsA(isA<AssertionError>()),
    );
  });

  test('e todo valor DECLARADO em options desenha', () {
    // O outro lado do gate: opção declarada e sem caso no mapa também é defeito, e este laço percorre
    // as declarações em vez de uma amostra.
    for (final def in Ds.blocos.values) {
      for (final entrada in def.props.entries) {
        final opcoes = entrada.value.options;
        if (opcoes == null || opcoes.isEmpty) continue;
        for (final opcao in opcoes) {
          expect(
            () => def.build({...def.defaults(), entrada.key: opcao}),
            returnsNormally,
            reason: 'o bloco "${def.type}" declara "${entrada.key}: $opcao" e não sabe desenhar',
          );
        }
      }
    }
  });
}
