import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Appearance controls: colors, transparency, radius, border, shadows.
class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);
    final config = studio.config;

    return Column(
      children: [
        const StudioSectionHeader(
          title: 'Appearance',
          icon: Icons.auto_awesome_rounded,
        ),
        const SizedBox(height: 12),
        StudioCard(
          child: Column(
            children: [
              // ── Background Color ──
              _ColorRow(
                label: 'Background',
                currentColor: config.backgroundColor != null
                    ? Color(config.backgroundColor!)
                    : null,
                presets: _bgPresets,
                onSelect: (c) => notifier.updateBackgroundColor(c),
                onClear: () => notifier.clearBackgroundColor(),
                hasValue: config.backgroundColor != null,
              ),
              const _Divider(),
              // ── Text Color ──
              _ColorRow(
                label: 'Text Color',
                currentColor: config.textColor != null
                    ? Color(config.textColor!)
                    : null,
                presets: _textPresets,
                onSelect: (c) => notifier.updateTextColor(c),
                onClear: () => notifier.clearTextColor(),
                hasValue: config.textColor != null,
              ),
              const _Divider(),
              // ── Accent Color ──
              _ColorRow(
                label: 'Accent',
                currentColor: config.accentColor != null
                    ? Color(config.accentColor!)
                    : null,
                presets: _accentPresets,
                onSelect: (c) => notifier.updateAccentColor(c),
                onClear: () => notifier.clearAccentColor(),
                hasValue: config.accentColor != null,
              ),
              const _Divider(),
              // ── Transparency ──
              _SliderRow(
                label: 'Transparency',
                value: config.transparency ?? 0.0,
                min: 0.0,
                max: 0.9,
                divisions: 18,
                displayValue: config.transparency != null
                    ? '${((config.transparency!) * 100).round()}%'
                    : 'None',
                onChanged: (v) => notifier.updateTransparency(v),
              ),
              const _Divider(),
              // ── Corner Radius ──
              _SliderRow(
                label: 'Corner Radius',
                value: config.borderRadius ?? 16.0,
                min: 0,
                max: 40,
                divisions: 40,
                displayValue: config.borderRadius != null
                    ? '${config.borderRadius!.round()}px'
                    : 'Default',
                onChanged: (v) => notifier.updateBorderRadius(v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Color Row ──────────────────────────────────────────────────────

class _ColorRow extends StatelessWidget {
  final String label;
  final Color? currentColor;
  final List<Color> presets;
  final ValueChanged<Color> onSelect;
  final VoidCallback onClear;
  final bool hasValue;

  const _ColorRow({
    required this.label,
    required this.currentColor,
    required this.presets,
    required this.onSelect,
    required this.onClear,
    required this.hasValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            if (hasValue)
              GestureDetector(
                onTap: onClear,
                child: Text(
                  'Reset',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppTheme.goldPrimary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // ── Color palette ──
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: presets.length + 1, // +1 for custom picker
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == presets.length) {
                return _CustomColorButton(
                  currentColor: currentColor,
                  onSelect: onSelect,
                );
              }
              final color = presets[index];
              final isSelected = currentColor?.toARGB32() == color.toARGB32();
              return GestureDetector(
                onTap: () => onSelect(color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.goldPrimary
                          : Colors.white.withValues(alpha: 0.12),
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: _contrastColor(color),
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CustomColorButton extends StatelessWidget {
  final Color? currentColor;
  final ValueChanged<Color> onSelect;

  const _CustomColorButton({required this.currentColor, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final color = await _showCustomColorPicker(
          context,
          currentColor ?? AppTheme.goldPrimary,
        );
        if (color != null) onSelect(color);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─── Slider Row ─────────────────────────────────────────────────────

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

// ─── Divider ────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        height: 1,
        color: AppTheme.borderSubtle,
      ),
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────────────

Color _contrastColor(Color color) {
  final luminance = color.computeLuminance();
  return luminance > 0.5 ? Colors.black87 : Colors.white;
}

const _bgPresets = [
  Color(0xFF0B1730),
  Color(0xFF111A33),
  Color(0xFF16233E),
  Color(0xFF000000),
  Color(0xFF1A1A2E),
  Color(0xFF1E2746),
  Color(0xFF0D1B2A),
  Color(0xFF1B2946),
];

const _textPresets = [
  Colors.white,
  Color(0xFFD4DBE7),
  Color(0xFFF0D896),
  Color(0xFFE5C97F),
  Color(0xFF000000),
  Color(0xFF1A1A2E),
  Color(0xFF2196F3),
  Color(0xFF4CAF50),
];

const _accentPresets = [
  Color(0xFFD4AF37),
  Color(0xFFC99A1A),
  Color(0xFFB8860B),
  Color(0xFF2196F3),
  Color(0xFF4CAF50),
  Color(0xFFFF5722),
  Color(0xFF9C27B0),
  Color(0xFFE91E63),
];

/// Simple custom color picker dialog.
Future<Color?> _showCustomColorPicker(BuildContext context, Color initial) async {
  return showDialog<Color>(
    context: context,
    builder: (ctx) => _ColorPickerDialog(initial: initial),
  );
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initial;
  const _ColorPickerDialog({required this.initial});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late double _hue;
  late double _saturation;
  late double _lightness;

  @override
  void initState() {
    super.initState();
    final hsl = HSLColor.fromColor(widget.initial);
    _hue = hsl.hue;
    _saturation = hsl.saturation;
    _lightness = hsl.lightness;
  }

  Color get _currentColor =>
      HSLColor.fromAHSL(1.0, _hue, _saturation, _lightness).toColor();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppTheme.borderGold),
      ),
      title: Text(
        'Pick Color',
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      content: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Preview ──
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _currentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ── Hue ──
            _PickerSlider(
              label: 'Hue',
              value: _hue,
              min: 0,
              max: 360,
              activeColor: _currentColor,
              onChanged: (v) => setState(() => _hue = v),
            ),
            // ── Saturation ──
            _PickerSlider(
              label: 'Saturation',
              value: _saturation,
              min: 0,
              max: 1,
              activeColor: _currentColor,
              onChanged: (v) => setState(() => _saturation = v),
            ),
            // ── Lightness ──
            _PickerSlider(
              label: 'Lightness',
              value: _lightness,
              min: 0.05,
              max: 0.95,
              activeColor: _currentColor,
              onChanged: (v) => setState(() => _lightness = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: GoogleFonts.cairo(color: AppTheme.textMuted)),
        ),
        GoldButton(
          label: 'Select',
          onTap: () => Navigator.of(context).pop(_currentColor),
        ),
      ],
    );
  }
}

class _PickerSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const _PickerSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.round()}',
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: AppTheme.bgSurface,
            thumbColor: activeColor,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            trackHeight: 4,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
