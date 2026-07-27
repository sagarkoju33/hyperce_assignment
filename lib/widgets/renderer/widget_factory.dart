import 'package:flutter/material.dart';
import '../../models/widget_config.dart';
import '../components/sdui_button.dart';
import '../components/sdui_card.dart';
import '../components/sdui_column.dart';
import '../components/sdui_divider.dart';
import '../components/sdui_error_widget.dart';
import '../components/sdui_image.dart';
import '../components/sdui_row.dart';
import '../components/sdui_spacer.dart';
import '../components/sdui_text.dart';
import '../components/sdui_textfield.dart';

/// The heart of the Server-Driven UI engine. [build] maps a widget `type`
/// string to a concrete Flutter widget.
///
/// ## Adding a new widget type
/// 1. Create a new builder widget under `widgets/components/`.
/// 2. Add one `case` below.
/// That's the entire integration surface - no other file needs to change,
/// which satisfies the "minimal changes to add new widget types"
/// requirement.
///
/// Unknown types never throw: they render an inline [SduiErrorWidget] so a
/// single unrecognized node from the backend can't crash the whole screen.
class WidgetFactory {
  WidgetFactory._();

  static Widget build(WidgetConfig config) {
    try {
      switch (config.type) {
        case 'text':
          return SduiText(config: config);
        case 'button':
          return SduiButton(config: config);
        case 'image':
          return SduiImage(config: config);
        case 'textfield':
          return SduiTextField(config: config);
        case 'column':
          return SduiColumn(config: config);
        case 'row':
          return SduiRow(config: config);
        case 'card':
          return SduiCard(config: config);
        case 'divider':
          return SduiDivider(config: config);
        case 'spacer':
          return SduiSpacer(config: config);
        case '__missing_type__':
          return const SduiErrorWidget(
            message: 'Widget node is missing a "type" property.',
          );
        default:
          return SduiErrorWidget(
            message: 'Unknown widget type: "${config.type}".',
          );
      }
    } catch (e) {
      // A defensive last line - a bug in one widget builder should never
      // take down the entire screen render.
      return SduiErrorWidget(
        message: 'Failed to render "${config.type}": $e',
      );
    }
  }
}
