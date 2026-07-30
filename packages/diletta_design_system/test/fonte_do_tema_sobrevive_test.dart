import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A FONTE DO TEMA TEM QUE SOBREVIVER A QUALQUER COMPONENTE DO PAI.
///
/// Nasceu de um defeito medido pelo primeiro filho: a bolha de chat trocava o `DefaultTextStyle`
/// inteiro, e como os `TextStyle` de `DilettaType` **não fixam família de propósito** (a fonte vem
/// do tema do app, uma vez), a família morria dentro da bolha. Todo texto de chat saía na fonte do
/// sistema — 57 bolhas em 16 telas dele.
///
/// Por que o gate é aqui e não no filho, que foi o argumento do pedido e está certo: quem apaga a
/// herança é o componente do PAI, e a regra vale pra qualquer componente que mexa em
/// `DefaultTextStyle`. Medido: hoje é o único do pacote — e é justamente por ser único que ninguém
/// olhava.
///
/// O modo de falha é o pior que existe: no navegador a fonte de sistema é parecida o bastante pra
/// ninguém apontar. Ele apareceu num print de teste, onde não há fonte de sistema e o texto virou
/// caixa preta.
void main() {
  const familiaDoApp = 'FonteDoApp';

  /// O estilo EFETIVO de um texto: o herdado, mesclado com o que o widget declara. É como o
  /// framework resolve de verdade — medir só o `style` do `Text` não veria a herança.
  TextStyle efetivo(WidgetTester t, String texto) {
    final elemento = t.element(find.text(texto));
    final widget = elemento.widget as Text;
    return DefaultTextStyle.of(elemento).style.merge(widget.style);
  }

  testWidgets('a família do tema sobrevive dentro da bolha de chat', (t) async {
    await t.pumpWidget(MaterialApp(
      theme: ThemeData(fontFamily: familiaDoApp),
      home: DilettaThemeScope(
        theme: DilettaTheme.referenciaLight,
        child: const Scaffold(
          body: Column(
            children: [
              DilettaChatBubble(
                from: DilettaChatFrom.bot,
                child: Text('dentro'),
              ),
              Text('fora'),
            ],
          ),
        ),
      ),
    ));

    expect(efetivo(t, 'fora').fontFamily, familiaDoApp);
    expect(efetivo(t, 'dentro').fontFamily, familiaDoApp,
        reason: 'a bolha apagou a família do tema — algum componente do pai está SUBSTITUINDO o '
            'DefaultTextStyle em vez de mesclar');

    // E o que a bolha DEVE decidir continua decidido por ela: o degrau de chat, não o do corpo.
    expect(efetivo(t, 'dentro').fontSize, DilettaType.chatBody.fontSize);
    expect(efetivo(t, 'dentro').fontSize, isNot(efetivo(t, 'fora').fontSize));
  });
}
