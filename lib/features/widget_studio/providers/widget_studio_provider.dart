import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../widget_framework/framework.dart';

/// Available widget types for the studio.
enum StudioWidgetType {
  prayerTimes('Prayer Times', 'prayer_times'),
  quran('Quran Kareem', 'quran'),
  tasbih('Tasbih', 'tasbih'),
  dashboard('Dashboard', 'dashboard');

  const StudioWidgetType(this.displayName, this.configType);
  final String displayName;
  final String configType;
}

/// Saved preset for quick access.
@immutable
class WidgetPreset {
  final String id;
  final String name;
  final WidgetConfig config;
  final DateTime createdAt;

  const WidgetPreset({
    required this.id,
    required this.name,
    required this.config,
    required this.createdAt,
  });

  WidgetPreset copyWith({String? name, WidgetConfig? config}) {
    return WidgetPreset(
      id: id,
      name: name ?? this.name,
      config: config ?? this.config,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'config': config.toMap(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory WidgetPreset.fromMap(Map<String, dynamic> map) {
    return WidgetPreset(
      id: map['id'] as String,
      name: map['name'] as String,
      config: WidgetConfig.fromMap(map['config'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

/// The complete state of the Widget Studio.
@immutable
class WidgetStudioState {
  final WidgetConfig config;
  final StudioWidgetType widgetType;
  final WidgetSize widgetSize;
  final bool isDirty;
  final String? activePresetId;
  final List<WidgetPreset> presets;

  const WidgetStudioState({
    required this.config,
    this.widgetType = StudioWidgetType.prayerTimes,
    this.widgetSize = WidgetSize.medium,
    this.isDirty = false,
    this.activePresetId,
    this.presets = const [],
  });

  /// The resolved style for the current config (computed on access).
  WidgetStyle get resolvedStyle => StyleResolver.resolve(config);

  /// The layout constraints for the current size.
  WidgetLayoutConstraints get layoutConstraints =>
      StyleResolver.resolveLayout(widgetSize);

  WidgetStudioState copyWith({
    WidgetConfig? config,
    StudioWidgetType? widgetType,
    WidgetSize? widgetSize,
    bool? isDirty,
    String? activePresetId,
    bool clearActivePreset = false,
    List<WidgetPreset>? presets,
  }) {
    return WidgetStudioState(
      config: config ?? this.config,
      widgetType: widgetType ?? this.widgetType,
      widgetSize: widgetSize ?? this.widgetSize,
      isDirty: isDirty ?? this.isDirty,
      activePresetId:
          clearActivePreset ? null : (activePresetId ?? this.activePresetId),
      presets: presets ?? this.presets,
    );
  }
}

/// Notifier that manages the Widget Studio state.
class WidgetStudioNotifier extends StateNotifier<WidgetStudioState> {
  WidgetStudioNotifier()
      : super(
          WidgetStudioState(
            config: WidgetConfig.defaults('prayer_times'),
          ),
        );

  // ─── Config Updates ────────────────────────────────────────────────

  void updateConfig(WidgetConfig config) {
    state = state.copyWith(config: config, isDirty: true);
  }

  void updateTheme(String themeId) {
    state = state.copyWith(
      config: state.config.copyWith(themeId: themeId),
      isDirty: true,
    );
  }

  void updateBackgroundColor(Color color) {
    state = state.copyWith(
      config: state.config.copyWith(backgroundColor: color.toARGB32()),
      isDirty: true,
    );
  }

  void clearBackgroundColor() {
    state = state.copyWith(
      config: state.config.copyWith(clearBackground: true),
      isDirty: true,
    );
  }

  void updateTextColor(Color color) {
    state = state.copyWith(
      config: state.config.copyWith(textColor: color.toARGB32()),
      isDirty: true,
    );
  }

  void clearTextColor() {
    state = state.copyWith(
      config: state.config.copyWith(clearText: true),
      isDirty: true,
    );
  }

  void updateAccentColor(Color color) {
    state = state.copyWith(
      config: state.config.copyWith(accentColor: color.toARGB32()),
      isDirty: true,
    );
  }

  void clearAccentColor() {
    state = state.copyWith(
      config: state.config.copyWith(clearAccent: true),
      isDirty: true,
    );
  }

  void updateTransparency(double value) {
    state = state.copyWith(
      config: state.config.copyWith(transparency: value),
      isDirty: true,
    );
  }

  void updateBorderRadius(double value) {
    state = state.copyWith(
      config: state.config.copyWith(borderRadius: value),
      isDirty: true,
    );
  }

  void updateFontSize(double value) {
    state = state.copyWith(
      config: state.config.copyWith(fontSize: value),
      isDirty: true,
    );
  }

  void updateGlassEffect(bool enabled) {
    state = state.copyWith(
      config: state.config.copyWith(glassEffect: enabled),
      isDirty: true,
    );
  }

  void updatePatternOverlay(bool enabled) {
    state = state.copyWith(
      config: state.config.copyWith(patternId: enabled ? 'default' : null),
      isDirty: true,
    );
  }

  void updateMaterialYou(bool enabled) {
    state = state.copyWith(
      config: state.config.copyWith(materialYou: enabled),
      isDirty: true,
    );
  }

  void updateTextShadow(bool enabled) {
    state = state.copyWith(
      config: state.config.copyWith(textShadow: enabled),
      isDirty: true,
    );
  }

  void updateLetterSpacing(double value) {
    state = state.copyWith(
      config: state.config.copyWith(letterSpacing: value),
      isDirty: true,
    );
  }

  void updateLineHeight(double value) {
    state = state.copyWith(
      config: state.config.copyWith(lineHeight: value),
      isDirty: true,
    );
  }

  void updateGradientAngle(double value) {
    state = state.copyWith(
      config: state.config.copyWith(gradientAngle: value),
      isDirty: true,
    );
  }

  void updateFontFamily(String? family) {
    state = state.copyWith(
      config: state.config.copyWith(fontFamily: family),
      isDirty: true,
    );
  }

  void updateVerticalAlignment(String alignment) {
    state = state.copyWith(
      config: state.config.copyWith(verticalAlignment: alignment),
      isDirty: true,
    );
  }

  void updateLayoutStyle(String style) {
    state = state.copyWith(
      config: state.config.copyWith(layoutStyle: style),
      isDirty: true,
    );
  }

  // ─── Widget Type & Size ────────────────────────────────────────────

  void setWidgetType(StudioWidgetType type) {
    state = state.copyWith(
      widgetType: type,
      config: state.config.copyWith(widgetType: type.configType),
      isDirty: true,
    );
  }

  void setWidgetSize(WidgetSize size) {
    state = state.copyWith(widgetSize: size, isDirty: true);
  }

  // ─── Presets ───────────────────────────────────────────────────────

  void savePreset(String name) {
    final preset = WidgetPreset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      config: state.config,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      presets: [...state.presets, preset],
      activePresetId: preset.id,
      isDirty: false,
    );
  }

  void loadPreset(String presetId) {
    final preset = state.presets.where((p) => p.id == presetId).firstOrNull;
    if (preset != null) {
      state = state.copyWith(
        config: preset.config,
        activePresetId: preset.id,
        isDirty: false,
      );
    }
  }

  void renamePreset(String presetId, String newName) {
    state = state.copyWith(
      presets: state.presets.map((p) {
        if (p.id == presetId) return p.copyWith(name: newName);
        return p;
      }).toList(),
    );
  }

  void duplicatePreset(String presetId) {
    final original =
        state.presets.where((p) => p.id == presetId).firstOrNull;
    if (original != null) {
      final duplicate = WidgetPreset(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '${original.name} (Copy)',
        config: original.config,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        presets: [...state.presets, duplicate],
      );
    }
  }

  void deletePreset(String presetId) {
    state = state.copyWith(
      presets: state.presets.where((p) => p.id != presetId).toList(),
      clearActivePreset: state.activePresetId == presetId,
    );
  }

  void restoreDefaults() {
    state = state.copyWith(
      config: WidgetConfig.defaults(state.config.widgetType),
      isDirty: true,
      clearActivePreset: true,
    );
  }

  void markClean() {
    state = state.copyWith(isDirty: false);
  }
}

/// Global provider for the Widget Studio.
final widgetStudioProvider =
    StateNotifierProvider<WidgetStudioNotifier, WidgetStudioState>((ref) {
  return WidgetStudioNotifier();
});
