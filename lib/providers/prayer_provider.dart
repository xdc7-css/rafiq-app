import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan_dart/adhan_dart.dart';
import '../services/prayer_service.dart';
import '../services/location_service.dart';

class PrayerTimesNotifierState {
  final PrayerTimes? prayerTimes;
  final String? nextPrayer;
  final Duration? timeUntilNext;
  final List<Map<String, dynamic>> allPrayerTimes;
  final bool isLoading;
  final String? error;
  final String cityName;
  final double? latitude;
  final double? longitude;

  PrayerTimesNotifierState({
    this.prayerTimes,
    this.nextPrayer,
    this.timeUntilNext,
    this.allPrayerTimes = const [],
    this.isLoading = false,
    this.error,
    this.cityName = 'موقع غير معروف',
    this.latitude,
    this.longitude,
  });

  PrayerTimesNotifierState copyWith({
    PrayerTimes? prayerTimes,
    String? nextPrayer,
    Duration? timeUntilNext,
    List<Map<String, dynamic>>? allPrayerTimes,
    bool? isLoading,
    String? error,
    String? cityName,
    double? latitude,
    double? longitude,
  }) {
    return PrayerTimesNotifierState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeUntilNext: timeUntilNext ?? this.timeUntilNext,
      allPrayerTimes: allPrayerTimes ?? this.allPrayerTimes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cityName: cityName ?? this.cityName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesNotifierState> {
  bool _disposed = false;
  bool _initialized = false;

  PrayerTimesNotifier() : super(PrayerTimesNotifierState());

  /// Call once after first watch to start heavy initialization.
  Future<void> initialize() async {
    if (_initialized || _disposed) return;
    _initialized = true;
    await loadPrayerTimes();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadPrayerTimes() async {
    if (_disposed) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final position = await LocationService.getCurrentLocation();
      if (_disposed) return;
      if (position == null) {
        throw Exception('تعذر الحصول على الموقع الحالي. يرجى تفعيل تحديد الموقع.');
      }
      
      final times = await PrayerService.getPrayerTimes();
      if (_disposed) return;
      final nextPrayer = PrayerService.getNextPrayer();
      final timeUntilNext = PrayerService.getTimeUntilNextPrayer();
      final allTimes = PrayerService.getAllPrayerTimes();
      
      if (allTimes.isEmpty) {
        throw Exception('فشل في حساب مواقيت الصلاة للموقع المحدد.');
      }

      final cityName = await LocationService.getCityName(
        position.latitude,
        position.longitude,
      );

      if (_disposed) return;
      state = state.copyWith(
        prayerTimes: times,
        nextPrayer: nextPrayer,
        timeUntilNext: timeUntilNext,
        allPrayerTimes: allTimes,
        isLoading: false,
        cityName: cityName,
        latitude: position.latitude,
        longitude: position.longitude,
        error: null,
      );
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  void refresh() {
    loadPrayerTimes();
  }
}

final prayerTimesNotifierProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesNotifierState>((ref) {
  final notifier = PrayerTimesNotifier();
  Future.microtask(() => notifier.initialize());
  return notifier;
});
