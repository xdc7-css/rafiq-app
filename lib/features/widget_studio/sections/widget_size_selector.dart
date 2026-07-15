import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widget_framework/framework.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Horizontal selector for widget size (Small, Medium, Tall, Large, Thin).
class WidgetSizeSelector extends ConsumerWidget {
  const WidgetSizeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Widget Size',
          icon: Icons.aspect_ratio_rounded,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: WidgetSize.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final size = WidgetSize.values[index];
              final isSelected = studio.widgetSize == size;
              return _SizeCard(
                size: size,
                isSelected: isSelected,
                onTap: () => notifier.setWidgetSize(size),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SizeCard extends StatelessWidget {
  final WidgetSize size;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeCard({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Visual proportion representation
    final proportions = _getProportions(size);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 72,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.goldPrimary.withValues(alpha: 0.12)
              : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.goldPrimary : AppTheme.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Proportion visual ──
            Container(
              width: proportions.$1,
              height: proportions.$2,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.goldPrimary.withValues(alpha: 0.3)
                    : AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.goldPrimary : AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              size.name.toUpperCase(),
              style: GoogleFonts.cairo(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.goldPrimary : AppTheme.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns (width, height) for the mini visual proportion.
  (double, double) _getProportions(WidgetSize size) {
    switch (size) {
      case WidgetSize.small:
        return (20, 20);
      case WidgetSize.medium:
        return (36, 18);
      case WidgetSize.tall:
        return (18, 28);
      case WidgetSize.large:
        return (32, 32);
      case WidgetSize.thin:
        return (36, 8);
    }
  }
}
