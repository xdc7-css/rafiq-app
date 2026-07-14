import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../database/local_database.dart';
import '../models/bookmark_models.dart';

class BookmarkRepository {
  static const String _bookmarksKey = 'bookmarks_v2';
  static const String _lastReadKey = 'last_read';

  Future<void> addBookmark(BookmarkModel bookmark) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.id == bookmark.id);
    bookmarks.insert(0, bookmark);
    await _saveBookmarks(bookmarks);
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      await db.putBookmark(BookmarkEntry(
        uniqueKey: '${bookmark.type.index}_${bookmark.id}',
        typeIndex: bookmark.type.index,
        title: bookmark.title,
        subtitle: bookmark.subtitle ?? '',
        data: bookmark.data.toString(),
        createdAt: bookmark.createdAt,
      ));
    }
  }

  Future<void> removeBookmark(String id) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.id == id);
    await _saveBookmarks(bookmarks);
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final existing = await db.getAllBookmarks();
      for (final bm in existing) {
        if (bm.uniqueKey.endsWith('_$id')) {
          await db.deleteBookmarkByKey(bm.uniqueKey);
          break;
        }
      }
    }
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b.id == id);
  }

  Future<List<BookmarkModel>> getBookmarks() async {
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final entries = await db.getAllBookmarks();
      if (entries.isNotEmpty) {
        return entries.map((e) => BookmarkModel(
          id: e.uniqueKey.contains('_') ? e.uniqueKey.substring(e.uniqueKey.indexOf('_') + 1) : e.uniqueKey,
          type: BookmarkType.values[e.typeIndex],
          title: e.title,
          subtitle: e.subtitle.isNotEmpty ? e.subtitle : null,
          data: {},
          createdAt: e.createdAt,
        )).toList();
      }
    }
    final data = CacheManager.getJsonList(_bookmarksKey);
    if (data == null) return [];
    return data
        .map((e) => BookmarkModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<BookmarkModel>> getBookmarksByType(BookmarkType type) async {
    final bookmarks = await getBookmarks();
    return bookmarks.where((b) => b.type == type).toList();
  }

  Future<void> _saveBookmarks(List<BookmarkModel> bookmarks) async {
    final jsonList = bookmarks.map((b) => b.toJson()).toList();
    await CacheManager.cacheJsonList(_bookmarksKey, jsonList);
  }

  Future<void> saveLastRead(ReadingProgress progress) async {
    await CacheManager.cacheJson(_lastReadKey, progress.toJson());
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      await db.putReadingProgress(ReadingProgressEntry(
        bookId: 'default',
        surahNumber: progress.surahNumber,
        ayahNumber: progress.ayahNumber,
        page: progress.page,
        juz: progress.juz,
        updatedAt: DateTime.now(),
      ));
    }
  }

  Future<ReadingProgress?> getLastRead() async {
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final rp = await db.getReadingProgress('default');
      if (rp != null) {
        return ReadingProgress(
          surahNumber: rp.surahNumber,
          ayahNumber: rp.ayahNumber,
          page: rp.page,
          juz: rp.juz,
          lastRead: rp.updatedAt,
        );
      }
    }
    final data = CacheManager.getJson(_lastReadKey);
    if (data == null) return null;
    return ReadingProgress.fromJson(data);
  }

  Future<void> clearAll() async {
    await CacheManager.remove(_bookmarksKey);
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) => BookmarkRepository());
