import '../../../../core/config/debug_flags.dart';
import '../models/shia_hadith_models.dart';
import '../datasources/hadith_remote_datasource.dart';
import '../datasources/hadith_local_datasource.dart';

class HadithRepositoryImpl {
  final HadithRemoteDataSource _remote;
  final HadithLocalDataSource _local;

  HadithRepositoryImpl({
    HadithRemoteDataSource? remote,
    HadithLocalDataSource? local,
  })  : _remote = remote ?? HadithRemoteDataSource(),
        _local = local ?? HadithLocalDataSource();

  Future<List<ShiaHadith>> getBookHadiths(String bookId) async {
    final cached = await _local.getCachedHadiths(bookId);
    if (cached.isNotEmpty) return cached;

    if (DebugFlags.disableNonCriticalStartupApis) {
      return cached;
    }

    try {
      final hadiths = await _remote.getBookHadiths(bookId);
      await _local.cacheHadiths(bookId, hadiths);
      return hadiths;
    } catch (e) {
      return cached;
    }
  }

  Future<ShiaHadith?> getHadith(String bookId, int hadithNumber) async {
    if (DebugFlags.disableNonCriticalStartupApis) {
      final cached = await _local.getCachedHadiths(bookId);
      for (final h in cached) {
        if (h.number == hadithNumber) return h;
      }
      return null;
    }
    try {
      return await _remote.getHadith(bookId, hadithNumber);
    } catch (_) {
      final cached = await _local.getCachedHadiths(bookId);
      for (final h in cached) {
        if (h.number == hadithNumber) return h;
      }
      return null;
    }
  }

  Future<List<ShiaHadith>> searchHadiths(
    String query, {
    String? bookId,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    if (DebugFlags.disableNonCriticalStartupApis) {
      if (bookId != null) {
        final cached = await _local.getCachedHadiths(bookId);
        return cached
            .where((h) =>
                h.text.contains(q) ||
                (h.subject?.contains(q) ?? false) ||
                (h.narrator?.contains(q) ?? false))
            .toList();
      }
      return [];
    }

    if (bookId != null) {
      try {
        return await _remote.searchHadiths(bookId, q);
      } catch (_) {}
      final cached = await _local.getCachedHadiths(bookId);
      return cached
          .where((h) =>
              h.text.contains(q) ||
              (h.subject?.contains(q) ?? false) ||
              (h.narrator?.contains(q) ?? false))
          .toList();
    }

    final allResults = <ShiaHadith>[];
    const searchableBooks = [
      'Alkafi_v1', 'Alkafi_v2', 'Alkafi_v3',
      'Fadaail_elshia', 'Al_Amaal', 'ALkhisal', 'AlTawhid',
    ];

    for (final bid in searchableBooks) {
      try {
        final results = await _remote.searchHadiths(bid, q);
        allResults.addAll(results);
      } catch (_) {
        final cached = await _local.getCachedHadiths(bid);
        allResults.addAll(cached.where((h) =>
            h.text.contains(q) ||
            (h.subject?.contains(q) ?? false)));
      }
      if (allResults.length >= 50) break;
    }

    return allResults.take(50).toList();
  }

  Future<ShiaHadith> getDailyHadith() async {
    final cached = await _local.getCachedDailyHadith();
    if (cached != null && cached.text.isNotEmpty) return cached;

    if (DebugFlags.disableNonCriticalStartupApis) {
      final fallbacks = await _local.getFallbackHadiths();
      final dayOfYear =
          DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
      return fallbacks[dayOfYear % fallbacks.length];
    }

    try {
      final allBooks = [
        'Alkafi_v1', 'Fadaail_elshia', 'Al_Amaal',
        'ALkhisal', 'AlTawhid', 'KamilAlZiyarat',
      ];

      final allHadiths = <ShiaHadith>[];
      for (final bookId in allBooks) {
        try {
          final hadiths = await getBookHadiths(bookId);
          allHadiths.addAll(hadiths);
        } catch (_) {
          continue;
        }
        if (allHadiths.length >= 500) break;
      }

      if (allHadiths.isNotEmpty) {
        final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
        final hadith = allHadiths[dayOfYear % allHadiths.length];
        await _local.cacheDailyHadith(hadith);
        return hadith;
      }
    } catch (_) {}

    final fallbacks = await _local.getFallbackHadiths();
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return fallbacks[dayOfYear % fallbacks.length];
  }

  Future<List<ShiaBookInfo>> getAvailableBooks() async {
    return ShiaBookInfo.allBooks;
  }
}
