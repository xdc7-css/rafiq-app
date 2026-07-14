import '../../../../core/network/shia_api_client.dart';
import '../models/shia_hadith_models.dart';

class HadithRemoteDataSource {
  final ShiaApiClient _client;

  HadithRemoteDataSource({ShiaApiClient? client}) : _client = client ?? ShiaApiClient();

  Future<List<ShiaHadith>> getBookHadiths(String bookId) async {
    final rawData = await _client.getBook(bookId);
    return rawData
        .map((json) => ShiaHadith.fromJson(json, bookId))
        .where((h) => h.text.isNotEmpty)
        .toList();
  }

  Future<ShiaHadith?> getHadith(String bookId, int hadithNumber) async {
    final raw = await _client.getHadith(bookId, hadithNumber);
    if (raw == null) return null;
    return ShiaHadith.fromJson(raw, bookId);
  }

  Future<List<ShiaHadith>> searchHadiths(String bookId, String query) async {
    final rawData = await _client.searchHadiths(bookId, query);
    return rawData
        .map((json) => ShiaHadith.fromJson(json, bookId))
        .where((h) => h.text.isNotEmpty)
        .toList();
  }

  Future<List<ShiaHadith>> getRandomHadiths({int count = 5}) async {
    final books = ['Alkafi_v1', 'Fadaail_elshia', 'Al_Amaal', 'ALkhisal', 'AlTawhid'];
    final allHadiths = <ShiaHadith>[];

    for (final bookId in books) {
      try {
        final hadiths = await getBookHadiths(bookId);
        allHadiths.addAll(hadiths);
      } catch (_) {
        continue;
      }
      if (allHadiths.length >= count * 3) break;
    }

    if (allHadiths.isEmpty) return [];

    allHadiths.shuffle();
    return allHadiths.take(count).toList();
  }
}
