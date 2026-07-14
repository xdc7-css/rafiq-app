import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/prayer_times.dart';
import '../services/prayer_time_service.dart';

class PrayerTimeRepository {
  final PrayerTimeService _service;
  PrayerTimes? _lastFetched;
  final List<void Function(PrayerTimes)> _listeners = [];

  PrayerTimeRepository({PrayerTimeService? service})
      : _service = service ?? PrayerTimeService();

  Future<void> init() async {
    await _service.init();
  }

  void addListener(void Function(PrayerTimes) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(PrayerTimes) listener) {
    _listeners.remove(listener);
  }

  void _notify(PrayerTimes times) {
    _lastFetched = times;
    for (final l in _listeners) {
      l(times);
    }
  }

  Future<PrayerTimes?> tryLoadCached() async {
    final lastLoc = await _service.getLastLocation();
    if (lastLoc == null) return null;
    return _service.loadFromCache(
      latitude: lastLoc['latitude']!,
      longitude: lastLoc['longitude']!,
    );
  }

  Future<bool> isSameDayAndLocation() async {
    final position = await _getPosition();
    if (position == null) return false;
    return _service.isSameDayLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<PrayerTimes?> getLocationAndFetch({
    int method = 3,
    bool forceRefresh = false,
  }) async {
    final position = await _getPosition();
    if (position == null) return null;

    final city = await _getCityName(position.latitude, position.longitude);

    if (!forceRefresh) {
      final sameDay = await _service.isSameDayLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (sameDay && _lastFetched != null) {
        return _lastFetched;
      }
    }

    try {
      final times = await _service.fetchToday(
        latitude: position.latitude,
        longitude: position.longitude,
        method: method,
        city: city ?? '',
        country: '',
      );
      if (times != null) {
        _notify(times);
      }
      return times;
    } catch (e) {
      if (_lastFetched != null) return _lastFetched;
      rethrow;
    }
  }

  Future<PrayerTimes?> getCachedOrFetch({
    required double latitude,
    required double longitude,
    int method = 3,
    String city = '',
    String country = '',
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _lastFetched != null) {
      final sameDay = _lastFetched!.date.day == DateTime.now().day;
      if (sameDay) return _lastFetched;
    }

    try {
      final times = await _service.fetchToday(
        latitude: latitude,
        longitude: longitude,
        method: method,
        city: city,
        country: country,
      );
      if (times != null) {
        _notify(times);
      }
      return times;
    } catch (e) {
      if (_lastFetched != null) return _lastFetched;
      rethrow;
    }
  }

  Future<Position?> _getPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<bool> isLocationServiceEnabled() async =>
      Geolocator.isLocationServiceEnabled();

  static Future<LocationPermission> checkPermission() async =>
      Geolocator.checkPermission();

  static Future<LocationPermission> requestPermission() async =>
      Geolocator.requestPermission();

  static Future<void> openLocationSettings() async =>
      Geolocator.openLocationSettings();

  static Future<bool> isPermissionDeniedForever() async {
    final perm = await Geolocator.checkPermission();
    return perm == LocationPermission.deniedForever;
  }

  static Future<String?> _getCityName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[];
        if (p.locality != null && p.locality!.isNotEmpty) {
          parts.add(p.locality!);
        } else if (p.subAdministrativeArea != null &&
            p.subAdministrativeArea!.isNotEmpty) {
          parts.add(p.subAdministrativeArea!);
        }
        if (p.country != null && p.country!.isNotEmpty) {
          parts.add(p.country!);
        }
        return parts.isNotEmpty ? parts.join('، ') : null;
      }
    } catch (_) {}
    return null;
  }
}
