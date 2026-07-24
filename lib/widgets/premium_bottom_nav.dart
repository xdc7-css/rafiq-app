import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Modern, high-performance, Apple/Material 3 quality Bottom Navigation Bar.
///
/// Features:
/// - Instant navigation on single tap (zero delay)
/// - Soft radial gold glow centered behind the active icon
/// - Micro icon scale (1.08x) & font weight animation (w700 active vs w500 inactive)
/// - Clean translucent glass dock with subtle gold rim
class PremiumBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const PremiumBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const _items = [
    _NavEntry(Icons.home_outlined, Icons.home_rounded, 'الرئيسية', 'Home'),
    _NavEntry(Icons.menu_book_outlined, Icons.menu_book_rounded, 'القرآن', 'Quran'),
    _NavEntry(Icons.mosque_outlined, Icons.mosque_rounded, 'الزيارات', 'Ziyarat'),
    _NavEntry(Icons.nights_stay_outlined, Icons.nights_stay_rounded, 'الحديث', 'Hadith'),
    _NavEntry(Icons.settings_outlined, Icons.settings_rounded, 'الإعدادات', 'Settings'),
  ];

  static const Duration _animDuration = Duration(milliseconds: 200);
  static const Curve _animCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final screenW = MediaQuery.sizeOf(context).width;

    final hMargin = screenW < 360 ? 12.0 : screenW < 420 ? 14.0 : 16.0;
    final dockH = screenW < 360 ? 68.0 : screenW < 420 ? 74.0 : 78.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        hMargin,
        0,
        hMargin,
        bottomSafe > 0 ? bottomSafe + 8 : 12,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: RepaintBoundary(
            child: _ModernGlassDock(
              height: dockH,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── Top Caustic Edge Highlight ──
                  const Positioned(
                    top: 0,
                    left: 28,
                    right: 28,
                    height: 0.6,
                    child: _CausticEdge(),
                  ),

                  // ── Navigation Items ──
                  Row(
                    children: List.generate(
                      _items.length,
                      (index) {
                        final isSelected = index == selectedIndex;
                        return Expanded(
                          child: _ModernNavTile(
                            entry: _items[index],
                            isSelected: isSelected,
                            iconSize: screenW < 360 ? 22.0 : 24.0,
                            labelSize: screenW < 360 ? 9.5 : 10.5,
                            duration: _animDuration,
                            curve: _animCurve,
                            onTap: () {
                              if (!isSelected) {
                                HapticFeedback.selectionClick();
                                onDestinationSelected(index);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  MODERN GLASS DOCK — Clean translucent dark glass shell
// ═══════════════════════════════════════════════════════════════════

class _ModernGlassDock extends StatelessWidget {
  final double height;
  final Widget child;

  const _ModernGlassDock({required this.height, required this.child});

  static const _radius = 30.0;
  static final _blurFilter = ui.ImageFilter.blur(sigmaX: 28, sigmaY: 28);
  static final _clipR = BorderRadius.circular(_radius);

  static final _baseTint = LinearGradient(
    colors: [
      AppTheme.bgPrimary.withValues(alpha: 0.88),
      AppTheme.bgCard.withValues(alpha: 0.82),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final _shadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.45),
      blurRadius: 36,
      offset: const Offset(0, 14),
      spreadRadius: -6,
    ),
    BoxShadow(
      color: AppTheme.goldPrimary.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _clipR,
      child: BackdropFilter(
        filter: _blurFilter,
        child: SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _baseTint,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.16),
                width: 1.0,
              ),
              boxShadow: _shadows,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: height * 0.35,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(_radius),
                    ),
                  ),
                ),
                Positioned.fill(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CAUSTIC EDGE — Subtle top gold highlight
// ═══════════════════════════════════════════════════════════════════

class _CausticEdge extends StatelessWidget {
  const _CausticEdge();

  static final _deco = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 0.08),
        AppTheme.goldPrimary.withValues(alpha: 0.25),
        Colors.white.withValues(alpha: 0.08),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.15, 0.50, 0.85, 1.0],
    ),
    borderRadius: BorderRadius.circular(0.5),
  );

  @override
  Widget build(BuildContext context) => DecoratedBox(decoration: _deco);
}

// ═══════════════════════════════════════════════════════════════════
//  MODERN NAV TILE — Fast, minimal active glow tile
// ═══════════════════════════════════════════════════════════════════

class _ModernNavTile extends StatelessWidget {
  final _NavEntry entry;
  final bool isSelected;
  final double iconSize;
  final double labelSize;
  final Duration duration;
  final Curve curve;
  final VoidCallback onTap;

  const _ModernNavTile({
    required this.entry,
    required this.isSelected,
    required this.iconSize,
    required this.labelSize,
    required this.duration,
    required this.curve,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.goldPrimary;
    final inactiveColor = AppTheme.textMuted.withValues(alpha: 0.55);
    final targetColor = isSelected ? activeColor : inactiveColor;

    return Semantics(
      label: '${entry.labelAr} ${entry.labelEn}',
      selected: isSelected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Active Icon Container with Soft Radial Glow ──
              SizedBox(
                width: iconSize + 16,
                height: iconSize + 12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft radial glow centered behind active icon
                    AnimatedOpacity(
                      opacity: isSelected ? 0.22 : 0.0,
                      duration: duration,
                      curve: curve,
                      child: Container(
                        width: iconSize + 6,
                        height: iconSize + 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                          boxShadow: [
                            BoxShadow(
                              color: activeColor,
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Icon scale (1.08x) + filled/outline transition
                    AnimatedScale(
                      scale: isSelected ? 1.08 : 1.0,
                      duration: duration,
                      curve: curve,
                      child: AnimatedCrossFade(
                        firstChild: Icon(
                          entry.outlineIcon,
                          size: iconSize,
                          color: inactiveColor,
                        ),
                        secondChild: Icon(
                          entry.filledIcon,
                          size: iconSize,
                          color: activeColor,
                        ),
                        crossFadeState: isSelected
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: duration,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2),

              // ── Label: typography weight & color animation ──
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: curve,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: labelSize,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: targetColor,
                  letterSpacing: isSelected ? 0.2 : 0.0,
                ),
                child: Text(
                  entry.labelAr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  DATA ENTRY MODEL
// ═══════════════════════════════════════════════════════════════════

class _NavEntry {
  final IconData outlineIcon;
  final IconData filledIcon;
  final String labelAr;
  final String labelEn;
  const _NavEntry(this.outlineIcon, this.filledIcon, this.labelAr, this.labelEn);
}
