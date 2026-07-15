/// Widget spacing tokens — consistent spacing scale for all widgets.
///
/// All spacing values follow a 4pt grid system.
/// Android widgets have limited space; every pixel matters.
abstract final class WidgetSpacingTokens {
  // ════════════════════════════════════════════════════════════════════════
  // BASE GRID
  // ════════════════════════════════════════════════════════════════════════

  static const double unit = 4.0;

  static const double x0 = 0.0;
  static const double x1 = 4.0;
  static const double x2 = 8.0;
  static const double x3 = 12.0;
  static const double x4 = 16.0;
  static const double x5 = 20.0;
  static const double x6 = 24.0;
  static const double x7 = 28.0;
  static const double x8 = 32.0;
  static const double x10 = 40.0;
  static const double x12 = 48.0;
  static const double x14 = 56.0;
  static const double x16 = 64.0;

  // ════════════════════════════════════════════════════════════════════════
  // SEMANTIC SPACING
  // ════════════════════════════════════════════════════════════════════════

  /// No spacing.
  static const double none = x0;

  /// Tight spacing — between closely related items.
  static const double xxs = x1;

  /// Extra small — between icon and label.
  static const double xs = x2;

  /// Small — between related elements in a row.
  static const double sm = x3;

  /// Medium — between sections within a card.
  static const double md = x4;

  /// Large — between card sections.
  static const double lg = x6;

  /// Extra large — between cards.
  static const double xl = x8;

  /// Section gap — between major sections.
  static const double xxl = x12;

  // ════════════════════════════════════════════════════════════════════════
  // WIDGET PADDING — Internal widget padding
  // ════════════════════════════════════════════════════════════════════════

  /// Padding for 2x2 widgets (compact).
  static const double widgetPaddingSmall = 8.0;

  /// Padding for 4x2 / 2x3 widgets (standard).
  static const double widgetPaddingMedium = 12.0;

  /// Padding for 4x4 widgets (spacious).
  static const double widgetPaddingLarge = 16.0;

  /// Padding for 4x1 widgets (thin).
  static const double widgetPaddingThin = 8.0;

  // ════════════════════════════════════════════════════════════════════════
  // MARGINS — External spacing between elements
  // ════════════════════════════════════════════════════════════════════════

  /// Margin between prayer rows.
  static const double prayerRowGap = 6.0;

  /// Margin between date chips.
  static const double dateChipGap = 8.0;

  /// Margin between title and content.
  static const double titleContentGap = 8.0;

  /// Margin between sections.
  static const double sectionGap = 12.0;

  /// Margin around progress bars.
  static const double progressMargin = 4.0;
}
