import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:diletta_design_system/diletta_design_system.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// O LOGO É DO ARQUIVO E A TINTA É DO TEMA — e as duas coisas convivem no mesmo SVG.
///
/// O lockup CONTA BOLD tem duas partes com regras opostas: **8 `fill` de letra** que viram com o tema
/// e **1 gradiente de 8 paradas** que não vira. O `DilettaLogo` aplicava `ColorFilter.srcIn` no
/// arquivo inteiro, e `srcIn` não tem exceção — o gradiente morria junto com as letras.
///
/// Pedido de 20/08, veredito `ENTRA DIFERENTE` na `ds v0.120.0`: a tinta entra por `currentColor`, e
/// **quem decide o alcance é o arquivo**. O que este produto paga é uma edição por `fill` de letra —
/// e o que ele ganha está medido abaixo: dois arquivos viraram um.
void main() {
  test('a marca está declarada, e o arquivo diz o que pode ser tingido', () {
    expect(CoreflowTheme.marca.pacote, 'coreflow_design_system');
    expect(CoreflowTheme.marca.logoTingePorCurrentColor, isTrue,
        reason: 'sem isto o `ColorFilter` volta e engole o gradiente que o arquivo protege — os '
            'dois caminhos se excluem, e é o veredito que diz');
    expect(CoreflowTheme.light.brand, CoreflowTheme.marca);
    expect(CoreflowTheme.dark.brand, CoreflowTheme.marca);
  });

  test('o arquivo tem as letras em currentColor e o gradiente intacto', () async {
    // A asserção é sobre o ARQUIVO, e é ela que impede a regressão silenciosa: se alguém reexportar
    // do Figma sem a edição, o `currentColor` some, as letras voltam a `black` e o logo fica preto
    // no escuro — sem erro nenhum, porque `black` é um fill válido.
    final svg = await rootBundleDoTeste(
        'packages/coreflow_design_system/assets/logos/conta-bold-lockup.svg');
    expect('currentColor'.allMatches(svg).length, 8,
        reason: 'as 8 letras do lockup precisam dizer `currentColor`. Reexportou do Figma?');
    expect(svg, contains('url(#paint0_linear'),
        reason: 'o "O" perdeu o gradiente — ele é a parte que NÃO vira com o tema');
    // As 8 paradas da curva, conferidas no arquivo: é ele a fonte, e a paleta copia dele.
    for (final parada in ['#FE3976', '#FE7B5E', '#FEA150', '#FEED35']) {
      expect(svg, contains(parada));
    }
    expect(svg.contains('fill="black"'), isFalse,
        reason: 'sobrou letra em preto: ela não vai virar com o tema');
  });

  test('e o mapa da ARTE é hex → NOME de degrau, não hex → cor', () {
    // O veredito do recolor: *"nome sobrevive à troca de paleta, cor não"*. Se este mapa guardasse
    // hex→hex, ele envelheceria na primeira vez que um degrau mudasse — e ninguém saberia, porque o
    // recolor não erra alto: ele deixa passar o que não conhece.
    final mapa = CoreflowTheme.marca.hexesDaArte;
    expect(mapa, isNotEmpty);
    for (final e in mapa.entries) {
      expect(e.key, matches(RegExp(r'^#[0-9a-f]{6}$')),
          reason: 'a chave é o hex COZIDO no arquivo, em minúscula');
      expect(e.value, matches(RegExp(r'^primary0[1-9]$')),
          reason: '${e.value} não é nome de degrau — o valor é o NOME, e é isso que viaja');
    }
    // O tamanho do mapa não é mais um número só: desde 20/08 ele carrega DUAS chaveaduras, porque
    // consumimos arte de dois desenhistas. O que é NOSSO se mede tirando o que é dele — assim o
    // ratchet continua sendo sobre a nossa arte e não empata com o que o pai declara.
    final dele = p.DilettaIllustrationBrand.rampaDe(BoldPalette.bold).keys.toSet();
    final nossos = mapa.keys.where((h) => !dele.contains(h)).toList();
    expect(nossos.length, 7,
        reason: 'os 7 degraus de marca DESTE produto — medidos em 38 artes, 1751 pinturas, '
            '403 delas de marca (o resto é neutro e semântico, fora por regra do pai)');
  });
}

/// Lê um asset do bundle de teste sem depender de `WidgetTester`.
Future<String> rootBundleDoTeste(String chave) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final dados = await rootBundle.loadString(chave);
  return dados;
}
