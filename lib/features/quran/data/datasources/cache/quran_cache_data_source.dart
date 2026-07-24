import 'quran_cache_stub.dart'
    if (dart.library.io) 'native_quran_cache_data_source.dart'
    if (dart.library.js_interop) 'web_quran_cache_data_source.dart';

/// Platform-agnostic cache for Quran SVG pages.
///
/// Native platforms use the filesystem; web uses IndexedDB.
/// The presentation layer never knows which backend is in use.
abstract class QuranCacheDataSource {
  /// Performs any one-time setup (e.g. creating directories or opening DBs).
  Future<void> initialize();

  /// Persists the raw SVG bytes for [pageNumber].
  Future<void> savePage(int pageNumber, List<int> bytes);

  /// Returns `true` when a valid cached page exists for [pageNumber].
  Future<bool> pageExists(int pageNumber);

  /// Validates that the cached page is intact (size + header checks).
  /// Deletes the page automatically if it is corrupt.
  Future<bool> validatePage(int pageNumber);

  /// Number of `.svg` pages currently stored.
  Future<int> getDownloadedPagesCount();

  /// Whether all 604 pages are cached and valid.
  Future<bool> isFullyDownloaded();

  /// Page numbers that are missing **or** corrupt.
  Future<List<int>> getMissingPages();

  /// Deletes a single cached page.
  Future<void> deletePage(int pageNumber);

  /// Removes every cached page.
  Future<void> clearCache();

  /// Total size of the cache in bytes (approximation is acceptable).
  Future<int> getCacheSize();

  /// Returns the SVG content as a string (used for rendering).
  /// Returns `null` if the page is not cached.
  Future<String?> loadPageContent(int pageNumber);

  /// Returns a platform-native file reference.
  /// On native this is a [File]; on web this returns `null`
  /// and callers should use [loadPageContent] instead.
  Future<dynamic> loadPageFile(int pageNumber);
}

/// Creates the correct [QuranCacheDataSource] for the current platform.
QuranCacheDataSource createQuranCacheDataSource() => createImpl();
