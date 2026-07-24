import 'dart:math' as math;
import 'package:flutter/material.dart';

class QiblaNeedle extends StatelessWidget {
  /// اتجاه الجهاز الحالي
  final double heading;

  /// اتجاه القبلة
  final double qiblaDirection;

  const QiblaNeedle({
    super.key,
    required this.heading,
    required this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context) {
    final difference = (heading - qiblaDirection).abs();

    return Stack(
      alignment: Alignment.center,
      children: [
        //-----------------------------------------
        // Qibla Arrow
        //-----------------------------------------
        TweenAnimationBuilder<double>(
          tween: Tween(end: qiblaDirection),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (_, value, child) {
            return Transform.rotate(angle: value * math.pi / 180, child: child);
          },

          child: const _GoldenArrow(),
        ),

        //-----------------------------------------
        // Compass Needle
        //-----------------------------------------
        TweenAnimationBuilder<double>(
          tween: Tween(end: heading),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,

          builder: (_, value, child) {
            return Transform.rotate(angle: value * math.pi / 180, child: child);
          },

          child: const _CompassNeedle(),
        ),

        //-----------------------------------------
        // Center Circle
        //-----------------------------------------
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          width: 24,
          height: 24,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: difference < 3
                ? Colors.greenAccent
                : const Color(0xffD4AF37),

            boxShadow: [
              BoxShadow(
                color: difference < 3
                    ? Colors.greenAccent.withValues(alpha: .6)
                    : const Color(0xffD4AF37).withValues(alpha: .35),

                blurRadius: 22,

                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////

class _CompassNeedle extends StatelessWidget {
  const _CompassNeedle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 250,

      child: Stack(
        alignment: Alignment.center,

        children: [
          //---------------------------------
          Align(
            alignment: Alignment.topCenter,

            child: Container(
              width: 14,
              height: 120,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [Color(0xffFF5252), Color(0xffB71C1C)],
                ),

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                  bottom: Radius.circular(6),
                ),
              ),
            ),
          ),

          //---------------------------------
          Align(
            alignment: Alignment.bottomCenter,

            child: Container(
              width: 14,
              height: 120,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [Color(0xffF2C94C), Color(0xffD4AF37)],
                ),

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(6),
                  bottom: Radius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////

class _GoldenArrow extends StatelessWidget {
  const _GoldenArrow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,

      child: Stack(
        alignment: Alignment.topCenter,

        children: [
          Container(
            width: 8,
            height: 120,

            margin: const EdgeInsets.only(top: 22),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Color(0xffF7E08B),
                  Color(0xffD4AF37),
                  Color(0xff7A5B15),
                ],
              ),

              borderRadius: BorderRadius.circular(50),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xffD4AF37).withValues(alpha: .4),

                  blurRadius: 20,
                ),
              ],
            ),
          ),

          Container(
            width: 36,
            height: 46,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Color(0xffFFF6D5),
                  Color(0xffF2C94C),
                  Color(0xffC49719),
                ],
              ),

              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
                bottom: Radius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
