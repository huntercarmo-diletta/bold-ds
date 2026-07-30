import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';

/// CPF SEGURO — Divider (hairline).
///
/// Encapsula a linha divisória com a cor por **token de tema** (`s.divider` —
/// neutral-09 no light, branco @8% no dark). Substitui o `Divider`/
/// `VerticalDivider` crus (cor/espessura na mão), fechando o drift e habilitando
/// rebrand (a cor é do tema, não hardcoded).
///
/// - `DilettaDivider()` — horizontal (preenche a largura).
/// - `DilettaDivider.vertical()` — vertical (use em contexto de altura
///   limitada, ex.: dentro de um `Row`/`IntrinsicHeight`).
///
/// `indent`/`endIndent` recuam as pontas (use tokens de espaçamento).
class DilettaDivider extends StatelessWidget {
  const DilettaDivider({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.thickness = 1,
  }) : _vertical = false;

  const DilettaDivider.vertical({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.thickness = 1,
  }) : _vertical = true;

  /// Recuo no início (esquerda no horizontal, topo no vertical).
  final double indent;

  /// Recuo no fim (direita no horizontal, base no vertical).
  final double endIndent;

  /// Espessura da linha (default 1).
  final double thickness;

  final bool _vertical;

  @override
  Widget build(BuildContext context) {
    final color = DilettaTheme.schemeOf(context).divider;
    if (_vertical) {
      return Padding(
        padding: EdgeInsets.only(top: indent, bottom: endIndent),
        child: SizedBox(
          width: thickness,
          height: double.infinity,
          child: ColoredBox(color: color),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: SizedBox(
        height: thickness,
        width: double.infinity,
        child: ColoredBox(color: color),
      ),
    );
  }
}
