import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/color_utils.dart';
import '../state/screen_providers.dart';
import '../state/theme_provider.dart';
import '../widgets/renderer/sdui_renderer.dart';

class DynamicScreen extends ConsumerWidget {
  final String routeName;

  const DynamicScreen({super.key, required this.routeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncResult = ref.watch(screenConfigProvider(routeName));

    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleCase(routeName)),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: asyncResult.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _ErrorState(
          message: 'Something went wrong loading this screen.',
          onRetry: () => ref.invalidate(screenConfigProvider(routeName)),
        ),
        data: (result) => result.when(
          success: (screen) => RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(screenConfigProvider(routeName)),
            child: Column(
              children: [
                if (screen.generatedAt != null || screen.hasInvalidTimestamp)
                  _TimestampBanner(
                    generatedAt: screen.generatedAt,
                    isInvalid: screen.hasInvalidTimestamp,
                  ),
                Expanded(
                  child: Container(
                    color: ColorUtils.tryParse(screen.backgroundColor),
                    child: SduiRenderer(screen: screen),
                  ),
                ),
              ],
            ),
          ),
          failure: (message, _) => _ErrorState(
            message: message,
            onRetry: () => ref.invalidate(screenConfigProvider(routeName)),
          ),
        ),
      ),
    );
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _TimestampBanner extends StatelessWidget {
  final DateTime? generatedAt;
  final bool isInvalid;
  const _TimestampBanner({required this.generatedAt, required this.isInvalid});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = isInvalid
        ? 'This screen had an invalid timestamp from the server.'
        : 'Last updated ${_format(DateTime.now())}';

    return Container(
      width: double.infinity,
      color: isInvalid ? scheme.errorContainer : scheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(
            isInvalid ? Icons.warning_amber_rounded : Icons.schedule,
            size: 14,
            color:
                isInvalid ? scheme.onErrorContainer : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color:
                  isInvalid ? scheme.onErrorContainer : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _format(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
