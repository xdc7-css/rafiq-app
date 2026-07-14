import '../models/aqwal_model.dart';
import 'aqwal_local_source.dart';

class HadithLocalSource {
  final AqwalLocalSource _inner = AqwalLocalSource();

  Future<List<AqwalModel>> loadAllAhadith() async {
    return _inner.loadAll();
  }

  Future<List<AqwalModel>> getByCategory(String categoryId) async {
    return _inner.getByCategory(categoryId);
  }

  Future<List<AqwalModel>> searchHadiths(String query) async {
    return _inner.search(query);
  }

  AqwalModel? getDailyHadith() {
    return _inner.getDailyQawal();
  }

  void clearCache() {
    _inner.clearCache();
  }
}
