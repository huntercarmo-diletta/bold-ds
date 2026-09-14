// O QUE A WEB DESENHA É O QUE O MOBILE DESENHA.
//
// Este é o gate que faltava, e a falta foi medida duas vezes no mesmo dia. Já existe um gate
// provando que o `.css` no disco é o que o emissor produz — mas isso só pega quem edita o arquivo à
// mão. O que ele NÃO pega é o emissor produzir uma coisa e o componente desenhar outra, que é
// exatamente o que aconteceu:
//
//   1. `coreflowMedidasCss` lia a const `CoreflowRadius.sheet`. Um produto declarando 8 veria a
//      folha do app em 8 e a da web em 22;
//   2. depois, lia `medidaDe` cru, que consulta só a tabela de medidas e pula o alias `raioDeX`. O
//      produto desta casa declara `raioDeBotao: 16` e a web emitia a pílula.
//
// As duas passaram pelo gate do disco: o arquivo batia com o emissor, e o emissor é que estava
// errado. **Comparar a saída com a fonte não é o mesmo que comparar a saída com o DESENHO.**
//
// Por isso este arquivo lê pelas MESMAS APIs que os widgets leem — `formaDoCartao`,
// `dilettaCorDoPapelGen`, `CoreflowType.x` — e não pelo caminho que o emissor usou.
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'emite_o_css_do_bold.dart' show cssDoBold, tagsDaWeb;

/// As variáveis da folha, por MODO.
///
/// A folha tem vários blocos `:root` — um por família (cor, esquema, medida, tipo) — e três
/// seletores de modo. Varrer por posição pegaria só o primeiro, que foi o defeito da primeira versão
/// deste gate: ele reprovou tudo e a culpa era da leitura, não da folha.
///
/// [escuro] junta o que está em `:root[data-theme="dark"]`; [claro] junta o que está em `:root`
/// simples, que é onde as famílias sem modo (medida, tipo) também moram.
Map<String, String> _vars(String css, {required bool escuro}) {
  final fora = <String, String>{};
  final linhas = css.split('\n');
  var dentro = false;
  var profundidade = 0;
  for (final linha in linhas) {
    final l = linha.trim();
    if (l.endsWith('{')) {
      profundidade++;
      final sel = l.substring(0, l.length - 1).trim();
      if (sel.isNotEmpty && !sel.startsWith('@')) {
        // `:root` simples é o claro; `:root[data-theme="dark"]` é o escuro declarado. O
        // `:root:not([data-theme="light"])` dentro do `@media` é o MESMO escuro, e fica de fora pra
        // não contar duas vezes — o gate mede o que o seletor declara, não a preferência do sistema.
        dentro = escuro ? sel == ':root[data-theme="dark"]' : sel == ':root';
      }
      continue;
    }
    if (l == '}') {
      profundidade--;
      if (profundidade <= 0) dentro = false;
      continue;
    }
    if (!dentro) continue;
    final m = RegExp(r'--cps-([A-Za-z0-9-]+):\s*([^;]+);').firstMatch(l);
    if (m != null) fora[m.group(1)!] = m.group(2)!.trim();
  }
  return fora;
}

String _hex(Color c) {
  final argb = c.toARGB32();
  final rgb = argb.toRadixString(16).padLeft(8, '0').substring(2);
  final a = (argb >> 24) & 0xFF;
  return a == 0xFF ? '#$rgb' : '#$rgb${a.toRadixString(16).padLeft(2, '0')}';
}

String _px(double v) => v == v.roundToDouble() ? '${v.round()}px' : '${v}px';

