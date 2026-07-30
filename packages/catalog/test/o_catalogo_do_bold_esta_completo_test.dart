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
  /// Emite como o MOTOR emite, e não como o bloco declara.
  ///
  /// Desde a tabela (v0.30.0), bloco com `ctor` tem o código gerado pelo motor e o `codegen` fica
  /// vestigial — ele segue obrigatório no contrato por compatibilidade. Testar `def.codegen` direto
  /// passou a medir a peça errada: um bloco com tabela e `codegen: (p) => ''` parecia não emitir
  /// nada. Foi o que aconteceu com o `cabecalhoDaHome`, e dois testes meus estavam medindo isso.
  String emite(BlockDef def) => temTabela(def)
      ? codigoDeBlocoDeclarado(def, def.defaults())
      : def.codegen(def.defaults());

  test('o catálogo do Bold está completo — baseline VAZIA', () {
    // Voltou a ser vazia na v0.30.1 do motor. Ela existiu por menos de uma hora, com quatro itens
    // que eram todos do pai: o `ehCtor` que não lia construtor nomeado (regressão da v0.30.0) e
    // dois falsos positivos do gate, que cobrava leitura de chrome de aparelho — o que por
    // contrato não emite código.
    //
    // Filho nasce sem dívida, e este está sem. Se ficar vermelho, o conserto é aqui — não na
    // baseline.
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
      // `const ` na frente é do motor: ele marca bloco literal. O que importa é que o construtor
      // seja do DS, não Flutter puro.
      expect(emite(def).replaceFirst('const ', ''), startsWith('ds.'),
          reason: 'o bloco "${def.type}" não emite componente do DS');
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

  group('a VOLTA — o leitor de código', () {
    // A quarta fiação do contrato. Sem ela, tela que só existe como código aparece como código,
    // sem preview: quem monta tela perde a metade de abrir o que já existe.
    ScreenSpec ler(String corpo) => Ds.leCodigoComoSpec(
        'ds.DilettaFrame.column(children: [$corpo])', 'tela')!;

    test('reconhece os blocos da linguagem', () {
      final spec = ler('''
        ds.DilettaPageTitle(title: 'Abrir conta', subtitle: 'Rápido'),
        ds.DilettaText('Olá', style: ds.DilettaType.bodyMd),
        ds.DilettaButton(label: 'Continuar', onPressed: onX, fullWidth: true),
      ''');
      expect(spec.blocks.map((b) => b.type),
          ['tituloDaPagina', 'texto', 'botao']);
      expect(spec.blocks[0].props['titulo'], 'Abrir conta');
      expect(spec.blocks[2].props['larguraTotal'], isTrue);
    });

    test('reconhece os blocos que nasceram NESTE filho', () {
      final spec = ler('''
        ds.BoldSaldo(valor: 'dez reais', oculto: true, aoAbrirExtrato: abrir),
        ds.BoldSeloQuantico(estado: ds.BoldSeloEstado.negado, tamanho: 120),
        ds.BoldCopiar(texto: 'chave', rotuloDeAcessibilidade: 'Copiar'),
      ''');
      expect(spec.blocks.map((b) => b.type), ['saldo', 'seloQuantico', 'copiar']);
      expect(spec.blocks[0].props['oculto'], isTrue);
      expect(spec.blocks[1].props['estado'], 'negado');
      expect(spec.blocks[0].props['valor'], 'dez reais');
      expect(spec.blocks[2].props['texto'], 'chave');
    });

    test('o que ele NÃO conhece vira bloco cru, e fica visível', () {
      // Preview que adivinha é pior que preview que declara o que não entendeu: o pedaço
      // desconhecido aparece como código à mão, que é o sinal pra alguém declarar o bloco.
      final spec = ler("MeuWidgetQueNaoExiste(x: 1)");
      expect(spec.blocks.single.type, 'cru');
      expect(spec.blocks.single.props['codigo'], contains('MeuWidgetQueNaoExiste'));
    });

    test('TODO bloco declarado tem entrada no leitor', () {
      // O buraco silencioso desta fiação: bloco que existe no registro e não existe no leitor não
      // falha em lugar nenhum — a tela abre e ele vira `cru`, como se alguém tivesse escrito código
      // à mão ali. Este gate percorre o registro INTEIRO, não uma amostra.
      final semLeitor = <String>[];
      for (final def in Ds.blocos.values) {
        if (Ds.ehChromeDeDispositivo(def.type)) continue; // não vai pro código, por contrato
        final codigo = emite(def);
        if (codigo.isEmpty) continue;
        final lido = ler(codigo).blocks;
        if (lido.length != 1 || lido.single.type != def.type) semLeitor.add(def.type);
      }
      expect(semLeitor, isEmpty,
          reason: 'blocos sem entrada no leitor (abrem como código à mão): $semLeitor');
    });

    test('o emitido LEVA o conteúdo — a dívida da tabela morreu na v0.32.1', () {
      // `docs/pedidos/2026-07-30-a-tabela-omite-argumento-igual-ao-default.md`
      //
      // Aqui morava a dívida declarada: o motor omitia todo argumento igual ao default do bloco, e
      // **18 dos meus 20 blocos com tabela emitiam `const ds.X()` puro** — que não compila quando o
      // construtor tem `required`. O teste antigo fixava esse número pra a dívida não sobreviver ao
      // conserto, e foi o que aconteceu: na v0.32.1 ele passou a medir 0 e caiu.
      //
      // O que fica no lugar é a propriedade que faltava, e ela não é a de ida-e-volta: **ida-e-volta
      // prova que o par emite/lê é consistente; não prova que o emitido é código válido.** As duas
      // pontas fechavam perfeitamente em cima de código que não compila.
      final semConteudo = <String>[];
      for (final def in Ds.blocos.values.where(temTabela)) {
        final padroes = def.defaults();
        final codigo = emite(def);
        for (final prop in def.args.keys) {
          final valor = '${padroes[prop] ?? ''}';
          // Texto vazio e `false` não têm conteúdo pra levar — omitir ali é acerto, não perda.
          if (valor.isEmpty || valor == 'false') continue;
          if (!codigo.contains(valor)) semConteudo.add('${def.type}.$prop');
        }
      }
      expect(semConteudo, isEmpty,
          reason: 'argumento com conteúdo no default que não aparece no gerado: $semConteudo');
    });

    test('o emitido é Dart VÁLIDO — nenhum argumento sem nome', () {
      // `docs/pedidos/2026-07-30-a-tabela-nao-declara-argumento-posicional.md`
      //
      // Este gate nasceu de um defeito que apareceu ao consertar OUTRO: a v0.32.1 passou a emitir todo
      // argumento com conteúdo, e com isso apareceu o que a omissão escondia — os dois blocos cujo
      // conteúdo é POSICIONAL (`ds.DilettaText('oi')`, `ds.DilettaGap.h(s4)`) emitiam `(: 'oi')`.
      //
      // E o motivo de ele existir SEPARADO dos outros dois: `emitido-perde-conteudo` estava verde
      // (o conteúdo estava lá) e ida-e-volta também (a leitura de enum e de posicional ignora o nome
      // do argumento). Duas checagens verdes sobre código que não compila, de novo — só que agora um
      // nível abaixo. A propriedade que faltava é a mais boba: **é sintaxe válida?**
      for (final def in Ds.blocos.values) {
        if (Ds.ehChromeDeDispositivo(def.type)) continue;
        final codigo = emite(def);
        expect(codigo, isNot(anyOf(contains('(: '), contains(', : '))),
            reason: 'o bloco "${def.type}" emite argumento sem nome: $codigo');
      }
    });

    test('a LISTA vai e volta com os FILHOS — o primeiro bloco de slot deste filho', () {
      // O gate `TODO bloco declarado tem entrada no leitor` mede o `codegen`, e o da lista é o caso
      // vazio (`children: const []`). O caminho de verdade é outro — `slotsCodegen` —, então sem este
      // teste a capacidade nova ficaria sem medida nenhuma: a lista passaria o gate emitindo o card
      // vazio e perderia todo item no código gerado, sem uma linha vermelha.
      final lista = Block(
        id: 'l',
        type: 'lista',
        props: {'titulo': 'Ajuda', 'idioma': 'carded'},
        slots: {
          'itens': [
            Block(id: 'a', type: 'linha', props: Ds.blocos['linha']!.defaults()),
            Block(
              id: 'b',
              type: 'linhaDeValor',
              props: {...Ds.blocos['linhaDeValor']!.defaults(), 'valor': 'R\$ 90,00'},
            ),
          ],
        },
      );

      final codigo = codigoDoBloco(lista);
      expect(codigo, startsWith('ds.DilettaAppList.carded('));
      expect(codigo, contains("title: 'Ajuda'"));
      expect(codigo, contains('ds.DilettaAppListRow.menuItem('));
      expect(codigo, contains(r"amount: 'R$ 90,00'"));

      final volta = ler(codigo).blocks.single;
      expect(volta.type, 'lista');
      expect(volta.props['titulo'], 'Ajuda');
      expect(volta.props['idioma'], 'carded');
      // A recursão é o ponto: os itens voltam pela TABELA, cada um com o próprio tipo e props.
      expect(volta.slots['itens']!.map((b) => b.type), ['linha', 'linhaDeValor']);
      expect(volta.slots['itens']![1].props['valor'], r'R$ 90,00');
      expect(volta.slots['itens']![0].props['icone'], 'userLight');
    });

    test('lista de outro idioma volta com o idioma certo, não com o default', () {
      // `plain` e `menu` diferem só pelo construtor nomeado, e o `carded` é o default do bloco: ler
      // qualquer um como `carded` daria uma tela que compila com o separador errado — a classe de
      // defeito mais difícil de ver numa revisão.
      final spec = ler('ds.DilettaAppList.menu(children: [\n'
          "  ds.DilettaAppListRow.menuItem(icon: ds.DilettaIcons.bellLight, title: 'Avisos'),\n"
          '])');
      expect(spec.blocks.single.props['idioma'], 'menu');
      expect(spec.blocks.single.slots['itens'], hasLength(1));
    });

    test('IDA e VOLTA fecham: codegen → leitor → mesmas props', () {
      for (final tipo in ['texto', 'botao', 'selo', 'campo', 'saldo', 'copiar']) {
        final def = Ds.blocos[tipo]!;
        final codigo = emite(def);
        final lido = ler(codigo).blocks.single;
        expect(lido.type, tipo,
            reason: 'o codegen de "$tipo" emite algo que o leitor não reconhece: $codigo');
      }
    });
  });
}