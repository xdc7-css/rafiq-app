import 'package:flutter/foundation.dart';
import 'kfqc_datasource.dart';
import 'cache/quran_cache_data_source.dart';

class KfqcValidator {
  KfqcValidator._();

  static Future<void> runReport() async {
    if (!kDebugMode) return;
    debugPrint('\n══════════════════════════════════════════════════════════════');
    debugPrint('  KFQC ASSET VALIDATION REPORT');
    debugPrint('══════════════════════════════════════════════════════════════\n');

    final stopwatch = Stopwatch()..start();

    final svgResult  = await _validateSvgFiles();
    final jsonResult = await _validateJsonFiles();
    final surahOk    = await _validateSurahJson();
    final markersOk  = await _validateMarkersJson();

    stopwatch.stop();
    _printSummary(svgResult, jsonResult, surahOk, markersOk, stopwatch.elapsed);
  }

  static Future<_FileCheckResult> _validateSvgFiles() async {
    debugPrint('[SVG] Checking pages 001–604 (cross-platform cache)...');
    final missing = <int>[];
    var found = 0;

    final cache = createQuranCacheDataSource();
    await cache.initialize();

    for (int page = 1; page <= 604; page++) {
      try {
        final exists = await cache.pageExists(page);
        if (exists) {
          final valid = await cache.validatePage(page);
          if (valid) {
            found++;
          } else {
            missing.add(page);
            debugPrint('  [SVG] INVALID page $page — deleted during validation');
          }
        } else {
          missing.add(page);
          debugPrint('  [SVG] MISSING page $page');
        }
      } catch (e) {
        missing.add(page);
        debugPrint('  [SVG] ERROR page $page — error: $e');
      }
    }

    debugPrint('[SVG] Done. Found: $found / 604  Missing: ${missing.length}\n');
    return _FileCheckResult(found: found, total: 604, missing: missing);
  }

  static Future<_FileCheckResult> _validateJsonFiles() async {
    debugPrint('[JSON] Checking pages 001–604...');
    final missing = <int>[];
    final failed  = <int>[];
    var found = 0;

    for (int page = 1; page <= 604; page++) {
      final path = kfqcJsonPath(page);
      try {
        final data = await KfqcDatasource.instance.loadPageData(page);
        if (data == null) {
          failed.add(page);
          debugPrint('  [JSON] PARSE FAILED page $page — path: $path');
        } else {
          found++;
        }
      } catch (e, st) {
        missing.add(page);
        debugPrint(
          '  [JSON] MISSING page $page\n'
          '    path : $path\n'
          '    error: $e\n'
          '    trace: $st',
        );
      }
    }

    debugPrint('[JSON] Done. Found+Parsed: $found / 604  Missing: ${missing.length}  ParseFailed: ${failed.length}\n');
    return _FileCheckResult(
      found: found,
      total: 604,
      missing: [...missing, ...failed],
    );
  }

  static Future<bool> _validateSurahJson() async {
    debugPrint('[SURAH] Checking surah.json...');
    try {
      final entries = await KfqcDatasource.instance.loadSurahIndex();
      final ok = entries.length == 114;
      debugPrint('[SURAH] ${ok ? "OK" : "FAILED"} surah.json: ${entries.length}/114 surahs\n');
      return ok;
    } catch (e, st) {
      debugPrint('[SURAH] FAILED surah.json\n  $e\n$st\n');
      return false;
    }
  }

  static Future<bool> _validateMarkersJson() async {
    debugPrint('[MARKERS] Checking markers.json...');
    try {
      final markers = await KfqcDatasource.instance.loadMarkers();
      final ok = markers.isNotEmpty;
      debugPrint('[MARKERS] ${ok ? "OK" : "FAILED"} markers.json: ${markers.length} entries\n');
      return ok;
    } catch (e, st) {
      debugPrint('[MARKERS] FAILED markers.json\n  $e\n$st\n');
      return false;
    }
  }

  static void _printSummary(
    _FileCheckResult svg,
    _FileCheckResult json,
    bool surahOk,
    bool markersOk,
    Duration elapsed,
  ) {
    debugPrint('══════════════════════════════════════════════════════════════');
    debugPrint('  KFQC VALIDATION SUMMARY');
    debugPrint('══════════════════════════════════════════════════════════════');
    debugPrint('  SVG  files found  : ${svg.found} / ${svg.total}');
    debugPrint('  SVG  files missing: ${svg.missing.length}${svg.missing.isNotEmpty ? " → pages: ${svg.missing.join(", ")}" : ""}');
    debugPrint('  JSON files found  : ${json.found} / ${json.total}');
    debugPrint('  JSON files missing: ${json.missing.length}${json.missing.isNotEmpty ? " → pages: ${json.missing.join(", ")}" : ""}');
    debugPrint('  surah.json        : ${surahOk ? "OK" : "FAILED"}');
    debugPrint('  markers.json      : ${markersOk ? "OK" : "FAILED"}');
    debugPrint('  Elapsed           : ${elapsed.inMilliseconds} ms');
    debugPrint('══════════════════════════════════════════════════════════════\n');

    final allOk = svg.missing.isEmpty &&
        json.missing.isEmpty &&
        surahOk &&
        markersOk;

    if (allOk) {
      debugPrint('  ALL KFQC ASSETS VALID - Mushaf system ready.\n');
    } else {
      debugPrint('  SOME ASSETS FAILED - check above for details.\n');
    }
  }
}

class _FileCheckResult {
  final int found;
  final int total;
  final List<int> missing;
  const _FileCheckResult({
    required this.found,
    required this.total,
    required this.missing,
  });
}
