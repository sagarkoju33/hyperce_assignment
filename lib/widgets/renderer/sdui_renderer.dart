import 'package:flutter/material.dart';
import '../../models/screen_config.dart';
import 'widget_factory.dart';

class SduiRenderer extends StatelessWidget {
  final ScreenConfig screen;
  final EdgeInsetsGeometry padding;

  const SduiRenderer({
    super.key,
    required this.screen,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: screen.widgets.map(WidgetFactory.build).toList(),
        ),
      ),
    );
  }
}
