import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAbsoluteColors, DilettaAppList, DilettaAppListRow, DilettaLeftAccessory, DilettaMiddleAccessory, DilettaSectionHeader;
import 'package:flutter/material.dart';
import 'bold_rodape.dart';
import 'bold_barra_de_topo.dart';
import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaSpacing;
import 'bold_botoes_de_navegacao.dart' show CoreflowAcaoDeNavegacao;
import 'bold_background.dart' show CoreflowBackground;
import 'bold_resumo_da_transacao.dart' show CoreflowEstadoDaTransacao;
import 'bold_resumo_da_transacao.dart' show CoreflowResumoDaTransacao;

/// Linha de detalhe (acessório à esquerda + título/subtítulo) de uma seção do
/// [CoreflowPaginaDeResumo].
class CoreflowLinhaDeResumo {
  const CoreflowLinhaDeResumo({
    required this.left,
    required this.title,
    required this.subtitle,
  });
  final DilettaLeftAccessory left;
  final String title;
  final String subtitle;
}

/// Seção do resumo (rótulo + card com linhas), ex.: "Para", "Detalhes".
class CoreflowSecaoDeResumo {
  const CoreflowSecaoDeResumo({required this.label, required this.rows});
  final String label;
  final List<CoreflowLinhaDeResumo> rows;
}

/// Item da seção "Ajuda" (menu com chevron), ex.: "Contestar transação".
class CoreflowAcaoDeResumo {
  const CoreflowAcaoDeResumo({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final String icon;
  final String title;
  final VoidCallback onTap;
}

/// Conta BOLD — Resumo de transação (organismo). Layout estilo lista do modelo
/// CPF Seguro: top bar (voltar) + título + spot de status + valor em destaque +
/// subtítulo (data) + seções (Para/De, Detalhes) + Ajuda + CTA inferior.
///
/// Reutilizado pelo comprovante de PIX e pelo detalhe do extrato — o CTA
/// (ex.: "Comprovante") normalmente abre o documento compartilhável.
///
/// **Composição** — [CoreflowBackground], [CoreflowBarraDeTopo], [CoreflowSpot],
/// [BoldSectionHeader], [BoldAppList]/[BoldAppListGroup], [CoreflowRodape].
class CoreflowPaginaDeResumo extends StatelessWidget {
  const CoreflowPaginaDeResumo({
    super.key,
    required this.title,
    required this.amountText,
    required this.subtitle,
    this.estado = CoreflowEstadoDaTransacao.concluida,
    this.sections = const [],
    this.helpActions = const [],
    this.onBack,
    this.onPrimary,
    this.primaryLabel = 'Comprovante',
    this.primaryGlyph = 'receipt-light',
    this.onDownload,
  });

  final String title;
  final String amountText;
  final String subtitle;

  /// Em que ponto a transação está. Era `statusIcon` + `statusTone` calculados na tela — dois
  /// argumentos pra uma informação, e duas chances de escolher o ícone certo com o tom errado.
  final CoreflowEstadoDaTransacao estado;

  final List<CoreflowSecaoDeResumo> sections;
  final List<CoreflowAcaoDeResumo> helpActions;

  final VoidCallback? onBack;
  final VoidCallback? onPrimary;
  final String primaryLabel;
  final String primaryGlyph;

  /// BAIXAR o comprovante em PDF, no rodapé, ao lado de ver o documento.
  ///
  /// Ele existe aqui e não só dentro do documento porque a tela de sucesso é
  /// onde a pessoa está quando decide guardar — obrigar a abrir o documento pra
  /// achar o botão é um toque a mais no fim de um fluxo de dinheiro, que é
  /// exatamente onde ninguém quer procurar nada.
  ///
  /// Nulo esconde o slot: fluxo sem PDF não mostra um botão que não baixa nada.
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DilettaAbsoluteColors.transparent,
      body: CoreflowBackground(
        child: Column(children: [
          CoreflowBarraDeTopo.page(
              title: '',
              onBack: onBack ?? () => Navigator.of(context).maybePop()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  DilettaSpacing.s6, 0, DilettaSpacing.s6, DilettaSpacing.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // O cabeçalho é do PACOTE: título + spot + valor + data. Ele encolhe o valor
                  // em vez de cortar, e resolve o par ícone/tom a partir do estado.
                  CoreflowResumoDaTransacao(
                    titulo: title,
                    valor: amountText,
                    quando: subtitle,
                    estado: estado,
                  ),
                  const SizedBox(height: DilettaSpacing.s6),
                  for (final s in sections) ...[
                    // Sem margem: o respiro é o `SizedBox` abaixo. Mesma dobra dupla que o
                    // grupo de permissões tinha — 16 onde o desenho pede 8.
                    DilettaSectionHeader(label: s.label),
                    const SizedBox(height: DilettaSpacing.s2),
                    DilettaAppList.carded(children: [
                      for (final r in s.rows)
                        DilettaAppListRow(
                          left: r.left,
                          middle: DilettaMiddleAccessory.titleSubtitle(
                              title: r.title, subtitle: r.subtitle),
                        ),
                    ]),
                    const SizedBox(height: DilettaSpacing.s6),
                  ],
                  if (helpActions.isNotEmpty) ...[
                    const DilettaSectionHeader(label: 'Ajuda'),
                    const SizedBox(height: DilettaSpacing.s2),
                    DilettaAppList.carded(children: [
                      for (final a in helpActions)
                        DilettaAppListRow.menuItem(
                            icon: a.icon, title: a.title, onTap: a.onTap),
                    ]),
                  ],
                ],
              ),
            ),
          ),
          if (onPrimary != null)
            CoreflowRodape.button(
              primary: CoreflowAcaoDeNavegacao(
                label: primaryLabel,
                glyph: primaryGlyph,
                onPressed: onPrimary,
              ),
              secondary: onDownload == null
                  ? null
                  : CoreflowAcaoDeNavegacao(
                      label: 'Baixar PDF',
                      glyph: 'download-light',
                      onPressed: onDownload,
                    ),
            ),
        ]),
      ),
    );
  }
}
