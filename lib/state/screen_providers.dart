import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/result.dart';
import '../models/screen_config.dart';
import '../network/api_client.dart';
import '../network/mock_api_client.dart';
import '../repositories/screen_repository.dart';

/// --- Composition root -------------------------------------------------
///
/// [apiClientProvider] is the ONE place that decides which [ApiClient]
/// implementation the app runs against. Today it's [MockApiClient]
/// (bundled JSON, no live backend needed to run this assignment). Pointing
/// the whole app at a real backend later is a one-line change here:
///
///   final apiClientProvider = Provider<ApiClient>(
///     (ref) => DioApiClient(baseUrl: 'https://your-api.com'),
///   );
final apiClientProvider = Provider<ApiClient>((ref) => MockApiClient());

final screenRepositoryProvider = Provider<ScreenRepository>(
  (ref) => ScreenRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Fetches a single screen's config by route name (e.g. "home", "details").
/// `family` lets every route have its own independent, cached, auto-dispose
/// async state, and `.autoDispose` frees memory for screens that are popped.
final screenConfigProvider =
    FutureProvider.autoDispose.family<Result<ScreenConfig>, String>(
  (ref, routeName) async {
    final repo = ref.watch(screenRepositoryProvider);
    return repo.fetchScreen(routeName);
  },
);

/// Holds live values for any server-rendered text fields, keyed by the
/// field's `id` from the JSON config. Powers the dynamic-forms requirement
/// without every form screen needing bespoke state management code.
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
