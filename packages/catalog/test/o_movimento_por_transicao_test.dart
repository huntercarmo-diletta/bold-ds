import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// O MOVIMENTO POR TRANSIÇÃO — o gancho que a vista de Gramática (v0.64.0) mostrou vazio.
///
/// Eu já declarava quatro tokens de movimento em `estilos.movimentos`, e isso é INVENTÁRIO: o que existe.
/// `motionDaTransicao` é outra pergunta — **qual movimento é qual transição** —, e eu tinha só a primeira.
/// Oito tipos de conexão, oito "não declarado", e nada falhava: o board mostraria a prévia com o
/// `MotionDaTransicao()` padrão, que é um movimento que este produto não tem.
///
/// O gate mede as duas metades, porque cada uma sozinha passa com o defeito de pé:
///
/// 1. o que eu declaro bate com o token do meu inventário — número inventado aqui viraria prévia mentindo;
/// 2. o que eu NÃO declaro continua NÃO declarado — se um dia virar "tudo declarado por acidente" (um
///    `_ =>` com valor), a vista para de acender no tipo novo e a falta desaparece da página.
void main() {
  test('as três transições declaradas usam o token do MEU inventário', () {
    final inventario = Ds.estilos.movimentos;

    for (final (tipo, token, duracao) in [
      (TipoConexao.push, 'DilettaMotion.slow', DilettaMotion.slow),
      (TipoConexao.volta, 'DilettaMotion.slow', DilettaMotion.slow),
      (TipoConexao.sheet, 'DilettaMotion.medium', DilettaMotion.medium),
    ]) {
      final m = Ds.motionDaTransicao(tipo);
      expect(m.token, token, reason: '$tipo mudou de token');
      expect(m.duracao, duracao, reason: '$tipo tem duração que não é a do token');

      // E o token existe no inventário que a página de Styles desenha: os dois lados leem a mesma escala,
      // então uma duração aqui que não está lá seria número solto.
      expect(inventario.values.any((i) => i.token == token), isTrue,
          reason: 'o token $token não está em `estilos.movimentos`');
    }
  });

  test('os movimentos SEM declaração são exatamente estes cinco, por NOME', () {
    // Este teste tinha o defeito da ocorrência 9 do ledger do pai, e foi ele que achou: a asserção era
    // `expect(semDeclaracao, TipoConexao.values.length - 3)`.
    //
    // O que ela pegava: eu declarar um quarto movimento sem passar por aqui. Certo.
    // O que ela NÃO pegava: **o pai acrescentar um `TipoConexao`.** Os dois lados subiam juntos, o teste
    // ficava verde, e o nome dele passava a mentir — "os CINCO" com seis sem declaração. Não é hipótese: ele
    // mexeu no `TipoConexao` duas vezes nesta semana (`chatCpf` → `chatAssistente` na v0.63.0).
    //
    // > **O número que o teste promete no nome tem que estar na asserção.**
    //
    // Afirmar os nomes resolve as duas direções, e movimento novo do pai cai aqui com o nome dele no diff —
    // o que me obriga a decidir se aquele movimento é deste produto, em vez de sumir na conta.
    final semDeclaracao = {
      for (final t in TipoConexao.values)
        if (Ds.motionDaTransicao(t).token.isEmpty) t.name,
    };

    expect(semDeclaracao, {'estado', 'aposEspera', 'chatAssistente', 'chatUsuario', 'chatAcao'},
        reason: 'movimento novo do pai entra aqui e me obriga a decidir. Se um destes cinco saiu da lista, '
            'foi porque eu declarei — e aí o nome deste teste muda junto');
  });
}
