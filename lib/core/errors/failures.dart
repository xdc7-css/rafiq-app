abstract class Failure {
  final String message;
  const Failure({required this.message});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'غير موجود'});
}

class JsonParseFailure extends Failure {
  const JsonParseFailure({required super.message});
}
