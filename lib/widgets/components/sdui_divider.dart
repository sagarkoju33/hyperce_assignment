import 'package:flutter/material.dart';
import '../../models/widget_config.dart';

class SduiDivider extends StatelessWidget {
  final WidgetConfig config;
  const SduiDivider({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Divider(height: config.height ?? 16);
  }
}
