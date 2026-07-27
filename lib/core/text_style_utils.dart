import 'package:flutter/material.dart';
import 'color_utils.dart';

class TextStyleUtils {
  TextStyleUtils._();

  static TextStyle fromJson(Map<String, dynamic>? json, {TextStyle? base}) {
    final style = base ?? const TextStyle();
    if (json == null) return style;

    final fontSize = (json['fontSize'] as num?)?.toDouble();
    final color = ColorUtils.tryParse(json['color'] as String?);
    final weight = _parseWeight(json['fontWeight'] as String?);

    return style.copyWith(fontSize: fontSize, color: color, fontWeight: weight);
  }

  static FontWeight? _parseWeight(String? raw) {
    switch (raw) {
      case 'bold':
        return FontWeight.bold;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'normal':
        return FontWeight.normal;
      default:
        return null;
    }
  }
}
