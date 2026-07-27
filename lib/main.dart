import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'routes/app_router.dart';
import 'state/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: SduiApp()));
}

class SduiApp extends ConsumerWidget {
  const SduiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Server-Driven UI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: '/home',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
