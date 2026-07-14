class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.alquran.cloud/v1';
  static const String quranComApi = 'https://api.quran.com/api/v4';
  static const String hadithApi = 'https://api.hadith.gading.dev';
  static const String rawGithub = 'https://raw.githubusercontent.com/itsSamBz/Islamic-Api/main';

  static const Duration timeout = Duration(seconds: 15);
  static const Duration cacheDuration = Duration(hours: 24);

  static const String mediaTypeJson = 'application/json';
}
