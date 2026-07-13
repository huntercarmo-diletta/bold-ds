import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/bold_colors.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — Quantum Authorization pairing animation (native Flutter port
/// of the design-system prototype).
///
/// Two pieces:
/// * [BoldQuantumCore]   — the painted animation itself (lattice, entanglement
///   web, key-exchange photons, assembling key chip, progress ring, success
///   burst). Drop it into any layout and feed it `progress` (0..1).
/// * [BoldQuantumPairingScreen] — the full screen from the prototype (header,
///   phase text, progress bar, step indicator) built on top of the core.
///
/// DATA-DRIVEN vs DEMO:
/// * Pass `progress` to drive the ring/steps/text from the REAL pairing flow
///   (BLE pair → ML-KEM keygen → encapsulate → ML-DSA sign → done). The
///   continuous motion (rotation, photons, pulsing) always runs on its own.
/// * Pass `progress: null` for a self-running ~11s demo loop (previews/tests).
///
/// ```dart
/// // real flow
/// BoldQuantumPairingScreen(progress: _pairing.progress, onCompleted: _finish);
/// // demo
/// const BoldQuantumPairingScreen();
/// ```

// ---- palette (mirrors the design tokens) -----------------------------------
const Color _violet = Color(0xFF7C3AED);
const Color _purple = Color(0xFFA78BFA);
const Color _orange = Color(0xFFF26619);
const Color _orangeL = Color(0xFFFF9A52);
const Color _green = Color(0xFF2FD27A);

double _clamp01(double x) => x < 0 ? 0 : (x > 1 ? 1 : x);
double _lerp(double a, double b, double t) => a + (b - a) * t;
double _ease(double t) =>
    t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;

const int _kTotalMs = 11000;
const int _kHoldMs = 1700;
const int _kLoopMs = _kTotalMs + _kHoldMs;

/// The painted quantum animation. Sizes to its box (give it a square-ish area).
class BoldQuantumCore extends StatefulWidget {
  const BoldQuantumCore({super.key, this.progress});

  /// 0..1 progress of the real pairing flow. Null = self-running demo loop.
  final double? progress;

  @override
  State<BoldQuantumCore> createState() => _BoldQuantumCoreState();
}

class _BoldQuantumCoreState extends State<BoldQuantumCore>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    // Free-running clock for continuous motion; we read elapsed time off it.
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _clock,
      builder: (context, _) {
        final ms =
            (_clock.lastElapsedDuration ?? Duration.zero).inMilliseconds.toDouble();
        final g = widget.progress != null
            ? _clamp01(widget.progress!)
            : _clamp01((ms % _kLoopMs) / _kTotalMs);
        return CustomPaint(
          painter: _QuantumPainter(nowMs: ms, g: g),
          size: Size.infinite,
        );
      },
    );
  }
}

class _QuantumPainter extends CustomPainter {
  _QuantumPainter({required this.nowMs, required this.g});
  final double nowMs;
  final double g;

  // ring config: radius, count, speed, vertical squash, direction
  static const _rings = [
    [44.0, 6.0, 0.00022, 0.42, 1.0],
    [66.0, 9.0, -0.00016, 0.5, -1.0],
    [88.0, 12.0, 0.00011, 0.58, 1.0],
  ];

  Paint _glow(Color c, double sigma) => Paint()
    ..color = c
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

