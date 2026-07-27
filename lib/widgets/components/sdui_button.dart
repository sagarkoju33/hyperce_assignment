import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_config.dart';
import '../renderer/action_handler.dart';

class SduiButton extends ConsumerWidget {
  final WidgetConfig config;
  const SduiButton({super.key, required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = config.text ?? '';
    final onPressed = () => ActionHandler.execute(context, ref, config.action);

    switch (config.style) {
      case 'secondary':
        return OutlinedButton(
          onPressed: onPressed,
          child: Text(label),
        );
      case 'text':
        return TextButton(
          onPressed: onPressed,
          child: Text(label),
        );
      case 'primary':
      default:
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onPressed,
            child: Text(label),
          ),
        );
    }
  }
}
