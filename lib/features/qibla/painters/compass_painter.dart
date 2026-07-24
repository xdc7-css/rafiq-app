import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class CompassPainter extends CustomPainter {
  final double glowIntensity;

  CompassPainter({
    this.glowIntensity = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);
    final center = Offset(cx, cy);

    _drawOuterGlow(canvas, center, r);
    _drawBackground(canvas, center, r);
    _drawGoldRings(canvas, center, r);
    _drawTickMarks(canvas, cx, cy, r);
    _drawDegreeLabels(canvas, cx, cy, r);
    _drawCardinalLabels(canvas, cx, cy, r);
    _drawIslamicPattern(canvas, cx, cy, r);
    _drawInnerCircle(canvas, center, r);
  }

  void _drawOuterGlow(Canvas canvas, Offset center, double r) {
    if (glowIntensity <= 0) return;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          QiblaColors.gold.withValues(alpha: 0.08 * glowIntensity),
          QiblaColors.gold.withValues(alpha: 0.02 * glowIntensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r * 1.25));
    canvas.drawCircle(center, r * 1.25, paint);
  }

  void _drawBackground(Canvas canvas, Offset center, double r) {
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.1),
        radius: 1.1,
        colors: const [
          Color(0xFF0E1E38),
          QiblaColors.compassFace,
          Color(0xFF060E1C),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, bgPaint);
  }

  void _drawGoldRings(Canvas canvas, Offset center, double r) {
    final outerRingPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          QiblaColors.goldDark,
          QiblaColors.gold,
          QiblaColors.lightGold,
          QiblaColors.gold,
          QiblaColors.goldDark,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.045;
    canvas.drawCircle(center, r - r * 0.022, outerRingPaint);

    final innerRingPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          QiblaColors.goldDark,
          QiblaColors.gold,
          QiblaColors.lightGold,
          QiblaColors.gold,
          QiblaColors.goldDark,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r * 0.88))
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.025;
    canvas.drawCircle(center, r * 0.88, innerRingPaint);
  }

  void _drawTickMarks(Canvas canvas, double cx, double cy, double r) {
    final tickStart = r * 0.955;
    final majorTickEnd = r * 0.895;
    final minorTickEnd = r * 0.925;
    final microTickEnd = r * 0.940;

    final majorPaint = Paint()
      ..color = QiblaColors.gold
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final minorPaint = Paint()
      ..color = QiblaColors.gold.withValues(alpha: 0.5)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final microPaint = Paint()
      ..color = QiblaColors.textSecondary.withValues(alpha: 0.25)
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 360; i++) {
      final angle = (i - 90) * math.pi / 180;
      final cosA = math.cos(angle);
      final sinA = math.sin(angle);

      double endR;
      Paint paint;
      if (i % 30 == 0) {
        endR = majorTickEnd;
        paint = majorPaint;
      } else if (i % 10 == 0) {
        endR = minorTickEnd;
        paint = minorPaint;
      } else {
        endR = microTickEnd;
        paint = microPaint;
      }

      canvas.drawLine(
        Offset(cx + tickStart * cosA, cy + tickStart * sinA),
        Offset(cx + endR * cosA, cy + endR * sinA),
        paint,
      );
    }
  }

  void _drawDegreeLabels(Canvas canvas, double cx, double cy, double r) {
    final labelR = r * 0.835;
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 360; i += 30) {
      if (i % 90 == 0) continue;
      final angle = (i - 90) * math.pi / 180;
      final x = cx + labelR * math.cos(angle);
      final y = cy + labelR * math.sin(angle);

      tp.text = TextSpan(
        text: '$i',
        style: const TextStyle(
          color: QiblaColors.textSecondary,
          fontSize: 9,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  void _drawCardinalLabels(Canvas canvas, double cx, double cy, double r) {
    final labelR = r * 0.76;
    final tp = TextPainter(textDirection: TextDirection.ltr);

    const cardinals = {
      0: ('N', QiblaColors.danger),
      90: ('E', QiblaColors.textSecondary),
      180: ('S', QiblaColors.textSecondary),
      270: ('W', QiblaColors.textSecondary),
    };

    for (final entry in cardinals.entries) {
      final angle = (entry.key - 90) * math.pi / 180;
      final x = cx + labelR * math.cos(angle);
      final y = cy + labelR * math.sin(angle);

      tp.text = TextSpan(
        text: entry.value.$1,
        style: TextStyle(
          color: entry.value.$2,
          fontSize: entry.key == 0 ? 16 : 13,
          fontWeight: FontWeight.w800,
          fontFamily: 'Inter',
          letterSpacing: 1,
        ),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  void _drawIslamicPattern(Canvas canvas, double cx, double cy, double r) {
    final patternR = r * 0.62;
    final paint = Paint()
      ..color = QiblaColors.gold.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final vertices = <Offset>[];
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      vertices.add(Offset(cx + patternR * math.cos(angle), cy + patternR * math.sin(angle)));
    }

    final square1 = Path();
    for (int i = 0; i < 4; i++) {
      final idx = i * 2;
      if (i == 0) {
        square1.moveTo(vertices[idx].dx, vertices[idx].dy);
      } else {
        square1.lineTo(vertices[idx].dx, vertices[idx].dy);
      }
    }
    square1.close();
    canvas.drawPath(square1, paint);

    final square2 = Path();
    for (int i = 0; i < 4; i++) {
      final idx = i * 2 + 1;
      if (i == 0) {
        square2.moveTo(vertices[idx].dx, vertices[idx].dy);
      } else {
        square2.lineTo(vertices[idx].dx, vertices[idx].dy);
      }
    }
    square2.close();
    canvas.drawPath(square2, paint);

    final innerR = patternR * 0.55;
    final innerOct = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      final p = Offset(cx + innerR * math.cos(angle), cy + innerR * math.sin(angle));
      if (i == 0) {
        innerOct.moveTo(p.dx, p.dy);
      } else {
        innerOct.lineTo(p.dx, p.dy);
      }
    }
    innerOct.close();
    paint.color = QiblaColors.gold.withValues(alpha: 0.04);
    canvas.drawPath(innerOct, paint);

    paint.color = QiblaColors.gold.withValues(alpha: 0.05);
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + patternR * 0.95 * math.cos(angle), cy + patternR * 0.95 * math.sin(angle)),
        paint,
      );
    }

    final dotPaint = Paint()
      ..color = QiblaColors.gold.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      canvas.drawCircle(
        Offset(cx + innerR * math.cos(angle), cy + innerR * math.sin(angle)),
        1.5,
        dotPaint,
      );
    }
  }

  void _drawInnerCircle(Canvas canvas, Offset center, double r) {
    final innerR = r * 0.68;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF0C1A30),
          const Color(0xFF081326),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerR));
    canvas.drawCircle(center, innerR, paint);

    final borderPaint = Paint()
      ..color = QiblaColors.gold.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, innerR, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CompassPainter old) {
    return old.glowIntensity != glowIntensity;
  }
}
