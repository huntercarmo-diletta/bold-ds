import 'dart:io';
import 'dart:ui' as ui;

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// **O ESCOLHIDO SE DIZ DE UM JEITO SÓ, e este arquivo é o que impede o segundo.**
///
/// Em 01/09 a varredura das telas achou cinco superfícies dizendo *"escolhido"* com **quatro
/// espessuras de borda** — 1,3 · 1,4 · 1,5 · 2 — e uma delas invertida: escolhido ficava mais FINO.
/// As cinco JÁ trocavam a cor junto, então a espessura não carregava informação; ela só variava.
///
/// Foi pedido ao dono em vez de consertado, porque trocar a affordance de seleção em cinco telas é
/// mudança que precisa de olho, e a régua desta casa é que **gate não vê forma**. O veredito veio em
/// 02/09: *"vamos manter tudo no DS"*.
///
/// Então: a espessura livre saiu, `selecionado` entrou, e a peça que já tinha respondido certo —
/// o `CoreflowCartaoDePedido` — parou de ter resposta própria e passou a usar a da casa.
///
/// O que este arquivo defende é a **unicidade**, não o valor: o dia em que alguém precisar de um
/// segundo jeito de dizer escolhido, o teste cai e a pergunta reaparece.
void main() {
  // Os DOIS fios deste pacote que não são de cartão, cada um com a razão escrita. A lista é curta
  // de propósito: entrada nova aqui é decisão, não conserto.
  const fiosComRazao = {
    'lib/src/bold_avatar.dart':
        'o anel do selo de 16px — fio de 1 num círculo desse tamanho é 12% do raio, e ele lê como '
            'disco cheio. A espessura acompanha a peça, não o estado dela.',
    'lib/src/bold_tema_material.dart':
        'o anel de FOCO do campo de texto, que é do tema Material e não de superfície. Foco é a '
            'única coisa neste produto que engrossa borda, e ela engrossa em UM valor.',
    'lib/src/bold_etiqueta.dart':
        'meio fio na pílula. A etiqueta é pequena e vive em fileira; fio inteiro em seis delas '
            'lado a lado vira grade, e a fileira lê como tabela em vez de conjunto.',
  };

  test('nenhuma peça deste pacote inventa espessura de borda', () {
    final achados = <String, String>{};
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      // O cartão é o dono das duas espessuras de SUPERFÍCIE: é lá que elas moram, por contrato.
      if (f.path.endsWith('bold_cartao.dart')) continue;
      final fonte = f.readAsStringSync();
      for (final m in RegExp(r'(Border\.all|BorderSide)\([^)]*width:\s*([0-9.]+)')
          .allMatches(fonte)) {
        if (double.parse(m.group(2)!) != 1) achados[f.path] = m.group(0)!;
      }
    }
    expect(achados.keys.toSet().difference(fiosComRazao.keys.toSet()), isEmpty,
        reason: 'fio com espessura própria e sem razão escrita. Se for superfície, o eixo é '
            '`CoreflowCartao(bordaReforcada:)`; se não for, declare aqui com o porquê.\n'
            '${achados.entries.map((e) => '${e.key}: ${e.value}').join('\n')}');
    // E a lista não pode envelhecer: razão escrita pra fio que já saiu é documentação mentindo.
    expect(fiosComRazao.keys.toSet().difference(achados.keys.toSet()), isEmpty,
        reason: 'declarado aqui e não existe mais no código');
  });

  test('o cartão só conhece DUAS espessuras, e a segunda é 1,5', () {
    final fonte = File('lib/src/bold_cartao.dart').readAsStringSync();
    expect(fonte, contains('bordaReforcada ? 1.5 : 1.0'));
    // O CONTROLE: se o eixo livre voltar, este teste é o que avisa.
    expect(fonte, isNot(contains('final double? larguraDaBorda')),
        reason: 'número livre foi o que deixou cinco telas inventarem quatro valores em quatro dias');
  });

  test('o SEGUNDO jeito de dizer escolhido é peça, e é uma só', () {
    // Ele existe porque `selecionado` não serve quando o miolo é o que se está escolhendo: um
    // retrato de fundo, uma foto de avatar. Tingir ali pinta por cima da escolha.
    //
    // Até 02/09 essa forma estava escrita DUAS vezes — dentro do `CoreflowAmostraDeFundo` e na tela
    // de preferências do Letti, uma com o token de transparente e a outra com `Colors.transparent`.
    // A varredura dos jeitos de dizer escolhido achou as duas cópias no mesmo dia.
    final anel = File('lib/src/bold_anel_de_escolha.dart').readAsStringSync();
    expect(anel, contains('static const double espessura = 2.5'),
        reason: 'o número mora numa constante nomeada, e não solto na decoração');
    final amostra = File('lib/src/bold_amostra_de_fundo.dart').readAsStringSync();
    expect(amostra, contains('CoreflowAnelDeEscolha'));
    expect(amostra, isNot(contains('width: 2.5')), reason: 'a cópia voltou');
    // E ele lê o esquema DESTE pacote. A peça que o hospeda lia o do pai, e no CLARO os dois
    // `primary` são rosas diferentes — 0,620/0,071 contra 0,996/0,224: o anel sairia de um rosa e o
    // visto dentro dele de outro. Só apareceu quando a forma virou peça e trouxe a fonte junto.
    expect(amostra, contains('CoreflowScheme.of(context)'));
  });

  test('o cartão de pedido não tem mais resposta PRÓPRIA pra escolhido', () {
    final fonte = File('lib/src/bold_cartao_de_pedido.dart').readAsStringSync();
    expect(fonte, contains('selecionado: selecionada'));
    expect(fonte, isNot(contains('selecionada ? s.primary : s.border')),
        reason: 'era a resposta certa escrita no lugar errado — duas peças respondendo a mesma '
            'pergunta é o defeito que este veredito fechou');
  });

  testWidgets('escolhido MUDA O FUNDO, e não só o fio — medido em pixel', (t) async {
    // Por que pixel: o fio de 1 lógico é ~0,3% da área do cartão. Um gate que só lesse o `border`
    // passaria com a seleção invisível a um braço de distância, que é exatamente o que as cinco
    // telas estavam compensando quando engrossaram a borda.
    Future<ui.Image> tira(bool escolhido) async {
      final chave = Key('$escolhido');
      await t.pumpWidget(MaterialApp(
        theme: CoreflowTemaMaterial.escuro,
        home: RepaintBoundary(
          key: chave,
          child: Center(
            child: SizedBox(
              width: 200,
              height: 80,
              child: CoreflowCartao(selecionado: escolhido, child: const SizedBox.expand()),
            ),
          ),
        ),
      ));
      await t.pumpAndSettle();
      late ui.Image img;
      await t.runAsync(() async {
        img = await t.renderObject<RenderRepaintBoundary>(find.byKey(chave)).toImage();
      });
      return img;
    }

    Future<List<int>> miolo(ui.Image img) async {
      late List<int> px;
      await t.runAsync(() async {
        final d = (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
        final i = ((img.height ~/ 2) * img.width + img.width ~/ 2) * 4;
        px = [d[i], d[i + 1], d[i + 2]];
      });
      return px;
    }

    final normal = await miolo(await tira(false));
    final escolhido = await miolo(await tira(true));

    expect(escolhido, isNot(normal), reason: 'o MIOLO do cartão tem que mudar, não só a moldura');
    // E muda pra MARCA: mais vermelho que verde, que é o que o rosa deste produto é.
    expect(escolhido[0] - escolhido[1], greaterThan(normal[0] - normal[1] + 8),
        reason: 'escolhido tinge de marca; se o miolo só clareia, é degrau de superfície e não '
            'escolha — e um filho verde leria isso errado. normal=$normal escolhido=$escolhido');
  });
}
