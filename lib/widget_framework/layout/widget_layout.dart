import 'package:flutter/material.dart';
import '../tokens/spacing_tokens.dart';

/// Widget size presets — maps Android widget grid sizes to
/// logical dimensions for Flutter preview rendering.
///
/// Android uses a cell-based grid:
///   - 2x2 = 2 cells wide, 2 cells tall (~180dp x 180dp)
///   - 4x2 = 4 cells wide, 2 cells tall (~360dp x 180dp)
///   - 2x3 = 2 cells wide, 3 cells tall (~180dp x 270dp)
///   - 4x4 = 4 cells wide, 4 cells tall (~360dp x 360dp)
///   - 4x1 = 4 cells wide, 1 cell tall (~360dp x 90dp)
///
/// These dimensions are approximations; actual size depends on
/// launcher and device density.
enum WidgetSize {
  /// 2 cells wide, 2 cells tall — compact widgets (Tasbih).
  small(2, 2, 170, 170),

  /// 4 cells wide, 2 cells tall — standard widgets (Prayer 4x2).
  medium(4, 2, 340, 170),

  /// 2 cells wide, 3 cells tall — vertical widgets (Quran 2x3).
  tall(2, 3, 170, 260),

  /// 4 cells wide, 4 cells tall — large widgets (Dashboard).
  large(4, 4, 340, 340),

  /// 4 cells wide, 1 cell tall — thin widgets (countdown strip).
  thin(4, 1, 340, 80);

  final int cellsW;
  final int cellsH;
  final double previewWidth;
  final double previewHeight;

  const WidgetSize(
    this.cellsW,
    this.cellsH,
    this.previewWidth,
    this.previewHeight,
  );

  /// Aspect ratio for this widget size.
  double get aspectRatio => previewWidth / previewHeight;

  /// Whether this widget is wide (>= 4 cells).
  bool get isWide => cellsW >= 4;

  /// Whether this widget is tall (>= 3 cells).
  bool get isTall => cellsH >= 3;

  /// Whether this widget is compact (2x2).
  bool get isCompact => cellsW == 2 && cellsH == 2;

  /// Suggested padding for this size.
  double get suggestedPadding {
    if (isCompact) return WidgetSpacingTokens.widgetPaddingSmall;
    if (isTall) return WidgetSpacingTokens.widgetPaddingMedium;
    return WidgetSpacingTokens.widgetPaddingLarge;
  }

  /// Suggested font scale for this size.
  double get suggestedFontScale {
    if (isCompact) return 0.85;
    if (isTall) return 0.95;
    return 1.0;
  }
}

/// Layout constraints for a widget preview.
class WidgetLayoutConstraints {
  final WidgetSize size;
  final double? customWidth;
  final double? customHeight;
  final bool rtl;
  final bool landscape;

  const WidgetLayoutConstraints({
    required this.size,
    this.customWidth,
    this.customHeight,
    this.rtl = false,
    this.landscape = false,
  });

  double get width => customWidth ?? size.previewWidth;
  double get height => customHeight ?? size.previewHeight;

  /// Creates a responsive layout that adapts to available space.
  WidgetLayoutConstraints responsive(BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;
    final scale = [
      maxWidth / size.previewWidth,
      maxHeight / size.previewHeight,
    ].reduce((a, b) => a < b ? a : b);

    return WidgetLayoutConstraints(
      size: size,
      customWidth: size.previewWidth * scale,
      customHeight: size.previewHeight * scale,
      rtl: rtl,
      landscape: landscape,
    );
  }
}
