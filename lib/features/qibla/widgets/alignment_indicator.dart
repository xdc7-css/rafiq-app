import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/qibla_models.dart';
import '../utils/qibla_math.dart';

class AlignmentIndicator extends StatelessWidget {
  final bool isAligned;
  final double offset;
  final Animation<double>? pulseAnimation;

  const AlignmentIndicator({
    super.key,
    required this.isAligned,
    required this.offset,
    this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: isAligned ? _AlignedView(pulseAnimation: pulseAnimation) : _OffsetView(offset: offset),
    );
  }
}

class _AlignedView extends StatelessWidget {
  final Animation<double>? pulseAnimation;
  const _AlignedView({this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      key: const ValueKey('aligned'),
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            QiblaColors.success.withValues(alpha: 0.10),
            QiblaColors.success.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: QiblaColors.success.withValues(alpha: 0.25),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: QiblaColors.success.withValues(alpha: 0.08),
            blurRadius: 18,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF66BB6A), size: 24),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'القبلة أمامك',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF66BB6A),
                    ),
                  ),
                  Text(
                    'أنت الآن متجه نحو الكعبة المشرفة',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 9.5,
                      color: const Color(0xFF66BB6A).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (pulseAnimation != null) {
      return AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (_, child) {
          final s = 1.0 + pulseAnimation!.value * 0.03;
          return Transform.scale(scale: s, child: child);
        },
        child: content,
      );
    }
    return content;
  }
}

class _OffsetView extends StatelessWidget {
  final double offset;
  const _OffsetView({required this.offset});

  @override
  Widget build(BuildContext context) {
    final displayAngle = offset > 180 ? 360 - offset : offset;

    return Container(
      key: const ValueKey('offset'),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [QiblaColors.accentGold.withValues(alpha: 0.06), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: QiblaColors.accentGold.withValues(alpha: 0.18),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.navigation_rounded, color: QiblaColors.accentGold, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'قم بتدوير هاتفك باتجاه القبلة',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: QiblaColors.accentGold,
                    ),
                  ),
                  Text(
                    '${QiblaMath.formatDegrees(displayAngle)} متبقية',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: QiblaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
