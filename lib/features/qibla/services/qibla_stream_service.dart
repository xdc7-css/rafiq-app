import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../models/qibla_models.dart';

class QiblaStreamService {
  Future<QiblaStatus> initialize() async {
    if (kIsWeb) {
      return _initializeWeb();
    }

    try {
      final hasSensor = await FlutterQiblah.androidDeviceSensorSupport();
      if (hasSensor != true) return QiblaStatus.noSensor;

      final locationStatus = await FlutterQiblah.checkLocationStatus();
      if (!locationStatus.enabled) return QiblaStatus.noGps;

      switch (locationStatus.status) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return QiblaStatus.ready;
        case LocationPermission.denied:
          final requested = await FlutterQiblah.requestPermissions();
          if (requested == LocationPermission.denied) return QiblaStatus.noPermission;
          if (requested == LocationPermission.deniedForever) return QiblaStatus.permanentlyDenied;
          return QiblaStatus.ready;
        case LocationPermission.deniedForever:
          return QiblaStatus.permanentlyDenied;
        default:
          return QiblaStatus.noPermission;
      }
    } catch (e) {
      return QiblaStatus.error;
    }
  }

  Future<QiblaStatus> _initializeWeb() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return QiblaStatus.noGps;

      final permission = await Geolocator.checkPermission();
      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return QiblaStatus.ready;
        case LocationPermission.denied:
          final requested = await Geolocator.requestPermission();
          if (requested == LocationPermission.denied) return QiblaStatus.noPermission;
          if (requested == LocationPermission.deniedForever) return QiblaStatus.permanentlyDenied;
          return QiblaStatus.ready;
        case LocationPermission.deniedForever:
          return QiblaStatus.permanentlyDenied;
        default:
          return QiblaStatus.noPermission;
      }
    } catch (e) {
      return QiblaStatus.error;
    }
  }

  Stream<QiblahDirection> get qiblahStream {
    if (kIsWeb) return _webQiblahStream();
    return FlutterQiblah.qiblahStream;
  }

  Stream<QiblahDirection> _webQiblahStream() async* {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (_) {}

    if (position == null) return;

    final offset = _qiblaBearing(position.latitude, position.longitude);
    yield QiblahDirection(offset, 0.0, offset);

    await for (final pos in Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    )) {
      final o = _qiblaBearing(pos.latitude, pos.longitude);
      yield QiblahDirection(o, 0.0, o);
    }
  }

  double _qiblaBearing(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;
    final dLon = _toRad(kaabaLon - lon);
    final y = math.sin(dLon) * math.cos(_toRad(kaabaLat));
    final x = math.cos(_toRad(lat)) * math.sin(_toRad(kaabaLat)) -
        math.sin(_toRad(lat)) * math.cos(_toRad(kaabaLat)) * math.cos(dLon);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  static double _toRad(double deg) => deg * math.pi / 180;

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<String?> getCity(double lat, double lon) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) return placemarks.first.locality;
    } catch (_) {}
    return null;
  }

  Future<String?> getCountry(double lat, double lon) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) return placemarks.first.country;
    } catch (_) {}
    return null;
  }

  Future<Map<String, String?>> getLocationDetails(double lat, double lon) async {
    final results = await Future.wait([getCity(lat, lon), getCountry(lat, lon)]);
    return {'city': results[0], 'country': results[1]};
  }

  void dispose() {
    FlutterQiblah().dispose();
  }
}
