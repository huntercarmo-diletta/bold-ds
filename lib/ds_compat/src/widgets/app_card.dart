import 'package:flutter/material.dart';

/// Conta BOLD — helpers de card.
///
/// O card/tile com tokens light (AppCard widget, TransactionTile, BalanceCard)
/// foi removido: não era usado e usava a paleta clara, fora do padrão dark do
/// design system. Mantido apenas o divisor, usado em vários blocos chave-valor.
abstract final class AppCard {
  /// Divisor fino para separar linhas dentro de um bloco.
  static Widget divider() =>
      Divider(color: Colors.white.withAlpha(18), thickness: 1, height: 12);
}
