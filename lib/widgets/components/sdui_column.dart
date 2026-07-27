import 'package:flutter/material.dart';
import '../../models/widget_config.dart';
import '../renderer/widget_factory.dart';
import 'alignment_utils.dart';

class SduiColumn extends StatelessWidget {
  final WidgetConfig config;
  const SduiColumn({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: AlignmentUtils.mainAxis(config.mainAxisAlignment),
      crossAxisAlignment: AlignmentUtils.crossAxis(config.crossAxisAlignment),
      children: config.children.map(WidgetFactory.build).toList(),
    );
  }
}
