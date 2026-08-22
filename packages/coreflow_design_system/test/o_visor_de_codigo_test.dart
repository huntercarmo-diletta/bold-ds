import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O VISOR DE CÓDIGO — o diferencial deste filho, e o que dele é DS.
///
/// A tela de scanner tem 603 linhas e depende de câmera, permissão, rota e estado. Nada disso está
/// aqui: o visor é `CustomPainter` puro, e é por isso que ele tem teste — desenho sem dependência
/// se mede, tela com câmera não.
void main() {
  Widget montar(Widget filho, {bool escuro = true}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          child: Scaffold(body: SizedBox(width: 300, height: 500, child: filho)),
        ),
      );

  CoreflowAlvo alvo(CoreflowAlvoEstado estado, {String? rotulo, bool centralizado = false}) =>
      CoreflowAlvo(
        area: const Rect.fromLTWH(100, 200, 120, 120),
        estado: estado,
        rotulo: rotulo,
        centralizado: centralizado,
        codigo: 'codigo-$estado',
      );

  testWidgets('os TRÊS estados desenham, nos dois modos e em várias fases', (t) async {
    for (final escuro in [false, true]) {
      for (final estado in CoreflowAlvoEstado.values) {
        for (final fase in [0.0, 0.5, 1.0]) {
          await t.pumpWidget(montar(
            CoreflowVisorDeCodigo(
              alvos: [alvo(estado, rotulo: 'CÓDIGO DETECTADO')],
              fase: fase,
              tamanhoDaImagem: const Size(400, 800),
            ),
            escuro: escuro,
          ));
          await t.pump(const Duration(milliseconds: 30));
          expect(t.takeException(), isNull,
              reason: 'estado ${estado.name}, fase $fase, '
                  'modo ${escuro ? "escuro" : "claro"}');
        }
      }
    }
  });

  testWidgets('sem tamanho de imagem, cai no retículo CENTRAL em vez de desenhar errado', (t) async {
    // Sem cantos confiáveis, o visor não tem como mapear a área. Desenhar no lugar errado seria
    // pior que desenhar no centro: a pessoa aponta o celular pro nada.
    await t.pumpWidget(montar(CoreflowVisorDeCodigo(
      alvos: [alvo(CoreflowAlvoEstado.analisando, centralizado: true)],
      fase: 0.3,
    )));
    await t.pump(const Duration(milliseconds: 30));
    expect(t.takeException(), isNull);
  });

  testWidgets('rótulo longo não estoura a tela — ele quebra e clampa', (t) async {
    // Rótulo é mensagem de erro em alguns casos, e erro é longo. O clamp nos quatro lados existe
    // pra o texto ficar 100% visível.
    await t.pumpWidget(montar(CoreflowVisorDeCodigo(
      alvos: [
        alvo(CoreflowAlvoEstado.irrelevante,
            rotulo: 'ESTE CÓDIGO NÃO É DE UM BOLETO NEM DE UMA CHAVE PIX '
                'VÁLIDA, TENTE OUTRO OU DIGITE OS NÚMEROS'),
      ],
      fase: 0.7,
      tamanhoDaImagem: const Size(400, 800),
    )));
    await t.pump(const Duration(milliseconds: 30));
    expect(t.takeException(), isNull);
  });

  testWidgets('fantasma com tempo fora da janela não desenha, e não quebra', (t) async {
    await t.pumpWidget(montar(CoreflowVisorDeCodigo(
      alvos: const [],
      fase: 0.2,
      fantasmas: [
        // Um no meio da animação, um vencido, e um do futuro.
        CoreflowAlvoFantasma(
            cx: 0.5, cy: 0.4, largura: 0.3, altura: 0.3, inicio: DateTime.now()),
        CoreflowAlvoFantasma(
            cx: 0.2,
            cy: 0.2,
            largura: 0.2,
            altura: 0.2,
            inicio: DateTime.now().subtract(const Duration(seconds: 5))),
        CoreflowAlvoFantasma(
            cx: 0.8,
            cy: 0.8,
            largura: 0.2,
            altura: 0.2,
            inicio: DateTime.now().add(const Duration(seconds: 5))),
      ],
    )));
    await t.pump(const Duration(milliseconds: 30));
    expect(t.takeException(), isNull);
  });

  test('a cor do estado sai da PALETA, não de literal', () {
    // Eram quatro literais: âmbar #FFB300, verde neon #39FF14, vermelho #FF3B30 e o amarelo do
    // fantasma. O verde neon virar `success05` é a mudança que se vê, e está registrada no
    // componente — era estética de "visão de máquina", e a alternativa seria um quinto valor de
    // marca fora da rampa.
    const foraDaRampa = [0xFFFFB300, 0xFF39FF14, 0xFFFF3B30, 0xFFFFF3B0];
    final daPaleta = [
      BoldPalette.bold.warning04.toARGB32(),
      BoldPalette.bold.success05.toARGB32(),
      BoldPalette.bold.error05.toARGB32(),
      BoldPalette.bold.warning06.toARGB32(),
    ];
    for (final antigo in foraDaRampa) {
      expect(daPaleta, isNot(contains(antigo)),
          reason: 'um literal antigo voltou a ser igual a um degrau — confira se não foi por '
              'alguém trazer o valor de volta pra paleta');
    }
  });

  test('os FORMATOS que este produto lê estão declarados, com o boleto explícito', () {
    // A peça de conhecimento mais fácil de perder, e a que já custou bug de QA: o default da
    // plataforma não habilita os formatos 1D, e o boleto brasileiro é ITF de 44 dígitos.
    expect(CoreflowFormatosDeCodigo.todos, contains('qrCode'));
    expect(CoreflowFormatosDeCodigo.boleto, contains('itf2of5'),
        reason: 'sem ITF, boleto de 44 dígitos não é reconhecido — foi bug de QA');
    expect(CoreflowFormatosDeCodigo.todos.length, 7);
    // Sem duplicata: lista com nome repetido é lista que alguém editou duas vezes.
    expect(CoreflowFormatosDeCodigo.todos.toSet().length,
        CoreflowFormatosDeCodigo.todos.length);
  });
}
