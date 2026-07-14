import 'package:adhan_dart/adhan_dart.dart';
import 'location_service.dart';

class PrayerService {
  static PrayerTimes? _prayerTimes;

  static PrayerTimes? get prayerTimes => _prayerTimes;

  static Future<PrayerTimes?> getPrayerTimes() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (position == null) return null;


      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethodParameters.muslimWorldLeague();
      params.madhab = Madhab.shafi;

      _prayerTimes = PrayerTimes(
        coordinates: coordinates,
        date: DateTime.now(),
        calculationParameters: params,
        precision: true,
      );

      return _prayerTimes;
    } catch (e) {
      return null;
    }
  }

  static String _getArabicPrayerName(String name) {
    switch (name) {
      case 'Fajr': return 'الفجر';
      case 'Sunrise': return 'الشروق';
      case 'Dhuhr': return 'الظهر';
      case 'Asr': return 'العصر';
      case 'Maghrib': return 'المغرب';
      case 'Isha': return 'العشاء';
      default: return name;
    }
  }

  static String? getNextPrayer() {
    if (_prayerTimes == null) return null;

    final now = DateTime.now();
    final times = [
      {'name': 'Fajr', 'time': _prayerTimes!.fajr},
      {'name': 'Sunrise', 'time': _prayerTimes!.sunrise},
      {'name': 'Dhuhr', 'time': _prayerTimes!.dhuhr},
      {'name': 'Asr', 'time': _prayerTimes!.asr},
      {'name': 'Maghrib', 'time': _prayerTimes!.maghrib},
      {'name': 'Isha', 'time': _prayerTimes!.isha},
    ];

    for (final prayer in times) {
      final prayerTime = prayer['time'] as DateTime;
      if (prayerTime.isAfter(now)) {
        return _getArabicPrayerName(prayer['name'] as String);
      }
    }

    return _getArabicPrayerName('Fajr');
  }

  static Duration? getTimeUntilNextPrayer() {
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
      if (time.isAfter(now)) {
        return time.difference(now);
      }
    }

    final tomorrow = _prayerTimes!.fajr.add(const Duration(days: 1));
    return tomorrow.difference(now);
  }

  static List<Map<String, dynamic>> getAllPrayerTimes() {
    if (_prayerTimes == null) return [];

    return [
      {'name': 'Fajr', 'time': _prayerTimes!.fajr, 'icon': 'dawn'},
      {'name': 'Sunrise', 'time': _prayerTimes!.sunrise, 'icon': 'sunrise'},
      {'name': 'Dhuhr', 'time': _prayerTimes!.dhuhr, 'icon': 'sun'},
      {'name': 'Asr', 'time': _prayerTimes!.asr, 'icon': 'afternoon'},
      {'name': 'Maghrib', 'time': _prayerTimes!.maghrib, 'icon': 'sunset'},
      {'name': 'Isha', 'time': _prayerTimes!.isha, 'icon': 'moon'},
    ];
  }
}
