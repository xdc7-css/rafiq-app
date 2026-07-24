import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Luxury Core Palette ───
  static const Color bgPrimary = Color(0xFF0B1730);
  static const Color bgSecondary = Color(0xFF111A33);
  static const Color bgCard = Color(0xFF16233E);
  static const Color bgSurface = Color(0xFF1B2946);

  // ─── Premium Navy Gradient (Background System) ───
  static const Color navyDeep = Color(0xFF06101D);
  static const Color navyBase = Color(0xFF081728);
  static const Color navyMid = Color(0xFF0D1E36);
  static const Color navyLight = Color(0xFF12284A);

  // ─── Card Depths ───
  static const Color cardDeep = Color(0xFF132341);
  static const Color cardBase = Color(0xFF172C4E);
  static const Color cardLifted = Color(0xFF1B3158);

  // ─── Luxury Accent Gold ───
  static const Color goldWarm = Color(0xFFD9B96E);
  static const Color goldBright = Color(0xFFE5C97F);
  static const Color goldLight = Color(0xFFF0D896);

  // ─── Text Hierarchy ───
  static const Color textElevated = Color(0xFFD4DBE7);
  static const Color textMutedPremium = Color(0xFFAEB8C8);

  // ─── Gold Palette ───
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldSecondary = Color(0xFFC99A1A);
  static const Color goldSoft = goldSecondary; // Alias for soft gold used throughout the app
  static const Color goldDark = Color(0xFFB8860B); // Darker shade of gold
  static const Color navy = bgPrimary; // Alias for primary dark navy background
  static const Color surface = bgSurface; // Alias for default surface color
  static const Color surfaceLight = bgCard; // Alias for lighter surface/card background

  // ─── Text ───
  static const Color textPrimary = Color(0xFFFFFFFF);
  static Color get textMuted => textPrimary.withValues(alpha: 0.72);
  static Color get textDisabled => textPrimary.withValues(alpha: 0.45);

  // ─── Borders ───
  static Color get borderGold => goldPrimary.withValues(alpha: 0.20);
  static Color get borderSubtle => goldPrimary.withValues(alpha: 0.10);

  // ─── Shadows ───
  static List<BoxShadow> get luxuryShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 40,
          offset: const Offset(0, 16),
          spreadRadius: -8,
        ),
      ];

  // ═══════════════════════════════════════════════
  // Design System — 8-Point Grid & Consistent Radii
  // ═══════════════════════════════════════════════

  // ─── Spacing Scale (8pt grid) ───
  static const double sp4 = 4;
  static const double sp8 = 8;
  static const double sp12 = 12;
  static const double sp16 = 16;
  static const double sp20 = 20;
  static const double sp24 = 24;
  static const double sp32 = 32;
  static const double sp40 = 40;
  static const double sp48 = 48;
  static const double sp56 = 56;

  // ─── Outer Page Margins ───
  static const double pageMarginH = 24;
  static const double pageMarginTop = 24;
  static const double pageMarginBottom = 32;

  // ─── Section Spacing ───
  static const double sectionGap = 32;

  // ─── Card System ───
  static const double cardRadius = 28;
  static const double cardPadding = 20;
  static const double cardContentPadding = 16;

  // ─── Button System ───
  static const double buttonHeight = 52;
  static const double buttonRadius = 26;
  static const double buttonMarginH = 16;
  static const double buttonMarginV = 16;

  // ─── Border Radius ───
  static const double radiusLuxury = 28.0;
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusPill = 50.0;

  // ─── Gradients ───
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0B1324), Color(0xFF111A33)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Premium Navy Background Gradient ───
  static const LinearGradient premiumNavyGradient = LinearGradient(
    colors: [navyDeep, navyBase, navyMid, navyLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.3, 0.65, 1.0],
  );

  // ─── Card Decoration ───
  static BoxDecoration glassCard({
    double radius = 30,
    bool isDark = true,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: isDark ? bgCard.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? borderGold,
        width: 1.0,
      ),
      boxShadow: luxuryShadow,
    );
  }

  // ─── Responsive Spacing (context-aware) ───
  static double rPageMarginH(BuildContext context) =>
      MediaQuery.sizeOf(context).width * 0.051; // ~20px on 390
  static double rPageMarginTop(BuildContext context) =>
      MediaQuery.sizeOf(context).height * 0.019; // ~16px on 844
  static double rSectionGap(BuildContext context) =>
      MediaQuery.sizeOf(context).width * 0.072; // ~28px on 390
  static double rCardPadding(BuildContext context) =>
      MediaQuery.sizeOf(context).width * 0.046; // ~18px on 390
  static double rCardRadius(BuildContext context) =>
      MediaQuery.sizeOf(context).width * 0.062; // ~24px on 390

  // ─── Backward-compatible Aliases ───
  static const Color luxuryGold = goldPrimary;
  static const Color warmWhite = textPrimary;
  static const Color midnightNavy = bgPrimary;
  static const Color darkGlassBlue = bgSecondary;
  static Color get textSecondary => textMuted;
  static Color get borderColor => borderGold;
  static Color get glowGold => goldPrimary.withValues(alpha: 0.25);
  static Color get glassDark => bgCard.withValues(alpha: 0.45);
  static Color get glassLight => bgCard.withValues(alpha: 0.20);
  static Color get shadowDark => Colors.black.withValues(alpha: 0.3);
  static Color get shadowGold => goldPrimary.withValues(alpha: 0.15);

  static TextStyle arabicText({
    double size = 22,
    FontWeight weight = FontWeight.normal,
    Color? color,
    double height = 2.0,
  }) {
    return GoogleFonts.notoNaskhArabic(
      fontSize: size,
      fontWeight: weight,
      color: color ?? textPrimary,
      height: height,
    );
  }

  // ─── Themes ───
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      splashFactory: InkRipple.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: goldPrimary,
        brightness: Brightness.dark,
        surface: bgPrimary,
        primary: goldPrimary,
        secondary: goldSecondary,
      ),
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
      scaffoldBackgroundColor: bgPrimary,
    );
  }

  // ─── Gold Divider ───
  static Widget goldDivider({double? width}) {
    return Container(
      width: width ?? 60,
      height: 1,
      decoration: BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
