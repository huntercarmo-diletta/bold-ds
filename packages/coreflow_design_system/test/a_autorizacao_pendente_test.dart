import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// AS DUAS PEÇAS DE UMA PENDÊNCIA — falta quanto, e até quando.
void main() {
  eixosDoCartao();
  Widget naTela(Widget filho, {bool escuro = false}) => Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          child: Align(alignment: Alignment.topLeft, child: filho),
        ),
      );

  group('progresso de aprovação', () {
    testWidgets('um degrau por assinatura exigida, preenchido por colhida', (t) async {
      await t.pumpWidget(naTela(
          const CoreflowProgressoDeAprovacao(colhidas: 1, exigidas: 3)));
      await t.pump(const Duration(milliseconds: 50));

      expect(find.text('1 de 3'), findsOneWidget);
      expect(find.text(' · faltam 2'), findsOneWidget);

      final s = DilettaScheme.light(BoldPalette.bold);
      final degraus = t
          .widgetList<DilettaBox>(find.byType(DilettaBox))
          .where((b) => b.height == 18 || b.height == 4)
          .map((b) => b.color?.toARGB32())
          .toList();
      expect(degraus, hasLength(3), reason: 'um degrau por assinatura');
      expect(degraus.first, s.primary.toARGB32(), reason: 'a colhida está cheia');
      expect(degraus.last, s.primaryTrack.toARGB32(), reason: 'a que falta é trilho');
    });

    testWidgets('completo fica VERDE — é a pendência que já pode executar', (t) async {
      await t.pumpWidget(naTela(
          const CoreflowProgressoDeAprovacao(colhidas: 2, exigidas: 2)));
      await t.pump(const Duration(milliseconds: 50));

      expect(find.text(' · completo'), findsOneWidget);
      final s = DilettaScheme.light(BoldPalette.bold);
      final cores = t
          .widgetList<DilettaBox>(find.byType(DilettaBox))
          .map((b) => b.color?.toARGB32())
          .toSet();
      expect(cores, contains(s.success.toARGB32()));
      expect(cores, isNot(contains(s.primary.toARGB32())));
    });

    testWidgets('singular quando falta uma', (t) async {
      await t.pumpWidget(naTela(
          const CoreflowProgressoDeAprovacao(colhidas: 1, exigidas: 2)));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text(' · falta 1'), findsOneWidget);
    });

    testWidgets('compacto some com a linha de apoio, e mantém o número', (t) async {
      await t.pumpWidget(naTela(const CoreflowProgressoDeAprovacao(
          colhidas: 1, exigidas: 2, compacto: true)));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('1 de 2'), findsOneWidget);
      expect(find.text(' · falta 1'), findsNothing);
    });

    testWidgets('exigência ZERO não desenha régua nenhuma', (t) async {
      await t.pumpWidget(naTela(
          const CoreflowProgressoDeAprovacao(colhidas: 0, exigidas: 0)));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.byType(DilettaBox), findsNothing);
    });

    testWidgets('o leitor de tela recebe a FRASE, não os degraus', (t) async {
      // Sem isto ele anuncia três caixas vazias antes do número — e a régua é redundância visual de
      // um dado que já é texto.
      await t.pumpWidget(naTela(const CoreflowProgressoDeAprovacao(
          colhidas: 1, exigidas: 2, exigeMaster: true)));
      await t.pump(const Duration(milliseconds: 50));

      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label ==
                '1 de 2 assinaturas, falta 1, uma precisa ser master'),
        findsOneWidget,
      );
    });
  });

  group('prazo da pendência', () {
    testWidgets('sem prazo do servidor mostra a IDADE, e não inventa contagem', (t) async {
      await t.pumpWidget(naTela(const CoreflowPrazoDaPendencia(idade: 'criada há 2 h')));
      await t.pump(const Duration(milliseconds: 50));

      expect(find.text('criada há 2 h'), findsOneWidget);
      // `pending`, não `neutral`: o veredito do meu pedido de família `info` (`ds v0.27.0`) foi que
      // espera é tom, e `neutral` quer dizer *sem estado*. A tinta é a mesma, a declaração não.
      expect(t.widget<DilettaStatusTag>(find.byType(DilettaStatusTag)).tone,
          DilettaStatusTone.pending);
    });

    testWidgets('prazo curto vira ALERTA; prazo largo fica neutro', (t) async {
      await t.pumpWidget(naTela(
          const CoreflowPrazoDaPendencia(restante: Duration(hours: 3))));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('faltam 3 h'), findsOneWidget);
      expect(t.widget<DilettaStatusTag>(find.byType(DilettaStatusTag)).tone,
          DilettaStatusTone.warning);

      await t.pumpWidget(naTela(
          const CoreflowPrazoDaPendencia(restante: Duration(days: 2))));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('faltam 2 d'), findsOneWidget);
      expect(t.widget<DilettaStatusTag>(find.byType(DilettaStatusTag)).tone,
          DilettaStatusTone.pending,
          reason: 'prazo largo é espera; só o prazo curto é ATENÇÃO');
    });

    // O GATE DA RECAÍDA, e ele mede a classe inteira e não os dois sítios: nenhum estado de espera
    // desta casa pode voltar a sair como `neutral`. O pai escreveu o `espera_nao_e_atencao_test`
    // porque o exemplo da doc dele pareava "Pendente" com `warning` — este é o mesmo gate um nível
    // abaixo, e o que ele pega aqui é a outra metade: espera que se declara *sem estado*.
    testWidgets('nenhuma espera sai como neutral — nem sem prazo, nem com prazo largo', (t) async {
      for (final espera in [
        const CoreflowPrazoDaPendencia(idade: 'criada há 2 h'),
        const CoreflowPrazoDaPendencia(restante: Duration(days: 2)),
        const CoreflowPrazoDaPendencia(restante: Duration(minutes: 30), urgenteAbaixoDe: Duration.zero),
      ]) {
        await t.pumpWidget(naTela(espera));
        await t.pump(const Duration(milliseconds: 50));
        final tag = t.widget<DilettaStatusTag>(find.byType(DilettaStatusTag));
        expect(tag.tone, isNot(DilettaStatusTone.neutral),
            reason: 'espera declarada como "sem estado": ${tag.label}');
        expect(tag.tone, DilettaStatusTone.pending);
      }
    });

    testWidgets('vencido é estado TERMINAL, e não "faltam -2 h"', (t) async {
      await t.pumpWidget(naTela(
          const CoreflowPrazoDaPendencia(restante: Duration(hours: -2))));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('prazo vencido'), findsOneWidget);
      expect(t.widget<DilettaStatusTag>(find.byType(DilettaStatusTag)).tone,
          DilettaStatusTone.danger);
    });

    testWidgets('o limite de urgência é do consumidor', (t) async {
      await t.pumpWidget(naTela(const CoreflowPrazoDaPendencia(
        restante: Duration(hours: 20),
        urgenteAbaixoDe: Duration(days: 1),
      )));
      await t.pump(const Duration(milliseconds: 50));
      expect(t.widget<DilettaStatusTag>(find.byType(DilettaStatusTag)).tone,
          DilettaStatusTone.warning);
    });

    testWidgets('sem prazo e sem idade não desenha etiqueta vazia', (t) async {
      await t.pumpWidget(naTela(const CoreflowPrazoDaPendencia()));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.byType(DilettaStatusTag), findsNothing);
    });

    testWidgets('o pill é do PAI — nenhum desenho de etiqueta mora aqui', (t) async {
      // O componente antigo pintava fundo com 12% do tom, radius de pill, ícone 11. Isso é a
      // `DilettaStatusTag`, que aceita ícone e tom: o que sobrou deste componente é a REGRA.
      await t.pumpWidget(naTela(const CoreflowPrazoDaPendencia(idade: 'criada há 1 d')));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.byType(DilettaStatusTag), findsOneWidget);
      expect(find.byType(DilettaBox), findsNothing,
          reason: 'voltou a desenhar pill próprio em vez de usar a etiqueta do pai');
    });
  });
}

