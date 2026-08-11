/// CONTA BOLD — o DS-filho.
///
/// Este arquivo é a identidade do produto, e é quase só isso: a paleta. Os **53 papéis de cor**
/// do scheme são DERIVADOS dela — contados por CAMPO e não por linha, que é o que errou as duas
/// versões anteriores desta frase (`~50` de chute, e `39` de um regex meu que lia
/// `final Color warning, onWarning, warningSubtle;` como um papel só). Confere com
/// `grep -oE 'final Color\??[^;]+;' diletta_scheme.dart | tr ',' '\n' | wc -l` — a pergunta é
/// quantos CAMPOS, e o comando tem que responder essa, não quantas linhas declaram algum.
///
/// Derivados quer dizer o que está escrito: este filho não escolhe papel nenhum, não monta
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
/// (`package:conta_bold_design_system/...`) e recebem os componentes do pai — **77 com
/// contrato** (`kDilettaSpecs`, medido em 2026-08-06; eu dizia 100) — mais a identidade
/// daqui.
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

/// AS QUATRO LACUNAS, e as duas que estavam do lado errado da fronteira.
///
/// Elas entraram juntas porque a causa é uma só: o dono pediu quatro telas em alta fidelidade pro
/// catálogo, e **as quatro paravam aqui**. `BoldMenuTile`, `BoldFilterChip`, `BoldNoticeRow` e
/// `BoldPromoCard` eram as quatro últimas peças marcadas como LACUNA no inventário de adoção
/// (alcance 4, 3, 2 e 2); a fileira de avatares e o grupo do dia já eram adotados, mas moravam em
/// `app-newbold/lib/design_system/` — e o catálogo consome o PACOTE, nunca o app.
///
/// São duas classes de defeito diferentes com o mesmo sintoma: **peça que não dá pra desenhar em
/// lugar nenhum**. A régua que saiu daqui: adotada e alcançável não são a mesma coisa.
export 'src/bold_cartao_da_conta.dart';
export 'src/bold_cartao_de_pedido.dart';
export 'src/bold_cartao_promocional.dart';
export 'src/bold_chip_de_filtro.dart';
export 'src/bold_fileira_de_avatares.dart';
export 'src/bold_grupo_do_dia.dart';
export 'src/bold_ladrilho_de_menu.dart';
export 'src/bold_linha_de_aviso.dart';
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

  /// ONDE OS ASSETS DO PAI MORAM — uma linha, e sem ela nenhum ícone do pai aparece.
  ///
  /// `DilettaAssets.assetPackage` nasce `null`, que significa "assets na raiz do bundle". Num app que
  /// CONSOME o pacote eles moram em `packages/diletta_design_system/…`, então o `AssetBytesLoader`
  /// procura no lugar errado. E `VectorGraphic` com asset ausente **não estoura**: desenha caixa vazia.
  ///
  /// Chegou como *"os ícones não estão aparecendo no app"*, depois de a adoção trocar
  /// `BoldIconButton` por `DilettaIconButton`: as setas de voltar, os ícones da home e o `>` do extrato
  /// sumiram juntos. Nada falhou — nem `analyze`, nem a suíte inteira, nem o console. (O número que
  /// estava escrito aqui, `414 testes`, era de outra medição e ficou velho: hoje são 125 no pacote e 86
  /// no catálogo. O argumento nunca dependeu do tamanho da suíte — dependeu de nada nela olhar o asset.)
  ///
  /// **Fica AQUI e não no `main` do app**, e a razão é a mesma que o catálogo escreveu no plugue dele:
  /// quem liga o DS é quem sabe onde o DS guarda coisa. No `main` isso é uma linha que todo app novo
  /// tem que lembrar de copiar — e o primeiro filho, que resolveu no `main` do catálogo dele, tem o
  /// mesmo buraco de um lado só.
  ///
  /// É idempotente e roda no primeiro acesso ao tema. Não existe caminho que desenhe componente do pai
  /// sem passar por `BoldTheme.light`/`dark`: o `DilettaThemeScope` é obrigatório pra qualquer um deles.
  static void _garanteOsAssetsDoPai() {
    DilettaAssets.assetPackage ??= DilettaAssets.package;
  }

  static DilettaTheme get light {
    _garanteOsAssetsDoPai();
    return _claro;
  }

  static DilettaTheme get dark {
    _garanteOsAssetsDoPai();
    return _escuro;
  }

  static final DilettaTheme _claro = DilettaTheme.resolve(palette: BoldPalette.bold);

  static final DilettaTheme _escuro =
      DilettaTheme.resolve(palette: BoldPalette.bold, brightness: Brightness.dark);
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
