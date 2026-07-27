import 'package:flutter/material.dart';
import '../../core/color_utils.dart';
import '../../models/widget_config.dart';
import '../renderer/widget_factory.dart';

class SduiCard extends StatelessWidget {
  final WidgetConfig config;
  const SduiCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final child = config.child;
    final padding = config.padding ?? 16;
    final color = ColorUtils.tryParse(
      config.backgroundColor,
      fallback: Theme.of(context).cardTheme.color ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
    );

    return Card(
      color: color,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child != null
            ? WidgetFactory.build(child)
            : const SizedBox.shrink(),
      ),
    );
  }
}
