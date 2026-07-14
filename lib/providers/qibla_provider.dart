import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/qibla/models/qibla_models.dart';
import '../features/qibla/services/qibla_stream_service.dart';

final qiblaServiceProvider = Provider<QiblaStreamService>((ref) {
  return QiblaStreamService();
});

final qiblaProvider = StateNotifierProvider<QiblaNotifier, QiblaData>((ref) {
  return QiblaNotifier(ref.read(qiblaServiceProvider));
});

class QiblaNotifier extends StateNotifier<QiblaData> {
  final QiblaStreamService _service;
  StreamSubscription? _qiblahSub;
  bool _disposed = false;

  QiblaNotifier(this._service) : super(const QiblaData());

  Future<void> init() async {
    if (_disposed) return;
    state = const QiblaData(status: QiblaStatus.loading);

    final status = await _service.initialize();
    if (_disposed) return;

    if (status != QiblaStatus.ready) {
      state = state.copyWith(status: status);
      return;
    }

    await _fetchPosition();
    if (_disposed) return;

    _startListening();
  }

  Future<void> _fetchPosition() async {
    final pos = await _service.getCurrentPosition();
    if (_disposed) return;

    if (pos == null) {
      state = state.copyWith(status: QiblaStatus.noGps);
      return;
    }

    String? city;
    String? country;
    try {
      final details = await _service.getLocationDetails(pos.latitude, pos.longitude);
      city = details['city'];
      country = details['country'];
    } catch (_) {}

    final offset = _calculateQiblaOffset(pos.latitude, pos.longitude);
    if (_disposed) return;

    state = state.copyWith(
      latitude: pos.latitude,
      longitude: pos.longitude,
      city: city,
      country: country,
      offset: offset,
    );
  }

  void _startListening() {
    _qiblahSub?.cancel();
    _qiblahSub = _service.qiblahStream.listen(
      (qiblahDir) {
        if (_disposed) return;
        final heading = qiblahDir.direction;
        final qiblah = qiblahDir.qiblah;
        final offset = qiblahDir.offset;

        state = state.copyWith(
          status: QiblaStatus.ready,
          heading: heading,
          qiblah: qiblah,
          offset: offset,
        );
      },
      onError: (e) {
        if (!_disposed) {
          state = state.copyWith(
            status: QiblaStatus.error,
            errorMessage: e.toString(),
          );
        }
      },
    );
  }

  double _calculateQiblaOffset(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;

    final dLon = _toRadians(kaabaLon - lon);
    final lat1 = _toRadians(lat);
    final lat2 = _toRadians(kaabaLat);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    var bearing = math.atan2(y, x);
    bearing = _toDegrees(bearing);
    return (bearing + 360) % 360;
  }

  static double _toRadians(double deg) => deg * math.pi / 180;
  static double _toDegrees(double rad) => rad * 180 / math.pi;

  @override
  void dispose() {
    _disposed = true;
    _qiblahSub?.cancel();
    super.dispose();
  }
}
