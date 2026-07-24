import 'package:isar_community/isar.dart';

part 'collections.g.dart';

@collection
class SettingsIsar {
  Id id = Isar.autoIncrement;
  late String data;
  late DateTime updatedAt;
}

@collection
class FavoriteIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uniqueKey;
  late int typeIndex;
  late String textArabic;
  late String reference;
  late DateTime dateAdded;
  late String metadata;
}

@collection
class BookmarkIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uniqueKey;
  late int typeIndex;
  late String title;
  late String subtitle;
  late String data;
  late DateTime createdAt;
}

@collection
class ReadingProgressIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String bookId;
  late int surahNumber;
  late int ayahNumber;
  late int page;
  late int juz;
  late DateTime updatedAt;
}

@collection
class KhatmahIsar {
  Id id = 1;
  late int currentPage;
  late int currentSurah;
  late int currentAyah;
  late int totalAyahsRead;
  late DateTime startDate;
  late DateTime lastReadDate;
  late String name;
  late String readingStreakJson;
}

@collection
class TasbeehIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uniqueKey;
  late String name;
  late String nameArabic;
  late int count;
  late int target;
  late DateTime lastUsed;
}

@collection
class AdhkarStateIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uniqueKey;
  late String categoryId;
  late String dhikrId;
  late int currentCount;
  late bool isFavorite;
}

@collection
class PrayerTimesCacheIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String dateLocationKey;
  late String fullJson;
  late DateTime fetchedAt;
}

@collection
class CacheEntryIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String cacheKey;
  late String data;
  late DateTime expiresAt;
  late String category;
}

@collection
class AudioStateIsar {
  Id id = 1;
  late int currentSurahNumber;
  late String reciterId;
  late String reciterName;
  late String moshafId;
  late String server;
  late int positionMs;
  late double speed;
  late String queueJson;
  late DateTime updatedAt;
}

@collection
class RecentlyPlayedIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String reciterId;
  late String data;
  late DateTime lastPlayed;
}

@collection
class TasbihStatsIsar {
  Id id = 1;
  late int todayCount;
  late int totalCount;
  late String date;
  late String weeklyCountsJson;
  late String monthlyCountsJson;
  late int dailyGoal;
}

@collection
class TasbihHistoryIsar {
  Id id = Isar.autoIncrement;
  late String sessionId;
  late String type;
  late String label;
  late int count;
  late DateTime startedAt;
  late int durationSeconds;
}

@collection
class CustomTasbihIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uniqueKey;
  late String name;
  late String nameArabic;
  late int target;
  late bool isFavorite;
  late DateTime createdAt;
}

@collection
class DailyContentIsar {
  Id id = 1;
  late int lastVerseIndex;
  late int lastHadithIndex;
  late String lastVerseDate;
  late String lastHadithDate;
}

@collection
class SearchHistoryIsar {
  Id id = Isar.autoIncrement;
  late String query;
  late DateTime searchedAt;
  late int resultCount;
}

@collection
class MemorialIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String memorialId;
  late String deceasedName;
  String? deceasedNameArabic;
  late int dateOfDeathMs;
  String? description;
  late int prayerCount;
  late int duaCount;
  late int khatmahCount;
  late int tasbeehCount;
  late int createdAtMs;
  late int updatedAtMs;
  String? userId;
  late bool isPublic;
  late int typeIndex;
  int? surahNumber;
  String? duaText;
  String? photoUrl;
  late String searchName;
  String? searchNameArabic;
}

@collection
class RewardIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String rewardId;
  @Index()
  late String memorialId;
  String? userId;
  late int typeIndex;
  late int count;
  late int createdAtMs;
  late int points;
  String? note;
}

@collection
class QuranSvgPageIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late int pageNumber;
  late String svgContent;
  late DateTime cachedAt;
}

@collection
class DownloadStateIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String key;
  late String value;
}
