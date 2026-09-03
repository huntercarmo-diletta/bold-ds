/// CONTA BOLD — o VISOR do leitor de código, e o diferencial deste produto.
///
/// Nenhum outro filho lê código: este lê **QR e código de barras**, classifica pelo conteúdo e
/// roteia — Pix por EMV, boleto por linha digitável, autorização de transação por QR próprio.
///
/// ## O corte, e ele é a decisão que importa
///
/// A tela de scanner do produto tem 603 linhas e depende de `mobile_scanner`, `permission_handler`,
/// roteador e injeção de estado. **Nada disso entra no DS.** Um design system que arrasta plugin de
/// câmera obriga todo consumidor a carregar câmera — inclusive o catálogo, que só quer desenhar.
///
/// O que entra é o que é DESENHO e o que é CONHECIMENTO:
///
/// - **[CoreflowVisorDeCodigo]**, o overlay: cantos em colchete, varredura com rastro, o segundo quadro
///   em saltos de câmera de cinema e o rótulo com linha de chamada. 100%
///   `CustomPainter`, zero dependência;
/// - **[CoreflowFormatosDeCodigo]**, a lista de formatos que este produto precisa ler. É a peça de
///   conhecimento mais fácil de perder e a que já custou um bug de QA — o boleto brasileiro é ITF
///   de 44 dígitos, e o default da plataforma **não habilita 1D**. Fica declarada aqui, com o
///   motivo, e o app traduz pra o enum do plugin.
///
/// ## O que mudou na adaptação
///
/// **Quatro literais de cor viraram zero.** Eram âmbar `#FFB300`, verde neon `#39FF14`, vermelho
/// `#FF3B30` e um amarelo claro de fantasma. Viraram `warning04`, `success05`, `error05` e
/// `warning06` — e em 03/09 sobraram três: o alvo fantasma saiu, e com ele o `warning06`.
///
/// O verde neon é a mudança que se vê: ele era estética de "visão de máquina" e passa a ser o
/// verde da marca. Está registrado porque é escolha, não descuido — a alternativa era um quinto
/// valor de marca fora da rampa, e a régua deste filho já respondeu isso três vezes (gradiente,
/// backdrop, selo).
///
/// **A fonte do rótulo era `'monospace'` cravada.** Agora é o degrau de dado técnico do pai
/// (`numericXs`), que é o que este filho pediu na v0.1.9 — e que existe exatamente pra número em
/// coluna, que é o caso de um código lido.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';


/// O que o leitor precisa reconhecer, e por quê.
///
/// Lista declarada em vez de deixada no default do plugin porque o default **não habilita os
/// formatos 1D** — e o boleto brasileiro é 1D. Isso já apareceu como bug de QA: boleto de 44
/// dígitos não era reconhecido.
abstract final class CoreflowFormatosDeCodigo {
  /// QR: cobre Pix (EMV copia-e-cola), pareamento de dispositivo e autorização de transação.
  static const String qr = 'qrCode';

  /// Boleto brasileiro: 44 dígitos em **Interleaved 2 of 5**. Os três nomes cobrem o ITF genérico,
  /// a variante com dígito verificador e o alias legado ITF-14.
  static const List<String> boleto = ['itf2of5', 'itf2of5WithChecksum', 'itf14'];

  /// Convênio e concessionária costumam vir em Code 128 ou Code 39; EAN-13 aparece em ficha de
  /// compensação antiga.
  static const List<String> convenio = ['code128', 'code39', 'ean13'];

  /// A lista inteira, na ordem em que o app deve declarar no plugin.
  static const List<String> todos = [qr, ...boleto, ...convenio];
}

/// Estado de um alvo desenhado no visor.
enum CoreflowAlvoEstado {
  /// Analisando: o código está em vista e ainda não foi classificado.
  analisando,

  /// Relevante: é um código que este app sabe tratar.
  relevante,

  /// Irrelevante: leu, entendeu, e não é coisa nossa.
  irrelevante,
}

