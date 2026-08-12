import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O EXPERIMENTO que o pai pediu antes de eu abrir o pedido do `avatarHeroTag`.
///
/// > *"O que eu vou querer no «Já tentei» é **por que envolver o avatar num `Hero` por fora não
/// > serve**, porque a resposta óbvia é que serve e eu não sei por que não."*
///
/// Este arquivo é a resposta, e ela é medida e não argumentada.
void main() {
  testWidgets('envolver o CABEÇALHO num Hero faz voar o cabeçalho, não o avatar',
      (t) async {
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: Scaffold(
          body: Hero(
            tag: 'avatar',
            child: BoldCabecalhoDaHome(
                nome: 'Ranter', conta: 'Minha conta', aoAbrirPerfil: () {}),
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    // O que a origem do voo mede é o TAMANHO do que vai voar. Envolvendo por fora, o `Hero` é a
    // casca inteira — status bar, botão de conta, ícones e a segunda linha.
    final voando = t.getSize(find.byType(Hero));
    final avatar = t.getSize(find.byType(DilettaAvatar));

    expect(avatar.width, 48, reason: 'o que DEVERIA voar é o círculo de 48');
    expect(voando.height, greaterThan(100),
        reason: 'o que VAI voar é a casca inteira. Um Hero por fora não '
            'consegue apontar pra dentro da peça: o avatar é filho de um widget '
            'PRIVADO (`_AvatarComSaudacao`), e Hero casa por posição na árvore, '
            'não por seletor');
    expect(voando.width, greaterThan(300),
        reason: 'e ele voa com a largura da tela, não com a do avatar');
  });
}
