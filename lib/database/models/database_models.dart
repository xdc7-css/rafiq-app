class SettingsEntry {
  String data;
  DateTime updatedAt;
  SettingsEntry({required this.data, required this.updatedAt});
  Map<String, dynamic> toJson() => {'data': data, 'updatedAt': updatedAt.toIso8601String()};
  factory SettingsEntry.fromJson(Map<String, dynamic> json) => SettingsEntry(
    data: json['data'] as String? ?? '',
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
  );
}

class FavoriteEntry {
  String uniqueKey;
  int typeIndex;
  String textArabic;
  String reference;
  DateTime dateAdded;
  String metadata;
  FavoriteEntry({
    required this.uniqueKey,
    required this.typeIndex,
    this.textArabic = '',
    this.reference = '',
    DateTime? dateAdded,
    this.metadata = '{}',
  }) : dateAdded = dateAdded ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'uniqueKey': uniqueKey, 'typeIndex': typeIndex, 'textArabic': textArabic,
    'reference': reference, 'dateAdded': dateAdded.toIso8601String(), 'metadata': metadata,
  };
  factory FavoriteEntry.fromJson(Map<String, dynamic> json) => FavoriteEntry(
    uniqueKey: json['uniqueKey'] as String? ?? '',
    typeIndex: json['typeIndex'] as int? ?? 0,
    textArabic: json['textArabic'] as String? ?? '',
    reference: json['reference'] as String? ?? '',
    dateAdded: DateTime.tryParse(json['dateAdded'] as String? ?? ''),
    metadata: json['metadata'] as String? ?? '{}',
  );
}

class BookmarkEntry {
  String uniqueKey;
  int typeIndex;
  String title;
  String subtitle;
  String data;
  DateTime createdAt;
  BookmarkEntry({
    required this.uniqueKey,
    required this.typeIndex,
    this.title = '',
    this.subtitle = '',
    this.data = '{}',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'uniqueKey': uniqueKey, 'typeIndex': typeIndex, 'title': title,
    'subtitle': subtitle, 'data': data, 'createdAt': createdAt.toIso8601String(),
  };
  factory BookmarkEntry.fromJson(Map<String, dynamic> json) => BookmarkEntry(
    uniqueKey: json['uniqueKey'] as String? ?? '',
    typeIndex: json['typeIndex'] as int? ?? 0,
    title: json['title'] as String? ?? '',
    subtitle: json['subtitle'] as String? ?? '',
    data: json['data'] as String? ?? '{}',
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
  );
}

class ReadingProgressEntry {
  String bookId;
  int surahNumber;
  int ayahNumber;
  int page;
  int juz;
  DateTime updatedAt;
  ReadingProgressEntry({
    this.bookId = 'default',
    this.surahNumber = 1,
    this.ayahNumber = 1,
    this.page = 1,
    this.juz = 1,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'bookId': bookId, 'surahNumber': surahNumber, 'ayahNumber': ayahNumber,
    'page': page, 'juz': juz, 'updatedAt': updatedAt.toIso8601String(),
  };
  factory ReadingProgressEntry.fromJson(Map<String, dynamic> json) => ReadingProgressEntry(
    bookId: json['bookId'] as String? ?? 'default',
    surahNumber: json['surahNumber'] as int? ?? 1,
    ayahNumber: json['ayahNumber'] as int? ?? 1,
    page: json['page'] as int? ?? 1,
    juz: json['juz'] as int? ?? 1,
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
  );
}

class KhatmahEntry {
  int currentPage;
  int currentSurah;
  int currentAyah;
  int totalAyahsRead;
  DateTime startDate;
  DateTime lastReadDate;
  String name;
  String readingStreakJson;
  KhatmahEntry({
    this.currentPage = 0,
    this.currentSurah = 1,
    this.currentAyah = 1,
    this.totalAyahsRead = 0,
    DateTime? startDate,
    DateTime? lastReadDate,
    this.name = 'ختمتي',
    this.readingStreakJson = '[]',
  })  : startDate = startDate ?? DateTime.now(),
        lastReadDate = lastReadDate ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'currentPage': currentPage, 'currentSurah': currentSurah, 'currentAyah': currentAyah,
    'totalAyahsRead': totalAyahsRead, 'startDate': startDate.toIso8601String(),
    'lastReadDate': lastReadDate.toIso8601String(), 'name': name,
    'readingStreakJson': readingStreakJson,
  };
  factory KhatmahEntry.fromJson(Map<String, dynamic> json) => KhatmahEntry(
    currentPage: json['currentPage'] as int? ?? 0,
    currentSurah: json['currentSurah'] as int? ?? 1,
    currentAyah: json['currentAyah'] as int? ?? 1,
    totalAyahsRead: json['totalAyahsRead'] as int? ?? 0,
    startDate: DateTime.tryParse(json['startDate'] as String? ?? ''),
    lastReadDate: DateTime.tryParse(json['lastReadDate'] as String? ?? ''),
    name: json['name'] as String? ?? 'ختمتي',
    readingStreakJson: json['readingStreakJson'] as String? ?? '[]',
  );
}

class TasbeehEntry {
  String uniqueKey;
  String name;
  String nameArabic;
  int count;
  int target;
  DateTime lastUsed;
  TasbeehEntry({
    required this.uniqueKey,
    this.name = '',
    this.nameArabic = '',
    this.count = 0,
    this.target = 33,
    DateTime? lastUsed,
  }) : lastUsed = lastUsed ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'uniqueKey': uniqueKey, 'name': name, 'nameArabic': nameArabic,
    'count': count, 'target': target, 'lastUsed': lastUsed.toIso8601String(),
  };
  factory TasbeehEntry.fromJson(Map<String, dynamic> json) => TasbeehEntry(
    uniqueKey: json['uniqueKey'] as String? ?? '',
    name: json['name'] as String? ?? '',
    nameArabic: json['nameArabic'] as String? ?? '',
    count: json['count'] as int? ?? 0,
    target: json['target'] as int? ?? 33,
    lastUsed: DateTime.tryParse(json['lastUsed'] as String? ?? ''),
  );
}

