import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/bold_typography.dart';

/// Conta BOLD — Quantum Authorization SEAL.
///
/// A compact, **transparent-background** mark that confirms the quantum
/// authorization step of a transaction. Designed to be shown right after the
/// Face ID animation, as an overlay / watermark on top of the transaction
/// screen.
///
/// Three states, driven by [waiting] + [failed]:
/// * `waiting: true`  — an indefinite "securing" loop (rotating quantum ring +
///   orbiting entanglement nodes + pulsing key). Use this while the backend is
///   still confirming the transaction, so the animation can last as long as
///   needed.
/// * `waiting: false, failed: false` — plays the SUCCESS completion (key → check
///   morph, ring closes to green, burst, label) once, then calls [onCompleted].
/// * `waiting: false, failed: true`  — plays the FAILURE completion (ring turns
///   red, key → X morph, shake, red burst, "negada" label) once, then calls
///   [onFailed] (or [onCompleted] if [onFailed] is null).
///
/// Typical flow:
/// ```dart
/// // While the transaction is in flight:
/// BoldQuantumSeal(waiting: _pending, onCompleted: _dismiss, onFailed: _retry);
/// // Resolve it: set waiting:false. If the server rejected, also set
/// // failed:true → it plays the red X end-state and calls onFailed.
/// ```
///
/// Paints nothing opaque behind the mark — drop it in a [Stack] over your
/// content (a translucent scrim is up to you).
class BoldQuantumSeal extends StatefulWidget {
  const BoldQuantumSeal({
    super.key,
    this.waiting = false,
    this.failed = false,
    this.onCompleted,
    this.onFailed,
    this.size = 160,
    this.showLabel = true,
    this.label = 'Autorização Quântica',
    this.failLabel = 'Autorização negada',
  });

  /// While true, loops the securing state indefinitely. Set false to finish.
  final bool waiting;

  /// When the seal resolves (waiting→false), choose the end-state: false = green
  /// success (check), true = red failure (X).
  final bool failed;

  /// Fired once when the SUCCESS completion reaches the end.
  final VoidCallback? onCompleted;

  /// Fired once when the FAILURE completion reaches the end. Falls back to
  /// [onCompleted] when null.
  final VoidCallback? onFailed;

  /// Square side of the mark in logical pixels.
  final double size;

  /// Show the label line under the mark on completion.
  final bool showLabel;

  /// Label shown on success / failure respectively.
  final String label;
  final String failLabel;

  @override
  State<BoldQuantumSeal> createState() => _BoldQuantumSealState();
}

