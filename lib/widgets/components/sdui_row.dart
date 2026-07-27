import 'package:flutter/material.dart';
import '../../models/widget_config.dart';
import '../renderer/widget_factory.dart';
import 'alignment_utils.dart';

class SduiRow extends StatelessWidget {
  final WidgetConfig config;
  const SduiRow({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: AlignmentUtils.mainAxis(config.mainAxisAlignment),
      crossAxisAlignment: AlignmentUtils.crossAxis(config.crossAxisAlignment),
      children: config.children.map(WidgetFactory.build).toList(),
    );
  }
}
