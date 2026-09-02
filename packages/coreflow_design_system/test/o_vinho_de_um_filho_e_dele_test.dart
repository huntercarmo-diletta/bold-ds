import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O VINHO DE UM FILHO É DELE — e o defeito que este gate fecha estava vivo.
///
/// O `daMarca` copiava `BoldPalette.bold.papeisExtras` inteiro pro filho, e três daqueles papéis são
/// o vinho: `vinhoMarca`, `vinhoLavagem`, `vinhoTinta`. Eles são a marca do Bold escurecida — então
/// **um banco verde nascia com o vidro escuro vermelho**, e a tela de login recorrente dele saía
/// Bold.
///
/// Achado em 01/09 pelo gate do lado do app (`o_app_recebe_um_filho_test`), que montou o mesmo
/// pedaço de tela com os dois produtos: as peças resolviam o verde em `primary*` e o vinho do Bold
/// em `vinhoTinta`. **Duas rotas pro mesmo material, e só uma derivava** — o `CoreflowVidro.tinte`
/// já saía da paleta desde a `v0.4.0` do pai.
void main() {
  final verde = CoreflowProduto.daMarca(
      marca: const Color(0xFF1B5E20), id: 'bancoVerde', nome: 'Banco Verde');

  test('o Bold não muda um pixel — ele DECLARA os três', () {
    // A derivação só alcança quem não declarou. O Bold declara, e o declarado ganha.
    final s = CoreflowProduto.bold.esquemaEscuro;
    expect(s.vinho, BoldVinho.marca);
    expect(s.vinhoTinta, BoldVinho.ink);
    expect(s.vinhoLavagem, BoldVinho.lavagem);
  });

  test('e o filho ganha o vinho DELE, nos mesmos pontos da rampa', () {
    final s = verde.esquemaEscuro;
    for (final par in [
      ('vinho', s.vinho, BoldVinho.marca),
      ('vinhoTinta', s.vinhoTinta, BoldVinho.ink),
      ('vinhoLavagem', s.vinhoLavagem, BoldVinho.lavagem),
    ]) {
      expect(par.$2, isNot(par.$3), reason: '${par.$1} do filho é o do Bold');
      // O matiz do filho é verde: o canal verde manda, e no vinho do Bold manda o vermelho.
      expect(par.$2.g, greaterThanOrEqualTo(par.$2.r),
          reason: '${par.$1} do filho não puxou pro verde da marca dele');
    }
  });

  test('e a claridade dos três é a mesma que o Bold tem — a POSIÇÃO é que viaja', () {
    // A regra não é "escureça um pouco": são três pontos medidos na rampa do Bold, que reproduzem
    // os hexes dele com erro zero. É isso que faz a derivação descrever em vez de aproximar.
    double luz(Color c) => 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b;
    final bold = CoreflowProduto.bold.esquemaEscuro;
    final filho = verde.esquemaEscuro;
    // O verde é MAIS CLARO que o rosa na mesma posição de rampa — o matiz muda a luminância —, mas
    // a ORDEM dos três tem que ser a mesma nos dois: marca > lavagem > tinta.
    expect(luz(bold.vinho), greaterThan(luz(bold.vinhoLavagem)));
    expect(luz(bold.vinhoLavagem), greaterThan(luz(bold.vinhoTinta)));
    expect(luz(filho.vinho), greaterThan(luz(filho.vinhoLavagem)));
    expect(luz(filho.vinhoLavagem), greaterThan(luz(filho.vinhoTinta)));
  });
}
