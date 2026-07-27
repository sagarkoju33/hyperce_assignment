import 'package:equatable/equatable.dart';
import '../core/date_validator.dart';
import 'widget_config.dart';

/// Top-level response model for `GET /screen/{name}`. Parsing failures for
/// individual widgets never abort parsing of the whole screen - malformed
/// nodes are still parsed into a [WidgetConfig] and it's the renderer's
/// job (not the model's) to decide how to display "widget I don't
/// understand" gracefully.
class ScreenConfig extends Equatable {
  final String title;
  final String? backgroundColor;
  final List<WidgetConfig> widgets;

  /// When the backend generated this screen config, parsed from the
  /// `generatedAt` field (expected ISO 8601, e.g.
  /// `"2026-07-27T10:15:00Z"`). `null` if the field was missing or was not
  /// a validly formatted date — an invalid timestamp is logged but never
  /// prevents the rest of the screen from rendering.
  final DateTime? generatedAt;

  /// True only when the backend supplied a `generatedAt` value that failed
  /// validation (as opposed to omitting it entirely). Exposed so callers
  /// can optionally surface a "this screen may be out of date" hint.
  final bool hasInvalidTimestamp;

  const ScreenConfig({
    required this.title,
    required this.widgets,
    this.backgroundColor,
    this.generatedAt,
    this.hasInvalidTimestamp = false,
  });

  factory ScreenConfig.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final widgetsRaw = json['widgets'];
    final rawTimestamp = json['generatedAt'] as String?;
    final parsedTimestamp = DateValidator.tryParse(rawTimestamp);

    return ScreenConfig(
      title: title is String && title.isNotEmpty ? title : 'Untitled',
      backgroundColor: json['backgroundColor'] as String?,
      generatedAt: parsedTimestamp,
      hasInvalidTimestamp: rawTimestamp != null && parsedTimestamp == null,
      widgets: widgetsRaw is List
          ? widgetsRaw
              .whereType<Map<String, dynamic>>()
              .map(WidgetConfig.fromJson)
              .toList(growable: false)
          : const [],
    );
  }

  @override
  List<Object?> get props =>
      [title, backgroundColor, widgets, generatedAt, hasInvalidTimestamp];
}
