import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Mosque Silhouette ───
class MosqueSilhouette extends StatelessWidget {
  final double height;
  final Color? color;
  final double opacity;

  const MosqueSilhouette({
    super.key,
    this.height = 120,
    this.color,
    this.opacity = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _MosquePainter(color ?? AppTheme.goldPrimary, opacity),
    );
  }
}

class _MosquePainter extends CustomPainter {
  final Color color;
  final double opacity;

  _MosquePainter(this.color, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final baseY = size.height;

    final domePath = Path()
      ..moveTo(cx - 50, baseY)
      ..quadraticBezierTo(cx - 55, baseY - 60, cx, baseY - 75)
      ..quadraticBezierTo(cx + 55, baseY - 60, cx + 50, baseY)
      ..close();
    canvas.drawPath(domePath, paint);

    final crescentPaint = Paint()
      ..color = color.withValues(alpha: opacity * 1.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, baseY - 82), width: 12, height: 12),
      -pi / 4,
      pi * 1.5,
      false,
      crescentPaint,
    );

    _drawMinaret(canvas, cx - 65, baseY, paint);
    _drawMinaret(canvas, cx + 65, baseY, paint);

    for (final dx in [-35, 35]) {
      final smallDome = Path()
        ..moveTo(cx + dx - 20, baseY)
        ..quadraticBezierTo(cx + dx - 22, baseY - 25, cx + dx, baseY - 30)
        ..quadraticBezierTo(cx + dx + 22, baseY - 25, cx + dx + 20, baseY)
        ..close();
      canvas.drawPath(smallDome, paint);
    }
  }

  void _drawMinaret(Canvas canvas, double cx, double baseY, Paint paint) {
    final path = Path()
      ..moveTo(cx - 6, baseY)
      ..lineTo(cx - 6, baseY - 95)
      ..lineTo(cx - 8, baseY - 98)
      ..lineTo(cx - 8, baseY - 105)
      ..lineTo(cx + 8, baseY - 105)
      ..lineTo(cx + 8, baseY - 98)
      ..lineTo(cx + 6, baseY - 98)
      ..lineTo(cx + 6, baseY)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Golden Crescent ───
class GoldenCrescent extends StatelessWidget {
  final double size;
  final Color? color;

  const GoldenCrescent({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CrescentPainter(color ?? AppTheme.goldPrimary),
    );
  }
}

class _CrescentPainter extends CustomPainter {
  final Color color;
  _CrescentPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addArc(Rect.fromLTWH(0, 0, size.width, size.height), -pi / 3, pi * 1.8)
      ..close();

    canvas.drawPath(path, paint);

    final cutPaint = Paint()..blendMode = BlendMode.dstOut;
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.15),
      size.width * 0.35,
      cutPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Decorative Arch ───
class IslamicArch extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final double opacity;

  const IslamicArch({
    super.key,
    this.width = 100,
    this.height = 60,
    this.color,
    this.opacity = 0.04,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ArchPainter(color ?? AppTheme.goldPrimary, opacity),
    );
  }
}