/// OS DOIS EIXOS QUE O CARTÃO GANHOU EM 22/08, adotando-o na tela de onde ele saiu.
///
/// O `_PendingCard` do app foi portado pra cá semanas antes e a tela continuou evoluindo: ganhou o
/// tom por TIPO DE TRANSAÇÃO e o MODO LOTE. Sem os dois, adotar a peça custava duas funções do
/// produto — e peça que custa função não é adotada, é contornada.
void eixosDoCartao() {
  Widget naTela(Widget filho, {bool escuro = false}) => Directionality(
        textDirection: TextDirection.ltr,
        child: DilettaThemeScope(
          theme: escuro ? CoreflowTheme.dark : CoreflowTheme.light,
          child: Align(alignment: Alignment.topLeft, child: filho),
        ),
      );

  Widget cartao({
    CoreflowTomDoPedido tom = CoreflowTomDoPedido.marca,
    bool emLote = false,
    bool selecionada = false,
    bool jaAprovei = false,
  }) =>
      CoreflowCartaoDePedido(
        quemPediu: 'Ana',
        detalhe: 'Pix · para João · 14:32',
        valor: r'R$ 1.200,00',
        icone: 'pix-mark',
        colhidas: 1,
        exigidas: 2,
        tom: tom,
        emLote: emLote,
        selecionada: selecionada,
        jaAprovei: jaAprovei,
      );

  group('o cartão do pedido', () {
    testWidgets('o TOM pinta o ladrilho, e os quatro são papéis distintos', (t) async {
      final tintes = <CoreflowTomDoPedido, int>{};
      for (final tom in CoreflowTomDoPedido.values) {
        await t.pumpWidget(naTela(SizedBox(width: 400, child: cartao(tom: tom))));
        await t.pump(const Duration(milliseconds: 50));
        final ladrilho = t
            .widgetList<Container>(find.byType(Container))
            .firstWhere((c) => c.constraints?.maxWidth == 46);
        tintes[tom] = ((ladrilho.decoration! as BoxDecoration).color!).toARGB32();
      }
      expect(tintes.values.toSet(), hasLength(4),
          reason: 'quatro tons, quatro tintes — se dois empatam, o tipo deixa de se ler pela cor');
    });

    testWidgets('o LOTE troca o par de botões pela caixa de marcar', (t) async {
      await t.pumpWidget(naTela(SizedBox(width: 400, child: cartao())));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('Aprovar'), findsOneWidget, reason: 'fora do lote o cartão decide');
      expect(find.byType(DilettaCheckbox), findsNothing);

      await t.pumpWidget(naTela(SizedBox(width: 400, child: cartao(emLote: true))));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.text('Aprovar'), findsNothing,
          reason: 'no lote a ação é da barra de baixo, não do cartão');
      expect(find.byType(DilettaCheckbox), findsOneWidget);
    });

    testWidgets('e quem JÁ APROVOU não tem caixa: ali é estado', (t) async {
      await t.pumpWidget(
          naTela(SizedBox(width: 400, child: cartao(emLote: true, jaAprovei: true))));
      await t.pump(const Duration(milliseconds: 50));
      expect(find.byType(DilettaCheckbox), findsNothing);
    });

    testWidgets('a ESCOLHA do lote vai na borda do cartão', (t) async {
      Color? borda(WidgetTester t) => t
          .widgetList<DilettaCardSurface>(find.byType(DilettaCardSurface))
          .first
          .bordaSolida;

      await t.pumpWidget(naTela(SizedBox(width: 400, child: cartao(emLote: true))));
      await t.pump(const Duration(milliseconds: 50));
      final normal = borda(t);

      await t.pumpWidget(naTela(
          SizedBox(width: 400, child: cartao(emLote: true, selecionada: true))));
      await t.pump(const Duration(milliseconds: 50));
      expect(borda(t), isNot(normal),
          reason: 'sem a borda, o cartão escolhido é indistinguível do vizinho');
      expect(borda(t), DilettaScheme.light(BoldPalette.bold).primary);
    });
  });
}
