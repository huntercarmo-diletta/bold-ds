import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_metrics.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — abas sublinhadas (tab bar).
///
/// Baseado no componente "Tab-item" do Figma CPF Seguro: itens de largura igual
/// (`Expanded`), a aba ativa ganha um sublinhado grosso em [BoldScheme.primary]
/// + texto de peso médio; as inativas ficam com uma linha fina ([BoldScheme.border])
/// e texto regular. Distinto do [BoldSegmentedControl] (pílula) — use este para
/// alternar seções/listas.
///
/// ```dart
/// BoldTabs(
///   tabs: const ['Ativos', 'Encerrados'],
///   selectedIndex: _tab,
///   onChanged: (i) => setState(() => _tab = i),
/// );
/// ```
class BoldTabs extends StatelessWidget {
  const BoldTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  /// Espessura do sublinhado da aba ativa.
  static const double _indicator = 3;

  @override
  Widget build(BuildContext context) {
    final c = BoldColors.of(context);
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++)
          Expanded(
            child: Semantics(
              button: true,
              selected: i == selectedIndex,
              label: tabs[i],
              child: InkWell(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: BoldSpace.x4, vertical: BoldSpace.x3),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == selectedIndex ? c.primary : c.border,
                        width: i == selectedIndex ? _indicator : 1,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BoldType.labelLg.copyWith(
                      color: c.textPrimary,
                      fontWeight: i == selectedIndex
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
