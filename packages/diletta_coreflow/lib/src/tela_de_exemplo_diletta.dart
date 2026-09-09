import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart';

import 'diletta.dart';

/// A tela que mostra o WHITE LABEL: nenhuma linha dela é da Diletta além do tema que a envolve.
///
/// Logo, botão, etiqueta, cartão e texto são peças do pai e do avô lendo o esquema em contexto. Troque
/// o produto e a tela troca inteira — é a frase que o Coreflow existe pra provar.
class TelaDeExemploDiletta extends StatelessWidget {
  const TelaDeExemploDiletta({super.key, this.escuro = false, CoreflowProduto? produto})
      : _produto = produto;

  final bool escuro;
  final CoreflowProduto? _produto;
  CoreflowProduto get produto => _produto ?? Diletta.produto;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: escuro ? produto.materialEscuro : produto.materialClaro,
      child: DilettaThemeScope(
        theme: escuro ? produto.escuro : produto.claro,
        child: Builder(
          builder: (ctx) {
            final s = DilettaTheme.schemeOf(ctx);
            final c = CoreflowScheme.of(ctx);
            // `Material` pra a tela desenhar SOZINHA — fora de um `Scaffold`, texto sem Material acima
            // sai com o sublinhado amarelo do Flutter, e uma tela de exemplo precisa valer em qualquer lugar.
            return Material(
              color: c.background,
              child: DilettaFrame.column(
                gap: DilettaSpacing.s4,
                padding: EdgeInsets.all(DilettaSpacing.s5),
                children: [
                  DilettaLogo(variant: DilettaLogoVariant.full, size: 56, color: s.fg),
                  DilettaText(produto.paleta.nome, style: DilettaType.displaySm),
                  DilettaText(
                    'Nenhuma linha desta tela é da marca: os componentes são do pai, e a cor '
                    'vem da paleta.',
                    style: DilettaType.bodyMd,
                  ),
                  DilettaButton(label: 'Continuar', onPressed: () {}),
                  CoreflowEtiqueta(label: 'Ativo', tone: DilettaStatusTone.success),
                  CoreflowCartao(
                    child: DilettaText('Superfície do produto', style: DilettaType.label),
                  ),
                  DilettaBox(
                    color: s.primarySubtle,
                    radius: DilettaRadius.all16,
                    child: DilettaText('Lavagem da marca', style: DilettaType.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
