// ESCREVE `packages/coreflow_design_system_web/tokens/bold-tokens.css`. **Não é gate** — gate é o
// vizinho `o_css_do_bold_esta_em_dia_test.dart`, que roda na suíte e compara o disco com a fonte.
//
//     flutter test test/emite_o_css_do_bold.dart
//
// Sem `_test` no nome de propósito: `flutter test` não o pega, e emitir arquivo dentro da suíte é
// como um repo começa a ter saída gerada que ninguém sabe quando mudou.
import 'dart:io';

import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// As TAGS que a instância web registra, lidas do `index.js` do pacote do avô.
///
/// A fonte é o pacote, não uma lista nossa: peça nova na tag dele entra aqui sozinha, e peça que
/// sair para de aparecer. Lista paralela é a forma de ficar para trás sem ninguém ver.
Set<String> tagsDaWeb() {
  final f = File('../coreflow_design_system_web/node_modules/diletta-design-system-web/index.js');
  if (!f.existsSync()) return const {};
  return RegExp(r"^\s*'(diletta-[a-z-]+)',", multiLine: true)
      .allMatches(f.readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();
}

/// As famílias que o produto declara, na ordem em que a cascata precisa delas.
String cssDoBold() => [
      coreflowPapeisCss(BoldPalette.bold, produto: 'Conta BOLD'),
      '\n/* O ESQUEMA DESTE PRODUTO — os papéis que o avô não tem. */\n',
      coreflowEsquemaCss(BoldPalette.bold),
      '\n/* MEDIDA por nome. */\n',
      coreflowMedidasCss(BoldPalette.bold),
      '\n/* A ESCALA DE TIPO DESTE PRODUTO. Seis degraus têm px que o avô não tem — decisão escrita\n'
          '   no `///` do `CoreflowType`, não deriva. Os homônimos SOBRESCREVEM os dele. */\n',
      coreflowTipoCss(_degrausDoBold, familia: "'${BoldFonts.familyRaw}', system-ui, sans-serif"),
      '\n/* OS GRADIENTES DESTE PRODUTO. A curva sai do símbolo e a tinta que vai por cima é o\n'
          '   vinho-tinta — com branco, o amarelo daria 1,21:1. */\n',
      coreflowGradientesCss(ContaBold.gradientes),
      '\n/* AS PARADAS DO LOCKUP, soltas. O degradê inteiro não serve a quem precisa de UMA cor\n'
          '   dele: o `BoldBackdrop` do IB digitava `#FE7B5E` e `#FEED35` na folha do componente\n'
          '   porque a parada não tinha nome publicado. As OITO saem, e não só as duas que hoje têm\n'
          '   consumidor — meia rampa publicada é a próxima tela pedindo a que faltou.\n'
          '   Sem bloco de modo: constante de marca não inverte. `dois_gradientes_e_so_test` prende\n'
          '   esta lista ao gradiente, então as duas não divergem. */\n',
      coreflowConstantesCss(_paradasDoLockup),
      // OS AJUSTES POR COMPONENTE, por último: eles redeclaram papel DENTRO de um elemento, então
      // precisam vir depois das declarações de raiz que sobrescrevem. Hoje este produto não declara
      // nenhum e isto sai vazio — o encanamento existe pra que declarar um não peça mais nada.
      _ajustes(),
    ].join();

/// A folha inteira: as famílias, e a PONTE do nome antigo derivada delas.
///
/// A ponte vem por último e é calculada a partir do que saiu acima — token novo em qualquer família
/// ganha alias sozinho, e família que sair leva o alias junto.
String cssDoBoldComPonte() {
  final css = cssDoBold();
  return css + coreflowPonteDoNomeAntigo(css);
}

String _ajustes() {
  final css = coreflowAjustesCss(ContaBold.produto.ajustesDePapel, tagsWeb: tagsDaWeb());
  return css.isEmpty ? '' : '\n/* AJUSTES DE PAPEL POR COMPONENTE. */\n$css';
}

/// As oito paradas da curva do lockup, na ordem do símbolo. É a MESMA lista que
/// `ContaBold.gradientes.primary.colors`, e `dois_gradientes_e_so_test` reprova se as duas
/// divergirem — por isso escrever aqui não cria uma segunda fonte.
const Map<String, Color> _paradasDoLockup = {
  'lockup01': BoldColors.lockup01, 'lockup02': BoldColors.lockup02,
  'lockup03': BoldColors.lockup03, 'lockup04': BoldColors.lockup04,
  'lockup05': BoldColors.lockup05, 'lockup06': BoldColors.lockup06,
  'lockup07': BoldColors.lockup07, 'lockup08': BoldColors.lockup08,
};

/// Os 20 degraus do `CoreflowType`, por nome. A tabela é explícita porque `TextStyle` estático não se
/// enumera por reflexão em Dart — e tabela que alguém esquece de atualizar é melhor que reflexão que
/// ninguém entende: o gate conta os degraus e reprova se a classe crescer sem esta lista crescer.
final Map<String, TextStyle> _degrausDoBold = {
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

void main() {
  test('emite o CSS dos tokens do Bold', () {
    final css = cssDoBoldComPonte();
    final f = File('../coreflow_design_system_web/tokens/bold-tokens.css');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(css);

    final daLinguagem = RegExp(r'--diletta-([A-Za-z0-9_-]+)\s*:').allMatches(css).length;
    // NOME ÚNICO, e não declaração: a folha declara o mesmo papel três vezes (claro, escuro por
    // mídia, escuro por atributo) e a ponte precisa de um alias só para os três — alias segue o
    // seletor. Comparar declaração com apelido foi o primeiro jeito que escrevi, e ele dava 287
    // contra 149 sem que nada estivesse errado.
    Set<String> nomesUnicos(String prefixo) =>
        RegExp('$prefixo([A-Za-z0-9_-]+)\\s*:').allMatches(css).map((m) => m.group(1)!).toSet();
    final nomes = nomesUnicos('--diletta-');
    final apelidos = nomesUnicos('--cps-');
    // Controle negativo: folha curta demais não é erro no navegador, é silêncio.
    expect(daLinguagem, greaterThan(250), reason: 'a folha saiu curta demais pra ser as quatro famílias');
    // A ponte cobre TODO nome: um sem alias é um consumidor lendo vazio, calado — foi assim que os
    // dois meio-passos ficaram mudos na ponte do avô.
    expect(apelidos, nomes, reason: 'a ponte não cobriu todos os nomes emitidos');
    stdout.writeln('escrito: ${f.path} — ${nomes.length} nomes, $daLinguagem declarações, ${apelidos.length} apelidos');
  });
}
