import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/debug_flags.dart';
import '../errors/exceptions.dart';
import 'api_cache_service.dart';

class ShiaApiClient {
  static const String _baseUrl = 'https://shiaapi.p.rapidapi.com';
  static const String _apiKey = String.fromEnvironment(
    'RAPID_API_KEY',
    defaultValue: '',
  );
  static const String _apiHost = 'shiaapi.p.rapidapi.com';
  static const Duration _cacheTtl = Duration(hours: 6);

  late final Dio _dio;
  final Map<String, List<Map<String, dynamic>>> _memCache = {};
  final ApiCacheService _cache;

  ShiaApiClient({Dio? dio, ApiCacheService? cache})
      : _cache = cache ?? ApiCacheService() {
    _dio = dio ?? _createDio();
  }

  Dio _createDio() {
    final d = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': _apiHost,
      },
    ));

    d.interceptors.add(_RetryInterceptor(maxRetries: 2));
    d.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
      logPrint: (o) => debugPrint('[ShiaAPI] $o'),
    ));

    return d;
  }

  Future<List<Map<String, dynamic>>> getBook(String bookId) async {
    if (DebugFlags.disableNonCriticalStartupApis) {
      debugPrint(
          '[ShiaAPI] Startup non-critical APIs disabled via DebugFlags. Skipping getBook($bookId).');
      return <Map<String, dynamic>>[];
    }

    final memCached = _memCache[bookId];
    if (memCached != null) return memCached;

    try {
      final result = await _cache.fetch<List<Map<String, dynamic>>>(
        'shia_book_$bookId',
        onFetch: () async {
          final response = await _dio.get('/$bookId');
          final data = response.data;
          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            if (data.containsKey('data') && data['data'] is List) {
              return (data['data'] as List).cast<Map<String, dynamic>>();
            } else if (data.containsKey('hadiths') && data['hadiths'] is List) {
              return (data['hadiths'] as List).cast<Map<String, dynamic>>();
            } else {
              return [data];
            }
          } else {
            return <Map<String, dynamic>>[];
          }
        },
        fromCache: (raw) {
          if (raw is List) {
            return raw.cast<Map<String, dynamic>>();
          }
          return <Map<String, dynamic>>[];
        },
        toCache: (data) => data,
        ttl: _cacheTtl,
      );
      _memCache[bookId] = result;
      return result;
    } on DioException catch (e) {
      debugPrint(
          '[RapidAPI Error] DioException in getBook($bookId): status=${e.response?.statusCode}, type=${e.type}, message=${e.message}');
      return <Map<String, dynamic>>[];
    } catch (e) {
      debugPrint('[RapidAPI Error] Unexpected exception in getBook($bookId): $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<Map<String, dynamic>?> getHadith(
      String bookId, int hadithNumber) async {
    if (DebugFlags.disableNonCriticalStartupApis) {
      debugPrint(
          '[ShiaAPI] Startup non-critical APIs disabled via DebugFlags. Skipping getHadith($bookId, $hadithNumber).');
      return null;
    }
    try {
      final all = await getBook(bookId);
      for (final h in all) {
        final num = h['number'] ?? h['hadithNumber'] ?? h['id'];
        if (num == hadithNumber) return h;
      }
      return null;
    } on DioException catch (e) {
      debugPrint(
          '[RapidAPI Error] DioException in getHadith($bookId, $hadithNumber): status=${e.response?.statusCode}, message=${e.message}');
      return null;
    } catch (e) {
      debugPrint(
          '[RapidAPI Error] Unexpected exception in getHadith($bookId, $hadithNumber): $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchHadiths(
      String bookId, String query) async {
    if (DebugFlags.disableNonCriticalStartupApis) {
      debugPrint(
          '[ShiaAPI] Startup non-critical APIs disabled via DebugFlags. Skipping searchHadiths($bookId, $query).');
      return <Map<String, dynamic>>[];
    }
    try {
      final all = await getBook(bookId);
      final q = query.trim().toLowerCase();
      if (q.isEmpty) return all;
      return all.where((h) {
        final text = (h['text'] ?? h['body'] ?? '').toString().toLowerCase();
        final subject =
            (h['subject'] ?? h['topic'] ?? '').toString().toLowerCase();
        return text.contains(q) || subject.contains(q);
      }).toList();
    } on DioException catch (e) {
      debugPrint(
          '[RapidAPI Error] DioException in searchHadiths($bookId, $query): status=${e.response?.statusCode}, message=${e.message}');
      return <Map<String, dynamic>>[];
    } catch (e) {
      debugPrint(
          '[RapidAPI Error] Unexpected exception in searchHadiths($bookId, $query): $e');
      return <Map<String, dynamic>>[];
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'انتهت مهلة الاتصال بالخادم');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'لا يوجد اتصال بالإنترنت');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return ServerException(
              message: 'غير مصرح أو الاشتراك غير مفعّل',
              statusCode: statusCode);
        }
        if (statusCode == 429) {
          return ServerException(
              message: 'طلبات كثيرة جداً، يرجى الانتظار قليلاً',
              statusCode: statusCode);
        }
        return ServerException(
            message: 'خطأ في الخادم', statusCode: statusCode);
      default:
        return NetworkException(message: 'خطأ غير متوقع في الاتصال');
    }
  }
}

class _RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay = const Duration(seconds: 1);

  _RetryInterceptor({this.maxRetries = 2});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['_retryCount'] ?? 0;
    if (retryCount < maxRetries && _shouldRetry(err)) {
      err.requestOptions.extra['_retryCount'] = retryCount + 1;

      Duration delay;
      final retryAfterHeader = err.response?.headers['retry-after'];
      if (retryAfterHeader != null && retryAfterHeader.isNotEmpty) {
        final seconds = int.tryParse(retryAfterHeader.first);
        if (seconds != null && seconds > 0 && seconds <= 60) {
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
    if (code == 401 || code == 403) return false;
    if (code == 429 || code == 500 || code == 502 || code == 503) return true;
    return false;
  }
}
