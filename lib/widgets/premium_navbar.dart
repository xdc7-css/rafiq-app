import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/settings_model.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

/// Floating glass navbar — logo, nav, theme toggle, notifications, profile.
class PremiumNavbar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int>? onNavigate;

  const PremiumNavbar({
    super.key,
    required this.selectedIndex,
    this.onNavigate,
  });

  static const _navItems = [
    ('الرئيسية', Icons.home_rounded, '/home'),
    ('القرآن', Icons.menu_book_rounded, '/quran'),
    ('الحديث', Icons.nights_stay_rounded, '/hadith'),
    ('الأذكار', Icons.wb_sunny_rounded, '/adhkar'),
    ('الزيارات', Icons.mosque_rounded, '/ziyarat'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 900;
    final settings = ref.watch(settingsNotifierProvider);
    final isDark = settings.themeMode != ThemeModeOption.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: isCompact ? 56 : 64,
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppTheme.bgCard.withValues(alpha: 0.75),
                      AppTheme.bgSurface.withValues(alpha: 0.55),
                    ]
                  : [
                      AppTheme.lightBgCard.withValues(alpha: 0.85),
                      AppTheme.lightBgCard.withValues(alpha: 0.7),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? AppTheme.borderSubtle
                  : AppTheme.goldPrimary.withValues(alpha: 0.12),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppTheme.bgPrimary.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              if (isDark)
                BoxShadow(
                  color: AppTheme.glowGold,
                  blurRadius: 32,
                  spreadRadius: -8,
                ),
            ],
          ),
          child: Row(
            children: [
              _Logo(isCompact: isCompact),
              if (!isCompact) ...[
                const SizedBox(width: 28),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_navItems.length, (i) {
                      final (label, icon, route) = _navItems[i];
                      final selected = selectedIndex == i;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _NavPill(
                          label: label,
                          icon: icon,
                          selected: selected,
                          onTap: () {
                            onNavigate?.call(i);
                            context.go(route);
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ] else
                const Spacer(),
              _IconAction(
                icon: isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                tooltip: 'تبديل المظهر',
                onTap: () {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateThemeMode(
                        isDark ? ThemeModeOption.light : ThemeModeOption.dark,
                      );
                },
              ),
              const SizedBox(width: 6),
              _IconAction(
                icon: Icons.notifications_none_rounded,
                tooltip: 'الإشعارات',
                badge: true,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'الإشعارات قريباً',
                        style: GoogleFonts.notoKufiArabic(),
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => context.push('/settings'),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.goldGradient,
                    border: Border.all(
                      color: AppTheme.goldSoft.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(color: AppTheme.glowGold, blurRadius: 12),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: AppTheme.bgPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final bool isCompact;
  const _Logo({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: 32,
          width: isCompact ? 32 : null,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _NavPill extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.goldPrimary.withValues(alpha: 0.15)
                : _hovered
                ? AppTheme.goldPrimary.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: widget.selected
                ? Border.all(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.25),
                  )
                : null,
            boxShadow: widget.selected
                ? [BoxShadow(color: AppTheme.glowGold, blurRadius: 16)]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.selected
                    ? AppTheme.goldPrimary
                    : (isDark ? AppTheme.textMuted : AppTheme.lightTextMuted),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  fontWeight: widget.selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: widget.selected
                      ? AppTheme.goldPrimary
                      : (isDark
                            ? AppTheme.textSecondary
                            : AppTheme.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool badge;

  const _IconAction({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.badge = false,
  });

  @override
  State<_IconAction> createState() => _IconActionState();
}

class _IconActionState extends State<_IconAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppTheme.goldPrimary.withValues(alpha: 0.1)
                  : isDark
                  ? AppTheme.bgSurface.withValues(alpha: 0.4)
                  : AppTheme.lightBgCard.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppTheme.borderSubtle
                    : AppTheme.goldPrimary.withValues(alpha: 0.1),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: isDark
                      ? AppTheme.textSecondary
                      : AppTheme.lightTextSecondary,
                ),
                if (widget.badge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.goldPrimary,
                        boxShadow: [
                          BoxShadow(color: AppTheme.glowGold, blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
