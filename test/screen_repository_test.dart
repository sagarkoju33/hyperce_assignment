import 'package:b1/network/api_client.dart';
import 'package:b1/network/api_exception.dart';
import 'package:b1/repositories/screen_repository.dart';
import 'package:flutter_test/flutter_test.dart';


class _FakeApiClient implements ApiClient {
  int callCount = 0;
  bool shouldFail = false;
  String? generatedAt = '2026-07-27T09:00:00Z';

  @override
  Future<Map<String, dynamic>> get(String path) async {
    callCount++;
    if (shouldFail) throw ApiException.notFound(path);
    return {
      'title': 'Fake Screen',
      if (generatedAt != null) 'generatedAt': generatedAt,
      'widgets': [
        {'type': 'text', 'text': 'Hi'}
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    return {'success': true};
  }
}

void main() {
  group('ScreenRepositoryImpl', () {
    test('returns Success and parses the screen config', () async {
      final api = _FakeApiClient();
      final repo = ScreenRepositoryImpl(api);

      final result = await repo.fetchScreen('home');

      expect(result.isSuccess, isTrue);
      result.when(
        success: (screen) {
          expect(screen.title, 'Fake Screen');
          expect(screen.widgets, hasLength(1));
        },
        failure: (_, __) => fail('expected success'),
      );
    });

    test('returns Failure when the API throws', () async {
      final api = _FakeApiClient()..shouldFail = true;
      final repo = ScreenRepositoryImpl(api);

      final result = await repo.fetchScreen('missing');

      expect(result.isFailure, isTrue);
    });

    test('caches screens so a second fetch does not hit the network again', () async {
      final api = _FakeApiClient();
      final repo = ScreenRepositoryImpl(api);

      await repo.fetchScreen('home');
      await repo.fetchScreen('home');

      expect(api.callCount, 1);
    });

    test('parses a valid generatedAt timestamp', () async {
      final api = _FakeApiClient()..generatedAt = '2026-07-27T09:00:00Z';
      final repo = ScreenRepositoryImpl(api);

      final result = await repo.fetchScreen('home');

      result.when(
        success: (screen) {
          expect(screen.generatedAt, isNotNull);
          expect(screen.hasInvalidTimestamp, isFalse);
        },
        failure: (_, __) => fail('expected success'),
      );
    });

    test('treats an invalid generatedAt as null but still succeeds', () async {
      final api = _FakeApiClient()..generatedAt = '27/07/2026';
      final repo = ScreenRepositoryImpl(api);

      final result = await repo.fetchScreen('home');

      expect(result.isSuccess, isTrue);
      result.when(
        success: (screen) {
          expect(screen.generatedAt, isNull);
          expect(screen.hasInvalidTimestamp, isTrue);
        },
        failure: (_, __) => fail('expected success even with a bad timestamp'),
      );
    });

    test('treats a missing generatedAt as absent, not invalid', () async {
      final api = _FakeApiClient()..generatedAt = null;
      final repo = ScreenRepositoryImpl(api);

      final result = await repo.fetchScreen('home');

      result.when(
        success: (screen) {
          expect(screen.generatedAt, isNull);
          expect(screen.hasInvalidTimestamp, isFalse);
        },
        failure: (_, __) => fail('expected success'),
      );
    });
  });
}