void main() {
  final css = cssDoBold();
  final claro = _vars(css, escuro: false);
  final escuro = _vars(css, escuro: true);
  const p = BoldPalette.bold;

  test('a COR de cada papel é a que o componente pinta, nos dois modos', () {
    final divergem = <String>[];
    for (final modo in [
      (nome: 'claro', s: DilettaScheme.light(p), css: claro),
      (nome: 'escuro', s: DilettaScheme.dark(p), css: escuro),
    ]) {
      for (final papel in dilettaNomesDePapelGen) {
        final cor = dilettaCorDoPapelGen(modo.s, papel);
        if (cor == null) continue;
        final naWeb = modo.css[papel];
        // Os dois papéis que o esquema do produto sobrescreve de propósito saem com o valor DELE,
        // e é assim que o white label acontece na cascata — a conferência deles é o teste abaixo.
        if (papel == 'primary' || papel == 'border') continue;
        if (naWeb != _hex(cor)) {
          divergem.add('${modo.nome}/$papel: mobile ${_hex(cor)} × web ${naWeb ?? "ausente"}');
        }
      }
    }
    expect(divergem, isEmpty, reason: 'a web pinta diferente do app:\n${divergem.join('\n')}');
  });

  test('os papéis do ESQUEMA do produto também, e são eles que ganham na cascata', () {
    for (final modo in [
      (nome: 'claro', b: Brightness.light, css: claro),
      (nome: 'escuro', b: Brightness.dark, css: escuro),
    ]) {
      final s = CoreflowScheme.de(p, brilho: modo.b);
      final esperado = {
        'background': s.background, 'secondaryFlow': s.secondaryFlow,
        'textPrimary': s.textPrimary, 'border': s.border, 'overlay': s.overlay,
        'primary': s.primary, 'danger': s.danger, 'infoSubtle': s.infoSubtle, 'vinho': s.vinho,
      };
      esperado.forEach((papel, cor) {
        expect(modo.css[papel], _hex(cor),
            reason: '${modo.nome}/$papel: a web não pinta o que o esquema do produto diz');
      });
    }
  });

  test('a FORMA de cada família é a que o componente arredonda', () {
    final a = DilettaScheme.light(p);
    final nosso = CoreflowScheme.de(p, brilho: Brightness.light);
    // As mesmas APIs que os widgets chamam. Ler por aqui é o que faz este gate valer: o emissor
    // errou duas vezes justamente por ler por outro caminho.
    final desenho = {
      DilettaMedida.formaDeBotao: a.formaDoBotao,
      DilettaMedida.formaDeFolha: nosso.formaDaFolha,
      DilettaMedida.formaDeCampo: a.formaDoCampo,
      DilettaMedida.formaDeCartao: a.formaDoCartao,
      DilettaMedida.formaDeVidro: a.formaDoVidro,
      DilettaMedida.formaDeNav: a.formaDaNav,
    };
    desenho.forEach((papel, raio) {
      expect(claro[papel], _px(raio.topLeft.x),
          reason: '$papel: o app arredonda ${_px(raio.topLeft.x)} e a web diz ${claro[papel]}');
    });
    // E o conjunto FECHADO: forma nova no avô sem entrar na folha é peça web que arredonda por
    // conta própria. Este número sobe por veredito, como todo campo do plugue.
    expect(desenho.keys.toSet(), DilettaMedida.formas,
        reason: 'o avô tem forma que a folha não emite, ou a folha emite uma que ele não tem');
  });

  test('o TIPO de cada degrau é o que o componente escreve', () {
    final divergem = <String>[];
    final degraus = <String, TextStyle>{
      'display': CoreflowType.display, 'valorHeroi': CoreflowType.valorHeroi,
      'h1': CoreflowType.h1, 'h2': CoreflowType.h2,
      'headlineMd': CoreflowType.headlineMd, 'headlineSm': CoreflowType.headlineSm,
      'title': CoreflowType.title, 'titleMd': CoreflowType.titleMd,
      'body': CoreflowType.body, 'bodyLg': CoreflowType.bodyLg,
      'bodySm': CoreflowType.bodySm, 'bodySmall': CoreflowType.bodySmall,
      'button': CoreflowType.button, 'label': CoreflowType.label,
      'labelLg': CoreflowType.labelLg, 'labelMd': CoreflowType.labelMd,
      'labelSm': CoreflowType.labelSm, 'tileLabel': CoreflowType.tileLabel,
      'mono': CoreflowType.mono, 'monoCaption': CoreflowType.monoCaption,
    };
    degraus.forEach((nome, e) {
      final tamanho = e.fontSize!;
      final conferir = {
        '$nome-size': _px(tamanho),
        '$nome-line-height': _px((e.height ?? 1) * tamanho),
        if (e.fontWeight != null) '$nome-weight': '${e.fontWeight!.value}',
        if (e.letterSpacing != null) '$nome-spacing': _px(e.letterSpacing!),
      };
      conferir.forEach((chave, valor) {
        if (claro['type-$chave'] != valor) {
          divergem.add('$chave: app $valor × web ${claro['type-$chave'] ?? "ausente"}');
        }
      });
    });
    expect(divergem, isEmpty, reason: 'a web escreve diferente do app:\n${divergem.join('\n')}');
  });

  group('os AJUSTES de papel por componente', () {
    // AS TAGS VÊM DO `node_modules` do pacote web, e uma suíte Dart não pode EXIGIR `npm install`:
    // quem clonar o repo e rodar `flutter test` pegaria vermelho por um passo de outra linguagem,
    // que não tem a ver com o que veio fazer.
    //
    // Então a régua é a estreita: **sem as tags, pula — a não ser que haja ajuste declarado.** Com
    // ajuste declarado e sem tags, a emissão sairia vazia e o gate aprovaria em silêncio, que é
    // exatamente a falha que ele existe pra impedir. Aí reprova, e reprova alto.
    final tags = tagsDaWeb();
    final semTags = tags.isEmpty;
    const semTagsPorque = 'sem `npm install` em coreflow_design_system_web não há lista de tags. '
        'Este produto não declara ajuste, então não há o que medir — rode o install para cobrir.';

    setUp(() {
      if (semTags && ContaBold.produto.ajustesDePapel.isNotEmpty) {
        fail('há ajuste declarado e a lista de tags veio vazia: a folha sairia SEM ele e nada '
            'acusaria. Rode `npm install` em coreflow_design_system_web.');
      }
    });
    // O eixo que deixa um produto dizer "neste componente, o papel X passa a ler o Y", com `de` e
    // `para` da mesma família e um motivo declarado. No Flutter é `scheme.comAjustes(...)`; na web é
    // cascata dentro do elemento. Os dois têm que remapear a MESMA coisa.
    //
    // Este produto declara ZERO ajustes hoje, por decisão medida e escrita
    // (`docs/avisos/2026-08-12-o-ajuste-de-papel-RESPOSTA.md`: sem parceiro, não há caso de `marca`;
    // e o único caso de `contraste` a casa já decidiu ao contrário). Um gate que só rodasse contra a
    // lista real passaria sem medir nada — por isso o primeiro teste usa uma lista SINTÉTICA.

    test('o remapeamento da web é o mesmo que o do app', skip: semTags ? semTagsPorque : null, () {
      const ajustes = [
        DilettaAjusteDePapel(
            componente: 'DilettaButton',
            de: 'primary',
            para: 'primaryPressed',
            motivo: MotivoDoAjuste.marca,
            nota: 'sintético, só para o gate medir'),
      ];
      final base = DilettaScheme.light(p);
      final comAjuste = base.comAjustes(ajustes, 'DilettaButton');

      // MOBILE: no componente ajustado, `primary` passa a valer o que `primaryPressed` vale.
      expect(_hex(comAjuste.primary), _hex(base.primaryPressed),
          reason: 'o app não aplicou o ajuste — o eixo do Flutter parou de funcionar');
      // E fora dele, nada muda. Ajuste é por componente, não global.
      expect(_hex(base.primary), isNot(_hex(base.primaryPressed)));

      // WEB: a mesma troca, como alias dentro da tag. Alias e não cor: a folha tem que seguir
      // `primaryPressed` quando ele mudar, e cor copiada aqui divergiria na próxima paleta.
      final css = coreflowAjustesCss(ajustes, tagsWeb: tags);
      expect(css, contains('diletta-button { --cps-primary: var(--cps-primaryPressed); }'),
          reason: 'a web não aplicou o ajuste que o app aplica');
    });

    test('ajuste em peça sem instância web não some calado — some por não existir lá',
        skip: semTags ? semTagsPorque : null, () {
      // `CoreflowSaldo` é do pai e só tem lado Flutter. Ajustar nela não tem o que emitir, e isso
      // não é divergência: é peça que não existe na web. O que seria divergência é uma peça QUE
      // EXISTE ficar de fora — e é isso que a conta abaixo separa.
      const ajustes = [
        DilettaAjusteDePapel(
            componente: 'CoreflowSaldo',
            de: 'surface',
            para: 'surfaceMuted',
            motivo: MotivoDoAjuste.marca,
            nota: 'sintético'),
      ];
      expect(tags.contains(tagDaPeca('CoreflowSaldo')), isFalse);
      expect(coreflowAjustesCss(ajustes, tagsWeb: tags), isEmpty);
    });

    test('nenhum ajuste DESTE produto fica de fora da folha', () {
      // A catraca de verdade: roda contra a lista real. Hoje ela é vazia e isto passa de graça — e
      // no dia em que alguém declarar um ajuste numa peça que EXISTE na web, este teste é o que
      // cobra a folha acompanhar.
      final declarados = ContaBold.produto.ajustesDePapel;
      final deveriamSair =
          declarados.where((a) => tags.contains(tagDaPeca(a.componente))).toList();
      final css = coreflowAjustesCss(declarados, tagsWeb: tags);
      for (final a in deveriamSair) {
        expect(css, contains('${tagDaPeca(a.componente)} { --cps-${a.de}: var(--cps-${a.para}); }'),
            reason: '${a.componente} tem instância web e o ajuste dele não saiu na folha');
      }
    });
  });
}
