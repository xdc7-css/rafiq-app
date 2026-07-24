import 'dart:collection';
import 'package:flutter/foundation.dart';

/// In-memory LRU cache for decoded Quran SVG page strings.
///
/// Keeps the latest [maxSize] pages decoded in RAM so swiping between
/// recently-viewed pages is instant — no Isar read or SVG re-parse.
class LruSvgCache {
  LruSvgCache({this.maxSize = 20});

  final int maxSize;
  final LinkedHashMap<int, String> _cache = LinkedHashMap();

  /// Returns cached SVG content for [pageNumber], or null.
  String? get(int pageNumber) {
    final content = _cache.remove(pageNumber);
    if (content == null) return null;
    _cache[pageNumber] = content;
    return content;
  }

  /// Stores [content] for [pageNumber], evicting LRU if at capacity.
  void put(int pageNumber, String content) {
    _cache.remove(pageNumber);
    if (_cache.length >= maxSize) {
      final lru = _cache.keys.first;
      _cache.remove(lru);
      debugPrint('[LruSvgCache] Evicted page $lru (size=${_cache.length})');
    }
    _cache[pageNumber] = content;
  }

  /// Removes all entries.
  void clear() => _cache.clear();

  int get size => _cache.length;
}
