/// Compile-time environment via `--dart-define`.
///
/// Examples:
///   flutter run --dart-define=FLAVOR=dev
///   flutter run -t lib/main_prod.dart --dart-define=FLAVOR=prod \
///     --dart-define=API_BASE_URL=https://api.example.com
enum Environment { dev, staging, prod }

abstract final class AppEnvironment {
  static const String _flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const String _apiOverride =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static Environment get current => switch (_flavor) {
        'prod' || 'production' => Environment.prod,
        'staging' || 'stage' => Environment.staging,
        _ => Environment.dev,
      };

  static String get apiBaseUrl {
    if (_apiOverride.isNotEmpty) return _apiOverride;
    return switch (current) {
      Environment.dev => 'https://api.dev.example.com',
      Environment.staging => 'https://api.staging.example.com',
      Environment.prod => 'https://api.example.com',
    };
  }

  static bool get isProduction => current == Environment.prod;
  static bool get isDev => current == Environment.dev;
  static String get flavorName => _flavor;
}
