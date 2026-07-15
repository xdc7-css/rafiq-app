import 'package:home_widget/home_widget.dart';
import 'package:flutter/foundation.dart';
import 'widget_config.dart';

/// Bridges [WidgetConfig] to/from SharedPreferences via the home_widget
/// package.
///
/// Each widget type stores its config under a unique key:
///   `widget_config_{widgetType}`
///
/// This keeps configs independent — changing prayer config doesn't
/// affect quran config.
///
/// # Caching
/// An in-memory cache avoids repeated SharedPreferences reads within
/// a session. The cache is invalidated on [save] and [remove].
class ConfigAdapter {
  ConfigAdapter._();

  static const String _prefix = 'widget_config_';

  /// In-memory cache: widgetType → WidgetConfig.
  static final Map<String, WidgetConfig> _cache = {};

  /// SharedPreferences key for a widget type's config.
  static String _configKey(String widgetType) => '$_prefix$widgetType';

  /// Saves a [WidgetConfig] to SharedPreferences and updates the cache.
  static Future<void> save(WidgetConfig config) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final key = _configKey(config.widgetType);
      final json = config.toJson();
      await HomeWidget.saveWidgetData(key, json);
      _cache[config.widgetType] = config;
    }
  }

  /// Loads a [WidgetConfig] from SharedPreferences.
  ///
  /// Returns cached value if available, otherwise reads from SharedPreferences.
  /// Returns [WidgetConfig.defaults(widgetType)] if no config is stored.
  static Future<WidgetConfig> load(String widgetType) async {
    // Return cached value if available
    if (_cache.containsKey(widgetType)) {
      return _cache[widgetType]!;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final key = _configKey(widgetType);
      final json = await HomeWidget.getWidgetData<String>(key);
      if (json != null && json.isNotEmpty) {
        try {
          final config = WidgetConfig.fromJson(json);
          _cache[widgetType] = config;
          return config;
        } catch (e) {
          debugPrint('[ConfigAdapter] Failed to parse config for $widgetType: $e');
        }
      }
    }
    final defaults = WidgetConfig.defaults(widgetType);
    _cache[widgetType] = defaults;
    return defaults;
  }

  /// Removes a stored config, reverting to defaults and clearing cache.
  static Future<void> remove(String widgetType) async {
    _cache.remove(widgetType);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final key = _configKey(widgetType);
      await HomeWidget.saveWidgetData(key, '');
    }
  }

  /// Clears the in-memory cache for a widget type.
  static void invalidate(String widgetType) {
    _cache.remove(widgetType);
  }

  /// Clears the entire in-memory cache.
  static void invalidateAll() {
    _cache.clear();
  }

  /// Saves a single override field for a widget type.
  static Future<void> saveField(
    String widgetType,
    String field,
    dynamic value,
  ) async {
    final config = await load(widgetType);
    final updatedMap = config.toMap();
    updatedMap[field] = value;
    final updated = WidgetConfig.fromMap(updatedMap);
    await save(updated);
  }

  /// Batch-saves multiple fields at once.
  static Future<void> saveFields(
    String widgetType,
    Map<String, dynamic> fields,
  ) async {
    final config = await load(widgetType);
    final updatedMap = config.toMap();
    updatedMap.addAll(fields);
    final updated = WidgetConfig.fromMap(updatedMap);
    await save(updated);
  }
}
