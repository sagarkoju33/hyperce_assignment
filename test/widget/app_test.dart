import 'package:flutter_test/flutter_test.dart';

import 'package:b1/app/app.dart';

void main() {
  testWidgets('App smoke test', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    expect(find.textContaining('Home'), findsWidgets);
  });
}
