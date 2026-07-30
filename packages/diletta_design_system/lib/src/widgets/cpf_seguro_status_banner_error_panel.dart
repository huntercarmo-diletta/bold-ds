import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_status_banner_action_icon.dart';

/// CPF SEGURO — StatusBannerErrorPanel.
///
/// Painel de erro DENTRO do banner azul (feedback de documento inválido).
/// Bg [DilettaScheme.errorSolid], radius 8, gap 16, SEM padding — o
/// ActionIcon fica flush à esquerda, altura = altura do ícone (40).
/// Usar via `body` do [DilettaStatusBanner].
class DilettaStatusBannerErrorPanel extends StatelessWidget {
  const DilettaStatusBannerErrorPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // Stance: o azul segura você mesmo no erro — o painel é um alerta CONTIDO
    // dentro do banner, não a tela virando vermelha. O errorBanner (#A23737)
    // A escolha de vermelho por modo mora no PAPEL (`errorSolid`), não aqui: no claro é o
    // vermelho dessaturado que não grita sobre o azul; no escuro é um mais limpo, porque o
    // dessaturado vira marrom-lama e o "vermelho = erro" some. Este componente só pede o
    // papel — o `dark` local que existia aqui virou código morto quando o scheme assumiu.
    return Container(
      decoration: BoxDecoration(
        color: DilettaTheme.schemeOf(context).errorSolid,
        borderRadius: DilettaRadius.all8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DilettaStatusBannerActionIcon(icon: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: DilettaSpacing.s2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DilettaType.subheading.copyWith(color: DilettaAbsoluteColors.white),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DilettaType.labelSm.copyWith(color: DilettaTheme.schemeOf(context).onErrorSolid),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
