import '../datasources/quran_audio_api.dart';
import '../models/quran_audio_models.dart';

class QuranAudioRepository {
  final QuranAudioApi _api;

  QuranAudioRepository({QuranAudioApi? api})
      : _api = api ?? QuranAudioApi();

  Future<List<QuranReciter>> getReciters() => _api.fetchReciters();
  Future<List<QuranReciter>> searchReciters(String q) => _api.searchReciters(q);

  List<int> availableSurahs(QuranReciter reciter, Moshaf moshaf) {
    return moshaf.parsedSurahNumbers();
  }

  String audioUrl(Moshaf moshaf, int surahNumber) {
    return moshaf.audioUrl(surahNumber);
  }

  void dispose() => _api.dispose();
}