  @override
  void paint(Canvas canvas, Size size) {
    final W = size.width, H = size.height;
    final cx = W / 2, cy = H * 0.46;
    final now = nowMs;

    // ---------- background lattice dots ----------
    final keygen = _clamp01((g - 0.30) / 0.22);
    final wave = g < 0.52 ? keygen : 1.0;
    final waveR = 30 + wave * 150 + math.sin(now * 0.002) * 6;
    const gap = 30.0;
    final dotPaint = Paint();
    for (double x = gap / 2; x < W; x += gap) {
      for (double y = gap / 2; y < H; y += gap) {
        final d = math.sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
        final near = math.exp(-math.pow((d - waveR) / 42, 2).toDouble());
        final tw = 0.04 + 0.03 * math.sin(now * 0.001 + x * 0.3 + y * 0.2);
        final a = _clamp01(tw + near * 0.5 * wave);
        dotPaint.color = const Color(0xFF9682FF).withValues(alpha: a);
        canvas.drawRect(Rect.fromLTWH(x - 0.9, y - 0.9, 1.8, 1.8), dotPaint);
      }
    }

    final topY = 30.0, botY = H - 26;

    // ---------- beam ----------
    final beamA = _clamp01((g - 0.16) / 0.12);
    if (beamA > 0) {
      final shader = ui.Gradient.linear(
        Offset(cx, topY), Offset(cx, botY),
        [
          _violet.withValues(alpha: 0),
          _purple.withValues(alpha: 0.5 * beamA),
          _orange.withValues(alpha: 0),
        ],
        [0.0, 0.5, 1.0],
      );
      canvas.drawLine(Offset(cx, topY), Offset(cx, botY),
          Paint()..shader = shader..strokeWidth = 1.4);
    }

    final success = _clamp01((g - 0.88) / 0.12);

    // top node
    _node(canvas, cx, topY, _purple, 'SERVIDOR BOLD', above: true);

    // ---------- discovery radar ----------
    if (g < 0.16) {
      final rp = g / 0.16;
      for (int k = 0; k < 3; k++) {
        final pr = ((rp * 3 + k * 0.55) % 1);
        canvas.drawCircle(
          Offset(cx, cy),
          pr * 110,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..color = _purple.withValues(alpha: (1 - pr) * 0.5),
        );
      }
    }

    // ---------- entanglement web ----------
    final webA = _clamp01((g - 0.18) / 0.18);
    if (webA > 0) {
      for (int ri = 0; ri < _rings.length; ri++) {
        final r = _rings[ri][0], n = _rings[ri][1].toInt(),
            sp = _rings[ri][2], sq = _rings[ri][3], dir = _rings[ri][4];
        final pts = <Offset>[];
        final depths = <double>[];
        for (int i = 0; i < n; i++) {
          final ang = (i / n) * math.pi * 2 + now * sp * dir;
          final px = cx + math.cos(ang) * r;
          final py = cy + math.sin(ang) * r * sq;
          pts.add(Offset(px, py));
          depths.add((math.sin(ang) + 1) / 2);
        }
        for (int i = 0; i < pts.length; i++) {
          final p = pts[i], q = pts[(i + 1) % pts.length];
          final a = webA * (0.12 + depths[i] * 0.33);
          canvas.drawLine(p, q,
              Paint()..color = _purple.withValues(alpha: a)..strokeWidth = 1);
        }
        for (int i = 0; i < pts.length; i++) {
          final depth = depths[i];
          final sz = 1.1 + depth * 1.8;
          final a = webA * (0.3 + depth * 0.7);
          final col = ri == 2 ? _orangeL : _purple;
          if (depth > 0.2) {
            canvas.drawCircle(pts[i], sz + 1.5,
                _glow(col.withValues(alpha: a * 0.6), 4 * depth));
          }
          canvas.drawCircle(pts[i], sz, Paint()..color = col.withValues(alpha: a));
        }
      }
    }

    // ---------- photons ----------
    if (g >= 0.52 && g < 0.88) {
      const N = 7;
      for (int i = 0; i < N; i++) {
        final dir = i % 2 == 0 ? 1 : -1;
        final f = ((now * 0.0006) + i / N) % 1;
        final col = dir > 0 ? _orangeL : _purple;
        for (int t = 0; t < 5; t++) {
          final tf = f - t * 0.03 * dir;
          final ty = dir > 0 ? _lerp(botY, topY, tf) : _lerp(topY, botY, tf);
          final a = (1 - t / 5) * 0.5;
          canvas.drawCircle(Offset(cx, ty), 2.6 - t * 0.4,
              Paint()..color = col.withValues(alpha: a));
        }
        final yy = dir > 0 ? _lerp(botY, topY, f) : _lerp(topY, botY, f);
        canvas.drawCircle(Offset(cx, yy), 5, _glow(col.withValues(alpha: 0.9), 6));
        canvas.drawCircle(Offset(cx, yy), 3, Paint()..color = col);
      }
    }

    // ---------- core ----------
    final assembly = _ease(_clamp01((g - 0.24) / 0.28));
    final pulse = 1 + math.sin(now * 0.004) * 0.03;
    final chip = 52 * pulse;

    // core glow
    final coreGlow = Paint()
      ..shader = ui.Gradient.radial(Offset(cx, cy), 70, [
        success > 0
            ? _green.withValues(alpha: 0.35 + success * 0.2)
            : _violet.withValues(alpha: 0.4),
        _violet.withValues(alpha: 0),
      ]);
    canvas.drawCircle(Offset(cx, cy), 70, coreGlow);

    // shards
    if (assembly < 1) {
      const shards = 6;
      for (int i = 0; i < shards; i++) {
        final ang = (i / shards) * math.pi * 2 + now * 0.001;
        final dist = (1 - assembly) * 56;
        final sx = cx + math.cos(ang) * dist, sy = cy + math.sin(ang) * dist;
        canvas.save();
        canvas.translate(sx, sy);
        canvas.rotate(ang + now * 0.002);
        final p = Paint()..color = (i % 2 == 0 ? _purple : _orangeL).withValues(alpha: (1 - assembly) * 0.9);
        canvas.drawRRect(
            RRect.fromRectAndRadius(const Rect.fromLTWH(-5, -5, 10, 10),
                const Radius.circular(3)),
            p);
        canvas.restore();
      }
    }

    // chip body
    canvas.save();
    canvas.translate(cx, cy);
    final chipOpacity = math.max(assembly, success);
    final chipRect = Rect.fromCenter(center: Offset.zero, width: chip, height: chip);
    final chipRRect = RRect.fromRectAndRadius(chipRect, const Radius.circular(16));
    canvas.drawRRect(
        chipRRect,
        _glow((success > 0 ? _green : _violet).withValues(alpha: chipOpacity), 11));
    canvas.drawRRect(
        chipRRect,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(-chip / 2, -chip / 2), Offset(chip / 2, chip / 2),
            success > 0
                ? [const Color(0xFF1C2B22), const Color(0xFF102018)]
                : [const Color(0xFF2A1D52), const Color(0xFF160F33)],
          )
          ..color = Colors.white.withValues(alpha: chipOpacity));
    canvas.drawRRect(
        chipRRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = (success > 0 ? _green : _purple)
              .withValues(alpha: chipOpacity * (success > 0 ? 0.7 : 0.6)));

