class PrayerCalculationMethod {
  final String id;
  final String name;
  final double? fajrAngle;
  final dynamic ishaAngle;
  final double? maghribAngle;
  final String? midnightMode;

  const PrayerCalculationMethod({
    required this.id,
    required this.name,
    this.fajrAngle,
    this.ishaAngle,
    this.maghribAngle,
    this.midnightMode,
  });

  factory PrayerCalculationMethod.fromJson(
      String key, Map<String, dynamic> json) {
    final params = json['params'] as Map<String, dynamic>? ?? {};
    return PrayerCalculationMethod(
      id: key,
      name: json['name'] ?? '',
      fajrAngle: _parseAngle(params['Fajr']),
      ishaAngle: params['Isha'],
      maghribAngle: _parseAngle(params['Maghrib']),
      midnightMode: params['Midnight'],
    );
  }

  static double? _parseAngle(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    return null;
  }
}

class PrayerTime {
  final String name;
  final String arabicName;
  final DateTime time;
  final String icon;
  final bool isCurrent;
  final bool isNext;

  const PrayerTime({
    required this.name,
    required this.arabicName,
    required this.time,
    required this.icon,
    this.isCurrent = false,
    this.isNext = false,
  });

  bool get hasPassed => DateTime.now().isAfter(time);

  Duration get remaining => time.isAfter(DateTime.now())
      ? time.difference(DateTime.now())
      : Duration.zero;

  PrayerTime copyWith({
    String? name,
    String? arabicName,
    DateTime? time,
    String? icon,
    bool? isCurrent,
    bool? isNext,
  }) {
    return PrayerTime(
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      isCurrent: isCurrent ?? this.isCurrent,
      isNext: isNext ?? this.isNext,
    );
  }
}
