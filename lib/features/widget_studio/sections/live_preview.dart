import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widget_framework/framework.dart';
import '../providers/widget_studio_provider.dart';

/// The live preview widget — renders the current config in real-time.
///
/// Uses [StyleResolver.resolve] and [WidgetFrameBuilder.buildPreview]
/// from the Widget Framework. No rendering logic is duplicated here.
class LivePreview extends ConsumerWidget {
  const LivePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final style = studio.resolvedStyle;
    final layout = studio.layoutConstraints;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 900;

    // Responsive preview sizing
    final maxPreviewWidth = isDesktop ? 420.0 : screenWidth - 40.0;
    final previewScale = maxPreviewWidth / 340.0;
    final previewHeight = 340.0 * previewScale;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24 : 20,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Preview Card ──
            Container(
              width: maxPreviewWidth,
              constraints: BoxConstraints(maxHeight: previewHeight),
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Transform.scale(
                  scale: previewScale.clamp(0.5, 1.2),
                  child: _WidgetPreviewContent(
                    config: studio.config,
                    style: style,
                    layout: layout,
                    widgetType: studio.widgetType,
                  ),
                ),
              ),
            ),
            // ── Preview Label ──
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.widgets_rounded,
                  size: 12,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  '${studio.widgetType.displayName} · ${studio.widgetSize.name}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders the actual widget preview content based on type.
///
/// Each type gets a placeholder preview that demonstrates the style.
/// Real widget content (prayer times, quran verses, etc.) will be
/// added when we implement the actual widgets.
class _WidgetPreviewContent extends StatelessWidget {
  final WidgetConfig config;
  final WidgetStyle style;
  final WidgetLayoutConstraints layout;
  final StudioWidgetType widgetType;

  const _WidgetPreviewContent({
    required this.config,
    required this.style,
    required this.layout,
    required this.widgetType,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetFrameBuilder.buildPreview(
      style: style,
      layout: layout,
      child: _buildWidgetContent(),
    );
  }

  Widget _buildWidgetContent() {
    switch (widgetType) {
      case StudioWidgetType.prayerTimes:
        return _PrayerTimesPreview(style: style);
      case StudioWidgetType.quran:
        return _QuranPreview(style: style);
      case StudioWidgetType.tasbih:
        return _TasbihPreview(style: style);
      case StudioWidgetType.dashboard:
        return _DashboardPreview(style: style);
    }
  }
}

// ════════════════════════════════════════════════════════════════════════
// TYPE-SPECIFIC PREVIEW CONTENT
// ════════════════════════════════════════════════════════════════════════

class _PrayerTimesPreview extends StatelessWidget {
  final WidgetStyle style;
  const _PrayerTimesPreview({required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(style.paddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Row(
            children: [
              Icon(Icons.mosque_rounded, size: 16, color: style.accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Prayer Times',
                  style: style.titleStyle.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: style.contentGap * 0.6),
          // ── Date ──
          Text(
            'Wednesday, 15 Dhul Hijjah 1447',
            style: style.captionStyle,
          ),
          SizedBox(height: style.contentGap * 0.6),
          // ── Prayer Rows ──
          _PrayerRow(name: 'Fajr', time: '04:12', style: style),
          _PrayerRow(name: 'Sunrise', time: '05:48', style: style, muted: true),
          _PrayerRow(name: 'Dhuhr', time: '12:31', style: style),
          _PrayerRow(name: 'Asr', time: '16:08', style: style),
          _PrayerRow(name: 'Maghrib', time: '19:24', style: style, highlighted: true),
          _PrayerRow(name: 'Isha', time: '21:02', style: style),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final String time;
  final WidgetStyle style;
  final bool muted;
  final bool highlighted;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.style,
    this.muted = false,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final nameColor = highlighted
        ? style.accent
        : muted
            ? style.textMuted
            : style.textPrimary;
    final timeColor = highlighted ? style.accent : style.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
              color: nameColor,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              color: timeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuranPreview extends StatelessWidget {
  final WidgetStyle style;
  const _QuranPreview({required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(style.paddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 20, color: style.accent),
          const SizedBox(height: 8),
          Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            style: TextStyle(
              fontSize: 18,
              color: style.textPrimary,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: style.contentGap * 0.5),
          Text(
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            style: TextStyle(
              fontSize: 16,
              color: style.textSecondary,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: style.contentGap * 0.3),
          Text(
            'Al-Fatiha · 1 · Ayah 1-2',
            style: style.captionStyle.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TasbihPreview extends StatelessWidget {
  final WidgetStyle style;
  const _TasbihPreview({required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(style.paddingH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'سُبْحَانَ اللَّه',
            style: TextStyle(
              fontSize: 20,
              color: style.textPrimary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // ── Counter Circle ──
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: style.accent, width: 3),
              color: style.surface,
            ),
            alignment: Alignment.center,
            child: Text(
              '33',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: style.accent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '0 / 99',
            style: style.captionStyle,
          ),
        ],
      ),
    );
  }
}

class _DashboardPreview extends StatelessWidget {
  final WidgetStyle style;
  const _DashboardPreview({required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(style.paddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Text('Dashboard', style: style.titleStyle.copyWith(fontSize: 15)),
          SizedBox(height: style.contentGap * 0.5),
          // ── Stats Grid ──
          Row(
            children: [
              Expanded(
                child: _DashboardStat(
                  icon: Icons.mosque_rounded,
                  label: 'Next Prayer',
                  value: 'Fajr',
                  accent: style.accent,
                  style: style,
                ),
              ),
              SizedBox(width: style.contentGap * 0.5),
              Expanded(
                child: _DashboardStat(
                  icon: Icons.book_rounded,
                  label: 'Page',
                  value: '286',
                  accent: style.accent,
                  style: style,
                ),
              ),
            ],
          ),
          SizedBox(height: style.contentGap * 0.4),
          Row(
            children: [
              Expanded(
                child: _DashboardStat(
                  icon: Icons.calculate_rounded,
                  label: 'Tasbih',
                  value: '99',
                  accent: style.accent,
                  style: style,
                ),
              ),
              SizedBox(width: style.contentGap * 0.5),
              Expanded(
                child: _DashboardStat(
                  icon: Icons.calendar_month_rounded,
                  label: 'Date',
                  value: '15',
                  accent: style.accent,
                  style: style,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final WidgetStyle style;

  const _DashboardStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: style.surface,
        borderRadius: BorderRadius.circular(style.borderRadius * 0.75),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: style.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: style.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
