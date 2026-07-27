import 'package:b1/models/widget_config.dart';
import 'package:b1/widgets/components/sdui_error_widget.dart';
import 'package:b1/widgets/components/sdui_text.dart';
import 'package:b1/widgets/renderer/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
      final config =
          WidgetConfig.fromJson({'type': 'text', 'text': 'Welcome Rahul'});
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: WidgetFactory.build(config))),
      );
      expect(find.text('Welcome Sagar Koju'), findsOneWidget);
    });
  });
}
