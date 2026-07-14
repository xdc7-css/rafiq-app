import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  final Duration _timeout;

  ApiClient({http.Client? client, Duration? timeout})
      : _client = client ?? http.Client(),
        _timeout = timeout ?? ApiConstants.timeout;

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: _buildHeaders(headers))
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'لا يوجد اتصال بالإنترنت');
    } on TimeoutException {
      throw NetworkException(message: 'انتهت مهلة الطلب');
    }
  }

  Future<dynamic> post(String url,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await _client
          .post(Uri.parse(url),
              headers: _buildHeaders(headers), body: json.encode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'لا يوجد اتصال بالإنترنت');
    } on TimeoutException {
      throw NetworkException(message: 'انتهت مهلة الطلب');
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final defaultHeaders = <String, String>{
      'Content-Type': ApiConstants.mediaTypeJson,
      'Accept': ApiConstants.mediaTypeJson,
    };
    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    return defaultHeaders;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (_) {
        return response.body;
      }
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'الموارد غير موجودة');
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'خطأ في الخادم', statusCode: response.statusCode);
    } else {
      throw ServerException(
          message: 'خطأ غير متوقع', statusCode: response.statusCode);
    }
  }

  Future<String> loadAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      throw CacheException(message: 'فشل تحميل الملف: $path');
    }
  }

  Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    try {
      final data = await rootBundle.loadString(path);
      return json.decode(data) as Map<String, dynamic>;
    } catch (e) {
      throw JsonParseException(message: 'فشل قراءة ملف JSON: $path');
    }
  }

  Future<List<dynamic>> loadJsonListAsset(String path) async {
    try {
      final data = await rootBundle.loadString(path);
      return json.decode(data) as List<dynamic>;
    } catch (e) {
      throw JsonParseException(message: 'فشل قراءة ملف JSON: $path');
    }
  }

  void dispose() {
    _client.close();
  }
}
