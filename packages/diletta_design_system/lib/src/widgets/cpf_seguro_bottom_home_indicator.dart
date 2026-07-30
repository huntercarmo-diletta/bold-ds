import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_dev_inspect.dart';

/// CPF SEGURO — BottomHomeIndicator.
///
/// Slot inferior mínimo — só a barra de gesto do iOS. Altura 34, pill 134×5.
///
/// - [color]: cor do pill. Default null = s.fg do tema (neutral-01 no light).
/// - [background]: bg do container 34-alto. Default null = transparente
///   (uso standalone sobre bg da tela). Passe [s.palette.neutral08] pra
///   emendar visualmente com Numpad (spec iOS quando teclado aberto).
class DilettaBottomHomeIndicator extends StatelessWidget {
  const DilettaBottomHomeIndicator({
    super.key,
    this.color,
    this.background,
  });

  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Teclado aberto → o gesture bar do iOS fica coberto: recolhe (evita a
    // barrinha flutuando sobre o teclado). Robusto p/ toda variante do BottomApp.
    if (mq.viewInsets.bottom > 0) {
      return const SizedBox.shrink();
    }
    // Device real (iOS notch / Android gesture): o SO já desenha o gesture bar
    // de verdade. Reserva só o inset real e NÃO desenha pill fake (senão
    // duplica). O pill fake abaixo é fidelidade de catálogo (sem inset do SO).
    final realInset = mq.viewPadding.bottom;
    if (realInset > 0) {
      return Container(height: realInset, color: background);
    }
    final s = DilettaTheme.schemeOf(context);
    final barColor = color ?? s.fg;
    return DilettaDevInfo(
      component: 'DilettaBottomHomeIndicator',
      props: {'background': nomeDoToken(context, background)},
      tokens: const ['h34 · barra 134×5 radius pill neutral-01'],
      child: Container(
      height: 34,
      color: background,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: DilettaSpacing.s2),
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: DilettaRadius.pillAll,
          ),
        ),
      ),
    ),
    );
  }
}
