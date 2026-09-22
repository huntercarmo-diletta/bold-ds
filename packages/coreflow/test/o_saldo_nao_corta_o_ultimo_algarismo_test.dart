import 'package:coreflow/coreflow.dart';
import 'package:flutter_test/flutter_test.dart';

/// O saldo mostrava `R$ 913,2` onde o valor era R$ 913,25.
///
/// A peça mede o texto e dá à caixa exatamente a largura medida. A medição é
/// FRACIONÁRIA, e uma caixa com a largura exata do texto corta o glifo final na
/// hora de pintar — com `maxLines: 1` e clip não há para onde sobrar.
///
/// Não é arredondamento de valor: é um algarismo faltando num número que a
/// pessoa confere antes de mandar dinheiro. Reportado pelo app (item #157 do
/// portal de feedback), medido no print: a linha do dia dizia 913,25 e o
/// destaque dizia 913,2.
void main() {
  group('larguraDaCaixaDoSaldo', () {
    test('arredonda PARA CIMA — o lado seguro do erro', () {
      expect(larguraDaCaixaDoSaldo(96.4), 97);
      expect(larguraDaCaixaDoSaldo(0.1), 1);
      expect(larguraDaCaixaDoSaldo(249.99), 250);
    });

    test('medida inteira não cresce', () {
      expect(larguraDaCaixaDoSaldo(120), 120);
      expect(larguraDaCaixaDoSaldo(0), 0);
    });

    test('nunca devolve menos que a medida', () {
      for (final m in [0.0, 1.2, 33.9, 96.4, 120.0, 250.5, 1000.01]) {
        expect(larguraDaCaixaDoSaldo(m), greaterThanOrEqualTo(m),
            reason: 'faltar largura é o defeito; sobrar sub-pixel é invisível');
      }
    });
  });
}
