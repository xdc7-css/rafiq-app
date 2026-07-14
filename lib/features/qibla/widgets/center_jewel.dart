import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class CenterJewel extends StatelessWidget {
  final bool isAligned;
  final double size;
  final Animation<double>? pulseAnimation;

  const CenterJewel({
    super.key,
    this.isAligned = false,
    this.size = 28,
    this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Widget jewel = AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.2, -0.3),
          colors: [
            isAligned ? QiblaColors.success : QiblaColors.accentGold,
            isAligned ? const Color(0xFF1B5E20) : QiblaColors.goldDeep,
          ],
        ),
        border: Border.all(
          color: isAligned
              ? const Color(0xFF66BB6A)
              : QiblaColors.goldLight,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isAligned
                ? QiblaColors.success.withValues(alpha: 0.6)
                : QiblaColors.accentGold.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            blurRadius: 2,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: [
              Colors.white.withValues(alpha: 0.20),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );

    if (pulseAnimation != null) {
      return AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (_, child) {
          final scale = 1.0 + pulseAnimation!.value * 0.08;
          return Transform.scale(scale: scale, child: child);
        },
        child: jewel,
      );
    }

    return jewel;
  }
}
