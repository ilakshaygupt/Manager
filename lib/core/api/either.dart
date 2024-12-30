
abstract class Either<L, R> {
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  Left(this.value);

  @override
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    return leftFn(value);
  }
}

class Right<L, R> extends Either<L, R> {
  final R value;
  Right(this.value);

  @override
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    return rightFn(value);
  }
}
