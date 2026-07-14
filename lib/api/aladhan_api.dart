import 'package:dio/dio.dart';

class AladhanApi {
  static const _baseUrl = 'https://api.aladhan.com/v1';
  final Dio _dio;

  AladhanApi({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: {'Accept': 'application/json'},
            ));

  Future<Map<String, dynamic>> fetchTimings({
    required double latitude,
    required double longitude,
    required int method,
    DateTime? date,
  }) async {
    final dateStr = date != null
        ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
        : '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';

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
  }
}
