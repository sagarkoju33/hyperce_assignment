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
      return SduiErrorWidget(message: 'Failed to render "${config.type}": $e');
    }
  }
}
