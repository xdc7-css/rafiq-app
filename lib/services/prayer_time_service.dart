import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/aladhan_api.dart';
import '../models/prayer_times.dart';

class PrayerTimeService {
  final AladhanApi _api;
  SharedPreferences? _prefs;

  static const _cacheKeyPrefix = 'prayer_times_cache_';
  static const _locationCacheKey = 'prayer_times_last_location';
  static const _lastFetchDateKey = 'prayer_times_last_fetch_date';

  PrayerTimeService({AladhanApi? api}) : _api = api ?? AladhanApi();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<PrayerTimes?> fetchToday({
    required double latitude,
    required double longitude,
    int method = 3,
    String city = '',
    String country = '',
  }) async {
    final now = DateTime.now();
    final cacheKey = _cacheKeyFor(latitude, longitude, now);

    final cached = await _loadFromCache(cacheKey);
    if (cached != null) {
      final cacheDate = DateTime(cached.date.year, cached.date.month, cached.date.day);
      final today = DateTime(now.year, now.month, now.day);
      if (cacheDate == today) {
        return cached;
      }
    }

    final data = await _api.fetchTimings(
      latitude: latitude,
      longitude: longitude,
      method: method,
      date: now,
    );

    final result = _parseResponse(
      data: data,
      city: city.isNotEmpty ? city : _extractCity(data),
      country: country,
      latitude: latitude,
      longitude: longitude,
      method: method,
    );

    await _saveToCache(cacheKey, result);
    await _saveLastLocation(latitude, longitude);

    return result;
  }

