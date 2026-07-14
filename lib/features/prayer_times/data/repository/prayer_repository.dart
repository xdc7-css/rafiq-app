import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/location_service.dart';
import '../models/prayer_models.dart';

class PrayerRepository {
  PrayerTimes? _prayerTimes;
  Coordinates? _coordinates;

  Future<List<PrayerTime>> getTodayPrayerTimes() async {
    final position = await LocationService.getCurrentLocation();
    if (position == null) return [];

    _coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethodParameters.muslimWorldLeague();
    params.madhab = Madhab.shafi;

    _prayerTimes = PrayerTimes(
      coordinates: _coordinates!,
      date: DateTime.now(),
      calculationParameters: params,
      precision: true,
    );

    if (_prayerTimes == null) return [];

    final now = DateTime.now();
    final prayers = [
      _buildPrayer('Fajr', _prayerTimes!.fajr, 'dawn', now),
      _buildPrayer('Sunrise', _prayerTimes!.sunrise, 'sunrise', now),
      _buildPrayer('Dhuhr', _prayerTimes!.dhuhr, 'sun', now),
      _buildPrayer('Asr', _prayerTimes!.asr, 'afternoon', now),
      _buildPrayer('Maghrib', _prayerTimes!.maghrib, 'sunset', now),
      _buildPrayer('Isha', _prayerTimes!.isha, 'moon', now),
    ];

    for (int i = 0; i < prayers.length; i++) {
      if (!prayers[i].hasPassed) {
        if (i > 0) {
          prayers[i - 1] = prayers[i - 1].copyWith(isCurrent: true);
        }
        prayers[i] = prayers[i].copyWith(isNext: true);
        break;
      }
    }

    return prayers;
  }

  PrayerTime _buildPrayer(String name, DateTime time, String icon, DateTime now) {
    const arabicNames = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };
    return PrayerTime(
      name: name,
      arabicName: arabicNames[name] ?? name,
      time: time,
      icon: icon,
    );
  }

  PrayerTime? getNextPrayer(List<PrayerTime> prayers) {
    for (final prayer in prayers) {
      if (!prayer.hasPassed) return prayer;
    }
    return prayers.first;
  }

  String? getNextPrayerName() {
    if (_prayerTimes == null) return null;
    final now = DateTime.now();
    final times = [
      {'name': 'الفجر', 'time': _prayerTimes!.fajr},
      {'name': 'الشروق', 'time': _prayerTimes!.sunrise},
      {'name': 'الظهر', 'time': _prayerTimes!.dhuhr},
      {'name': 'العصر', 'time': _prayerTimes!.asr},
      {'name': 'المغرب', 'time': _prayerTimes!.maghrib},
      {'name': 'العشاء', 'time': _prayerTimes!.isha},
    ];
    for (final prayer in times) {
      if ((prayer['time'] as DateTime).isAfter(now)) {
        return prayer['name'] as String;
      }
    }
    return 'الفجر';
  }

  Duration? getTimeUntilNext() {
    if (_prayerTimes == null) return null;
    final now = DateTime.now();
    final times = [
      _prayerTimes!.fajr,
      _prayerTimes!.sunrise,
      _prayerTimes!.dhuhr,
      _prayerTimes!.asr,
      _prayerTimes!.maghrib,
      _prayerTimes!.isha,
    ];
    for (final time in times) {
      if (time.isAfter(now)) return time.difference(now);
    }
    final tomorrow = _prayerTimes!.fajr.add(const Duration(days: 1));
    return tomorrow.difference(now);
  }
}

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) => PrayerRepository());
