/// CONTA BOLD — os PONTOS DE PÁGINA.
///
/// Onde a pessoa está num carrossel ou num onboarding: pontos numa linha, e o ativo alonga em pílula.
/// O pai não tem indicador de página — `grep` em `lib/src/widgets` não acha nenhum — e o chrome do
/// catálogo também precisou do dele. Dois lugares precisando é o sinal de vocabulário faltando, então
/// nasce aqui e é candidato a subir quando um segundo filho medir a mesma falta.
///
/// ## O que mudou, e é a mesma classe de defeito duas vezes
///
/// **O ponto ativo cravava a cor da marca** (`BoldColors.primary04`) e **o inativo fazia conta de alpha
/// por modo** (`white@30%` no escuro, `neutral07` no claro). Os dois viraram papel: `primary` e
/// `borderSubtle` — que é exatamente o papel de "traço discreto que muda com o modo", e existe pra não
/// precisar do `if (isDark)`.
///
/// A `activeColor` opcional saiu junto. Ela existia pra o caso "sobre a imagem" e não tinha uso: quem
/// desenha sobre a arte é o `BoldBackground`, e no escuro `primary` já contrasta.
///
/// **O que NÃO mudou, e é de propósito:** o ativo alonga (2.75×) em vez de só mudar de cor. Indicador
/// que muda só de matiz não é lido por quem não distingue matiz, e a largura é a redundância que resolve
/// — mesma decisão do sublinhado das `BoldAbas`.
library;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

/// Indicador de página. Presentacional: quem controla a página é quem chama.
class BoldPontosDePagina extends StatelessWidget {
  const BoldPontosDePagina({
    super.key,
    required this.total,
    required this.indiceAtivo,
    this.tamanho = 8,
  });

  final int total;
  final int indiceAtivo;

  /// Diâmetro do ponto inativo. O ativo mantém a altura e alonga a largura.
  final double tamanho;

  /// Quanto o ativo alonga. Não é knob: é a proporção que faz a pílula ler como "estou aqui" sem virar
  /// uma barra.
  static const double _fatorDoAtivo = 2.75;

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox.shrink();
    final s = DilettaTheme.schemeOf(context);

    return DilettaDevInfo(
      component: 'pontosDePagina',
      props: {'total': '$total', 'indiceAtivo': '$indiceAtivo'},
      tokens: const ['ativo: primary (alonga 2.75×) · inativo: borderSubtle'],
      child: Semantics(
        // A linha de pontos é uma frase pro leitor de tela, não N caixas.
        container: true,
        label: 'Página ${indiceAtivo + 1} de $total',
        child: ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < total; i++) ...[
                if (i > 0) DilettaGap.w(DilettaSpacing.s2),
                AnimatedContainer(
                  duration: DilettaMotion.medium,
                  curve: DilettaMotion.enter,
                  width: i == indiceAtivo ? tamanho * _fatorDoAtivo : tamanho,
                  height: tamanho,
                  decoration: BoxDecoration(
                    color: i == indiceAtivo ? s.primary : s.borderSubtle,
                    borderRadius: DilettaRadius.pillAll,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
