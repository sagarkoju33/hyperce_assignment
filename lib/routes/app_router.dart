import 'package:flutter/material.dart';
import '../screens/dynamic_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = (settings.name ?? '/home').replaceFirst('/', '');

    return MaterialPageRoute(
      settings: settings,
      builder: (_) =>
          DynamicScreen(routeName: routeName.isEmpty ? 'home' : routeName),
    );
  }
}
