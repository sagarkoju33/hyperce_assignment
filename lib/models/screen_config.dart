import 'package:equatable/equatable.dart';
import '../core/date_validator.dart';
import 'widget_config.dart';

class ScreenConfig extends Equatable {
  final String title;
  final String? backgroundColor;
  final List<WidgetConfig> widgets;

  final DateTime? generatedAt;
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
  List<Object?> get props => [
    title,
    backgroundColor,
    widgets,
    generatedAt,
    hasInvalidTimestamp,
  ];
}
