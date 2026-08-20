import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O NETO MONTA O TEMA INTEIRO — e até 20/08 ele parava na porta com a chave na mão.
///
/// O gate vizinho (`o_neto_troca_a_paleta_e_pronto`) mede 35 papéis do [BoldScheme] viajando com
/// dívida zero, e ele está certo — sobre o ESQUEMA. O que ele nunca mediu é o que vem depois: o
/// `ThemeData` do Material, que é o que pinta botão, campo, card e divisor, e é de onde saem os
/// ~500 `BoldColors.of(context)`.
///
/// A porta era `_monta`, privada. [BoldScheme.de] aceita paleta desde a v0.55.0 e não havia nada
/// acima dele que aceitasse: um produto novo montava o esquema com a paleta dele e não conseguia
/// registrá-lo. Desde 20/08 quem responde é o [BoldProduto], e este gate mede o que sai dele.
void main() {
  /// O neto: a paleta de referência do pai, que é VERDE. Não é um verde inventado aqui — é a paleta
  /// que o pai mantém, então este teste acompanha o contrato dele sem eu copiar campo.
  final neto = BoldProduto(
    paleta: DilettaPalette.referencia,
    marca: BoldProduto.marcaDoBold,
  );

  /// Tudo que é cor de MARCA do Conta BOLD. Se um destes valores aparecer no tema do neto, é rosa
  /// vazando — e vazar é literal, porque nenhuma paleta produz estes hexes por derivação.
  final rosaDoBold = <Color, String>{
    BoldColors.primary01: 'primary01', BoldColors.primary02: 'primary02',
    BoldColors.primary03: 'primary03', BoldColors.primary04: 'primary04',
    BoldColors.primary05: 'primary05', BoldColors.primary06: 'primary06',
    BoldColors.primary07: 'primary07', BoldColors.primary08: 'primary08',
    BoldColors.primary09: 'primary09',
    BoldColors.primaryStateSelected: 'primaryStateSelected',
    BoldColors.primaryStateHover: 'primaryStateHover',
    BoldVinho.marca: 'BoldVinho.marca',
    BoldVinho.ink: 'BoldVinho.ink',
    BoldVinho.lavagem: 'BoldVinho.lavagem',
  };

  /// Os sítios de cor do `ThemeData` que este DS declara. Lista explícita, e é de propósito: varrer
  /// o `ThemeData` inteiro por reflexão traria os 40 defaults do Material, que não são nossos.
  Map<String, Color?> sitios(ThemeData t) => {
        'colorScheme.primary': t.colorScheme.primary,
        'colorScheme.onPrimary': t.colorScheme.onPrimary,
        'colorScheme.secondary': t.colorScheme.secondary,
        'colorScheme.surface': t.colorScheme.surface,
        'colorScheme.error': t.colorScheme.error,
        'scaffoldBackgroundColor': t.scaffoldBackgroundColor,
        'dividerColor': t.dividerColor,
        'iconTheme.color': t.iconTheme.color,
        'cardTheme.color': t.cardTheme.color,
        'bottomSheetTheme.backgroundColor': t.bottomSheetTheme.backgroundColor,
        'textButtonTheme.foreground':
            t.textButtonTheme.style?.foregroundColor?.resolve({}),
        'inputDecorationTheme.fill': t.inputDecorationTheme.fillColor,
        'inputDecorationTheme.focused': _borda(t.inputDecorationTheme.focusedBorder),
        'inputDecorationTheme.enabled': _borda(t.inputDecorationTheme.enabledBorder),
      };

  for (final escuro in [false, true]) {
    test('o ThemeData do neto não tem rosa do Bold — ${escuro ? 'escuro' : 'claro'}', () {
      final tema = escuro ? neto.materialEscuro : neto.materialClaro;
      final vazou = <String>[];
      sitios(tema).forEach((onde, cor) {
        final nome = cor == null ? null : rosaDoBold[cor];
        if (nome != null) vazou.add('$onde = $nome');
      });
      expect(vazou, isEmpty,
          reason: 'o neto trocou a paleta e o tema do Material saiu no rosa do Bold:\n'
              '${vazou.join("\n")}');
    });
  }

  test('e o controle: o tema do BOLD tem esses valores, senão a varredura olha pro nada', () {
    // Asserção de ausência passa sozinha quando não há o que encontrar. Este é o par: os mesmos
    // sítios, no produto de verdade, TÊM que bater no rosa.
    final achou = sitios(BoldProduto.bold.materialClaro)
        .values
        .where((c) => c != null && rosaDoBold.containsKey(c))
        .length;
    expect(achou, greaterThanOrEqualTo(3),
        reason: 'a varredura não achou rosa nem no Bold — ela está olhando pros sítios errados');
  });

  test('e os dois temas do neto saem da paleta DELE, não de duas paletas diferentes', () {
    // A invariante que o `///` do BoldTemaMaterial declarava em prosa: o par claro/escuro sai do
    // mesmo objeto, então não existe caminho que monte um de uma paleta e o outro de outra.
    expect(neto.claro.palette, same(neto.escuro.palette));
    expect(neto.claro.palette, same(neto.paleta));
  });

  test('o VINHO do neto é dele — e ele era o eixo de marca que não viajava', () {
    // O rosa do Bold mora em `primary01..09` e viaja pela paleta desde a v0.55.0. O VINHO — o
    // segundo eixo da identidade, que pinta o vidro escuro, o ladrilho de ícone e o polo frio dos
    // fundos — morava em três `static const` de `BoldVinho`, lidas direto por 8 sítios do pacote.
    // Um produto novo declarava a paleta dele e recebia o vinho do Bold.
    //
    // Agora são `papeisExtras`, que é o que o pai criou pra vocabulário que a linguagem não tem.
    final comVinhoProprio = DilettaPalette.referencia.comMaterial(papeisExtras: {
      'vinhoMarca': const DilettaPapelExtra(
          claro: Color(0xFF0B4F3A), escuro: Color(0xFF0B4F3A), significado: 'o vinho do neto'),
      'vinhoTinta': const DilettaPapelExtra(
          claro: Color(0xFF04160F), escuro: Color(0xFF04160F), significado: 'a tinta do neto'),
      'vinhoLavagem': const DilettaPapelExtra(
          claro: Color(0xFF0A2C1F), escuro: Color(0xFF0A2C1F), significado: 'a lavagem do neto'),
    });
    final dele = BoldProduto(paleta: comVinhoProprio, marca: BoldProduto.marcaDoBold);

    expect(dele.esquemaClaro.vinho, const Color(0xFF0B4F3A));
    expect(dele.esquemaClaro.vinhoTinta, const Color(0xFF04160F));
    expect(dele.esquemaEscuro.vinhoLavagem, const Color(0xFF0A2C1F));

    // E o Bold continua com o dele, sem declarar nada além do que já declarava.
    expect(BoldProduto.bold.esquemaClaro.vinho, BoldVinho.marca);
  });

  test('e quem NÃO declara o vinho cai no do Bold, em vez de estourar', () {
    // Degradação, não exceção: uma paleta incompleta desenha com o valor deste produto. É a mesma
    // regra dos outros quatro `papeisExtras`, e o gate existe porque a alternativa silenciosa
    // (`null` virando transparente) some na tela em vez de aparecer no console.
    expect(neto.esquemaClaro.vinho, BoldVinho.marca);
  });

  test('o GRADIENTE do neto é o dele — a curva do símbolo não serve duas marcas', () {
    final curvaDele = const BoldGradients(
      paleta: DilettaPalette.referencia,
      paradasDoLockup: [Color(0xFF0E7C5F), Color(0xFF17A37D)],
      offsetsDoLockup: [0, 1],
      tintaSobreOGradiente: Color(0xFF04160F),
    );
    final dele = BoldProduto(
        paleta: DilettaPalette.referencia,
        marca: BoldProduto.marcaDoBold,
        gradientes: curvaDele);

    expect(dele.gradientes.primary.colors, curvaDele.paradasDoLockup);
    expect(dele.gradientes.onGradient, const Color(0xFF04160F));
    // Controle: sem declarar, ele recebe a curva do Bold — 8 paradas, e a primeira é o rosa.
    expect(neto.gradientes.primary.colors.length, 8);
    expect(neto.gradientes.primary.colors.first, BoldColors.lockup01);
  });

}

Color? _borda(InputBorder? b) => b is OutlineInputBorder ? b.borderSide.color : null;
