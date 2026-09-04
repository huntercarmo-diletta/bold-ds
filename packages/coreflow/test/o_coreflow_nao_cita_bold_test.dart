import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O COREFLOW NÃO CITA O BOLD — o gate de nascimento do pai.
///
/// A régua é a de `packages/coreflow_design_system/tool/levanta_a_separacao.sh`, escrita aqui
/// letra por letra: o filho mede com ela quanto ainda falta separar (300 em 04/09), e o pai mede
/// com a MESMA régua que nada do que falta veio parar aqui. Duas réguas distintas dariam um
/// número que não fecha com o outro.
///
/// Comentário e doc NÃO são isentos, de propósito. O gate do filho (`o_pacote_nao_crava_a_paleta`)
/// isenta prosa porque lá contar a história do Bold é o ponto; aqui a história do Bold não é do
/// pai — um componente que chega explicando "no Conta BOLD isto era rosa" trouxe o produto junto.
void main() {
  // A mesma `P=` do script. Se o script mudar, este literal muda no mesmo commit.
  final regua = RegExp(
    r'BoldColors|BoldPalette|BoldSeloQuantico|BoldSeloEstado|BoldFonts|BoldVinho|marcaDoBold|'
    r'CoreflowProduto\.bold\b|Conta BOLD|hexesDaArte|assets/logos',
  );

  // Mais larga que a régua: QUALQUER símbolo `Bold` com inicial maiúscula. Fecha a classe "a regex
  // deixou passar um nome novo" — `FontWeight.bold` é minúsculo e não casa.
  final qualquerBold = RegExp(r'\bBold[A-Z]\w*');

  List<String> varre(RegExp r) {
    final achados = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      final linhas = f.readAsLinesSync();
      for (var i = 0; i < linhas.length; i++) {
        for (final m in r.allMatches(linhas[i])) {
          achados.add('${f.path}:${i + 1}  ${m.group(0)}');
        }
      }
    }
    return achados;
  }

  test('a régua da separação dá zero em lib/ — comentário incluído', () {
    final achados = varre(regua);
    expect(achados, isEmpty,
        reason: 'o pai citou o filho (${achados.length}):\n${achados.join("\n")}');
  });

  test('e nenhum símbolo Bold* de nome novo entrou pela lateral', () {
    final achados = varre(qualquerBold);
    expect(achados, isEmpty, reason: 'símbolo Bold* em lib/ do pai:\n${achados.join("\n")}');
  });

  test('e a régua SABE ver o que procura', () {
    // Controle: asserção de ausência passa sozinha quando a busca está errada.
    for (final l in const [
      '      color: BoldPalette.bold.primary04,',
      "  /// No Conta BOLD isto era rosa.",
      '  static final bold = CoreflowProduto.bold;',
      "  'assets/logos/conta-bold-lockup.svg',",
      '      vinhoTinta: BoldVinho.tintaDe(paleta),',
    ]) {
      expect(regua.hasMatch(l), isTrue, reason: 'a régua não casa com: $l');
    }
    expect(regua.hasMatch('FontWeight.bold'), isFalse);
    // O campo do esquema que o app lê não é referência ao Bold — é a API que o pai carrega.
    expect(regua.hasMatch('    final c = CoreflowScheme.of(context).vinhoTinta;'), isFalse);
    expect(qualquerBold.hasMatch('FontWeight.bold'), isFalse);
    expect(qualquerBold.hasMatch('BoldNomeNovo.x'), isTrue);
  });
}
