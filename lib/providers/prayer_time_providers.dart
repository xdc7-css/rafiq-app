import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../api/aladhan_api.dart';
import '../models/prayer_times.dart';
import '../repositories/prayer_time_repository.dart';
import '../services/prayer_time_service.dart';
import '../services/prayer_scheduler.dart';
import '../services/storage_service.dart';
import '../services/time_formatter.dart';
import '../services/home_widget_service.dart';

final aladhanApiProvider = Provider<AladhanApi>((ref) => AladhanApi());

final prayerTimeServiceProvider = Provider<PrayerTimeService>((ref) {
  final api = ref.watch(aladhanApiProvider);
  return PrayerTimeService(api: api);
});

final prayerTimeRepositoryProvider = Provider<PrayerTimeRepository>((ref) {
  final service = ref.watch(prayerTimeServiceProvider);
  return PrayerTimeRepository(service: service);
});

enum PrayerTimesStatus {
  initial,
  loaded,
  loadingFresh,
  error,
  locationDenied,
  locationDisabled,
}

class PrayerTimesState {
  final PrayerTimesStatus status;
  final PrayerTimes? prayerTimes;
  final String? currentPrayer;
  final String? nextPrayer;
  final Duration? timeUntilNext;
  final String? errorMessage;
  final double? latitude;
  final double? longitude;
  final String cityName;
  final int calculationMethod;
  final bool notificationsEnabled;
  final bool hasCachedData;

  const PrayerTimesState({
    this.status = PrayerTimesStatus.initial,
    this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.timeUntilNext,
    this.errorMessage,
    this.latitude,
    this.longitude,
    this.cityName = '',
    this.calculationMethod = 3,
    this.notificationsEnabled = false,
    this.hasCachedData = false,
  });

  PrayerTimesState copyWith({
    PrayerTimesStatus? status,
    PrayerTimes? prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    Duration? timeUntilNext,
    String? errorMessage,
    double? latitude,
    double? longitude,
    String? cityName,
    int? calculationMethod,
    bool? notificationsEnabled,
    bool? hasCachedData,
  }) {
    return PrayerTimesState(
      status: status ?? this.status,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeUntilNext: timeUntilNext ?? this.timeUntilNext,
      errorMessage: errorMessage ?? this.errorMessage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hasCachedData: hasCachedData ?? this.hasCachedData,
    );
  }
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final PrayerTimeRepository _repository;
  Timer? _countdownTimer;
  bool _disposed = false;
  bool _isFetching = false;
  bool _initialized = false;
  int _lastFetchDay = -1;

  PrayerTimesNotifier(this._repository) : super(const PrayerTimesState());

