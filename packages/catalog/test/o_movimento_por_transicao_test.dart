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

  test('os CINCO que eu não medi seguem sem declaração, e isso é a informação', () {
    // `estado`, `apósEspera` e os três de chat: este produto não tem fluxo de chat e eu não medi qual token
    // move troca de estado. A vista acende em vermelho quando a primeira seta desses tipos existir — e é
    // esse vermelho que eu quero, em vez de um número que ninguém verificou.
    final semDeclaracao = TipoConexao.values
        .where((t) => Ds.motionDaTransicao(t).token.isEmpty)
        .length;

    expect(semDeclaracao, TipoConexao.values.length - 3,
        reason: 'ou entrou declaração nova sem gate, ou um `_ =>` com valor apagou a falta');
  });
}
