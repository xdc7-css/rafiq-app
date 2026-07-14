import '../models/greeting.dart';
import '../models/greeting_period.dart';
import '../core/utils/hijri_date.dart';
import '../data/greetings/greeting_data.dart';
import '../data/greetings/default_greetings.dart';

class GreetingService {
  GreetingService._();

  static GreetingResult? _cached;
  static String? _cacheKey;

  static GreetingResult getGreeting({
    DateTime? fajr,
    DateTime? sunrise,
    DateTime? dhuhr,
    DateTime? asr,
    DateTime? maghrib,
    DateTime? isha,
    int? hijriMonth,
    int? hijriDay,
  }) {
    final now = DateTime.now();
    final key = '${now.year}-${now.month}-${now.day}';
    if (_cached != null && _cacheKey == key) return _cached!;

    final period = _determinePeriod(
      now: now,
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      maghrib: maghrib,
      isha: isha,
    );

    final hm = hijriMonth ?? HijriDate.now().month;
    final hd = hijriDay ?? HijriDate.now().day;
    final dayOfYear = _dayOfYear(now);
    final seed = dayOfYear + hd + period.index;

    final occasion = findOccasion(hm, hd);
    if (occasion != null && occasion.greetings.isNotEmpty) {
      final idx = seed % occasion.greetings.length;
      final e = occasion.greetings[idx];
      _cached = GreetingResult(
        title: e.title,
        subtitle: e.subtitle,
        period: period,
        priority: GreetingPriority.occasion,
        occasionName: occasion.name,
        hijriMonth: hm,
      );
      _cacheKey = key;
      return _cached!;
    }

    final monthly = monthlyGreetings[hm];
    if (monthly != null) {
      final monthGreetings = monthly[period];
      if (monthGreetings != null && monthGreetings.isNotEmpty) {
        final idx = seed % monthGreetings.length;
        final e = monthGreetings[idx];
        _cached = GreetingResult(
          title: e.title,
          subtitle: e.subtitle,
          period: period,
          priority: GreetingPriority.monthly,
          hijriMonth: hm,
        );
        _cacheKey = key;
        return _cached!;
      }
    }

    final def = defaultGreetings[period];
    if (def != null && def.isNotEmpty) {
      final idx = seed % def.length;
      final e = def[idx];
      _cached = GreetingResult(
        title: e.title,
        subtitle: e.subtitle,
        period: period,
        priority: GreetingPriority.defaults,
        hijriMonth: hm,
      );
      _cacheKey = key;
      return _cached!;
    }

    _cached = const GreetingResult(
      title: 'اللهم بارك لنا في يومنا',
      subtitle: '',
      period: GreetingPeriod.morning,
      priority: GreetingPriority.defaults,
    );
    _cacheKey = key;
    return _cached!;
  }

  static void clearCache() {
    _cached = null;
    _cacheKey = null;
  }

  static GreetingPeriod _determinePeriod({
    required DateTime now,
    DateTime? fajr,
    DateTime? sunrise,
    DateTime? dhuhr,
    DateTime? asr,
    DateTime? maghrib,
    DateTime? isha,
  }) {
    if (fajr != null && sunrise != null && dhuhr != null &&
        asr != null && maghrib != null && isha != null) {
      return _periodFromPrayerTimes(
        now: now, fajr: fajr, sunrise: sunrise, dhuhr: dhuhr,
        asr: asr, maghrib: maghrib, isha: isha,
      );
    }
    return _periodFromClock(now);
  }

  static GreetingPeriod _periodFromPrayerTimes({
    required DateTime now,
    required DateTime fajr,
    required DateTime sunrise,
    required DateTime dhuhr,
    required DateTime asr,
    required DateTime maghrib,
    required DateTime isha,
  }) {
    if (now.isBefore(sunrise)) return GreetingPeriod.fajr;
    if (now.isBefore(dhuhr)) return GreetingPeriod.morning;
    if (now.isBefore(asr)) return GreetingPeriod.dhuhr;
    if (now.isBefore(maghrib)) return GreetingPeriod.asr;
    if (now.isBefore(isha)) return GreetingPeriod.maghrib;
    final midnight = DateTime(now.year, now.month, now.day + 1);
    if (now.isBefore(midnight)) return GreetingPeriod.evening;
    return GreetingPeriod.midnight;
  }

  static GreetingPeriod _periodFromClock(DateTime now) {
    final h = now.hour;
    if (h >= 3 && h < 6) return GreetingPeriod.fajr;
    if (h >= 6 && h < 12) return GreetingPeriod.morning;
    if (h >= 12 && h < 15) return GreetingPeriod.dhuhr;
    if (h >= 15 && h < 18) return GreetingPeriod.asr;
    if (h >= 18 && h < 20) return GreetingPeriod.maghrib;
    if (h >= 20) return GreetingPeriod.evening;
    return GreetingPeriod.midnight;
  }

  static int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays;
  }
}
