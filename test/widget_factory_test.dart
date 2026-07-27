import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdui_app/models/widget_config.dart';
import 'package:sdui_app/widgets/components/sdui_error_widget.dart';
import 'package:sdui_app/widgets/components/sdui_text.dart';
import 'package:sdui_app/widgets/renderer/widget_factory.dart';

void main() {
  group('WidgetFactory', () {
    test('builds a known widget type', () {
      final config = WidgetConfig.fromJson({'type': 'text', 'text': 'Hello'});
      final widget = WidgetFactory.build(config);
      expect(widget, isA<SduiText>());
    });

    test('gracefully falls back for an unknown widget type', () {
      final config = WidgetConfig.fromJson({'type': 'carousel_3d'});
      final widget = WidgetFactory.build(config);
      expect(widget, isA<SduiErrorWidget>());
    });

    test('gracefully falls back when "type" is missing', () {
      final config = WidgetConfig.fromJson({'text': 'no type here'});
      final widget = WidgetFactory.build(config);
      expect(widget, isA<SduiErrorWidget>());
    });

    testWidgets('renders text widget with correct content', (tester) async {
      final config = WidgetConfig.fromJson({'type': 'text', 'text': 'Welcome Rahul'});
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: WidgetFactory.build(config))),
      );
      expect(find.text('Welcome Rahul'), findsOneWidget);
    });
  });
}
