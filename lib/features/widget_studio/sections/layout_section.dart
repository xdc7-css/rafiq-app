import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Layout controls: padding, vertical alignment, layout style.
class LayoutSection extends ConsumerWidget {
  const LayoutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);
    final config = studio.config;

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Layout',
          icon: Icons.dashboard_customize_rounded,
        ),
        const SizedBox(height: 12),
        StudioCard(
          child: Column(
            children: [
              // ── Vertical Alignment ──
              _AlignmentRow(
                current: config.verticalAlignment,
                onChanged: (v) => notifier.updateVerticalAlignment(v),
              ),
              const _LDiv(),
              // ── Layout Style ──
              _LayoutStyleRow(
                current: config.layoutStyle,
                onChanged: (v) => notifier.updateLayoutStyle(v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlignmentRow extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _AlignmentRow({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [
      ('top', Icons.vertical_align_top_rounded, 'Top'),
      ('center', Icons.vertical_align_center_rounded, 'Center'),
      ('bottom', Icons.vertical_align_bottom_rounded, 'Bottom'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vertical Alignment',
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textElevated,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            final isSelected = current == option.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                        : AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.goldPrimary
                          : AppTheme.borderSubtle,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        option.$2,
                        size: 18,
                        color: isSelected
                            ? AppTheme.goldPrimary
                            : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.$3,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.goldPrimary
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LayoutStyleRow extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _LayoutStyleRow({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [
      ('standard', Icons.grid_view_rounded, 'Standard'),
      ('compact', Icons.view_agenda_rounded, 'Compact'),
      ('minimal', Icons.view_headline_rounded, 'Minimal'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Widget Style',
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textElevated,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            final isSelected = current == option.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                        : AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.goldPrimary
                          : AppTheme.borderSubtle,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        option.$2,
                        size: 18,
                        color: isSelected
                            ? AppTheme.goldPrimary
                            : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.$3,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.goldPrimary
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LDiv extends StatelessWidget {
  const _LDiv();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: AppTheme.borderSubtle),
    );
  }
}