    if (success > 0) {
      final s = _ease(_clamp01(success));
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = _green
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.6);
      const p1 = Offset(-11, 1), p2 = Offset(-3, 9), p3 = Offset(12, -9);
      final path = Path()..moveTo(p1.dx, p1.dy);
      if (s < 0.5) {
        final k = s / 0.5;
        path.lineTo(_lerp(p1.dx, p2.dx, k), _lerp(p1.dy, p2.dy, k));
      } else {
        path.lineTo(p2.dx, p2.dy);
        final k = (s - 0.5) / 0.5;
        path.lineTo(_lerp(p2.dx, p3.dx, k), _lerp(p2.dy, p3.dy, k));
      }
      canvas.drawPath(path, p);
    } else {
      final kp = Paint()..color = _purple.withValues(alpha: 0.9);
      canvas.drawCircle(const Offset(0, -4), 6, kp);
      final notch = Path()
        ..moveTo(-3, -1)
        ..lineTo(3, -1)
        ..lineTo(5, 12)
        ..lineTo(-5, 12)
        ..close();
      canvas.drawPath(notch, kp);
    }
    canvas.restore();

    // success burst
    if (success > 0 && success < 1) {
      final bs = _ease(success);
      const parts = 14;
      for (int i = 0; i < parts; i++) {
        final ang = (i / parts) * math.pi * 2;
        final rr = 30 + bs * 70;
        final px = cx + math.cos(ang) * rr, py = cy + math.sin(ang) * rr;
        canvas.drawCircle(
            Offset(px, py),
            2.4 * (1 - bs) + 0.5,
            Paint()
              ..color = (i % 3 == 0 ? _orangeL : _green).withValues(alpha: (1 - bs) * 0.9));
      }
    }

    // ---------- progress ring ----------
    const ringRadius = 104.0;
    final ringRect = Rect.fromCircle(center: Offset(cx, cy), radius: ringRadius);
    canvas.drawCircle(
        Offset(cx, cy),
        ringRadius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.white.withValues(alpha: 0.07));
    final a0 = -math.pi / 2, sweep = g * math.pi * 2;
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset(cx - ringRadius, cy), Offset(cx + ringRadius, cy),
        [_violet, _purple, success > 0 ? _green : _orangeL],
        [0.0, 0.5, 1.0],
      );
    canvas.drawArc(ringRect, a0, sweep, false, arcPaint);
    final a1 = a0 + sweep;
    final hx = cx + math.cos(a1) * ringRadius, hy = cy + math.sin(a1) * ringRadius;
    final headCol = success > 0 ? _green : _orangeL;
    canvas.drawCircle(Offset(hx, hy), 7, _glow(headCol.withValues(alpha: 0.9), 7));
    canvas.drawCircle(Offset(hx, hy), 4.5, Paint()..color = headCol);

    // bottom device node
    _node(canvas, cx, botY, success > 0 ? _green : _orangeL, 'SEU APARELHO',
        above: false);
  }

  void _node(Canvas canvas, double cx, double y, Color color, String label,
      {required bool above}) {
    canvas.drawCircle(Offset(cx, y), 8, _glow(color.withValues(alpha: 0.9), 8));
    canvas.drawCircle(Offset(cx, y), 5, Paint()..color = color);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: BoldType.fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0x8CFFFFFF),
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas,
        Offset(cx - tp.width / 2, above ? y - 12 - tp.height : y + 12));
  }

  @override
  bool shouldRepaint(covariant _QuantumPainter old) =>
      old.nowMs != nowMs || old.g != g;
}

