import 'package:dio/dio.dart';
import 'api_exception.dart';

/// Abstraction over "however we talk to the network". The rest of the app
/// only depends on this interface, so swapping the mock implementation for
/// a real backend (or vice versa, e.g. in tests) is a one-line change at
/// the composition root (see `main.dart`).
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path);
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});
}

/// Real implementation backed by Dio, ready to point at an actual REST
/// backend. Not wired up by default (there is no live server for this
/// assignment) but included to show the intended production path -
/// see [MockApiClient] for the implementation actually used at runtime.
class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient({String baseUrl = 'https://example.com/api', Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  @override
  Future<Map<String, dynamic>> get(String path) => _request(
        () => _dio.get(path),
      );

  @override
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) =>
      _request(() => _dio.post(path, data: body));

  Future<Map<String, dynamic>> _request(
    Future<Response> Function() call,
  ) async {
    try {
      final response = await call();
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      throw ApiException.parsing('Response was not a JSON object');
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw ApiException.timeout();
        case DioExceptionType.connectionError:
          throw ApiException.network();
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 404) {
            throw ApiException.notFound(e.requestOptions.path);
          }
          throw ApiException(
            'Server error (${e.response?.statusCode}).',
            statusCode: e.response?.statusCode,
            cause: e,
          );
        default:
          throw ApiException.unknown(e);
      }
    } catch (e) {
      throw ApiException.unknown(e);
    }
  }
}
