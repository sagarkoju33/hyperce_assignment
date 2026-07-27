/// A lightweight Result type (similar to `Either`) used to propagate
/// success/failure across the network -> repository -> UI layers without
/// relying on exceptions for control flow. This keeps error handling
/// explicit and forces callers to handle both cases.
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, {Object? cause}) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? cause) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    if (self is Failure<T>) return failure(self.message, self.cause);
    throw StateError('Unreachable');
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final Object? cause;
  const Failure(this.message, {this.cause});
}
