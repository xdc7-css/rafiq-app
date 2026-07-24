import 'dart:async';
import 'package:dio/dio.dart';
import '../core/network/api_cache_service.dart';

class AladhanApi {
  static const _baseUrl = 'https://api.aladhan.com/v1';
  static const Duration _timingCacheTtl = Duration(hours: 12);
  final Dio _dio;
  final ApiCacheService _cache;

  AladhanApi({Dio? dio, ApiCacheService? cache})
      : _cache = cache ?? ApiCacheService(),
        _dio = dio ??
            Dio(BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: {'Accept': 'application/json'},
            )) {
    _dio.interceptors.add(_AladhanRetryInterceptor());
  }

  Future<Map<String, dynamic>> fetchTimings({
    required double latitude,
    required double longitude,
    required int method,
    DateTime? date,
  }) async {
    final dateStr = date != null
        ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
        : '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';

    final cacheKey = 'aladhan_timing_${latitude}_${longitude}_${method}_$dateStr';

    return _cache.fetch<Map<String, dynamic>>(
      cacheKey,
      onFetch: () => _fetchTimingsFromApi(latitude, longitude, method, dateStr),
      fromCache: (raw) {
        if (raw is Map<String, dynamic>) return raw;
        return <String, dynamic>{};
      },
      toCache: (data) => data,
      ttl: _timingCacheTtl,
    );
  }

  Future<Map<String, dynamic>> _fetchTimingsFromApi(
    double latitude,
    double longitude,
    int method,
    String dateStr,
  ) async {
    final response = await _dio.get(
      '/timings/$dateStr',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'method': method,
      },
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Aladhan API returned status ${response.statusCode}',
      );
    }

    final body = response.data as Map<String, dynamic>;
    if (body['code'] != 200 || body['status'] != 'OK') {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Aladhan API error: ${body['status']} (code ${body['code']})',
      );
    }

    return body['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchMonthlyTimings({
    required double latitude,
    required double longitude,
    required int method,
    required int year,
    required int month,
  }) async {
    final cacheKey = 'aladhan_monthly_${latitude}_${longitude}_${method}_${year}_$month';

    return _cache.fetch<List<Map<String, dynamic>>>(
      cacheKey,
      onFetch: () async {
        final response = await _dio.get(
          '/calendar/$year/$month',
          queryParameters: {
            'latitude': latitude,
            'longitude': longitude,
            'method': method,
          },
        );

        if (response.statusCode != 200) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Aladhan API returned status ${response.statusCode}',
          );
        }

        final body = response.data as Map<String, dynamic>;
        if (body['code'] != 200 || body['status'] != 'OK') {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Aladhan API error: ${body['status']} (code ${body['code']})',
          );
        }

        return List<Map<String, dynamic>>.from(body['data'] as List);
      },
      fromCache: (raw) {
        if (raw is List) return raw.cast<Map<String, dynamic>>();
        return <Map<String, dynamic>>[];
      },
      toCache: (data) => data,
      ttl: const Duration(hours: 24),
    );
  }
}

class _AladhanRetryInterceptor extends Interceptor {
  final int maxRetries = 3;
  final Duration baseDelay = const Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['_retryCount'] ?? 0;
    if (retryCount < maxRetries && _shouldRetry(err)) {
      err.requestOptions.extra['_retryCount'] = retryCount + 1;

      final retryAfterHeader = err.response?.headers['retry-after'];
      Duration delay;
      if (retryAfterHeader != null && retryAfterHeader.isNotEmpty) {
        final seconds = int.tryParse(retryAfterHeader.first);
        if (seconds != null && seconds > 0 && seconds <= 30) {
          delay = Duration(seconds: seconds);
        } else {
          delay = baseDelay * (1 << retryCount);
        }
      } else {
        delay = baseDelay * (1 << retryCount);
      }

      await Future.delayed(delay);
      try {
        final dio = Dio();
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {}
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionError) return true;
    if (err.type == DioExceptionType.connectionTimeout) return true;
    if (err.type == DioExceptionType.sendTimeout) return true;
    if (err.type == DioExceptionType.receiveTimeout) return true;
    final code = err.response?.statusCode;
    if (code == 429 || code == 500 || code == 502 || code == 503) return true;
    return false;
  }
}
