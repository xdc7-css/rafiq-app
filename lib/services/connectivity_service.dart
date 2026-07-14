import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._();
  factory ConnectivityService() => _instance;
  ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _controller =
      StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get onConnectivityChanged => _controller.stream;
  ConnectivityResult _currentResult = ConnectivityResult.none;
  ConnectivityResult get currentResult => _currentResult;

  bool get isOnline => _currentResult != ConnectivityResult.none;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final result = await _connectivity.checkConnectivity();
      _currentResult = result.isNotEmpty ? result.first : ConnectivityResult.none;
    } catch (e) {
      debugPrint('[ConnectivityService] Initial check failed: $e');
    }

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        _currentResult = result;
        _controller.add(result);
        debugPrint('[ConnectivityService] Changed: $result');
      },
      onError: (e) {
        debugPrint('[ConnectivityService] Stream error: $e');
      },
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
    _initialized = false;
  }
}
