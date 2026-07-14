import 'dart:math' as math;
import 'package:flutter/material.dart';

class GlowHalo extends StatefulWidget {
  const GlowHalo({super.key});

  @override
  State<GlowHalo> createState() => _GlowHaloState();
}

class _GlowHaloState extends State<GlowHalo>
    with TickerProviderStateMixin {
  late final AnimationController _breatheController;
  late final AnimationController _rotateController;
  late final Animation<double> _breatheAnim;

  @override
  void initState() {
    super.initState();
    // Continuous breathing animation
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _breatheAnim = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    // Continuous slow rotation for the geometric halo ring
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Radial Glow Shadows
          AnimatedBuilder(
            animation: _breatheAnim,
            builder: (context, _) {
              final scale = _breatheAnim.value;
              final blurBase = 50.0 * scale;
              final spreadBase = 6.0 * scale;

              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Deep Gold/Amber Base Glow
                    BoxShadow(
                      color: const Color(0x77D4AF37).withValues(alpha: 0.35 * scale),
                      blurRadius: blurBase * 1.1,
                      spreadRadius: spreadBase * 1.2,
                    ),
                    // Bright Core Glow
                    BoxShadow(
                      color: const Color(0x99FFD970).withValues(alpha: 0.45 * scale),
                      blurRadius: blurBase * 0.7,
                      spreadRadius: spreadBase * 0.5,
                    ),
                    // Large ambient soft glow
                    BoxShadow(
                      color: const Color(0x33F4D27A).withValues(alpha: 0.2 * scale),
                      blurRadius: blurBase * 1.6,
                      spreadRadius: spreadBase * 2.0,
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Rotating Halo Ring
          AnimatedBuilder(
            animation: _rotateController,
            builder: (context, _) {
              return Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: CustomPaint(
                  painter: const _HaloRingPainter(),
                  size: const Size(190, 190),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HaloRingPainter extends CustomPainter {
  const _HaloRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF4D27A).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    // Draw a dashed circular halo
    const int dashCount = 40;
    const double dashAngle = (2 * math.pi) / dashCount;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        final startAngle = i * dashAngle;
        final sweepAngle = dashAngle * 0.7; // dash length

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    }

    // Draw little geometric dots at 8 points
    final dotPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final dotPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(dotPos, 1.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