class AdhkarStateEntry {
  String uniqueKey;
  String categoryId;
  String dhikrId;
  int currentCount;
  bool isFavorite;
  AdhkarStateEntry({
    required this.uniqueKey,
    this.categoryId = '',
    this.dhikrId = '',
    this.currentCount = 0,
    this.isFavorite = false,
  });
  Map<String, dynamic> toJson() => {
    'uniqueKey': uniqueKey, 'categoryId': categoryId, 'dhikrId': dhikrId,
    'currentCount': currentCount, 'isFavorite': isFavorite,
  };
  factory AdhkarStateEntry.fromJson(Map<String, dynamic> json) => AdhkarStateEntry(
    uniqueKey: json['uniqueKey'] as String? ?? '',
    categoryId: json['categoryId'] as String? ?? '',
    dhikrId: json['dhikrId'] as String? ?? '',
    currentCount: json['currentCount'] as int? ?? 0,
    isFavorite: json['isFavorite'] as bool? ?? false,
  );
}

class PrayerTimesCacheEntry {
  String dateLocationKey;
  String fullJson;
  DateTime fetchedAt;
  PrayerTimesCacheEntry({
    required this.dateLocationKey,
    this.fullJson = '',
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'dateLocationKey': dateLocationKey, 'fullJson': fullJson,
    'fetchedAt': fetchedAt.toIso8601String(),
  };
  factory PrayerTimesCacheEntry.fromJson(Map<String, dynamic> json) => PrayerTimesCacheEntry(
    dateLocationKey: json['dateLocationKey'] as String? ?? '',
    fullJson: json['fullJson'] as String? ?? '',
    fetchedAt: DateTime.tryParse(json['fetchedAt'] as String? ?? ''),
  );
}

class CacheEntry {
  String cacheKey;
  String data;
  DateTime expiresAt;
  String category;
  CacheEntry({
    required this.cacheKey,
    this.data = '',
    DateTime? expiresAt,
    this.category = '',
  }) : expiresAt = expiresAt ?? DateTime.now().add(const Duration(hours: 1));
  Map<String, dynamic> toJson() => {
    'cacheKey': cacheKey, 'data': data,
    'expiresAt': expiresAt.toIso8601String(), 'category': category,
  };
  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
    cacheKey: json['cacheKey'] as String? ?? '',
    data: json['data'] as String? ?? '',
    expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? ''),
    category: json['category'] as String? ?? '',
  );
}

