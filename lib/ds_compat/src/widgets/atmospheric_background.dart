import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Fundo padrão do app — BOLD Design System v2.
///
/// Reproduz o `BoldBackground.image` do DS novo: a cidade cyberpunk no topo,
/// um glow rosa da marca e um wash escuro de 4 paradas para legibilidade das
/// "glass cards", sobre o fundo dark (#0A0B12). Mantém o nome/uso para não
/// quebrar os scaffolds (BoldDarkScaffold/BoldLightScaffold).
class AtmosphericBackground extends StatelessWidget {
  const AtmosphericBackground({
    super.key,
    this.asset = 'assets/images/city-cyberpunk.webp',
  });

  final String asset;

  @override
  Widget build(BuildContext context) {
    // Lê o brilho do Theme (depende dele → repinta na troca de tema).
    final light = Theme.of(context).brightness == Brightness.light;
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.bgDark,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cidade: cheia no ESCURO; faint (silhueta clara) no CLARO — a
            // mesma cidade, só mais clara, sobre o fundo off-white.
            Opacity(
              opacity: light ? 0.20 : 1.0,
              child: Image.asset(
                asset,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),

            // Glow rosa da marca, vindo do topo.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.6, -0.9),
                  radius: 1.1,
                  colors: [
                    AppColors.brand.withAlpha(light ? 0x24 : 0x2E),
                    AppColors.brand.withAlpha(0),
                  ],
                ),
              ),
            ),

            if (light)
              // Claro: segundo glow coral vindo de baixo — "vidro claro" da marca.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.7, 1),
                    radius: 1.0,
                    colors: [
                      AppColors.accent.withAlpha(0x1F),
                      AppColors.accent.withAlpha(0),
                    ],
                  ),
                ),
              )
            else
              // Escuro: wash near-black de 4 paradas p/ legibilidade das glass cards.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xCC0A0B12),
                      Color(0x8C0A0B12),
                      Color(0x9E0A0B12),
                      Color(0xE60A0B12),
                    ],
                    stops: [0.0, 0.22, 0.62, 1.0],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
