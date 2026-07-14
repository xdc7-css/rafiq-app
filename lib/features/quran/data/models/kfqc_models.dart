// ──────────────────────────────────────────────────────────────────────────────
// KFQC (King Fahd Quran Complex) Dart models
// Source: assets/quran/quran-svg-main/mushafs/hafs/kfqc/
// ──────────────────────────────────────────────────────────────────────────────

import 'dart:ui' show Offset;

/// Represents a single ayah (verse) hit-area on a Mushaf page.
///
/// Parsed from the per-page JSON files (e.g. `json/001.json`).
/// Each entry carries the surah number, the ayah number within that surah,
/// the approximate centre point [x, y] in SVG coordinate space, and a
/// [polygonPoints] list that describes the exact bounds of the ayah's text.
class KfqcAyahArea {
  /// The surah (chapter) this ayah belongs to (1–114).
  final int surahNumber;

  /// The ayah number within the surah.
  final int ayahNumber;

  /// Approximate X centre of the ayah in SVG coordinates.
  final double x;

  /// Approximate Y centre of the ayah in SVG coordinates.
  final double y;

  /// Polygon vertices (in SVG coordinate space) that outline the ayah text.
  /// Suitable for building custom hit-test regions.
  final List<Offset> polygonPoints;

  /// Human-readable identifier: "<surahNumber>:<ayahNumber>", e.g. "2:255".
  final String verseIdentifier;

  const KfqcAyahArea({
    required this.surahNumber,
    required this.ayahNumber,
    required this.x,
    required this.y,
    required this.polygonPoints,
    required this.verseIdentifier,
  });

  /// Constructs a [KfqcAyahArea] from a single JSON object in the per-page file.
  ///
  /// Expected JSON shape:
  /// ```json
  /// {
  ///   "surahNumber": 1,
  ///   "ayahNumber": 7,
  ///   "x": 79.43,
  ///   "y": 205.31,
  ///   "polygon": "113.70,130.39 13.82,130.39 ..."
  /// }
  /// ```
  factory KfqcAyahArea.fromJson(Map<String, dynamic> json) {
    final surahNumber = (json['surahNumber'] as num?)?.toInt() ?? 0;
    final ayahNumber  = (json['ayahNumber']  as num?)?.toInt() ?? 0;
    final x = (json['x'] as num?)?.toDouble() ?? 0.0;
    final y = (json['y'] as num?)?.toDouble() ?? 0.0;

    final rawPolygon = json['polygon'] as String? ?? '';
    final polygonPoints = _parsePolygon(rawPolygon);

    return KfqcAyahArea(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      x: x,
      y: y,
      polygonPoints: polygonPoints,
      verseIdentifier: '$surahNumber:$ayahNumber',
    );
  }

  /// Parses a polygon string like `"x1,y1 x2,y2 x3,y3"` into [Offset] points.
  static List<Offset> _parsePolygon(String raw) {
    if (raw.trim().isEmpty) return [];
    final points = <Offset>[];
    for (final pair in raw.trim().split(RegExp(r'\s+'))) {
      final parts = pair.split(',');
      if (parts.length == 2) {
        final dx = double.tryParse(parts[0].trim());
        final dy = double.tryParse(parts[1].trim());
        if (dx != null && dy != null) {
          points.add(Offset(dx, dy));
        }
      }
    }
    return points;
  }

  @override
  String toString() =>
      'KfqcAyahArea($verseIdentifier, polygon=${polygonPoints.length} pts)';
}

// ─────────────────────────────────────────────────────────────────────────────

/// All ayah areas for a single Mushaf page.
///
/// Loaded from `json/NNN.json` where `NNN` is the zero-padded page number.
class KfqcPageData {
  /// Page number (1–604).
  final int pageNumber;

  /// All ayah areas that appear on this page, in document order.
  final List<KfqcAyahArea> ayahs;

  const KfqcPageData({
    required this.pageNumber,
    required this.ayahs,
  });

  /// Returns the unique surah numbers that appear on this page.
  Set<int> get surahNumbers =>
      ayahs.map((a) => a.surahNumber).toSet();

  @override
  String toString() =>
      'KfqcPageData(page=$pageNumber, ayahs=${ayahs.length})';
}

// ─────────────────────────────────────────────────────────────────────────────

/// A single surah (chapter) entry from `surah.json`.
class KfqcSurahEntry {
  /// Surah number (1–114).
  final int number;

  /// First page of this surah in the KFQC Mushaf.
  final int pageNumber;

  /// Total number of ayahs in this surah.
  final int ayahCount;

  /// Juz (part) number where this surah begins.
  final int juzNumber;

  /// Arabic name of the surah.
  final String nameArabic;

  /// Transliterated English name, e.g. "Al-Fatiha".
  final String nameEnglish;

  /// English translation of the surah name, e.g. "The Opening".
  final String nameTranslation;

  /// Y-position of the surah header on its opening page (SVG coordinates).
  final double headerPosition;

  const KfqcSurahEntry({
    required this.number,
    required this.pageNumber,
    required this.ayahCount,
    required this.juzNumber,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTranslation,
    required this.headerPosition,
  });

  /// Constructs from a single JSON object in `surah.json`.
  ///
  /// Expected shape:
  /// ```json
  /// {
  ///   "number": 1,
  ///   "pageNumber": 1,
  ///   "ayahCount": 7,
  ///   "juzNumber": 1,
  ///   "nameArabic": "الفاتحة",
  ///   "nameEnglish": "Al-Fatiha",
  ///   "nameTranslation": "The Opener",
  ///   "headerPosition": 183.016
  /// }
  /// ```
  factory KfqcSurahEntry.fromJson(Map<String, dynamic> json) {
    return KfqcSurahEntry(
      number:          (json['number']          as num?)?.toInt()    ?? 0,
      pageNumber:      (json['pageNumber']       as num?)?.toInt()    ?? 1,
      ayahCount:       (json['ayahCount']        as num?)?.toInt()    ?? 0,
      juzNumber:       (json['juzNumber']        as num?)?.toInt()    ?? 1,
      nameArabic:       json['nameArabic']        as String? ?? '',
      nameEnglish:      json['nameEnglish']       as String? ?? '',
      nameTranslation:  json['nameTranslation']   as String? ?? '',
      headerPosition:  (json['headerPosition']   as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() => 'KfqcSurahEntry($number: $nameArabic, page=$pageNumber)';
}

// ─────────────────────────────────────────────────────────────────────────────

/// A verse-marker position entry from `markers.json`.
///
/// Can be used to overlay verse-number badges or tap targets on the SVG.
class KfqcVerseMarker {
  /// Page number (1–604).
  final int page;

  /// Ayah (verse) sequential index within the page.
  final int ayah;

  /// X position in SVG coordinate space.
  final double x;

  /// Y position in SVG coordinate space.
  final double y;

  const KfqcVerseMarker({
    required this.page,
    required this.ayah,
    required this.x,
    required this.y,
  });

  /// Constructs from a single JSON object in `markers.json`.
  ///
  /// Expected shape: `{"page": 1, "ayah": 1, "x": 66.48, "y": 34.46}`
  factory KfqcVerseMarker.fromJson(Map<String, dynamic> json) {
    return KfqcVerseMarker(
      page: (json['page'] as num?)?.toInt() ?? 0,
      ayah: (json['ayah'] as num?)?.toInt() ?? 0,
      x:    (json['x']    as num?)?.toDouble() ?? 0.0,
      y:    (json['y']    as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() => 'KfqcVerseMarker(page=$page, ayah=$ayah, x=$x, y=$y)';
}
