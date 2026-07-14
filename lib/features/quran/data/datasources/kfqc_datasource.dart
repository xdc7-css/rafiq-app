// ──────────────────────────────────────────────────────────────────────────────
// KFQC Datasource
// Lazy-loading, in-memory cached access to the KFQC Hafs Mushaf assets.
//
// Asset roots:
//   SVG  : assets/quran/quran-svg-main/mushafs/hafs/kfqc/svg/NNN.svg
//   JSON : assets/quran/quran-svg-main/mushafs/hafs/kfqc/json/NNN.json
//   Index: assets/quran/quran-svg-main/mushafs/hafs/kfqc/json/surah.json
//   Marks: assets/quran/quran-svg-main/mushafs/hafs/kfqc/json/markers.json
// ──────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/kfqc_models.dart';

/// Asset base paths for the KFQC dataset.
const String kfqcSvgBase  = 'assets/quran-svg/svg';
const String kfqcJsonBase = 'assets/quran-svg/json';

/// Returns the canonical SVG asset path for [pageNumber] (1–604).
///
/// Always uses the plain `NNN.svg` form; surah-boundary variants
/// (e.g. `106-surah4.svg`) are intentionally excluded.
String kfqcSvgPath(int pageNumber) {
  final padded = pageNumber.toString().padLeft(3, '0');
  return '$kfqcSvgBase/$padded.svg';
}

/// Returns the JSON asset path for [pageNumber] (1–604).
String kfqcJsonPath(int pageNumber) {
  final padded = pageNumber.toString().padLeft(3, '0');
  return '$kfqcJsonBase/$padded.json';
}

// ─────────────────────────────────────────────────────────────────────────────

/// Singleton datasource for the KFQC Mushaf assets.
///
/// All data is loaded on demand and cached in memory for the lifetime of the
/// application. Call [reset] to clear caches (e.g. during testing).
class KfqcDatasource {
  KfqcDatasource._();
  static final KfqcDatasource instance = KfqcDatasource._();

  // ── Per-page JSON cache ───────────────────────────────────────────────────
  final Map<int, KfqcPageData> _pageCache = {};

  // ── surah.json cache ──────────────────────────────────────────────────────
  List<KfqcSurahEntry>? _surahIndex;

  // ── markers.json cache ────────────────────────────────────────────────────
  List<KfqcVerseMarker>? _markers;

  // ── In-flight futures (prevent duplicate concurrent loads) ────────────────
  final Map<int, Future<KfqcPageData?>> _pageLoading = {};
  Future<List<KfqcSurahEntry>>? _surahLoading;
  Future<List<KfqcVerseMarker>>? _markersLoading;

  // ───────────────────────────────────────────────────────────────────────────
  // Public API
  // ───────────────────────────────────────────────────────────────────────────

  /// Loads and caches the [KfqcPageData] for [pageNumber] (1–604).
  ///
  /// Returns `null` if the asset is missing or cannot be parsed.
  /// Errors are printed via [debugPrint]; they are never silently swallowed.
  Future<KfqcPageData?> loadPageData(int pageNumber) async {
    if (_pageCache.containsKey(pageNumber)) return _pageCache[pageNumber];
    return _pageLoading.putIfAbsent(pageNumber, () => _fetchPageData(pageNumber));
  }

