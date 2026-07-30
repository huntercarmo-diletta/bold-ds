/// O CHROME da ferramenta, com as cores do Conta BOLD.
///
/// Chrome é a FERRAMENTA, não o produto: são os papéis da barra, do painel e da paleta
/// de blocos. Os nomes aqui não são os do DS do Bold — são papéis de ferramenta, e o
/// mapa se escreve uma vez.
///
/// Sem configurar, o pai cai num cinza de REFERÊNCIA que não é marca de ninguém. Cor
/// errada no chrome é feia, não fatal — por isso ele tem default e o registro de blocos
/// não tem.
library;

import 'package:conta_bold_design_system/conta_bold_design_system.dart';
import 'package:diletta_catalog_core/diletta_catalog_core.dart';
import 'package:flutter/widgets.dart';

/// A paleta do Bold, lida como instância — nunca uma cópia dos hexes.
///
/// Ler da paleta e não recravar valor é o que faz o chrome acompanhar a identidade: se
/// o rosa mudar no DS, a ferramenta muda com ele.
const _p = BoldPalette.bold;

/// Chrome CLARO.
final _claro = CoresDoChrome(
  white: _p.white,
  neutral10: _p.neutral10,
  neutral09: _p.neutral09,
  neutral08: _p.neutral08,
  neutral01: _p.neutral01,
  neutral02: _p.neutral02,
  neutral03: _p.neutral03,
  neutral04: _p.neutral04,
  neutral05: _p.neutral05,
  neutral06: _p.neutral06,
  neutral07: _p.neutral07,
  primary03: _p.primary03,
  primary04: _p.primary04,
  primary05: _p.primary05,
  primary07: _p.primary07,
  primary08: _p.primary08,
  primary09: _p.primary09,
  primarySelecionado: _p.primaryStateSelected,
  primaryTinte: _p.primary08,
  primaryHover: _p.primaryStateHover,
  sobreposicao: _p.black.withValues(alpha: 0.4),
  success04: _p.success04,
  success07: _p.success07,
  warning04: _p.warning04,
  warning07: _p.warning07,
  error04: _p.error04,
  error07: _p.error07,
  // O chrome do pai tem uma família de ACENTO, e o Bold descontinuou a rampa coral que
  // ocuparia esse lugar. Entra o ouro do selo: é família de verdade do produto e lê
  // distinta do rosa, que é o que a ferramenta precisa pra marcar "atenção" sem
  // parecer ação.
  accent03: _p.secure03,
  accent04: _p.secure04,
  accent07: _p.secure07,
  accent08: _p.secure08,
  sombra: [
    BoxShadow(
      color: _p.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ],
);

/// Chrome ESCURO.
///
/// Aqui `white` não é branco: é a SUPERFÍCIE da ferramenta, e `neutral10` é o fundo da
/// página. Os papéis mantêm o nome e trocam de valor — foi o que o pai fez com o
/// próprio scheme, e a conformidade cobra os três pares (borda visível, superfície
/// distinta do fundo, texto legível) nos DOIS modos.
final _escuro = CoresDoChrome(
  white: _p.surfaceEscura!,
  neutral10: _p.bgEscuro!,
  neutral09: _p.surfaceMutedEscura!,
  neutral08: const Color(0xFF3A3D4E),
  neutral01: _p.white,
  neutral02: const Color(0xFFE8E9EE),
  neutral03: const Color(0xFFC8CBD4),
  neutral04: const Color(0xFFB7BBC8),
  neutral05: const Color(0xFF8A8FA0),
  neutral06: const Color(0xFF686D7E),
  neutral07: const Color(0xFF4A4E5E),
  primary03: _p.primary03,
  primary04: _p.primary04,
  primary05: _p.primary05,
  primary07: _p.primary07,
  // No escuro o tinte é o lado ESCURO da rampa: o wash claro do claro viraria facho
  // de luz. Vinho quase preto, derivado do 01.
  primary08: const Color(0xFF2A0A18),
  primary09: const Color(0xFF1C0710),
  primarySelecionado: const Color(0xFF3D0F22),
  primaryTinte: const Color(0xFF2A0A18),
  primaryHover: const Color(0xFF2A0A18),
  sobreposicao: _p.black.withValues(alpha: 0.6),
  success04: _p.success05,
  success07: _p.success01,
  warning04: _p.warning05,
  warning07: _p.warning01,
  error04: _p.error05,
  error07: _p.error01,
  accent03: _p.secure05,
  accent04: _p.secure04,
  accent07: _p.secure02,
  accent08: const Color(0xFF241B06),
  sombra: [
    BoxShadow(
      color: _p.black.withValues(alpha: 0.4),
      blurRadius: 14,
      offset: const Offset(0, 2),
    ),
  ],
);

/// A tipografia do chrome: 11 papéis de ferramenta.
///
/// Os tamanhos são os da escala do DS, mas os PAPÉIS são da ferramenta — `rotuloPequeno`
/// é o mais usado dela (prop no inspetor, chip de token, legenda de bloco na paleta), e
/// não existe como papel de produto.
const _tipografia = TipografiaDoChrome(
  tituloGrande: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.25),
  titulo: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
  subtitulo: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
  corpo: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
  corpoPequeno: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400, height: 1.45),
  rotulo: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
  rotuloPequeno: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.25),
  legenda: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w400, height: 1.3),
  sobrescrito: TextStyle(
      fontSize: 10, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: 0.8),
  botao: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.2),
  // MONOESPAÇADO DE VERDADE, e não o token `mono` do DS.
  //
  // O `mono` do pai é a fonte da marca com tracking apertado (dígitos tabulares no
  // Bold), então não alinha em coluna — e alinhamento é requisito da ferramenta, onde
  // spec, JSON e árvore de blocos precisam ler como código. O pai registra isso como
  // pendência dele.
  //
  // Aqui a saída é a família do SISTEMA, e ela é legítima: o chrome é a ferramenta, não
  // a entrega. Quando o pai tiver um token `codigo` de verdade, isto vira uma linha
  // lendo o token.
  mono: TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: ['SF Mono', 'Menlo', 'Consolas', 'Liberation Mono'],
    fontSize: 12,
    height: 1.45,
  ),
);

/// Métricas: raio, ritmo e o movimento curto da ferramenta.
final _metricas = MetricasDoChrome(
  raioPainel: BorderRadius.circular(12),
  raioBotao: BorderRadius.circular(8),
  raioPilula: BorderRadius.circular(100),
  gapCompacto: DilettaSpacing.s2,
  gapPadrao: DilettaSpacing.s4,
  gapAmplo: DilettaSpacing.s6,
  // Movimento vem do DS porque movimento é linguagem: a ferramenta que documenta o
  // produto não deve ter outro ritmo.
  duracaoMicro: DilettaMotion.micro,
  curvaDeEntrada: DilettaMotion.enter,
);

/// O primeiro dos quatro plugues.
void configurarChromeDoBold() {
  CC.configurar(claro: _claro, escuro: _escuro);
  CT.configurar(_tipografia);
  CM.configurar(_metricas);
}
