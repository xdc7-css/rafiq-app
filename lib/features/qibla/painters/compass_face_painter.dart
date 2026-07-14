import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class CompassFacePainter extends CustomPainter {
  CompassFacePainter();

  // ─── Cached Paint Objects ───
  late final Paint _groovePaint = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
  late final Paint _bevelLight = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
  late final Paint _bevelDark = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
  late final Paint _tickShadow = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final r = math.min(cx, cy);

    _drawBackground(canvas, center, r);
    _drawBezelRing(canvas, center, r);
    _drawGeometricRing(canvas, center, r);
    _drawTickMarks(canvas, center, r);
    _drawDegreeNumbers(canvas, center, r);
    _drawInnerRing(canvas, center, r);
    _drawCenterOrnament(canvas, center, r);
    _drawTopReflection(canvas, center, r);
  }

  void _drawBackground(Canvas canvas, Offset center, double r) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.1, -0.15),
        radius: 1.1,
        colors: [
          QiblaColors.compassBgMid,
          QiblaColors.compassBg,
          QiblaColors.compassBgDeep,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, paint);
  }

  void _drawBezelRing(Canvas canvas, Offset center, double r) {
    final outerR = r;
    final innerR = r * 0.93;

    final bezelPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: outerR))
      ..addOval(Rect.fromCircle(center: center, radius: innerR))
      ..fillType = PathFillType.evenOdd;

    final bezelPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          QiblaColors.goldDark,
          QiblaColors.accentGold,
          QiblaColors.goldLight,
          QiblaColors.accentGold,
          QiblaColors.goldDark,
          QiblaColors.accentGold,
          QiblaColors.goldLight,
          QiblaColors.accentGold,
          QiblaColors.goldDark,
        ],
        stops: const [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: outerR));
    canvas.drawPath(bezelPath, bezelPaint);

    // Inner bevel highlight
    final innerBevel = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x30FFFFFF),
          const Color(0x05FFFFFF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerR));
    canvas.drawCircle(center, innerR, innerBevel);

    // Inner shadow
    final shadow = Paint()
      ..color = const Color(0x40000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 4);
    canvas.drawCircle(center, innerR + 1, shadow);

    // Thin inner rim line
    final rimPaint = Paint()
      ..color = QiblaColors.goldDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    canvas.drawCircle(center, innerR, rimPaint);
  }

  void _drawGeometricRing(Canvas canvas, Offset center, double r) {
    final outerR = r * 0.68;
    final innerR = r * 0.56;
    final midR = (outerR + innerR) / 2;

    // Ring background
    final ringBg = Path()
      ..addOval(Rect.fromCircle(center: center, radius: outerR))
      ..addOval(Rect.fromCircle(center: center, radius: innerR))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(ringBg, Paint()..color = QiblaColors.compassDial);

    // 8-pointed star pattern
    final starPaint = Paint()
      ..color = QiblaColors.accentGold.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final starR = (outerR - innerR) * 0.36;

    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final px = center.dx + midR * math.cos(angle);
      final py = center.dy + midR * math.sin(angle);
      final starPath = Path();
      for (int j = 0; j < 8; j++) {
        final a = j * math.pi / 4;
        final sx = px + starR * math.cos(a);
        final sy = py + starR * math.sin(a);
        if (j == 0) {
          starPath.moveTo(sx, sy);
        } else {
          starPath.lineTo(sx, sy);
        }
      }
      starPath.close();
      canvas.drawPath(starPath, starPaint);
    }

    // Border lines
    final borderPaint = Paint()
      ..color = QiblaColors.accentGold.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;
    canvas.drawCircle(center, outerR, borderPaint);
    canvas.drawCircle(center, innerR, borderPaint);

    // Division lines
    for (int i = 0; i < 16; i++) {
      final a1 = i * math.pi / 8;
      final a2 = a1 + math.pi / 8;
      final p1 = Offset(
        center.dx + innerR * math.cos(a1),
        center.dy + innerR * math.sin(a1),
      );
      final p2 = Offset(
        center.dx + outerR * math.cos(a2),
        center.dy + outerR * math.sin(a2),
      );
      canvas.drawLine(p1, p2, borderPaint);
    }
  }

  void _drawTickMarks(Canvas canvas, Offset center, double r) {
    final tickOuter = r * 0.91;
    const lightAngle = -math.pi / 2;
    const lightFalloff = 0.12;

    final levels = <_TickLevel>[
      _TickLevel(divisor: 90, length: r * 0.120, grooveW: 2.0, bevelW: 0.55, alpha: 1.0),
      _TickLevel(divisor: 30, length: r * 0.088, grooveW: 1.5, bevelW: 0.45, alpha: 0.92),
      _TickLevel(divisor: 10, length: r * 0.055, grooveW: 0.9, bevelW: 0.30, alpha: 0.78),
      _TickLevel(divisor: 5,  length: r * 0.034, grooveW: 0.55, bevelW: 0.22, alpha: 0.55),
      _TickLevel(divisor: 1,  length: r * 0.018, grooveW: 0.30, bevelW: 0.12, alpha: 0.28),
    ];

    for (int deg = 0; deg < 360; deg++) {
      final angle = (deg - 90) * math.pi / 180;

      _TickLevel? level;
      for (final lv in levels) {
        if (deg % lv.divisor == 0) {
          level = lv;
          break;
        }
      }
      if (level == null) continue;

      final angleDiff = (angle - lightAngle).abs();
      final wrapped = angleDiff > math.pi ? 2 * math.pi - angleDiff : angleDiff;
      final lightMult = 1.0 + lightFalloff * math.cos(wrapped);

      final outerPt = Offset(
        center.dx + tickOuter * math.cos(angle),
        center.dy + tickOuter * math.sin(angle),
      );
      final innerPt = Offset(
        center.dx + (tickOuter - level.length) * math.cos(angle),
        center.dy + (tickOuter - level.length) * math.sin(angle),
      );

      final baseAlpha = level.alpha * lightMult;

      // Shadow
      final shadowOuter = Offset(
        center.dx + (tickOuter + 0.3) * math.cos(angle),
        center.dy + (tickOuter + 0.3) * math.sin(angle),
      );
      final shadowInner = Offset(
        center.dx + (tickOuter - level.length + 0.3) * math.cos(angle),
        center.dy + (tickOuter - level.length + 0.3) * math.sin(angle),
      );
      _tickShadow
        ..color = Colors.black.withValues(alpha: 0.22 * baseAlpha)
        ..strokeWidth = level.grooveW + 0.7;
      canvas.drawLine(shadowOuter, shadowInner, _tickShadow);

      // Groove
      _groovePaint
        ..color = Color.fromRGBO(18, 12, 4, baseAlpha * 0.88)
        ..strokeWidth = level.grooveW;
      canvas.drawLine(outerPt, innerPt, _groovePaint);

      // Bright bevel edge
      final perpX = -math.sin(angle) * 0.35;
      final perpY = math.cos(angle) * 0.35;
      _bevelLight
        ..color = Color.fromRGBO(247, 224, 139, baseAlpha * 0.50)
        ..strokeWidth = level.bevelW;
      canvas.drawLine(
        Offset(outerPt.dx + perpX, outerPt.dy + perpY),
        Offset(innerPt.dx + perpX, innerPt.dy + perpY),
        _bevelLight,
      );

      // Dark bevel edge
      _bevelDark
        ..color = Color.fromRGBO(50, 35, 10, baseAlpha * 0.35)
        ..strokeWidth = level.bevelW;
      canvas.drawLine(
        Offset(outerPt.dx - perpX, outerPt.dy - perpY),
        Offset(innerPt.dx - perpX, innerPt.dy - perpY),
        _bevelDark,
      );
    }
  }

  void _drawDegreeNumbers(Canvas canvas, Offset center, double r) {
    const cardinalArabic = {0: 'ش', 90: 'ق', 180: 'ج', 270: 'غ'};
    const cardinalLatin = {0: 'N', 90: 'E', 180: 'S', 270: 'W'};

    final numberR = r * 0.73;
    final shadowPaint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    const lightAngle = -math.pi / 2;
    const lightFalloff = 0.10;

    for (int deg = 0; deg < 360; deg += 30) {
      final angle = (deg - 90) * math.pi / 180;
      final isCardinal = deg % 90 == 0;

      final angleDiff = (angle - lightAngle).abs();
      final wrapped = angleDiff > math.pi ? 2 * math.pi - angleDiff : angleDiff;
      final lightMult = 1.0 + lightFalloff * math.cos(wrapped);

      final label = cardinalArabic[deg] ?? '$deg';

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: isCardinal
                ? Color.fromRGBO(247, 224, 139, lightMult)
                : Color.fromRGBO(212, 175, 55, 0.78 * lightMult),
            fontSize: isCardinal ? r * 0.088 : r * 0.062,
            fontWeight: isCardinal ? FontWeight.w800 : FontWeight.w600,
            fontFamily: 'NotoNaskhArabic',
            letterSpacing: isCardinal ? 0.5 : 0,
          ),
        ),
        textDirection: isCardinal ? TextDirection.rtl : TextDirection.ltr,
      )..layout();

      final nx = center.dx + numberR * math.cos(angle) - tp.width / 2;
      final ny = center.dy + numberR * math.sin(angle) - tp.height / 2;

      // Engraving shadow
      shadowPaint.color = Colors.black.withValues(alpha: 0.30 * lightMult);
      tp.paint(canvas, Offset(nx + 0.5, ny + 0.7));

      // Bright highlight
      tp.paint(canvas, Offset(nx - 0.25, ny - 0.25));

      // Primary
      tp.paint(canvas, Offset(nx, ny));

      // Latin sub-label for cardinals
      if (isCardinal) {
        final latinR = r * 0.68;
        final latinLabel = cardinalLatin[deg] ?? '';
        final ltp = TextPainter(
          text: TextSpan(
            text: latinLabel,
            style: TextStyle(
              color: Color.fromRGBO(160, 130, 60, 0.38 * lightMult),
              fontSize: r * 0.035,
              fontWeight: FontWeight.w500,
              fontFamily: 'Georgia',
              letterSpacing: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final lx = center.dx + latinR * math.cos(angle) - ltp.width / 2;
        final ly = center.dy + latinR * math.sin(angle) - ltp.height / 2;
        shadowPaint.color = Colors.black.withValues(alpha: 0.18 * lightMult);
        ltp.paint(canvas, Offset(lx + 0.3, ly + 0.4));
        ltp.paint(canvas, Offset(lx, ly));
      }
    }
  }

  void _drawInnerRing(Canvas canvas, Offset center, double r) {
    final ringR = r * 0.52;
    final paint = Paint()
      ..color = QiblaColors.accentGold.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, ringR, paint);

    // Decorative dots at 45° intervals
    final dotPaint = Paint()
      ..color = QiblaColors.accentGold.withValues(alpha: 0.12);
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawCircle(
        Offset(center.dx + ringR * math.cos(a), center.dy + ringR * math.sin(a)),
        1.2,
        dotPaint,
      );
    }
  }

  void _drawCenterOrnament(Canvas canvas, Offset center, double r) {
    final outerR = r * 0.12;
    final innerR = r * 0.08;

    // Gold outer ring
    canvas.drawCircle(
      center,
      outerR,
      Paint()
        ..shader = const SweepGradient(
          colors: [QiblaColors.goldDark, QiblaColors.accentGold, QiblaColors.goldLight, QiblaColors.accentGold, QiblaColors.goldDark],
        ).createShader(Rect.fromCircle(center: center, radius: outerR)),
    );

    // Dark fill
    canvas.drawCircle(center, outerR - 1.2, Paint()..color = QiblaColors.compassBg);

    // Inner jewel
    canvas.drawCircle(
      center,
      innerR,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF1A2A4A), QiblaColors.compassBg],
        ).createShader(Rect.fromCircle(center: center, radius: innerR)),
    );

    // Reflection
    final reflectionPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: [const Color(0x25FFFFFF), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: innerR));
    canvas.drawCircle(center, innerR, reflectionPaint);
  }

  void _drawTopReflection(Canvas canvas, Offset center, double r) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.15, -0.2),
        radius: 0.9,
        colors: [const Color(0x08FFFFFF), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: r * 0.80));
    canvas.drawCircle(center, r * 0.80, paint);
  }

  @override
  bool shouldRepaint(covariant CompassFacePainter oldDelegate) => false;
}

class _TickLevel {
  final int divisor;
  final double length;
  final double grooveW;
  final double bevelW;
  final double alpha;

  const _TickLevel({
    required this.divisor,
    required this.length,
    required this.grooveW,
    required this.bevelW,
    required this.alpha,
  });
}
