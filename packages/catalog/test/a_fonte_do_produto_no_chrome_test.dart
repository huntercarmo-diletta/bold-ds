import 'package:conta_bold_catalog/main.dart';
import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A FONTE DO PRODUTO NO CHROME — e ela faltava desde o primeiro dia.
///
/// `BoldFonts` tinha **zero consumidores** neste repo: o catálogo publicado desenhava um DS cuja tipografia
/// ele DOCUMENTA em Styles usando a fonte padrão do navegador. Nada falhava, e a página seguia dizendo
/// "Inter" enquanto pintava outra coisa — a classe de defeito mais silenciosa que este catálogo já teve, e a
/// mais visível pra quem abre.
///
/// O gancho é do pai desde sempre (`ConfigDoCatalogo.fonte`, *"vem do DS do filho"*). Eu achei porque os
/// meus gates de layout mediam texto 76% mais largo que o real, e fui atrás do porquê.
void main() {
  test('o chrome declara a família do DS, com o prefixo do pacote', () {
    final cfg = configDoCatalogoDoBold();

    expect(cfg.fonte, BoldFonts.family,
        reason: 'sem isto o chrome do catálogo sai na fonte do navegador');

    // O PREFIXO é o ponto, e não detalhe: o arquivo mora no pacote do DS, então pro engine a família é
    // `packages/<pacote>/<família>`. `Inter` cru só resolveria se o catálogo declarasse as fontes outra
    // vez — cópia de asset, que é o que a fronteira entre os dois pacotes existe pra evitar.
    expect(cfg.fonte, startsWith('packages/'));
    expect(cfg.fonte, endsWith(BoldFonts.familyRaw));
  });

  testWidgets('e o texto do chrome RENDERIZA com ela', (t) async {
    // Declarar não é pintar. Este gate mede a largura de um texto na família declarada contra a largura do
    // MESMO texto sem família: na fonte quadrada do `flutter_test` todo glifo é 1em, então se a família
    // não chegou os dois números são iguais.
    t.view.physicalSize = const Size(1400, 900);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    const texto = 'Componentes';
    double largura(String? familia) => (TextPainter(
          text: TextSpan(
            text: texto,
            style: TextStyle(fontFamily: familia, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        )..layout())
            .width;

    final semFamilia = largura(null);
    final comFamilia = largura(configDoCatalogoDoBold().fonte);

    expect(comFamilia, lessThan(semFamilia * 0.9),
        reason: 'a família declarada não mudou a métrica: ela não carregou, e o chrome está na fonte '
            'quadrada (sem=$semFamilia com=$comFamilia)');
  });
}