class AudioStateEntry {
  int currentSurahNumber;
  String reciterId;
  String reciterName;
  String moshafId;
  String server;
  int positionMs;
  double speed;
  String queueJson;
  DateTime updatedAt;
  AudioStateEntry({
    this.currentSurahNumber = 0,
    this.reciterId = '',
    this.reciterName = '',
    this.moshafId = '',
    this.server = '',
    this.positionMs = 0,
    this.speed = 1.0,
    this.queueJson = '[]',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'currentSurahNumber': currentSurahNumber, 'reciterId': reciterId,
    'reciterName': reciterName, 'moshafId': moshafId, 'server': server,
    'positionMs': positionMs, 'speed': speed, 'queueJson': queueJson,
    'updatedAt': updatedAt.toIso8601String(),
  };
  factory AudioStateEntry.fromJson(Map<String, dynamic> json) => AudioStateEntry(
    currentSurahNumber: json['currentSurahNumber'] as int? ?? 0,
    reciterId: json['reciterId'] as String? ?? '',
    reciterName: json['reciterName'] as String? ?? '',
    moshafId: json['moshafId'] as String? ?? '',
    server: json['server'] as String? ?? '',
    positionMs: json['positionMs'] as int? ?? 0,
    speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
    queueJson: json['queueJson'] as String? ?? '[]',
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
  );
}

class RecentlyPlayedEntry {
  String reciterId;
  String data;
  DateTime lastPlayed;
  RecentlyPlayedEntry({
    required this.reciterId,
    this.data = '{}',
    DateTime? lastPlayed,
  }) : lastPlayed = lastPlayed ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'reciterId': reciterId, 'data': data, 'lastPlayed': lastPlayed.toIso8601String(),
  };
  factory RecentlyPlayedEntry.fromJson(Map<String, dynamic> json) => RecentlyPlayedEntry(
    reciterId: json['reciterId'] as String? ?? '',
    data: json['data'] as String? ?? '{}',
    lastPlayed: DateTime.tryParse(json['lastPlayed'] as String? ?? ''),
  );
}

class TasbihStatsEntry {
  int todayCount;
  int totalCount;
  String date;
  String weeklyCountsJson;
  String monthlyCountsJson;
  int dailyGoal;
  TasbihStatsEntry({
    this.todayCount = 0,
    this.totalCount = 0,
    this.date = '',
    this.weeklyCountsJson = '[]',
    this.monthlyCountsJson = '[]',
    this.dailyGoal = 1000,
  });
  Map<String, dynamic> toJson() => {
    'todayCount': todayCount, 'totalCount': totalCount, 'date': date,
    'weeklyCountsJson': weeklyCountsJson, 'monthlyCountsJson': monthlyCountsJson,
    'dailyGoal': dailyGoal,
  };
  factory TasbihStatsEntry.fromJson(Map<String, dynamic> json) => TasbihStatsEntry(
    todayCount: json['todayCount'] as int? ?? 0,
    totalCount: json['totalCount'] as int? ?? 0,
    date: json['date'] as String? ?? '',
    weeklyCountsJson: json['weeklyCountsJson'] as String? ?? '[]',
    monthlyCountsJson: json['monthlyCountsJson'] as String? ?? '[]',
    dailyGoal: json['dailyGoal'] as int? ?? 1000,
  );
}

