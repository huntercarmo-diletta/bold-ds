import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// AS SEIS PEÇAS QUE ATRAVESSARAM A FRONTEIRA — as quatro lacunas e as duas exiladas.
///
/// Elas entraram no pacote de uma vez porque o pedido era um só: quatro telas de loja em alta
/// fidelidade no catálogo, e as quatro paravam em peças que só existiam dentro do aparelho.
///
/// O que este arquivo mede não é "renderiza". É o que cada uma tem de próprio e que se perde numa
/// mudança de casa distraída — a regra do divisor, o alvo de toque de 44, a inversão do chip, o
/// desconto do porte.
void main() {
  Widget montar(Widget filho, {bool escuro = false}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          child: Scaffold(body: Center(child: filho)),
        ),
      );

  group('o ladrilho de menu', () {
    testWidgets('cada porte tem a sua altura, e elas não são a mesma', (t) async {
      final alturas = <CoreflowPorteDoLadrilho, double>{};
      for (final porte in CoreflowPorteDoLadrilho.values) {
        await t.pumpWidget(montar(SizedBox(
          width: 200,
          child: CoreflowLadrilhoDeMenu(
              icone: DilettaIcons.pixLight,
              rotulo: 'Área Pix',
              porte: porte,
              aoTocar: () {}),
        )));
        await t.pump(const Duration(milliseconds: 50));
        alturas[porte] = t.getSize(find.byType(CoreflowLadrilhoDeMenu)).height;
      }
      // O porte é a única coisa que este componente decide. Três portes com a mesma altura seria
      // um enum decorativo — e é o defeito mais fácil de introduzir mudando o `switch` de casa.
      expect(alturas.values.toSet().length, 3,
          reason: 'dois portes colapsaram na mesma altura: $alturas');
      expect(alturas[CoreflowPorteDoLadrilho.compacto], 80);
      expect(alturas[CoreflowPorteDoLadrilho.largo], 82);
      expect(alturas[CoreflowPorteDoLadrilho.alto], 100);
    });

    testWidgets('o compacto declara ALTURA e aceita a largura de quem posiciona',
        (t) async {
      // **O teste inverteu em 19/08**, e a inversão é a decisão: o compacto travava 85 de largura
      // porque vivia num FLUXO, e o dono trocou o fluxo por uma grade de três colunas. Numa grade a
      // peça não pode ter largura própria — é o `Expanded` que reparte.
      //
      // O que sobrou pra medir é a altura, que é o número do desenho e continua da peça. E a largura
      // é medida com restrição APERTADA de propósito: é o que uma coluna de grade entrega.
      await t.pumpWidget(montar(const SizedBox(
        width: 111,
        child: CoreflowLadrilhoDeMenu(
            icone: DilettaIcons.pixLight,
            rotulo: 'Pix',
            porte: CoreflowPorteDoLadrilho.compacto),
      )));
      await t.pump(const Duration(milliseconds: 50));
      final tamanho = t.getSize(find.byType(CoreflowLadrilhoDeMenu));
      expect(tamanho.height, 80, reason: 'a altura é da peça');
      expect(tamanho.width, 111,
          reason: 'a largura é de quem posiciona — se a peça voltar a cravar 85, a grade de três '
              'colunas volta a deixar 79pt vazios à direita');
    });

    testWidgets('e a LARGURA DISPONÍVEL pro rótulo cresce com a coluna', (t) async {
      // O defeito que a grade conserta é o rótulo quebrando por falta de pixel. **Não dá pra afirmar
      // isso num gate**: o ambiente de teste renderiza com a fonte de bloco, onde todo glifo é
      // quadrado — "Agência e conta" ocuparia 165 a 11px e quebraria em qualquer largura. Teste que
      // não vê a fonte não pode dizer se o texto quebra, e eu tentei antes de escrever isto.
      //
      // O que ele PODE medir é o que a decisão mudou: quanto espaço o rótulo recebe. Com 85 de
      // ladrilho e 8 de respiro de cada lado sobravam **69**; numa coluna de 111 sobram **95**. Os
      // 26 a mais são a folga que faltava.
      for (final (coluna, esperado) in [(85.0, 69.0), (111.0, 95.0)]) {
        await t.pumpWidget(montar(SizedBox(
          width: coluna,
          child: const CoreflowLadrilhoDeMenu(
              icone: DilettaIcons.pixLight,
              rotulo: 'Agência e conta do titular',
              porte: CoreflowPorteDoLadrilho.compacto),
        )));
        await t.pump(const Duration(milliseconds: 50));
        // A largura do parágrafo COM rótulo longo é a largura disponível: ele preenche a restrição
        // e corta. Medir assim em vez de caçar o `Padding` certo na árvore — a árvore é do pai e
        // pode mudar de forma sem mudar a decisão.
        final texto = t.getSize(find.byType(DilettaText).first).width;
        expect(texto, esperado,
            reason: 'numa coluna de $coluna o rótulo deveria receber $esperado');
      }
    });
  });

  group('a linha de aviso', () {
    testWidgets('a contagem some no ZERO — fila vazia não mostra um zero',
        (t) async {
      for (final quantas in [null, 0, 1]) {
        await t.pumpWidget(montar(CoreflowLinhaDeAviso(
          icone: DilettaIcons.paperPlaneLight,
          titulo: 'Autorizações',
          subtitulo: 'Veja o que está esperando você.',
          contagem: quantas,
        )));
        await t.pump(const Duration(milliseconds: 50));
        // A borda é o zero, e não o nulo: `count != null` sozinho desenharia um disco com "0",
        // que lê como "tem uma coisa aqui" quando não tem nada.
        expect(find.text('0'), findsNothing);
        expect(find.text('1'), quantas == 1 ? findsOneWidget : findsNothing);
      }
    });
  });

  group('o chip de filtro', () {
    testWidgets('escolhido INVERTE — e é isso que o separa do chip do pai',
        (t) async {
      Future<TextStyle> estiloCom({required bool escolhido}) async {
        await t.pumpWidget(montar(CoreflowChipDeFiltro('Entradas',
            escolhido: escolhido, aoTocar: () {})));
        await t.pump(const Duration(milliseconds: 200));
        return t.widget<Text>(find.text('Entradas')).style!;
      }

      final solto = await estiloCom(escolhido: false);
      final marcado = await estiloCom(escolhido: true);

      // As duas metades da inversão. Se só a cor virasse, o chip seria o `DilettaInputChip` com
      // outro nome — e o peso existe porque cor sozinha não é informação.
      expect(marcado.color, isNot(solto.color));
      expect(marcado.fontWeight, FontWeight.w600);
      expect(solto.fontWeight, FontWeight.w400);
    });

    testWidgets('o alvo de toque tem 44, e a pílula NÃO tem', (t) async {
      await t.pumpWidget(montar(
          CoreflowChipDeFiltro('Todos', escolhido: false, aoTocar: () {})));
      await t.pump(const Duration(milliseconds: 50));

      final alvo = t.getSize(find.byType(CoreflowChipDeFiltro)).height;
      // A pílula é o `Container` de dentro do chip do pai; o alvo é a peça inteira. Medir os dois
      // pelo mesmo `find` daria 44 nos dois e o teste passaria sem medir nada.
      final pilula = t
          .getSize(find
              .descendant(
                  of: find.byType(DilettaInputChip),
                  matching: find.byType(Container))
              .first)
          .height;

      // O número certo é **2.5.8** (WCAG 2.2, nível AA, 24×24), e não o 2.5.5 que eu tinha citado —
      // 2.5.5 é AAA. A correção é do pai, e ela muda o que a coisa é: o chip `filled`, com 24
      // cravados, **não falha** — ele está em cima do piso com margem zero.
      //
      // Esta variante entrega 44 porque o desenho dela pede, com o respiro FORA do desenho. Os dois
      // números são medidos separados de propósito: pôr o respiro dentro engorda a pílula e não move
      // o alvo, que é o erro fácil na direção contrária.
      expect(alvo, 44);
      expect(pilula, lessThan(30),
          reason: 'a pílula engordou junto com o alvo: o respiro foi parar '
              'dentro do desenho');
    });
  });

  group('o grupo do dia', () {
    Future<int> fiosCom(WidgetTester t, int lancamentos,
        {bool escuro = false}) async {
      await t.pumpWidget(montar(
        CoreflowGrupoDoDia(
          rotulo: 'Sexta, 8 de agosto',
          acessorio: const Text(r'R$ 0,14'),
          filhos: [
            for (var i = 0; i < lancamentos; i++)
              SizedBox(height: 56, child: Text('lançamento $i')),
          ],
        ),
        escuro: escuro,
      ));
      await t.pump(const Duration(milliseconds: 50));
      return t.widgetList(find.byType(DilettaDivider)).length;
    }

    testWidgets('N lançamentos, N-1 fios — medido em 1, 2 e 3', (t) async {
      // Com DOIS, "todos menos o último" e "entre pares" dão o mesmo número: é preciso o TRÊS pra
      // separar as leituras, e o UM pro caso em que o fio fecha o grupo em vez de separar.
      expect(await fiosCom(t, 1), 1,
          reason: 'o dia de um lançamento leva fio: ali ele FECHA o grupo');
      expect(await fiosCom(t, 2), 1);
      expect(await fiosCom(t, 3), 2);
    });

    testWidgets('o fio é o do pai nos dois temas — o defeito do print',
        (t) async {
      for (final escuro in [true, false]) {
        expect(await fiosCom(t, 2, escuro: escuro), 1);
      }
      // O controle. O defeito de 10/08 era um `Divider` do Material com branco a 12% cravado: ele
      // aparecia na árvore, então contar "existe um separador" passaria verde no claro também.
      expect(find.byType(Divider), findsNothing,
          reason: 'voltou um `Divider` cru: a cor dele é escrita à mão, e foi '
              'assim que o extrato ficou sem linha no tema claro');
    });
  });

  group('a fileira de avatares', () {
    testWidgets('rotulada mostra nome e banco; compacta não mostra nenhum',
        (t) async {
      await t.pumpWidget(montar(SizedBox(
        width: 300,
        child: CoreflowFileiraDeAvatares(
          iniciais: const ['CM', 'BL'],
          rotulos: const ['Carla', 'Bruno'],
          subrotulos: const ['Nubank', 'Itaú'],
          aoAdicionar: () {},
        ),
      )));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('Carla'), findsOneWidget);
      expect(find.text('Nubank'), findsOneWidget);
      expect(find.text('Adicionar'), findsOneWidget);

      await t.pumpWidget(montar(SizedBox(
        width: 300,
        child: CoreflowFileiraDeAvatares(
            iniciais: const ['CM', 'BL'], aoAdicionar: () {}),
      )));
      await t.pump(const Duration(milliseconds: 50));
      // A forma compacta é a MESMA peça com `rotulos` nulo, e não outra: passar rótulo é o que
      // liga a forma. Um `if` invertido aqui desenharia nome na fileira que não tem espaço.
      expect(find.text('Adicionar'), findsNothing);
    });
  });

  group('o cartão promocional', () {
    testWidgets('o X só existe quando há como fechar', (t) async {
      for (final fecha in [false, true]) {
        await t.pumpWidget(montar(SizedBox(
          width: 300,
          child: CoreflowCartaoPromocional(
            titulo: 'Habilite sua passkey',
            subtitulo: 'Login sem senha, resistente a phishing.',
            aoFechar: fecha ? () {} : null,
          ),
        )));
        await t.pump(const Duration(milliseconds: 50));
        // Sem `aoFechar` o X não pode aparecer: um X que não fecha é a pior das duas opções — ele
        // promete dispensar e não dispensa.
        expect(find.byType(DilettaIcon),
            fecha ? findsNWidgets(2) : findsOneWidget,
            reason: 'com fechar são dois glifos (X + moldura sem arte); sem, um');
      }
    });
  });
}
