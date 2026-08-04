import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CABEÇALHO DA HOME — o componente que estava atrás do pedido bloqueante.
///
/// Os 113 usos da barra de topo deste produto ficavam presos porque os acessórios do pai eram
/// `sealed`: 110 eram rename direto e não podiam entrar por causa de 3. A v0.4.0 abriu o acessório
/// livre, e este componente é o que ocupa a abertura.
void main() {
  Widget naBarra(BoldCabecalhoDaHome cabecalho, {bool escuro = true}) => MaterialApp(
        home: DilettaThemeScope(
          theme: escuro ? BoldTheme.dark : BoldTheme.light,
          child: Scaffold(
            body: Column(children: [cabecalho]),
          ),
        ),
      );

  testWidgets('entra na barra do PAI e aparece, nos dois modos', (t) async {
    for (final escuro in [false, true]) {
      await t.pumpWidget(naBarra(
        const BoldCabecalhoDaHome(nome: 'Ana', conta: 'Conta PF'),
        escuro: escuro,
      ));
      await t.pump(const Duration(milliseconds: 50));
      expect(t.takeException(), isNull);
      expect(find.text('Olá, Ana!'), findsOneWidget);
      expect(find.text('Conta PF'), findsOneWidget);
    }
  });

  testWidgets('é CASCA e não acessório — as duas linhas não caberiam na barra', (t) async {
    // A primeira versão deste componente era um acessório `.livre` dentro da barra, e estourou
    // 32px: a barra do pai é `height: 52` cravado, e este cabeçalho tem duas linhas (28 + 16 + 40
    // = 84). Este teste fixa a estrutura que resolveu — a barra DENTRO da casca, não o contrário.
    await t.pumpWidget(naBarra(const BoldCabecalhoDaHome(nome: 'Ana', conta: 'Conta PF')));
    await t.pump(const Duration(milliseconds: 50));

    expect(t.takeException(), isNull, reason: 'estourou o layout de novo');
    // A CASCA é do pai desde a v0.11.0 (`DilettaTopAppBar.comConteudo`): antes eu copiava a gramática
    // dela aqui — vidro, status bar, coluna e o respiro do fim. Este `expect` é o que impede a cópia
    // de voltar: se alguém remontar à mão, os outros testes continuam verdes e este não.
    expect(find.byType(DilettaTopAppBar), findsOneWidget,
        reason: 'a casca voltou a ser composta à mão aqui dentro');
    // A barra do pai é usada por dentro, e a linha de conta vai no acessório livre dela.
    expect(find.byType(DilettaNavigationTopBar), findsOneWidget);
    expect(t.getSize(find.byType(BoldCabecalhoDaHome)).height, greaterThan(52),
        reason: 'se caiu pra 52, a segunda linha sumiu');
  });

  testWidgets('a casca é a de APP REAL — sem a status bar mock, senão são DOIS relógios', (t) async {
    // A v0.40.0 do pai. Até ela, a segunda linha só existia nas variantes de status bar MOCK, e
    // esta peça montava em `.comConteudo` — que desenha a `DilettaStatusBar` 9:41 por cima da
    // status bar do sistema. Este componente é a home de um app REAL: aqui a mock é defeito, não
    // moldura. O gate mede a AUSÊNCIA porque é ela que o print mostrava errado.
    await t.pumpWidget(naBarra(const BoldCabecalhoDaHome(nome: 'Ana', conta: 'Conta PF')));
    await t.pump(const Duration(milliseconds: 50));

    expect(find.byType(DilettaStatusBar), findsNothing,
        reason: 'o relógio mock voltou — no app real ele empilha na status bar do sistema');
    // O controle: sem ele o `findsNothing` acima passaria também se a casca inteira tivesse sumido.
    expect(find.byType(DilettaTopAppBar), findsOneWidget);
  });

  testWidgets('sem troca de conta NÃO tem chevron', (t) async {
    // Rótulo estático com afordância de clique é pior que rótulo sem afordância: a pessoa toca e
    // nada acontece, e ela conclui que o app travou.
    await t.pumpWidget(naBarra(const BoldCabecalhoDaHome(nome: 'Ana', conta: 'Conta PF')));
    await t.pump(const Duration(milliseconds: 50));
    final semTroca = t.widgetList<DilettaIcon>(find.byType(DilettaIcon)).length;

    var trocou = 0;
    await t.pumpWidget(naBarra(BoldCabecalhoDaHome(
      nome: 'Ana',
      conta: 'Conta PF',
      aoTrocarConta: () => trocou++,
    )));
    await t.pump(const Duration(milliseconds: 50));
    expect(t.widgetList<DilettaIcon>(find.byType(DilettaIcon)).length,
        semTroca + 1,
        reason: 'com troca de conta aparece o chevron');

    await t.tap(find.text('Conta PF'));
    expect(trocou, 1);
  });

  testWidgets('o perfil abre pelo avatar, e ele tem rótulo de leitor de tela', (t) async {
    var abriu = 0;
    await t.pumpWidget(naBarra(BoldCabecalhoDaHome(
      nome: 'Ana',
      aoAbrirPerfil: () => abriu++,
    )));
    await t.pump(const Duration(milliseconds: 50));

    // Por predicado de WIDGET e não por `bySemanticsLabel`: a árvore de semântica só existe em
    // teste com `ensureSemantics`, e o que interessa aqui é que a DECLARAÇÃO está no componente —
    // ícone sem rótulo é botão mudo pra leitor de tela.
    expect(
      find.byWidgetPredicate((w) =>
          w is Semantics && w.properties.label == 'Abrir perfil de Ana'),
      findsOneWidget,
    );
    await t.tap(find.byType(DilettaAvatar));
    expect(abriu, 1);
  });

  testWidgets('nome vazio cai no "?" em vez de quebrar', (t) async {
    // O nome vem de sessão, e sessão pode chegar vazia. `nome[0]` em string vazia é exceção.
    await t.pumpWidget(naBarra(const BoldCabecalhoDaHome(nome: '')));
    await t.pump(const Duration(milliseconds: 50));
    expect(t.takeException(), isNull);
    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('conta carregando mostra skeleton, não o rótulo vazio', (t) async {
    await t.pumpWidget(naBarra(const BoldCabecalhoDaHome(
      nome: 'Ana',
      conta: 'Conta PF',
      carregandoConta: true,
    )));
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('Conta PF'), findsNothing);
    expect(find.byType(DilettaSkeleton), findsOneWidget);
  });

  testWidgets('o mini-avatar NÃO é branco cravado — ele segue a superfície do tema', (t) async {
    // Era `white` fixo. No escuro, um círculo de branco puro sobre fundo quase preto fica sendo o
    // ponto mais claro da tela, e ele é um adorno de 16px.
    await t.pumpWidget(naBarra(const BoldCabecalhoDaHome(nome: 'Ana'), escuro: true));
    await t.pump(const Duration(milliseconds: 50));

    final cores = t
        .widgetList<DilettaBox>(find.byType(DilettaBox))
        .map((b) => b.color)
        .whereType<Color>()
        .map((c) => c.toARGB32())
        .toSet();
    expect(cores, isNot(contains(0xFFFFFFFF)),
        reason: 'branco cravado no adorno voltou');
    expect(cores, contains(DilettaScheme.dark(BoldPalette.bold).surface.toARGB32()));
  });
}