class _BoldQuantumSealState extends State<BoldQuantumSeal>
    with TickerProviderStateMixin {
  // Free-running clock for ambient motion (rotation, pulse, indeterminate arc).
  late final AnimationController _clock;
  // Drives completion progress 0..1 (the "end" portion of the original anim).
  late final AnimationController _resolve;
  bool _fired = false;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..repeat();
    _resolve = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed && !_fired) {
          _fired = true;
          if (widget.failed) {
            (widget.onFailed ?? widget.onCompleted)?.call();
          } else {
            widget.onCompleted?.call();
          }
        }
      });
    if (!widget.waiting) {
      // Full one-shot completion from the start (~2s).
      _resolve.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant BoldQuantumSeal old) {
    super.didUpdateWidget(old);
    if (old.waiting && !widget.waiting) {
      // Transaction confirmed → focus on the end (~1.2s from mid-point).
      _fired = false;
      _resolve.forward(from: 0.5);
    } else if (!old.waiting && widget.waiting) {
      _resolve.stop();
      _resolve.value = 0;
      _fired = false;
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    _resolve.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_clock, _resolve]),
        builder: (context, _) {
          final ms = (_clock.lastElapsedDuration ?? Duration.zero)
              .inMilliseconds
              .toDouble();
          return CustomPaint(
            size: Size(widget.size, widget.size * (widget.showLabel ? 1.32 : 1)),
            painter: _SealPainter(
              nowMs: ms,
              g: widget.waiting ? 0.5 : _resolve.value,
              waiting: widget.waiting,
              failed: widget.failed,
              showLabel: widget.showLabel,
              label: widget.failed ? widget.failLabel : widget.label,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------

const Color _violet = Color(0xFF7C3AED);
const Color _purple = Color(0xFFA78BFA);
const Color _orangeL = Color(0xFFFF9A52);
const Color _green = Color(0xFF2FD27A);

double _c01(double x) => x < 0 ? 0 : (x > 1 ? 1 : x);
double _lerp(double a, double b, double t) => a + (b - a) * t;
double _ease(double t) =>
    t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;

class _SealPainter extends CustomPainter {
  _SealPainter({
    required this.nowMs,
    required this.g,
    required this.waiting,
    required this.failed,
    required this.showLabel,
    required this.label,
  });

  final double nowMs;
  final double g;
  final bool waiting;
  final bool failed;
  final bool showLabel;
  final String label;

  Paint _glow(Color c, double sigma) => Paint()
    ..color = c
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2, cy = s / 2;
    final R = s * 0.34; // ring radius
    final now = nowMs;

    final success = _c01((g - 0.8) / 0.2);
    final assemble = _ease(_c01(g / 0.55));

    // End-state palette: green success vs. red failure.
    final isFail = failed;
    final endCol = isFail ? const Color(0xFFFF4D5E) : _green;
    final endLabelCol = isFail ? const Color(0xFFFF8A92) : const Color(0xFF5BD597);

    // ---- soft core glow (semi-transparent, the only "background") ----
    final glowCol = success > 0 ? endCol : _violet;
    canvas.drawCircle(
      Offset(cx, cy),
      R * 0.9,
      Paint()
        ..shader = ui.Gradient.radial(Offset(cx, cy), R * 0.9, [
          glowCol.withValues(alpha: 0.22 + success * 0.12),
          glowCol.withValues(alpha: 0),
        ]),
    );

    // ---- orbiting entanglement nodes ----
    final webA = waiting ? 1.0 : (1 - success);
    if (webA > 0.01) {
      for (int ri = 0; ri < 2; ri++) {
        final rr = R * (ri == 0 ? 0.62 : 0.92);
        final n = ri == 0 ? 5 : 8;
        final sp = ri == 0 ? 0.0011 : -0.0007;
        final sq = ri == 0 ? 0.5 : 0.42;
        for (int i = 0; i < n; i++) {
          final ang = (i / n) * math.pi * 2 + now * sp;
          final px = cx + math.cos(ang) * rr;
          final py = cy + math.sin(ang) * rr * sq + (ri == 0 ? 0 : 0);
          final depth = (math.sin(ang) + 1) / 2;
          final a = webA * (0.25 + depth * 0.6);
          final col = ri == 1 ? _orangeL : _purple;
          final sz = 1.2 + depth * 1.6;
          if (depth > 0.3) {
            canvas.drawCircle(Offset(px, py), sz + 1.4,
                _glow(col.withValues(alpha: a * 0.5), 3.5 * depth));
          }
          canvas.drawCircle(Offset(px, py), sz, Paint()..color = col.withValues(alpha: a));
        }
      }
    }

    // ---- progress ring ----
    final ringRect = Rect.fromCircle(center: Offset(cx, cy), radius: R);
    canvas.drawCircle(
        Offset(cx, cy),
        R,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.white.withValues(alpha: 0.08));
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset(cx - R, cy), Offset(cx + R, cy),
        [_violet, _purple, success > 0 ? endCol : _orangeL],
        [0.0, 0.5, 1.0],
      );
    double a0, sweep;
    if (waiting) {
      // Indeterminate sweep.
      a0 = (now * 0.004) % (math.pi * 2);
      sweep = math.pi * 0.6 + math.sin(now * 0.003) * 0.5;
    } else {
      a0 = -math.pi / 2;
      sweep = g * math.pi * 2;
    }
    canvas.drawArc(ringRect, a0, sweep, false, ringPaint);
    // head dot
    final headAng = a0 + sweep;
    final hx = cx + math.cos(headAng) * R, hy = cy + math.sin(headAng) * R;
    final headCol = success > 0 ? endCol : _orangeL;
    canvas.drawCircle(Offset(hx, hy), 6, _glow(headCol.withValues(alpha: 0.9), 6));
    canvas.drawCircle(Offset(hx, hy), 3.6, Paint()..color = headCol);

    // ---- center chip (keyhole → check) ----
    final pulse = 1 + math.sin(now * 0.004) * 0.04;
    final chip = R * 0.62 * pulse;
    canvas.save();
    // Damped horizontal shake on failure.
    final shakeX = isFail && success > 0
        ? math.sin(success * math.pi * 5) * (1 - success) * 5
        : 0.0;
    canvas.translate(cx + shakeX, cy);
    final chipRect =
        Rect.fromCenter(center: Offset.zero, width: chip, height: chip);
    final chipRRect =
        RRect.fromRectAndRadius(chipRect, Radius.circular(chip * 0.3));
    final chipOpacity = math.max(assemble, success);
    canvas.drawRRect(chipRRect,
        _glow((success > 0 ? endCol : _violet).withValues(alpha: chipOpacity), 9));
    canvas.drawRRect(
        chipRRect,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(-chip / 2, -chip / 2), Offset(chip / 2, chip / 2),
            success > 0
                ? (isFail
                    ? [const Color(0xFF2B1517), const Color(0xFF1E0E11)]
                    : [const Color(0xFF1C2B22), const Color(0xFF102018)])
                : [const Color(0xFF2A1D52), const Color(0xFF160F33)],
          )
          ..color = Colors.white.withValues(alpha: chipOpacity));
    canvas.drawRRect(
        chipRRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = (success > 0 ? endCol : _purple)
              .withValues(alpha: chipOpacity * (success > 0 ? 0.75 : 0.6)));

    final scale = chip / 52; // glyph designed at chip=52
    if (success > 0) {
      final sc = _ease(_c01(success));
      if (isFail) {
        // key → X morph
        final p = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 * scale
          ..strokeCap = StrokeCap.round
          ..color = endCol;
        final a1 = Offset(-9 * scale, -9 * scale),
            a2 = Offset(9 * scale, 9 * scale),
            b1 = Offset(9 * scale, -9 * scale),
            b2 = Offset(-9 * scale, 9 * scale);
        if (sc < 0.5) {
          final k = sc / 0.5;
          canvas.drawLine(
              a1, Offset(_lerp(a1.dx, a2.dx, k), _lerp(a1.dy, a2.dy, k)), p);
        } else {
          canvas.drawLine(a1, a2, p);
          final k = (sc - 0.5) / 0.5;
          canvas.drawLine(
              b1, Offset(_lerp(b1.dx, b2.dx, k), _lerp(b1.dy, b2.dy, k)), p);
        }
      } else {
        // key → check morph
        final p = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 * scale
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = _green;
        final p1 = Offset(-11 * scale, 1 * scale),
            p2 = Offset(-3 * scale, 9 * scale),
            p3 = Offset(12 * scale, -9 * scale);
        final path = Path()..moveTo(p1.dx, p1.dy);
        if (sc < 0.5) {
          final k = sc / 0.5;
          path.lineTo(_lerp(p1.dx, p2.dx, k), _lerp(p1.dy, p2.dy, k));
        } else {
          path.lineTo(p2.dx, p2.dy);
          final k = (sc - 0.5) / 0.5;
          path.lineTo(_lerp(p2.dx, p3.dx, k), _lerp(p2.dy, p3.dy, k));
        }
        canvas.drawPath(path, p);
      }
    } else {
      final kp = Paint()..color = _purple.withValues(alpha: 0.9 * chipOpacity);
      canvas.drawCircle(Offset(0, -4 * scale), 6 * scale, kp);
      final notch = Path()
        ..moveTo(-3 * scale, -1 * scale)
        ..lineTo(3 * scale, -1 * scale)
        ..lineTo(5 * scale, 12 * scale)
        ..lineTo(-5 * scale, 12 * scale)
        ..close();
      canvas.drawPath(notch, kp);
    }
    canvas.restore();

    // ---- end-state burst ----
    if (success > 0 && success < 1) {
      final bs = _ease(success);
      for (int i = 0; i < 14; i++) {
        final ang = (i / 14) * math.pi * 2;
        final rr = R * 0.5 + bs * R * 0.7;
        final px = cx + math.cos(ang) * rr, py = cy + math.sin(ang) * rr;
        canvas.drawCircle(
            Offset(px, py),
            (2.4 * (1 - bs) + 0.5),
            Paint()
              ..color = (i % 3 == 0 ? _orangeL : endCol).withValues(alpha: (1 - bs) * 0.9));
      }
    }

    // ---- label ----
    if (showLabel) {
      final labelA = success;
      if (labelA > 0.01) {
        _text(canvas, label, cx, s + s * 0.02, 14, FontWeight.w800,
            Colors.white.withValues(alpha: labelA), BoldType.fontFamily, -0.3);
        _text(
            canvas,
            isFail ? 'tente novamente' : 'concluída · canal seguro',
            cx,
            s + s * 0.13,
            11,
            FontWeight.w500,
            endLabelCol.withValues(alpha: labelA),
            BoldType.fontFamily,
            0.3);
      }
    }
  }

  void _text(Canvas canvas, String t, double cx, double y, double size,
      FontWeight w, Color color, String family, double spacing) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
          fontFamily: family,
          fontSize: size,
          fontWeight: w,
          color: color,
          letterSpacing: spacing,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, y));
  }

  @override
  bool shouldRepaint(covariant _SealPainter old) =>
      old.nowMs != nowMs ||
      old.g != g ||
      old.waiting != waiting ||
      old.failed != failed ||
      old.showLabel != showLabel;
}
