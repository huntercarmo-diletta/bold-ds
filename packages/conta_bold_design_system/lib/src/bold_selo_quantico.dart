/// CONTA BOLD — o SELO de autorização quântica.
///
/// A marca que confirma o passo de autorização de uma transação. Fundo transparente de
/// propósito: entra num `Stack` por cima do conteúdo, e o scrim é de quem chama.
///
/// 9 usos no produto antigo — o mais usado dos componentes exclusivos. Fica no filho pra sempre:
/// é narrativa de marca, e valor de marca no pai é a regra que o pai não quebra.
///
/// ## O que a adaptação mudou, e as três primeiras são defeito
///
/// **1 · Três estados que eram dois booleanos.** A API antiga era `waiting` + `failed`, o que dá
/// quatro combinações pra três estados — e a quarta (`waiting: true, failed: true`) não tem
/// significado: o selo mostra o loop e ignora o `failed`. Agora é [BoldSeloEstado], enum fechado,
/// que é a exigência 7 do contrato de componente pelo motivo exato: com dois booleanos o estado
/// impossível se disfarça de estado válido em vez de nem compilar.
///
/// **2 · O rótulo era branco cravado, então o selo era só-escuro.** `Colors.white` no texto e no
/// trilho do anel: sobre o backdrop claro do produto, o rótulo desaparecia. Agora sai de papel
/// (`s.fg`), e os dois modos renderizam — exigência 4.
///
/// **3 · A tipografia era `BoldType.fontFamily` lida dentro do `CustomPainter`.** Painter não vê
/// tema, então a família ficava presa a um estático — o mesmo defeito que o pai consertou na
/// v0.5.0 num `DefaultTextStyle` substituído. Agora o estilo é resolvido no widget e entregue
/// pronto ao painter, que deixou de saber que fontes existem.
///
/// **4 · Nove literais de cor viraram zero.** Dois eram exatos da paleta (`#2FD27A` é
/// `success05`, `#FF4D5E` é `error05`) e os outros sete eram violeta, roxo, laranja claro e três
/// pares de tinta escura. Tudo derivado agora: o polo profundo é [BoldVinho], o claro é o rosa, o
/// acento é a rampa de laranja, e as tintas escuras são o degrau 01 do estado aprofundado por
/// função — não por hex novo.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:flutter/widgets.dart';

import 'bold_palette.dart';
import 'bold_vinho.dart';

/// Os três estados do selo. Fechado, e sem quarto caso possível.
enum BoldSeloEstado {
  /// Loop indefinido de "protegendo": anel girando, nós orbitando, chave pulsando. Dura o tempo
  /// que o backend precisar.
  protegendo,

  /// Toca a conclusão de sucesso uma vez (chave → check, anel fecha em verde, estouro, rótulo).
  autorizado,

  /// Toca a conclusão de falha uma vez (anel em vermelho, chave → X, tremor, rótulo).
  negado,
}

/// O selo.
///
/// ```dart
/// BoldSeloQuantico(
///   estado: pendente ? BoldSeloEstado.protegendo : BoldSeloEstado.autorizado,
///   aoConcluir: fechar,
/// )
/// ```
class BoldSeloQuantico extends StatefulWidget {
  const BoldSeloQuantico({
    super.key,
    this.estado = BoldSeloEstado.protegendo,
    this.aoConcluir,
    this.tamanho = 160,
    this.mostrarRotulo = true,
    this.rotuloAutorizado = 'Autorização Quântica',
    this.rotuloNegado = 'Autorização negada',
  });

  final BoldSeloEstado estado;

  /// Dispara UMA vez quando a conclusão (de sucesso ou de falha) termina. Um gancho e não dois:
  /// quem chama já sabe qual estado pediu, então dois ganchos seriam a mesma informação em dois
  /// lugares — e o segundo é o que fica desatualizado.
  final VoidCallback? aoConcluir;

  /// Lado do quadrado, em pixels lógicos.
  final double tamanho;

  final bool mostrarRotulo;
  final String rotuloAutorizado;
  final String rotuloNegado;

  @override
  State<BoldSeloQuantico> createState() => _BoldSeloQuanticoState();
}

