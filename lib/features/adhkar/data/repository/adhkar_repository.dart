import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/adhkar_local_source.dart';
import '../models/adhkar_models.dart';

final adhkarLocalSourceProvider = Provider<AdhkarLocalSource>((ref) => AdhkarLocalSource());

class AdhkarRepository {
  final AdhkarLocalSource _local;
  AdhkarRepository(this._local);

  Future<List<AdhkarCategoryModel>> getCategories() => _local.loadAdhkar();
  Future<List<DhikrModel>> searchAdhkar(String query) => _local.searchAdhkar(query);
}

final adhkarRepositoryProvider = Provider<AdhkarRepository>((ref) {
  return AdhkarRepository(ref.watch(adhkarLocalSourceProvider));
});