/// Um alvo rastreado no visor.
///
/// Guarda o `codigo` como IDENTIDADE: é o que faz a re-detecção do mesmo QR deslizar a caixa em
/// vez de piscar uma nova. E guarda o `visto` pra o alvo sobreviver a frames sem detecção — sem
/// isso a caixa pisca em qualquer tremor de mão.
class CoreflowAlvo {
  CoreflowAlvo({
    required this.area,
    required this.estado,
    this.rotulo,
    this.centralizado = false,
    this.codigo,
  }) : visto = DateTime.now();

  /// Área do código em coordenadas da IMAGEM analisada.
  Rect area;
  CoreflowAlvoEstado estado;
  String? rotulo;

  /// Sem cantos confiáveis, o visor cai num retículo central em vez de desenhar no lugar errado.
  bool centralizado;

  /// Identidade estável do alvo.
  String? codigo;

  /// Último frame em que apareceu. Quem poda é o app, com a política dele.
  DateTime visto;

  Rect? _desenhado;
  DateTime? _adquiridoEm;
}

/// O visor. Overlay puramente visual, desenhado sobre o preview da câmera.
class CoreflowVisorDeCodigo extends StatelessWidget {
  const CoreflowVisorDeCodigo({
    super.key,
    required this.alvos,
    required this.fase,
    this.descendo = true,
    this.tamanhoDaImagem = Size.zero,
  });

  final List<CoreflowAlvo> alvos;

  /// 0..1 da varredura. Quem anima é o app: o visor não tem controlador próprio, o que o deixa
  /// testável sem relógio.
  final double fase;

  final bool descendo;

  /// Tamanho do frame analisado, pra mapear os cantos. `Size.zero` ⇒ retículo central.
  final Size tamanhoDaImagem;

  @override
  Widget build(BuildContext context) {
    return DilettaDevInfo(
      component: 'visorDeCodigo',
      props: {'alvos': '${alvos.length}'},
      tokens: const ['palette.warning04', 'palette.success05', 'palette.error05'],
      child: CustomPaint(
        size: Size.infinite,
        painter: _PintorDoVisor(
          paleta: DilettaTheme.schemeOf(context).palette,
          alvos: alvos,
          fase: fase,
          descendo: descendo,
          tamanhoDaImagem: tamanhoDaImagem,
          estiloDoRotulo: DilettaType.numericXs,
        ),
      ),
    );
  }
}

class _PintorDoVisor extends CustomPainter {
  _PintorDoVisor({
    required DilettaPalette paleta,
    required this.alvos,
    required this.fase,
    required this.descendo,
    required this.tamanhoDaImagem,
    required this.estiloDoRotulo,
  }) : _p = paleta;

  final List<CoreflowAlvo> alvos;
  final double fase;
  final bool descendo;
  final Size tamanhoDaImagem;
  final TextStyle estiloDoRotulo;

  /// A paleta de quem montou o visor.
  ///
  /// Era `static const _p = BoldPalette.bold`. Os quatro valores que ele lê são semânticos e
  /// neutros (`success05`, `error05`, `warning04`, `black`) — a regra do pai diz que
  /// esses são invariantes, então cravar aqui não pintava errado hoje. Mas invariante por REGRA e
  /// congelado por LEITOR são coisas diferentes, e a segunda não se mede: um produto que declare
  /// outro `error05` receberia o do Bold sem nada acusar.
  final DilettaPalette _p;

  Color _cor(CoreflowAlvoEstado e) => switch (e) {
        CoreflowAlvoEstado.relevante => _p.success05,
        CoreflowAlvoEstado.irrelevante => _p.error05,
        CoreflowAlvoEstado.analisando => _p.warning04,
      };

