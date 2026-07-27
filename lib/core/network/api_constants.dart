abstract final class ApiConstants {
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/me';
}
