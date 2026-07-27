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
