import 'package:flutter/material.dart';

class MosqueSilhouette extends StatelessWidget {
  const MosqueSilhouette({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: size.height * 0.25,
      child: RepaintBoundary(
        child: Opacity(
          opacity: 0.12, // Very low opacity, blending naturally
          child: CustomPaint(
            painter: const _MosqueSilhouettePainter(),
            size: Size(size.width, size.height * 0.25),
          ),
        ),
      ),
    );
  }
}

class _MosqueSilhouettePainter extends CustomPainter {
  const _MosqueSilhouettePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          const Color(0xFF040B13), // Deepest background tone
          const Color(0xFF07172B).withValues(alpha: 0.0), // Fades to transparent at top
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start at bottom-left
    path.moveTo(0, h);
    path.lineTo(0, h * 0.65);

    // Left flat roof
    path.lineTo(w * 0.08, h * 0.65);

    // Small left dome
    path.lineTo(w * 0.08, h * 0.60);
    path.quadraticBezierTo(w * 0.12, h * 0.40, w * 0.16, h * 0.60);
    path.lineTo(w * 0.16, h * 0.65);

    // Minaret 1 (Left Tall Minaret)
    path.lineTo(w * 0.22, h * 0.65);
    path.lineTo(w * 0.22, h * 0.20);
    // Minaret tip
    path.lineTo(w * 0.235, h * 0.12);
    path.lineTo(w * 0.25, h * 0.20);
    path.lineTo(w * 0.25, h * 0.65);

    // Middle connecting wall
    path.lineTo(w * 0.35, h * 0.65);

    // Large Center Dome
    path.lineTo(w * 0.35, h * 0.58);
    // Left dome base curve
    path.cubicTo(
      w * 0.38, h * 0.58,
      w * 0.40, h * 0.30,
      w * 0.50, h * 0.30,
    );
    // Right dome base curve
    path.cubicTo(
      w * 0.60, h * 0.30,
      w * 0.62, h * 0.58,
      w * 0.65, h * 0.58);
    path.lineTo(w * 0.65, h * 0.65);

    // Minaret 2 (Right Tall Minaret)
    path.lineTo(w * 0.75, h * 0.65);
    path.lineTo(w * 0.75, h * 0.15);
    // Tip
    path.lineTo(w * 0.765, h * 0.08);
    path.lineTo(w * 0.78, h * 0.15);
    path.lineTo(w * 0.78, h * 0.65);

    // Right Dome
    path.lineTo(w * 0.82, h * 0.65);
    path.lineTo(w * 0.82, h * 0.58);
    path.quadraticBezierTo(w * 0.87, h * 0.38, w * 0.92, h * 0.58);
    path.lineTo(w * 0.92, h * 0.65);

    // Rightmost flat roof
    path.lineTo(w, h * 0.65);
    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, paint);

    // Optional subtle outline to highlight dome structures
    final strokePaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
