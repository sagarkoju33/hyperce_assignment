import 'package:logger/logger.dart';

import 'app_exception.dart';
import 'failure.dart';

class ErrorHandler {
  ErrorHandler({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  Failure mapException(Object error) {
    _logger.e('Handled error', error: error);
    if (error is NetworkException) return NetworkFailure(error.message);
    if (error is ServerException) return ServerFailure(error.message);
    if (error is CacheException) return CacheFailure(error.message);
    if (error is AuthException) return AuthFailure(error.message);
    if (error is AppException) return UnexpectedFailure(error.message);
    return UnexpectedFailure(error.toString());
  }

  String userMessage(Failure failure) => failure.message;
}
