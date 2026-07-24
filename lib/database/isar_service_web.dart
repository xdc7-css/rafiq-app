import 'collections_stub.dart';

class IsarService {
  static final Map<int, QuranSvgPageIsar> _pages = {};
  static final Map<String, String> _downloadState = {};
  static bool _initialized = false;

  static Future<void> getInstance() async {
    _initialized = true;
  }

  static bool get isInitialized => _initialized;

  static Future<void> close() async {
    _pages.clear();
    _downloadState.clear();
    _initialized = false;
  }

  static Future<QuranSvgPageIsar?> getQuranSvgPage(int pageNumber) async {
    return _pages[pageNumber];
  }

  static Future<void> putQuranSvgPage(int pageNumber, String svgContent) async {
    _pages[pageNumber] = QuranSvgPageIsar()
      ..pageNumber = pageNumber
      ..svgContent = svgContent
      ..cachedAt = DateTime.now();
  }

  static Future<List<int>> getAllCachedPageNumbers() async {
    return _pages.keys.toList();
  }

  static Future<int> getCachedPageCount() async {
    return _pages.length;
  }

  static Future<void> deleteQuranSvgPage(int pageNumber) async {
    _pages.remove(pageNumber);
  }

  static Future<String?> getDownloadStateValue(String key) async {
    return _downloadState[key];
  }

  static Future<void> putDownloadStateValue(String key, String value) async {
    _downloadState[key] = value;
  }

  static Future<void> deleteDownloadStateKeys(List<String> keys) async {
    for (final key in keys) {
      _downloadState.remove(key);
    }
  }
}
