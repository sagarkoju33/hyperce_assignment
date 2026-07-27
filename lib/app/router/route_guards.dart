import 'package:flutter/foundation.dart';
import 'package:b1/core/di/injection.dart';

import 'package:b1/core/session/session_service.dart';

/// Auth gate backed by [SessionService] (secure token store).
abstract final class RouteGuards {
  static Future<bool> get isAuthenticated async {
    try {
      return await getIt<SessionService>().hasSession;
    } catch (_) {
      return false;
    }
  }

  static bool isPublicLocation(String location) {
    const publicPrefixes = <String>{
      '/auth',
      '/splash',
      '/onboarding',
    };
    return publicPrefixes.any(
      (p) => location == p || location.startsWith('$p/'),
    );
  }

  static Future<void> clearSession() async {
    try {
      await getIt<SessionService>().clear();
    } catch (_) {/* DI not ready */}
  }

  static void debugAuth(bool value) {
    if (kDebugMode) {
      // hook for tests
    }
  }
}

// Tip: add an `auth` feature to enable login redirects.

