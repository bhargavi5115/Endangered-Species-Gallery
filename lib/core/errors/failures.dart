abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Network connection unavailable. Operating in offline cached mode.',
    super.code,
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Unable to read or write cached data.',
    super.code,
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}
