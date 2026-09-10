/// O PAI da família Coreflow.
///
/// Separação de `docs/2026-09-04-adr-o-coreflow-e-o-pai.md`, fase 2 em curso: aqui moram a
/// linguagem do avô re-exportada e os componentes `Coreflow*` que já não dependem de produto
/// nenhum — 61 arquivos em 08/09, com o veredito do dono do DS (decisões 1 e 2). O que NUNCA chega: cor, fonte, logo, arte ou nome de produto — o
/// gate `o_coreflow_nao_cita_bold` mede isso em `lib/` inteiro, comentário incluído.
///
/// Os arquivos seguem chamando `bold_*.dart`: é dívida de NOME, medida e fora do escopo do ADR —
/// renomear 36 arquivos no mesmo commit em que eles mudam de pacote esconderia o diff que importa.
library coreflow;

export 'package:diletta_design_system/diletta_design_system.dart';

export 'src/coreflow_abas.dart';
export 'src/coreflow_autorizacao.dart';
export 'src/coreflow_aviso.dart';
export 'src/coreflow_background.dart';
export 'src/coreflow_botao.dart';
export 'src/coreflow_botoes_de_navegacao.dart';
export 'src/coreflow_busy.dart';
export 'src/coreflow_cabecalho_da_home.dart';
export 'src/coreflow_campo_de_valor.dart';
export 'src/coreflow_cartao_da_conta.dart';
export 'src/coreflow_cartao_promocional.dart';
export 'src/coreflow_chip_de_filtro.dart';
export 'src/coreflow_comprovante.dart';
export 'src/coreflow_contratos.dart';
export 'src/coreflow_copiar.dart';
export 'src/coreflow_dinheiro.dart';
export 'src/coreflow_disco.dart';
export 'src/coreflow_elevacao.dart';
export 'src/coreflow_escada_de_alcadas.dart';
export 'src/coreflow_espaco.dart';
export 'src/coreflow_fileira_de_avatares.dart';
export 'src/coreflow_grupo_do_dia.dart';
export 'src/coreflow_ilustracao.dart';
export 'src/coreflow_ladrilho_de_menu.dart';
export 'src/coreflow_largura.dart';
export 'src/coreflow_linha_de_aviso.dart';
export 'src/coreflow_nav_flutuante.dart';
export 'src/coreflow_ponto.dart';
export 'src/coreflow_pontos_de_pagina.dart';
export 'src/coreflow_radius.dart';
export 'src/coreflow_resumo_da_transacao.dart';
export 'src/coreflow_rodape.dart';
export 'src/coreflow_saldo.dart';
export 'src/coreflow_segmentos.dart';
export 'src/coreflow_vinho.dart';
export 'src/coreflow_vocabulario.dart';
export 'src/coreflow_amostra_de_fundo.dart';
export 'src/coreflow_anel_de_escolha.dart';
export 'src/coreflow_avatar.dart';
export 'src/coreflow_barra_de_topo.dart';
export 'src/coreflow_busca.dart';
export 'src/coreflow_cabecalho_de_folha.dart';
export 'src/coreflow_campo_de_texto.dart';
export 'src/coreflow_cartao.dart';
export 'src/coreflow_cartao_de_pedido.dart';
export 'src/coreflow_contexto_de_operacao.dart';
export 'src/coreflow_corpo_de_folha.dart';
export 'src/coreflow_etiqueta.dart';
export 'src/coreflow_folha.dart';
export 'src/coreflow_gradients.dart';
export 'src/coreflow_heroi.dart';
export 'src/coreflow_icone.dart';
export 'src/coreflow_lista.dart';
export 'src/coreflow_pagina.dart';
export 'src/coreflow_pagina_de_resumo.dart';
export 'src/coreflow_pegador.dart';
export 'src/coreflow_scheme.dart';
export 'src/coreflow_tema_material.dart';
export 'src/coreflow_vidro.dart';
export 'src/coreflow_visor_de_codigo.dart';
export 'src/coreflow_produto.dart';
