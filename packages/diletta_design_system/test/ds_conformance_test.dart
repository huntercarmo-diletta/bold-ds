import 'package:diletta_design_system/src/conformance/ds_conformance.dart';
import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// O PAI RODA A PRÓPRIA CONFORMIDADE — e o CPF é o primeiro filho.
///
/// Ver `docs/ADR-003`. As checagens moram em `lib/conformance/` justamente pra um
/// DS-filho poder importar e rodar contra os PRÓPRIOS tokens; este arquivo é o
/// exemplo de como o filho faz (são cinco linhas).
void main() {
  /// DÍVIDA CONHECIDA da paleta CPF: **nenhuma**.
  ///
  /// Em 2026-07-28 esta lista tinha SETE pares `role.color` sobre `role.subtle`
  /// abaixo de AA de texto — o pior era `secure` em 1.79:1 (texto amarelo em fundo
  /// amarelo) e a tag de `warning` em 2.16:1, num componente publicado.
  ///
  /// O conserto NÃO foi mexer na identidade: foi separar os papéis. A cor sólida
  /// do role serve `onColor`; o texto sobre o tinte agora tem `onSubtle` próprio,
  /// medido por família. O `primary` já tinha esse par (`onPrimarySubtle`) — as
  /// outras famílias é que estavam faltando.
  ///
  /// A lista fica aqui, vazia, de propósito: é o lugar onde uma dívida nova
  /// apareceria, e o teste abaixo exige que ela seja EXATAMENTE a medida.
  const dividaCpf = <String>{};

  test('a paleta CPF não tem violação NOVA', () {
    final v = violacoesDeConformidade(DilettaPalette.referencia, baseline: dividaCpf);
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('a dívida congelada é exatamente a medida (nem mais, nem menos)', () {
    // Baseline que não encolhe vira desculpa permanente. Este teste é o que
    // obrigou a esvaziar a lista quando os sete pares foram consertados.
    final todas =
        todasAsViolacoes(DilettaPalette.referencia).map(chaveDeViolacao).toSet();
    expect(todas, dividaCpf,
        reason: 'a dívida mudou: se melhorou, tire da lista; se piorou, é '
            'violação nova e precisa de conserto');
  });

  test('as regras PEGAM um filho quebrado (senão a suíte é decoração)', () {
    // Paleta com a rampa neutra INVERTIDA: é o erro que um filho comete ao
    // preencher os tokens sem entender a direção da rampa (01 = tinta).
    const cpf = DilettaPalette.referencia;
    final quebrada = DilettaPalette(
      id: 'quebrada',
      partnerPrimary: cpf.partnerPrimary,
      partnerOnPrimary: cpf.partnerOnPrimary,
      partnerSurface: cpf.partnerSurface,
      primary01: cpf.primary01,
      primary02: cpf.primary02,
      primary03: cpf.primary03,
      primary04: cpf.primary04,
      primary05: cpf.primary05,
      primary06: cpf.primary06,
      primary07: cpf.primary07,
      primary08: cpf.primary08,
      primary09: cpf.primary09,
      primaryStateSelected: cpf.primaryStateSelected,
      primaryStateHover: cpf.primaryStateHover,
      onPrimary: cpf.onPrimary,
      // AO CONTRÁRIO: 01 claro, 10 escuro.
      neutral01: cpf.neutral10,
      neutral02: cpf.neutral09,
      neutral03: cpf.neutral08,
      neutral04: cpf.neutral07,
      neutral05: cpf.neutral06,
      neutral06: cpf.neutral05,
      neutral07: cpf.neutral04,
      neutral08: cpf.neutral03,
      neutral09: cpf.neutral02,
      neutral10: cpf.neutral01,
      white: cpf.white,
      black: cpf.black,
      error01: cpf.error01, error02: cpf.error02, error03: cpf.error03,
      error04: cpf.error04, error05: cpf.error05, error06: cpf.error06,
      error07: cpf.error07,
      errorBanner: cpf.errorBanner,
      warning01: cpf.warning01, warning02: cpf.warning02,
      warning03: cpf.warning03, warning04: cpf.warning04,
      warning05: cpf.warning05, warning06: cpf.warning06,
      warning07: cpf.warning07,
      success01: cpf.success01, success02: cpf.success02,
      success03: cpf.success03, success04: cpf.success04,
      success05: cpf.success05, success06: cpf.success06,
      success07: cpf.success07,
      secure02: cpf.secure02, secure03: cpf.secure03, secure04: cpf.secure04,
      secure05: cpf.secure05, secure07: cpf.secure07, secure08: cpf.secure08,
    );
    final v = violacoesDeConformidade(quebrada);
    expect(v, isNotEmpty,
        reason: 'a suíte não pegou uma paleta com rampa invertida — então ela '
            'não protege filho nenhum');
    expect(v.map((x) => x.regra), contains('rampa-neutra'));
  });

  test('cada violação diz O QUE ELA EVITA (senão alguém afrouxa o alvo)', () {
    // A regra existir não basta: quem for "consertar" precisa ler o erro que ela
    // guardava, senão o conserto é baixar o mínimo.
    for (final v in todasAsViolacoes(DilettaPalette.referencia)) {
      expect(v.porQue.length, greaterThan(20));
    }
    // E o toString tem que ser colável num relatório.
    const amostra = ViolacaoDeConformidade(
        regra: 'r', onde: 'o', detalhe: 'd', porQue: 'p que explica bastante');
    expect(amostra.toString(), contains('evita:'));
  });
}
