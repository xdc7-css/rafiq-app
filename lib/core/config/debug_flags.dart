class DebugFlags {
  /// Temporarily disable non-critical startup API requests
  /// (Shia books, remote book sync, optional content) so the app
  /// and Quran screen load immediately during debugging.
  static const bool disableNonCriticalStartupApis = true;
}
