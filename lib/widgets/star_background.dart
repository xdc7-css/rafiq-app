import 'dart:math';
import 'package:flutter/material.dart';

/// Premium Islamic background widget.
/// Replaces all star/particle/space-based backgrounds across the app.
/// ─── Usage ───────────────────────────────────────────────────────────────────
///   IslamicBackground(
///     child: Scaffold(...),
///   )
///
///   StarBackground(child: ...)  // backward-compatible alias
/// ─────────────────────────────────────────────────────────────────────────────
class IslamicBackground extends StatelessWidget {
  final Widget? child;

  /// Show the Islamic geometric lattice pattern and mosque silhouette.
  final bool showGeometric;

  /// Show the floating gold dust particles.
  final bool showParticles;

  const IslamicBackground({
    super.key,
    this.child,
    this.showGeometric = true,
    this.showParticles = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // ← fills the parent fully
      children: [
        // ── 1. Deep multi-layer gradient ─────────────────────────────────────
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF07172C), // Top
                Color(0xFF0B1F3A), // Middle
                Color(0xFF10284A), // Bottom
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // ── 2. Ultra-soft ambient radial glow (upper-left) ───────────────────
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.4, -0.75),
                radius: 1.3,
                colors: [
                  Color(0x0BFFFFFF), // ~4 % opacity white
                  Color(0x00FFFFFF),
                ],
              ),
            ),
          ),
        ),

        // ── 3. Islamic geometric lattice + noise + gold dust ─────────────────
        IgnorePointer(
          child: CustomPaint(
            painter: _IslamicPatternPainter(
              showGeometric: showGeometric,
              showParticles: showParticles,
            ),
          ),
        ),

        // ── 4. Refined gold accent curves ────────────────────────────────────
        const IgnorePointer(
          child: CustomPaint(
            painter: _GoldCurvePainter(),
          ),
        ),

        // ── 5. UI content ────────────────────────────────────────────────────
        if (child != null) child!,
      ],
    );
  }
}

/// Backward-compatible alias — all screens that import `StarBackground` work without changes.
typedef StarBackground = IslamicBackground;

// ─────────────────────────────────────────────────────────────────────────────
// Geometric pattern, mosque silhouette, noise grain, floating dust
// ─────────────────────────────────────────────────────────────────────────────
class _IslamicPatternPainter extends CustomPainter {
  final bool showGeometric;
  final bool showParticles;

