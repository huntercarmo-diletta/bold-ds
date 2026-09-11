import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

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

  return '''
/* GERADO — NÃO editar à mão. Os ${dilettaNomesDePapelGen.length} papéis da linguagem, com a tinta de
   $produto. Carregue DEPOIS das folhas do avô: estas mesmas variáveis, com os valores deste produto. */
:root {
${bloco(claro, '')}
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
${bloco(escuro, '  ')}
  }
}

:root[data-theme="dark"] {
${bloco(escuro, '')}
}
''';
}

/// `#rrggbb` quando opaco, `#rrggbbaa` quando não — a mesma forma que o avô emite, pra que comparar as
/// duas folhas seja `diff` e não conversão.
String _hex(Color c) {
  final argb = c.toARGB32();
  final rgb = argb.toRadixString(16).padLeft(8, '0').substring(2);
  final alfa = (argb >> 24) & 0xFF;
  return alfa == 0xFF ? '#$rgb' : '#$rgb${alfa.toRadixString(16).padLeft(2, '0')}';
}
