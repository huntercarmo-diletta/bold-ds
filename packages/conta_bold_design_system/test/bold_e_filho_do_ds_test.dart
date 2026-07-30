// UM import, e ele é do FILHO: o barril daqui reexporta a linguagem inteira, então quem
// consome este pacote (o app e o catálogo) não precisa conhecer o nome do pai. A
// conformidade também vem por ele desde a v0.1.5 — que foi um achado desta adoção: a
// suíte morava em `lib/` pra o filho chamar e não estava exportada.
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
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

  test('a paleta do Bold passa na conformidade do pai, com baseline VAZIA', () {
    // Nasceu com uma dívida e ela DUROU UM DIA: no claro o pai derivava
    // `onPrimarySubtle` de `primary04`, e o rosa do logo sobre o wash dava 3.08:1 —
    // sem conserto possível do lado do filho. A v0.1.6 do pai passou a derivar do
    // degrau 03, por evidência de dois filhos, e a baseline saiu.
    //
    // Baseline vazia é o estado normal de um filho. Se este teste ficar vermelho, o
    // conserto é na paleta — nunca na baseline.
    final v = violacoesDeConformidade(BoldPalette.bold);
    expect(v, isEmpty, reason: v.map((e) => '\n$e').join());
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
}
