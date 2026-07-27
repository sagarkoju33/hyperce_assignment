import 'package:flutter/material.dart';
import '../../core/text_style_utils.dart';
import '../../models/widget_config.dart';

class SduiText extends StatelessWidget {
  final WidgetConfig config;
  const SduiText({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final text = config.text;
    if (text == null) {
      // Missing required property -> render nothing visible rather than
      // throwing, per the "missing widget properties" error-handling rule.
      return const SizedBox.shrink();
    }
    return Text(
      text,
      style: TextStyleUtils.fromJson(
        config.textStyle,
        base: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
