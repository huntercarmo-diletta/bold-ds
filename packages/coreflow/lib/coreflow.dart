/// O PAI da família Coreflow.
///
/// Fase 0 da separação (`docs/2026-09-04-adr-o-coreflow-e-o-pai.md`): o pacote nasce só com a
/// linguagem do avô re-exportada. Os componentes `Coreflow*` chegam na fase 2, depois do
/// veredito do dono do DS. O que NUNCA chega: cor, fonte, logo, arte ou nome de produto — o gate
/// `o_coreflow_nao_cita_bold` mede isso em `lib/` inteiro, comentário incluído.
library coreflow;

export 'package:diletta_design_system/diletta_design_system.dart';
