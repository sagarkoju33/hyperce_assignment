import 'package:flutter/material.dart';
import '../../models/screen_config.dart';
import 'widget_factory.dart';

/// Renders an entire [ScreenConfig] by delegating each top-level widget to
/// [WidgetFactory]. Kept deliberately thin - all per-widget logic lives in
/// the factory/components so this class never needs to change when new
/// widget types are added.
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
    // Every screen is wrapped in a [Form], even ones with no text fields
    // (validate() on an empty form is a harmless no-op). This is what lets
    // any submit button reach up via `Form.of(context)` and validate every
    // field on the screen in one call - see [ActionHandler].
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
