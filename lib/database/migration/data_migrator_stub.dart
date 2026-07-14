import 'package:flutter/foundation.dart';

class DataMigrator {
  static Future<void> migrateIfNeeded() async {
    debugPrint('[DataMigrator] Skipped on Web (no-op)');
  }
}
