import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/ziyarat_models.dart';

class BookmarkNotifier extends StateNotifier<List<ReadingBookmark>> {
  bool _disposed = false;

  BookmarkNotifier() : super([]) {
    _load();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  static const _key = 'ziyarat_bookmarks';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (_disposed) return;
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      state = list.map((e) => ReadingBookmark.fromJson(e)).toList();
    }
  }

  Future<void> _save() async {
    if (_disposed) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  void addBookmark(String contentId, String contentType, String contentTitle, {int position = 0}) {
    final exists = state.any((b) => b.contentId == contentId && b.contentType == contentType);
    if (exists) return;
    state = [
      ...state,
      ReadingBookmark(
        id: const Uuid().v4(),
        contentId: contentId,
        contentType: contentType,
        contentTitle: contentTitle,
        position: position,
        savedAt: DateTime.now(),
      ),
    ];
    _save();
  }

  void removeBookmark(String id) {
    state = state.where((b) => b.id != id).toList();
    _save();
  }

  bool isBookmarked(String contentId) {
    return state.any((b) => b.contentId == contentId);
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, List<ReadingBookmark>>((ref) {
  return BookmarkNotifier();
});

final isBookmarkedProvider = Provider.family<bool, String>((ref, contentId) {
  return ref.watch(bookmarkProvider).any((b) => b.contentId == contentId);
});
