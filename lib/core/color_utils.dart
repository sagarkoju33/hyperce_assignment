import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color? tryParse(String? hex, {Color? fallback}) {
    if (hex == null || hex.isEmpty) return fallback;
    var value = hex.trim().replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    if (value.length != 8) return fallback;
    final intValue = int.tryParse(value, radix: 16);
    if (intValue == null) return fallback;
    return Color(intValue);
  }

  static Color parse(String? hex, {Color fallback = Colors.transparent}) {
    return tryParse(hex, fallback: fallback) ?? fallback;
  }
}
