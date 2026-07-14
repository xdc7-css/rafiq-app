import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../painters/compass_face_painter.dart';
import '../models/qibla_models.dart';
import 'qibla_needle.dart';
import 'center_jewel.dart';

class CompassDial extends StatelessWidget {
  final double heading;
  final double qiblah;
  final bool isAligned;
  final double? size;

  const CompassDial({
    super.key,
    required this.heading,
    required this.qiblah,
    this.isAligned = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final compassSize = size ?? MediaQuery.of(context).size.width * 0.72;

    return SizedBox(
      width: compassSize + 32,
      height: compassSize + 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ambient glow
          Container(
            width: compassSize + 26,
            height: compassSize + 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: QiblaColors.accentGold.withValues(alpha: 0.07),
                  blurRadius: 55,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),

          // Depth shadow
          Container(
            width: compassSize + 14,
            height: compassSize + 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.22),
                ],
                stops: const [0.65, 1.0],
              ),
            ),
          ),

          // Gold bezel ring
          Container(
            width: compassSize + 6,
            height: compassSize + 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  QiblaColors.goldDark,
                  QiblaColors.accentGold,
                  QiblaColors.goldLight,
                  QiblaColors.accentGold,
                  QiblaColors.goldDark,
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppThemeShadow.dark,
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: QiblaColors.accentGold.withValues(alpha: 0.12),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(3.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(compassSize / 2),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        QiblaColors.compassBg.withValues(alpha: 0.3),
                        QiblaColors.compassBgMid.withValues(alpha: 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Static compass face (cached)
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(compassSize, compassSize),
                          painter: CompassFacePainter(),
                        ),
                      ),

                      // Animated needle layer
                      QiblaNeedle(
                        heading: heading,
                        qiblah: qiblah,
                        isAligned: isAligned,
                      ),

                      // Center jewel
                      CenterJewel(
                        isAligned: isAligned,
                        size: compassSize * 0.075,
                      ),

                      // Inner reflection overlay
                      IgnorePointer(
                        child: Container(
                          width: compassSize,
                          height: compassSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.12, -0.18),
                              radius: 0.88,
                              colors: [
                                Colors.white.withValues(alpha: 0.025),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppThemeShadow {
  AppThemeShadow._();
  static Color get dark => Colors.black.withValues(alpha: 0.3);
}
