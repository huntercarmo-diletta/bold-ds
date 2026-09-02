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
library coreflow_design_system;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'src/bold_produto.dart';

/// A LINGUAGEM SAI POR AQUI, e é o que faz este pacote ser "o DS do Bold" pra quem
/// consome: o app e o catálogo importam UM caminho
/// (`package:coreflow_design_system/...`) e recebem os componentes do pai — **77 com
/// contrato** (`kDilettaSpecs`, medido em 2026-08-06; eu dizia 100) — mais a identidade
/// daqui.
///
/// É também o que sustenta o `importNoCodigo` do catálogo: o código gerado diz
/// `ds.DilettaButton(...)` com `ds` apontando pra cá. Sem este reexport, o código gerado
/// não compilaria no app — e o catálogo não teria como saber.
export 'package:diletta_design_system/diletta_design_system.dart';

/// A identidade deste filho: paleta, fonte e os dois gradientes.
export 'src/bold_palette.dart';
export 'src/bold_scheme.dart';
export 'src/bold_radius.dart';
export 'src/bold_vidro.dart';
export 'src/bold_tema_material.dart';
export 'src/bold_ponto.dart';
export 'src/bold_pontos_de_pagina.dart';
export 'src/bold_vinho.dart';
export 'src/bold_fonts.dart';
export 'src/bold_type.dart';
export 'src/bold_fundamentos.dart';
export 'src/bold_produto.dart';
export 'src/bold_gradients.dart';
export 'src/bold_icone.dart';
export 'src/bold_avatar.dart';
export 'src/bold_aviso.dart';
export 'src/bold_barra_de_topo.dart';
export 'src/bold_busca.dart';
export 'src/bold_folha.dart';
export 'src/bold_pagina.dart';
export 'src/bold_pagina_de_resumo.dart';
export 'src/bold_rodape.dart';
export 'src/bold_campo_de_texto.dart';
export 'src/bold_cartao.dart';
export 'src/bold_etiqueta.dart';
export 'src/bold_ilustracao.dart';
export 'src/bold_lista.dart';

/// Componentes que só o Bold tem, nascidos aqui compondo as peças do pai.
export 'src/bold_autorizacao.dart';
export 'src/bold_busy.dart';
export 'src/bold_contexto_de_operacao.dart';
export 'src/bold_background.dart';
export 'src/bold_botao.dart';
export 'src/bold_botoes_de_navegacao.dart';
export 'src/bold_campo_de_valor.dart';
export 'src/bold_dinheiro.dart';
export 'src/bold_abas.dart';
export 'src/bold_cabecalho_da_home.dart';
export 'src/bold_contratos.dart';
export 'src/bold_copiar.dart';
export 'src/bold_elevacao.dart';
export 'src/bold_escada_de_alcadas.dart';
export 'src/bold_espaco.dart';

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
export 'src/bold_amostra_de_fundo.dart';
export 'src/bold_nav_flutuante.dart';
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
class CoreflowTheme {
  CoreflowTheme._();

  /// O tema do Conta BOLD no claro. Atalho pra `CoreflowProduto.bold.claro`.
  ///
  /// Este par de getters era o fim da linha: os dois eram `static final` montados com
  /// `BoldPalette.bold` cravada, e não havia forma de pedir o mesmo tema com outra paleta. Desde
  /// 20/08 quem responde é o [CoreflowProduto], e este nome fica porque **43 cascas e o `main` do app
  /// já o escrevem** — atalho pro produto default não é indireção, é o nome curto do caso comum.
  static DilettaTheme get light => CoreflowProduto.bold.claro;

  /// O tema do Conta BOLD no escuro. Atalho pra `CoreflowProduto.bold.escuro`.
  static DilettaTheme get dark => CoreflowProduto.bold.escuro;

  /// A MARCA deste produto, declarada no plugue do pai — arquivos e o mapa da arte.
  ///
  /// Mora em [CoreflowProduto.marcaDoBold] desde 20/08, porque marca é do PRODUTO e não do tema: um
  /// filho do Bold troca as duas coisas juntas ou nenhuma.
  static const DilettaBrand marca = CoreflowProduto.marcaDoBold;
}

/// Uma tela montada SÓ com componentes do pai.
///
/// Serve de exemplo e de instrumento: é o que o teste renderiza pra medir se sobrou
/// cor do primeiro filho em algum lugar.
///
/// **Recebe o PRODUTO desde 20/08**, e não é generalização especulativa: esta tela é o instrumento
/// que responde *"um filho do Bold consegue?"* com uma imagem em vez de uma asserção. Renderizada
/// com dois produtos lado a lado, ela mostra em um quadro o que 20 `expect` afirmam em partes.
class TelaDeExemploBold extends StatelessWidget {
  const TelaDeExemploBold({super.key, this.escuro = false, CoreflowProduto? produto})
      : _produto = produto;

  final bool escuro;
  final CoreflowProduto? _produto;

  /// O produto desta tela. Sem nada declarado, é o Conta BOLD.
  CoreflowProduto get produto => _produto ?? CoreflowProduto.bold;

  @override
  Widget build(BuildContext context) {
    return DilettaThemeScope(
      theme: escuro ? produto.escuro : produto.claro,
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
