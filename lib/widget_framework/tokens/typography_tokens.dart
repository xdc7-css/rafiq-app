import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget typography tokens — font sizes, weights, styles, and families.
abstract final class WidgetTypographyTokens {
  // ════════════════════════════════════════════════════════════════════════
  // FONT FAMILIES
  // ════════════════════════════════════════════════════════════════════════

  static TextStyle get fontPrimary => GoogleFonts.cairo();
  static TextStyle get fontArabic => GoogleFonts.notoNaskhArabic();
  static TextStyle get fontDecorative =>
      const TextStyle(fontFamily: 'DecoTypeThuluth');
  static TextStyle get fontMono =>
      GoogleFonts.cairo(fontWeight: FontWeight.w600);

  // ════════════════════════════════════════════════════════════════════════
  // FONT SIZES — 8pt scale
  // ════════════════════════════════════════════════════════════════════════

  static const double sizeMicro = 8.0;
  static const double sizeCaption = 10.0;
  static const double sizeSmall = 12.0;
  static const double sizeBody = 14.0;
  static const double sizeMedium = 16.0;
  static const double sizeLarge = 18.0;
  static const double sizeTitle = 20.0;
  static const double sizeHeadline = 24.0;
  static const double sizeDisplay = 32.0;
  static const double sizeHero = 48.0;
  static const double sizeGiant = 64.0;

  // ════════════════════════════════════════════════════════════════════════
  // FONT WEIGHTS
  // ════════════════════════════════════════════════════════════════════════

  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;

  // ════════════════════════════════════════════════════════════════════════
  // LINE HEIGHTS
  // ════════════════════════════════════════════════════════════════════════

  static const double heightTight = 1.1;
  static const double heightCompact = 1.2;
  static const double heightNormal = 1.4;
  static const double heightRelaxed = 1.6;
  static const double heightLoose = 1.8;

  // ════════════════════════════════════════════════════════════════════════
  // LETTER SPACING
  // ════════════════════════════════════════════════════════════════════════

  static const double trackingTight = -0.5;
  static const double trackingNormal = 0.0;
  static const double trackingWide = 0.5;
  static const double trackingExtraWide = 1.0;

  // ════════════════════════════════════════════════════════════════════════
  // PRE-BUILT STYLES
  // ════════════════════════════════════════════════════════════════════════

  static TextStyle get title => fontPrimary.copyWith(
        fontSize: sizeTitle,
        fontWeight: weightBold,
        color: Colors.white,
        height: heightCompact,
      );

  static TextStyle get subtitle => fontPrimary.copyWith(
        fontSize: sizeMedium,
        fontWeight: weightMedium,
        color: const Color(0xFFD4DBE7),
        height: heightNormal,
      );

  static TextStyle get body => fontPrimary.copyWith(
        fontSize: sizeBody,
        fontWeight: weightRegular,
        color: const Color(0xFFD4DBE7),
        height: heightNormal,
      );

  static TextStyle get caption => fontPrimary.copyWith(
        fontSize: sizeSmall,
        fontWeight: weightRegular,
        color: const Color(0xFFAEB8C8),
        height: heightNormal,
      );

  static TextStyle get goldHeading => fontPrimary.copyWith(
        fontSize: sizeLarge,
        fontWeight: weightBold,
        color: const Color(0xFFD4AF37),
        height: heightCompact,
      );

  static TextStyle get prayerTime => fontPrimary.copyWith(
        fontSize: sizeBody,
        fontWeight: weightSemiBold,
        color: Colors.white,
        height: heightCompact,
      );

  static TextStyle get largeNumber => fontMono.copyWith(
        fontSize: sizeHero,
        fontWeight: weightBold,
        color: Colors.white,
        height: heightTight,
      );

  static TextStyle get countdown => fontPrimary.copyWith(
        fontSize: sizeSmall,
        fontWeight: weightMedium,
        color: const Color(0xFFC9A84C),
        height: heightNormal,
      );

  static TextStyle get arabicVerse => fontArabic.copyWith(
        fontSize: sizeBody,
        fontWeight: weightRegular,
        color: Colors.white,
        height: heightRelaxed,
      );

  static TextStyle get dateText => fontPrimary.copyWith(
        fontSize: sizeSmall,
        fontWeight: weightMedium,
        color: const Color(0xFFAEB8C8),
        height: heightNormal,
      );

  static TextStyle get badge => fontPrimary.copyWith(
        fontSize: sizeCaption,
        fontWeight: weightBold,
        color: Colors.white,
        height: heightTight,
      );

  static TextStyle get progressPercent => fontMono.copyWith(
        fontSize: sizeSmall,
        fontWeight: weightSemiBold,
        color: const Color(0xFFD4AF37),
        height: heightNormal,
      );

  // ════════════════════════════════════════════════════════════════════════
  // SCALING — Apply font scale factor to any TextStyle
  // ════════════════════════════════════════════════════════════════════════

  static TextStyle scale(TextStyle style, double factor) {
    return style.copyWith(fontSize: (style.fontSize ?? sizeBody) * factor);
  }
}
