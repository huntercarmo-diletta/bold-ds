import 'package:conta_bold_catalog/chrome_do_bold.dart';
import 'package:conta_bold_catalog/conteudo_do_bold.dart';
import 'package:conta_bold_catalog/ds_do_bold.dart';
import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ABA DE SPECS é do MOTOR desde a v0.45.0, e este teste passou a medir o que é MEU nela: a
/// declaração.
///
/// A minha versão media um sentido — "esta spec tem bloco?" — e chamava a outra metade de "sem bloco
/// aqui", que é a mesma informação com nome de culpa. A dele mede os dois e diz na tela que **contrato sem
/// bloco não é dívida**: é vocabulário que existe e este produto não usou.
///
/// O que sobra pra mim medir: que o conjunto declarado (`contratos` + `contratosDisponiveis`) chega
/// completo, e que nenhuma spec é copiada — a do pai é a string do pacote dele.
void main() {
  setUpAll(() {
    configurarChromeDoBold();
    configurarDsDoBold();
    configurarConteudoDoBold();
  });

  /// `Scaffold` porque é o que a casca do pai monta — e é dele que vem o `Material` que a tinta do
  /// card exige. Harness que não espelha a casca acusa defeito que a tela real não tem: foi assim que
  /// eu quase carreguei um `Material` pra sempre dentro do card de componentes.
  test('a DECLARAÇÃO chega inteira — é o que é meu nesta aba', () {
    // 56 blocos, e a cobertura de contrato é o número que a aba mostra no topo.
    final comContrato = Ds.blocos.keys.where((t) => Ds.contratoDe(t) != null).length;
    // O que se mede é a LACUNA e não um piso: `>= 52` com 55 medidos deixava três blocos poderem
    // perder o contrato sem nada reprovar. A lacuna é estável quando o registro cresce — bloco novo COM
    // contrato não mexe nela, bloco novo SEM contrato reprova, que é a única coisa que este número diz.
    expect(Ds.blocos.length - comContrato, 1,
        reason: 'a cobertura de contrato caiu: $comContrato de ${Ds.blocos.length}');

    // O conjunto DISPONÍVEL é o que permite a outra ponta ("contrato sem bloco"). Sem ele declarado, a
    // aba diz explicitamente que não pode medir essa metade — e mostrar zero não-usados seria afirmar
    // "você usa tudo", que é o que o motor não sabe.
    expect(Ds.atual.contratosDisponiveis, hasLength(kDilettaSpecs.length + kBoldSpecs.length));
    for (final k in kBoldSpecs.keys) {
      expect(Ds.atual.contratosDisponiveis, contains(k),
          reason: 'o contrato "$k" deste filho não entrou no conjunto disponível');
    }
  });

  test('NÃO copia spec: a do pai é a string do PACOTE dele', () {
    // A garantia é de identidade, não de conteúdo: `same()` prova que é o mesmo objeto, então não há
    // cópia envelhecendo em dois lugares.
    expect(Ds.atual.contratosDisponiveis['design-system-button'],
        same(kDilettaSpecs['design-system-button']));
    expect(kDilettaSpecs['design-system-button'], contains('SHALL'));
  });
}
