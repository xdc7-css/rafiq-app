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
    (Icons.mosque_outlined, Icons.mosque_rounded, 'الزيارات'),
    (Icons.nights_stay_outlined, Icons.nights_stay_rounded, 'الحديث'),
    (Icons.settings_outlined, Icons.settings_rounded, 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomSafety = MediaQuery.paddingOf(context).bottom;
    final w = MediaQuery.sizeOf(context).width;
    final dockH = w < 360 ? 62.0 : w < 420 ? 68.0 : 72.0;
    final radius = w < 360 ? 24.0 : 28.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, bottomSafety > 0 ? bottomSafety + 8 : 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: dockH,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.bgCard.withValues(alpha: 0.82),
                  AppTheme.bgSurface.withValues(alpha: 0.65),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.bgPrimary.withValues(alpha: 0.5),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
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

class _DockItemState extends State<_DockItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final mutedColor = AppTheme.textMuted;
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final hPad = w < 360 ? 6.0 : 10.0;
    final iconSz = w < 360 ? 20.0 : 22.0;
    final labelSz = w < 360 ? 8.0 : 9.0;
    return MediaQuery(
      data: media.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GestureDetector(
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
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 2),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with glow indicator embedded as shadow — no extra height.
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (widget.selected)
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.glowGold,
                              blurRadius: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  Icon(
                    widget.icon,
                    size: iconSz,
                    color: widget.selected ? AppTheme.goldPrimary : mutedColor,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.notoKufiArabic(
                  fontSize: labelSz,
                  fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.selected ? AppTheme.goldPrimary : mutedColor,
                ),
                child: Text(widget.label, maxLines: 1),
              ),
              // Dot: uses SizedBox with fixed 5px height always, width animates to 0 when hidden.
              SizedBox(
                height: 5,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: widget.selected ? 4 : 0,
                    height: widget.selected ? 4 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.goldPrimary,
                      boxShadow: widget.selected
                          ? [BoxShadow(color: AppTheme.glowGold, blurRadius: 5)]
                          : null,
                    ),
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
