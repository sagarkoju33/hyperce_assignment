/// Parses and validates timestamp strings coming from the backend (e.g. a
/// screen config's `generatedAt` field). Backend data is never trusted
/// blindly — an invalid or missing date must never crash parsing of the
/// rest of the screen, so this always returns `null` on bad input instead
/// of throwing.
///
/// Accepts strict ISO 8601 (e.g. `2026-07-27T10:15:00Z` or
/// `2026-07-27T10:15:00+05:45`). Values that parse as a valid [DateTime]
/// but don't round-trip through this format (e.g. "07/27/2026") are
/// rejected, since silently accepting ambiguous formats is worse than
/// treating the field as absent.
class DateValidator {
  DateValidator._();

  static final RegExp _iso8601 = RegExp(
    r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})?$',
  );

  /// Returns a parsed [DateTime] if [raw] is a syntactically valid ISO 8601
  /// timestamp representing a real calendar date/time, otherwise `null`.
  static DateTime? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();

    if (!_iso8601.hasMatch(value)) return null;

    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;

    // `DateTime.tryParse` silently normalizes out-of-range components
    // (e.g. month 13 rolls into the next year) instead of failing, so a
    // typo'd date would otherwise parse "successfully" into the wrong
    // date. Reject anything where the numeric month/day fall outside
    // their valid ranges before trusting the parsed result.
    final month = int.parse(value.substring(5, 7));
    final day = int.parse(value.substring(8, 10));
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;

    return parsed;
  }

  static bool isValid(String? raw) => tryParse(raw) != null;
}