class _ArchPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _ArchPainter(this.color, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width / 2,
        -size.height * 0.2,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── 8-Pointed Star (Islamic geometric) ───
class IslamicStar extends StatelessWidget {
  final double size;
  final Color? color;
  final double opacity;

  const IslamicStar({
    super.key,
    this.size = 32,
    this.color,
    this.opacity = 0.04,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _IslamicStarPainter(color ?? AppTheme.goldPrimary, opacity),
    );
  }
}

class _IslamicStarPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _IslamicStarPainter(this.color, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(cx, cy);
    final path = Path();

    for (int i = 0; i < 16; i++) {
      final angle = i * (pi / 8) - pi / 2;
      final radius = i.isEven ? r : r * 0.4;
      final px = cx + radius * cos(angle);
      final py = cy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Decorative Frame ───
class IslamicDecorativeFrame extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color? color;

  const IslamicDecorativeFrame({
    super.key,
    required this.child,
    this.padding = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FramePainter(color ?? AppTheme.goldPrimary),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  final Color color;
  _FramePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const inset = 8.0;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );

    const cornerSize = 20.0;
    for (final corner in [
      Offset(inset, inset),
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      Offset(size.width - inset, size.height - inset),
    ]) {
      final path = Path();
      if (corner == Offset(inset, inset)) {
        path
          ..moveTo(corner.dx, corner.dy + cornerSize)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx + cornerSize, corner.dy);
      } else if (corner == Offset(size.width - inset, inset)) {
        path
          ..moveTo(corner.dx - cornerSize, corner.dy)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx, corner.dy + cornerSize);
      } else if (corner == Offset(inset, size.height - inset)) {
        path
          ..moveTo(corner.dx, corner.dy - cornerSize)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx + cornerSize, corner.dy);
      } else {
        path
          ..moveTo(corner.dx - cornerSize, corner.dy)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx, corner.dy - cornerSize);
      }
      canvas.drawPath(path, paint);
    }

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Lantern ───
class LanternIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const LanternIcon({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.4),
      painter: _LanternPainter(color ?? AppTheme.goldPrimary),
    );
  }
}

