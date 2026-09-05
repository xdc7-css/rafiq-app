import 'package:flutter/foundation.dart';

class DebugFlags {
  /// Disable non-critical startup API requests during local development.
  /// Defaults to kDebugMode so release builds perform standard remote sync.
  static const bool disableNonCriticalStartupApis = bool.fromEnvironment(
    'DISABLE_NON_CRITICAL_APIS',
    defaultValue: kDebugMode,
  );
}
