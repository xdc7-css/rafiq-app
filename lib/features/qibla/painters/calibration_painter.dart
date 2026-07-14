import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class CalibrationPainter extends CustomPainter {
  final double progress;
  const CalibrationPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(size.width, size.height) * 0.35;

    // Figure-8 path (lemniscate)
    final paint = Paint()
      ..color = QiblaColors.accentGold.withValues(
        alpha: 0.3 + 0.2 * math.sin(progress * math.pi * 2),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    for (double t = 0; t <= math.pi * 2; t += 0.04) {
      final x = cx + r * math.sin(t);
      final y = cy + r * 0.55 * math.sin(t * 2);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Moving dot
    final dotPaint = Paint()
      ..color = QiblaColors.accentGold
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final dotX = cx + r * math.sin(progress * math.pi * 4);
    final dotY = cy + r * 0.55 * math.sin(progress * math.pi * 8);
    canvas.drawCircle(Offset(dotX, dotY), 4, dotPaint);
  }

  @override
  bool shouldRepaint(CalibrationPainter old) => old.progress != progress;
}
