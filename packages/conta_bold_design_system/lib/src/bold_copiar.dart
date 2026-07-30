/// CONTA BOLD — o botão de COPIAR, com o aviso que não empurra layout.
///
/// 3 usos. Copiar chave, código, ID de transação — a ação que aparece do lado de todo dado que a
/// pessoa precisa levar pra outro app.
///
/// A parte que é desenho, e que a adaptação preservou: o aviso de "copiado" é `Positioned` FORA do
/// fluxo, então ele flutua por cima do conteúdo em vez de empurrar o vizinho. Um aviso que
/// reflui a linha faz o dedo perder o alvo justamente quando a pessoa quer conferir se copiou.
///
/// ## O que mudou
///
/// **O `Timer` virou `restartable`, e isso era um bug.** A versão antiga criava um `Timer` a cada
/// toque sem cancelar o anterior: dois toques rápidos e o primeiro timer apagava o aviso do
/// segundo, ~1.8s antes da hora. Agora o toque cancela o timer pendente.
///
/// **Cores e durações saem de token.** Eram `Colors`/`Duration` literais no widget.
library;

import 'dart:async';

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Botão de copiar com aviso flutuante.
class BoldCopiar extends StatefulWidget {
  const BoldCopiar({
    super.key,
    required this.texto,
    required this.rotuloDeAcessibilidade,
    this.aviso = 'Copiado',
    this.aoCopiar,
  });

  /// O que vai pro clipboard.
  final String texto;

  /// O que o leitor de tela anuncia. Obrigatório: ícone sem rótulo é botão mudo.
  final String rotuloDeAcessibilidade;

  /// Micro-rótulo do aviso.
  final String aviso;

  final VoidCallback? aoCopiar;

  @override
  State<BoldCopiar> createState() => _BoldCopiarState();
}

class _BoldCopiarState extends State<BoldCopiar> {
  bool _copiado = false;
  Timer? _timer;

  /// Quanto o aviso fica na tela. Não é degrau de motion do pai porque não é transição: é o tempo
  /// de leitura de duas palavras.
  static const Duration _permanencia = Duration(milliseconds: 1800);

  Future<void> _copiar() async {
    await Clipboard.setData(ClipboardData(text: widget.texto));
    if (!mounted) return;
    widget.aoCopiar?.call();
    setState(() => _copiado = true);
    // Cancela o pendente: sem isso, dois toques rápidos fazem o primeiro timer apagar o aviso do
    // segundo antes da hora.
    _timer?.cancel();
    _timer = Timer(_permanencia, () {
      if (mounted) setState(() => _copiado = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaDevInfo(
      component: 'copiar',
      props: {'copiado': '$_copiado'},
      tokens: const ['scheme.textSecondary', 'motion.short'],
      child: Semantics(
        button: true,
        label: widget.rotuloDeAcessibilidade,
        // Stack sem clip: o ícone define o footprint e o aviso flutua por cima. Aviso dentro do
        // fluxo empurraria o vizinho no instante em que a pessoa vai conferir se copiou.
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            DilettaTappable(
              onTap: _copiar,
              child: Padding(
                padding: EdgeInsets.all(DilettaSpacing.s0_5),
                child: DilettaIcon(
                  // O conjunto do pai chama de `clone`, não de `copy` — o glifo é o mesmo par de
                  // folhas. Nome de ícone é vocabulário do pai, então quem se adapta é o filho.
                  name: DilettaIcons.cloneLight,
                  size: 14,
                  color: s.textSecondary,
                ),
              ),
            ),
            Positioned(
              top: 22,
              child: IgnorePointer(
                child: AnimatedScale(
                  scale: _copiado ? 1 : 0.85,
                  duration: DilettaMotion.short,
                  curve: DilettaMotion.enter,
                  child: AnimatedOpacity(
                    // Chave nomeada porque o selo de status monta o próprio `AnimatedOpacity` por
                    // dentro: sem ela, um teste que procure por tipo pega o de dentro e mede 1.0
                    // sempre. Aconteceu, e o teste "passava" medindo a peça errada.
                    key: const ValueKey('avisoDeCopiado'),
                    opacity: _copiado ? 1 : 0,
                    duration: DilettaMotion.short,
                    child: DilettaStatusTag(
                      label: widget.aviso,
                      tone: DilettaStatusTone.success,
                      icon: DilettaIcons.circleCheckSolid,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