  /// Call once after first watch to start heavy initialization.
  /// This defers GPS, network, and timers away from app startup.
  Future<void> initialize() async {
    if (_initialized || _disposed) return;
    _initialized = true;

    await _repository.init();
    if (_disposed) return;

    final settings = StorageService.getSettings();
    state = state.copyWith(
      calculationMethod: settings.calculationMethod,
      notificationsEnabled: settings.prayerNotifications,
    );
    await _tryLoadCached();
    _scheduleDayChangeCheck();
    _backgroundRefresh();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_disposed) {
        _recalculateNextPrayer();
        _checkDayChange();
      }
    });
  }

  Future<void> _tryLoadCached() async {
    final cached = await _repository.tryLoadCached();
    if (_disposed) return;
    if (cached != null) {
      state = state.copyWith(
        prayerTimes: cached,
        status: PrayerTimesStatus.loaded,
        hasCachedData: true,
        latitude: cached.latitude,
        longitude: cached.longitude,
        cityName: cached.city,
      );
      _recalculateNextPrayer();
    }
  }

  Future<void> _backgroundRefresh() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (_disposed) { _isFetching = false; return; }

      if (!enabled) {
        if (!state.hasCachedData) {
          state = state.copyWith(status: PrayerTimesStatus.locationDisabled);
        }
        _isFetching = false;
        return;
      }

      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          if (!state.hasCachedData) {
            state = state.copyWith(status: PrayerTimesStatus.locationDenied);
          }
          _isFetching = false;
          return;
        }
      }
      if (perm == LocationPermission.deniedForever) {
        if (!state.hasCachedData) {
          state = state.copyWith(status: PrayerTimesStatus.locationDenied);
        }
        _isFetching = false;
        return;
      }

      if (state.hasCachedData) {
        final sameDay = await _repository.isSameDayAndLocation();
        if (sameDay) {
          _isFetching = false;
          return;
        }
      }

      if (!state.hasCachedData) {
        state = state.copyWith(status: PrayerTimesStatus.loadingFresh);
      }

      try {
        final times = await _repository.getLocationAndFetch(
          method: state.calculationMethod,
          forceRefresh: true,
        );

        if (_disposed) { _isFetching = false; return; }

        if (times != null) {
          state = state.copyWith(
            status: PrayerTimesStatus.loaded,
            prayerTimes: times,
            hasCachedData: true,
            latitude: times.latitude,
            longitude: times.longitude,
            cityName: times.city,
          );
          _recalculateNextPrayer();
          _schedulePrayerNotificationsIfEnabled(times);
        }
      } catch (e) {
        if (_disposed) { _isFetching = false; return; }
        if (!state.hasCachedData) {
          state = state.copyWith(
            status: PrayerTimesStatus.error,
            errorMessage: _friendlyError(e),
          );
        } else {
          state = state.copyWith(status: PrayerTimesStatus.loaded);
        }
      }
    } finally {
      _isFetching = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _countdownTimer?.cancel();
    PrayerScheduler.instance.dispose();
    super.dispose();
  }

  Future<void> load({bool forceRefresh = false}) async {
    if (_disposed) return;
    if (_isFetching) return;

    _isFetching = true;

    final enabled = await Geolocator.isLocationServiceEnabled();
    if (_disposed) { _isFetching = false; return; }

    if (!enabled) {
      state = state.copyWith(status: PrayerTimesStatus.locationDisabled);
      _isFetching = false;
      return;
    }

    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.deniedForever) {
      state = state.copyWith(status: PrayerTimesStatus.locationDenied);
      _isFetching = false;
      return;
    }

    if (!state.hasCachedData && !forceRefresh) {
      await _tryLoadCached();
    }

    if (state.hasCachedData && !forceRefresh) {
      final sameDay = await _repository.isSameDayAndLocation();
      if (sameDay) {
        state = state.copyWith(status: PrayerTimesStatus.loaded);
        _isFetching = false;
        return;
      }
    }

    if (!state.hasCachedData) {
      state = state.copyWith(status: PrayerTimesStatus.loadingFresh);
    }

    try {
      final times = await _repository.getLocationAndFetch(
        method: state.calculationMethod,
        forceRefresh: true,
      );

      if (_disposed) { _isFetching = false; return; }

      if (times == null) {
        final permAfter = await Geolocator.checkPermission();
        if (permAfter == LocationPermission.denied ||
            permAfter == LocationPermission.deniedForever) {
          state = state.copyWith(status: PrayerTimesStatus.locationDenied);
        } else {
          state = state.copyWith(status: PrayerTimesStatus.locationDisabled);
        }
        _isFetching = false;
        return;
      }

      state = state.copyWith(
        status: PrayerTimesStatus.loaded,
        prayerTimes: times,
        hasCachedData: true,
        latitude: times.latitude,
        longitude: times.longitude,
        cityName: times.city,
      );
      _lastFetchDay = DateTime.now().day;
      _recalculateNextPrayer();
      _schedulePrayerNotificationsIfEnabled(times);
    } catch (e) {
      if (_disposed) { _isFetching = false; return; }
      if (!state.hasCachedData) {
        state = state.copyWith(
          status: PrayerTimesStatus.error,
          errorMessage: _friendlyError(e),
        );
      } else {
        state = state.copyWith(status: PrayerTimesStatus.loaded);
      }
    } finally {
      _isFetching = false;
    }
  }

  void _recalculateNextPrayer() {
    final times = state.prayerTimes;
    if (times == null) return;

    final summary = PrayerTimeService.summarize(times);
    if (_disposed) return;

    state = state.copyWith(
      currentPrayer: summary.currentPrayer,
      nextPrayer: summary.nextPrayer,
      timeUntilNext: summary.timeUntilNext,
    );

    _syncPrayerWidget(times, summary.nextPrayer, summary.nextPrayerTime);
  }

  void _syncPrayerWidget(PrayerTimes times, String? nextPrayer, DateTime? nextPrayerTime) {
    const nameMap = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    final settings = StorageService.getSettings();

    final timeStr = nextPrayerTime != null
        ? TimeFormatter.formatTime(nextPrayerTime)
        : '--:--';

    HomeWidgetService.updatePrayerWidget(
      nextPrayerName: nameMap[nextPrayer] ?? 'الصلاة',
      nextPrayerTime: timeStr,
      fajrTime: TimeFormatter.formatTime(times.fajr),
      dhuhrTime: TimeFormatter.formatTime(times.dhuhr),
      asrTime: TimeFormatter.formatTime(times.asr),
      maghribTime: TimeFormatter.formatTime(times.maghrib),
      ishaTime: TimeFormatter.formatTime(times.isha),
      sunriseTime: TimeFormatter.formatTime(times.sunrise),
      bgColor: settings.widgetBgColor,
      textColor: settings.widgetTextColor,
      fontSize: settings.widgetFontSize,
    );

    HomeWidgetService.updateDashboardDate(
      hijriDate: '${times.hijriDay} ${times.hijriMonth} ${times.hijriYear}',
      gregorianDate: times.gregorianDate,
      dayOfWeek: times.gregorianWeekday,
    );
  }

  void _checkDayChange() {
    final now = DateTime.now();
    if (now.day != _lastFetchDay) {
      _lastFetchDay = now.day;
      _backgroundRefresh();
    }
  }

  void _scheduleDayChangeCheck() {
    final now = DateTime.now();
    _lastFetchDay = now.day;
  }

  void _schedulePrayerNotificationsIfEnabled(PrayerTimes times) {
    final settings = StorageService.getSettings();
    if (settings.prayerNotifications || settings.adhanEnabled) {
      PrayerScheduler.instance.scheduleForToday(times);
    } else {
      PrayerScheduler.instance.cancelAll();
    }
  }

  static String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('HandshakeException')) {
      return 'لا يوجد اتصال بالإنترنت';
    }
    if (msg.contains('DioException')) {
      if (msg.contains('timeout')) return 'انتهت مهلة الاتصال';
      return 'خطأ في الاتصال بالخادم';
    }
    if (msg.contains('LocationService') || msg.contains('disabled')) {
      return 'خدمة الموقع غير مفعلة';
    }
    return 'حدث خطأ أثناء تحميل أوقات الصلاة';
  }

  Future<void> refresh() => load(forceRefresh: true);

  void setCalculationMethod(int method) {
    state = state.copyWith(calculationMethod: method);
    load(forceRefresh: true);
  }

  void setNotificationsEnabled(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }
}

final prayerTimesProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  final repo = ref.watch(prayerTimeRepositoryProvider);
  final notifier = PrayerTimesNotifier(repo);
  // Defer heavy initialization to next microtask so first frame renders fast.
  Future.microtask(() => notifier.initialize());
  return notifier;
});