class _BoldSeloQuanticoState extends State<BoldSeloQuantico>
    with TickerProviderStateMixin {
  /// Relógio livre do movimento ambiente (rotação, pulso, arco indeterminado).
  late final AnimationController _relogio;

  /// Progresso da conclusão, 0..1.
  late final AnimationController _conclusao;
  bool _disparou = false;

  bool get _protegendo => widget.estado == BoldSeloEstado.protegendo;
  bool get _negado => widget.estado == BoldSeloEstado.negado;

  @override
  void initState() {
    super.initState();
    _relogio = AnimationController(
      vsync: this,
      duration: DilettaMotion.spinner * 1000,
    )..repeat();
    _conclusao = AnimationController(vsync: this, duration: _duracaoDaConclusao)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && !_disparou) {
          _disparou = true;
          widget.aoConcluir?.call();
        }
      });
    if (!_protegendo) _conclusao.forward(from: 0);
  }

  /// 2s: é o tempo que a conclusão precisa pra ler como um gesto (anel fecha, glifo transforma,
  /// estouro, rótulo entra) em vez de piscar. Não é degrau de motion do pai porque não é
  /// transição — é uma cena.
  static const Duration _duracaoDaConclusao = Duration(milliseconds: 2000);

  @override
  void didUpdateWidget(covariant BoldSeloQuantico velho) {
    super.didUpdateWidget(velho);
    final eraProtegendo = velho.estado == BoldSeloEstado.protegendo;
    if (eraProtegendo && !_protegendo) {
      // Resolveu: pula pro meio, então a conclusão leva ~1.2s em vez de 2s.
      _disparou = false;
      _conclusao.forward(from: 0.5);
    } else if (!eraProtegendo && _protegendo) {
      _conclusao.stop();
      _conclusao.value = 0;
      _disparou = false;
    }
  }

  @override
  void dispose() {
    _relogio.dispose();
    _conclusao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final p = BoldPalette.bold;

    return DilettaDevInfo(
      component: 'seloQuantico',
      props: {'estado': widget.estado.name, 'tamanho': '${widget.tamanho.toInt()}'},
      tokens: const [
        'BoldVinho.marca',
        'palette.primary05',
        'palette.warning05',
        'scheme.fg',
      ],
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([_relogio, _conclusao]),
          builder: (context, _) {
            final ms = (_relogio.lastElapsedDuration ?? Duration.zero)
                .inMilliseconds
                .toDouble();
            return CustomPaint(
              size: Size(widget.tamanho,
                  widget.tamanho * (widget.mostrarRotulo ? 1.32 : 1)),
              painter: _PintorDoSelo(
                agoraMs: ms,
                g: _protegendo ? 0.5 : _conclusao.value,
                protegendo: _protegendo,
                negado: _negado,
                mostrarRotulo: widget.mostrarRotulo,
                rotulo: _negado ? widget.rotuloNegado : widget.rotuloAutorizado,
                apoio: _negado ? 'tente novamente' : 'concluída · canal seguro',
                cores: _CoresDoSelo(
                  profundo: BoldVinho.marca,
                  claro: p.primary05,
                  acento: p.warning05,
                  fim: _negado ? p.error05 : p.success05,
                  fimApoio: _negado ? p.error06 : p.success06,
                  tintaDoChip: _negado ? p.error01 : p.success01,
                  tintaEmRepouso: p.primary01,
                  maisFundo: (c) => Color.lerp(c, p.black, 0.35)!,
                  trilho: s.fg.withValues(alpha: 0.08),
                ),
                // O estilo chega PRONTO: painter não vê tema, então resolver fonte lá dentro é
                // o que prendia a família num estático.
                estiloRotulo: DilettaType.labelLg.copyWith(color: s.fg),
                estiloApoio: DilettaType.labelSm,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// As cores que o painter usa, todas resolvidas antes de entrar.
class _CoresDoSelo {
  const _CoresDoSelo({
    required this.profundo,
    required this.claro,
    required this.acento,
    required this.fim,
    required this.fimApoio,
    required this.tintaDoChip,
    required this.tintaEmRepouso,
    required this.maisFundo,
    required this.trilho,
  });

  /// O polo profundo (era o violeta `#7C3AED`): vinho da marca.
  final Color profundo;

  /// O polo claro (era o roxo `#A78BFA`): rosa da rampa.
  final Color claro;

  /// O acento dos nós e da cabeça do anel (era `#FF9A52`): laranja da rampa.
  final Color acento;

  /// A cor do fim: verde de sucesso ou vermelho de falha.
  final Color fim;
  final Color fimApoio;

  /// Tinta do chip no fim, e em repouso. O par escuro sai do degrau 01 aprofundado por
  /// [maisFundo] — não de hex novo.
  final Color tintaDoChip;
  final Color tintaEmRepouso;
  final Color Function(Color) maisFundo;

  /// Trilho do anel: papel do tema com alpha, e é o que faz o selo funcionar no claro.
  final Color trilho;
}

double _c01(double x) => x < 0 ? 0 : (x > 1 ? 1 : x);
double _entre(double a, double b, double t) => a + (b - a) * t;
double _suave(double t) => t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;

class _PintorDoSelo extends CustomPainter {
  _PintorDoSelo({
    required this.agoraMs,
    required this.g,
    required this.protegendo,
    required this.negado,
    required this.mostrarRotulo,
    required this.rotulo,
    required this.apoio,
    required this.cores,
    required this.estiloRotulo,
    required this.estiloApoio,
  });

  final double agoraMs;
  final double g;
  final bool protegendo;
  final bool negado;
  final bool mostrarRotulo;
  final String rotulo;
  final String apoio;
  final _CoresDoSelo cores;
  final TextStyle estiloRotulo;
  final TextStyle estiloApoio;

  Paint _brilho(Color c, double sigma) => Paint()
    ..color = c
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2, cy = s / 2;
    final raio = s * 0.34;
    final agora = agoraMs;

    final sucesso = _c01((g - 0.8) / 0.2);
    final montagem = _suave(_c01(g / 0.55));

    // ── brilho do núcleo (a única "camada de fundo", e é semitransparente) ──
    final corDoBrilho = sucesso > 0 ? cores.fim : cores.profundo;
    canvas.drawCircle(
      Offset(cx, cy),
      raio * 0.9,
      Paint()
        ..shader = ui.Gradient.radial(Offset(cx, cy), raio * 0.9, [
          corDoBrilho.withValues(alpha: 0.22 + sucesso * 0.12),
          corDoBrilho.withValues(alpha: 0),
        ]),
    );

    // ── nós de emaranhamento em órbita ──
    final teia = protegendo ? 1.0 : (1 - sucesso);
    if (teia > 0.01) {
      for (var anel = 0; anel < 2; anel++) {
        final rr = raio * (anel == 0 ? 0.62 : 0.92);
        final n = anel == 0 ? 5 : 8;
        final vel = anel == 0 ? 0.0011 : -0.0007;
        final achatamento = anel == 0 ? 0.5 : 0.42;
        for (var i = 0; i < n; i++) {
          final ang = (i / n) * math.pi * 2 + agora * vel;
          final px = cx + math.cos(ang) * rr;
          final py = cy + math.sin(ang) * rr * achatamento;
          final profundidade = (math.sin(ang) + 1) / 2;
          final a = teia * (0.25 + profundidade * 0.6);
          final cor = anel == 1 ? cores.acento : cores.claro;
          final tam = 1.2 + profundidade * 1.6;
          if (profundidade > 0.3) {
            canvas.drawCircle(Offset(px, py), tam + 1.4,
                _brilho(cor.withValues(alpha: a * 0.5), 3.5 * profundidade));
          }
          canvas.drawCircle(
              Offset(px, py), tam, Paint()..color = cor.withValues(alpha: a));
        }
      }
    }

    // ── anel de progresso ──
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: raio);
    canvas.drawCircle(
        Offset(cx, cy),
        raio,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = cores.trilho);
    final tintaDoAnel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset(cx - raio, cy),
        Offset(cx + raio, cy),
        [
          cores.profundo,
          cores.claro,
          sucesso > 0 ? cores.fim : cores.acento,
        ],
        [0.0, 0.5, 1.0],
      );
    final double inicio, arco;
    if (protegendo) {
      inicio = (agora * 0.004) % (math.pi * 2);
      arco = math.pi * 0.6 + math.sin(agora * 0.003) * 0.5;
    } else {
      inicio = -math.pi / 2;
      arco = g * math.pi * 2;
    }
    canvas.drawArc(rect, inicio, arco, false, tintaDoAnel);

    final anguloDaCabeca = inicio + arco;
    final hx = cx + math.cos(anguloDaCabeca) * raio;
    final hy = cy + math.sin(anguloDaCabeca) * raio;
    final corDaCabeca = sucesso > 0 ? cores.fim : cores.acento;
    canvas.drawCircle(
        Offset(hx, hy), 6, _brilho(corDaCabeca.withValues(alpha: 0.9), 6));
    canvas.drawCircle(Offset(hx, hy), 3.6, Paint()..color = corDaCabeca);

    // ── chip central (fechadura → check ou X) ──
    final pulso = 1 + math.sin(agora * 0.004) * 0.04;
    final chip = raio * 0.62 * pulso;
    canvas.save();
    // Tremor horizontal amortecido na falha.
    final tremor = negado && sucesso > 0
        ? math.sin(sucesso * math.pi * 5) * (1 - sucesso) * 5
        : 0.0;
    canvas.translate(cx + tremor, cy);
    final chipRect =
        Rect.fromCenter(center: Offset.zero, width: chip, height: chip);
    final chipRRect =
        RRect.fromRectAndRadius(chipRect, Radius.circular(chip * 0.3));
    final opacidade = math.max(montagem, sucesso);
    canvas.drawRRect(
        chipRRect,
        _brilho(
            (sucesso > 0 ? cores.fim : cores.profundo)
                .withValues(alpha: opacidade),
            9));
    final tintaBase = sucesso > 0 ? cores.tintaDoChip : cores.tintaEmRepouso;
    canvas.drawRRect(
        chipRRect,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(-chip / 2, -chip / 2),
            Offset(chip / 2, chip / 2),
            [tintaBase, cores.maisFundo(tintaBase)],
          ));
    canvas.drawRRect(
        chipRRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = (sucesso > 0 ? cores.fim : cores.claro)
              .withValues(alpha: opacidade * (sucesso > 0 ? 0.75 : 0.6)));

    final escala = chip / 52; // o glifo foi desenhado com chip = 52
    if (sucesso > 0) {
      final t = _suave(_c01(sucesso));
      final tinta = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * escala
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = cores.fim;
      if (negado) {
        // chave → X
        final a1 = Offset(-9 * escala, -9 * escala);
        final a2 = Offset(9 * escala, 9 * escala);
        final b1 = Offset(9 * escala, -9 * escala);
        final b2 = Offset(-9 * escala, 9 * escala);
        if (t < 0.5) {
          final k = t / 0.5;
          canvas.drawLine(
              a1, Offset(_entre(a1.dx, a2.dx, k), _entre(a1.dy, a2.dy, k)), tinta);
        } else {
          canvas.drawLine(a1, a2, tinta);
          final k = (t - 0.5) / 0.5;
          canvas.drawLine(
              b1, Offset(_entre(b1.dx, b2.dx, k), _entre(b1.dy, b2.dy, k)), tinta);
        }
      } else {
        // chave → check
        final p1 = Offset(-11 * escala, 1 * escala);
        final p2 = Offset(-3 * escala, 9 * escala);
        final p3 = Offset(12 * escala, -9 * escala);
        final caminho = Path()..moveTo(p1.dx, p1.dy);
        if (t < 0.5) {
          final k = t / 0.5;
          caminho.lineTo(_entre(p1.dx, p2.dx, k), _entre(p1.dy, p2.dy, k));
        } else {
          caminho.lineTo(p2.dx, p2.dy);
          final k = (t - 0.5) / 0.5;
          caminho.lineTo(_entre(p2.dx, p3.dx, k), _entre(p2.dy, p3.dy, k));
        }
        canvas.drawPath(caminho, tinta);
      }
    } else {
      final tinta = Paint()
        ..color = cores.claro.withValues(alpha: 0.9 * opacidade);
      canvas.drawCircle(Offset(0, -4 * escala), 6 * escala, tinta);
      final recorte = Path()
        ..moveTo(-3 * escala, -1 * escala)
        ..lineTo(3 * escala, -1 * escala)
        ..lineTo(5 * escala, 12 * escala)
        ..lineTo(-5 * escala, 12 * escala)
        ..close();
      canvas.drawPath(recorte, tinta);
    }
    canvas.restore();

    // ── estouro do fim ──
    if (sucesso > 0 && sucesso < 1) {
      final b = _suave(sucesso);
      for (var i = 0; i < 14; i++) {
        final ang = (i / 14) * math.pi * 2;
        final rr = raio * 0.5 + b * raio * 0.7;
        canvas.drawCircle(
            Offset(cx + math.cos(ang) * rr, cy + math.sin(ang) * rr),
            2.4 * (1 - b) + 0.5,
            Paint()
              ..color = (i % 3 == 0 ? cores.acento : cores.fim)
                  .withValues(alpha: (1 - b) * 0.9));
      }
    }

    // ── rótulo ──
    if (mostrarRotulo && sucesso > 0.01) {
      _texto(canvas, rotulo, cx, s + s * 0.02,
          estiloRotulo.copyWith(color: estiloRotulo.color?.withValues(alpha: sucesso)));
      _texto(canvas, apoio, cx, s + s * 0.13,
          estiloApoio.copyWith(color: cores.fimApoio.withValues(alpha: sucesso)));
    }
  }

  void _texto(Canvas canvas, String t, double cx, double y, TextStyle estilo) {
    final tp = TextPainter(
      text: TextSpan(text: t, style: estilo),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, y));
  }

  @override
  bool shouldRepaint(covariant _PintorDoSelo old) =>
      old.agoraMs != agoraMs ||
      old.g != g ||
      old.protegendo != protegendo ||
      old.negado != negado ||
      old.mostrarRotulo != mostrarRotulo;
}
