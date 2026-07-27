import 'package:logger/logger.dart';

class LoggerService {
  LoggerService(this._logger);

  final Logger _logger;

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, {Object? error, StackTrace? stack}) =>
      _logger.e(message, error: error, stackTrace: stack);
}