class TasbihHistoryEntry {
  String sessionId;
  String type;
  String label;
  int count;
  DateTime startedAt;
  int durationSeconds;
  TasbihHistoryEntry({
    this.sessionId = '',
    this.type = '',
    this.label = '',
    this.count = 0,
    DateTime? startedAt,
    this.durationSeconds = 0,
  }) : startedAt = startedAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'sessionId': sessionId, 'type': type, 'label': label, 'count': count,
    'startedAt': startedAt.toIso8601String(), 'durationSeconds': durationSeconds,
  };
  factory TasbihHistoryEntry.fromJson(Map<String, dynamic> json) => TasbihHistoryEntry(
    sessionId: json['sessionId'] as String? ?? '',
    type: json['type'] as String? ?? '',
    label: json['label'] as String? ?? '',
    count: json['count'] as int? ?? 0,
    startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
    durationSeconds: json['durationSeconds'] as int? ?? 0,
  );
}

class CustomTasbihEntry {
  String uniqueKey;
  String name;
  String nameArabic;
  int target;
  bool isFavorite;
  DateTime createdAt;
  CustomTasbihEntry({
    required this.uniqueKey,
    this.name = '',
    this.nameArabic = '',
    this.target = 33,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'uniqueKey': uniqueKey, 'name': name, 'nameArabic': nameArabic,
    'target': target, 'isFavorite': isFavorite, 'createdAt': createdAt.toIso8601String(),
  };
  factory CustomTasbihEntry.fromJson(Map<String, dynamic> json) => CustomTasbihEntry(
    uniqueKey: json['uniqueKey'] as String? ?? '',
    name: json['name'] as String? ?? '',
    nameArabic: json['nameArabic'] as String? ?? '',
    target: json['target'] as int? ?? 33,
    isFavorite: json['isFavorite'] as bool? ?? false,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
  );
}

class DailyContentEntry {
  int lastVerseIndex;
  int lastHadithIndex;
  String lastVerseDate;
  String lastHadithDate;
  DailyContentEntry({
    this.lastVerseIndex = 0,
    this.lastHadithIndex = 0,
    this.lastVerseDate = '',
    this.lastHadithDate = '',
  });
  Map<String, dynamic> toJson() => {
    'lastVerseIndex': lastVerseIndex, 'lastHadithIndex': lastHadithIndex,
    'lastVerseDate': lastVerseDate, 'lastHadithDate': lastHadithDate,
  };
  factory DailyContentEntry.fromJson(Map<String, dynamic> json) => DailyContentEntry(
    lastVerseIndex: json['lastVerseIndex'] as int? ?? 0,
    lastHadithIndex: json['lastHadithIndex'] as int? ?? 0,
    lastVerseDate: json['lastVerseDate'] as String? ?? '',
    lastHadithDate: json['lastHadithDate'] as String? ?? '',
  );
}

class SearchHistoryEntry {
  String query;
  DateTime searchedAt;
  int resultCount;
  SearchHistoryEntry({
    this.query = '',
    DateTime? searchedAt,
    this.resultCount = 0,
  }) : searchedAt = searchedAt ?? DateTime.now();
  Map<String, dynamic> toJson() => {
    'query': query, 'searchedAt': searchedAt.toIso8601String(), 'resultCount': resultCount,
  };
  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) => SearchHistoryEntry(
    query: json['query'] as String? ?? '',
    searchedAt: DateTime.tryParse(json['searchedAt'] as String? ?? ''),
    resultCount: json['resultCount'] as int? ?? 0,
  );
}

