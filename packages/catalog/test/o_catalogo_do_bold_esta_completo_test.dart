import 'package:conta_bold_catalog/main.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O CATÁLOGO DO BOLD É FILHO DO CATALOGO-DILETTA — o gate que torna isso fato.
///
/// A conformidade é entregue pelo PAI: ele não audita o filho, ele dá a checagem e o
/// filho roda no próprio CI. Cada violação diz onde, o quê, e qual erro aquilo evita.
void main() {
  test('o catálogo do Bold está completo — baseline VAZIA', () {
    // Filho nasce sem dívida. Baseline que não encolhe vira desculpa permanente, então
    // esta começa vazia e a intenção é que continue.
    final v = violacoesDoFilho();
    expect(v, isEmpty, reason: v.map((e) => '\n$e').join());
  });

  test('todo bloco do registro está num grupo', () {
    // A paleta do editor sai dos GRUPOS, então bloco fora de grupo existe e ninguém
    // acha. A conformidade já cobre isto; o teste explícito existe porque a mensagem
    // aqui é mais direta pra quem acabou de declarar um bloco novo.
    final agrupados = Ds.grupos.values.expand((g) => g).toSet();
    expect(Ds.blocos.keys.toSet().difference(agrupados), isEmpty,
        reason: 'bloco declarado e fora de grupo: não aparece na paleta');
  });

  test('todo bloco desenha com os próprios defaults', () {
    // `defaults()` é o que o editor usa ao arrastar um bloco pro canvas. Se um default
    // faltar, o bloco entra na tela e estoura no primeiro render.
    for (final def in Ds.blocos.values) {
      expect(() => def.build(def.defaults()), returnsNormally,
          reason: 'o bloco "${def.type}" não desenha com os defaults dele');
    }
  });

  test('o código gerado USA o design system, e não Flutter puro', () {
    // O furo mais perigoso do plugue, porque nada falha: o catálogo geraria código que
    // compila e não usa o DS, o dev copiaria a tela, e ninguém avisaria.
    expect(Ds.importNoCodigo, contains('conta_bold_design_system'));
    expect(Ds.nomesNoCodigo.coluna, startsWith('ds.'));

    for (final def in Ds.blocos.values) {
      // Chrome de aparelho não vai pro código gerado, de propósito.
      if (Ds.ehChromeDeDispositivo(def.type)) continue;
      expect(def.codegen(def.defaults()), startsWith('ds.'),
          reason: 'o codegen de "${def.type}" não emite componente do DS');
    }
  });

  testWidgets('o preview sai com a cor do BOLD, e nenhuma do CPF SEGURO', (t) async {
    // O mesmo critério do DS-filho, aplicado à ferramenta: os componentes aqui passam
    // pelo gancho `tema` do plugue, e é ele que faz a identidade chegar no preview.
    const marcaDoPrimeiroFilho = {
      'primary04 (azul de ação)': 0xFF003BE0,
      'primary08 (wash)': 0xFFF2F5FF,
      'secure04 (amarelo do selo)': 0xFFF5C842,
    };

    await t.pumpWidget(MaterialApp(
      home: Ds.tema(
        Builder(
          builder: (ctx) => ColoredBox(
            color: DilettaTheme.schemeOf(ctx).bg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final tipo in ['botao', 'selo', 'valor'])
                  Ds.blocos[tipo]!.build(Ds.blocos[tipo]!.defaults()),
              ],
            ),
          ),
        ),
      ),
    ));
    await t.pump(const Duration(milliseconds: 100));

    final cores = <int>{};
    for (final w in t.allWidgets) {
      for (final prop in w.toDiagnosticsNode().getProperties()) {
        switch (prop.value) {
          case Color c:
            cores.add(c.toARGB32());
          case TextStyle s when s.color != null:
            cores.add(s.color!.toARGB32());
          case BoxDecoration d when d.color != null:
            cores.add(d.color!.toARGB32());
        }
      }
    }

    final vazam = marcaDoPrimeiroFilho.entries
        .where((e) => cores.contains(e.value))
        .map((e) => e.key);
    expect(vazam, isEmpty, reason: 'cor do CPF SEGURO no preview do Bold: $vazam');
    expect(cores, contains(BoldPalette.bold.primary04.toARGB32()),
        reason: 'o rosa do Bold não apareceu — a identidade não chega no preview');
  });

  test('a config das abas é válida na CONSTRUÇÃO', () {
    // O pai valida no construtor: sem aba, só abas ocultas, id repetido, id com "/",
    // abaInicial inexistente. Config torta que só aparece como aba em branco custa uma
    // sessão de depuração; aqui custa uma mensagem.
    final c = configDoCatalogoDoBold();
    expect(c.abas.map((a) => a.id), contains(c.abaInicial));
    expect(c.abas.length, greaterThan(1));
  });
}
