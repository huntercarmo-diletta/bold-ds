import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// A RAMPA É LEGÍVEL EM `const` — e **a asserção é a COMPILAÇÃO**.
///
/// As três declarações abaixo não têm corpo de teste nenhum. Elas existem porque, se alguém
/// "simplificar" a rampa de volta pra dentro do construtor da paleta, **este arquivo não
/// compila** — e falhar em compilação é o mais alto que um gate falha.
///
/// O erro que ele impede tem nome:
///
/// ```
/// The property 'primary04' can't be accessed on the type 'DilettaPalette'
/// in a constant expression • const_eval_property_access
/// ```
///
/// Veio do veredito ENTRA COMO FORMA do pai (`ds v0.25.0`), e o custo que sustentou o pedido
/// foi medido no app real: 84 constantes copiadas, 51 linhas `const` que quebrariam com
/// `static final`, 427 chamadas que perderiam o `const`.
class _ConsumidorQueDeriva {
  /// Se a rampa deixar de ser `static const`, esta linha não compila.
  static const Color acao = BoldColors.primary04;

  /// E esta prova o caso que interessa de verdade: cor de pacote dentro de um widget `const`.
  static const BoxDecoration caixa = BoxDecoration(color: BoldColors.primary08);

  static const List<Color> rampaInteira = [
    BoldColors.primary01,
    BoldColors.neutral10,
    BoldColors.success04,
    BoldColors.warning04,
    BoldColors.error04,
    BoldColors.secure04,
  ];
}

void main() {
  test('a paleta é a MESMA COISA que a rampa, e não uma cópia que combina', () {
    const p = BoldPalette.bold;

    // Se alguém reescrever um hex dentro do construtor da paleta, isto pega. É a segunda
    // metade do gate: a de cima prova que dá pra derivar, esta prova que a paleta derivou.
    expect(p.primary01, BoldColors.primary01);
    expect(p.primary03, BoldColors.primary03);
    expect(p.primary04, BoldColors.primary04);
    expect(p.primary08, BoldColors.primary08);
    expect(p.neutral01, BoldColors.neutral01);
    expect(p.neutral10, BoldColors.neutral10);
    expect(p.success03, BoldColors.success03);
    expect(p.warning02, BoldColors.warning02);
    expect(p.error04, BoldColors.error04);
    expect(p.errorBanner, BoldColors.errorBanner);
    expect(p.secure04, BoldColors.secure04);
    expect(p.bgEscuro, BoldColors.bgEscuro);
    expect(p.tinteDeVidroEscuro, BoldColors.tinteDeVidroEscuro);
    expect(p.tracoDeVidroClaro, BoldColors.tracoDeVidroClaro);
  });

  test('o consumidor deriva sem perder `const`', () {
    expect(_ConsumidorQueDeriva.acao, BoldPalette.bold.primary04);
    expect(_ConsumidorQueDeriva.caixa.color, BoldPalette.bold.primary08);
    expect(_ConsumidorQueDeriva.rampaInteira, hasLength(6));
  });

  test('os três degraus consertados por AA continuam consertados', () {
    // Eles voltariam sozinhos se alguém restaurasse a rampa do app antigo por engano.
    expect(BoldColors.primary03.toARGB32(), 0xFF9E1241); // era #CC1E58
    expect(BoldColors.success03.toARGB32(), 0xFF157A45); // era #1E8F4E
    expect(BoldColors.warning02.toARGB32(), 0xFF85520A); // era #8F5A06

    // E a rampa de sucesso volta a SUBIR: o 03 é mais escuro que o 04.
    expect(
      BoldColors.success03.computeLuminance(),
      lessThan(BoldColors.success04.computeLuminance()),
      reason: 'o 03 escreve sobre o wash; mais claro que o 04 é a inversão que reprovava',
    );
  });
}
