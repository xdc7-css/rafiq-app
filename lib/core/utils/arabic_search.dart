

class ArabicNormalizer {
  ArabicNormalizer._();

  static final Map<String, String> _normalizeCache = {};
  static final Map<String, List<RegExp>> _fuzzyCache = {};

  static final _tashkeel = RegExp(r'[ًٌٍَُِّْ]');
  static final _tatweel = RegExp(r'[ـ]');

  static String normalize(String text) {
    final cached = _normalizeCache[text];
    if (cached != null) return cached;

    String s = text;
    s = s.replaceAll(_tashkeel, '');
    s = s.replaceAll(_tatweel, '');
    s = s.replaceAll('\u0621', '\u0627');
    s = s.replaceAll('\u0622', '\u0627');
    s = s.replaceAll('\u0623', '\u0627');
    s = s.replaceAll('\u0625', '\u0627');
    s = s.replaceAll('\u0629', '\u0647');
    s = s.replaceAll('\u064A', '\u0649');
    s = s.replaceAll('\u0626', '\u0623');
    s = s.replaceAll('\u064E', '');
    s = s.replaceAll('\u064F', '');
    s = s.replaceAll('\u0650', '');
    s = s.replaceAll('\u0651', '');
    s = s.replaceAll('\u0652', '');
    s = s.replaceAll('\u0670', '\u0627');

    _normalizeCache[text] = s;
    return s;
  }

  static String normalizeForSearch(String text) {
    return normalize(text).trim();
  }

  static List<RegExp> buildFuzzyPatterns(String query) {
    final cacheKey = query;
    final cached = _fuzzyCache[cacheKey];
    if (cached != null) return cached;

    final normalized = normalizeForSearch(query);
    final words = normalized.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    if (words.isEmpty) {
      final empty = [RegExp('')];
      _fuzzyCache[cacheKey] = empty;
      return empty;
    }

    final patterns = <RegExp>[];
    for (final word in words) {
      final escaped = RegExp.escape(word);
      final flexible = StringBuffer();
      for (int i = 0; i < escaped.length; i++) {
        flexible.write(escaped[i]);
        if (i < escaped.length - 1) {
          flexible.write(r'\s*');
        }
      }
      patterns.add(RegExp(flexible.toString(), caseSensitive: false));
    }

    _fuzzyCache[cacheKey] = patterns;
    return patterns;
  }

  static bool fuzzyMatch(String text, String query) {
    final normalizedText = normalizeForSearch(text);
    final patterns = buildFuzzyPatterns(query);
    if (patterns.isEmpty) return true;
    return patterns.every((p) => p.hasMatch(normalizedText));
  }

  static List<int> findRanges(String text, String query) {
    final normalizedText = normalizeForSearch(text);
    final normalizedQuery = normalizeForSearch(query);
    final ranges = <int>[];
    int start = 0;
    while (true) {
      final idx = normalizedText.indexOf(normalizedQuery, start);
      if (idx == -1) break;
      ranges.add(idx);
      ranges.add(idx + normalizedQuery.length);
      start = idx + 1;
    }
    return ranges;
  }

  static double similarity(String a, String b) {
    final na = normalizeForSearch(a);
    final nb = normalizeForSearch(b);
    if (na == nb) return 1.0;
    if (na.contains(nb) || nb.contains(na)) return 0.9;
    final wordsA = na.split(' ').toSet();
    final wordsB = nb.split(' ').toSet();
    if (wordsA.isEmpty || wordsB.isEmpty) return 0.0;
    final intersection = wordsA.intersection(wordsB).length;
    final union = wordsA.union(wordsB).length;
    return intersection / union;
  }
}

class QuranIndex {
  final List<QuranIndexEntry> entries = [];
  final Map<int, List<QuranIndexEntry>> _juzMap = {};
  final Map<int, List<QuranIndexEntry>> _hizbMap = {};
  final Map<int, List<QuranIndexEntry>> _pageMap = {};
  final Map<int, List<QuranIndexEntry>> _surahMap = {};
  final Map<String, List<int>> _wordIndex = {};

