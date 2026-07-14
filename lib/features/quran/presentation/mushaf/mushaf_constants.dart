import 'package:flutter/material.dart';

/// Visual tokens for the Madinah-style Mushaf presentation layer.
class MushafColors {
  static const paper = Color(0xFFF8F4EC);
  static const paperDark = Color(0xFF1A1814);
  static const ink = Color(0xFF1C1510);
  static const inkNight = Color(0xFFE8DCC8);
  static const gold = Color(0xFFB8942A);
  static const goldSoft = Color(0xFFD9B96E);
  static const border = Color(0xFFD4C4A8);
  static const borderNight = Color(0xFF3D3528);
  static const frame = Color(0xFFC9B896);
  static const kSelectionGold = Color(0x38D9B96E);
  static const kBookmarkGold = Color(0x1FB8942A);
  static const kHighlightGold = Color(0x14B8942A);
}

class MushafMetrics {
  static const double pageMaxWidth = 600;
  static const double pageHorizontalMargin = 16;
  static const double pageInnerPadding = 20;
  static const double baseVerseFontSize = 28;
  static const double minVerseFontSize = 18;
  static const double verseLineHeight = 1.8;
  static const double baseMarkerSize = 28;
  static const double minMarkerSize = 18;
  static const double toolbarAutoHideSeconds = 4;

  static double responsiveFontSize(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final ratio = (width / 440).clamp(0.65, 1.15);
    return (baseVerseFontSize * ratio).clamp(minVerseFontSize, baseVerseFontSize * 1.15);
  }

  static double responsiveFontSizeRaw(double availableWidth, TextScaler scaler) {
    final ratio = (availableWidth / 440).clamp(0.65, 1.15);
    final base = (baseVerseFontSize * ratio).clamp(minVerseFontSize, baseVerseFontSize * 1.15);
    return scaler.scale(base);
  }

  static double responsiveMarkerSize(double fontSize) {
    return (baseMarkerSize * (fontSize / baseVerseFontSize)).clamp(minMarkerSize, baseMarkerSize * 1.15);
  }

}

/// Primary Quran text face — bundled Noto Naskh (Uthmani-friendly).
const String kMushafFontFamily = 'NotoNaskhArabic';

String mushafArabicDigits(int number) {
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return number
      .toString()
      .split('')
      .map((d) => eastern[int.parse(d)])
      .join();
}

int? juzForSurah(int surahNumber) {
  const starts = {
    1: 1, 2: 1, 3: 3, 4: 4, 5: 6, 6: 7, 7: 8, 8: 9, 9: 10, 10: 11,
    11: 11, 12: 12, 13: 13, 14: 14, 15: 14, 16: 14, 17: 15, 18: 15,
    19: 16, 20: 16, 21: 17, 22: 17, 23: 18, 24: 18, 25: 18, 26: 19,
    27: 19, 28: 20, 29: 20, 30: 21, 31: 21, 32: 21, 33: 21, 34: 22,
    35: 22, 36: 22, 37: 23, 38: 23, 39: 23, 40: 24, 41: 24, 42: 25,
    43: 25, 44: 25, 45: 25, 46: 26, 47: 26, 48: 26, 49: 26, 50: 26,
    51: 26, 52: 27, 53: 27, 54: 27, 55: 27, 56: 27, 57: 27, 58: 28,
    59: 28, 60: 28, 61: 28, 62: 28, 63: 28, 64: 28, 65: 28, 66: 28,
    67: 29, 68: 29, 69: 29, 70: 29, 71: 29, 72: 29, 73: 29, 74: 29,
    75: 29, 76: 29, 77: 29, 78: 30, 79: 30, 80: 30, 81: 30, 82: 30,
    83: 30, 84: 30, 85: 30, 86: 30, 87: 30, 88: 30, 89: 30, 90: 30,
    91: 30, 92: 30, 93: 30, 94: 30, 95: 30, 96: 30, 97: 30, 98: 30,
    99: 30, 100: 30, 101: 30, 102: 30, 103: 30, 104: 30, 105: 30,
    106: 30, 107: 30, 108: 30, 109: 30, 110: 30, 111: 30, 112: 30,
    113: 30, 114: 30,
  };
  return starts[surahNumber];
}
