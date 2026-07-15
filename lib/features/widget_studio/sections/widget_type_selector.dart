import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Horizontal selector for widget type (Prayer Times, Quran, Tasbih, Dashboard).
class WidgetTypeSelector extends ConsumerWidget {
  const WidgetTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Widget Type',
          icon: Icons.widgets_rounded,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: StudioWidgetType.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final type = StudioWidgetType.values[index];
              final isSelected = studio.widgetType == type;
              return _TypeCard(
                type: type,
                isSelected: isSelected,
                onTap: () => notifier.setWidgetType(type),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final StudioWidgetType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case StudioWidgetType.prayerTimes:
        return Icons.mosque_rounded;
      case StudioWidgetType.quran:
        return Icons.menu_book_rounded;
      case StudioWidgetType.tasbih:
        return Icons.calculate_rounded;
      case StudioWidgetType.dashboard:
        return Icons.dashboard_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldPrimary.withValues(alpha: 0.12) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              size: 24,
              color: isSelected ? AppTheme.goldPrimary : AppTheme.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              type.displayName.split(' ').first,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.goldPrimary : AppTheme.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
