import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Typography controls: font family, size, weight, spacing, line height.
class TypographySection extends ConsumerWidget {
  const TypographySection({super.key});

  static const _fontFamilies = <String?>[
    null, // System default
    'Cairo',
    'Noto Naskh Arabic',
    'Amiri',
    'Tajawal',
    'Inter',
    'Roboto',
  ];

  static const _fontLabels = <String>[
    'Default',
    'Cairo',
    'Noto Naskh Arabic',
    'Amiri',
    'Tajawal',
    'Inter',
    'Roboto',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);
    final config = studio.config;

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Typography',
          icon: Icons.text_fields_rounded,
        ),
        const SizedBox(height: 12),
        StudioCard(
          child: Column(
            children: [
              // ── Font Family ──
              _FontFamilyRow(
                currentFamily: config.fontFamily,
                families: _fontFamilies,
                labels: _fontLabels,
                onSelect: (f) => notifier.updateFontFamily(f),
              ),
              const _TDiv(),
              // ── Font Size ──
              _SliderRow(
                label: 'Font Size',
                value: config.fontSize ?? 14.0,
                min: 10,
                max: 28,
                divisions: 36,
                displayValue: config.fontSize != null
                    ? '${config.fontSize!.round()}sp'
                    : 'Default',
                onChanged: (v) => notifier.updateFontSize(v),
              ),
              const _TDiv(),
              // ── Letter Spacing ──
              _SliderRow(
                label: 'Letter Spacing',
                value: config.letterSpacing ?? 0.0,
                min: -2,
                max: 5,
                divisions: 14,
                displayValue: config.letterSpacing != null
                    ? config.letterSpacing!.toStringAsFixed(1)
                    : 'Default',
                onChanged: (v) => notifier.updateLetterSpacing(v),
              ),
              const _TDiv(),
              // ── Line Height ──
              _SliderRow(
                label: 'Line Height',
                value: config.lineHeight ?? 1.4,
                min: 0.8,
                max: 3.0,
                divisions: 22,
                displayValue: config.lineHeight != null
                    ? config.lineHeight!.toStringAsFixed(1)
                    : 'Default',
                onChanged: (v) => notifier.updateLineHeight(v),
              ),
              const _TDiv(),
              // ── Text Shadow ──
              _SwitchRow(
                label: 'Text Shadow',
                value: config.textShadow,
                onChanged: (v) => notifier.updateTextShadow(v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FontFamilyRow extends StatelessWidget {
  final String? currentFamily;
  final List<String?> families;
  final List<String> labels;
  final ValueChanged<String?> onSelect;

  const _FontFamilyRow({
    required this.currentFamily,
    required this.families,
    required this.labels,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = families.indexOf(currentFamily);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font Family',
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textElevated,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: families.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = index == currentIndex;
              return GestureDetector(
                onTap: () => onSelect(families[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                        : AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.goldPrimary
                          : AppTheme.borderSubtle,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[index],
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.goldPrimary
                          : AppTheme.textElevated,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textElevated,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.goldPrimary,
            activeTrackColor: AppTheme.goldPrimary.withValues(alpha: 0.3),
            inactiveTrackColor: AppTheme.bgSurface,
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String displayValue;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textElevated,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                displayValue,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.goldPrimary,
            inactiveTrackColor: AppTheme.bgSurface,
            thumbColor: AppTheme.goldPrimary,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayColor: AppTheme.goldPrimary.withValues(alpha: 0.1),
            trackHeight: 4,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _TDiv extends StatelessWidget {
  const _TDiv();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Divider(height: 1, color: AppTheme.borderSubtle),
    );
  }
}