  void build(List<QuranIndexEntry> data) {
    entries.addAll(data);
    for (final e in data) {
      _juzMap.putIfAbsent(e.juz, () => []).add(e);
      _hizbMap.putIfAbsent(e.hizbQuarter, () => []).add(e);
      _pageMap.putIfAbsent(e.page, () => []).add(e);
      _surahMap.putIfAbsent(e.surahNumber, () => []).add(e);
      final normalized = ArabicNormalizer.normalizeForSearch(e.text);
      final words = normalized.split(' ').where((w) => w.length > 1).toSet();
      for (final w in words) {
        _wordIndex.putIfAbsent(w, () => []).add(e.index);
      }
    }
  }

  List<QuranIndexEntry> search(String query,
      {int? surah, int? juz, int? hizb, int? page, int? ayahNumber}) {
    final results = <QuranIndexEntry>[];

    if (surah != null) {
      final surahEntries = _surahMap[surah];
      if (surahEntries == null) return results;
      if (ayahNumber != null) {
        return surahEntries.where((e) => e.ayahNumber == ayahNumber).toList();
      }
      return surahEntries;
    }

    if (juz != null) return _juzMap[juz] ?? [];
    if (hizb != null) return _hizbMap[hizb] ?? [];
    if (page != null) return _pageMap[page] ?? [];
    if (ayahNumber != null && surah != null) {
      return entries.where((e) =>
          e.surahNumber == surah && e.ayahNumber == ayahNumber).toList();
    }

    if (query.isEmpty) return [];

    final normalizedQuery = ArabicNormalizer.normalizeForSearch(query);

    if (matchesSurahName(normalizedQuery)) {
      final surahNum = getSurahNumber(normalizedQuery);
      if (surahNum != null) {
        return _surahMap[surahNum] ?? [];
      }
    }

    final matchedIndices = <int>{};
    final queryWords =
        normalizedQuery.split(' ').where((w) => w.length > 1).toList();
    for (final w in queryWords) {
      for (final entry in _wordIndex.entries) {
        if (entry.key.contains(w) || w.contains(entry.key)) {
          matchedIndices.addAll(entry.value);
        }
      }
    }

    for (final idx in matchedIndices) {
      final entry = entries[idx];
      if (ArabicNormalizer.fuzzyMatch(entry.text, query)) {
        results.add(entry);
      }
    }

    for (final e in entries) {
      if (!matchedIndices.contains(e.index)) {
        final txt = ArabicNormalizer.normalizeForSearch(e.text);
        if (txt.contains(normalizedQuery)) {
          results.add(e);
        }
      }
    }

    results.sort((a, b) => a.index.compareTo(b.index));
    return results.take(100).toList();
  }

  bool matchesSurahName(String normalized) {
    return _surahNames.values.any((names) =>
        names.any((n) => ArabicNormalizer.normalizeForSearch(n) == normalized ||
            ArabicNormalizer.normalizeForSearch(n).contains(normalized)));
  }

  int? getSurahNumber(String normalized) {
    for (final entry in _surahNames.entries) {
      if (entry.value.any((n) =>
          ArabicNormalizer.normalizeForSearch(n) == normalized ||
          ArabicNormalizer.normalizeForSearch(n).contains(normalized))) {
        return entry.key;
      }
    }
    return null;
  }

  static const Map<int, List<String>> _surahNames = {
    1: ['الفاتحة', 'سُورَةُ الْفَاتِحَةِ', 'سورة الفاتحة'],
    2: ['البقرة', 'سُورَةُ الْبَقَرَةِ', 'سورة البقرة'],
    3: ['آل عمران', 'ال عمران', 'سُورَةُ آلِ عِمْرَانَ'],
    36: ['يس', 'ياسين', 'يسٓ', 'سُورَةُ يس'],
    67: ['تبارك', 'الملك', 'سُورَةُ الْمُلْكِ'],
    112: ['الإخلاص', 'الاخلاص', 'سُورَةُ الإِخْلَاصِ'],
  };
}

class QuranIndexEntry {
  final int index;
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final int juz;
  final int page;
  final int hizbQuarter;
  final int ruku;
  final int manzil;
  final bool hasSajda;

  QuranIndexEntry({
    required this.index,
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    this.juz = 1,
    this.page = 1,
    this.hizbQuarter = 1,
    this.ruku = 1,
    this.manzil = 1,
    this.hasSajda = false,
  });
}