  /// Mapeia a área da IMAGEM pro canvas assumindo `BoxFit.cover` — é como o preview preenche.
  Rect _paraCanvas(CoreflowAlvo a, Size size) {
    if (a.centralizado ||
        tamanhoDaImagem == Size.zero ||
        tamanhoDaImagem.width == 0 ||
        tamanhoDaImagem.height == 0) {
      final lado = math.min(size.width, size.height) * 0.55;
      return Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2), width: lado, height: lado);
    }
    final escala = math.max(
        size.width / tamanhoDaImagem.width, size.height / tamanhoDaImagem.height);
    final dx = (size.width - tamanhoDaImagem.width * escala) / 2;
    final dy = (size.height - tamanhoDaImagem.height * escala) / 2;
    return Rect.fromLTRB(
      a.area.left * escala + dx,
      a.area.top * escala + dy,
      a.area.right * escala + dx,
      a.area.bottom * escala + dy,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final alvo in alvos) {
      final destino = _paraCanvas(alvo, size);

      // Aquisição: a caixa nasce GRANDE e fecha sobre o código.
      if (alvo._desenhado == null) {
        final grande =
            math.max(destino.longestSide * 2.4, size.shortestSide * 0.6);
        alvo._desenhado = Rect.fromCenter(
            center: destino.center, width: grande, height: grande);
        alvo._adquiridoEm = DateTime.now();
      }
      // Lock-on lento (~11% por frame): desliza em vez de pular.
      alvo._desenhado = Rect.lerp(alvo._desenhado, destino, 0.11) ?? destino;
      final r = alvo._desenhado!;
      final cor = _cor(alvo.estado);

      canvas.drawRect(
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..color = cor.withValues(alpha: 0.16)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );

      final traco = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.75
        ..color = cor;

      final len = math.min(r.width, r.height) * 0.22;
      _colchete(canvas, r.topLeft, const Offset(1, 0), const Offset(0, 1), len, traco);
      _colchete(canvas, r.topRight, const Offset(-1, 0), const Offset(0, 1), len, traco);
      _colchete(canvas, r.bottomLeft, const Offset(1, 0), const Offset(0, -1), len, traco);
      _colchete(canvas, r.bottomRight, const Offset(-1, 0), const Offset(0, -1), len, traco);

      _varredura(canvas, r, cor);
      _segundoQuadro(canvas, alvo, destino, size, cor);
      if (alvo.rotulo case final rotulo? when rotulo.isNotEmpty) {
        _rotulo(canvas, size, r, rotulo, cor);
      }
    }
  }

  /// Varredura estilo radar: uma linha atravessa a caixa carregando um rastro atrás dela.
  void _varredura(Canvas canvas, Rect r, Color cor) {
    final y = r.top + r.height * fase;
    canvas.save();
    canvas.clipRect(r);

    const alphaJuntoDaLinha = 0.55;
    final rastro = r.height * 0.55;
    if (descendo) {
      final topo = math.max(r.top, y - rastro);
      if (y - topo > 1) {
        canvas.drawRect(
          Rect.fromLTRB(r.left, topo, r.right, y),
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(r.left, topo),
              Offset(r.left, y),
              [cor.withValues(alpha: 0), cor.withValues(alpha: alphaJuntoDaLinha)],
              const [0, 1],
            ),
        );
      }
    } else {
      final base = math.min(r.bottom, y + rastro);
      if (base - y > 1) {
        canvas.drawRect(
          Rect.fromLTRB(r.left, y, r.right, base),
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(r.left, y),
              Offset(r.left, base),
              [cor.withValues(alpha: alphaJuntoDaLinha), cor.withValues(alpha: 0)],
              const [0, 1],
            ),
        );
      }
    }

    canvas.drawLine(
      Offset(r.left, y),
      Offset(r.right, y),
      Paint()
        ..strokeWidth = 3
        ..shader = ui.Gradient.linear(
          Offset(r.left, y - 10),
          Offset(r.left, y + 10),
          [
            cor.withValues(alpha: 0),
            cor.withValues(alpha: 0.95),
            cor.withValues(alpha: 0),
          ],
          const [0, 0.5, 1],
        ),
    );
    canvas.restore();
  }

  /// O segundo quadro: começa ~1s depois da aquisição e fecha em SALTOS, com cross-fade. É ritmo
  /// de câmera de cinema, e é de propósito que ele não desliza como o primeiro.
  void _segundoQuadro(
      Canvas canvas, CoreflowAlvo alvo, Rect destino, Size size, Color cor) {
    final adquirido = alvo._adquiridoEm;
    if (adquirido == null) return;
    final decorrido =
        DateTime.now().difference(adquirido).inMilliseconds - 1000;
    if (decorrido < 0) return;

    const passos = 6;
    const msPorPasso = 150;
    const fracaoDeCrossFade = 0.6;
    final larguraGrande =
        math.max(destino.longestSide * 2.2, size.shortestSide * 0.55);
    final inicio = Rect.fromCenter(
        center: destino.center, width: larguraGrande, height: larguraGrande);
    Rect quadroEm(int i) =>
        Rect.lerp(inicio, destino.inflate(7), i / (passos - 1))!;
    void desenha(Rect q, double opacidade) {
      if (opacidade <= 0.02) return;
      canvas.drawRect(
        q,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.25
          ..color = cor.withValues(alpha: 0.85 * opacidade.clamp(0.0, 1.0)),
      );
    }

    final passoFracionario = decorrido / msPorPasso;
    final atual = math.min(passoFracionario.floor(), passos - 1);
    if (atual >= passos - 1) {
      desenha(quadroEm(passos - 1), 1);
      return;
    }
    final entrada =
        ((passoFracionario - atual) / fracaoDeCrossFade).clamp(0.0, 1.0);
    if (atual >= 1) desenha(quadroEm(atual - 1), 1 - entrada);
    desenha(quadroEm(atual), entrada);
  }

  /// Rótulo com linha de chamada: diagonal a partir da borda, cotovelo, tick horizontal, e o texto
  /// acima — sempre dentro da tela, porque mensagem de erro pode ser longa.
  void _rotulo(Canvas canvas, Size size, Rect r, String texto, Color cor) {
    final larguraMaxima = math.min(size.width - 16.0, 240.0);
    final tp = TextPainter(
      text: TextSpan(
        text: texto,
        style: estiloDoRotulo.copyWith(
          color: cor,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          height: 1.25,
          shadows: [Shadow(color: _p.black, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 3,
      ellipsis: '…',
    )..layout(maxWidth: larguraMaxima);

    final cabeEmCima = r.top > 110;
    final ancora = Offset(r.center.dx, cabeEmCima ? r.top : r.bottom);
    final vertical = cabeEmCima ? -1.0 : 1.0;
    const diagonal = 26.0;
    const tick = 44.0;
    final paraDireita = ancora.dx < size.width * 0.5;
    final horizontal = paraDireita ? 1.0 : -1.0;
    final cotovelo = Offset(
        ancora.dx + diagonal * horizontal, ancora.dy + diagonal * vertical);
    final fim = Offset(cotovelo.dx + tick * horizontal, cotovelo.dy);

    final linha = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = cor;
    canvas.drawLine(ancora, cotovelo, linha);
    canvas.drawLine(cotovelo, fim, linha);
    canvas.drawCircle(ancora, 3.75, Paint()..color = cor);

    final querEsquerda = paraDireita ? cotovelo.dx + 3 : fim.dx + 3;
    final querTopo = cotovelo.dy - tp.height - 3;
    tp.paint(
      canvas,
      Offset(
        querEsquerda
            .clamp(8.0, math.max(8.0, size.width - tp.width - 8))
            .toDouble(),
        querTopo
            .clamp(8.0, math.max(8.0, size.height - tp.height - 8))
            .toDouble(),
      ),
    );
  }

  void _colchete(
      Canvas c, Offset canto, Offset hx, Offset vy, double len, Paint p) {
    c.drawLine(canto, canto + hx * len, p);
    c.drawLine(canto, canto + vy * len, p);
  }

  @override
  bool shouldRepaint(covariant _PintorDoVisor old) => true;
}
