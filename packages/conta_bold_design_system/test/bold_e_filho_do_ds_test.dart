// UM import, e ele é do FILHO: o barril daqui reexporta a linguagem inteira, então quem
// consome este pacote (o app e o catálogo) não precisa conhecer o nome do pai. A
// conformidade também vem por ele desde a v0.1.5 — que foi um achado desta adoção: a
// suíte morava em `lib/` pra o filho chamar e não estava exportada.
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

/// O CONTA BOLD É FILHO DO DS — este teste transforma isso em fato.
///
/// Copia a forma da Aurora (`ds-diletta/exemplos/aurora`), e o critério é o mesmo:
/// compilar já é metade da prova (se o pai escondesse dependência da identidade do
/// primeiro filho, este pacote não compilaria), e a outra metade é a cor sair ROSA.
void main() {
  /// As cores que só existem no CPF SEGURO. Nenhuma pode aparecer numa tela do Bold —
  /// se aparecer, um componente do pai está lendo VALOR em vez de papel.
  ///
  /// Literais de propósito: importar a paleta do irmão exigiria depender dele, que é
  /// exatamente o que este teste prova não acontecer.
  const marcaDoPrimeiroFilho = <String, int>{
    'primary04 (azul de ação)': 0xFF003BE0,
    'primary05': 0xFF2861FF,
    'primary08 (wash)': 0xFFF2F5FF,
    'primary03': 0xFF002CA8,
    'secure04 (amarelo do selo)': 0xFFF5C842,
    'partnerPrimary': 0xFFFF6B35,
  };

  Set<int> coresNaArvore(WidgetTester t) {
    final out = <int>{};
    void add(Object? v) {
      // BoxDecoration.boxShadow chega como List<BoxShadow>; BoxShadow solto tambem.
      switch (v) {
        case Color c:
          out.add(c.toARGB32());
        case TextStyle st:
          add(st.color);
        case BoxDecoration d:
          add(d.color);
          add(d.border?.top.color);
          if (d.gradient case final LinearGradient g) {
            g.colors.forEach(add);
          }
          d.boxShadow?.forEach(add);
        case BorderSide b:
          add(b.color);
        // SOMBRA entra na varredura, e a razão é medida: as quatro elevações de MARCA do
        // pai (`brandLow/Medium/High/Soft`) são constantes com o azul do primeiro filho,
        // e nenhum dos dois gates olhava pra `boxShadow`. Quatro componentes do pai as
        // usam — entre eles a nav e o botão `chatLift`. Ver ADOCAO.md, pedido 6.
        case BoxShadow s:
          add(s.color);
        case List<BoxShadow> ss:
          ss.forEach(add);
      }
    }

    for (final w in t.allWidgets) {
      for (final prop in w.toDiagnosticsNode().getProperties()) {
        add(prop.value);
      }
    }
    return out;
  }

  for (final escuro in [false, true]) {
    final modo = escuro ? 'escuro' : 'claro';
    testWidgets('a tela do Bold não mostra NENHUMA cor do CPF SEGURO ($modo)', (t) async {
      await t.pumpWidget(MaterialApp(home: TelaDeExemploBold(escuro: escuro)));
      await t.pump(const Duration(milliseconds: 100));

      final cores = coresNaArvore(t);
      final vazam = marcaDoPrimeiroFilho.entries
          .where((e) => cores.contains(e.value))
          .map((e) => e.key)
          .toList();
      expect(vazam, isEmpty,
          reason: 'a tela do Bold está mostrando cor do CPF SEGURO: $vazam.\n'
              'Cada uma é um componente do pai lendo VALOR em vez de papel.');
    });
  }

  testWidgets('a cor de ação que aparece é a do BOLD', (t) async {
    // O par do teste acima, e ele é necessário: "nenhuma cor do CPF" também passaria
    // numa tela cinza que não pinta marca nenhuma. Este exige a presença do rosa.
    await t.pumpWidget(const MaterialApp(home: TelaDeExemploBold()));
    await t.pump(const Duration(milliseconds: 100));

    expect(coresNaArvore(t), contains(BoldPalette.bold.primary04.toARGB32()),
        reason: 'o rosa do Bold não apareceu — a identidade não está chegando');
  });

  test('a conformidade do pai na paleta do Bold — 2 dívidas, uma classe só', () {
    // A `ds v0.66.0` trocou degrau por DISTÂNCIA nos três papéis derivados, e o
    // resultado na minha paleta é o melhor tipo de resposta: **duas violações
    // sumiram e uma trocou de tinta.**
    //
    //   saiu  warning/trilho (light)        — a derivação do `warningGrafico`
    //                                         achou o degrau que fecha (4,11)
    //   saiu  trilho/bg (dark)              — o trilho escuro se separou da página
    //   fica  normal/trilho (light)         — 2,93 → **1,32**
    //   entra error/trilho (light)          — 3,11 → **1,41**
    //
    // Os dois que ficam PIORARAM, e o número é o achado: a busca do trilho anda
    // do claro pro médio (`neutral09 → neutral05`) e **o rosa desta marca tem
    // luminância média**. Descer o trilho o aproxima da tinta antes de afastar —
    // a curva não é monotônica, e a lista para no meio dela.
    //
    // Medido e pedido em
    // `docs/pedidos/2026-08-10-a-lista-de-candidatos-anda-numa-direcao-so.md`.
    const dividasComPedido = {
      '[trilho-do-medidor] normal/trilhoDeMedidor (light)',
      '[trilho-do-medidor] error/trilhoDeMedidor (light)',
    };
    final v = violacoesDeConformidade(BoldPalette.bold);
    final vistas = v.map((e) => '$e'.split(' — ').first).toSet();
    expect(vistas, dividasComPedido,
        reason: 'a conformidade mudou de forma. Se ENTROU violação, é dívida '
            'nova e o conserto é na paleta; se SAIU, o pedido foi atendido e a '
            'lista encolhe aqui:\n${v.map((e) => "\n$e").join()}');
  });

  test('o esqueleto pesa IGUAL nos dois temas — 1,41 e 1,41', () {
    // O pedido do esqueleto entrou na mesma tag, e este é o critério de sucesso
    // que eu escrevi nele: *o mesmo vulto nos dois temas*.
    //
    // Era **1,41 no claro e 2,51 no escuro** — o escuro pesava 1,8×, e um
    // esqueleto que chama atenção é o oposto do gesto. Agora `surfaceLoading` é
    // a tinta da superfície com o alpha que alcança 1,4, e dá `#D9D9D9` no claro
    // e `#30313A` no escuro: **1,41 e 1,41**.
    //
    // O teste mede o PESO e não a cor, de propósito: cor muda com a rampa, peso
    // é a intenção.
    double luz(Color c) {
      double canal(double v) =>
          v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4) as double;
      return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
    }

    double peso(Color a, Color b) {
      final x = luz(a), y = luz(b);
      return (math.max(x, y) + 0.05) / (math.min(x, y) + 0.05);
    }

    final claro = DilettaScheme.light(BoldPalette.bold);
    final escuro = DilettaScheme.dark(BoldPalette.bold);
    final pc = peso(claro.surfaceLoading, claro.surface);
    final pe = peso(escuro.surfaceLoading, escuro.surface);

    expect(pc, closeTo(1.4, 0.15), reason: 'o vulto do claro saiu do alvo');
    expect(pe, closeTo(1.4, 0.15), reason: 'o vulto do escuro saiu do alvo');
    expect((pc - pe).abs(), lessThan(0.15),
        reason: 'os dois temas voltaram a pesar diferente — era 1,41 contra '
            '2,51, e é isso que o pedido consertou');
  });

  test('o Bold fornece a paleta e MAIS NADA obrigatório', () {
    final s = DilettaScheme.light(BoldPalette.bold);
    expect(s.primary, BoldPalette.bold.primary04);
    expect(s.partnerSurface, BoldPalette.bold.partnerSurface);

    // O escuro vem de graça: mesma paleta, papéis invertidos.
    final d = DilettaScheme.dark(BoldPalette.bold);
    expect(d.bg, isNot(s.bg));
    expect(d.isDark, isTrue);
  });

  testWidgets('o Bold HERDA os ícones do pai sem configurar nada', (t) async {
    expect(DilettaAssets.package, 'diletta_design_system');
    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: const Scaffold(body: DilettaIcon(name: 'bell-light', size: 24)),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));
    expect(t.takeException(), isNull);
  });

  testWidgets('o glifo de assistente vem do PAI, e não de asset próprio', (t) async {
    // Este é o gate que eu prometi no pedido do sparkle
    // (`docs/pedidos/2026-07-29-falta-o-glifo-de-assistente-no-conjunto.md`, veredito ENTRA
    // na v0.6.0). Ele mede a AUSÊNCIA de conjunto próprio, que é o que estava em jogo: dois
    // arquivos locais obrigariam este filho a manter um conjunto inteiro e cobrir os 46
    // nomes que os componentes do pai referenciam — 6 dos quais quebrariam em silêncio por
    // sufixo de export.
    for (final nome in ['sparklesLightFull', 'sparklesSolidFull']) {
      expect(DilettaIcons.all, contains(nome),
          reason: 'o glifo $nome não está no conjunto do pai');
    }

    await t.pumpWidget(MaterialApp(
      home: DilettaThemeScope(
        theme: BoldTheme.light,
        child: Scaffold(
          body: DilettaFrame.row(
            gap: DilettaSpacing.s2,
            children: [
              DilettaIcon(name: DilettaIcons.sparklesLightFull, size: 20),
              DilettaIcon(name: DilettaIcons.sparklesSolidFull, size: 20),
            ],
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));
    expect(t.takeException(), isNull,
        reason: 'o .vec compilado do pai não carregou');
  });
}
