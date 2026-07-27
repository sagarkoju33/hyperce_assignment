import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/result.dart';
import '../models/screen_config.dart';
import '../network/api_client.dart';
import '../network/mock_api_client.dart';
import '../repositories/screen_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => MockApiClient());

final screenRepositoryProvider = Provider<ScreenRepository>(
  (ref) => ScreenRepositoryImpl(ref.watch(apiClientProvider)),
);

final screenConfigProvider = FutureProvider.autoDispose
    .family<Result<ScreenConfig>, String>((ref, routeName) async {
      final repo = ref.watch(screenRepositoryProvider);
      return repo.fetchScreen(routeName);
    });

class FormStateNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => {};

  void update(String fieldId, String value) {
    state = {...state, fieldId: value};
  }

  void reset() => state = {};
}

final formStateProvider =
    NotifierProvider<FormStateNotifier, Map<String, String>>(
      FormStateNotifier.new,
    );
