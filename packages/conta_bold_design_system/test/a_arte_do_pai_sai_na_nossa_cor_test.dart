import 'dart:convert';
import 'dart:io';

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_design_system/diletta_design_system.dart' as p;
import 'package:flutter_test/flutter_test.dart';

/// A ARTE DO PAI SAI NA NOSSA COR — e o mapa que declara um lado desliga o outro.
///
/// Em 20/08 `key_word` e `no_data` passaram a ser a peça DELE. O que eu não medi naquele dia: o
/// `rampaDe` é **exclusivo**, não aditivo — `if (declarado.isNotEmpty)` devolve só o mapa do filho e
/// a tabela de fallback do pai (a que traduz o azul do primeiro filho) **nunca roda**. Declarar os 7
/// hexes do nosso rosa, portanto, foi o que fez o azul dele atravessar inteiro: 33 pinturas saindo
/// azuis num app rosa, sem erro, sem log, sem gate — o gate que existia media o TIPO do widget e o
/// tamanho da caixa, e o nome dele já dizia "recolore pra nossa paleta".
///
/// Regra que fica: **o mapa é indexado por quem DESENHOU.** Consumir arte de dois desenhistas
/// significa carregar as duas chaveaduras.
void main() {
  /// Onde o pacote do pai foi resolvido — lido do package_config, não do hash do cache.
  String raizDoPai() {
    final cfg = jsonDecode(File('.dart_tool/package_config.json').readAsStringSync());
    final pkg = (cfg['packages'] as List)
        .firstWhere((e) => e['name'] == 'diletta_design_system');
    return Uri.parse(pkg['rootUri'] as String).toFilePath();
  }

  final rampa = p.DilettaIllustrationBrand.rampaDe(BoldPalette.bold, marca: BoldTheme.marca);
  final tabelaDele = p.DilettaIllustrationBrand.rampaDe(BoldPalette.bold);

  test('a nossa rampa cobre TODO hex que o pai declara como marca', () {
    // A tabela de fallback dele é a declaração autoritativa de "estes hexes são de marca". Ela morre
    // em 20/09 junto com a obrigatoriedade do `marca:` — quando isso acontecer, este gate perde a
    // fonte e vira lista literal, e a lista tem que vir do CHANGELOG dele, não da minha memória.
    final descobertos = tabelaDele.keys.where((h) => !rampa.containsKey(h)).toList();
    expect(descobertos, isEmpty,
        reason: 'hex de marca do pai fora do nosso mapa passa DIRETO e sai azul: $descobertos');
  });

  test('e nenhuma das artes dele que nós montamos sai com azul de marca', () {
    // As duas que adotamos, nos dois temas. Arte de verdade, do caminho de verdade.
    final dir = Directory('${raizDoPai()}/assets/illustrations');
    final arquivos = ['key_word_light', 'key_word_dark', 'no_data_light', 'no_data_dark'];
    var pinturasTraduzidas = 0;

    for (final nome in arquivos) {
      final cru = File('${dir.path}/$nome.svg').readAsStringSync();
      final saida = p.DilettaIllustrationBrand
          .apply(cru, BoldPalette.bold, marca: BoldTheme.marca)
          .toLowerCase();

      for (final hex in tabelaDele.keys) {
        expect(saida.contains('"$hex"'), isFalse,
            reason: '$nome ainda pinta $hex — é o azul do primeiro filho num app rosa');
        pinturasTraduzidas += RegExp('"$hex"').allMatches(cru.toLowerCase()).length;
      }
    }

    // Controle: se o número cair a zero, o teste acima passa por não ter o que traduzir.
    expect(pinturasTraduzidas, greaterThan(20),
        reason: 'as quatro artes tinham 33 pinturas de marca; zero aqui significa gate cego');
  });

  test('o mapa não inventa nome de degrau — todo destino existe na paleta', () {
    // `rampaDe` IGNORA em silêncio nome que a paleta não tem (a linha some do mapa em vez de pintar
    // errado). Então o tamanho do mapa é a prova: 17 declarados, 17 resolvidos.
    expect(rampa.length, BoldTheme.marca.hexesDaArte.length,
        reason: 'entrada que sumiu é nome de degrau que a paleta não conhece');
  });
}
