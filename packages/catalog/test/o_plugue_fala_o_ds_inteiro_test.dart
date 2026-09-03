import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// **O PLUGUE FALA O DS INTEIRO — o gate que impede ele de ficar pra trás de novo.**
///
/// Em 03/09 o DS tinha **62 widgets** e o plugue declarava **23**. Trinta e nove peças existiam no
/// design system e não no catálogo: quem compunha uma tela não tinha como pedir um cartão, uma
/// etiqueta ou o pegador de uma folha sem sair dele — e as que existiam emitiam a peça do PAI onde o
/// app escreve a deste produto.
///
/// O buraco não apareceu de uma vez: ele cresceu peça a peça, cada uma com uma razão boa pra ficar
/// pra depois. É exatamente o tipo de dívida que precisa de régua, porque nada falha enquanto ela
/// existe — o catálogo continua desenhando, só que menos do que o produto tem.
///
/// **O que este gate mede é a DISTÂNCIA entre os dois, não um número.** Peça nova no DS que não
/// chega ao plugue acende aqui, e a resposta é uma das duas: declarar o bloco, ou declarar aqui por
/// que ela não é bloco — com o porquê escrito.
void main() {
  /// As que NÃO viram bloco, e o motivo de cada uma.
  const foraDoPlugue = <String, String>{
    'CoreflowBusyScope': 'é `InheritedWidget`: publica o estado de espera pra subárvore e não '
        'desenha nada. Bloco é coisa que se põe numa tela e se vê.',
    'CoreflowOperatingContext': 'idem — publica a conta operada. Quem DESENHA é a '
        '`CoreflowOperatingStrip` (bloco `faixaDeOperacao`) e o `CoreflowOperatingSlot` '
        '(bloco `encaixeDeOperacao`), e os dois estão no plugue.',
  };

  test('todo widget do DS está no plugue, ou tem razão escrita pra não estar', () {
    final dir = Directory('../coreflow_design_system/lib/src');
    expect(dir.existsSync(), isTrue, reason: 'não achei o DS ao lado: ${dir.path}');

    final widgets = <String>{};
    for (final f in dir.listSync().whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      for (final m in RegExp(
              r'^class (Coreflow[A-Za-z0-9]+)\s+extends\s+(?:StatelessWidget|StatefulWidget|InheritedWidget)',
              multiLine: true)
          .allMatches(f.readAsStringSync())) {
        widgets.add(m.group(1)!);
      }
    }
    expect(widgets.length, greaterThan(40),
        reason: 'a varredura achou ${widgets.length} widgets no DS — ou o caminho mudou, ou esta '
            'régua está medindo o vazio');

    final plugue = File('lib/ds_do_bold.dart').readAsStringSync();
    final ausentes = widgets
        .where((n) => !RegExp('\\b$n\\b').hasMatch(plugue))
        .toSet();

    expect(ausentes.difference(foraDoPlugue.keys.toSet()), isEmpty,
        reason: 'peça do DS que o catálogo não sabe falar. Declare o bloco, ou declare aqui por que '
            'ela não é bloco:\n${ausentes.difference(foraDoPlugue.keys.toSet()).join('\n')}');

    // A outra ponta: razão escrita pra peça que já entrou é documentação mentindo.
    expect(foraDoPlugue.keys.toSet().difference(ausentes), isEmpty,
        reason: 'declarado como fora do plugue e já está dentro — apague estas linhas');
  });

  test('e o gate SABE ver — um nome inventado seria acusado', () {
    // Sem isto, um `hasMatch` que sempre casasse deixaria o teste acima verde pra sempre.
    final plugue = File('lib/ds_do_bold.dart').readAsStringSync();
    expect(RegExp(r'\bCoreflowPecaQueNaoExiste\b').hasMatch(plugue), isFalse);
    expect(RegExp(r'\bCoreflowBotao\b').hasMatch(plugue), isTrue,
        reason: 'o botão está no plugue desde 03/09; se isto falhar, a varredura não vê nada');
  });
}
