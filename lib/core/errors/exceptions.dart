class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException({this.message = 'المورد غير موجود'});

  @override
  String toString() => 'NotFoundException: $message';
}

class JsonParseException implements Exception {
  final String message;
  final String? dataPath;
  JsonParseException({required this.message, this.dataPath});

  @override
  String toString() => 'JsonParseException: $message${dataPath != null ? ' at $dataPath' : ''}';
}