class MemorialEntry {
  String memorialId;
  String deceasedName;
  String deceasedNameArabic;
  int dateOfDeathMs;
  String description;
  int prayerCount;
  int duaCount;
  int khatmahCount;
  int tasbeehCount;
  int createdAtMs;
  int updatedAtMs;
  String userId;
  bool isPublic;
  int typeIndex;
  int surahNumber;
  String duaText;
  String photoUrl;
  String searchName;
  String searchNameArabic;
  MemorialEntry({
    required this.memorialId,
    this.deceasedName = '',
    this.deceasedNameArabic = '',
    this.dateOfDeathMs = 0,
    this.description = '',
    this.prayerCount = 0,
    this.duaCount = 0,
    this.khatmahCount = 0,
    this.tasbeehCount = 0,
    this.createdAtMs = 0,
    this.updatedAtMs = 0,
    this.userId = '',
    this.isPublic = true,
    this.typeIndex = 0,
    this.surahNumber = 0,
    this.duaText = '',
    this.photoUrl = '',
    this.searchName = '',
    this.searchNameArabic = '',
  });
  Map<String, dynamic> toJson() => {
    'memorialId': memorialId, 'deceasedName': deceasedName,
    'deceasedNameArabic': deceasedNameArabic, 'dateOfDeathMs': dateOfDeathMs,
    'description': description, 'prayerCount': prayerCount,
    'duaCount': duaCount, 'khatmahCount': khatmahCount, 'tasbeehCount': tasbeehCount,
    'createdAtMs': createdAtMs, 'updatedAtMs': updatedAtMs,
    'userId': userId, 'isPublic': isPublic, 'typeIndex': typeIndex,
    'surahNumber': surahNumber, 'duaText': duaText, 'photoUrl': photoUrl,
    'searchName': searchName, 'searchNameArabic': searchNameArabic,
  };
  factory MemorialEntry.fromJson(Map<String, dynamic> json) => MemorialEntry(
    memorialId: json['memorialId'] as String? ?? '',
    deceasedName: json['deceasedName'] as String? ?? '',
    deceasedNameArabic: json['deceasedNameArabic'] as String? ?? '',
    dateOfDeathMs: json['dateOfDeathMs'] as int? ?? 0,
    description: json['description'] as String? ?? '',
    prayerCount: json['prayerCount'] as int? ?? 0,
    duaCount: json['duaCount'] as int? ?? 0,
    khatmahCount: json['khatmahCount'] as int? ?? 0,
    tasbeehCount: json['tasbeehCount'] as int? ?? 0,
    createdAtMs: json['createdAtMs'] as int? ?? 0,
    updatedAtMs: json['updatedAtMs'] as int? ?? 0,
    userId: json['userId'] as String? ?? '',
    isPublic: json['isPublic'] as bool? ?? true,
    typeIndex: json['typeIndex'] as int? ?? 0,
    surahNumber: json['surahNumber'] as int? ?? 0,
    duaText: json['duaText'] as String? ?? '',
    photoUrl: json['photoUrl'] as String? ?? '',
    searchName: json['searchName'] as String? ?? '',
    searchNameArabic: json['searchNameArabic'] as String? ?? '',
  );
}

class RewardEntry {
  String rewardId;
  String memorialId;
  String userId;
  int typeIndex;
  int count;
  int createdAtMs;
  int points;
  String note;
  RewardEntry({
    required this.rewardId,
    required this.memorialId,
    this.userId = '',
    this.typeIndex = 0,
    this.count = 1,
    this.createdAtMs = 0,
    this.points = 1,
    this.note = '',
  });
  Map<String, dynamic> toJson() => {
    'rewardId': rewardId, 'memorialId': memorialId, 'userId': userId,
    'typeIndex': typeIndex, 'count': count, 'createdAtMs': createdAtMs,
    'points': points, 'note': note,
  };
  factory RewardEntry.fromJson(Map<String, dynamic> json) => RewardEntry(
    rewardId: json['rewardId'] as String? ?? '',
    memorialId: json['memorialId'] as String? ?? '',
    userId: json['userId'] as String? ?? '',
    typeIndex: json['typeIndex'] as int? ?? 0,
    count: json['count'] as int? ?? 1,
    createdAtMs: json['createdAtMs'] as int? ?? 0,
    points: json['points'] as int? ?? 1,
    note: json['note'] as String? ?? '',
  );
}
