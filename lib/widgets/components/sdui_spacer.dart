import 'package:flutter/material.dart';
import '../../models/widget_config.dart';

class SduiSpacer extends StatelessWidget {
  final WidgetConfig config;
  const SduiSpacer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: config.height ?? 8, width: config.width);
  }
}
