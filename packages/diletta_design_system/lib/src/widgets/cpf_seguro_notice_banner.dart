import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/material.dart';
import '../theme/cpf_seguro_metrics.dart';
import 'cpf_seguro_tappable.dart';
import 'cpf_seguro_box.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_illustration.dart';
import 'cpf_seguro_icon_button.dart';

/// CPF SEGURO — NoticeBanner.
///
/// Card CLARO ilustrado de aviso/estado (ex.: conta em processamento, KYC
/// pendente, feature bloqueada). Borda primary-04, radius 16, título + descrição
/// em primary-04, ilustração sangrando no canto inferior-direito e um
/// **botão-ícone** de ação (default `+`) ancorado embaixo à direita.
///
/// Distinto dos outros banners:
/// - [DilettaPromoBanner] = CTA promo (botão de TEXTO, ilustração à direita).
/// - [DilettaStatusBanner] = banner de NÍVEL (gradiente escuro + progresso).
class DilettaNoticeBanner extends StatelessWidget {
  const DilettaNoticeBanner({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    this.onTap,
    this.showButton = true,
    this.buttonIcon = DilettaIcons.plusLight,
    this.buttonSemanticLabel = 'Adicionar',
  });

  final String title;
  final String description;
  final DilettaIllustration illustration;
  final VoidCallback? onTap;
  final bool showButton;
  final String buttonIcon;
  final String buttonSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    return DilettaTappable(
      onTap: onTap,
      child: DilettaBox(
        radius: DilettaRadius.all16,
        borderColor: s.palette.primary04,
        clip: true,
        child: Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.antiAlias,
            children: [
              Positioned(
                right: -DilettaSpacing.s6,
                bottom: -DilettaSpacing.s12,
                child: DilettaIllustrationAccessory(
                  illustration: illustration,
                  size: DilettaIllustrationSize.md,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: DilettaSpacing.s6,
                        top: DilettaSpacing.s4,
                        bottom: DilettaSpacing.s3,
                        right: DilettaSpacing.s4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: DilettaType.headlineMd.copyWith(
                              color: s.palette.primary04,
                              height: 1.2,
                              backgroundColor: s.palette.white,
                            ),
                          ),
                          const SizedBox(height: DilettaSpacing.s1),
                          Text(
                            description,
                            style: DilettaType.labelLg.copyWith(
                              color: s.palette.primary04,
                              backgroundColor: s.palette.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 160, width: 120),
                ],
              ),
              if (showButton)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: DilettaIconButton(
                    icon: buttonIcon,
                    semanticLabel: buttonSemanticLabel,
                    type: DilettaIconButtonType.secondaryPrimary,
                    size: DilettaIconButtonSize.lg,
                    onPressed: onTap ?? () {},
                  ),
                ),
            ],
          ),
        ),
      );
  }
}
