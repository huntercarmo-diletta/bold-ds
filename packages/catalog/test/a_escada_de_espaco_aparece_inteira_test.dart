import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:diletta_catalog_core/ds.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ESCADA QUE O CATÁLOGO MOSTRA É A ESCADA QUE A LINGUAGEM PUBLICA.
///
/// A aba *Styles → espaço* desenha `Ds.spacingTokens`, e essa lista é declarada à mão aqui no
/// plugue. Enquanto ela teve nove entradas e a linguagem publicou onze, o catálogo escondeu os dois
/// meio-passos — e esconder degrau não é neutro: em 16/09 a designer foi ao catálogo conferir se
/// `2px` tinha token, não achou, e a conclusão correta a partir do que estava na tela era que **não
/// existia**. A partir daí o caminho natural é escrever o número à mão, que é exatamente o que o
/// catálogo existe para evitar.
///
/// Este teste não escolhe quais degraus existem — ele cobra que a lista **não deixe nenhum de fora**.
/// Degrau novo na linguagem entra aqui, ou este teste fecha.
void main() {
  setUpAll(configurarDsDoBold);

  // Toda constante de DilettaSpacing, com o nome que ela tem. Dart não enumera estático, então a
  // lista é escrita — e é ela que o teste protege: acrescentar degrau na linguagem sem acrescentar
  // aqui deixa o gate verde por omissão, então a linha de baixo é parte da régua, não decoração.
  const escadaDaLinguagem = <String, double>{
    's0_5': DilettaSpacing.s0_5,
    's1': DilettaSpacing.s1,
    's1_5': DilettaSpacing.s1_5,
    's2': DilettaSpacing.s2,
    's3': DilettaSpacing.s3,
    's4': DilettaSpacing.s4,
    's5': DilettaSpacing.s5,
    's6': DilettaSpacing.s6,
    's8': DilettaSpacing.s8,
    's10': DilettaSpacing.s10,
    's12': DilettaSpacing.s12,
  };

  test('o catálogo mostra todo degrau que a linguagem publica', () {
    final faltando = escadaDaLinguagem.keys.where((k) => !Ds.spacingTokens.containsKey(k)).toList();
    expect(faltando, isEmpty,
        reason: 'degraus que a linguagem tem e o catálogo esconde: $faltando');
  });

  test('e cada degrau mostrado vale o que a linguagem diz que ele vale', () {
    for (final e in Ds.spacingTokens.entries) {
      expect(escadaDaLinguagem[e.key], e.value,
          reason: '${e.key} no catálogo vale ${e.value}, na linguagem ${escadaDaLinguagem[e.key]}');
    }
  });

  test('os dois MEIO-PASSOS estão lá, que é o caso que faltava', () {
    // Prova por valor, e não por presença: se alguém devolver a chave apontando para outra coisa,
    // a presença sozinha aprovaria.
    expect(Ds.spacingTokens['s0_5'], 2);
    expect(Ds.spacingTokens['s1_5'], 6);
  });
}
