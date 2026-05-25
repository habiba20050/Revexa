import 'package:revexa/core/error/failures.dart';

/// A functional Result type: either [Success] or [Failure].
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get data => isSuccess ? (this as Success<T>).value : null;
  Failure? get failure => isFailure ? (this as ResultFailure<T>).failure : null;
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class ResultFailure<T> extends Result<T> {
  @override
  final Failure failure;
  const ResultFailure(this.failure);
}
