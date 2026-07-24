import 'package:flutter/material.dart';
import 'compass_painter.dart';
import 'qibla_needle.dart';

class CompassWidget extends StatelessWidget {
  final double heading;
  final double qiblaDirection;

  const CompassWidget({super.key, this.heading = 0, this.qiblaDirection = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xff1E293B), Color(0xff111A33), Color(0xff0B1324)],
        ),
        border: Border.all(color: const Color(0xffD4AF37), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffD4AF37).withValues(alpha: .18),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(340, 340), painter: CompassPainter()),
          QiblaNeedle(heading: heading, qiblaDirection: qiblaDirection),
        ],
      ),
    );
  }
}
