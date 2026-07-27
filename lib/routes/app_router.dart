import 'package:flutter/material.dart';
import '../screens/dynamic_screen.dart';

/// Generates a [DynamicScreen] for any route name the backend sends via a
/// `navigate` action (e.g. `{"type": "navigate", "route": "/profile"}`).
/// No route needs to be registered in advance - this is what makes the
/// navigation graph itself backend-driven rather than hardcoded in Dart.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = (settings.name ?? '/home').replaceFirst('/', '');

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => DynamicScreen(routeName: routeName.isEmpty ? 'home' : routeName),
    );
  }
}
