import 'dart:math' as math;
import 'package:flutter/material.dart';

class IslamicPattern extends StatelessWidget {
  const IslamicPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: 320,
        height: 320,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Opacity(
          opacity: 0.03, // Opacity below 5%
          child: CustomPaint(
            painter: const _IslamicPatternPainter(),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  const _IslamicPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37) // Primary Gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.48;

    // Draw concentric geometric layers
    for (int ring = 1; ring <= 4; ring++) {
      final radius = maxRadius * (ring / 4);
      
      // Draw base circle
      canvas.drawCircle(center, radius, paint);

      // Draw star points for 8-fold and 16-fold geometry
      final int points = ring.isEven ? 8 : 16;
      final double angleStep = (2 * math.pi) / points;

      for (int i = 0; i < points; i++) {
        final double angle = i * angleStep;
        final start = Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        );

        // Connect lines to create geometric nodes
        final nextAngle = (i + (points ~/ 3)) * angleStep;
        final end = Offset(
          center.dx + radius * math.cos(nextAngle),
          center.dy + radius * math.sin(nextAngle),
        );

        canvas.drawLine(start, end, paint);
      }
    }

    // Centered Rub el Hizb (8-point star)
    final starPath = Path();
    final starRadius = maxRadius * 0.28;
    final innerRadius = starRadius * 0.707; // sin(45 deg) = 0.707

    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi) / 8 - math.pi / 2;
      final r = i.isEven ? starRadius : innerRadius;
      final point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );

      if (i == 0) {
        starPath.moveTo(point.dx, point.dy);
      } else {
        starPath.lineTo(point.dx, point.dy);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, paint);

    // Draw connecting rays from inner star to intermediate ring
    final rayRadius = maxRadius * 0.5;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final start = Offset(
        center.dx + (starRadius * 0.8) * math.cos(angle),
        center.dy + (starRadius * 0.8) * math.sin(angle),
      );
      final end = Offset(
        center.dx + rayRadius * math.cos(angle),
        center.dy + rayRadius * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
