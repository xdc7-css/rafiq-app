import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class PremiumBackground extends StatelessWidget {
  const PremiumBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: const _PremiumBackgroundPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _PremiumBackgroundPainter extends CustomPainter {
  const _PremiumBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // ── Layer 1: Deep Navy Gradient ──
    _drawBaseGradient(canvas, rect);

    // ── Layer 2: Soft Radial Lighting (Hero area) ──
    _drawRadialLighting(canvas, size);

    // ── Layer 3: Ultra Subtle Vignette ──
    _drawVignette(canvas, rect, size);

    // ── Layer 4: Barely Visible Islamic Geometric Pattern ──
    _drawIslamicPattern(canvas, size);

    // ── Layer 5: Static Metallic Gold Particles ──
    _drawGoldParticles(canvas, size);
  }

  // ═══════════════════════════════════════════════
  // Layer 1 — Deep Navy Gradient
  // ═══════════════════════════════════════════════
  void _drawBaseGradient(Canvas canvas, Rect rect) {
    const gradient = LinearGradient(
      colors: [
        Color(0xFF06101D),
        Color(0xFF081728),
        Color(0xFF0D1E36),
        Color(0xFF12284A),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.3, 0.65, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  // ═══════════════════════════════════════════════
  // Layer 2 — Soft Radial Lighting Behind Hero
  // ═══════════════════════════════════════════════
  void _drawRadialLighting(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Primary glow — centered behind the hero card
    final center = Offset(size.width * 0.5, size.height * 0.22);
    final radius = size.width * 0.65;
    final glowColors = [
      AppTheme.goldPrimary.withValues(alpha: 0.06),
      AppTheme.goldPrimary.withValues(alpha: 0.02),
      Colors.transparent,
    ];
    final shader = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: glowColors,
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    paint.shader = shader;
    canvas.drawCircle(center, radius, paint);

    // Secondary glow — subtle warm reflection at bottom
    final center2 = Offset(size.width * 0.7, size.height * 0.88);
    final radius2 = size.width * 0.4;
    final shader2 = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        AppTheme.goldWarm.withValues(alpha: 0.03),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center2, radius: radius2));
    paint.shader = shader2;
    canvas.drawCircle(center2, radius2, paint);
  }

  // ═══════════════════════════════════════════════
  // Layer 3 — Ultra Subtle Edge Vignette
  // ═══════════════════════════════════════════════
  void _drawVignette(Canvas canvas, Rect rect, Size size) {
    final shader = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.18),
      ],
      stops: const [0.55, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  // ═══════════════════════════════════════════════
  // Layer 4 — Barely Visible Islamic Geometric
  // ═══════════════════════════════════════════════
  void _drawIslamicPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.015);

    final spacing = size.width * 0.32;
    final radius = size.width * 0.06;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cx = col * spacing + (row.isOdd ? spacing * 0.5 : 0);
        final cy = row * spacing;
        final center = Offset(cx, cy);

        // 8-pointed star
        _drawEightPointedStar(canvas, center, radius, paint);

        // Concentric circle
        canvas.drawCircle(center, radius * 0.55, paint);
      }
    }
  }

  void _drawEightPointedStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi / 8 - math.pi / 2;
      final r = i.isEven ? radius : radius * 0.38;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // ═══════════════════════════════════════════════
  // Layer 5 — Static Metallic Gold Particles
  // ═══════════════════════════════════════════════
  void _drawGoldParticles(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 18; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.4 + random.nextDouble() * 0.8;

      paint.color = AppTheme.goldPrimary.withValues(alpha: 0.02);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Loading Indicator (used by loading/error/GPS states)
// ═══════════════════════════════════════════════════════════════════

class PremiumLoadingIndicator extends StatefulWidget {
  const PremiumLoadingIndicator({super.key});

  @override
  State<PremiumLoadingIndicator> createState() =>
      _PremiumLoadingIndicatorState();
}

class _PremiumLoadingIndicatorState extends State<PremiumLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: _LoadingRingPainter(
                      progress: _controller.value,
                      color: AppTheme.goldPrimary,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CustomPaint(
                    painter: _LoadingRingPainter(
                      progress: 1 - _controller.value,
                      color: AppTheme.goldSoft,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    color: Color(0xFF0B1324),
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'جاري تحضير أوقات الصلاة',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'بضع لحظات...',
              style: GoogleFonts.tajawal(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _LoadingRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.1);
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          color.withValues(alpha: 0.3),
          color,
          color.withValues(alpha: 0.3),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    final path = Path()..addArc(rect, -math.pi / 2, 2 * math.pi * progress);
    canvas.drawPath(path, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _LoadingRingPainter &&
        oldDelegate.progress != progress;
  }
}
