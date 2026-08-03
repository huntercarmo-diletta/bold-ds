// GERADO pelo board do catálogo (Salvar setas no repo). NÃO editar à mão.
//
// As SAÍDAS de cada fluxo: de qual componente sai, pra qual tela vai e com que
// motion. Antes disto a edição vivia no localStorage do navegador de quem
// editou — não era versionada, não era revisável e morria com o cache.
// Ver docs/ADR-001.
//
// Fluxo AUSENTE deste mapa continua DERIVADO da ordem das telas: editar é
// opt-in, e "restaurar derivadas" é apagar a entrada.

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

const Map<String, List<Ligacao>> kLigacoes = {
  'pf/conta-pf': [
    Ligacao(de: 0, para: 1, tipo: TipoConexao.push, bloco: 'b_4'),
    Ligacao(de: 1, para: 2, tipo: TipoConexao.push, bloco: 'b_7'),
    Ligacao(de: 2, para: 3, tipo: TipoConexao.push, bloco: 'b_11'),
  ],
};
