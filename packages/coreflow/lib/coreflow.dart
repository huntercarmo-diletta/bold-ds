/// O PAI da família Coreflow.
///
/// Separação de `docs/2026-09-04-adr-o-coreflow-e-o-pai.md`, fase 2 em curso: aqui moram a
/// linguagem do avô re-exportada e os componentes `Coreflow*` que já não dependem de produto
/// nenhum — 36 arquivos em 08/09. Os que ainda leem o esquema ou a fonte do primeiro produto chegam
/// com o veredito do dono do DS. O que NUNCA chega: cor, fonte, logo, arte ou nome de produto — o
/// gate `o_coreflow_nao_cita_bold` mede isso em `lib/` inteiro, comentário incluído.
///
/// Os arquivos seguem chamando `bold_*.dart`: é dívida de NOME, medida e fora do escopo do ADR —
/// renomear 36 arquivos no mesmo commit em que eles mudam de pacote esconderia o diff que importa.
library coreflow;

export 'package:diletta_design_system/diletta_design_system.dart';

export 'src/bold_abas.dart';
export 'src/bold_autorizacao.dart';
export 'src/bold_aviso.dart';
export 'src/bold_background.dart';
export 'src/bold_botao.dart';
export 'src/bold_botoes_de_navegacao.dart';
export 'src/bold_busy.dart';
export 'src/bold_cabecalho_da_home.dart';
export 'src/bold_campo_de_valor.dart';
export 'src/bold_cartao_da_conta.dart';
export 'src/bold_cartao_promocional.dart';
export 'src/bold_chip_de_filtro.dart';
export 'src/bold_comprovante.dart';
export 'src/bold_contratos.dart';
export 'src/bold_copiar.dart';
export 'src/bold_dinheiro.dart';
export 'src/bold_disco.dart';
export 'src/bold_elevacao.dart';
export 'src/bold_escada_de_alcadas.dart';
export 'src/bold_espaco.dart';
export 'src/bold_fileira_de_avatares.dart';
export 'src/bold_grupo_do_dia.dart';
export 'src/bold_ilustracao.dart';
export 'src/bold_ladrilho_de_menu.dart';
export 'src/bold_largura.dart';
export 'src/bold_linha_de_aviso.dart';
export 'src/bold_nav_flutuante.dart';
export 'src/bold_ponto.dart';
export 'src/bold_pontos_de_pagina.dart';
export 'src/bold_radius.dart';
export 'src/bold_resumo_da_transacao.dart';
export 'src/bold_rodape.dart';
export 'src/bold_saldo.dart';
export 'src/bold_segmentos.dart';
export 'src/coreflow_vinho.dart';
export 'src/coreflow_vocabulario.dart';
