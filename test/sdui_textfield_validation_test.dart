import 'package:b1/models/widget_config.dart';
import 'package:b1/widgets/components/sdui_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';


/// Pumps a single [SduiTextField] inside a real [Form] + [ProviderScope],
/// mirroring how [SduiRenderer] wraps every screen. Returns the
/// [GlobalKey] so tests can trigger `formState.validate()` the same way
/// the "Save Profile" submit button does via `Form.of(context).validate()`.
Future<GlobalKey<FormState>> _pumpField(
  WidgetTester tester,
  Map<String, dynamic> json,
) async {
  final formKey = GlobalKey<FormState>();
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: SduiTextField(config: WidgetConfig.fromJson(json)),
          ),
        ),
      ),
    ),
  );
  return formKey;
}

void main() {
  group('SduiTextField required + format validation', () {
    testWidgets(
        'a required + email field shows "required" error on submit when empty',
        (tester) async {
      final formKey = await _pumpField(tester, {
        'type': 'textfield',
        'id': 'email',
        'label': 'Email',
        'validator': 'email',
        'required': true,
      });

      final isValid = formKey.currentState!.validate();
      await tester.pump();

      expect(isValid, isFalse);
      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets(
        'a required + email field shows a format error once something invalid is typed',
        (tester) async {
      final formKey = await _pumpField(tester, {
        'type': 'textfield',
        'id': 'email',
        'label': 'Email',
        'validator': 'email',
        'required': true,
      });

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      expect(isValid, isFalse);
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('a required + email field passes once a valid email is typed',
        (tester) async {
      final formKey = await _pumpField(tester, {
        'type': 'textfield',
        'id': 'email',
        'label': 'Email',
        'validator': 'email',
        'required': true,
      });

      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      expect(isValid, isTrue);
      expect(find.text('This field is required'), findsNothing);
      expect(find.text('Enter a valid email address'), findsNothing);
    });

    testWidgets(
        'a required + number field shows "required" when empty and a format error when non-numeric',
        (tester) async {
      final formKey = await _pumpField(tester, {
        'type': 'textfield',
        'id': 'age',
        'label': 'Age',
        'validator': 'number',
        'required': true,
      });

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('This field is required'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'abc');
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Enter a valid number'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '29');
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets(
        'an optional (non-required) field with no validator never blocks submit',
        (tester) async {
      final formKey = await _pumpField(tester, {
        'type': 'textfield',
        'id': 'search',
        'label': 'Search',
        'validator': 'none',
      });

      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