class _LanternPainter extends CustomPainter {
  final Color color;
  _LanternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cx = size.width / 2;
    final w = size.width * 0.4;

    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height * 0.1), paint);

    final topPath = Path()
      ..moveTo(cx - w, size.height * 0.15)
      ..lineTo(cx + w, size.height * 0.15)
      ..lineTo(cx + w * 0.7, size.height * 0.25)
      ..lineTo(cx - w * 0.7, size.height * 0.25)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.1);
    canvas.drawPath(topPath, paint);
    paint
      ..style = PaintingStyle.stroke
      ..color = color;

    final bodyPath = Path()
      ..moveTo(cx - w * 0.7, size.height * 0.25)
      ..quadraticBezierTo(
        cx - w * 1.1,
        size.height * 0.5,
        cx - w * 0.6,
        size.height * 0.75,
      )
      ..lineTo(cx - w * 0.5, size.height * 0.85)
      ..lineTo(cx + w * 0.5, size.height * 0.85)
      ..lineTo(cx + w * 0.6, size.height * 0.75)
      ..quadraticBezierTo(
        cx + w * 1.1,
        size.height * 0.5,
        cx + w * 0.7,
        size.height * 0.25,
      )
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.06);
    canvas.drawPath(bodyPath, paint);
    paint
      ..style = PaintingStyle.stroke
      ..color = color;
    canvas.drawPath(bodyPath, paint);

    canvas.drawCircle(
      Offset(cx, size.height * 0.5),
      w * 0.2,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    canvas.drawLine(
      Offset(cx - w * 0.5, size.height * 0.85),
      Offset(cx + w * 0.5, size.height * 0.85),
      paint,
    );
    canvas.drawLine(
      Offset(cx - w * 0.3, size.height * 0.92),
      Offset(cx, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(cx + w * 0.3, size.height * 0.92),
      Offset(cx, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Kaaba Silhouette ───
class KaabaSilhouette extends StatelessWidget {
  final double size;
  final Color? color;

  const KaabaSilhouette({super.key, this.size = 48, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.75, size),
      painter: _KaabaPainter(color ?? AppTheme.goldPrimary),
    );
  }
}

class _KaabaPainter extends CustomPainter {
  final Color color;
  _KaabaPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final bodyPath = Path()
      ..moveTo(w * 0.1, h * 0.2)
      ..lineTo(w * 0.9, h * 0.2)
      ..lineTo(w * 0.85, h * 0.95)
      ..lineTo(w * 0.15, h * 0.95)
      ..close();
    canvas.drawPath(bodyPath, paint);

    paint.color = color.withValues(alpha: 0.3);
    canvas.drawCircle(Offset(w * 0.12, h * 0.25), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Islamic Floral Ornament ───
class FloralOrnament extends StatelessWidget {
  final double size;
  final Color? color;
  final double opacity;

  const FloralOrnament({
    super.key,
    this.size = 40,
    this.color,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FloralPainter(color ?? AppTheme.goldPrimary, opacity),
    );
  }
}

class _FloralPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _FloralPainter(this.color, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(cx, cy) * 0.8;

    for (int i = 0; i < 6; i++) {
      final angle = i * (pi / 3);
      final px = cx + r * cos(angle);
      final py = cy + r * sin(angle);

      final petalPath = Path()
        ..moveTo(cx, cy)
        ..quadraticBezierTo(
          cx + (px - cx) * 0.5 - (py - cy) * 0.3,
          cy + (py - cy) * 0.5 + (px - cx) * 0.3,
          px,
          py,
        )
        ..quadraticBezierTo(
          cx + (px - cx) * 0.5 + (py - cy) * 0.3,
          cy + (py - cy) * 0.5 - (px - cx) * 0.3,
          cx,
          cy,
        );
      canvas.drawPath(petalPath, paint);
    }

    canvas.drawCircle(Offset(cx, cy), r * 0.15, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Prayer Rug ───
class PrayerRug extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const PrayerRug({super.key, this.width = 60, this.height = 100, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _RugPainter(color ?? AppTheme.goldPrimary),
    );
  }
}

class _RugPainter extends CustomPainter {
  final Color color;
  _RugPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final bodyPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.1, 0, w * 0.8, h),
          const Radius.circular(4),
        ),
      );
    canvas.drawPath(bodyPath, paint);

    paint
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final archPath = Path()
      ..moveTo(w * 0.2, h * 0.15)
      ..quadraticBezierTo(w * 0.5, -h * 0.05, w * 0.8, h * 0.15);
    canvas.drawPath(archPath, paint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.1, 0, w * 0.8, h),
        const Radius.circular(4),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Open Quran Illustration ───
class OpenQuranIllustration extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const OpenQuranIllustration({
    super.key,
    this.width = 64,
    this.height = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _OpenQuranPainter(color ?? AppTheme.goldPrimary),
    );
  }
}

class _OpenQuranPainter extends CustomPainter {
  final Color color;
  _OpenQuranPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final leftPage = Path()
      ..moveTo(cx, h * 0.08)
      ..quadraticBezierTo(w * 0.05, h * 0.15, w * 0.08, h * 0.92)
      ..lineTo(cx - 2, h * 0.88)
      ..close();

    final rightPage = Path()
      ..moveTo(cx, h * 0.08)
      ..quadraticBezierTo(w * 0.95, h * 0.15, w * 0.92, h * 0.92)
      ..lineTo(cx + 2, h * 0.88)
      ..close();

    final fill = Paint()..color = color.withValues(alpha: 0.1);
    canvas.drawPath(leftPage, fill);
    canvas.drawPath(rightPage, fill);

    final stroke = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(leftPage, stroke);
    canvas.drawPath(rightPage, stroke);
    canvas.drawLine(Offset(cx, h * 0.08), Offset(cx, h * 0.88), stroke);

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 0.6;
    for (int i = 0; i < 4; i++) {
      final y = h * 0.25 + i * h * 0.14;
      canvas.drawLine(Offset(w * 0.15, y), Offset(cx - 6, y), linePaint);
      canvas.drawLine(Offset(cx + 6, y), Offset(w * 0.85, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Prayer Beads (Tasbeeh) ───
class PrayerBeadsIllustration extends StatelessWidget {
  final double size;
  final Color? color;

  const PrayerBeadsIllustration({super.key, this.size = 48, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.6),
      painter: _BeadsPainter(color ?? AppTheme.goldPrimary),
    );
  }
}

class _BeadsPainter extends CustomPainter {
  final Color color;
  _BeadsPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final beadPaint = Paint()..style = PaintingStyle.fill;
    final stringPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < 9; i++) {
      final t = i / 8;
      final x = size.width * 0.08 + t * size.width * 0.84;
      final y = size.height * 0.5 + sin(t * pi) * size.height * 0.35;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      beadPaint.color = color.withValues(alpha: i == 4 ? 0.45 : 0.2);
      canvas.drawCircle(Offset(x, y), i == 4 ? 5 : 3.5, beadPaint);
    }
    canvas.drawPath(path, stringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
