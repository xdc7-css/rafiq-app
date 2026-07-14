import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/qibla_models.dart';

class KaabaIcon extends StatelessWidget {
  final bool isAligned;
  final double breatheValue;
  final double size;

  const KaabaIcon({
    super.key,
    this.isAligned = false,
    this.breatheValue = 0.0,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final b = breatheValue;
    final glowAlpha = 0.12 + b * 0.08 + (isAligned ? 0.15 : 0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow halo
          Container(
            width: size * 0.90 + (isAligned ? b * 10 : 0),
            height: size * 0.90 + (isAligned ? b * 10 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  QiblaColors.accentGold.withValues(alpha: glowAlpha),
                  QiblaColors.accentGold.withValues(alpha: glowAlpha * 0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Alignment ring
          if (isAligned)
            Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: QiblaColors.success.withValues(alpha: 0.3 + b * 0.2),
                  width: 1.5,
                ),
              ),
            ),

          // Background circle
          Container(
            width: size * 0.70,
            height: size * 0.70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF1E293B), Color(0xFF111A33)],
              ),
              border: Border.all(
                color: QiblaColors.accentGold.withValues(alpha: 0.22),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: QiblaColors.accentGold.withValues(alpha: 0.10 + b * 0.06),
                  blurRadius: 20 + b * 6,
                  spreadRadius: 1 + b * 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),

          // Kaaba SVG
          SizedBox(
            width: size * 0.45,
            height: size * 0.45,
            child: SvgPicture.asset(
              'assets/icons/kaaba.svg',
              placeholderBuilder: (_) => _FallbackKaaba(size * 0.45),
            ),
          ),

          // Top reflection
          Positioned(
            top: size * 0.20,
            child: Container(
              width: size * 0.28,
              height: size * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackKaaba extends StatelessWidget {
  final double s;
  const _FallbackKaaba(this.s);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(s, s), painter: _FallbackPainter());
  }
}

class _FallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width * 0.5;
    final h = size.height * 0.65;

    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
      const Radius.circular(3),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A3A3A), Color(0xFF0A0A0A)],
        ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: w, height: h)),
    );

    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.1), width: w + 4, height: h * 0.08),
      Paint()
        ..shader = const LinearGradient(
          colors: [QiblaColors.accentGold, Color(0xFFF2C94C)],
        ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: w, height: h)),
    );

    final door = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.22, height: h * 0.28),
      const Radius.circular(2),
    );
    canvas.drawRRect(door, Paint()..color = QiblaColors.compassBg);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
