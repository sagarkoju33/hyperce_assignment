import '../core/result.dart';
import '../models/screen_config.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';

abstract class ScreenRepository {
  Future<Result<ScreenConfig>> fetchScreen(String routeName);
  Future<Result<Map<String, dynamic>>> performAction(
    String endpoint, {
    String method = 'POST',
    Map<String, dynamic>? body,
  });
}

class ScreenRepositoryImpl implements ScreenRepository {
  final ApiClient _apiClient;

  final Map<String, ScreenConfig> _cache = {};

  ScreenRepositoryImpl(this._apiClient);

  @override
  Future<Result<ScreenConfig>> fetchScreen(String routeName, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.containsKey(routeName)) {
      return Result.success(_cache[routeName] as ScreenConfig);
    }

    try {
      final json = await _apiClient.get('/screen/$routeName');
      final config = ScreenConfig.fromJson(json);
      if (config.hasInvalidTimestamp) {
      
        print('SDUI: screen "$routeName" had an invalid generatedAt timestamp; ignoring it.');
      }
      _cache[routeName] = config;
      return Result.success(config);
    } on ApiException catch (e) {
      return Result.failure(e.message, cause: e.cause);
    } catch (e) {
      return Result.failure('Failed to load screen "$routeName".', cause: e);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> performAction(
    String endpoint, {
    String method = 'POST',
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _apiClient.post(endpoint, body: body);
      return Result.success(response);
    } on ApiException catch (e) {
      return Result.failure(e.message, cause: e.cause);
    } catch (e) {
      return Result.failure('Action "$endpoint" failed.', cause: e);
    }
  }

  void clearCache() => _cache.clear();
}
