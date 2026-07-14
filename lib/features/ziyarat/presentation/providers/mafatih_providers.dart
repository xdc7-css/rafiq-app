import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/mafatih_local_source.dart';
import '../../data/repository/mafatih_repository.dart';
import '../../data/models/mafatih_models.dart';

// ─── Data Layer ───

final mafatihLocalSourceProvider = Provider<MafatihLocalSource>((ref) {
  return MafatihLocalSource();
});

final mafatihRepositoryProvider = Provider<MafatihRepository>((ref) {
  final source = ref.watch(mafatihLocalSourceProvider);
  return MafatihRepository(source);
});

// ─── Chapters ───

final mafatihChaptersProvider = FutureProvider<List<MafatihChapter>>((ref) {
  final repo = ref.watch(mafatihRepositoryProvider);
  return repo.getChapters();
});

// ─── Search ───

final mafatihSearchQueryProvider = StateProvider<String>((ref) => '');

final mafatihSearchResultsProvider = Provider<List<MafatihSearchResult>>((ref) {
  final query = ref.watch(mafatihSearchQueryProvider);
  final chaptersAsync = ref.watch(mafatihChaptersProvider);
  final repo = ref.watch(mafatihRepositoryProvider);
  if (query.trim().isEmpty) return [];
  final chapters = chaptersAsync.valueOrNull;
  if (chapters == null) return [];
  return repo.search(query);
});

// ─── Bookmarks ───

const _bookmarksKey = 'mafatih_bookmarks';

final mafatihBookmarksProvider =
    StateNotifierProvider<MafatihBookmarksNotifier, List<MafatihBookmarkEntry>>(
        (ref) {
  return MafatihBookmarksNotifier();
});

class MafatihBookmarksNotifier extends StateNotifier<List<MafatihBookmarkEntry>> {
  MafatihBookmarksNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_bookmarksKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => MafatihBookmarkEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_bookmarksKey, raw);
  }

  bool isBookmarked(String href) =>
      state.any((b) => b.articleHref == href);

  void toggle(MafatihBookmarkEntry entry) {
    if (isBookmarked(entry.articleHref)) {
      remove(entry.articleHref);
    } else {
      add(entry);
    }
  }

  void add(MafatihBookmarkEntry entry) {
    state = [entry, ...state];
    _save();
  }

  void remove(String href) {
    state = state.where((b) => b.articleHref != href).toList();
    _save();
  }

  void updateScroll(String href, int scrollPosition) {
    state = state.map((b) {
      if (b.articleHref == href) {
        return MafatihBookmarkEntry(
          articleHref: b.articleHref,
          articleTitle: b.articleTitle,
          chapterTitle: b.chapterTitle,
          sectionTitle: b.sectionTitle,
          scrollPosition: scrollPosition,
          bookmarkedAt: b.bookmarkedAt,
        );
      }
      return b;
    }).toList();
    _save();
  }

  MafatihBookmarkEntry? findByHref(String href) {
    try {
      return state.firstWhere((b) => b.articleHref == href);
    } catch (_) {
      return null;
    }
  }
}

// ─── Recently Read ───

const _recentlyReadKey = 'mafatih_recent';

final mafatihRecentlyReadProvider =
    StateNotifierProvider<MafatihRecentlyReadNotifier, List<MafatihBookmarkEntry>>(
        (ref) {
  return MafatihRecentlyReadNotifier();
});

class MafatihRecentlyReadNotifier extends StateNotifier<List<MafatihBookmarkEntry>> {
  MafatihRecentlyReadNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_recentlyReadKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => MafatihBookmarkEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_recentlyReadKey, raw);
  }

  void record(MafatihBookmarkEntry entry) {
    state = [
      entry,
      ...state.where((b) => b.articleHref != entry.articleHref).take(49),
    ];
    _save();
  }

  void updateScroll(String href, int scrollPosition) {
    state = state.map((b) {
      if (b.articleHref == href) {
        return MafatihBookmarkEntry(
          articleHref: b.articleHref,
          articleTitle: b.articleTitle,
          chapterTitle: b.chapterTitle,
          sectionTitle: b.sectionTitle,
          scrollPosition: scrollPosition,
          bookmarkedAt: b.bookmarkedAt,
        );
      }
      return b;
    }).toList();
    _save();
  }

  MafatihBookmarkEntry? findRecent(String href) {
    try {
      return state.firstWhere((b) => b.articleHref == href);
    } catch (_) {
      return null;
    }
  }
}

// ─── Reading Settings ───

class MafatihReadingSettings {
  final double fontSize;
  final double lineSpacing;
  final bool nightMode;

  const MafatihReadingSettings({
    this.fontSize = 20.0,
    this.lineSpacing = 1.6,
    this.nightMode = false,
  });

  MafatihReadingSettings copyWith({
    double? fontSize,
    double? lineSpacing,
    bool? nightMode,
  }) {
    return MafatihReadingSettings(
      fontSize: fontSize ?? this.fontSize,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      nightMode: nightMode ?? this.nightMode,
    );
  }
}

final mafatihReadingSettingsProvider = StateNotifierProvider<
    MafatihReadingSettingsNotifier, MafatihReadingSettings>((ref) {
  return MafatihReadingSettingsNotifier();
});

class MafatihReadingSettingsNotifier
    extends StateNotifier<MafatihReadingSettings> {
  MafatihReadingSettingsNotifier() : super(const MafatihReadingSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = MafatihReadingSettings(
      fontSize: prefs.getDouble('maf_font_size') ?? 20.0,
      lineSpacing: prefs.getDouble('maf_line_spacing') ?? 1.6,
      nightMode: prefs.getBool('maf_night_mode') ?? false,
    );
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('maf_font_size', state.fontSize);
    await prefs.setDouble('maf_line_spacing', state.lineSpacing);
    await prefs.setBool('maf_night_mode', state.nightMode);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size.clamp(14.0, 36.0));
    _save();
  }

  void setLineSpacing(double spacing) {
    state = state.copyWith(lineSpacing: spacing.clamp(1.0, 3.0));
    _save();
  }

  void toggleNightMode() {
    state = state.copyWith(nightMode: !state.nightMode);
    _save();
  }
}
