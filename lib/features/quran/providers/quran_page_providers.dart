import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/quran_page_streamer.dart';
import '../data/services/lru_svg_cache.dart';
import '../../../database/isar_service.dart';

// ─── Singletons ──────────────────────────────────────────────────────────────

final quranPageStreamerProvider = Provider<QuranPageStreamer>((ref) {
  final streamer = QuranPageStreamer();
  ref.onDispose(() => streamer.dispose());
  return streamer;
});

final lruSvgCacheProvider = Provider<LruSvgCache>((ref) {
  return LruSvgCache(maxSize: 20);
});

// ─── Page SVG content ────────────────────────────────────────────────────────

/// FutureProvider family that returns SVG content for a single page.
///
/// Priority order:
/// 1. LRU memory cache
/// 2. Isar disk cache
/// 3. CDN network fetch (critical priority)
final quranPageSvgProvider =
    FutureProvider.autoDispose.family<String?, int>((ref, pageNumber) async {
  final lru = ref.read(lruSvgCacheProvider);

  // 1. Memory cache.
  final memCached = lru.get(pageNumber);
  if (memCached != null) {
    debugPrint('[QuranPageProvider] Memory cache HIT page $pageNumber (len=${memCached.length})');
    return memCached;
  }
  debugPrint('[QuranPageProvider] Memory cache MISS page $pageNumber');

  // 2. Isar cache or CDN (via streamer).
  final streamer = ref.read(quranPageStreamerProvider);
  final content = await streamer.getPage(pageNumber);

  // 3. Populate memory cache.
  if (content != null) {
    lru.put(pageNumber, content);
    debugPrint('[QuranPageProvider] Populated LRU page $pageNumber (len=${content.length})');
  } else {
    debugPrint('[QuranPageProvider] Content NULL for page $pageNumber');
  }

  return content;
});

// ─── Download progress ───────────────────────────────────────────────────────

/// Exposes simple streaming download progress for the UI download screen.
/// Only actively polls when downloads may be in progress; backs off when
/// the cached count is stable (all 604 pages or no change for 5 cycles).
final quranDownloadProgressProvider = StreamProvider<int>((ref) async* {
  int lastCount = -1;
  int stableCycles = 0;
  while (true) {
    final count = await IsarService.getCachedPageCount();
    yield count;
    if (count == lastCount) {
      stableCycles++;
      if (stableCycles >= 5) {
        // All pages likely cached or no download activity — poll slowly.
        await Future.delayed(const Duration(seconds: 30));
        continue;
      }
    } else {
      stableCycles = 0;
      lastCount = count;
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
});

// ─── Init streamer ───────────────────────────────────────────────────────────

/// Provider that initializes the streamer on first read (fire once).
final quranStreamerInitProvider = Provider<void>((ref) {
  final streamer = ref.watch(quranPageStreamerProvider);
  unawaited(streamer.initialize().then((_) {
    streamer.startBackgroundDownload();
  }));
});

// ─── Page prefetch ───────────────────────────────────────────────────────────

/// Call this when the user changes pages to trigger adjacent prefetch.
void prefetchQuranPages(WidgetRef ref, int currentPage) {
  final streamer = ref.read(quranPageStreamerProvider);
  streamer.onPageChanged(currentPage);
}

/// Start background download (on first launch).
void startBackgroundDownload(WidgetRef ref) {
  final streamer = ref.read(quranPageStreamerProvider);
  streamer.startBackgroundDownload();
}
