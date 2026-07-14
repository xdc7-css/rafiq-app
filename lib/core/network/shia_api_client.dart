import 'dart:async';
import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class ShiaApiClient {
  static const String _baseUrl = 'https://shiaapi.p.rapidapi.com';
  static const String _apiKey = String.fromEnvironment(
    'RAPID_API_KEY',
    defaultValue: '',
  );
  static const String _apiHost = 'shiaapi.p.rapidapi.com';

  late final Dio _dio;
  final Map<String, List<Map<String, dynamic>>> _bookCache = {};

  ShiaApiClient({Dio? dio}) {
    _dio = dio ?? _createDio();
  }

  Dio _createDio() {
    final d = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': _apiHost,
      },
    ));

    d.interceptors.add(_RetryInterceptor(maxRetries: 3));
    d.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
      logPrint: (o) => print('[ShiaAPI] $o'),
    ));

    return d;
  }

  Future<List<Map<String, dynamic>>> getBook(String bookId) async {
    final cached = _bookCache[bookId];
    if (cached != null) return cached;
    try {
      final response = await _dio.get('/$bookId');
      final data = response.data;
      List<Map<String, dynamic>> result;
      if (data is List) {
        result = data.cast<Map<String, dynamic>>();
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('data') && data['data'] is List) {
          result = (data['data'] as List).cast<Map<String, dynamic>>();
        } else if (data.containsKey('hadiths') && data['hadiths'] is List) {
          result = (data['hadiths'] as List).cast<Map<String, dynamic>>();
        } else {
          result = [data];
        }
      } else {
        result = [];
      }
      _bookCache[bookId] = result;
      return result;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>?> getHadith(
      String bookId, int hadithNumber) async {
    try {
      final all = await getBook(bookId);
      for (final h in all) {
        final num = h['number'] ?? h['hadithNumber'] ?? h['id'];
        if (num == hadithNumber) return h;
      }
      return null;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> searchHadiths(
      String bookId, String query) async {
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
      throw _handleDioError(e);
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
        if (statusCode == 403) {
          return ServerException(
              message: 'الاشتراك غير مفعّل في هذه الخدمة',
              statusCode: statusCode);
        }
        if (statusCode == 429) {
          return ServerException(
              message: 'طلبات كثيرة جداً، يرجى الانتظار قليلاً',
              statusCode: statusCode);
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
              message: 'خطأ في الخادم', statusCode: statusCode);
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
  final Duration baseDelay = const Duration(seconds: 2);

  _RetryInterceptor({this.maxRetries = 3});

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
    if (code == 429 || code == 500 || code == 502 || code == 503) return true;
    return false;
  }
}
