import 'dart:async';

import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaStatusTone;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bold_etiqueta.dart' show CoreflowEtiqueta;
import 'bold_icone.dart' show CoreflowIcone;
import 'bold_scheme.dart' show CoreflowScheme;
/// **COPIAR, com a confirmação que não vai embora sozinha** — escrito pelo time do app.
///
/// Chegou por merge em 02/09. Ele resolve o que um `Clipboard.setData` cru não resolve: **a pessoa
/// não vê que copiou.** O botão troca de estado por alguns segundos e volta, com o texto e o glifo
/// dizendo o mesmo — que é a regra de UM indicador que este DS cita desde o alerta inline.


/// Conta BOLD — CopyButton (átomo). Botão de copiar com feedback IN-PLACE: ao
/// tocar, copia [text] pro clipboard e o ícone de copiar (pequeno) vira um
/// [CoreflowEtiqueta] success com check-circle + [label] ("Conta copiada"); reverte
/// após ~2s. Feedback perto da ação (melhor que toast distante).
///
/// **Composição** — CoreflowIcone + CoreflowEtiqueta (átomos) + tokens.
///
/// ```dart
/// CoreflowBotaoDeCopiar(text: user.conta, semanticLabel: 'Copiar conta', label: 'Conta copiada');
/// ```
class CoreflowBotaoDeCopiar extends StatefulWidget {
  const CoreflowBotaoDeCopiar({
    super.key,
    required this.text,
    required this.semanticLabel,
    this.label = 'Copiado',
    this.onCopied,
  });

  /// Texto copiado pro clipboard.
  final String text;
  final String semanticLabel;

  /// Micro-rótulo mostrado abaixo do check.
  final String label;
  final VoidCallback? onCopied;

  @override
  State<CoreflowBotaoDeCopiar> createState() => _CoreflowBotaoDeCopiarState();
}

class _CoreflowBotaoDeCopiarState extends State<CoreflowBotaoDeCopiar> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.text));
    HapticFeedback.selectionClick();
    widget.onCopied?.call();
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      // Stack sem clip: o ícone pequeno define o footprint; o status tag do
      // feedback é FORA do fluxo (Positioned), flutuando por cima do conteúdo à
      // esquerda — não empurra/reflui nenhum componente vizinho.
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _copy,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: CoreflowIcone('copy', size: 13, color: c.textSecondary),
            ),
          ),
          // O tag do feedback tem de caber, e por muito tempo não cabia.
          //
          // Era `Positioned(top: 22)` sem left nem right: o tag ficava com
          // largura natural (Positioned sem borda horizontal não restringe
          // nada), mas era CENTRALIZADO no ícone pelo alignment do stack. O
          // ícone tem 19 lógicos e o tag tem uns 100: sobravam ~40 para cada
          // lado. O botão de copiar mora no FIM da linha de valor nas telas que
          // o usam, então esses 40 da direita caíam fora do cartão — e quem
          // cortava era o clip da borda arredondada do comprovante. A pessoa
          // lia "ID copia". Bug #102 do feedback, relatado pelo Luis na 3.4.0.
          //
          // `right: 0` ancora o tag pela direita do ícone: ele cresce todo para
          // a ESQUERDA, por cima do conteúdo, que é onde há espaço. Nada de
          // OverflowBox — a primeira tentativa colocou um, e ele estoura em
          // "given an infinite size during layout" porque se dimensiona pela
          // restrição recebida, que aqui é ilimitada nos dois eixos.
          Positioned(
            top: 22,
            right: 0,
            child: IgnorePointer(
              child: AnimatedScale(
                scale: _copied ? 1 : 0.85,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _copied ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: CoreflowEtiqueta(
                    label: widget.label,
                    tone: DilettaStatusTone.success,
                    icon: 'circle-check-solid',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
