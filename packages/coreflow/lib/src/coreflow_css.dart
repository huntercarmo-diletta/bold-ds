import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'coreflow_radius.dart';
import 'coreflow_scheme.dart';

/// A INSTÂNCIA WEB da tinta: os papéis da linguagem, resolvidos com [p], escritos como `--cps-*`.
///
/// Não é uma segunda paleta nem uma segunda derivação. É a MESMA do avô (`dilettaCorDoPapelGen`)
/// rodada com a paleta que chega — por isso nenhum hex é digitado aqui, e por isso papel novo no avô
/// aparece sozinho na próxima emissão.
///
/// Mora no PAI porque todo filho quer isto: quem declara uma cor e recebe os ~59 papéis do lado
/// Flutter tem o mesmo direito do lado web. A função recebe a paleta e não conhece produto nenhum —
/// o gate `o_pacote_nao_crava_a_paleta_do_bold` do filho existe exatamente pra essa linha não voltar.
///
/// O par disto é o `cps-papeis.css` do avô, que tem a MESMA lista de nomes com a tinta de referência.
/// Carregue a dele primeiro e esta depois: `--cps-*` é variável, e variável se sobrescreve. É o white
/// label do lado web, pelo mesmo mecanismo que o Flutter já usa com paleta.
///
/// [produto] entra só no comentário do topo, pra quem abrir o arquivo saber de quem é a tinta.
String coreflowPapeisCss(DilettaPalette p, {required String produto}) {
  final claro = DilettaScheme.light(p);
  final escuro = DilettaScheme.dark(p);

  String bloco(DilettaScheme s, String indent) {
    final linhas = <String>[];
    for (final papel in dilettaNomesDePapelGen) {
      final cor = dilettaCorDoPapelGen(s, papel);
      // Papel sem tinta é ausência declarada (o avô tem dois: `glassStroke`, `skeletonShimmer`), e
      // ausência não vira `--cps-x: ;` — declaração inválida some no navegador sem erro, que é a
      // classe de defeito que o README do pacote web do avô conta ter custado semanas.
      if (cor == null) continue;
      linhas.add('$indent  --cps-$papel: ${_hex(cor)};');
    }
    return linhas.join('\n');
  }

  return '/* GERADO — NÃO editar à mão. Os ${dilettaNomesDePapelGen.length} papéis da linguagem, '
          'com a tinta de $produto.\n'
          '   Carregue DEPOIS das folhas do avô: estas mesmas variáveis, com os valores '
          'deste produto. */\n' +
      _tresBlocos(bloco(claro, ''), bloco(escuro, '  '), bloco(escuro, ''));
}

/// A FORMA das três folhas de modo, e ela é a do avô — `:root`, o `@media` com a guarda de
/// `[data-theme="light"]`, e o `[data-theme="dark"]` que deixa o botão de modo ganhar nos dois
/// sentidos. Uma função só porque as três emissões mode-aware daqui têm que sair idênticas: forma
/// divergente entre folhas é a classe de defeito que ninguém vê até o modo escuro de um produto só.
String _tresBlocos(String claro, String escuroMedia, String escuroAttr) => '''
:root {
$claro
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
$escuroMedia
  }
}

:root[data-theme="dark"] {
$escuroAttr
}
''';

/// `#rrggbb` quando opaco, `#rrggbbaa` quando não — a mesma forma que o avô emite, pra que comparar as
/// duas folhas seja `diff` e não conversão.
String _hex(Color c) {
  final argb = c.toARGB32();
  final rgb = argb.toRadixString(16).padLeft(8, '0').substring(2);
  final alfa = (argb >> 24) & 0xFF;
  return alfa == 0xFF ? '#$rgb' : '#$rgb${alfa.toRadixString(16).padLeft(2, '0')}';
}

/// Os papéis do ESQUEMA DO PRODUTO — os que o avô não tem e o `CoreflowScheme` acrescenta —
/// escritos como `--cps-*`, no mesmo namespace e na mesma forma de três blocos.
///
/// Mesmo namespace de propósito: é UMA língua. O que o filho acrescenta entra ao lado do que o avô
/// declara, e o gate `nenhum papel do produto colide com o do avo` prova que nenhum nome é roubado.
String coreflowEsquemaCss(DilettaPalette p) {
  Map<String, Color> papeis(Brightness b) {
    final s = CoreflowScheme.de(p, brilho: b);
    return {
      'background': s.background, 'secondaryFlow': s.secondaryFlow,
      'textPrimary': s.textPrimary, 'border': s.border, 'overlay': s.overlay,
      'primary': s.primary, 'danger': s.danger, 'infoSubtle': s.infoSubtle, 'vinho': s.vinho,
    };
  }

  String bloco(Brightness b, String i) => papeis(b)
      .entries
      .map((e) => '$i  --cps-${e.key}: ${_hex(e.value)};')
      .join('\n');

  return _tresBlocos(bloco(Brightness.light, ''), bloco(Brightness.dark, '  '),
      bloco(Brightness.dark, ''));
}

/// As MEDIDAS que o produto declara por nome — hoje o raio. Vão como `--cps-radius-*`, e não como
/// `--cps-r<N>`: o avô emite a escada de primitivas, isto é o papel que a peça pede.
///
/// Não é mode-aware, então sai num `:root` só.
String coreflowMedidasCss() {
  final raios = <String, double>{
    'field': CoreflowRadius.field, 'card': CoreflowRadius.card,
    'sheet': CoreflowRadius.sheet, 'pill': CoreflowRadius.pill,
  };
  final linhas = raios.entries
      .map((e) => '  --cps-radius-${e.key}: ${_px(e.value)};')
      .join('\n');
  return ':root {\n$linhas\n}\n';
}

/// A ESCALA DE TIPO do produto, na MESMA forma que o avô emite (`-size`, `-weight`, `-line-height`,
/// `-spacing`), pra que um degrau homônimo SOBRESCREVA o dele em vez de conviver com ele.
///
/// [degraus] é `papel -> estilo`, e quem monta é o produto: a escala é dele (seis px que o avô não
/// tem, por decisão escrita no `///` da classe). O `height` do Flutter é multiplicador; aqui vira px,
/// que é o que o CSS do avô já usa — comparar as duas folhas tem que ser `diff`, não conversão.
String coreflowTipoCss(Map<String, TextStyle> degraus, {required String familia}) {
  final linhas = <String>["  --cps-font-family: $familia;"];
  for (final e in degraus.entries) {
    final s = e.value;
    final tamanho = s.fontSize;
    if (tamanho == null) continue;
    final altura = (s.height ?? 1) * tamanho;
    linhas.add('  --cps-type-${e.key}-size: ${_px(tamanho)};');
    linhas.add('  --cps-type-${e.key}-line-height: ${_px(altura)};');
    if (s.fontWeight != null) {
      linhas.add('  --cps-type-${e.key}-weight: ${s.fontWeight!.value};');
    }
    if (s.letterSpacing != null) {
      linhas.add('  --cps-type-${e.key}-spacing: ${_px(s.letterSpacing!)};');
    }
  }
  return ':root {\n${linhas.join('\n')}\n}\n';
}

/// `16px`, e `22px` — sem `.0` pendurado, que é o que o CSS do avô escreve.
String _px(double v) => v == v.roundToDouble() ? '${v.round()}px' : '${v}px';

