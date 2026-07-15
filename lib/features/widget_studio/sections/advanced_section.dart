import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Advanced controls: glass effect, pattern overlay, Material You.
class AdvancedSection extends ConsumerWidget {
  const AdvancedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);
    final config = studio.config;

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Advanced',
          icon: Icons.tune_rounded,
        ),
        const SizedBox(height: 12),
        StudioCard(
          child: Column(
            children: [
              _SwitchRow(
                label: 'Glass Effect',
                subtitle: 'Frosted blur background',
                icon: Icons.water_drop_outlined,
                value: config.glassEffect,
                onChanged: (v) => notifier.updateGlassEffect(v),
              ),
              const _ADiv(),
              _SwitchRow(
                label: 'Pattern Overlay',
                subtitle: 'Decorative background pattern',
                icon: Icons.texture_rounded,
                value: config.patternId != null,
                onChanged: (v) => notifier.updatePatternOverlay(v),
              ),
              const _ADiv(),
              _SwitchRow(
                label: 'Material You',
                subtitle: 'Dynamic color from wallpaper',
                icon: Icons.palette_outlined,
                value: config.materialYou,
                onChanged: (v) => notifier.updateMaterialYou(v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: value
                ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                : AppTheme.bgSurface,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: value ? AppTheme.goldPrimary : AppTheme.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textElevated,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: AppTheme.textMutedPremium,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.goldPrimary,
          activeTrackColor: AppTheme.goldPrimary.withValues(alpha: 0.3),
          inactiveTrackColor: AppTheme.bgSurface,
        ),
      ],
    );
  }
}

class _ADiv extends StatelessWidget {
  const _ADiv();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Divider(height: 1, color: AppTheme.borderSubtle),
    );
  }
}
