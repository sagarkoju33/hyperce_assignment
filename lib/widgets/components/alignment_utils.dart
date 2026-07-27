import 'package:flutter/material.dart';

/// Parses the backend's alignment strings (e.g. "spaceBetween", "center")
/// into Flutter's Main/CrossAxisAlignment enums, defaulting sensibly when
/// the value is missing or unrecognized.
class AlignmentUtils {
  AlignmentUtils._();

  static MainAxisAlignment mainAxis(String? raw) {
    switch (raw) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment crossAxis(String? raw) {
    switch (raw) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.center;
    }
  }
}
