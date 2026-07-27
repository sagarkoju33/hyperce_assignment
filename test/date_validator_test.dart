import 'package:flutter_test/flutter_test.dart';
import 'package:sdui_app/core/date_validator.dart';

void main() {
  group('DateValidator', () {
    test('accepts a valid UTC ISO 8601 timestamp', () {
      final result = DateValidator.tryParse('2026-07-27T09:00:00Z');
      expect(result, isNotNull);
      expect(result!.year, 2026);
      expect(result.month, 7);
      expect(result.day, 27);
    });

    test('accepts a valid timestamp with a timezone offset', () {
      final result = DateValidator.tryParse('2026-07-27T09:00:00+05:45');
      expect(result, isNotNull);
    });

    test('rejects null', () {
      expect(DateValidator.tryParse(null), isNull);
    });

    test('rejects an empty string', () {
      expect(DateValidator.tryParse(''), isNull);
    });

    test('rejects a non-ISO format like "27/07/2026"', () {
      expect(DateValidator.tryParse('27/07/2026'), isNull);
    });

    test('rejects a date-only string with no time component', () {
      expect(DateValidator.tryParse('2026-07-27'), isNull);
    });

    test('rejects an out-of-range month', () {
      expect(DateValidator.tryParse('2026-13-01T00:00:00Z'), isNull);
    });

    test('rejects an out-of-range day', () {
      expect(DateValidator.tryParse('2026-02-32T00:00:00Z'), isNull);
    });

    test('rejects garbage text', () {
      expect(DateValidator.tryParse('not a date'), isNull);
    });

    test('isValid mirrors tryParse', () {
      expect(DateValidator.isValid('2026-07-27T09:00:00Z'), isTrue);
      expect(DateValidator.isValid('bogus'), isFalse);
    });
  });
}
