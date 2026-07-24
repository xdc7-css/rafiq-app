import 'package:uuid/uuid.dart';

enum MemorialType {
  deathAnniversary,
  death,
  generalPrayer,
  ongoing,
}

class Memorial {
  final String id;
  final String deceasedName;
  final String? deceasedNameArabic;
  final DateTime dateOfDeath;
  final String? description;
  final int prayerCount;
  final int duaCount;
  final int khatmahCount;
  final int tasbeehCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final bool isPublic;
  final MemorialType type;
  final int? surahNumber;
  final String? duaText;
  final String? photoUrl;
  final String searchName;
  final String? searchNameArabic;

  const Memorial({
    required this.id,
    required this.deceasedName,
    this.deceasedNameArabic,
    required this.dateOfDeath,
    this.description,
    this.prayerCount = 0,
    this.duaCount = 0,
    this.khatmahCount = 0,
    this.tasbeehCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.isPublic = true,
    this.type = MemorialType.generalPrayer,
    this.surahNumber,
    this.duaText,
    this.photoUrl,
    required this.searchName,
    this.searchNameArabic,
  });

  factory Memorial.create({
    required String deceasedName,
    String? deceasedNameArabic,
    required DateTime dateOfDeath,
    String? description,
    String? userId,
    bool isPublic = true,
    MemorialType type = MemorialType.generalPrayer,
    int? surahNumber,
    String? duaText,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return Memorial(
      id: const Uuid().v4(),
      deceasedName: deceasedName,
      deceasedNameArabic: deceasedNameArabic,
      dateOfDeath: dateOfDeath,
      description: description,
      createdAt: now,
      updatedAt: now,
      userId: userId,
      isPublic: isPublic,
      type: type,
      surahNumber: surahNumber,
      duaText: duaText,
      photoUrl: photoUrl,
      searchName: normalizeArabic(deceasedName),
      searchNameArabic: deceasedNameArabic != null && deceasedNameArabic.isNotEmpty
          ? normalizeArabic(deceasedNameArabic)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deceasedName': deceasedName,
      'deceasedNameArabic': deceasedNameArabic,
      'dateOfDeath': dateOfDeath.toIso8601String(),
      'description': description,
      'prayerCount': prayerCount,
      'duaCount': duaCount,
      'khatmahCount': khatmahCount,
      'tasbeehCount': tasbeehCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'isPublic': isPublic,
      'type': type.name,
      'surahNumber': surahNumber,
      'duaText': duaText,
      'photoUrl': photoUrl,
      'searchName': searchName,
      'searchNameArabic': searchNameArabic,
    };
  }

  static DateTime _parseDateTime(dynamic val) {
    if (val == null) return DateTime.now();
    if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
    if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
    if (val is DateTime) return val;
    try {
      final dynamic dynamicVal = val;
      if (dynamicVal.toDate != null) {
        return (dynamicVal.toDate() as DateTime);
      }
    } catch (_) {}
    return DateTime.now();
  }

  factory Memorial.fromJson(Map<String, dynamic> json) {
    final name = json['deceasedName'] as String;
    final nameArabic = json['deceasedNameArabic'] as String?;
    return Memorial(
      id: json['id'] as String,
      deceasedName: name,
      deceasedNameArabic: nameArabic,
      dateOfDeath: _parseDateTime(json['dateOfDeath']),
      description: json['description'] as String?,
      prayerCount: (json['prayerCount'] as num?)?.toInt() ?? 0,
      duaCount: (json['duaCount'] as num?)?.toInt() ?? 0,
      khatmahCount: (json['khatmahCount'] as num?)?.toInt() ?? 0,
      tasbeehCount: (json['tasbeehCount'] as num?)?.toInt() ?? 0,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      userId: json['userId'] as String?,
      isPublic: json['isPublic'] as bool? ?? true,
      type: MemorialType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MemorialType.generalPrayer,
      ),
      surahNumber: (json['surahNumber'] as num?)?.toInt(),
      duaText: json['duaText'] as String?,
      photoUrl: json['photoUrl'] as String?,
      searchName: json['searchName'] as String? ?? normalizeArabic(name),
      searchNameArabic: json['searchNameArabic'] as String? ??
          (nameArabic != null ? normalizeArabic(nameArabic) : null),
    );
  }

  Memorial copyWith({
    String? id,
    String? deceasedName,
    String? deceasedNameArabic,
    DateTime? dateOfDeath,
    String? description,
    int? prayerCount,
    int? duaCount,
    int? khatmahCount,
    int? tasbeehCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isPublic,
    MemorialType? type,
    int? surahNumber,
    String? duaText,
    String? photoUrl,
    String? searchName,
    String? searchNameArabic,
  }) {
    final newDeceasedName = deceasedName ?? this.deceasedName;
    final newDeceasedNameArabic = deceasedNameArabic ?? this.deceasedNameArabic;
    return Memorial(
      id: id ?? this.id,
      deceasedName: newDeceasedName,
      deceasedNameArabic: newDeceasedNameArabic,
      dateOfDeath: dateOfDeath ?? this.dateOfDeath,
      description: description ?? this.description,
      prayerCount: prayerCount ?? this.prayerCount,
      duaCount: duaCount ?? this.duaCount,
      khatmahCount: khatmahCount ?? this.khatmahCount,
      tasbeehCount: tasbeehCount ?? this.tasbeehCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isPublic: isPublic ?? this.isPublic,
      type: type ?? this.type,
      surahNumber: surahNumber ?? this.surahNumber,
      duaText: duaText ?? this.duaText,
      photoUrl: photoUrl ?? this.photoUrl,
      searchName: searchName ?? this.searchName,
      searchNameArabic: searchNameArabic ?? this.searchNameArabic,
    );
  }

  String get displayName => deceasedNameArabic ?? deceasedName;

  int get daysSinceDeath => DateTime.now().difference(dateOfDeath).inDays;

  String get timeAgo {
    final diff = DateTime.now().difference(dateOfDeath);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} سنة';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} شهر';
    if (diff.inDays > 0) return '${diff.inDays} يوم';
    if (diff.inHours > 0) return '${diff.inHours} ساعة';
    return '${diff.inMinutes} دقيقة';
  }

  static String normalizeArabic(String input) {
    return input
        .toLowerCase()
        .replaceAll(
          RegExp(
            r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC'
            r'\u06DF-\u06E4\u06E7\u06E8\u06EA-\u06ED]',
          ),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

String normalizeArabic(String input) => Memorial.normalizeArabic(input);