  const _IslamicPatternPainter({
    required this.showGeometric,
    required this.showParticles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Blue-gray pattern — 3 % opacity (2-4 % per spec)
    final patternPaint = Paint()
      ..color = const Color(0xFF5E708C).withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    if (showGeometric) {
      _drawEdgePatterns(canvas, size, patternPaint);
      _drawMosqueSilhouette(canvas, size);
    }

    _drawNoiseGrain(canvas, size);

    if (showParticles) {
      _drawFloatingDust(canvas, size);
    }
  }

  // Draws interlocking 8-point stars only in the four corner regions.
  void _drawEdgePatterns(Canvas canvas, Size size, Paint paint) {
    const double cellSize = 160.0;

    // (cornerX, cornerY, limitW, limitH)
    // Top-Right and Bottom-Left get larger crop (per spec).
    final zones = [
      _Zone(0, 0, size.width * 0.28, size.height * 0.22),          // TL — small
      _Zone(size.width, 0, -size.width * 0.42, size.height * 0.38),// TR — large
      _Zone(0, size.height, size.width * 0.42, -size.height * 0.38),// BL — large
      _Zone(size.width, size.height, -size.width * 0.28, -size.height * 0.22),// BR — small
    ];

    for (final z in zones) {
      canvas.save();
      canvas.clipRect(Rect.fromPoints(
        Offset(z.cx, z.cy),
        Offset(z.cx + z.dw, z.cy + z.dh),
      ));

      // Grid of cells inside the zone
      final double startX = z.dw >= 0 ? z.cx : z.cx + z.dw;
      final double startY = z.dh >= 0 ? z.cy : z.cy + z.dh;
      final double endX = z.dw >= 0 ? z.cx + z.dw : z.cx;
      final double endY = z.dh >= 0 ? z.cy + z.dh : z.cy;

      double x = startX - cellSize;
      while (x <= endX + cellSize) {
        double y = startY - cellSize;
        while (y <= endY + cellSize) {
          // Fade opacity toward the center
          final distFromCornerX = (z.dw >= 0 ? x - z.cx : z.cx - x).clamp(0.0, z.dw.abs());
          final distFromCornerY = (z.dh >= 0 ? y - z.cy : z.cy - y).clamp(0.0, z.dh.abs());
          final fadeX = 1.0 - (distFromCornerX / z.dw.abs()).clamp(0.0, 1.0);
          final fadeY = 1.0 - (distFromCornerY / z.dh.abs()).clamp(0.0, 1.0);
          final fade = (fadeX * fadeY).clamp(0.0, 1.0);

          final fadedPaint = Paint()
            ..color = const Color(0xFF5E708C).withValues(alpha: 0.04 * fade)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8;

          _drawStar8(canvas, Offset(x, y), 44, fadedPaint);
          y += cellSize;
        }
        x += cellSize;
      }
      canvas.restore();
    }
  }

  // Draws a single 8-point Islamic star at the given centre with given radius.
  void _drawStar8(Canvas canvas, Offset c, double r, Paint paint) {
    // Outer 8 points
    final outer = Path();
    for (int i = 0; i < 8; i++) {
      final a = (pi / 4) * i - pi / 8;
      final p = Offset(c.dx + r * cos(a), c.dy + r * sin(a));
      i == 0 ? outer.moveTo(p.dx, p.dy) : outer.lineTo(p.dx, p.dy);
    }
    outer.close();
    canvas.drawPath(outer, paint);

    // Inner square rotated 45°
    final inner = Path();
    final ri = r * 0.5;
    for (int i = 0; i < 4; i++) {
      final a = (pi / 2) * i;
      final p = Offset(c.dx + ri * cos(a), c.dy + ri * sin(a));
      i == 0 ? inner.moveTo(p.dx, p.dy) : inner.lineTo(p.dx, p.dy);
    }
    inner.close();
    canvas.drawPath(inner, paint);

    // Connecting spokes
    for (int i = 0; i < 8; i++) {
      final a = (pi / 4) * i - pi / 8;
      final p = Offset(c.dx + r * cos(a), c.dy + r * sin(a));
      canvas.drawLine(c, p, paint);
    }
  }

  // Soft, blurry mosque + minaret silhouette — bottom centre (5-7 % opacity)
  void _drawMosqueSilhouette(Canvas canvas, Size size) {
    // Use a light blue-gray tinted slightly lighter than background for visibility
    final paint = Paint()
      ..color = const Color(0xFF1E3A5A).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

    final cx = size.width * 0.5;
    final base = size.height;

    // Center dome
    final skyline = Path()
      ..moveTo(cx - 160, base)
      ..lineTo(cx - 160, base - 28)
      ..quadraticBezierTo(cx - 100, base - 28, cx - 75, base - 22)
      // left side dome
      ..quadraticBezierTo(cx - 55, base - 58, cx, base - 65)
      ..quadraticBezierTo(cx + 55, base - 58, cx + 75, base - 22)
      ..quadraticBezierTo(cx + 100, base - 28, cx + 160, base - 28)
      ..lineTo(cx + 160, base)
      ..close();

    // Left minaret
    final mL = Path()
      ..addRect(Rect.fromLTWH(cx - 125, base - 100, 10, 72))
      ..moveTo(cx - 125, base - 100)
      ..quadraticBezierTo(cx - 120, base - 114, cx - 115, base - 100);

    // Right minaret
    final mR = Path()
      ..addRect(Rect.fromLTWH(cx + 115, base - 100, 10, 72))
      ..moveTo(cx + 115, base - 100)
      ..quadraticBezierTo(cx + 120, base - 114, cx + 125, base - 100);

    canvas.drawPath(skyline, paint);
    canvas.drawPath(mL, paint);
    canvas.drawPath(mR, paint);
  }

  // Extremely fine matte grain — 1 % opacity to prevent color banding
  void _drawNoiseGrain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.012);
    final rng = Random(42);
    for (int i = 0; i < 400; i++) {
      canvas.drawRect(
        Rect.fromLTWH(rng.nextDouble() * size.width, rng.nextDouble() * size.height, 1, 1),
        paint,
      );
    }
  }

  // 20-30 tiny warm gold particles — 1-2 px, 20 % opacity
  void _drawFloatingDust(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD4AF37).withValues(alpha: 0.22);
    final rng = Random(1337);
    for (int i = 0; i < 26; i++) {
      // Keep dust away from the central 50 % of the screen height
      double ry;
      if (i < 13) {
        ry = rng.nextDouble() * size.height * 0.25; // top quarter
      } else {
        ry = size.height * 0.75 + rng.nextDouble() * size.height * 0.25; // bottom quarter
      }
      final rx = rng.nextDouble() * size.width;
      canvas.drawCircle(Offset(rx, ry), 0.8 + rng.nextDouble() * 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Two elegant gold accent curves
// ─────────────────────────────────────────────────────────────────────────────
class _GoldCurvePainter extends CustomPainter {
  const _GoldCurvePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.60)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Curve 1 — upper-right corner, fades before center
    final path1 = Path()
      ..moveTo(size.width, 0)
      ..cubicTo(
        size.width * 0.82, size.height * 0.04,
        size.width * 0.90, size.height * 0.12,
        size.width * 0.78, size.height * 0.28, // stops at ~28 % — well above center
      );
    canvas.drawPath(path1, paint);

    // Curve 2 — lower-left corner, fades before center
    final path2 = Path()
      ..moveTo(0, size.height)
      ..cubicTo(
        size.width * 0.18, size.height * 0.96,
        size.width * 0.10, size.height * 0.88,
        size.width * 0.22, size.height * 0.72, // stops at ~72 % — well below center
      );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────────────────────────────────────
class _Zone {
  final double cx, cy, dw, dh;
  const _Zone(this.cx, this.cy, this.dw, this.dh);
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy pass-through — ShootingStarOverlay is kept for backward compatibility
// but is now a transparent wrapper (stars removed).
// ─────────────────────────────────────────────────────────────────────────────
class ShootingStarOverlay extends StatelessWidget {
  final Widget child;
  const ShootingStarOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
