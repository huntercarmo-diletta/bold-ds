import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A BARRA DE TOPO NÃO TEM MAIS SLOT CRU — o gate mudou de repo junto com a peça.
///
/// Ele morava em `app-newbold/test/a_casca_de_topo_e_a_do_pai_test.dart` e media um arquivo de
/// `lib/design_system/` do app. Em 01/09 a barra veio pra cá como `CoreflowBarraDeTopo`, e um gate
/// que lê fonte só funciona no repo onde a fonte está — do outro lado ele viraria um caminho
/// relativo que depende de quem tem os dois repos lado a lado.
void main() {
  test('a API CRUA morreu — e com ela a segunda cópia da barra do pai', () {
    // `CoreflowBarraDeTopo(leading:, title:, trailing:)` montava um `Container(height: 52)` com padding 20 e
    // `fontSize: 17` cravado: a mesma barra do pai, copiada, no caminho que ninguém olhava. Dois usos,
    // os dois cabiam nos acessórios dele. Este teste é de FONTE porque a ausência de construtor não
    // se mede em árvore — e sem ele o caminho volta na primeira tela que precisar de um slot custom.
    // A FONTE MUDOU DE REPO em 01/09: a barra foi pro pacote como `CoreflowBarraDeTopo`, junto com
    // o resto da camada de DS do app. O gate segue lendo fonte — a ausência de construtor não se
    // mede em árvore —, e o caminho é o do pacote resolvido, não um caminho relativo que só existe
    // na máquina de quem tem os dois repos lado a lado.
    final fonte = File('lib/src/bold_barra_de_topo.dart').readAsStringSync();
    expect(fonte.contains('_rawBar'), isFalse,
        reason: 'a barra copiada voltou — os acessórios do pai cobrem leading/trailing');
    expect(fonte.contains('this.leading'), isFalse,
        reason: 'o construtor de slots crus voltou, e ele é a porta pela qual a cópia entra');
    // O degrau cravado não se mede aqui: `o_titulo_da_barra_tem_o_papel_do_pai_test` mede o
    // `fontSize` REAL em runtime. Medir a string na fonte reprovaria no comentário que conta a
    // história — e gate que reprova por prosa é gate que alguém desliga.
  });
}
