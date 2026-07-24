import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/api_providers.dart';
import '../../data/models/shia_hadith_models.dart';
import '../../data/datasources/hadith_local_datasource.dart';
import '../../data/repository/hadith_repository_impl.dart';

final hadithLocalDataSourceProvider = Provider<HadithLocalDataSource>((ref) {
  return HadithLocalDataSource();
});

final hadithRepositoryProvider = Provider<HadithRepositoryImpl>((ref) {
  return HadithRepositoryImpl(
    remote: ref.watch(hadithRemoteDataSourceProvider),
    local: ref.watch(hadithLocalDataSourceProvider),
  );
});

final dailyShiaHadithProvider =
    FutureProvider.autoDispose<ShiaHadith>((ref) async {
  ref.cacheFor(const Duration(hours: 6));
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getDailyHadith();
});

final bookListProvider = Provider<List<ShiaBookInfo>>((ref) {
  return ShiaBookInfo.allBooks;
});

final bookHadithsProvider =
    FutureProvider.autoDispose.family<List<ShiaHadith>, String>((ref, bookId) async {
  ref.cacheFor(const Duration(hours: 2));
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getBookHadiths(bookId);
});

final hadithSearchQueryProvider = StateProvider<String>((ref) => '');

final hadithSearchResultsProvider =
    FutureProvider.autoDispose<List<ShiaHadith>>((ref) async {
  final query = ref.watch(hadithSearchQueryProvider);
  if (query.trim().isEmpty) return Future.value([]);
  ref.cacheFor(const Duration(seconds: 30));
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.searchHadiths(query);
});

final tasbihCompletionHadithProvider =
    FutureProvider.autoDispose<ShiaHadith>((ref) async {
  ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getDailyHadith();
});

extension _FutureProviderRefX on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    Future.delayed(duration, () {
      link.close();
    });
  }
}
