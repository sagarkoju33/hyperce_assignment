import 'failure.dart';

/// Maps domain [Failure]s to UI-friendly copy.
abstract final class ErrorMapper {
  static String toMessage(Failure failure) => switch (failure) {
        NetworkFailure() => 'Please check your connection and try again.',
        ServerFailure() => 'Something went wrong on our side. Try again later.',
        AuthFailure() => 'Please sign in again.',
        CacheFailure() => 'Could not load saved data.',
        UnexpectedFailure() => failure.message,
      };
}
