import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/hadith_local_source.dart';
import '../models/aqwal_model.dart';

final hadithLocalSourceProvider = Provider<HadithLocalSource>((ref) => HadithLocalSource());

final aqwalProvider = FutureProvider<List<AqwalModel>>((ref) {
  return ref.watch(hadithLocalSourceProvider).loadAllAhadith();
});

class HadithRepository {
  final HadithLocalSource _local;
  HadithRepository(this._local);

  Future<List<AqwalModel>> getByCategory(String categoryId) => _local.getByCategory(categoryId);
  Future<List<AqwalModel>> getAll() => _local.loadAllAhadith();
  Future<List<AqwalModel>> search(String query) => _local.searchHadiths(query);
  AqwalModel? getDaily() => _local.getDailyHadith();
}

final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  return HadithRepository(ref.watch(hadithLocalSourceProvider));
});
