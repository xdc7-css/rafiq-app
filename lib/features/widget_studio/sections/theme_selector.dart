import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widget_framework/framework.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Grid selector for widget themes from the ThemeRegistry.
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);
    final options = ThemeRegistry.themeOptions;

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Theme',
          icon: Icons.palette_rounded,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = studio.config.themeId == option.id;
              final theme = ThemeRegistry.getById(option.id);
              return _ThemeCard(
                name: option.name,
                theme: theme,
                isSelected: isSelected,
                onTap: () => notifier.updateTheme(option.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String name;
  final WidgetTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.name,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = theme.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 90,
        decoration: BoxDecoration(
          color: c.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.goldPrimary : AppTheme.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Color preview dots ──
            Row(
              children: [
                _ColorDot(color: c.foundationPrimary),
                const SizedBox(width: 4),
                _ColorDot(color: c.surfacePrimary),
                const SizedBox(width: 4),
                _ColorDot(color: c.accentPrimary),
              ],
            ),
            const Spacer(),
            // ── Theme name ──
            Text(
              name,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: c.contentPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // ── Effect badges ──
            Row(
              children: [
                if (theme.useGlassEffect)
                  _Badge(label: 'Glass', color: c.accentPrimary),
                if (theme.useGoldGlow)
                  _Badge(label: 'Glow', color: c.accentPrimary),
                if (theme.usePatternOverlay)
                  _Badge(label: 'Pattern', color: c.accentPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4, top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
