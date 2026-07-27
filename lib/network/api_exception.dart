/// Represents a normalized network/API error so upper layers never need to
/// know whether the failure came from Dio, JSON parsing, or the mock layer.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  const ApiException(this.message, {this.statusCode, this.cause});

  factory ApiException.timeout() =>
      const ApiException('The request timed out. Please try again.');

  factory ApiException.network() => const ApiException(
      'Could not reach the server. Check your internet connection.');

  factory ApiException.notFound(String path) =>
      ApiException('Resource not found: $path', statusCode: 404);

  factory ApiException.parsing(Object cause) => ApiException(
        'Received malformed data from the server.',
        cause: cause,
      );

  factory ApiException.unknown(Object cause) =>
      ApiException('An unexpected error occurred.', cause: cause);

  @override
  String toString() => 'ApiException: $message';
}
