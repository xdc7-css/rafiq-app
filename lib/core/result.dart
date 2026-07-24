import 'errors/failures.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure error) = ResultFailure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final data) => data,
        ResultFailure() => null,
      };

  Failure? get errorOrNull => switch (this) {
        Success() => null,
        ResultFailure<T>(:final error) => error,
      };

  Result<T2> map<T2>(T2 Function(T data) transform) => switch (this) {
        Success<T>(:final data) => Result.success(transform(data)),
        ResultFailure<T>(:final error) => Result.failure(error),
      };

  Result<T> when({
    required Result<T> Function(T data) success,
    required Result<T> Function(Failure error) failure,
  }) =>
      switch (this) {
        Success<T>(:final data) => success(data),
        ResultFailure<T>(:final error) => failure(error),
      };

  T fold(T Function(Failure error) onError, T Function(T data) onSuccess) =>
      switch (this) {
        Success<T>(:final data) => onSuccess(data),
        ResultFailure<T>(:final error) => onError(error),
      };
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

final class ResultFailure<T> extends Result<T> {
  final Failure error;

  const ResultFailure(this.error);
}

sealed class AppFailure extends Failure {
  const AppFailure({required super.message});
}

class MemorialNotFoundFailure extends AppFailure {
  const MemorialNotFoundFailure({super.message = 'السجل غير موجود'});
}

class MemorialPermissionFailure extends AppFailure {
  const MemorialPermissionFailure({super.message = 'ليس لديك صلاحية للوصول'});
}

class MemorialNetworkFailure extends AppFailure {
  const MemorialNetworkFailure({super.message = 'تحقق من اتصال الإنترنت'});
}

class MemorialCacheFailure extends AppFailure {
  const MemorialCacheFailure({super.message = 'خطأ في التخزين المحلي'});
}

class MemorialUnknownFailure extends AppFailure {
  const MemorialUnknownFailure({super.message = 'حدث خطأ غير متوقع'});
}

class AuthFailure extends AppFailure {
  const AuthFailure({super.message = 'فشل في المصادقة'});
}
