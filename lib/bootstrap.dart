import 'package:b1/app/app.dart';
import 'package:b1/core/di/injection.dart';
import 'package:flutter/material.dart';

/// Shared startup used by all flavor entrypoints.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  runApp(const App());
}
