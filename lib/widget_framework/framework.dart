/// Rafiq Widget Framework — the design system for all home screen widgets.
///
/// ## Architecture Overview
///
/// Every widget in the app follows this pipeline:
///
///   WidgetConfig (user preferences)
///       ↓
///   ThemeRegistry (lookup theme by ID)
///       ↓
///   WidgetTheme (complete visual configuration)
///       ↓
///   WidgetStyle.resolve() (merge theme + config overrides)
///       ↓
///   WidgetStyle (resolved visual properties)
///       ↓
///   Components (render using style)
///
/// ## Quick Start
///
/// ```dart
/// // 1. Load config
/// final config = await ConfigAdapter.load('prayer_times');
///
/// // 2. Resolve style
/// final style = StyleResolver.resolve(config);
/// final layout = StyleResolver.resolveLayout(WidgetSize.medium);
///
/// // 3. Render
/// WidgetFrameBuilder.buildClipped(
///   style: style,
///   layout: layout,
///   child: MyPrayerWidget(style: style),
/// );
/// ```
///
/// ## Adding a New Theme
///
/// ```dart
/// // 1. Add to widget_themes.dart or create a new file
/// static const WidgetTheme myTheme = WidgetTheme(
///   id: 'my_theme',
///   name: 'My Theme',
///   colors: WidgetColorScheme(...),
/// );
///
/// // 2. Register it
/// ThemeRegistry.register(WidgetThemes.myTheme);
/// ```
///
/// No widget code changes needed.
library;

// Design Tokens
export 'tokens/tokens.dart';

// Theme Engine
export 'themes/widget_theme.dart';
export 'themes/widget_color_scheme.dart';
export 'themes/widget_themes.dart';
export 'themes/theme_registry.dart';

// Style Engine
export 'styles/widget_style.dart';

// Configuration
export 'config/widget_config.dart';
export 'config/config_adapter.dart';

// Components
export 'components/components.dart';

// Layout
export 'layout/widget_layout.dart';

// Preview
export 'preview/widget_frame_builder.dart';
export 'preview/style_resolver.dart';
