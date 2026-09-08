import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaReceipt, DilettaReceiptRow, DilettaReceiptSection, DilettaSpotState;
import 'package:flutter/widgets.dart';

import 'bold_copiar.dart' show CoreflowCopiar;

/// **CoreflowComprovante** — o comprovante do pai com o ID pronto pra ser levado dali.
///
/// O layout inteiro é do `DilettaReceipt`: spot de estado, título, carimbo de hora, linhas, seções
/// e o rodapé com o ID e o logo. O que este produto acrescenta é UMA coisa, e ela é comportamento:
/// **quando o ID é real, ele vem com copiar.**
///
/// ## Por que a peça existe em vez de o pai fazer sozinho
///
/// O pai tem o `acaoDoId` (slot, `v0.154.0`) e não tem um botão de copiar — copiar com confirmação é
/// peça de produto: o aviso, a permanência dele, o retorno háptico. O slot mantém o layout do rodapé
/// lá e a affordance aqui, e esta peça é o lugar onde as duas se encontram.
///
/// ## O que é um ID REAL
///
/// Seis caracteres e ao menos um alfanumérico. A regra é do time do app e chegou por merge em 02/09,
/// com o caso na mão: as telas escrevem `—`, `-`, `N/A` ou vazio quando não há ID, e sem o crivo o
/// botão apareceria oferecendo copiar um travessão. **Nenhum chamador precisa dizer se o ID dele é
/// real** — é o tipo de pergunta que a peça responde melhor que a tela.
class CoreflowComprovante extends StatelessWidget {
  const CoreflowComprovante({
    super.key,
    required this.title,
    required this.timestamp,
    this.icon = 'circle-check-light',
    this.estado = DilettaSpotState.success,
    this.rows = const [],
    this.sections = const [],
    this.footerLines = const [],
    this.transactionId,
  });

  final String title;
  final String timestamp;
  final String icon;
  final DilettaSpotState estado;
  final List<DilettaReceiptRow> rows;
  final List<DilettaReceiptSection> sections;
  final List<String> footerLines;
  final String? transactionId;

  /// Seis caracteres e ao menos um alfanumérico — o crivo que descarta os marcadores de ausência.
  static bool idCopiavel(String? id) {
    if (id == null) return false;
    final t = id.trim();
    return t.length >= 6 && t.contains(RegExp(r'[0-9A-Za-z]'));
  }

  @override
  Widget build(BuildContext context) => DilettaReceipt(
        title: title,
        timestamp: timestamp,
        icon: icon,
        estado: estado,
        rows: rows,
        sections: sections,
        footerLines: footerLines,
        transactionId: transactionId,
        acaoDoId: idCopiavel(transactionId)
            ? CoreflowCopiar(
                texto: transactionId!,
                rotuloDeAcessibilidade: 'Copiar o ID da transação',
              )
            : null,
      );
}
