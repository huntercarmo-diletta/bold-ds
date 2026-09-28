import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// O selo ganhou o desfecho de quem **não teve resposta**.
///
/// O app pintava o X vermelho quando o watchdog estourava — ou seja, dizia
/// "negado" sobre dinheiro que podia ter saído. Alguém leu isso como "não foi",
/// repetiu o Pix, e o push da primeira transferência chegou depois.
///
/// Aqui o gate é de VOCABULÁRIO: o estado existe, é distinto, e o switch que o
/// resolve é exaustivo.
void main() {
  test('os quatro estados existem e são distintos', () {
    expect(BoldSeloEstado.values, hasLength(4));
    expect(BoldSeloEstado.values, contains(BoldSeloEstado.semResposta));
    expect(BoldSeloEstado.semResposta, isNot(BoldSeloEstado.negado));
    expect(BoldSeloEstado.semResposta, isNot(BoldSeloEstado.autorizado));
  });

  test('o rótulo padrão não afirma desfecho', () {
    const selo = BoldSeloQuantico(estado: BoldSeloEstado.semResposta);
    expect(selo.rotuloSemResposta, 'Sem confirmação');
    // Nem "negada", nem "autorizada": as duas são afirmações.
    expect(selo.rotuloSemResposta.toLowerCase(), isNot(contains('negad')));
    expect(selo.rotuloSemResposta.toLowerCase(), isNot(contains('autoriz')));
  });

  test('o contrato declara a regra do desfecho sem resposta', () {
    // O spec é servido ao catálogo; se a regra sair dele, sai da documentação
    // que o time lê antes de usar a peça.
    expect(kSeloQuanticoSpec, contains('semResposta'));
    expect(kSeloQuanticoSpec, contains('SHALL NOT tremer'));
    expect(kSeloQuanticoSpec, contains('SHALL NOT\nconvidar a repetir'));
  });
}