// ---------------------------------------------------------------------------
// Full pairing screen
// ---------------------------------------------------------------------------

class _Phase {
  const _Phase(this.to, this.step, this.title, this.sub, this.subColor);
  final double to;
  final int step;
  final String title;
  final String sub;
  final Color subColor;
}

const List<_Phase> _phases = [
  _Phase(0.16, 0, 'Procurando seu aparelho', 'BLE · escaneando dispositivos', Color(0xFF9AA0B4)),
  _Phase(0.30, 0, 'Aparelho pareado', 'ID 9F·A1·7C · identidade verificada', Color(0xFF9AA0B4)),
  _Phase(0.52, 1, 'Gerando par de chaves', 'ML-KEM-768 · keygen', Color(0xFFF89B5E)),
  _Phase(0.72, 1, 'Trocando chaves', 'ML-KEM · encapsulando segredo', Color(0xFFF89B5E)),
  _Phase(0.88, 2, 'Assinando autorização', 'ML-DSA-65 · assinatura digital', Color(0xFFF89B5E)),
  _Phase(1.01, 3, 'Autorização Quântica ativada', 'canal pós-quântico estabelecido', Color(0xFF5BD597)),
];

_Phase _phaseFor(double g) {
  for (final p in _phases) {
    if (g <= p.to) return p;
  }
  return _phases.last;
}

/// The full Quantum Authorization pairing screen from the prototype: header,
/// the [BoldQuantumCore] animation, live phase text, progress bar and a 4-step
/// indicator (Parear · Chaves · Assinar · Pronto).
///
/// Wrap nothing — it builds its own dark surface. Feed [progress] from the real
/// flow, or omit it for the demo loop. [onCompleted] fires once when progress
/// first reaches 1.0. [onCancel] wires the bottom "Cancelar" affordance (hidden
/// if null).
class BoldQuantumPairingScreen extends StatefulWidget {
  const BoldQuantumPairingScreen({
    super.key,
    this.progress,
    this.onCompleted,
    this.onCancel,
    this.title = 'Autorização Quântica',
    this.subtitle =
        'Pareando seu aparelho ao novo sistema de autorização com criptografia resistente a computadores quânticos.',
  });

  final double? progress;
  final VoidCallback? onCompleted;
  final VoidCallback? onCancel;
  final String title;
  final String subtitle;

  @override
  State<BoldQuantumPairingScreen> createState() =>
      _BoldQuantumPairingScreenState();
}

