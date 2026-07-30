/// CONTA BOLD — o DS-filho.
///
/// Este arquivo é a identidade do produto, e é quase só isso: a paleta. Os ~50 papéis
/// do scheme são DERIVADOS dela, então este filho não escolhe papel nenhum, não monta
/// tema Material, não registra componente e não copia widget do pai.
///
/// A fonte dos valores é `app-newbold/lib/design_system/theme/bold_colors.dart` — as
/// rampas de lá já nasceram com a estrutura do pai (01 = tinta, 10 = superfície),
/// porque o DS do Bold começou se integrando com o do primeiro filho.
///
/// O que NÃO está aqui e é de propósito: os extras do Bold (glass, gradiente de marca,
/// escada de aprovação, `secondaryFlow`, alphas). Cada um precisa passar pela pergunta
/// da governança — "outro produto ia querer isso?" — antes de virar campo daqui ou
/// pedido pro pai. Enquanto não passarem, este arquivo é a paleta e mais nada.
library conta_bold_design_system;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'src/bold_palette.dart';

/// A LINGUAGEM SAI POR AQUI, e é o que faz este pacote ser "o DS do Bold" pra quem
/// consome: o app e o catálogo importam UM caminho
/// (`package:conta_bold_design_system/...`) e recebem os 100 componentes do pai mais a
/// identidade daqui.
///
/// É também o que sustenta o `importNoCodigo` do catálogo: o código gerado diz
/// `ds.DilettaButton(...)` com `ds` apontando pra cá. Sem este reexport, o código gerado
/// não compilaria no app — e o catálogo não teria como saber.
export 'package:diletta_design_system/diletta_design_system.dart';

/// A identidade deste filho: paleta, fonte e os dois gradientes.
export 'src/bold_palette.dart';
export 'src/bold_pontos_de_pagina.dart';
export 'src/bold_vinho.dart';
export 'src/bold_fonts.dart';
export 'src/bold_fundamentos.dart';
export 'src/bold_gradients.dart';

/// Componentes que só o Bold tem, nascidos aqui compondo as peças do pai.
export 'src/bold_autorizacao.dart';
export 'src/bold_background.dart';
export 'src/bold_dinheiro.dart';
export 'src/bold_abas.dart';
export 'src/bold_cabecalho_da_home.dart';
export 'src/bold_contratos.dart';
export 'src/bold_copiar.dart';
export 'src/bold_escada_de_alcadas.dart';
export 'src/bold_resumo_da_transacao.dart';
export 'src/bold_saldo.dart';
export 'src/bold_segmentos.dart';
export 'src/bold_selo_quantico.dart';
export 'src/bold_visor_de_codigo.dart';

/// Os temas do Bold — claro e escuro, com a paleta acima.
///
/// O escuro sai de graça: mesma paleta, rampa invertida pelo pai.
class BoldTheme {
  BoldTheme._();

  static final DilettaTheme light =
      DilettaTheme.resolve(palette: BoldPalette.bold);

  static final DilettaTheme dark = DilettaTheme.resolve(
      palette: BoldPalette.bold, brightness: Brightness.dark);
}

/// Uma tela do Bold montada SÓ com componentes do pai.
///
/// Serve de exemplo e de instrumento: é o que o teste renderiza pra medir se sobrou
/// cor do primeiro filho em algum lugar.
class TelaDeExemploBold extends StatelessWidget {
  const TelaDeExemploBold({super.key, this.escuro = false});

  final bool escuro;

  @override
  Widget build(BuildContext context) {
    return DilettaThemeScope(
      theme: escuro ? BoldTheme.dark : BoldTheme.light,
      child: Builder(
        builder: (ctx) {
          final s = DilettaTheme.schemeOf(ctx);
          return ColoredBox(
            color: s.bg,
            child: DilettaFrame.column(
              gap: DilettaSpacing.s4,
              padding: EdgeInsets.all(DilettaSpacing.s5),
              children: [
                DilettaText('Conta BOLD', style: DilettaType.displaySm),
                DilettaText(
                  'Nenhuma linha desta tela é do Bold: os componentes são do pai, e a '
                  'cor vem da paleta.',
                  style: DilettaType.bodyMd,
                ),
                DilettaButton(label: 'Continuar', onPressed: () {}),
                DilettaStatusTag(label: 'Ativo', tone: DilettaStatusTone.success),
                DilettaBox(
                  color: s.primarySubtle,
                  radius: DilettaRadius.all16,
                  child: DilettaText('Superfície da marca', style: DilettaType.label),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