  Future<PrayerTimes?> fetchForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    int method = 3,
    String city = '',
    String country = '',
  }) async {
    final data = await _api.fetchTimings(
      latitude: latitude,
      longitude: longitude,
      method: method,
      date: date,
    );

    return _parseResponse(
      data: data,
      city: city.isNotEmpty ? city : _extractCity(data),
      country: country,
      latitude: latitude,
      longitude: longitude,
      method: method,
    );
  }

  static String _extractCity(Map<String, dynamic> data) {
    try {
      final meta = data['meta'] as Map<String, dynamic>?;
      if (meta == null) return '';
      final timezone = meta['timezone'] as String? ?? '';
      final parts = timezone.split('/');
      if (parts.length > 1) return parts.last.replaceAll('_', ' ');
    } catch (_) {}
    return '';
  }

  static PrayerTimes _parseResponse({
    required Map<String, dynamic> data,
    required String city,
    required String country,
    required double latitude,
    required double longitude,
    required int method,
  }) {
    final timingsRaw = data['timings'] as Map<String, dynamic>;
    final dateInfo = data['date'] as Map<String, dynamic>;
    final meta = data['meta'] as Map<String, dynamic>?;
    final gregorian = dateInfo['gregorian'] as Map<String, dynamic>;
    final hijri = dateInfo['hijri'] as Map<String, dynamic>;
    final gregorianDate = gregorian['date'] as String? ?? '';
    final gregorianWeekday = ((gregorian['weekday'] as Map<String, dynamic>?) ?? {})['en'] as String? ?? '';
    final hijriDate = hijri['date'] as String? ?? '';
    final hijriDay = hijri['day'] as String? ?? '';
    final hijriMonth = ((hijri['month'] as Map<String, dynamic>?) ?? {})['en'] as String? ?? '';
    final hijriYear = hijri['year'] as String? ?? '';
    final timezone = meta?['timezone'] as String? ?? 'توقيت عالمي منسق';
    final methodInfo = meta?['method'] as Map<String, dynamic>?;
    final methodId = methodInfo?['id'] as int? ?? method;
    final methodName = methodInfo?['name'] as String? ?? 'غير معروف';

    final timings = <String, DateTime>{};
    for (final entry in timingsRaw.entries) {
      final timeStr = entry.value as String;
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        timings[entry.key] = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hour,
          minute,
        );
      }
    }

    return PrayerTimes(
      city: city,
      country: country,
      date: DateTime.now(),
      hijriDate: hijriDate,
      hijriDay: hijriDay,
      hijriMonth: hijriMonth,
      hijriYear: hijriYear,
      gregorianDate: gregorianDate,
      gregorianWeekday: gregorianWeekday,
      timings: timings,
      calculationMethodId: methodId,
      calculationMethodName: methodName,
      timezone: timezone,
      latitude: latitude,
      longitude: longitude,
      fetchedTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  static PrayerTimeSummary summarize(PrayerTimes times) {
    final now = DateTime.now();
    final ordered = _orderedPrayers(times);
    final currentPrayer = _findCurrentPrayer(ordered, now);
    final nextPrayer = _findNextPrayer(ordered, now);
    Duration? timeUntilNext;
    if (nextPrayer != null) {
      final prayerTime = nextPrayer.time;
      if (prayerTime != null) {
        timeUntilNext = prayerTime.difference(now);
        if (timeUntilNext.isNegative) {
          final tomorrow = prayerTime.add(const Duration(days: 1));
          timeUntilNext = tomorrow.difference(now);
        }
      }
    }

    return PrayerTimeSummary(
      currentPrayer: currentPrayer?.name,
      currentPrayerTime: currentPrayer?.time,
      nextPrayer: nextPrayer?.name,
      nextPrayerTime: nextPrayer?.time,
      timeUntilNext: timeUntilNext,
    );
  }

  static List<_PrayerEntry> _orderedPrayers(PrayerTimes times) {
    return [
      _PrayerEntry('Fajr', times.fajr),
      _PrayerEntry('Sunrise', times.sunrise),
      _PrayerEntry('Dhuhr', times.dhuhr),
      _PrayerEntry('Asr', times.asr),
      _PrayerEntry('Maghrib', times.maghrib),
      _PrayerEntry('Isha', times.isha),
    ];
  }

  static _PrayerEntry? _findCurrentPrayer(List<_PrayerEntry> prayers, DateTime now) {
    for (int i = prayers.length - 1; i >= 0; i--) {
      final p = prayers[i];
      if (p.time != null && p.time!.isBefore(now) || p.time!.isAtSameMomentAs(now)) {
        return p;
      }
    }
    return null;
  }

  static _PrayerEntry? _findNextPrayer(List<_PrayerEntry> prayers, DateTime now) {
    for (final p in prayers) {
      if (p.time != null && p.time!.isAfter(now)) {
        return p;
      }
    }
    return prayers.isNotEmpty ? prayers.first : null;
  }

  String _cacheKeyFor(double lat, double lng, DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$_cacheKeyPrefix${lat.toStringAsFixed(4)}_${lng.toStringAsFixed(4)}_$dateStr';
  }

  Future<PrayerTimes?> _loadFromCache(String key) async {
    if (_prefs == null) return null;
    final jsonStr = _prefs!.getString(key);
    if (jsonStr == null) return null;
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return PrayerTimes.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(String key, PrayerTimes times) async {
    if (_prefs == null) return;
    await _prefs!.setString(key, jsonEncode(times.toJson()));
  }

  Future<void> _saveLastLocation(double lat, double lng) async {
    if (_prefs == null) return;
    await _prefs!.setString(_locationCacheKey, '$lat,$lng');
    final today = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    await _prefs!.setString(_lastFetchDateKey, today);
  }

  Future<PrayerTimes?> loadFromCache({
    required double latitude,
    required double longitude,
  }) async {
    final cacheKey = _cacheKeyFor(latitude, longitude, DateTime.now());
    return _loadFromCache(cacheKey);
  }

  Future<Map<String, double>?> getLastLocation() async {
    if (_prefs == null) return null;
    final lastLocation = _prefs!.getString(_locationCacheKey);
    if (lastLocation == null) return null;
    final parts = lastLocation.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0]);
    final lng = double.tryParse(parts[1]);
    if (lat == null || lng == null) return null;
    return {'latitude': lat, 'longitude': lng};
  }

  Future<bool> isSameDayLocation({
    required double latitude,
    required double longitude,
  }) async {
    if (_prefs == null) return false;
    final lastLocation = _prefs!.getString(_locationCacheKey);
    final lastDate = _prefs!.getString(_lastFetchDateKey);
    if (lastLocation == null || lastDate == null) return false;

    final today = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    if (lastDate != today) return false;

    final parts = lastLocation.split(',');
    if (parts.length != 2) return false;
    final lastLat = double.tryParse(parts[0]);
    final lastLng = double.tryParse(parts[1]);
    if (lastLat == null || lastLng == null) return false;

    const threshold = 0.05;
    return (latitude - lastLat).abs() < threshold &&
        (longitude - lastLng).abs() < threshold;
  }
}

class _PrayerEntry {
  final String name;
  final DateTime? time;
  const _PrayerEntry(this.name, this.time);
}

class PrayerTimeSummary {
  final String? currentPrayer;
  final DateTime? currentPrayerTime;
  final String? nextPrayer;
  final DateTime? nextPrayerTime;
  final Duration? timeUntilNext;

  const PrayerTimeSummary({
    this.currentPrayer,
    this.currentPrayerTime,
    this.nextPrayer,
    this.nextPrayerTime,
    this.timeUntilNext,
  });
}