class _BoldQuantumPairingScreenState extends State<BoldQuantumPairingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;
  bool _firedDone = false;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  double _progressFor(double ms) {
    if (widget.progress != null) return _clamp01(widget.progress!);
    // Fluxo REAL (tem onCompleted): toca UMA vez e congela no frame final —
    // com o sheet do passkey abrindo em seguida, o loop recomeçava atrás
    // (onboarding do Diego/relato do Michel). O loop contínuo fica só para
    // previews/demos (sem onCompleted).
    if (widget.onCompleted != null) return _clamp01(ms / _kTotalMs);
    return _clamp01((ms % _kLoopMs) / _kTotalMs);
  }

  @override
  Widget build(BuildContext context) {
    // Material provê o ancestral que o Text exige (senão sai com o sublinhado
    // amarelo de "missing Material") e pinta o fundo igual ao Container.
    return Material(
      color: BoldColors.background,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _clock,
          builder: (context, _) {
            final ms = (_clock.lastElapsedDuration ?? Duration.zero)
                .inMilliseconds
                .toDouble();
            final g = _progressFor(ms);
            final phase = _phaseFor(g);
            final success = g >= 0.88;

            if (g >= 1.0 && !_firedDone) {
              _firedDone = true;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => widget.onCompleted?.call());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  // header badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _violet.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: _violet.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  color: _purple, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 7),
                            Text('PÓS-QUÂNTICO',
                                style: TextStyle(
                                  fontFamily: BoldType.fontFamily,
                                  fontSize: 10.5,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFC4B5FD),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(widget.title,
                      style: TextStyle(
                        fontFamily: BoldType.fontFamily,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.1,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 6),
                  Text(widget.subtitle,
                      style: TextStyle(
                        fontFamily: BoldType.fontFamily,
                        fontSize: 14,
                        height: 1.55,
                        color: Color(0xFFBFC3CF),
                      )),
                  // animation
                  Expanded(child: BoldQuantumCore(progress: widget.progress)),
                  // status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(phase.title,
                            style: TextStyle(
                              fontFamily: BoldType.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: Colors.white,
                            )),
                      ),
                      Text('${(g * 100).round()}%',
                          style: TextStyle(
                            fontFamily: BoldType.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: success ? _green : _orangeL,
                          )),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(phase.sub,
                      style: TextStyle(
                        fontFamily: BoldType.fontFamily,
                        fontSize: 12,
                        letterSpacing: 0.4,
                        color: phase.subColor,
                      )),
                  const SizedBox(height: 14),
                  // progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Stack(
                      children: [
                        Container(
                            height: 6, color: Colors.white.withValues(alpha: 0.08)),
                        FractionallySizedBox(
                          widthFactor: g,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              gradient: LinearGradient(
                                colors: success
                                    ? const [_violet, _purple, _green]
                                    : const [_violet, _purple, _orangeL],
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // steps
                  Row(
                    children: [
                      _step('Parear', 0, phase.step),
                      _step('Chaves', 1, phase.step),
                      _step('Assinar', 2, phase.step),
                      _step('Pronto', 3, phase.step),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.onCancel != null)
                    Center(
                      child: TextButton(
                        onPressed: widget.onCancel,
                        child: Text('Cancelar',
                            style: TextStyle(
                                fontFamily: BoldType.fontFamily,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9AA0B4))),
                      ),
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text('Mantenha o app aberto durante o processo',
                            style: TextStyle(
                                fontFamily: BoldType.fontFamily,
                                fontSize: 11,
                                color: Color(0xFF686D7E))),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _step(String label, int index, int activeStep) {
    final done = index < activeStep;
    final active = index == activeStep;
    Color dotColor;
    List<BoxShadow>? glow;
    if (done) {
      dotColor = _green;
      glow = [BoxShadow(color: _green.withValues(alpha: 0.7), blurRadius: 8)];
    } else if (active) {
      dotColor = index == 3 ? _green : _orangeL;
      glow = [BoxShadow(color: dotColor.withValues(alpha: 0.8), blurRadius: 10)];
    } else {
      dotColor = Colors.white.withValues(alpha: 0.14);
      glow = null;
    }
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: glow,
            ),
          ),
          const SizedBox(height: 7),
          Text(label,
              style: TextStyle(
                fontFamily: BoldType.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: done || active
                    ? (done ? const Color(0xFFBFC3CF) : Colors.white)
                    : const Color(0xFF686D7E),
              )),
        ],
      ),
    );
  }
}
