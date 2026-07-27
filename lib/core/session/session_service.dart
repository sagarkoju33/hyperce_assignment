import 'package:b1/core/storage/storage_keys.dart';
import 'package:b1/core/storage/secure_storage.dart';
import 'package:b1/core/storage/shared_prefs.dart';

/// Production session boundary — tokens never live in plain UI state.
class SessionService {
  SessionService({
    SecureStorageService? secure,
    SharedPrefsService? prefs,
  }) :
      _secure = secure,
      _prefs = prefs;

  final SecureStorageService? _secure;
  final SharedPrefsService? _prefs;

  Future<String?> get accessToken async {
        final fromSecure = await _secure?.read(StorageKeys.accessToken);
    if (fromSecure != null && fromSecure.isNotEmpty) return fromSecure;

    return _prefs?.getString(StorageKeys.accessToken);
  }

  Future<String?> get refreshToken async {
        final fromSecure = await _secure?.read(StorageKeys.refreshToken);
    if (fromSecure != null && fromSecure.isNotEmpty) return fromSecure;

    return _prefs?.getString(StorageKeys.refreshToken);
  }

  Future<bool> get hasSession async {
    final token = await accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
  }) async {
        await _secure?.write(StorageKeys.accessToken, accessToken);
    if (refreshToken != null) {
      await _secure?.write(StorageKeys.refreshToken, refreshToken);
    }

  }

  Future<void> clear() async {
        await _secure?.delete(StorageKeys.accessToken);
    await _secure?.delete(StorageKeys.refreshToken);

        await _prefs?.remove(StorageKeys.accessToken);
    await _prefs?.remove(StorageKeys.refreshToken);

  }
}
