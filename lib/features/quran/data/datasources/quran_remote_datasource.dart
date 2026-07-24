import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for downloading Quran SVG pages from GitHub.
///
/// Pages are fetched from the xdc7-css/quran-svg repository using
/// raw.githubusercontent.com for direct file access.
class QuranRemoteDataSource {
  QuranRemoteDataSource({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
    ));
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }

  static const String _baseUrl =
      'https://cdn.jsdelivr.net/gh/xdc7-css/quran-svg@main';

  static const int totalPages = 604;

  /// Downloads a single SVG page and returns its bytes.
  ///
  /// Throws [DioException] on network failure after retries are exhausted.
  Future<List<int>> downloadPage(int pageNumber) async {
    final padded = pageNumber.toString().padLeft(3, '0');
    final url = '$_baseUrl/$padded.svg';

    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    }

    throw Exception('Failed to download page $pageNumber: HTTP ${response.statusCode}');
  }

  /// Checks the remote version and compares with local.
  ///
  /// Returns null if version check fails (non-fatal).
  Future<QuranVersionInfo?> fetchVersion() async {
    try {
      final response = await _dio.get<dynamic>(
        '$_baseUrl/quran_version.json',
      );
      if (response.statusCode == 200 && response.data is Map) {
        final map = Map<String, dynamic>.from(response.data as Map);
        return QuranVersionInfo(
          version: map['version'] as String? ?? '1.0.0',
          pages: map['pages'] as int? ?? totalPages,
        );
      }
    } catch (e) {
      debugPrint('[QuranRemoteDataSource] Version fetch failed (non-fatal): $e');
    }
    return null;
  }

  void dispose() {
    _dio.close(force: true);
  }
}

/// Metadata about the remote Quran asset version.
class QuranVersionInfo {
  final String version;
  final int pages;

  const QuranVersionInfo({required this.version, required this.pages});
}

/// Interceptor that retries failed requests with exponential backoff.
///
/// Retries up to 3 times on connection errors, timeouts, and 5xx responses.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this._dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  final Dio _dio;
  final int maxRetries;
  final Duration initialDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['_retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries || !_shouldRetry(err)) {
      return handler.next(err);
    }

    final delay = initialDelay * (1 << retryCount);
    debugPrint(
      '[RetryInterceptor] Retry ${retryCount + 1}/$maxRetries '
      'after ${delay.inMilliseconds}ms — ${err.type}',
    );

    await Future<void>.delayed(delay);

    err.requestOptions.extra['_retryCount'] = retryCount + 1;

    try {
      final response = await _dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        return status != null && status >= 500;
      default:
        return false;
    }
  }
}
