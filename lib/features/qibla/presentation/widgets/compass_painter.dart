import 'dart:math' as math;
import 'package:flutter/material.dart';

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final outerRadius = size.width / 2 - 8;
    final innerRadius = outerRadius - 30;

    //-----------------------------------------
    // Gold Outer Ring
    //-----------------------------------------

    final outerPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Color(0xff6E5315),
          Color(0xffD4AF37),
          Color(0xffF7E08B),
          Color(0xffD4AF37),
          Color(0xff6E5315),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(center, outerRadius, outerPaint);

    //-----------------------------------------
    // Decorative Inner Ring
    //-----------------------------------------

    final ringPaint = Paint()
      ..color = const Color(0xffD4AF37).withValues(alpha: .25)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, outerRadius - 16, ringPaint);

    canvas.drawCircle(center, outerRadius - 26, ringPaint);

    //-----------------------------------------
    // Compass Ticks
    //-----------------------------------------

    for (int i = 0; i < 360; i++) {
      final angle = (i - 90) * math.pi / 180;

      double tick = 7;

      if (i % 90 == 0) {
        tick = 26;
      } else if (i % 30 == 0) {
        tick = 18;
      } else if (i % 10 == 0) {
        tick = 12;
      }

      final p1 = Offset(
        center.dx + (outerRadius - tick) * math.cos(angle),
        center.dy + (outerRadius - tick) * math.sin(angle),
      );

      final p2 = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );

      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..strokeWidth = i % 30 == 0 ? 2.5 : 1
          ..color = i % 90 == 0
              ? const Color(0xffF7E08B)
              : const Color(0xffD4AF37).withValues(alpha: .7),
      );
    }

    //-----------------------------------------
    // Decorative Dots
    //-----------------------------------------

    final dotPaint = Paint()..color = const Color(0xffD4AF37);

    for (int i = 0; i < 36; i++) {
      final angle = i * 10 * math.pi / 180;

      final point = Offset(
        center.dx + (innerRadius - 8) * math.cos(angle),
        center.dy + (innerRadius - 8) * math.sin(angle),
      );

      canvas.drawCircle(point, 1.6, dotPaint);
    }

    //-----------------------------------------
    // Cardinal Letters
    //-----------------------------------------

    drawLabel(canvas, center, outerRadius - 40, "N", -90);
    drawLabel(canvas, center, outerRadius - 40, "E", 0);
    drawLabel(canvas, center, outerRadius - 40, "S", 90);
    drawLabel(canvas, center, outerRadius - 40, "W", 180);

    //-----------------------------------------
    // Arabic Directions
    //-----------------------------------------

    drawSmall(canvas, center, outerRadius - 52, "ش", -90);
    drawSmall(canvas, center, outerRadius - 52, "ق", 0);
    drawSmall(canvas, center, outerRadius - 52, "ج", 90);
    drawSmall(canvas, center, outerRadius - 52, "غ", 180);
  }

  //-----------------------------------------

  void drawLabel(
    Canvas canvas,
    Offset center,
    double radius,
    String text,
    double deg,
  ) {
    final angle = deg * math.pi / 180;

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xffF2C94C),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    tp.layout();

    tp.paint(
      canvas,
      Offset(
        center.dx + radius * math.cos(angle) - tp.width / 2,
        center.dy + radius * math.sin(angle) - tp.height / 2,
      ),
    );
  }

  //-----------------------------------------

  void drawSmall(
    Canvas canvas,
    Offset center,
    double radius,
    String text,
    double deg,
  ) {
    final angle = deg * math.pi / 180;

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xffD4AF37).withValues(alpha: .8),
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.rtl,
    );

    tp.layout();

    tp.paint(
      canvas,
      Offset(
        center.dx + radius * math.cos(angle) - tp.width / 2,
        center.dy + radius * math.sin(angle) - tp.height / 2,
      ),
    );
  }

  //-----------------------------------------

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
