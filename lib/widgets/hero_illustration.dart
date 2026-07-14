import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Premium hero scene: crescent, mosque skyline, lanterns, clouds, stars.
class HeroIllustration extends StatefulWidget {
  final double width;
  final double height;

  const HeroIllustration({
    super.key,
    this.width = 280,
    this.height = 200,
  });

  @override
  State<HeroIllustration> createState() => _HeroIllustrationState();
}

class _HeroIllustrationState extends State<HeroIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
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
      builder: (context, _) => CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _HeroScenePainter(glow: _controller.value),
      ),
    );
  }
}

class _HeroScenePainter extends CustomPainter {
  final double glow;

  _HeroScenePainter({required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    _drawMoonGlow(canvas, size);
    _drawClouds(canvas, size);
    _drawStars(canvas, size);
    _drawMosqueSkyline(canvas, size);
    _drawLanterns(canvas, size);
    _drawCrescent(canvas, size);
    _drawArabesque(canvas, size);
  }

  void _drawMoonGlow(Canvas canvas, Size size) {
    final moonX = size.width * 0.78;
    final moonY = size.height * 0.18;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.goldSoft.withValues(alpha: 0.18 + glow * 0.06),
          AppTheme.goldPrimary.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0, 0.45, 1],
      ).createShader(Rect.fromCircle(center: Offset(moonX, moonY), radius: 60));
    canvas.drawCircle(Offset(moonX, moonY), 55, glowPaint);
  }

  void _drawClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = AppTheme.goldSoft.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    _cloud(canvas, size.width * 0.15, size.height * 0.22, 36, cloudPaint);
    _cloud(canvas, size.width * 0.55, size.height * 0.12, 28, cloudPaint);
    _cloud(canvas, size.width * 0.35, size.height * 0.08, 22, cloudPaint);
  }

  void _cloud(Canvas canvas, double cx, double cy, double w, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), w * 0.35, paint);
    canvas.drawCircle(Offset(cx + w * 0.25, cy - w * 0.08), w * 0.28, paint);
    canvas.drawCircle(Offset(cx - w * 0.2, cy + w * 0.05), w * 0.22, paint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;
    const positions = [
      (0.12, 0.15, 1.2),
      (0.28, 0.08, 0.8),
      (0.45, 0.18, 1.0),
      (0.62, 0.06, 0.7),
      (0.88, 0.28, 1.1),
      (0.05, 0.35, 0.6),
    ];
    for (final (x, y, r) in positions) {
      final twinkle = sin(glow * pi * 2 + x * 10) * 0.3 + 0.7;
      starPaint.color = AppTheme.goldSoft.withValues(alpha: 0.35 * twinkle);
      _drawStar(canvas, Offset(size.width * x, size.height * y), r, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + cos(angle) * r * 2,
        center.dy + sin(angle) * r * 2,
      );
    }
    canvas.drawPath(path, paint..strokeWidth = 0.8..style = PaintingStyle.stroke);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, r * 0.4, paint);
  }

  void _drawMosqueSkyline(Canvas canvas, Size size) {
    final baseY = size.height * 0.88;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.goldPrimary.withValues(alpha: 0.35),
          AppTheme.goldPrimary.withValues(alpha: 0.08),
        ],
      ).createShader(Rect.fromLTWH(0, baseY - 80, size.width, 80));

    // Central dome
    final cx = size.width * 0.42;
    final dome = Path()
      ..moveTo(cx - 42, baseY)
      ..quadraticBezierTo(cx - 48, baseY - 52, cx, baseY - 68)
      ..quadraticBezierTo(cx + 48, baseY - 52, cx + 42, baseY)
      ..close();
    canvas.drawPath(dome, paint);

    // Side domes
    for (final dx in [-70.0, 70.0]) {
      final sc = cx + dx;
      final sd = Path()
        ..moveTo(sc - 22, baseY)
        ..quadraticBezierTo(sc - 24, baseY - 28, sc, baseY - 34)
        ..quadraticBezierTo(sc + 24, baseY - 28, sc + 22, baseY)
        ..close();
      canvas.drawPath(sd, paint);
    }

    // Minarets
    _minaret(canvas, cx - 58, baseY, paint);
    _minaret(canvas, cx + 58, baseY, paint);

    // Base wall
    final wallPaint = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.08, baseY - 8, size.width * 0.72, 10),
      wallPaint,
    );
  }

  void _minaret(Canvas canvas, double cx, double baseY, Paint paint) {
    final path = Path()
      ..moveTo(cx - 5, baseY)
      ..lineTo(cx - 5, baseY - 72)
      ..lineTo(cx - 7, baseY - 78)
      ..lineTo(cx - 7, baseY - 84)
      ..lineTo(cx + 7, baseY - 84)
      ..lineTo(cx + 7, baseY - 78)
      ..lineTo(cx + 5, baseY - 78)
      ..lineTo(cx + 5, baseY)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawLanterns(Canvas canvas, Size size) {
    final sway = sin(glow * pi * 2) * 3;
    _lantern(canvas, size.width * 0.22 + sway, size.height * 0.38, 0.9 + glow * 0.1);
    _lantern(canvas, size.width * 0.68 - sway * 0.5, size.height * 0.32, 0.75);
    _lantern(canvas, size.width * 0.52 + sway * 0.3, size.height * 0.45, 0.65);
  }

  void _lantern(Canvas canvas, double cx, double cy, double scale) {
    final w = 14.0 * scale;
    final h = 22.0 * scale;

    // Glow
    canvas.drawCircle(
      Offset(cx, cy + h * 0.35),
      w * 1.2,
      Paint()
        ..color = AppTheme.goldPrimary.withValues(alpha: 0.12 + glow * 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final stroke = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(Offset(cx, cy - h * 0.3), Offset(cx, cy), stroke);

    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.35), width: w * 2, height: h),
      Radius.circular(w * 0.3),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..color = AppTheme.goldPrimary.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(body, stroke);

    canvas.drawCircle(
      Offset(cx, cy + h * 0.35),
      w * 0.35,
      Paint()..color = AppTheme.goldSoft.withValues(alpha: 0.35 + glow * 0.2),
    );
  }

  void _drawCrescent(Canvas canvas, Size size) {
    final cx = size.width * 0.78;
    final cy = size.height * 0.18;
    final r = 18.0;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 3,
      pi * 1.6,
      false,
      Paint()
        ..color = AppTheme.goldSoft.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(cx + r * 0.28, cy - r * 0.12),
      r * 0.72,
      Paint()
        ..color = const Color(0xFF07111F)
        ..blendMode = BlendMode.srcOver,
    );
  }

  void _drawArabesque(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();
    for (int i = 0; i <= 8; i++) {
      final t = i / 8;
      final x = size.width * 0.05 + t * size.width * 0.9;
      final y = size.height * 0.72 + sin(t * pi * 3) * 4;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.quadraticBezierTo(x - 8, y - 6, x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HeroScenePainter old) => old.glow != glow;
}