  Future<KfqcPageData?> _fetchPageData(int pageNumber) async {
    final path = kfqcJsonPath(pageNumber);
    try {
      final raw = await rootBundle.loadString(path);
      final decoded = json.decode(raw);
      if (decoded is! List) {
        debugPrint('[KfqcDatasource] Page $pageNumber JSON is not a list. Path: $path');
        return null;
      }
      final ayahs = <KfqcAyahArea>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          try {
            ayahs.add(KfqcAyahArea.fromJson(item));
          } catch (e, st) {
            debugPrint('[KfqcDatasource] Page $pageNumber ayah parse error: $e\n$st');
          }
        }
      }
      final data = KfqcPageData(pageNumber: pageNumber, ayahs: ayahs);
      _pageCache[pageNumber] = data;
      _pageLoading.remove(pageNumber);
      debugPrint('[KfqcDatasource] ✓ Page $pageNumber loaded: ${ayahs.length} ayahs');
      return data;
    } catch (e, st) {
      debugPrint(
        '[KfqcDatasource] ✗ Page $pageNumber JSON load FAILED\n'
        '  Path     : $path\n'
        '  Exception: $e\n'
        '  Trace    :\n$st',
      );
      _pageLoading.remove(pageNumber);
      return null;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────

  /// Loads and caches all 114 [KfqcSurahEntry] objects from `surah.json`.
  ///
  /// Returns an empty list if the asset is missing or cannot be parsed.
  Future<List<KfqcSurahEntry>> loadSurahIndex() async {
    if (_surahIndex != null) return _surahIndex!;
    return _surahLoading ??= _fetchSurahIndex();
  }

  Future<List<KfqcSurahEntry>> _fetchSurahIndex() async {
    const path = '$kfqcJsonBase/surah.json';
    try {
      final raw = await rootBundle.loadString(path);
      final decoded = json.decode(raw);
      if (decoded is! List) {
        debugPrint('[KfqcDatasource] surah.json is not a list. Path: $path');
        _surahIndex = [];
        return [];
      }
      final entries = decoded
          .whereType<Map<String, dynamic>>()
          .map(KfqcSurahEntry.fromJson)
          .toList()
        ..sort((a, b) => a.number.compareTo(b.number));
      _surahIndex = entries;
      _surahLoading = null;
      debugPrint('[KfqcDatasource] ✓ surah.json loaded: ${entries.length} surahs');
      return entries;
    } catch (e, st) {
      debugPrint(
        '[KfqcDatasource] ✗ surah.json load FAILED\n'
        '  Path     : $path\n'
        '  Exception: $e\n'
        '  Trace    :\n$st',
      );
      _surahIndex = [];
      _surahLoading = null;
      return [];
    }
  }

  // ───────────────────────────────────────────────────────────────────────────

  /// Loads and caches all [KfqcVerseMarker] objects from `markers.json`.
  ///
  /// Returns an empty list if the asset is missing or cannot be parsed.
  Future<List<KfqcVerseMarker>> loadMarkers() async {
    if (_markers != null) return _markers!;
    return _markersLoading ??= _fetchMarkers();
  }

  Future<List<KfqcVerseMarker>> _fetchMarkers() async {
    const path = '$kfqcJsonBase/markers.json';
    try {
      final raw = await rootBundle.loadString(path);
      final decoded = json.decode(raw);
      if (decoded is! List) {
        debugPrint('[KfqcDatasource] markers.json is not a list. Path: $path');
        _markers = [];
        return [];
      }
      final markers = decoded
          .whereType<Map<String, dynamic>>()
          .map(KfqcVerseMarker.fromJson)
          .toList();
      _markers = markers;
      _markersLoading = null;
      debugPrint('[KfqcDatasource] ✓ markers.json loaded: ${markers.length} markers');
      return markers;
    } catch (e, st) {
      debugPrint(
        '[KfqcDatasource] ✗ markers.json load FAILED\n'
        '  Path     : $path\n'
        '  Exception: $e\n'
        '  Trace    :\n$st',
      );
      _markers = [];
      _markersLoading = null;
      return [];
    }
  }

  // ───────────────────────────────────────────────────────────────────────────

  /// Returns markers for a specific page, filtering from the loaded cache.
  ///
  /// Loads [markers.json] on first call.
  Future<List<KfqcVerseMarker>> getMarkersForPage(int pageNumber) async {
    final all = await loadMarkers();
    return all.where((m) => m.page == pageNumber).toList();
  }

  // ───────────────────────────────────────────────────────────────────────────

  /// Clears all in-memory caches. Useful for testing.
  void reset() {
    _pageCache.clear();
    _pageLoading.clear();
    _surahIndex = null;
    _surahLoading = null;
    _markers = null;
    _markersLoading = null;
    debugPrint('[KfqcDatasource] Cache cleared.');
  }

  // ───────────────────────────────────────────────────────────────────────────

  /// Pre-warms pages adjacent to [currentPage] for smoother scrolling.
  ///
  /// Loads [ahead] pages in the forward direction and [behind] pages backwards.
  void prewarm(int currentPage, {int ahead = 2, int behind = 1}) {
    for (int i = currentPage - behind; i <= currentPage + ahead; i++) {
      if (i >= 1 && i <= 604 && !_pageCache.containsKey(i)) {
        loadPageData(i);
      }
    }
  }
}
