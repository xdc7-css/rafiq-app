import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class QiblaNeedle extends StatelessWidget {
  final double heading;
  final double qiblah;
  final bool isAligned;

  const QiblaNeedle({
    super.key,
    required this.heading,
    required this.qiblah,
    this.isAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Qibla arrow (rotated to absolute qiblah bearing)
        Transform.rotate(
          angle: qiblah * math.pi / 180 * -1,
          child: const _GoldenArrow(),
        ),

        // Compass needle (rotated to compass heading)
        Transform.rotate(
          angle: heading * math.pi / 180 * -1,
          child: const _CompassNeedle(),
        ),
      ],
    );
  }
}

class _CompassNeedle extends StatelessWidget {
  const _CompassNeedle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // North (red)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 12,
              height: 115,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFF6B6B), Color(0xFFB71C1C)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(50),
                  bottom: Radius.circular(6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),

          // South (gold)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 12,
              height: 115,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF2C94C),
                    QiblaColors.accentGold,
                    Color(0xFF7A5B15),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                  bottom: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: QiblaColors.accentGold.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Metallic highlight
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 2.5,
              height: 110,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.30),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldenArrow extends StatelessWidget {
  const _GoldenArrow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 270,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Shaft
          Container(
            width: 6,
            height: 105,
            margin: const EdgeInsets.only(top: 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  QiblaColors.goldLight,
                  QiblaColors.accentGold,
                  QiblaColors.goldDark,
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: QiblaColors.accentGold.withValues(alpha: 0.45),
                  blurRadius: 14,
                ),
              ],
            ),
          ),

          // Tip
          Container(
            width: 32,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF6D5),
                  Color(0xFFF2C94C),
                  Color(0xFFC49719),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
                bottom: Radius.circular(8),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40D4AF37),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
