class PrayerTimes {
  final String city;
  final String country;
  final DateTime date;
  final String hijriDate;
  final String hijriDay;
  final String hijriMonth;
  final String hijriYear;
  final String gregorianDate;
  final String gregorianWeekday;
  final Map<String, DateTime> timings;
  final int calculationMethodId;
  final String calculationMethodName;
  final String timezone;
  final double latitude;
  final double longitude;
  final int fetchedTimestamp;

  const PrayerTimes({
    required this.city,
    required this.country,
    required this.date,
    required this.hijriDate,
    this.hijriDay = '',
    this.hijriMonth = '',
    this.hijriYear = '',
    this.gregorianDate = '',
    this.gregorianWeekday = '',
    required this.timings,
    this.calculationMethodId = 3,
    this.calculationMethodName = 'رابطة العالم الإسلامي',
    this.timezone = 'توقيت عالمي منسق',
    required this.latitude,
    required this.longitude,
    required this.fetchedTimestamp,
  });

  DateTime? get fajr => timings['Fajr'];
  DateTime? get sunrise => timings['Sunrise'];
  DateTime? get dhuhr => timings['Dhuhr'];
  DateTime? get asr => timings['Asr'];
  DateTime? get maghrib => timings['Maghrib'];
  DateTime? get isha => timings['Isha'];
  DateTime? get imsak => timings['Imsak'];
  DateTime? get midnight => timings['Midnight'];

  bool get isExpired =>
      DateTime.now().millisecondsSinceEpoch - fetchedTimestamp >
      const Duration(hours: 6).inMilliseconds;

  bool get isStale =>
      DateTime.now().millisecondsSinceEpoch - fetchedTimestamp >
      const Duration(hours: 1).inMilliseconds;

  Map<String, dynamic> toJson() => {
        'city': city,
        'country': country,
        'date': date.toIso8601String(),
        'hijriDate': hijriDate,
        'hijriDay': hijriDay,
        'hijriMonth': hijriMonth,
        'hijriYear': hijriYear,
        'gregorianDate': gregorianDate,
        'gregorianWeekday': gregorianWeekday,
        'timings': timings.map((k, v) => MapEntry(k, v.toIso8601String())),
        'calculationMethodId': calculationMethodId,
        'calculationMethodName': calculationMethodName,
        'timezone': timezone,
        'latitude': latitude,
        'longitude': longitude,
        'fetchedTimestamp': fetchedTimestamp,
      };

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    final timingsRaw = json['timings'] as Map<String, dynamic>;
    final timings = timingsRaw.map(
        (k, v) => MapEntry(k, DateTime.parse(v as String)));
    return PrayerTimes(
      city: json['city'] as String,
      country: json['country'] as String,
      date: DateTime.parse(json['date'] as String),
      hijriDate: json['hijriDate'] as String,
      hijriDay: json['hijriDay'] as String? ?? '',
      hijriMonth: json['hijriMonth'] as String? ?? '',
      hijriYear: json['hijriYear'] as String? ?? '',
      gregorianDate: json['gregorianDate'] as String? ?? '',
      gregorianWeekday: json['gregorianWeekday'] as String? ?? '',
      timings: timings,
      calculationMethodId: json['calculationMethodId'] as int? ?? 3,
      calculationMethodName: json['calculationMethodName'] as String? ?? '',
      timezone: json['timezone'] as String? ?? 'UTC',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fetchedTimestamp: json['fetchedTimestamp'] as int,
    );
  }
}
