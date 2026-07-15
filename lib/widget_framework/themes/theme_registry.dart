import 'widget_theme.dart';
import 'widget_themes.dart';

/// Central registry of all available widget themes.
///
/// To add a new theme:
/// 1. Create a [WidgetTheme] instance (in [WidgetThemes] or a new file).
/// 2. Register it via [ThemeRegistry.register].
///
/// The registry is the lookup point for theme-by-id resolution.
class ThemeRegistry {
  ThemeRegistry._();

  static final Map<String, WidgetTheme> _themes = {
    WidgetThemes.luxuryGold.id: WidgetThemes.luxuryGold,
    WidgetThemes.midnightBlack.id: WidgetThemes.midnightBlack,
    WidgetThemes.minimalWhite.id: WidgetThemes.minimalWhite,
    WidgetThemes.emerald.id: WidgetThemes.emerald,
    WidgetThemes.modernGlass.id: WidgetThemes.modernGlass,
    WidgetThemes.classicMushaf.id: WidgetThemes.classicMushaf,
  };

  /// All registered theme IDs.
  static List<String> get availableIds => List.unmodifiable(_themes.keys);

  /// All registered themes.
  static List<WidgetTheme> get availableThemes =>
      List.unmodifiable(_themes.values);

  /// All registered themes as (id, name) pairs for UI dropdowns.
  static List<({String id, String name})> get themeOptions =>
      _themes.values.map((t) => (id: t.id, name: t.name)).toList();

  /// Looks up a theme by its unique [id].
  ///
  /// Falls back to [WidgetThemes.luxuryGold] if the id is not found.
  /// This ensures widgets always have a valid theme.
  static WidgetTheme getById(String id) {
    return _themes[id] ?? WidgetThemes.luxuryGold;
  }

  /// Registers a new theme. Overwrites if [id] already exists.
  static void register(WidgetTheme theme) {
    _themes[theme.id] = theme;
  }

  /// Removes a theme by [id]. Cannot remove the default.
  static bool unregister(String id) {
    if (id == WidgetThemes.luxuryGold.id) return false;
    return _themes.remove(id) != null;
  }

  /// Checks if a theme [id] is registered.
  static bool contains(String id) => _themes.containsKey(id);

  /// Returns the default theme.
  static WidgetTheme get defaultTheme => WidgetThemes.luxuryGold;
}
