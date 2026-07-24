import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Floating glass dock navigation for mobile with gold active indicator.
class FloatingDockNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const FloatingDockNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'الرئيسية'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'القرآن'),
    (Icons.wb_sunny_outlined, Icons.wb_sunny_rounded, 'الأذكار'),
    (Icons.nights_stay_outlined, Icons.nights_stay_rounded, 'الحديث'),
    (Icons.settings_outlined, Icons.settings_rounded, 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppTheme.bgCard.withValues(alpha: 0.82),
                        AppTheme.bgSurface.withValues(alpha: 0.65),
                      ]
                    : [
                        AppTheme.lightBgCard.withValues(alpha: 0.9),
                        AppTheme.lightBgCard.withValues(alpha: 0.75),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? AppTheme.borderSubtle
                    : AppTheme.goldPrimary.withValues(alpha: 0.12),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppTheme.bgPrimary.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
                if (isDark)
                  BoxShadow(
                    color: AppTheme.glowGold,
                    blurRadius: 40,
                    spreadRadius: -12,
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_items.length, (index) {
                final (outline, filled, label) = _items[index];
                final selected = selectedIndex == index;
                return _DockItem(
                  icon: selected ? filled : outline,
                  label: label,
                  selected: selected,
                  onTap: () => onDestinationSelected(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppTheme.textMuted : AppTheme.lightTextMuted;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.selected)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppTheme.glowGold, blurRadius: 16),
                        ],
                      ),
                    ),
                  Icon(
                    widget.icon,
                    size: 24,
                    color: widget.selected ? AppTheme.goldPrimary : mutedColor,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 10,
                  fontWeight: widget.selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: widget.selected ? AppTheme.goldPrimary : mutedColor,
                ),
                child: Text(widget.label),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(top: 3),
                width: widget.selected ? 4 : 0,
                height: widget.selected ? 4 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.goldPrimary,
                  boxShadow: [
                    BoxShadow(color: AppTheme.glowGold, blurRadius: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
