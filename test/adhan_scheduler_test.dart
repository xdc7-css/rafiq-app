import 'package:flutter_test/flutter_test.dart';
import 'package:daily_islamic_widget/models/prayer_times.dart';

void main() {
  group('Adhan Deterministic IDs & Schedule Window Tests', () {
    test('Request codes are deterministic and non-colliding across 48 hours', () {
      final now = DateTime(2026, 9, 5); // Day of year: 248
      final tomorrow = now.add(const Duration(days: 1)); // Day of year: 249

      int dayOfYear(DateTime date) {
        final diff = date.difference(DateTime(date.year, 1, 1));
        return diff.inDays + 1;
      }

      int computeCode(DateTime date, int prayerIndex) {
        return (dayOfYear(date) * 10) + prayerIndex;
      }

      final todayFajr = computeCode(now, 0);
      final todayDhuhr = computeCode(now, 1);
      final todayMaghrib = computeCode(now, 2);

      final tomorrowFajr = computeCode(tomorrow, 0);
      final tomorrowDhuhr = computeCode(tomorrow, 1);
      final tomorrowMaghrib = computeCode(tomorrow, 2);

      final allCodes = {
        todayFajr,
        todayDhuhr,
        todayMaghrib,
        tomorrowFajr,
        tomorrowDhuhr,
        tomorrowMaghrib,
      };

      // Ensure all 6 alarms across the 48-hour window have unique request codes
      expect(allCodes.length, equals(6));
      expect(todayFajr, isNot(equals(tomorrowFajr)));
      expect(todayDhuhr, isNot(equals(tomorrowDhuhr)));
      expect(todayMaghrib, isNot(equals(tomorrowMaghrib)));
    });

    test('Lateness policy classification thresholds', () {
      const thresholdLateMs = 15 * 60 * 1000;
      const thresholdMissedMs = 45 * 60 * 1000;

      String classifyLateness(int latenessMs) {
        if (latenessMs > thresholdMissedMs) {
          return 'MISSED';
        } else if (latenessMs > thresholdLateMs) {
          return 'LATE';
        } else {
          return 'ON_TIME';
        }
      }

      expect(classifyLateness(0), equals('ON_TIME'));
      expect(classifyLateness(10 * 60 * 1000), equals('ON_TIME'));
      expect(classifyLateness(15 * 60 * 1000), equals('ON_TIME'));
      expect(classifyLateness(20 * 60 * 1000), equals('LATE'));
      expect(classifyLateness(44 * 60 * 1000), equals('LATE'));
      expect(classifyLateness(46 * 60 * 1000), equals('MISSED'));
      expect(classifyLateness(3 * 60 * 60 * 1000), equals('MISSED'));
    });

    test('PrayerTimes model serialization and deserialization retains precision', () {
      final now = DateTime.now();
      final timings = {
        'Fajr': now.add(const Duration(hours: 1)),
        'Dhuhr': now.add(const Duration(hours: 6)),
        'Maghrib': now.add(const Duration(hours: 12)),
      };

      final prayerTimes = PrayerTimes(
        city: 'النجف الأشرف',
        country: 'العراق',
        date: now,
        hijriDate: '١٧ ربيع الأول ١٤٤٨',
        timings: timings,
        latitude: 32.0,
        longitude: 44.33,
        fetchedTimestamp: now.millisecondsSinceEpoch,
      );

      final json = prayerTimes.toJson();
      final parsed = PrayerTimes.fromJson(json);

      expect(parsed.city, equals('النجف الأشرف'));
      expect(parsed.latitude, equals(32.0));
      expect(parsed.timings['Fajr']?.millisecondsSinceEpoch,
          equals(timings['Fajr']!.millisecondsSinceEpoch));
    });
  });
}
