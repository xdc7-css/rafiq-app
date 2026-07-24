import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class HelpCard extends StatelessWidget {
  final double alignmentProgress;
  final bool isAligned;

  const HelpCard({
    super.key,
    required this.alignmentProgress,
    this.isAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: QiblaColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAligned
              ? QiblaColors.success.withValues(alpha: 0.25)
              : QiblaColors.cardBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: QiblaColors.gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isAligned ? Icons.check_circle_rounded : Icons.screen_rotation_rounded,
              color: isAligned ? QiblaColors.success : QiblaColors.gold,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAligned
                      ? 'القبلة صحيحة'
                      : 'قم بتدوير هاتفك حتى يتطابق مؤشر الكعبة مع السهم الذهبي',
                  style: TextStyle(
                    fontSize: isAligned ? 13 : 11,
                    fontWeight: isAligned ? FontWeight.w700 : FontWeight.w500,
                    color: isAligned ? QiblaColors.success : QiblaColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: alignmentProgress,
                    strokeWidth: 3.5,
                    backgroundColor: QiblaColors.textSecondary.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(
                      isAligned ? QiblaColors.success : QiblaColors.gold,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${(alignmentProgress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAligned ? QiblaColors.success : QiblaColors.gold,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
